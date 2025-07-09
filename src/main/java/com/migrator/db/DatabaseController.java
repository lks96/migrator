package com.migrator.db;


import javax.swing.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 处理所有数据库连接逻辑。
 * 该类负责创建、管理、测试和关闭Oracle与MySQL数据库的连接。
 */
public class DatabaseController {

    private Connection oracleConn;
    private Connection mysqlConn;
    private final JTextArea logArea;

    /**
 * DatabaseController的构造方法。
 * @param logArea 用于记录消息的JTextArea。
 */
    public DatabaseController(JTextArea logArea) {
        this.logArea = logArea;
    }

    /**
 * 使用提供的凭据建立与Oracle数据库的连接。
 * @param host 数据库主机。
 * @param port 数据库端口。
 * @param sidOrService SID或服务名。
 * @param user 用户名。
 * @param password 密码。
 * @param mode 连接模式（"SID"或"SERVICE_NAME"）。
 * @throws SQLException 如果数据库访问出错。
 */
    public void connectOracle(String host, String port, String sidOrService, String user, String password, String mode) throws SQLException {
        if (oracleConn != null && !oracleConn.isClosed()) {
            return; // 已连接
        }
        String url;
        if ("SID".equalsIgnoreCase(mode)) {
            url = "jdbc:oracle:thin:@" + host + ":" + port + ":" + sidOrService;
        } else {
            url = "jdbc:oracle:thin:@//" + host + ":" + port + "/" + sidOrService;
        }
        log("正在连接 Oracle: " + url);
        oracleConn = DriverManager.getConnection(url, user, password);
        log("✅ Oracle 连接成功");
    }

    /**
 * 建立与MySQL数据库的连接。
 * @param url JDBC URL中的主机和端口部分（例如："127.0.0.1:3306"）。
 * @param dbName 数据库名称。
 * @param user 用户名。
 * @param password 密码。
 * @throws SQLException 如果数据库访问出错。
 */
    public void connectMySQL(String url, String dbName, String user, String password) throws SQLException {
        if (mysqlConn != null && !mysqlConn.isClosed()) {
            return; // Already connected
        }
        String jdbcUrl = "jdbc:mysql://" + url + "/" + dbName + "?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
        log("正在连接 MySQL: " + jdbcUrl);
        mysqlConn = DriverManager.getConnection(jdbcUrl, user, password);
        log("✅ MySQL 连接成功");
    }

    /**
 * 测试当前的Oracle和MySQL连接。
 */
    public void testConnections() {
        log("开始测试连接...");
        boolean oracleOk = false;
        boolean mysqlOk = false;

        try {
            if (oracleConn != null && !oracleConn.isClosed() && oracleConn.isValid(5)) {
                oracleOk = true;
                log("✅ Oracle 连接测试通过");
            } else {
                log("❌ Oracle 连接无效或已关闭");
            }
        } catch (SQLException e) {
            log("❌ Oracle 连接测试失败: " + e.getMessage());
        }

        try {
            if (mysqlConn != null && !mysqlConn.isClosed() && mysqlConn.isValid(5)) {
                mysqlOk = true;
                log("✅ MySQL 连接测试通过");
            } else {
                log("❌ MySQL 连接无效或已关闭");
            }
        } catch (SQLException e) {
            log("❌ MySQL 连接测试失败: " + e.getMessage());
        }

        if (oracleOk && mysqlOk) {
            JOptionPane.showMessageDialog(null, "Oracle 和 MySQL 连接均有效！", "连接测试成功", JOptionPane.INFORMATION_MESSAGE);
        } else {
            JOptionPane.showMessageDialog(null, "一个或多个连接无效，请检查配置和日志！", "连接测试失败", JOptionPane.WARNING_MESSAGE);
        }
    }

    /**
 * 如果Oracle和MySQL连接处于打开状态，则关闭它们。
 */
    public void closeConnections() {
        try {
            if (oracleConn != null && !oracleConn.isClosed()) {
                oracleConn.close();
                oracleConn = null;
                log("Oracle 连接已关闭");
            }
            if (mysqlConn != null && !mysqlConn.isClosed()) {
                mysqlConn.close();
                mysqlConn = null;
                log("MySQL 连接已关闭");
            }
        } catch (SQLException ex) {
            log("❌ 关闭连接时出错: " + ex.getMessage());
        }
    }

    // --- 连接的getter方法 ---
    public Connection getOracleConnection() {
        return oracleConn;
    }

    public Connection getMysqlConnection() {
        return mysqlConn;
    }

    /**
 * 将消息记录到UI的日志区域。
 * @param msg 要记录的消息。
 */
    private void log(String msg) {
        if (logArea != null) {
            SwingUtilities.invokeLater(() -> {
                logArea.append(msg + "\n");
                logArea.setCaretPosition(logArea.getDocument().getLength());
            });
        }
    }
}
