package com.migrator.update;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;
import javax.swing.SwingWorker;
import javax.swing.JTextArea;

public class ConnectionManager {
    private Connection oracleConn = null;
    private Connection mysqlConn = null;
    private JTextArea logArea;
    private Properties config;

    public ConnectionManager(JTextArea logArea, Properties config) {
        this.logArea = logArea;
        this.config = config;
    }

    public void initializeConnections() {
        new SwingWorker<Void, String>() {
            @Override
            protected Void doInBackground() throws Exception {
                publish("正在初始化数据库连接...");

                // 关闭现有连接（如果存在）
                closeConnections();

                try {
                    // 创建Oracle连接
                    connectOracle();
                    publish("✅ Oracle 连接成功");

                    // 创建MySQL连接
                    connectMysql();
                    publish("✅ MySQL 连接成功");

                } catch (SQLException ex) {
                    publish("❌ 连接初始化失败: " + ex.getMessage());
                }
                return null;
            }

            @Override
            protected void process(List<String> chunks) {
                for (String msg : chunks) {
                    logArea.append(msg + "\n");
                }
                logArea.setCaretPosition(logArea.getDocument().getLength());
            }
        }.execute();
    }

    private void connectOracle() throws SQLException {
        String url = config.getProperty("oracle.url", "jdbc:oracle:thin:@localhost:1521:XE");
        String user = config.getProperty("oracle.user", "system");
        String password = config.getProperty("oracle.password", "password");

        try {
            Class.forName("oracle.jdbc.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("找不到Oracle JDBC驱动", e);
        }

        oracleConn = DriverManager.getConnection(url, user, password);
    }

    private void connectMysql() throws SQLException {
        String url = config.getProperty("mysql.url", "jdbc:mysql://localhost:3306/mydb");
        String user = config.getProperty("mysql.user", "root");
        String password = config.getProperty("mysql.password", "password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("找不到MySQL JDBC驱动", e);
        }

        mysqlConn = DriverManager.getConnection(url, user, password);
    }

    public Connection getOracleConn() {
        return oracleConn;
    }

    public Connection getMysqlConn() {
        return mysqlConn;
    }

    public void closeConnections() {
        try {
            if (oracleConn != null && !oracleConn.isClosed()) {
                oracleConn.close();
                log("Oracle 连接已关闭");
            }
            if (mysqlConn != null && !mysqlConn.isClosed()) {
                mysqlConn.close();
                log("MySQL 连接已关闭");
            }
        } catch (SQLException ex) {
            log("关闭连接时出错: " + ex.getMessage());
        }
    }

    private void log(String message) {
        logArea.append(message + "\n");
        logArea.setCaretPosition(logArea.getDocument().getLength());
    }
}