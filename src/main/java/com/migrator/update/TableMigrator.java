package com.migrator.update;

import java.sql.*;
import java.util.*;
import javax.swing.JTextArea;

public class TableMigrator {
    private Connection oracleConn;
    private Connection mysqlConn;
    private JTextArea logArea;
    private Map<String, String> typeMapping = new HashMap<>();
    private boolean dropOldTable = true;
    private boolean migrateForeignKeys = true;

    public TableMigrator(Connection oracleConn, Connection mysqlConn, JTextArea logArea) {
        this.oracleConn = oracleConn;
        this.mysqlConn = mysqlConn;
        this.logArea = logArea;
        initTypeMapping();
    }

    private void initTypeMapping() {
        // 添加默认的类型映射
        typeMapping.put("VARCHAR2", "VARCHAR");
        typeMapping.put("NVARCHAR2", "VARCHAR");
        typeMapping.put("CHAR", "CHAR");
        typeMapping.put("NCHAR", "CHAR");
        typeMapping.put("NUMBER", "DECIMAL");
        typeMapping.put("INTEGER", "INT");
        typeMapping.put("DATE", "DATETIME");
        typeMapping.put("TIMESTAMP", "DATETIME");
        typeMapping.put("CLOB", "TEXT");
        typeMapping.put("BLOB", "BLOB");
        // 可以添加更多的类型映射...
    }

    public void setDropOldTable(boolean dropOldTable) {
        this.dropOldTable = dropOldTable;
    }

    public void setMigrateForeignKeys(boolean migrateForeignKeys) {
        this.migrateForeignKeys = migrateForeignKeys;
    }

    public void migrateTables(String[] tableNames) throws SQLException {
        if (tableNames == null || tableNames.length == 0) {
            log("❌ 错误: 未指定要迁移的表");
            return;
        }

        for (String tableName : tableNames) {
            tableName = tableName.trim();
            if (tableName.isEmpty()) continue;

            try {
                log("开始迁移表: " + tableName);
                migrateTable(tableName);
                log("✅ 表 " + tableName + " 迁移完成");
            } catch (SQLException ex) {
                log("❌ 迁移表 " + tableName + " 失败: " + ex.getMessage());
            }
        }
    }

    private void migrateTable(String tableName) throws SQLException {
        // 检查表是否存在
        if (!checkTableExists(oracleConn, tableName, "Oracle")) {
            log("⚠️ 表 " + tableName + " 在Oracle中不存在，跳过");
            return;
        }

        // 如果MySQL中已存在该表，根据配置决定是否删除
        if (checkTableExists(mysqlConn, tableName, "MySQL")) {
            if (dropOldTable) {
                dropTable(mysqlConn, tableName);
            } else {
                log("⚠️ 表 " + tableName + " 在MySQL中已存在，跳过");
                return;
            }
        }

        // 获取表结构并生成创建语句
        String createTableSQL = generateCreateTableSQL(tableName);
        if (createTableSQL == null || createTableSQL.isEmpty()) {
            log("❌ 无法生成表 " + tableName + " 的创建语句");
            return;
        }

        // 执行创建表语句
        executeUpdate(mysqlConn, createTableSQL);

        // 迁移外键约束
        if (migrateForeignKeys) {
            migrateForeignKeys(tableName);
        }
    }

    private boolean checkTableExists(Connection conn, String tableName, String dbType) throws SQLException {
        DatabaseMetaData metaData = conn.getMetaData();
        ResultSet rs = null;

        try {
            if (dbType.equals("Oracle")) {
                rs = metaData.getTables(null, null, tableName.toUpperCase(), new String[]{"TABLE"});
            } else {
                rs = metaData.getTables(null, null, tableName, new String[]{"TABLE"});
            }

            return rs.next();
        } finally {
            if (rs != null) rs.close();
        }
    }

    private void dropTable(Connection conn, String tableName) throws SQLException {
        String sql = "DROP TABLE IF EXISTS " + tableName;
        executeUpdate(conn, sql);
        log("已删除表: " + tableName);
    }

    private String generateCreateTableSQL(String tableName) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("CREATE TABLE ").append(tableName).append(" (\n");

        // 获取表的列信息
        List<ColumnInfo> columns = getTableColumns(tableName);
        if (columns.isEmpty()) {
            log("❌ 表 " + tableName + " 没有列信息");
            return null;
        }

        // 添加列定义
        for (int i = 0; i < columns.size(); i++) {
            ColumnInfo column = columns.get(i);
            sql.append("  ").append(column.getName()).append(" ");
            sql.append(mapOracleTypeToMySQL(column.getType(), column.getLength(), column.getPrecision(), column.getScale()));

            if (!column.isNullable()) {
                sql.append(" NOT NULL");
            }

            if (column.getDefaultValue() != null) {
                sql.append(" DEFAULT '").append(column.getDefaultValue()).append("'");
            }

            if (i < columns.size() - 1) {
                sql.append(",\n");
            }
        }

        // 添加主键约束
        String primaryKey = getPrimaryKey(tableName);
        if (primaryKey != null && !primaryKey.isEmpty()) {
            sql.append(",\n  PRIMARY KEY (").append(primaryKey).append(")");
        }

        sql.append("\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
        return sql.toString();
    }

    private List<ColumnInfo> getTableColumns(String tableName) throws SQLException {
        List<ColumnInfo> columns = new ArrayList<>();
        String sql = "SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, " +
                "DATA_SCALE, NULLABLE, DATA_DEFAULT " +
                "FROM ALL_TAB_COLUMNS " +
                "WHERE TABLE_NAME = ?";

        try (PreparedStatement pstmt = oracleConn.prepareStatement(sql)) {
            pstmt.setString(1, tableName.toUpperCase());
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ColumnInfo column = new ColumnInfo();
                    column.setName(rs.getString("COLUMN_NAME"));
                    column.setType(rs.getString("DATA_TYPE"));
                    column.setLength(rs.getInt("DATA_LENGTH"));
                    column.setPrecision(rs.getInt("DATA_PRECISION"));
                    column.setScale(rs.getInt("DATA_SCALE"));
                    column.setNullable("Y".equals(rs.getString("NULLABLE")));
                    column.setDefaultValue(rs.getString("DATA_DEFAULT"));
                    columns.add(column);
                }
            }
        }

        return columns;
    }

    private String getPrimaryKey(String tableName) throws SQLException {
        StringBuilder primaryKeyColumns = new StringBuilder();

        String sql = "SELECT cols.COLUMN_NAME " +
                "FROM ALL_CONSTRAINTS cons, ALL_CONS_COLUMNS cols " +
                "WHERE cols.TABLE_NAME = ? " +
                "AND cons.CONSTRAINT_TYPE = 'P' " +
                "AND cons.CONSTRAINT_NAME = cols.CONSTRAINT_NAME " +
                "ORDER BY cols.POSITION";

        try (PreparedStatement pstmt = oracleConn.prepareStatement(sql)) {
            pstmt.setString(1, tableName.toUpperCase());
            try (ResultSet rs = pstmt.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) {
                        primaryKeyColumns.append(", ");
                    }
                    primaryKeyColumns.append(rs.getString("COLUMN_NAME"));
                    first = false;
                }
            }
        }

        return primaryKeyColumns.toString();
    }

    private String mapOracleTypeToMySQL(String oracleType, int length, int precision, int scale) {
        // 先查找是否有直接的类型映射
        if (typeMapping.containsKey(oracleType)) {
            String mysqlType = typeMapping.get(oracleType);

            // 处理需要长度信息的类型
            if (mysqlType.equals("VARCHAR") || mysqlType.equals("CHAR")) {
                // 限制最大长度为255，避免MySQL的行大小限制
                int maxLength = Math.min(length, 255);
                return mysqlType + "(" + maxLength + ")";
            }

            // 处理数值类型
            if (mysqlType.equals("DECIMAL")) {
                if (precision > 0) {
                    if (scale > 0) {
                        return mysqlType + "(" + precision + ", " + scale + ")";
                    } else {
                        return mysqlType + "(" + precision + ")";
                    }
                }
                // 默认精度
                return "INT";
            }

            return mysqlType;
        }

        // 如果没有找到映射，返回原始类型并记录警告
        log("⚠️ 未找到Oracle类型 " + oracleType + " 的映射，使用原始类型");
        return oracleType;
    }

    private void migrateForeignKeys(String tableName) throws SQLException {
        // 获取外键信息
        String sql = "SELECT " +
                "  cons_r.CONSTRAINT_NAME AS FK_NAME, " +
                "  cols.COLUMN_NAME AS FK_COLUMN, " +
                "  cons_p.TABLE_NAME AS PKTABLE_NAME, " +
                "  cols_p.COLUMN_NAME AS PKCOLUMN_NAME " +
                "FROM " +
                "  ALL_CONSTRAINTS cons_r, " +
                "  ALL_CONSTRAINTS cons_p, " +
                "  ALL_CONS_COLUMNS cols, " +
                "  ALL_CONS_COLUMNS cols_p " +
                "WHERE " +
                "  cons_r.TABLE_NAME = ? " +
                "  AND cons_r.CONSTRAINT_TYPE = 'R' " +
                "  AND cons_r.R_CONSTRAINT_NAME = cons_p.CONSTRAINT_NAME " +
                "  AND cons_r.CONSTRAINT_NAME = cols.CONSTRAINT_NAME " +
                "  AND cons_p.CONSTRAINT_NAME = cols_p.CONSTRAINT_NAME " +
                "  AND cols.POSITION = cols_p.POSITION " +
                "ORDER BY " +
                "  cols.POSITION";

        try (PreparedStatement pstmt = oracleConn.prepareStatement(sql)) {
            pstmt.setString(1, tableName.toUpperCase());

            try (ResultSet rs = pstmt.executeQuery()) {
                Map<String, List<ForeignKeyInfo>> fkMap = new HashMap<>();

                while (rs.next()) {
                    String fkName = rs.getString("FK_NAME");
                    String fkColumn = rs.getString("FK_COLUMN");
                    String pkTable = rs.getString("PKTABLE_NAME");
                    String pkColumn = rs.getString("PKCOLUMN_NAME");

                    fkMap.computeIfAbsent(fkName, k -> new ArrayList<>())
                            .add(new ForeignKeyInfo(fkColumn, pkTable, pkColumn));
                }

                // 为每个外键生成并执行ALTER TABLE语句
                for (Map.Entry<String, List<ForeignKeyInfo>> entry : fkMap.entrySet()) {
                    String fkName = entry.getKey();
                    List<ForeignKeyInfo> fkInfos = entry.getValue();

                    StringBuilder fkColumns = new StringBuilder();
                    StringBuilder pkColumns = new StringBuilder();

                    for (int i = 0; i < fkInfos.size(); i++) {
                        ForeignKeyInfo fkInfo = fkInfos.get(i);

                        if (i > 0) {
                            fkColumns.append(", ");
                            pkColumns.append(", ");
                        }

                        fkColumns.append(fkInfo.getFkColumn());
                        pkColumns.append(fkInfo.getPkColumn());
                    }

                    String alterSql = "ALTER TABLE " + tableName + " ADD CONSTRAINT " + fkName +
                            " FOREIGN KEY (" + fkColumns + ") REFERENCES " +
                            fkInfos.get(0).getPkTable() + " (" + pkColumns + ")";

                    try {
                        executeUpdate(mysqlConn, alterSql);
                        log("✅ 外键 " + fkName + " 迁移完成");
                    } catch (SQLException ex) {
                        log("❌ 迁移外键 " + fkName + " 失败: " + ex.getMessage());
                    }
                }
            }
        }
    }

    private void executeUpdate(Connection conn, String sql) throws SQLException {
        log("执行SQL: " + sql);
        try (Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        }
    }

    private void log(String message) {
        if (logArea != null) {
            logArea.append(message + "\n");
            logArea.setCaretPosition(logArea.getDocument().getLength());
        } else {
            System.out.println(message);
        }
    }

    // 内部类：列信息
    private static class ColumnInfo {
        private String name;
        private String type;
        private int length;
        private int precision;
        private int scale;
        private boolean nullable;
        private String defaultValue;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public int getLength() {
            return length;
        }

        public void setLength(int length) {
            this.length = length;
        }

        public int getPrecision() {
            return precision;
        }

        public void setPrecision(int precision) {
            this.precision = precision;
        }

        public int getScale() {
            return scale;
        }

        public void setScale(int scale) {
            this.scale = scale;
        }

        public boolean isNullable() {
            return nullable;
        }

        public void setNullable(boolean nullable) {
            this.nullable = nullable;
        }

        public String getDefaultValue() {
            return defaultValue;
        }

        public void setDefaultValue(String defaultValue) {
            this.defaultValue = defaultValue;
        }
    }

    // 内部类：外键信息
    private static class ForeignKeyInfo {
        private String fkColumn;
        private String pkTable;
        private String pkColumn;

        public ForeignKeyInfo(String fkColumn, String pkTable, String pkColumn) {
            this.fkColumn = fkColumn;
            this.pkTable = pkTable;
            this.pkColumn = pkColumn;
        }

        public String getFkColumn() {
            return fkColumn;
        }

        public String getPkTable() {
            return pkTable;
        }

        public String getPkColumn() {
            return pkColumn;
        }
    }
}