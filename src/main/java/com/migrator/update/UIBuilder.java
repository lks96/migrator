package com.migrator.update;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.Properties;

public class UIBuilder {
    private JFrame frame;
    private JTextArea logArea;
    private JTextField tableFilterField;
    private JTextField oracleHostField, oraclePortField, oracleSIDField, oracleUserField;
    private JPasswordField oraclePwdField;
    private JTextField mysqlUrlField, mysqlDbNameField, mysqlUserField;
    private JPasswordField mysqlPwdField;
    private JCheckBox dropOldTableCheckBox, migrateForeignKeysCheckBox;
    private ConnectionManager connectionManager;
    private Properties config;

    public UIBuilder() {
    }

    public void createAndShowGUI(ConfigLoader configLoader, ConnectionManager connectionManager) {
        this.config = configLoader.getConfig();
        this.connectionManager = connectionManager;

        frame = new JFrame("Oracle → MySQL 表结构迁移工具");
        setupFrame();

        // 创建主面板
        JSplitPane splitPane = createMainSplitPane();

        // 底部按钮面板
        JPanel bottomPanel = createBottomPanel();

        // 组装界面
        frame.add(splitPane, BorderLayout.CENTER);
        frame.add(bottomPanel, BorderLayout.SOUTH);

        // 显示窗口
        frame.setVisible(true);

        // 初始化连接
        connectionManager.initializeConnections();
    }

    private void setupFrame() {
        // 设置窗口图标
        try {
            String iconPath = config.getProperty("icon.path");
            if (iconPath != null && !iconPath.isEmpty()) {
                BufferedImage icon = ImageIO.read(new File(iconPath));
                frame.setIconImage(icon);
            }
        } catch (IOException e) {
            log("无法加载图标: " + e.getMessage());
        }

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(1080, 750);
        frame.setLocationRelativeTo(null); // 居中显示
    }

    private JSplitPane createMainSplitPane() {
        // 左侧面板 - 配置区域
        JPanel leftPanel = new JPanel(new BorderLayout());

        // 顶部过滤面板
        JPanel filterPanel = createFilterPanel();
        leftPanel.add(filterPanel, BorderLayout.NORTH);

        // 配置标签页
        JTabbedPane configTabbedPane = createConfigTabbedPane();
        leftPanel.add(configTabbedPane, BorderLayout.CENTER);

        // 右侧面板 - 日志区域
        logArea = new JTextArea(20, 40);
        logArea.setEditable(false);
        logArea.setFont(new Font("Monospaced", Font.PLAIN, 14));

        JScrollPane logScrollPane = new JScrollPane(logArea);
        logScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);

        JPanel rightPanel = new JPanel(new BorderLayout());
        rightPanel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.BLUE, 2),
                "日志控制台",
                TitledBorder.LEFT,
                TitledBorder.TOP,
                new Font("微软雅黑", Font.BOLD, 16),
                Color.BLUE
        ));
        rightPanel.add(logScrollPane, BorderLayout.CENTER);

        // 创建分割面板
        JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        splitPane.setLeftComponent(leftPanel);
        splitPane.setRightComponent(rightPanel);
        splitPane.setDividerLocation(450);
        splitPane.setResizeWeight(0.5);

        return splitPane;
    }

    private JPanel createFilterPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        panel.setBorder(BorderFactory.createTitledBorder("表过滤设置"));

        JLabel label = new JLabel("指定迁移的表名 (多个用逗号分隔):");
        label.setFont(new Font("微软雅黑", Font.PLAIN, 14));

        tableFilterField = new JTextField(50);
        tableFilterField.setFont(new Font("微软雅黑", Font.PLAIN, 14));

        panel.add(label);
        panel.add(tableFilterField);

        return panel;
    }

    private JTabbedPane createConfigTabbedPane() {
        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("微软雅黑", Font.BOLD, 16));

        tabbedPane.addTab("Oracle 配置", createOracleConfigPanel());
        tabbedPane.addTab("MySQL 配置", createMySQLConfigPanel());
        tabbedPane.addTab("字段映射配置", createMappingPanel());
        tabbedPane.addTab("其他配置", createOtherConfigPanel());

        return tabbedPane;
    }

    private JPanel createOracleConfigPanel() {
        JPanel panel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 10, 5, 10);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // 连接模式
        gbc.gridx = 0;
        gbc.gridy = 0;
        panel.add(new JLabel("连接模式:"), gbc);

        gbc.gridx = 1;
        JComboBox<String> connectModeBox = new JComboBox<>(new String[]{"SID", "Service Name"});
        panel.add(connectModeBox, gbc);

        // 主机
        gbc.gridx = 0;
        gbc.gridy = 1;
        panel.add(new JLabel("主机:"), gbc);

        gbc.gridx = 1;
        oracleHostField = new JTextField(config.getProperty("oracle.host", "localhost"), 20);
        panel.add(oracleHostField, gbc);

        // 端口
        gbc.gridx = 0;
        gbc.gridy = 2;
        panel.add(new JLabel("端口:"), gbc);

        gbc.gridx = 1;
        oraclePortField = new JTextField(config.getProperty("oracle.port", "1521"), 10);
        panel.add(oraclePortField, gbc);

        // SID/服务名
        gbc.gridx = 0;
        gbc.gridy = 3;
        panel.add(new JLabel("SID/服务名:"), gbc);

        gbc.gridx = 1;
        oracleSIDField = new JTextField(config.getProperty("oracle.sid", "XE"), 20);
        panel.add(oracleSIDField, gbc);

        // 用户名
        gbc.gridx = 0;
        gbc.gridy = 4;
        panel.add(new JLabel("用户名:"), gbc);

        gbc.gridx = 1;
        oracleUserField = new JTextField(config.getProperty("oracle.user", "system"), 20);
        panel.add(oracleUserField, gbc);

        // 密码
        gbc.gridx = 0;
        gbc.gridy = 5;
        panel.add(new JLabel("密码:"), gbc);

        gbc.gridx = 1;
        oraclePwdField = new JPasswordField(config.getProperty("oracle.password", ""), 20);
        panel.add(oraclePwdField, gbc);

        return panel;
    }

    private JPanel createMySQLConfigPanel() {
        JPanel panel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 10, 5, 10);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // 数据库URL
        gbc.gridx = 0;
        gbc.gridy = 0;
        panel.add(new JLabel("数据库URL:"), gbc);

        gbc.gridx = 1;
        mysqlUrlField = new JTextField(config.getProperty("mysql.url", "jdbc:mysql://localhost:3306/mydb"), 30);
        panel.add(mysqlUrlField, gbc);

        // 数据库名
        gbc.gridx = 0;
        gbc.gridy = 1;
        panel.add(new JLabel("数据库名:"), gbc);

        gbc.gridx = 1;
        mysqlDbNameField = new JTextField("mydb", 20);
        panel.add(mysqlDbNameField, gbc);

        // 用户名
        gbc.gridx = 0;
        gbc.gridy = 2;
        panel.add(new JLabel("用户名:"), gbc);

        gbc.gridx = 1;
        mysqlUserField = new JTextField(config.getProperty("mysql.user", "root"), 20);
        panel.add(mysqlUserField, gbc);

        // 密码
        gbc.gridx = 0;
        gbc.gridy = 3;
        panel.add(new JLabel("密码:"), gbc);

        gbc.gridx = 1;
        mysqlPwdField = new JPasswordField(config.getProperty("mysql.password", ""), 20);
        panel.add(mysqlPwdField, gbc);

        return panel;
    }

    private JPanel createMappingPanel() {
        JPanel panel = new JPanel(new BorderLayout());

        // 创建一个简单的字段映射表
        String[] columnNames = {"Oracle 类型", "MySQL 类型"};
        Object[][] data = {
                {"VARCHAR2", "VARCHAR"},
                {"NVARCHAR2", "VARCHAR"},
                {"CHAR", "CHAR"},
                {"NCHAR", "CHAR"},
                {"NUMBER", "DECIMAL"},
                {"INTEGER", "INT"},
                {"DATE", "DATETIME"},
                {"TIMESTAMP", "DATETIME"},
                {"CLOB", "TEXT"},
                {"BLOB", "BLOB"}
        };

        JTable mappingTable = new JTable(data, columnNames);
        JScrollPane scrollPane = new JScrollPane(mappingTable);

        panel.add(scrollPane, BorderLayout.CENTER);
        return panel;
    }

    private JPanel createOtherConfigPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 10));

        dropOldTableCheckBox = new JCheckBox("删除旧表");
        dropOldTableCheckBox.setSelected(true);
        dropOldTableCheckBox.setFont(new Font("微软雅黑", Font.PLAIN, 14));

        migrateForeignKeysCheckBox = new JCheckBox("迁移外键");
        migrateForeignKeysCheckBox.setSelected(true);
        migrateForeignKeysCheckBox.setFont(new Font("微软雅黑", Font.PLAIN, 14));

        panel.add(dropOldTableCheckBox);
        panel.add(migrateForeignKeysCheckBox);

        return panel;
    }

    private JPanel createBottomPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.CENTER, 50, 15));

        JButton migrateButton = new JButton("开始迁移");
        migrateButton.setFont(new Font("微软雅黑", Font.BOLD, 16));
        migrateButton.setForeground(Color.WHITE);
        migrateButton.setBackground(new Color(41, 128, 185));
        migrateButton.setPreferredSize(new Dimension(200, 50));
        migrateButton.addActionListener(e -> doMigration());

        JButton testButton = new JButton("测试连接");
        testButton.setFont(new Font("微软雅黑", Font.BOLD, 16));
        testButton.setForeground(Color.WHITE);
        testButton.setBackground(new Color(39, 174, 96));
        testButton.setPreferredSize(new Dimension(200, 50));
        testButton.addActionListener(e -> {
            saveCurrentConfig();
            connectionManager.initializeConnections();
        });

        panel.add(testButton);
        panel.add(migrateButton);

        return panel;
    }

    private void doMigration() {
        saveCurrentConfig();

        String tableNames = tableFilterField.getText();
        if (tableNames == null || tableNames.trim().isEmpty()) {
            JOptionPane.showMessageDialog(frame, "请输入要迁移的表名！", "错误", JOptionPane.ERROR_MESSAGE);
            return;
        }

        String[] tables = tableNames.split(",");
        for (int i = 0; i < tables.length; i++) {
            tables[i] = tables[i].trim();
        }

        // 检查连接
        Connection oracleConn = connectionManager.getOracleConn();
        Connection mysqlConn = connectionManager.getMysqlConn();

        if (oracleConn == null || mysqlConn == null) {
            JOptionPane.showMessageDialog(frame, "数据库连接不可用，请先测试连接！", "错误", JOptionPane.ERROR_MESSAGE);
            return;
        }

        // 执行迁移
        TableMigrator migrator = new TableMigrator(oracleConn, mysqlConn, logArea);
        migrator.setDropOldTable(dropOldTableCheckBox.isSelected());
        migrator.setMigrateForeignKeys(migrateForeignKeysCheckBox.isSelected());

        try {
            log("开始迁移表结构...");
            migrator.migrateTables(tables);
            log("✅ 表结构迁移完成！");
        } catch (Exception ex) {
            log("❌ 迁移过程中发生错误: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    private void saveCurrentConfig() {
        config.setProperty("oracle.host", oracleHostField.getText());
        config.setProperty("oracle.port", oraclePortField.getText());
        config.setProperty("oracle.sid", oracleSIDField.getText());
        config.setProperty("oracle.user", oracleUserField.getText());
        config.setProperty("oracle.password", new String(oraclePwdField.getPassword()));

        config.setProperty("mysql.url", mysqlUrlField.getText());
        config.setProperty("mysql.user", mysqlUserField.getText());
        config.setProperty("mysql.password", new String(mysqlPwdField.getPassword()));

        log("当前配置已保存");
    }

    private void log(String message) {
        logArea.append(message + "\n");
        logArea.setCaretPosition(logArea.getDocument().getLength());
    }
}