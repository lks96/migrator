package com.migrator.db;


import javax.swing.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Handles all database connection logic.
 * This class is responsible for creating, managing, testing, and closing
 * connections to both Oracle and MySQL databases.
 */
public class DatabaseController {

    private Connection oracleConn;
    private Connection mysqlConn;
    private final JTextArea logArea;

    /**
     * Constructor for DatabaseController.
     * @param logArea The JTextArea for logging messages.
     */
    public DatabaseController(JTextArea logArea) {
        this.logArea = logArea;
    }

    /**
     * Establishes a connection to the Oracle database using provided credentials.
     * @param host The database host.
     * @param port The database port.
     * @param sidOrService The SID or Service Name.
     * @param user The username.
     * @param password The password.
     * @param mode The connection mode ("SID" or "SERVICE_NAME").
     * @throws SQLException if a database access error occurs.
     */
    public void connectOracle(String host, String port, String sidOrService, String user, String password, String mode) throws SQLException {
        if (oracleConn != null && !oracleConn.isClosed()) {
            return; // Already connected
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
     * Establishes a connection to the MySQL database.
     * @param url The host and port part of the JDBC URL (e.g., "127.0.0.1:3306").
     * @param dbName The database name.
     * @param user The username.
     * @param password The password.
     * @throws SQLException if a database access error occurs.
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
     * Tests the current Oracle and MySQL connections.
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
     * Closes both Oracle and MySQL connections if they are open.
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

    // --- Getters for connections ---
    public Connection getOracleConnection() {
        return oracleConn;
    }

    public Connection getMysqlConnection() {
        return mysqlConn;
    }

    /**
     * Logs a message to the UI's log area.
     * @param msg The message to log.
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
