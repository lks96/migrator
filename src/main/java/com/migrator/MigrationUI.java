package com.migrator;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.sql.*;
import java.util.List;
import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class MigrationUI {
    // 新增表名过滤输入框
    private JTextField tableFilterField,
            oracleHostField, oraclePortField, oracleSIDField, oracleUserField,
            mysqlUrlField, mysqlUserField,mysqlDbNameField;
    private JPasswordField oraclePwdField,mysqlPwdField;
    private JComboBox<String> oracleConnectModeBox;
    private JTextArea logArea = new JTextArea(20, 40);
    private DefaultTableModel mappingTableModel;
    // 新增：其他配置的复选框
    private JCheckBox dropOldTableCheckBox ,migrateForeignKeysCheckBox;

    // 新增连接对象成员变量
    private Connection oracleConn ,mysqlConn;

    // 监听配置是否修改
    private boolean oracleChange = false;
    private boolean mysqlChange = false;

    private Properties config = new Properties();

    private void loadExternalConfig() {
        File configFile = new File("app/conf/migrator.properties");
        if (!configFile.exists()) {
            log("⚠️ 未找到配置文件: " + configFile.getAbsolutePath());
            return;
        }

        try (FileInputStream fis = new FileInputStream(configFile)) {
            config.load(fis);
            log("✅ 已加载外部配置: " + configFile.getAbsolutePath());
        } catch (IOException e) {
            log("❌ 配置文件读取失败: " + e.getMessage());
        }
    }

    // 初始化数据库连接
    private void initializeConnections() {
        new SwingWorker<Void, String>() {
            @Override
            protected Void doInBackground() throws Exception {
                publish("正在初始化数据库连接...");

                // 关闭现有连接（如果存在）
                closeConnections();

                try {
                    // 创建Oracle连接
                    connectOracle();
                    publish("✅ Oracle 连接成功（已保存）");

                    // 创建MySQL连接
                    connectMysql();
                    publish("✅ MySQL 连接成功（已保存）");

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

    // 关闭连接的方法
    private void closeConnections() {
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

    public void createAndShowGUI() {
        loadExternalConfig();
        JFrame frame = new JFrame("Oracle → MySQL 表结构迁移工具");
        BufferedImage iconImage = null;
        try {
            String iconPath = config.getProperty("icon.path");
            if (iconPath != null && !iconPath.isEmpty()) {
                iconImage = ImageIO.read(new File(iconPath));
                frame.setIconImage(iconImage);
                log("✅ 已加载图标: " + iconPath);
            } else {
                log("⚠️ icon.path 未设置，跳过图标设置");
            }
        } catch (IOException e) {
            log("⚠️ 图标加载失败: " + e.getMessage());
        }

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(1080, 750); // 稍微增加高度以容纳新组件
        frame.setLayout(new BorderLayout());

        // 创建顶部过滤面板
        JPanel filterPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        filterPanel.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createEmptyBorder(10, 10, 5, 10),
                BorderFactory.createTitledBorder("表过滤设置")
        ));
        filterPanel.setBackground(new Color(240, 240, 245));

        JLabel filterLabel = new JLabel("指定迁移的表名 (多个用逗号分隔):");
        filterLabel.setFont(new Font("微软雅黑", Font.BOLD, 14));
        tableFilterField = new JTextField(50);
        tableFilterField.setFont(new Font("微软雅黑", Font.PLAIN, 14));
        tableFilterField.setToolTipText("例如: EMPLOYEE,DEPARTMENT,PROJECT");

        filterPanel.add(filterLabel);
        filterPanel.add(tableFilterField);

        frame.add(filterPanel, BorderLayout.NORTH); // 添加到顶部

        // 创建配置标签页（保持不变）
        JTabbedPane configTabbedPane = new JTabbedPane();
        configTabbedPane.setFont(new Font("微软雅黑", Font.BOLD, 16));

        // 添加三个独立的配置标签页（保持不变）
        configTabbedPane.addTab("Oracle 配置", createOracleDbPanel());
        configTabbedPane.addTab("MySQL 配置", createMySqlDbPanel());
        configTabbedPane.addTab("字段映射配置", createMappingPanel());
        configTabbedPane.addTab("其他配置", createOtherConfigPanel());

        // ✅ 所有组件构建完成后再加载配置值
        applyConfigToUI();

        // 日志区域（保持不变）
        logArea.setEditable(false);
        logArea.setFont(new Font("Monospaced", Font.PLAIN, 14));
        logArea.setForeground(Color.BLACK);
        logArea.setBackground(Color.WHITE);
        JScrollPane logScrollPane = new JScrollPane(logArea);
        logScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);

        // 左边面板（保持不变）
        JPanel leftPanel = new JPanel(new BorderLayout());
        leftPanel.add(configTabbedPane, BorderLayout.CENTER);

        // 右边日志控制台（保持不变）
        JPanel rightPanel = new JPanel(new BorderLayout());
        rightPanel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(41, 128, 185), 2),
                "日志控制台",
                TitledBorder.LEFT,
                TitledBorder.TOP,
                new Font("微软雅黑", Font.BOLD, 16),
                new Color(41, 128, 185)
        ));
        rightPanel.add(logScrollPane, BorderLayout.CENTER);

        // 分割布局（保持不变）
        JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        splitPane.setLeftComponent(leftPanel);
        splitPane.setRightComponent(rightPanel);
        splitPane.setDividerLocation(450);
        splitPane.setResizeWeight(0.7);

        // 底部按钮面板（保持不变）
        JPanel bottomPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 30, 10));

        JButton migrateButton = new JButton("开始迁移");
        migrateButton.setFont(new Font("微软雅黑", Font.BOLD, 16));
        migrateButton.setForeground(Color.WHITE);
        migrateButton.setBackground(new Color(41, 128, 185));
        migrateButton.setPreferredSize(new Dimension(200, 50));
        migrateButton.addActionListener(e -> doMigration());
        bottomPanel.add(migrateButton);

        JButton testButton = new JButton("测试连接");
        testButton.setFont(new Font("微软雅黑", Font.BOLD, 16));
        testButton.setForeground(Color.WHITE);
        testButton.setBackground(new Color(39, 174, 96));
        testButton.setPreferredSize(new Dimension(200, 50));
        testButton.addActionListener(e ->{
            testConnections();
            saveCurrentConfig();
        });
        bottomPanel.add(testButton);

        frame.add(splitPane, BorderLayout.CENTER);
        frame.add(bottomPanel, BorderLayout.SOUTH);


        // 设置窗口在初始化时居中显示
        int x = (Toolkit.getDefaultToolkit().getScreenSize().width - frame.getWidth()) / 2;
        int y = (Toolkit.getDefaultToolkit().getScreenSize().height - frame.getHeight()) / 2;
        frame.setLocation(x, y);
        // 设置默认关闭操作
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);

        initializeConnections();
        setupConnectionListeners();
    }

    // 创建映射配置面板
    private JPanel createMappingPanel() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // 创建表格模型
        String[] columnNames = {"Oracle 类型", "MySQL 类型"};
        mappingTableModel = new DefaultTableModel(columnNames, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return true; // 允许编辑
            }
        };

        // 添加默认映射
        mappingTableModel.addRow(new Object[]{"DATE", "DATETIME"});
        mappingTableModel.addRow(new Object[]{"CLOB", "LONGTEXT"});
        mappingTableModel.addRow(new Object[]{"BLOB", "LONGBLOB"});


        JTable table = new JTable(mappingTableModel);
        table.setFont(new Font("微软雅黑", Font.PLAIN, 14));
        table.setRowHeight(25);

        // 添加列宽调整
        table.getColumnModel().getColumn(0).setPreferredWidth(150);
        table.getColumnModel().getColumn(1).setPreferredWidth(250);

        // 添加按钮面板
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));

        JButton addButton = new JButton("添加新映射");
        addButton.setFont(new Font("微软雅黑", Font.BOLD, 14));
        addButton.addActionListener(e -> mappingTableModel.addRow(new Object[]{"", ""}));
        buttonPanel.add(addButton);

        JButton resetButton = new JButton("恢复默认");
        resetButton.setFont(new Font("微软雅黑", Font.BOLD, 14));
        resetButton.addActionListener(e -> resetMappingsToDefault());
        buttonPanel.add(resetButton);

        JButton deleteButton = new JButton("删除选中");
        deleteButton.setFont(new Font("微软雅黑", Font.BOLD, 14));
        deleteButton.addActionListener(e -> {
            int row = table.getSelectedRow();
            if (row >= 0) {
                mappingTableModel.removeRow(row);
            } else {
                JOptionPane.showMessageDialog(null, "请先选择要删除的行", "提示", JOptionPane.WARNING_MESSAGE);
            }
        });
        buttonPanel.add(deleteButton);

        // 添加帮助说明
        JTextArea helpArea = new JTextArea();
        helpArea.setText("使用说明：\n"
                + "1. 添加自定义类型映射关系\n"
                + "3. 点击'恢复默认'可重置为初始映射");
        helpArea.setEditable(false);
        helpArea.setFont(new Font("微软雅黑", Font.PLAIN, 12));
        helpArea.setBackground(new Color(240, 240, 240));
        helpArea.setForeground(Color.DARK_GRAY);
        helpArea.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JPanel bottomPanel = new JPanel(new BorderLayout());
        bottomPanel.add(buttonPanel, BorderLayout.NORTH);
        bottomPanel.add(helpArea, BorderLayout.CENTER);

        panel.add(new JScrollPane(table), BorderLayout.CENTER);
        panel.add(bottomPanel, BorderLayout.SOUTH);

        return panel;
    }

    // 新增方法：创建其他配置面板
    private JPanel createOtherConfigPanel() {
        JPanel panel = new JPanel();
        panel.setLayout(new GridBagLayout());
        panel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(41, 128, 185), 2),
                "其他迁移配置",
                TitledBorder.LEFT,
                TitledBorder.TOP,
                new Font("微软雅黑", Font.BOLD, 16),
                new Color(41, 128, 185)
        ));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);
        gbc.anchor = GridBagConstraints.WEST;
        gbc.gridx = 0;
        gbc.gridy = 0;

        // 1. 创建“建表时删除旧表”复选框
        dropOldTableCheckBox = new JCheckBox("建表时删除旧表 (Drop table if exists)");
        dropOldTableCheckBox.setFont(new Font("微软雅黑", Font.PLAIN, 14));
        dropOldTableCheckBox.setToolTipText("如果勾选，将在创建新表前尝试删除MySQL中已存在的同名表");
        dropOldTableCheckBox.setSelected(false); // 默认不勾选
        panel.add(dropOldTableCheckBox, gbc);

        // 2. 创建“迁移外键约束”复选框
        gbc.gridy = 1;
        migrateForeignKeysCheckBox = new JCheckBox("迁移外键约束");
        migrateForeignKeysCheckBox.setFont(new Font("微软雅黑", Font.PLAIN, 14));
        migrateForeignKeysCheckBox.setToolTipText("如果勾选，将尝试迁移Oracle表的外键到MySQL");
        migrateForeignKeysCheckBox.setSelected(true); // 默认勾选
        panel.add(migrateForeignKeysCheckBox, gbc);

        // 添加一个占位的空组件，让布局更美观
        gbc.gridy = 2;
        gbc.weighty = 1.0;
        panel.add(new JLabel(), gbc);

        return panel;
    }

    // 恢复默认映射
    private void resetMappingsToDefault() {
        int response = JOptionPane.showConfirmDialog(
                null,
                "确定要恢复默认映射设置吗？",
                "恢复默认配置",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.QUESTION_MESSAGE);

        if (response == JOptionPane.YES_OPTION) {
            mappingTableModel.setRowCount(0); // 清空现有映射
            mappingTableModel.addRow(new Object[]{"DATE", "DATETIME"});
            mappingTableModel.addRow(new Object[]{"CLOB", "LONGTEXT"});
            mappingTableModel.addRow(new Object[]{"BLOB", "LONGBLOB"});
        }
    }

    // 修改类型映射方法使用表格模型
    private String mapOracleTypeToMySQL(String oracleType, int length, int precision, int scale) {
        String oracleTypeUpper = oracleType.toUpperCase();

        // 首先检查是否有精确匹配
        for (int i = 0; i < mappingTableModel.getRowCount(); i++) {
            String tableOracleType = (String) mappingTableModel.getValueAt(i, 0);
            String oracleTypeUpperTmp = oracleTypeUpper;
            if(length != 0){
                oracleTypeUpperTmp = oracleTypeUpperTmp+"("+length+")".trim();
            }
            if (tableOracleType.equalsIgnoreCase(oracleTypeUpperTmp)) {
                return (String) mappingTableModel.getValueAt(i, 1);
            }
        }

        // TIMESTAMP处理
        if (oracleTypeUpper.startsWith("TIMESTAMP(")) {
            // 获取字符串部分
            oracleTypeUpper = "TIMESTAMP";
        }


        switch (oracleTypeUpper) {
            case "VARCHAR2":
            case "NVARCHAR2":
                return length <= 16383 ? "VARCHAR(" + length + ")" : "TEXT"; // MySQL VARCHAR max is 65535 bytes, but one char can be > 1 byte. 16383 is a safe limit for utf8mb4.
            case "CHAR":
            case "NCHAR":
                return "CHAR(" + length + ")";
            case "NUMBER":
                if (scale > 0) {
                    return "DECIMAL(" + (precision > 0 ? precision : 20) + "," + scale + ")";
                }
                if (precision == 0) return "BIGINT";
                if (precision <= 3) return "TINYINT";
                if (precision <= 5) return "SMALLINT";
                if (precision <= 9) return "INT";
                if (precision <= 18) return "BIGINT";
                return "DECIMAL(" + precision + ",0)";
            case "DATE":
                return "DATETIME";
            case "TIMESTAMP":
                return oracleType; // MySQL supports TIMESTAMP with fractional seconds
            case "CLOB":
            case "NCLOB":
                return "LONGTEXT";
            case "BLOB":
                return "LONGBLOB";
            default:
                log("未找到映射的 Oracle 类型: " + oracleTypeUpper + "，使用默认 VARCHAR(255)");
                return "VARCHAR(255)";
        }
    }

    // 创建 oracle 配置面板
    private JPanel createOracleDbPanel() {
        JPanel panel = new JPanel();
        panel.setLayout(new GridBagLayout());
        panel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(41, 128, 185), 2),
                "Oracle 数据库配置",
                TitledBorder.LEFT,
                TitledBorder.TOP,
                new Font("微软雅黑", Font.BOLD, 16), // 设置支持中文的字体
                new Color(41, 128, 185)
        ));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);
        gbc.anchor = GridBagConstraints.WEST;

        oracleHostField = createTextField(config.getProperty("oracle.host", "127.0.0.1"));
        oraclePortField = createTextField(config.getProperty("oracle.port", "1521"));
        oracleSIDField = createTextField(config.getProperty("oracle.sid", ""));
        oracleUserField = createTextField(config.getProperty("oracle.user", ""));
        oraclePwdField = createPasswordField();
        oraclePwdField.setText(config.getProperty("oracle.password", ""));
        oracleConnectModeBox = new JComboBox<>(new String[]{"SID", "SERVICE_NAME"});
        oracleConnectModeBox.setFont(new Font("微软雅黑", Font.PLAIN, 14));
        oracleConnectModeBox.setSelectedItem(config.getProperty("oracle.connectMode", "SID"));



        // 添加标签和文本框
        addLabelAndField(panel, gbc, "主机:", oracleHostField, 0);
        addLabelAndField(panel, gbc, "端口:", oraclePortField, 1);
        addLabelAndField(panel, gbc, "SID / 服务名:", oracleSIDField, 2);
        addLabelAndField(panel, gbc, "连接方式:", oracleConnectModeBox, 3); // ✅ 新增
        addLabelAndField(panel, gbc, "用户名:", oracleUserField, 4);
        addLabelAndField(panel, gbc, "密码:", oraclePwdField, 5);


        return panel;
    }

    // 创建 mysql 配置面板
    private JPanel createMySqlDbPanel() {
        JPanel panel = new JPanel();
        panel.setLayout(new GridBagLayout());
        panel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(41, 128, 185), 2),
                "MySQL 数据库配置",
                TitledBorder.LEFT,
                TitledBorder.TOP,
                new Font("微软雅黑", Font.BOLD, 16), // 设置支持中文的字体
                new Color(41, 128, 185)
        ));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);
        gbc.anchor = GridBagConstraints.WEST;

        String mysqlHost = config.getProperty("mysql.host", "127.0.0.1");
        String mysqlPort = config.getProperty("mysql.port", "3306");
        mysqlUrlField = createTextField(mysqlHost + ":" + mysqlPort);

        mysqlDbNameField = createTextField(config.getProperty("mysql.dbname", ""));
        mysqlUserField = createTextField(config.getProperty("mysql.user", ""));
        mysqlPwdField = createPasswordField();
        mysqlPwdField.setText(config.getProperty("mysql.password", ""));


        // 添加标签和文本框
        addLabelAndField(panel, gbc, "主机:", mysqlUrlField, 0);
        addLabelAndField(panel, gbc, "库名:", mysqlDbNameField, 1);
        addLabelAndField(panel, gbc, "用户名:", mysqlUserField, 2);
        addLabelAndField(panel, gbc, "密码:", mysqlPwdField, 3);

        return panel;
    }

    private JTextField createTextField(String text) {
        JTextField field = new JTextField(text, 20);
        field.setFont(new Font("Arial", Font.PLAIN, 14));
        field.setBorder(BorderFactory.createLineBorder(Color.LIGHT_GRAY));
        return field;
    }

    private JPasswordField createPasswordField() {
        JPasswordField field = new JPasswordField(20);
        field.setFont(new Font("Arial", Font.PLAIN, 14));
        field.setBorder(BorderFactory.createLineBorder(Color.LIGHT_GRAY));
        return field;
    }

    private void addLabelAndField(JPanel panel, GridBagConstraints gbc, String labelText, JComponent field, int gridy){
        JLabel label = new JLabel(labelText);
        label.setFont(new Font("微软雅黑", Font.BOLD, 14)); // 设置支持中文的字体
        label.setForeground(Color.DARK_GRAY);

        gbc.gridx = 0;
        gbc.gridy = gridy;
        panel.add(label, gbc);

        gbc.gridx = 1;
        gbc.gridy = gridy;
        panel.add(field, gbc);
    }

    private String clobToString(Clob clob) throws SQLException, IOException {
        if (clob == null) return null;
        StringBuilder sb = new StringBuilder();
        Reader reader = clob.getCharacterStream();
        char[] buffer = new char[1024];
        int len;
        while ((len = reader.read(buffer)) != -1) {
            sb.append(buffer, 0, len);
        }
        return sb.toString();
    }

    // 修改doMigration方法以支持表过滤
    private void doMigration() {
        logArea.append("=====================================================\n");
        logArea.append("开始迁移...\n");
        JProgressBar progressBar = new JProgressBar(0, 100);
        progressBar.setStringPainted(true);
        progressBar.setFont(new Font("微软雅黑", Font.PLAIN, 14));

        JDialog progressDialog = new JDialog((Frame) null, "迁移进度", true);
        progressDialog.getContentPane().add(progressBar);
        progressDialog.setSize(400, 80);
        progressDialog.setLocationRelativeTo(null);


        // ✅ 完整 migrationWorker 实现（含结构+数据迁移、进度条、回滚、失败导出、索引重建）
        SwingWorker<Void, Void> migrationWorker = new SwingWorker<Void, Void>() {
            @Override
            protected Void doInBackground() throws Exception {
                List<String> allTableNames = new ArrayList<>();
                List<String> filteredTableNames = new ArrayList<>();
                Set<String> selectedTables;

                checkChange();
                if (oracleConn == null || oracleConn.isClosed()) connectOracle();
                if (mysqlConn == null || mysqlConn.isClosed()) connectMysql();

                DatabaseMetaData meta = oracleConn.getMetaData();
                ResultSet tables = meta.getTables(null, oracleUserField.getText().toUpperCase(), "%", new String[]{"TABLE"});
                while (tables.next()) allTableNames.add(tables.getString("TABLE_NAME"));
                String filterText = tableFilterField.getText().trim();
                if (!filterText.isEmpty()) {
                    String[] patterns = filterText.split(",");
                    Set<String> matched = new HashSet<>();
                    for (String pattern : patterns) {
                        pattern = pattern.trim();
                        try {
                            Pattern regex = Pattern.compile(pattern, Pattern.CASE_INSENSITIVE); // 👈 忽略大小写
                            for (String table : allTableNames) {
                                if (regex.matcher(table).find()) {
                                    matched.add(table);
                                }
                            }
                        } catch (PatternSyntaxException e) {
                            log("⚠️ 正则表达式无效: " + pattern + "，将忽略该项");
                        }
                    }
                    logArea.append("匹配到 " + matched.size() + " 张表。");
                    selectedTables = matched;
                } else {
                    TableSelectionDialog dialog = new TableSelectionDialog(null, allTableNames);
                    dialog.setVisible(true);
                    selectedTables = dialog.getSelectedTables();
                }


                if (selectedTables.isEmpty()) {
                    log("未选择任何表，迁移已取消。");
                    return null;
                }

                // 选择迁移类型（结构/数据/全部）
                String[] options = {"仅迁移结构", "仅迁移数据", "结构+数据"};
                int choice = JOptionPane.showOptionDialog(null, "请选择迁移内容：", "迁移类型",
                        JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE, null, options, options[2]);

                boolean migrateStructure = (choice == 0 || choice == 2);
                boolean migrateData = (choice == 1 || choice == 2);

                int tableIndex = 0;
                int totalTables = selectedTables.size();
                JProgressBar progressBar = new JProgressBar(0, 100);
                progressBar.setStringPainted(true);
                for (String tableName : selectedTables) {
                    tableIndex++;
                    int percent = (int)(((double) tableIndex / totalTables) * 100);
                    SwingUtilities.invokeLater(() -> progressBar.setValue(percent));
                    logArea.append(tableIndex+"/"+totalTables+"\n");
                    try {
                        mysqlConn.setAutoCommit(false);

                        if (migrateStructure) {
                            try(Statement stmt = mysqlConn.createStatement()) {
                                // 忽略外键
                                stmt.execute("SET FOREIGN_KEY_CHECKS=0");

                                if (dropOldTableCheckBox.isSelected()) {
                                    stmt.execute("DROP TABLE IF EXISTS `" + tableName.toLowerCase() + "`");
                                    log("✅ 旧表已删除: " + tableName);
                                }
                                String createSQL = generateCreateTableSQL(oracleConn, tableName);
                                try{
                                    stmt.execute(createSQL);
                                }catch (Exception exception){
                                    // 如果是 ROW size too large
                                    if(exception.getMessage().startsWith("Row size too large.")){
                                        // 将错判的建表语句 导出到错误文件中
                                        errorSql(createSQL);
                                        continue;
                                    }
                                }
                                successSql(createSQL);
                                log("✅ 表创建成功: " + tableName);
                                if (migrateForeignKeysCheckBox.isSelected()) {
                                    migrateForeignKeys(oracleConn, mysqlConn, tableName);
                                }
                            }
                        }

                        if (migrateData) {
                            log("开始迁移数据: " + tableName);
                            String lowerCaseTableName = tableName.toLowerCase();

                            try (Statement oracleStmt = oracleConn.createStatement();
                                 ResultSet rs = oracleStmt.executeQuery("SELECT * FROM " + tableName)) {

                                ResultSetMetaData metaData = rs.getMetaData();
                                int columnCount = metaData.getColumnCount();

                                // Build the PreparedStatement SQL
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

                                    while (rs.next()) {
                                        Object val = null;  // ✅ 必须先定义
                                        // ############### MODIFICATION START: ADDED DETAILED LOGGING ###############
                                        List<String> rowDataForLogging = new ArrayList<>();
                                        for (int i = 1; i <= columnCount; i++) {
                                            // start
                                            // 设置参数值（按字段类型分类）
                                            String columnType = metaData.getColumnTypeName(i).toUpperCase();

                                            switch (columnType) {
                                                case "CLOB":
                                                case "NCLOB":
                                                    Clob clob = rs.getClob(i);
                                                    if (clob != null) {
                                                        val = clobToString(clob);
                                                    } else {
                                                        val = null;
                                                    }
                                                    mysqlPstmt.setString(i, (String) val);
                                                    break;

                                                case "BLOB":
                                                    Blob blob = rs.getBlob(i);
                                                    if (blob != null) {
                                                        val = blob.getBytes(1, (int) blob.length());
                                                    } else {
                                                        val = null;
                                                    }
                                                    mysqlPstmt.setBytes(i, (byte[]) val);
                                                    break;

                                                case "DATE":
                                                case "TIMESTAMP":
                                                    Timestamp ts = rs.getTimestamp(i);
                                                    mysqlPstmt.setTimestamp(i, ts);
                                                    val = ts;
                                                    break;

                                                case "NUMBER":
                                                    BigDecimal number = rs.getBigDecimal(i);
                                                    mysqlPstmt.setBigDecimal(i, number);
                                                    val = number;
                                                    break;

                                                default:
                                                    val = rs.getObject(i);

                                                    // 自动反序列化 Java 对象（如果是 Object 序列化）
                                                    if (val instanceof byte[]) {
                                                        byte[] bytes = (byte[]) val;
                                                        if (bytes.length > 4 && bytes[0] == (byte) 0xAC && bytes[1] == (byte) 0xED) {
                                                            try (ByteArrayInputStream bais = new ByteArrayInputStream(bytes);
                                                                 ObjectInputStream ois = new ObjectInputStream(bais)) {
                                                                val = ois.readObject();
                                                            } catch (Exception e) {
                                                                // 反序列化失败，保留原始字节
                                                            }
                                                        }
                                                    }

                                                    mysqlPstmt.setObject(i, val);
                                                    break;
                                            }

                                            // 日志处理（保持原样）
                                            String loggedValue;
                                            if (val == null) {
                                                loggedValue = "NULL";
                                            } else if (val instanceof byte[]) {
                                                loggedValue = "byte[" + ((byte[]) val).length + "]";
                                            } else {
                                                loggedValue = val.toString();
                                            }
                                            if (loggedValue.length() > 100) {
                                                loggedValue = loggedValue.substring(0, 97) + "...";
                                            }
                                            rowDataForLogging.add(metaData.getColumnName(i) + "(" + columnType + "): [" + loggedValue + "]");

                                            // end
                                        }

                                        // Log the data for the current row BEFORE adding to batch
                                        log("  -> 准备行: " + String.join(" | ", rowDataForLogging));
                                        // ############### MODIFICATION END ###############

                                        mysqlPstmt.addBatch();
                                        batchCount++;

                                        if (batchCount % BATCH_SIZE == 0) {
                                            try {
                                                mysqlPstmt.executeBatch();
                                                mysqlConn.commit();
                                            } catch (SQLException ex) {
                                                log("❌ 批量插入失败 (" + tableName + "): " + ex.getMessage());
                                                log("❌ 请检查上一条 '准备行' 日志以定位问题数据。");
                                                mysqlConn.rollback();
                                            }
                                            mysqlPstmt.clearBatch();
                                        }
                                    }

                                    // Insert remaining records
                                    try {
                                        mysqlPstmt.executeBatch();
                                        mysqlConn.commit();
                                    } catch (SQLException ex) {
                                        log("❌ 批量插入失败 (" + tableName + "): " + ex.getMessage());
                                        log("❌ 请检查上一条 '准备行' 日志以定位问题数据。");
                                        mysqlConn.rollback();
                                    }
                                }
                                log("✅ 数据迁移完成: " + tableName);
                            }
                        }

                        if (migrateStructure) {
                            try(Statement stmt = mysqlConn.createStatement()) {
                                Map<String, List<String>> indexMap = new HashMap<>();
                                ResultSet idxRs = oracleConn.createStatement().executeQuery(
                                        "SELECT index_name, column_name FROM all_ind_columns WHERE table_owner = '" + oracleUserField.getText().toUpperCase() + "' AND table_name = '" + tableName + "'");
                                while (idxRs.next()) {
                                    String idx = idxRs.getString("index_name").toLowerCase();
                                    String col = idxRs.getString("column_name").toLowerCase();
                                    indexMap.computeIfAbsent(idx, k -> new ArrayList<>()).add(col);
                                }
                                for (Map.Entry<String, List<String>> entry : indexMap.entrySet()) {
                                    String idxName = entry.getKey();
                                    List<String> cols = entry.getValue();
                                    String sql = "CREATE INDEX `idx_" + idxName + "` ON `" + tableName.toLowerCase() + "` (" +
                                            String.join(", ", cols.stream().map(c -> "`" + c + "`").toArray(String[]::new)) + ")";
                                    try {
                                        stmt.execute(sql);
                                        log("✅ 索引已重建: " + sql);
                                    } catch (SQLException ex) {
                                        errorSql(sql+";");
                                        log("⚠️ 索引创建失败: " + sql + " - " + ex.getMessage());
                                        continue;
                                    }
                                    successSql(sql+";");
                                }
                            }
                        }

                        mysqlConn.commit();
                        log("✅ 已提交事务: " + tableName);

                    } catch (Exception ex) {
                        mysqlConn.rollback();
                        log("❌ 异常回滚 ("+ tableName +"): " + ex.getMessage());
                        ex.printStackTrace(); // Print stack trace for detailed debugging
                    } finally {
                        mysqlConn.setAutoCommit(true);
                    }
                }
                return null;
            }
            @Override
            protected void done() {
                // 在任务完成时关闭进度弹窗
                SwingUtilities.invokeLater(() -> {
                    progressDialog.dispose();
                    JOptionPane.showMessageDialog(null, "✅ 所有表迁移完成", "完成", JOptionPane.INFORMATION_MESSAGE);
                });
            }
        };
        migrationWorker.execute();
    }

    // 迁移外键约束
    private void migrateForeignKeys(Connection oracleConn, Connection mysqlConn, String tableName) {
        try {
            List<String> fkStatements = new ArrayList<>();

            // 获取外键信息
            try (PreparedStatement fkStmt = oracleConn.prepareStatement(
                    "SELECT a.constraint_name, a.r_constraint_name, " +
                            "       c.column_name AS local_column, " +
                            "       r.table_name AS ref_table, " +
                            "       d.column_name AS ref_column " +
                            "FROM all_constraints a " +
                            "JOIN all_cons_columns c ON a.constraint_name = c.constraint_name " +
                            "JOIN all_constraints r ON a.r_constraint_name = r.constraint_name " +
                            "JOIN all_cons_columns d ON r.constraint_name = d.constraint_name " +
                            "WHERE a.constraint_type = 'R' " +
                            "AND a.owner = ? " +
                            "AND a.table_name = ?")) {

                fkStmt.setString(1, oracleUserField.getText().toUpperCase());
                fkStmt.setString(2, tableName);
                try(ResultSet fkRs = fkStmt.executeQuery()){
                    while (fkRs.next()) {
                        String constraintName = fkRs.getString("constraint_name");
                        String localColumn = fkRs.getString("local_column");
                        String refTable = fkRs.getString("ref_table");
                        String refColumn = fkRs.getString("ref_column");

                        String fkSQL = "ALTER TABLE `" + tableName.toLowerCase() + "` " +
                                "ADD CONSTRAINT `fk_" + constraintName.toLowerCase() + "` " +
                                "FOREIGN KEY (`" + localColumn.toLowerCase() + "`) " +
                                "REFERENCES `" + refTable.toLowerCase() + "` (`" + refColumn.toLowerCase() + "`) " +
                                "ON DELETE CASCADE ON UPDATE CASCADE";

                        fkStatements.add(fkSQL);
                    }
                }
            }

            // 执行外键创建
            for (String fkSQL : fkStatements) {
                try (Statement stmt = mysqlConn.createStatement()) {
                    stmt.execute(fkSQL);
                    log("✅ 外键创建成功: " + fkSQL.substring(0, Math.min(fkSQL.length(), 100)) + "...");
                } catch (SQLException ex) {
                    log("⚠️ 外键创建失败: " + fkSQL + " - " + ex.getMessage());
                }
            }

        } catch (SQLException ex) {
            log("❌ 获取外键信息失败: " + ex.getMessage());
        }
    }

    private String generateCreateTableSQL(Connection oracleConn, String tableName) throws SQLException {
        // 获取表注释
        String tableComment = "";
        try (PreparedStatement ps = oracleConn.prepareStatement(
                "SELECT COMMENTS FROM ALL_TAB_COMMENTS WHERE OWNER = ? AND TABLE_NAME = ?")) {
            ps.setString(1, oracleUserField.getText().toUpperCase());
            ps.setString(2, tableName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                tableComment = rs.getString("COMMENTS");
            }
        }

        StringBuilder sb = new StringBuilder("CREATE TABLE `" + tableName.toLowerCase() + "` (\n");

        // 获取列信息及列注释
        String sql = "SELECT c.COLUMN_NAME, c.DATA_TYPE, c.DATA_LENGTH, c.DATA_PRECISION, c.DATA_SCALE, " +
                "cc.COMMENTS, c.DATA_DEFAULT " +
                "FROM ALL_TAB_COLUMNS c " +
                "LEFT JOIN ALL_COL_COMMENTS cc " +
                "  ON c.OWNER = cc.OWNER " +
                " AND c.TABLE_NAME = cc.TABLE_NAME " +
                " AND c.COLUMN_NAME = cc.COLUMN_NAME " +
                "WHERE c.OWNER = ? AND c.TABLE_NAME = ?";

        try (PreparedStatement ps = oracleConn.prepareStatement(sql)) {
            ps.setString(1, oracleUserField.getText().toUpperCase());
            ps.setString(2, tableName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String col = rs.getString("COLUMN_NAME");
                String dataType = rs.getString("DATA_TYPE");
                int dataLength = rs.getInt("DATA_LENGTH");
                int dataPrecision = rs.getInt("DATA_PRECISION");
                int dataScale = rs.getInt("DATA_SCALE");
                String comment = rs.getString("COMMENTS");
                String defaultValue = rs.getString("DATA_DEFAULT");

                String mappedType = mapOracleTypeToMySQL(dataType, dataLength, dataPrecision, dataScale);

                sb.append("  `").append(col.toLowerCase()).append("` ").append(mappedType);

                if (defaultValue != null && !defaultValue.trim().isEmpty()) {
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

        // 主键、唯一约束、索引部分不变
        List<String> primaryKeys = new ArrayList<>();
        List<String> uniqueColumns = new ArrayList<>();
        Map<String, List<String>> indexes = new HashMap<>();

        // 获取主键
        try (PreparedStatement pkStmt = oracleConn.prepareStatement(
                "SELECT cols.column_name FROM all_constraints cons, all_cons_columns cols " +
                        "WHERE cons.constraint_type = 'P' AND cons.owner = ? AND cons.table_name = ? " +
                        "AND cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner")) {
            pkStmt.setString(1, oracleUserField.getText().toUpperCase());
            pkStmt.setString(2, tableName);
            ResultSet pkRs = pkStmt.executeQuery();
            while (pkRs.next()) {
                primaryKeys.add(pkRs.getString("COLUMN_NAME").toLowerCase());
            }
        }

        if (!primaryKeys.isEmpty()) {
            sb.append("  PRIMARY KEY (");
            for (String pk : primaryKeys) {
                sb.append("`").append(pk).append("`, ");
            }
            sb.setLength(sb.length() - 2);
            sb.append("),\n");
        }

        // 获取唯一约束
        try (PreparedStatement uqStmt = oracleConn.prepareStatement(
                "SELECT cols.column_name FROM all_constraints cons, all_cons_columns cols " +
                        "WHERE cons.constraint_type = 'U' AND cons.owner = ? AND cons.table_name = ? " +
                        "AND cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner")) {
            uqStmt.setString(1, oracleUserField.getText().toUpperCase());
            uqStmt.setString(2, tableName);
            ResultSet uqRs = uqStmt.executeQuery();
            while (uqRs.next()) {
                uniqueColumns.add(uqRs.getString("COLUMN_NAME").toLowerCase());
            }
        }

        if (!uniqueColumns.isEmpty()) {
            sb.append("  UNIQUE KEY uk_").append(tableName.toLowerCase()).append(" (");
            for (String uq : uniqueColumns) {
                sb.append("`").append(uq).append("`, ");
            }
            sb.setLength(sb.length() - 2);
            sb.append("),\n");
        }

        // 获取索引
        try (PreparedStatement idxStmt = oracleConn.prepareStatement(
                "SELECT index_name, column_name FROM all_ind_columns WHERE table_owner = ? AND table_name = ? " +
                        "AND index_name NOT IN (SELECT constraint_name FROM all_constraints WHERE owner = ? AND table_name = ? " +
                        "AND constraint_type IN ('P', 'U'))")) {
            idxStmt.setString(1, oracleUserField.getText().toUpperCase());
            idxStmt.setString(2, tableName);
            idxStmt.setString(3, oracleUserField.getText().toUpperCase());
            idxStmt.setString(4, tableName);
            ResultSet idxRs = idxStmt.executeQuery();
            while (idxRs.next()) {
                String idxName = idxRs.getString("INDEX_NAME");
                String colName = idxRs.getString("COLUMN_NAME").toLowerCase();
                indexes.computeIfAbsent(idxName, k -> new ArrayList<>()).add(colName);
            }
        }

        for (Map.Entry<String, List<String>> entry : indexes.entrySet()) {
            sb.append("  KEY idx_").append(entry.getKey().toLowerCase()).append(" (");
            for (String col : entry.getValue()) {
                sb.append("`").append(col).append("`, ");
            }
            sb.setLength(sb.length() - 2);
            sb.append("),\n");
        }

        // 移除末尾多余逗号
        if (sb.charAt(sb.length() - 2) == ',') {
            sb.delete(sb.length() - 2, sb.length());
        }

        if (tableComment != null && !tableComment.isEmpty()) {
            sb.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='")
                    .append(tableComment.replace("'", "\\'")).append("';");
        } else {
            sb.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
        }

        return sb.toString();
    }

    private void log(String msg) {
        logArea.append(msg + "\n");
        logArea.setCaretPosition(logArea.getDocument().getLength());
    }

    // 修改测试连接方法，使用已保存的连接
    private void testConnections() {
        log("开始测试连接...");
        boolean oracleOk = false;
        boolean mysqlOk = false;

        checkChange();

        try {
            if (oracleConn != null && !oracleConn.isClosed()) {
                oracleOk = oracleConn.isValid(5); // 测试连接是否有效
                log("✅ Oracle 连接测试通过（连接有效）");
            } else {
                log("⚠️ Oracle 连接未初始化，正在尝试重新连接...");
                initializeConnections();
            }

            if (mysqlConn != null && !mysqlConn.isClosed()) {
                mysqlOk = mysqlConn.isValid(5); // 测试连接是否有效
                log("✅ MySQL 连接测试通过（连接有效）");
            } else {
                log("⚠️ MySQL 连接未初始化，正在尝试重新连接...");
                initializeConnections();
            }

        } catch (SQLException ex) {
            log("连接测试失败: " + ex.getMessage());
        }

        if (oracleOk && mysqlOk) {
            JOptionPane.showMessageDialog(null, "两个数据库连接都有效！", "连接测试成功", JOptionPane.INFORMATION_MESSAGE);
        } else {
            JOptionPane.showMessageDialog(null, "部分连接无效，请查看日志！", "连接测试结果", JOptionPane.WARNING_MESSAGE);
        }
    }

    // 添加配置变更监听器
    private void setupConnectionListeners() {
        // 当Oracle配置变更时重置连接
        oracleHostField.getDocument().addDocumentListener(new DocumentChangeListener(() -> oracleChange = true));
        oraclePortField.getDocument().addDocumentListener(new DocumentChangeListener(() -> oracleChange = true));
        oracleSIDField.getDocument().addDocumentListener(new DocumentChangeListener(() -> oracleChange = true));
        oracleUserField.getDocument().addDocumentListener(new DocumentChangeListener(() -> oracleChange = true));
        oraclePwdField.getDocument().addDocumentListener(new DocumentChangeListener(() -> oracleChange = true));
        // ✅ 新增监听：连接方式变更（SID / 服务名）
        oracleConnectModeBox.addActionListener(e -> oracleChange = true);


        // 当MySQL配置变更时重置连接
        mysqlUrlField.getDocument().addDocumentListener(new DocumentChangeListener(() -> mysqlChange = true));
        mysqlDbNameField.getDocument().addDocumentListener(new DocumentChangeListener(() -> mysqlChange = true));
        mysqlUserField.getDocument().addDocumentListener(new DocumentChangeListener(() -> mysqlChange = true));
        mysqlPwdField.getDocument().addDocumentListener(new DocumentChangeListener(() -> mysqlChange = true));
    }

    // 重置Oracle连接
    private void resetOracleConnection() {
        try {
            // 关闭现有链接
            if (oracleConn != null && !oracleConn.isClosed()) {
                oracleConn.close();
            }
            oracleConn = null;
            oracleChange = false;
            connectOracle();
            log("Oracle 连接已重置");
        } catch (SQLException ex) {
            log("重置Oracle连接时出错: " + ex.getMessage());
        }
    }

    // 重置MySQL连接
    private void resetMysqlConnection() {
        try {
            if (mysqlConn != null && !mysqlConn.isClosed()) {
                mysqlConn.close();
            }
            mysqlConn = null;
            mysqlChange = false;
            connectMysql();
            log("MySQL 连接已重置");
        } catch (SQLException ex) {
            log("重置MySQL连接时出错: " + ex.getMessage());
        }
    }

    // 文档变更监听器
    private class DocumentChangeListener implements DocumentListener {
        private final Runnable callback;

        public DocumentChangeListener(Runnable callback) {
            this.callback = callback;
        }

        @Override
        public void insertUpdate(DocumentEvent e) {
            callback.run();
        }

        @Override
        public void removeUpdate(DocumentEvent e) {
            callback.run();
        }

        @Override
        public void changedUpdate(DocumentEvent e) {
            callback.run();
        }
    }

    private void connectOracle() throws SQLException{
        String host = oracleHostField.getText();
        String port = oraclePortField.getText();
        String sidOrService = oracleSIDField.getText();
        String user = oracleUserField.getText();
        String password = String.valueOf(oraclePwdField.getPassword());
        String mode = (String) oracleConnectModeBox.getSelectedItem();

        String url;
        if ("SID".equalsIgnoreCase(mode)) {
            url = "jdbc:oracle:thin:@" + host + ":" + port + ":" + sidOrService;
        } else {
            url = "jdbc:oracle:thin:@//" + host + ":" + port + "/" + sidOrService;
        }

        oracleConn = DriverManager.getConnection(url, user, password);

    }

    private void connectMysql() throws SQLException{
        mysqlConn = DriverManager.getConnection(
                "jdbc:mysql://" + mysqlUrlField.getText() + "/" + mysqlDbNameField.getText() + "?useSSL=false&serverTimezone=Asia/Shanghai",
                mysqlUserField.getText(), String.valueOf(mysqlPwdField.getPassword()));
    }

    private void checkChange(){
        // 判断配置是否有修改
        if(oracleChange){
            resetOracleConnection();
        }

        if(mysqlChange){
            resetMysqlConnection();
        }
    }

    private void saveCurrentConfig() {
        // Oracle 配置
        config.setProperty("oracle.host", oracleHostField.getText());
        config.setProperty("oracle.port", oraclePortField.getText());
        config.setProperty("oracle.sid", oracleSIDField.getText());
        config.setProperty("oracle.user", oracleUserField.getText());
        config.setProperty("oracle.password", String.valueOf(oraclePwdField.getPassword()));
        config.setProperty("oracle.connectMode", (String) oracleConnectModeBox.getSelectedItem());

        // MySQL 配置
        String[] mysqlHostPort = mysqlUrlField.getText().split(":");
        if (mysqlHostPort.length == 2) {
            config.setProperty("mysql.host", mysqlHostPort[0]);
            config.setProperty("mysql.port", mysqlHostPort[1]);
        } else {
            config.setProperty("mysql.host", mysqlUrlField.getText());
            config.setProperty("mysql.port", "3306");
        }
        config.setProperty("mysql.dbname", mysqlDbNameField.getText());
        config.setProperty("mysql.user", mysqlUserField.getText());
        config.setProperty("mysql.password", String.valueOf(mysqlPwdField.getPassword()));

        // 字段映射配置
        for (int i = 0; i < mappingTableModel.getRowCount(); i++) {
            String oracleType = (String) mappingTableModel.getValueAt(i, 0);
            String mysqlType = (String) mappingTableModel.getValueAt(i, 1);
            config.setProperty("mapping." + i, oracleType + "->" + mysqlType);
        }

        // 其他迁移配置
        config.setProperty("migrate.dropOldTable", String.valueOf(dropOldTableCheckBox.isSelected()));
        config.setProperty("migrate.foreignKeys", String.valueOf(migrateForeignKeysCheckBox.isSelected()));

        try (FileOutputStream fos = new FileOutputStream("app/conf/migrator.properties")) {
            config.store(fos, "Updated config");
            log("✅ 已保存配置文件");
        } catch (IOException e) {
            log("❌ 配置保存失败: " + e.getMessage());
        }
    }

    private void applyConfigToUI() {
        // 字段映射恢复
        if (mappingTableModel != null) {
            mappingTableModel.setRowCount(0);
            int i = 0;
            while (true) {
                String mapping = config.getProperty("mapping." + i);
                if (mapping == null) break;
                String[] parts = mapping.split("->");
                if (parts.length == 2) {
                    mappingTableModel.addRow(new Object[]{parts[0], parts[1]});
                }
                i++;
            }
        }

        // 恢复复选框配置
        if (dropOldTableCheckBox != null)
            dropOldTableCheckBox.setSelected(Boolean.parseBoolean(config.getProperty("migrate.dropOldTable", "false")));

        if (migrateForeignKeysCheckBox != null)
            migrateForeignKeysCheckBox.setSelected(Boolean.parseBoolean(config.getProperty("migrate.foreignKeys", "true")));
    }

    public void errorSql(String sql) throws IOException {
        sql = sql+"\n\n";
        Files.write(Paths.get(config.getProperty("file.error")),
                sql.getBytes("UTF-8"),
                StandardOpenOption.CREATE,
                StandardOpenOption.APPEND);
    }

    public void successSql(String sql) throws IOException {
        sql = sql+"\n\n";
        Files.write(Paths.get(config.getProperty("file.success")),
                sql.getBytes("UTF-8"),
                StandardOpenOption.CREATE,
                StandardOpenOption.APPEND);
    }
}