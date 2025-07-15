package com.migrator.core;

import com.migrator.Main;
import com.migrator.config.ConfigManager;
import com.migrator.db.DatabaseController;
import com.migrator.ui.MigrationUI;
import com.migrator.ui.TableSelectionDialog;
import com.migrator.util.ClobUtil;
import com.migrator.util.SQLFileUtil;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

/**
 * 处理数据库迁移的核心逻辑。
 * 此类执行从Oracle到MySQL的模式和数据的实际迁移。
 */
public class Migrator {

    private final DatabaseController dbController;
    private final ConfigManager configManager;
    private final MigrationUI ui;
    private final JTextArea logArea;

    /**
 * Migrator的构造方法。
 * @param dbController 用于获取连接的数据库控制器。
 * @param configManager 用于设置的配置管理器。
 * @param ui 主UI框架，用于访问UI组件。
 */
    public Migrator(DatabaseController dbController, ConfigManager configManager, MigrationUI ui) {
        this.dbController = dbController;
        this.configManager = configManager;
        this.ui = ui;
        this.logArea = ui.getLogArea();
    }

    /**
 * 在后台线程中启动迁移过程。
 */
    public void doMigration() {
        log("=====================================================");
        log("准备开始迁移...");

        // 使用SwingWorker在后台执行迁移
        SwingWorker<Void, String> migrationWorker = new SwingWorker<Void, String>() {
            @Override
            protected Void doInBackground() throws Exception {
                Connection oracleConn = dbController.getOracleConnection();
                Connection mysqlConn = dbController.getMysqlConnection();

                if (oracleConn == null || oracleConn.isClosed() || mysqlConn == null || mysqlConn.isClosed()) {
                    publish("❌ 数据库未连接. 请先测试并确保连接成功。");
                    return null;
                }

                // 1. Get list of all tables from Oracle
                List<String> allTableNames = new ArrayList<>();
                DatabaseMetaData meta = oracleConn.getMetaData();
                String oracleUser = ui.getOracleUserField().getText().toUpperCase();
                try (ResultSet tables = meta.getTables(null, oracleUser, "%", new String[]{"TABLE"})) {
                    while (tables.next()) {
                        allTableNames.add(tables.getString("TABLE_NAME"));
                    }
                }

                // 2. Filter tables based on user input or show selection dialog
                Set<String> selectedTables;
                String filterText = ui.getTableFilterField().getText().trim();
                if (!filterText.isEmpty()) {
                    selectedTables = new HashSet<>();
                    String[] patterns = filterText.split(",");
                    for (String pattern : patterns) {
                        try {
                            boolean useRegex = ui.isRegexFilterEnabled();
                            for (String tableName : allTableNames) {
                                if (useRegex) {
                                    Pattern regex = Pattern.compile(pattern.trim(), Pattern.CASE_INSENSITIVE);
                                    if (regex.matcher(tableName).find()) {
                                        selectedTables.add(tableName);
                                    }
                                } else {
                                    if (tableName.equalsIgnoreCase(pattern.trim())) {
                                        selectedTables.add(tableName);
                                    }
                                }
                            }

                        } catch (PatternSyntaxException e) {
                            publish("⚠️ 无效的正则表达式: " + pattern + ", 已忽略。");
                        }
                    }
                    publish("🔍 根据过滤规则，匹配到 " + selectedTables.size() + " 张表。");
                } else {
                    TableSelectionDialog dialog = new TableSelectionDialog(ui.getFrame(), allTableNames);
                    dialog.setVisible(true);
                    selectedTables = dialog.getSelectedTables();
                }

                if (selectedTables.isEmpty()) {
                    publish("🔴 未选择任何表，迁移已取消。");
                    return null;
                }

                // 3. Ask for migration type
                String[] options = {"仅迁移结构", "仅迁移数据", "结构+数据"};
                int choice = JOptionPane.showOptionDialog(ui.getFrame(), "请选择迁移内容：", "迁移类型",
                        JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE, null, options, options[2]);

                if (choice == -1) {
                    publish("🔴 用户取消了操作，迁移已停止。");
                    return null;
                }

                boolean migrateStructure = (choice == 0 || choice == 2);
                boolean migrateData = (choice == 1 || choice == 2);

                // 4. Start migration loop
                int totalTables = selectedTables.size();
                int tableIndex = 0;
                for (String tableName : selectedTables) {
                    tableIndex++;
                    publish("\n--- (" + tableIndex + "/" + totalTables + ") 开始处理表: " + tableName + " ---");

                    try {
                        mysqlConn.setAutoCommit(false);

                        // 迁移结构
                        if (migrateStructure) {
                            publish("    - 正在迁移表结构...");
                            try (Statement stmt = mysqlConn.createStatement()) {
                                stmt.execute("SET FOREIGN_KEY_CHECKS=0");

                                if (ui.getDropOldTableCheckBox().isSelected()) {
                                    stmt.execute("DROP TABLE IF EXISTS `" + tableName.toLowerCase() + "`");
                                    publish("    - ✅ 已删除旧表 (if exists): " + tableName);
                                }

                                String createSQL = generateCreateTableSQL(oracleConn, tableName, oracleUser);
                                try {
                                    stmt.execute(createSQL);
                                    SQLFileUtil.successSql(createSQL, configManager.getProperty("file.log", "log/")+Main.LOG_FILE_DIR_PATH+Main.LOG_FILE_PATH+"success.sql");
                                    publish("    - ✅ 表结构创建成功: " + tableName);
                                } catch (SQLException e) {
                                    publish("    - ❌ 表结构创建失败: " + e.getMessage());
                                    SQLFileUtil.errorSql(createSQL, configManager.getProperty("file.log", "log/")+Main.LOG_FILE_DIR_PATH+Main.LOG_FILE_PATH+"error.sql");
                                    // 如果结构迁移失败则继续下一个表
                                    mysqlConn.rollback();
                                    continue;
                                }
                            }
                        }

                        // 迁移数据
                        if (migrateData) {
                            publish("    - 正在迁移数据...");
                            migrateDataForTable(oracleConn, mysqlConn, tableName);
                        }

                        // 迁移外键（在所有表创建和数据插入后）
                        if (migrateStructure && ui.getMigrateForeignKeysCheckBox().isSelected()) {
                            publish("    - 正在迁移外键...");
                            migrateForeignKeys(oracleConn, mysqlConn, tableName, oracleUser);
                        }

                        // 重新启用外键检查
                        if (migrateStructure) {
                            try (Statement stmt = mysqlConn.createStatement()) {
                                stmt.execute("SET FOREIGN_KEY_CHECKS=1");
                            }
                        }

                        mysqlConn.commit();
                        publish("    - ✅ 已提交事务: " + tableName);

                    } catch (Exception ex) {
                        publish("❌ 处理表 " + tableName + " 时发生严重错误: " + ex.getMessage());
                        ex.printStackTrace();
                        if (mysqlConn != null) {
                            mysqlConn.rollback();
                            publish("    - 🔴 事务已回滚。");
                        }
                    } finally {
                        if (mysqlConn != null) {
                            mysqlConn.setAutoCommit(true);
                        }
                    }
                }
                publish("\n=====================================================");
                publish("🎉🎉🎉 所有选定表的迁移任务已完成! 🎉🎉🎉");
                return null;
            }

            @Override
            protected void process(List<String> chunks) {
                for (String msg : chunks) {
                    log(msg);
                }
            }

            @Override
            protected void done() {
                try {
                    get(); // To catch any exception from doInBackground
                } catch (Exception e) {
                    log("❌ 迁移过程中发生未捕获的异常: " + e.getMessage());
                    e.printStackTrace();
                }
                JOptionPane.showMessageDialog(ui.getFrame(), "迁移任务已完成，请查看日志获取详细信息。", "迁移完成", JOptionPane.INFORMATION_MESSAGE);
            }
        };

        migrationWorker.execute();
    }

    /**
     * Migrates data for a single table.
     */
    private void migrateDataForTable(Connection oracleConn, Connection mysqlConn, String tableName) throws SQLException, IOException {
        String lowerCaseTableName = tableName.toLowerCase();
        try (Statement oracleStmt = oracleConn.createStatement();
             ResultSet rs = oracleStmt.executeQuery("SELECT * FROM \"" + tableName + "\"")) {

            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            StringBuilder insertSqlBuilder = new StringBuilder("INSERT INTO `");
            insertSqlBuilder.append(lowerCaseTableName).append("` (");
            for (int i = 1; i <= columnCount; i++) {
                insertSqlBuilder.append("`").append(metaData.getColumnName(i).toLowerCase()).append("`");
                if (i < columnCount) insertSqlBuilder.append(", ");
            }
            insertSqlBuilder.append(") VALUES (");
            for (int i = 0; i < columnCount; i++) {
                insertSqlBuilder.append("?");
                if (i < columnCount - 1) insertSqlBuilder.append(", ");
            }
            insertSqlBuilder.append(")");

            try (PreparedStatement mysqlPstmt = mysqlConn.prepareStatement(insertSqlBuilder.toString())) {
                int batchCount = 0;
                final int BATCH_SIZE = 500;
                int totalRows = 0;

                while (rs.next()) {
                    totalRows++;
                    for (int i = 1; i <= columnCount; i++) {
                        String columnType = metaData.getColumnTypeName(i).toUpperCase();
                        Object val;

                        if ("CLOB".equals(columnType) || "NCLOB".equals(columnType)) {
                            Clob clob = rs.getClob(i);
                            val = (clob == null) ? null : ClobUtil.clobToString(clob);
                            mysqlPstmt.setString(i, (String) val);
                        } else if ("BLOB".equals(columnType)) {
                            Blob blob = rs.getBlob(i);
                            val = (blob == null) ? null : blob.getBytes(1, (int) blob.length());
                            mysqlPstmt.setBytes(i, (byte[]) val);
                        } else if ("DATE".equals(columnType) || columnType.startsWith("TIMESTAMP")) {
                            Timestamp ts = rs.getTimestamp(i);
                            mysqlPstmt.setTimestamp(i, ts);
                        } else {
                            mysqlPstmt.setObject(i, rs.getObject(i));
                        }
                    }
                    mysqlPstmt.addBatch();
                    batchCount++;

                    if (batchCount % BATCH_SIZE == 0) {
                        mysqlPstmt.executeBatch();
                        mysqlPstmt.clearBatch();
                        log("    - -> 已插入 " + batchCount + " 行...");
                    }
                }

                mysqlPstmt.executeBatch(); // Insert remaining records
                log("    - ✅ 数据迁移完成，共 " + totalRows + " 行。");
            }
        }
    }


    /**
     * Generates the CREATE TABLE SQL statement for a given Oracle table.
     * @param oracleConn The Oracle database connection.
     * @param tableName The name of the table.
     * @param owner The schema/owner of the table.
     * @return The generated CREATE TABLE SQL string for MySQL.
     * @throws SQLException if a database access error occurs.
     */
    private String generateCreateTableSQL(Connection oracleConn, String tableName, String owner) throws SQLException {
        // 获取表注释
        String tableComment = "";
        String tableCommentSql = "SELECT COMMENTS FROM ALL_TAB_COMMENTS WHERE OWNER = ? AND TABLE_NAME = ?";
        try (PreparedStatement ps = oracleConn.prepareStatement(tableCommentSql)) {
            ps.setString(1, owner);
            ps.setString(2, tableName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tableComment = rs.getString("COMMENTS");
                }
            }
        }

        StringBuilder sb = new StringBuilder("CREATE TABLE `").append(tableName.toLowerCase()).append("` (\n");

        // 获取列详情
        String columnsSql = "SELECT c.COLUMN_NAME, c.DATA_TYPE, c.DATA_LENGTH, c.DATA_PRECISION, c.DATA_SCALE, c.NULLABLE, " +
                "cc.COMMENTS, c.DATA_DEFAULT " +
                "FROM ALL_TAB_COLUMNS c " +
                "LEFT JOIN ALL_COL_COMMENTS cc ON c.OWNER = cc.OWNER AND c.TABLE_NAME = cc.TABLE_NAME AND c.COLUMN_NAME = cc.COLUMN_NAME " +
                "WHERE c.OWNER = ? AND c.TABLE_NAME = ? ORDER BY c.COLUMN_ID";
        try (PreparedStatement ps = oracleConn.prepareStatement(columnsSql)) {
            ps.setString(1, owner);
            ps.setString(2, tableName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String colName = rs.getString("COLUMN_NAME");
                    String dataType = rs.getString("DATA_TYPE");
                    int dataLength = rs.getInt("DATA_LENGTH");
                    int dataPrecision = rs.getInt("DATA_PRECISION");
                    int dataScale = rs.getInt("DATA_SCALE");
                    String nullable = rs.getString("NULLABLE");
                    String comment = rs.getString("COMMENTS");
                    String defaultValue = rs.getString("DATA_DEFAULT");

                    String mappedType = mapOracleTypeToMySQL(dataType, dataLength, dataPrecision, dataScale);
                    sb.append("  `").append(colName.toLowerCase()).append("` ").append(mappedType);

                    if ("N".equals(nullable)) {
                        sb.append(" NOT NULL");
                    }

                    if (defaultValue != null && !defaultValue.trim().isEmpty() && !"NULL".equalsIgnoreCase(defaultValue.trim())) {
                        if (defaultValue.trim().equalsIgnoreCase("SYSDATE")) {
                            sb.append(" DEFAULT CURRENT_TIMESTAMP");
                        } else {
                            defaultValue = defaultValue.replace("'", "").trim();
                            sb.append(" DEFAULT '").append(defaultValue).append("'");
                        }
                    }

                    if (comment != null && !comment.trim().isEmpty()) {
                        sb.append(" COMMENT '").append(comment.replace("'", "\\'")).append("'");
                    }
                    sb.append(",\n");
                }
            }
        }

        // 获取主键
        List<String> primaryKeys = new ArrayList<>();
        String pkSql = "SELECT cols.column_name FROM all_constraints cons, all_cons_columns cols " +
                "WHERE cons.constraint_type = 'P' AND cons.owner = ? AND cons.table_name = ? " +
                "AND cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner";
        try (PreparedStatement pkStmt = oracleConn.prepareStatement(pkSql)) {
            pkStmt.setString(1, owner);
            pkStmt.setString(2, tableName);
            try (ResultSet pkRs = pkStmt.executeQuery()) {
                while (pkRs.next()) {
                    primaryKeys.add(pkRs.getString("COLUMN_NAME").toLowerCase());
                }
            }
        }
        if (!primaryKeys.isEmpty()) {
            sb.append("  PRIMARY KEY (").append(String.join(", ", primaryKeys.stream().map(pk -> "`" + pk + "`").toArray(String[]::new))).append("),\n");
        }

        // 清理末尾逗号
        if (sb.toString().trim().endsWith(",")) {
            sb.setLength(sb.length() - 2); // Remove ",\n"
            sb.append("\n");
        }

        sb.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        // 拼接表注释（先保留 comment 内容）
        String tableCommentClause = "";
        if (tableComment != null && !tableComment.isEmpty()) {
            tableCommentClause = " COMMENT='" + tableComment.replace("'", "\\'") + "'";
        }
        // 检查是否是分区表，生成 MySQL 分区语法（目前只处理 RANGE 分区示例）
        // 检查是否是分区表，生成 MySQL 分区语法（目前只处理 RANGE 分区示例）
        String partitioningSql = "SELECT PARTITIONING_TYPE FROM ALL_PART_TABLES WHERE OWNER = ? AND TABLE_NAME = ?";
        try (PreparedStatement ps = oracleConn.prepareStatement(partitioningSql)) {
            ps.setString(1, owner);
            ps.setString(2, tableName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String partitionType = rs.getString("PARTITIONING_TYPE");
                    if ("RANGE".equalsIgnoreCase(partitionType)) {
                        // 尝试获取分区键
                        String keySql = "SELECT COLUMN_NAME FROM ALL_PART_KEY_COLUMNS WHERE OWNER = ? AND NAME = ? ORDER BY COLUMN_POSITION";
                        List<String> partitionCols = new ArrayList<>();
                        try (PreparedStatement keyPs = oracleConn.prepareStatement(keySql)) {
                            keyPs.setString(1, owner);
                            keyPs.setString(2, tableName);
                            try (ResultSet keyRs = keyPs.executeQuery()) {
                                while (keyRs.next()) {
                                    partitionCols.add(keyRs.getString("COLUMN_NAME").toLowerCase());
                                }
                            }
                        }

                        // 检查分区字段类型是否为整数
                        boolean isIntegerPartition = false;
                        if (!partitionCols.isEmpty()) {
                            String columnTypeSql = "SELECT DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER = ? AND TABLE_NAME = ? AND COLUMN_NAME = ?";
                            try (PreparedStatement typePs = oracleConn.prepareStatement(columnTypeSql)) {
                                typePs.setString(1, owner);
                                typePs.setString(2, tableName);
                                typePs.setString(3, partitionCols.get(0).toUpperCase());
                                try (ResultSet rsType = typePs.executeQuery()) {
                                    if (rsType.next()) {
                                        String partitionColumnType = rsType.getString("DATA_TYPE");
                                        if ("NUMBER".equalsIgnoreCase(partitionColumnType)) {
                                            isIntegerPartition = true;
                                        } else {
                                            log("⚠️ 表 " + tableName + " 的分区列类型为 " + partitionColumnType + "，MySQL 不支持该类型做分区。分区定义将被跳过。");
                                        }
                                    }
                                }
                            }
                        }

                        if (isIntegerPartition) {
                            // 获取分区定义
                            String partSql = "SELECT PARTITION_NAME, HIGH_VALUE FROM ALL_TAB_PARTITIONS WHERE TABLE_OWNER = ? AND TABLE_NAME = ? ORDER BY PARTITION_POSITION";
                            List<String> partitionDefs = new ArrayList<>();
                            try (PreparedStatement partPs = oracleConn.prepareStatement(partSql)) {
                                partPs.setString(1, owner);
                                partPs.setString(2, tableName);
                                try (ResultSet partRs = partPs.executeQuery()) {
                                    while (partRs.next()) {
                                        String partitionName = partRs.getString("PARTITION_NAME").toLowerCase();
                                        String highValue = partRs.getString("HIGH_VALUE").trim();

                                        // 解析 TO_DATE 表达式
                                        if (highValue.contains("TO_DATE")) {
                                            Pattern datePattern = Pattern.compile("TO_DATE\\s*\\(\\s*'(.*?)'", Pattern.CASE_INSENSITIVE);
                                            Matcher matcher = datePattern.matcher(highValue);
                                            if (matcher.find()) {
                                                String dateStr = matcher.group(1);
                                                try {
                                                    // 尝试将日期转为整数格式 yyyyMMdd
                                                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd[ HH:mm:ss]");
                                                    LocalDateTime dt = LocalDateTime.parse(dateStr, formatter);
                                                    highValue = String.valueOf(Integer.parseInt(dt.format(DateTimeFormatter.ofPattern("yyyyMMdd"))));
                                                } catch (Exception ex) {
                                                    log("⚠️ 分区值日期解析失败，默认使用 MAXVALUE");
                                                    highValue = "MAXVALUE";
                                                }
                                            } else {
                                                highValue = "MAXVALUE";
                                            }
                                        }

                                        if ("MAXVALUE".equalsIgnoreCase(highValue)) {
                                            partitionDefs.add(String.format("PARTITION %s VALUES LESS THAN (MAXVALUE)", partitionName));
                                        } else {
                                            partitionDefs.add(String.format("PARTITION %s VALUES LESS THAN (%s)", partitionName, highValue));
                                        }
                                    }
                                }
                            }

                            // 拼接 MySQL 分区语法
                            if (!partitionDefs.isEmpty()) {
                                sb.append("\nPARTITION BY RANGE (").append(partitionCols.get(0)).append(") (\n  ");
                                sb.append(String.join(",\n  ", partitionDefs));
                                sb.append("\n)");
                                log("    - ✅ 表 " + tableName + " 的分区定义已成功迁移到 MySQL。");
                            }
                        }
                    } else {
                        log("⚠️ 不支持的 Oracle 分区类型: " + partitionType + "，分区定义将被跳过。");
                    }
                }
            }
        }

        // 最后再拼接分号
        sb.append(tableCommentClause);

        return sb.toString();
    }

    /**
     * Migrates foreign key constraints for a given table.
     * @param oracleConn The Oracle database connection.
     * @param mysqlConn The MySQL database connection.
     * @param tableName The name of the table.
     * @param owner The schema/owner of the table.
     */
    private void migrateForeignKeys(Connection oracleConn, Connection mysqlConn, String tableName, String owner) {
        String fkSql = "SELECT a.constraint_name, c.column_name AS local_column, " +
                "r.table_name AS ref_table, d.column_name AS ref_column " +
                "FROM all_constraints a " +
                "JOIN all_cons_columns c ON a.constraint_name = c.constraint_name AND a.owner = c.owner " +
                "JOIN all_constraints r ON a.r_constraint_name = r.constraint_name AND a.r_owner = r.owner " +
                "JOIN all_cons_columns d ON r.constraint_name = d.constraint_name AND r.owner = d.owner AND c.position = d.position " +
                "WHERE a.constraint_type = 'R' AND a.owner = ? AND a.table_name = ?";

        try (PreparedStatement fkStmt = oracleConn.prepareStatement(fkSql)) {
            fkStmt.setString(1, owner);
            fkStmt.setString(2, tableName);
            try (ResultSet fkRs = fkStmt.executeQuery()) {
                while (fkRs.next()) {
                    String constraintName = fkRs.getString("constraint_name");
                    String localColumn = fkRs.getString("local_column");
                    String refTable = fkRs.getString("ref_table");
                    String refColumn = fkRs.getString("ref_column");

                    String alterSql = String.format("ALTER TABLE `%s` ADD CONSTRAINT `%s` FOREIGN KEY (`%s`) REFERENCES `%s`(`%s`);",
                            tableName.toLowerCase(),
                            constraintName.toLowerCase(),
                            localColumn.toLowerCase(),
                            refTable.toLowerCase(),
                            refColumn.toLowerCase());

                    try (Statement mysqlStmt = mysqlConn.createStatement()) {
                        mysqlStmt.execute(alterSql);
                        log("    - ✅ 外键创建成功: " + constraintName);
                        SQLFileUtil.successSql(alterSql, configManager.getProperty("file.log", "log/")+Main.LOG_FILE_DIR_PATH+Main.LOG_FILE_PATH+"success.sql");
                    } catch (SQLException e) {
                        log("    - ⚠️ 外键创建失败: " + constraintName + " - " + e.getMessage());
                        SQLFileUtil.errorSql(alterSql, configManager.getProperty("file.log", "log/")+Main.LOG_FILE_DIR_PATH+Main.LOG_FILE_PATH+"error.sql");
                    }
                }
            }
        } catch (SQLException e) {
            log("❌ 获取外键信息失败: " + e.getMessage());
        }
    }

    /**
     * Maps an Oracle data type to its corresponding MySQL data type.
     * @param oracleType The Oracle data type string.
     * @param length The length of the data type.
     * @param precision The precision for numeric types.
     * @param scale The scale for numeric types.
     * @return The corresponding MySQL data type string.
     */
    /**
     * Maps an Oracle data type to its corresponding MySQL data type.
     * @param oracleType The Oracle data type string.
     * @param length The length of the data type.
     * @param precision The precision for numeric types.
     * @param scale The scale for numeric types.
     * @return The corresponding MySQL data type string.
     */
    private String mapOracleTypeToMySQL(String oracleType, int length, int precision, int scale) {
        String oracleTypeUpper = oracleType.toUpperCase();
        DefaultTableModel mappingModel = ui.getMappingTableModel();

        // --- 开始修改 ---

        // 1. 根据不同类型，构造一个带长度/精度的完整Oracle类型字符串，用于精确匹配
        String fullOracleType;
        switch (oracleTypeUpper) {
            case "VARCHAR2":
            case "NVARCHAR2":
            case "VARCHAR":
            case "CHAR":
            case "NCHAR":
            case "RAW":
                fullOracleType = oracleTypeUpper + "(" + length + ")";
                break;
            case "NUMBER":
                if (scale > 0 && precision > 0) {
                    fullOracleType = "NUMBER(" + precision + "," + scale + ")";
                } else if (precision > 0) {
                    fullOracleType = "NUMBER(" + precision + ")";
                } else {
                    fullOracleType = "NUMBER";
                }
                break;
            default:
                // 对于TIMESTAMP, DATE, CLOB等不带括号的类型，其本身就是完整类型
                fullOracleType = oracleTypeUpper;
                break;
        }

        // 2. 优先在自定义映射中查找精确匹配
        //    例如，这会查找 "VARCHAR2(255)"
        for (int i = 0; i < mappingModel.getRowCount(); i++) {
            String mappingKey = ((String) mappingModel.getValueAt(i, 0)).toUpperCase().replaceAll("\\s", "");
            if (mappingKey.equalsIgnoreCase(fullOracleType)) {
                return (String) mappingModel.getValueAt(i, 1);
            }
        }

        // 3. 如果找不到精确匹配，再查找通用类型匹配
        //    例如，这会查找 "DATE" 或 "CLOB"
        //    这确保了 VARCHAR2(255) 的规则不会被一个( hypothetical) 通用的 VARCHAR2 规则错误覆盖
        if (!fullOracleType.equals(oracleTypeUpper)) {
            for (int i = 0; i < mappingModel.getRowCount(); i++) {
                String mappingKey = ((String) mappingModel.getValueAt(i, 0)).toUpperCase().replaceAll("\\s", "");
                if (mappingKey.equalsIgnoreCase(oracleTypeUpper)) {
                    return (String) mappingModel.getValueAt(i, 1);
                }
            }
        }

        // --- 结束修改 ---

        // 4. 如果自定义映射中没有找到任何匹配项，则执行默认的转换逻辑
        if (oracleTypeUpper.startsWith("TIMESTAMP")) {
            return "DATETIME(6)";
        }

        switch (oracleTypeUpper) {
            case "VARCHAR2":
            case "VARCHAR":
                return "VARCHAR(" + length + ")";
            case "NVARCHAR2":
                return "VARCHAR(" + length + ")";
            case "CHAR":
            case "NCHAR":
                return "CHAR(" + length + ")";
            case "NUMBER":
                if (scale > 0) {
                    return "DECIMAL(" + (precision > 0 ? precision : 38) + "," + scale + ")";
                }
                if (precision == 0) return "INT"; // Or BIGINT if needed
                if (precision <= 3) return "TINYINT";
                if (precision <= 5) return "SMALLINT";
                if (precision <= 9) return "INT";
                if (precision <= 18) return "BIGINT";
                return "DECIMAL(" + precision + ",0)";
            case "DATE":
                return "DATETIME";
            case "CLOB":
            case "NCLOB":
                return "LONGTEXT";
            case "BLOB":
                return "LONGBLOB";
            case "FLOAT":
                return "DOUBLE";
            case "RAW":
                return "VARBINARY(" + length + ")";
            default:
                log("⚠️ 未知 Oracle 类型: " + oracleTypeUpper + "，将默认使用 VARCHAR(255)");
                return "VARCHAR(255)";
        }
    }

    /**
     * Logs a message to the UI's log area.
     * @param msg The message to log.
     */
    private void log(String msg) {
        if (logArea != null) {
            // 确保日志在EDT上完成
            SwingUtilities.invokeLater(() -> {
                logArea.append(msg + "\n");
                logArea.setCaretPosition(logArea.getDocument().getLength());
            });
        }
    }
}