package com.migrator.ui;

import com.migrator.config.ConfigManager;
import com.migrator.core.Migrator;
import com.migrator.db.DatabaseController;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.swing.Timer;
import java.util.concurrent.CountDownLatch;

/**
 * 数据库迁移工具的主用户界面。
 * 此类负责构建GUI、处理用户交互以及协调控制器、管理器和迁移器类的操作。
 */
public class MigrationUI {

    // --- UI Components ---
    private JFrame frame;
    private JTextField tableFilterField, oracleHostField, oraclePortField, oracleSIDField, oracleUserField,
            mysqlUrlField, mysqlUserField, mysqlDbNameField;
    private JPasswordField oraclePwdField, mysqlPwdField;
    private JComboBox<String> oracleConnectModeBox;
    private final JTextArea logArea = new JTextArea(20, 40);
    private DefaultTableModel mappingTableModel;
    private JCheckBox dropOldTableCheckBox, migrateForeignKeysCheckBox;

    // --- Controllers and Managers ---
    private final DatabaseController dbController;
    private final ConfigManager configManager;
    private final Migrator migratorMain;

    // --- State Flags ---
    private boolean oracleConfigChanged = false;
    private boolean mysqlConfigChanged = false;
    private boolean isConnecting = false; // 连接状态标志

    /**
 * MigrationUI的构造方法。初始化控制器。
 */
    public MigrationUI() {
        // logArea在此处创建并传递给其他需要它的组件。
        this.configManager = new ConfigManager(logArea);
        this.dbController = new DatabaseController(logArea);
        this.migratorMain = new Migrator(dbController, configManager, this);
    }

    /**
 * 创建并显示主GUI。
 */
    public void createAndShowGUI() {
        frame = new JFrame("Oracle → MySQL 表结构与数据迁移工具");

        // 首先加载配置
        configManager.loadExternalConfig();

        // 设置窗口图标
        try {
            String iconPath = configManager.getProperty("icon.path", "app/icon/icon.png");
            BufferedImage iconImage = ImageIO.read(new File(iconPath));
            frame.setIconImage(iconImage);
        } catch (IOException e) {
            log("⚠️ 图标加载失败: " + e.getMessage());
        }

        frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        frame.setSize(1080, 750);
        frame.setLayout(new BorderLayout(10,10));

        // 添加窗口监听器以处理关闭连接
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                log("正在关闭应用程序...");
                dbController.closeConnections();
                frame.dispose();
                System.exit(0);
            }
        });

        // 主面板
        frame.add(createFilterPanel(), BorderLayout.NORTH);
        frame.add(createMainSplitPane(), BorderLayout.CENTER);
        frame.add(createBottomButtonPanel(), BorderLayout.SOUTH);

        // 将加载的配置应用到UI字段
        configManager.applyConfigToUI(this);

        // 添加监听器以检测配置更改
        setupChangeListeners();

        // 完成并显示窗口
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        // 尝试使用加载的设置进行连接
        initializeConnectionsWithUISettings();
    }

    private JPanel createFilterPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        panel.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createEmptyBorder(10, 10, 5, 10),
                BorderFactory.createTitledBorder("表名过滤 (支持正则, 逗号分隔, 留空则弹窗选择)")));
        panel.setBackground(new Color(240, 240, 245));
        tableFilterField = new JTextField(90);
        tableFilterField.setToolTipText("例如: CUST_.*,ORDER_INFO,USER_TABLE");
        panel.add(tableFilterField);
        return panel;
    }

    private JSplitPane createMainSplitPane() {
        JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, createLeftTabbedPane(), createRightLogPanel());
        splitPane.setDividerLocation(480);
        return splitPane;
    }

    private JTabbedPane createLeftTabbedPane() {
        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("微软雅黑", Font.BOLD, 14));
        tabbedPane.addTab(" Oracle 配置 ", createOracleDbPanel());
        tabbedPane.addTab(" MySQL 配置 ", createMySqlDbPanel());
        tabbedPane.addTab(" 字段映射 ", createMappingPanel());
        tabbedPane.addTab(" 其他选项 ", createOtherConfigPanel());
        return tabbedPane;
    }

    private JPanel createRightLogPanel() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBorder(BorderFactory.createTitledBorder("日志控制台"));
        logArea.setEditable(false);
        logArea.setFont(new Font("Monospaced", Font.PLAIN, 13));
        panel.add(new JScrollPane(logArea), BorderLayout.CENTER);
        return panel;
    }

    private JPanel createBottomButtonPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 10));
        JButton migrateButton = new JButton("开始迁移");
        JButton testButton = new JButton("测试并保存连接");

        setupButton(migrateButton, new Color(41, 128, 185));
        setupButton(testButton, new Color(39, 174, 96));

        migrateButton.addActionListener(e -> migratorMain.doMigration());
        testButton.addActionListener(e -> {
            configManager.saveCurrentConfig(this);
            initializeConnectionsWithUISettings();
        });

        panel.add(migrateButton);
        panel.add(testButton);
        return panel;
    }

    // --- Panel Creation Helpers ---

    private JPanel createOracleDbPanel() {
        JPanel panel = new JPanel(new GridBagLayout());
        panel.setBorder(createTitledBorder("Oracle 数据库配置"));
        GridBagConstraints gbc = createGBC();

        oracleHostField = new JTextField(20);
        oraclePortField = new JTextField(20);
        oracleSIDField = new JTextField(20);
        oracleUserField = new JTextField(20);
        oraclePwdField = new JPasswordField(20);
        oracleConnectModeBox = new JComboBox<>(new String[]{"SID", "SERVICE_NAME"});

        addLabelAndField(panel, gbc, "主机:", oracleHostField, 0);
        addLabelAndField(panel, gbc, "端口:", oraclePortField, 1);
        addLabelAndField(panel, gbc, "SID / 服务名:", oracleSIDField, 2);
        addLabelAndField(panel, gbc, "连接方式:", oracleConnectModeBox, 3);
        addLabelAndField(panel, gbc, "用户名:", oracleUserField, 4);
        addLabelAndField(panel, gbc, "密码:", oraclePwdField, 5);
        return panel;
    }

    private JPanel createMySqlDbPanel() {
        JPanel panel = new JPanel(new GridBagLayout());
        panel.setBorder(createTitledBorder("MySQL 数据库配置"));
        GridBagConstraints gbc = createGBC();

        mysqlUrlField = new JTextField(20);
        mysqlUrlField.setToolTipText("格式: 主机:端口, 例如: 127.0.0.1:3306");
        mysqlDbNameField = new JTextField(20);
        mysqlUserField = new JTextField(20);
        mysqlPwdField = new JPasswordField(20);

        addLabelAndField(panel, gbc, "主机:端口:", mysqlUrlField, 0);
        addLabelAndField(panel, gbc, "数据库名:", mysqlDbNameField, 1);
        addLabelAndField(panel, gbc, "用户名:", mysqlUserField, 2);
        addLabelAndField(panel, gbc, "密码:", mysqlPwdField, 3);
        return panel;
    }

    private JPanel createMappingPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        mappingTableModel = new DefaultTableModel(new String[]{"Oracle 类型", "MySQL 类型"}, 0);
        JTable table = new JTable(mappingTableModel);
        table.setRowHeight(25);

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JButton addButton = new JButton("添加");
        JButton deleteButton = new JButton("删除选中");

        addButton.addActionListener(e -> mappingTableModel.addRow(new String[]{"", ""}));
        deleteButton.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow >= 0) {
                mappingTableModel.removeRow(selectedRow);
            } else {
                JOptionPane.showMessageDialog(frame, "请先选择要删除的行。", "提示", JOptionPane.WARNING_MESSAGE);
            }
        });

        buttonPanel.add(addButton);
        buttonPanel.add(deleteButton);

        panel.add(new JScrollPane(table), BorderLayout.CENTER);
        panel.add(buttonPanel, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel createOtherConfigPanel() {
        JPanel panel = new JPanel(new GridBagLayout());
        panel.setBorder(createTitledBorder("其他迁移选项"));
        GridBagConstraints gbc = createGBC();
        gbc.gridwidth = 2;

        dropOldTableCheckBox = new JCheckBox("迁移结构时，删除 MySQL 中已存在的同名表");
        migrateForeignKeysCheckBox = new JCheckBox("迁移外键约束 (在所有数据迁移后执行)");

        panel.add(dropOldTableCheckBox, gbc);
        gbc.gridy = 1;
        panel.add(migrateForeignKeysCheckBox, gbc);

        // 添加填充组件以将复选框推到顶部
        gbc.gridy = 2;
        gbc.weighty = 1.0;
        panel.add(new JLabel(), gbc);

        return panel;
    }

    // --- Action & Helper Methods ---

    private void initializeConnectionsWithUISettings() {
        if (isConnecting) {
            log("连接已在进行中，忽略新请求...");
            return;
        }
        isConnecting = true;
        // 在后台线程中运行连接逻辑，以免冻结UI
        new SwingWorker<Void, Void>() {
            @Override
            protected Void doInBackground() {
                dbController.closeConnections(); // 首先关闭任何现有连接
            CountDownLatch latch = new CountDownLatch(2);

            // 并行连接Oracle
            new Thread(() -> {
                try {
                    dbController.connectOracle(
                            oracleHostField.getText(), oraclePortField.getText(), oracleSIDField.getText(),
                            oracleUserField.getText(), String.valueOf(oraclePwdField.getPassword()),
                            (String) oracleConnectModeBox.getSelectedItem()
                    );
                } catch (Exception e) {
                    log("❌ Oracle 连接失败: " + e.getMessage());
                } finally {
                    latch.countDown();
                }
            }).start();

            // 并行连接MySQL
            new Thread(() -> {
                try {
                    dbController.connectMySQL(
                            mysqlUrlField.getText(), mysqlDbNameField.getText(),
                            mysqlUserField.getText(), String.valueOf(mysqlPwdField.getPassword())
                    );
                } catch (Exception e) {
                    log("❌ MySQL 连接失败: " + e.getMessage());
                } finally {
                    latch.countDown();
                }
            }).start();

            try {
                latch.await(); // 等待两个连接都完成
            } catch (InterruptedException e) {
                log("⚠️ 连接过程被中断: " + e.getMessage());
                Thread.currentThread().interrupt();
            }
                return null;
            }

            @Override
        protected void done() {
            try {
                get(); // 检索后台任务异常
                dbController.testConnections(); // 测试并显示结果弹窗
            } catch (Exception e) {
                log("连接过程发生错误: " + e.getMessage());
            } finally {
                isConnecting = false; // 重置连接状态
            }
        }
        }.execute();
    }

    /**
     * 带延迟防抖功能的文档变更监听器
     */
    private class DocumentChangeListener implements DocumentListener {
        private final Runnable callback;
        private Timer debounceTimer;
        
        public DocumentChangeListener(Runnable callback) {
            this.callback = callback;
            this.debounceTimer = new Timer(1000, e -> callback.run());
            this.debounceTimer.setRepeats(false);
        }
        
        @Override public void insertUpdate(DocumentEvent e) { restartTimer(); }
        @Override public void removeUpdate(DocumentEvent e) { restartTimer(); }
        @Override public void changedUpdate(DocumentEvent e) { restartTimer(); }
        
        private void restartTimer() {
            debounceTimer.stop();
            debounceTimer.start();
        }
    }
    
    private void setupChangeListeners() {
        // Oracle配置变更监听器（带自动重连）
        DocumentListener oracleListener = new DocumentChangeListener(() -> {
            oracleConfigChanged = true;
            log("检测到Oracle配置变更，正在重新连接...");
            initializeConnectionsWithUISettings();
        });
        oracleHostField.getDocument().addDocumentListener(oracleListener);
        oraclePortField.getDocument().addDocumentListener(oracleListener);
        oracleSIDField.getDocument().addDocumentListener(oracleListener);
        oracleUserField.getDocument().addDocumentListener(oracleListener);
        oraclePwdField.getDocument().addDocumentListener(oracleListener);
        oracleConnectModeBox.addActionListener(e -> {
            oracleConfigChanged = true;
            log("检测到Oracle连接方式变更，正在重新连接...");
            initializeConnectionsWithUISettings();
        });

        // MySQL配置变更监听器（带自动重连）
        DocumentListener mysqlListener = new DocumentChangeListener(() -> {
            mysqlConfigChanged = true;
            log("检测到MySQL配置变更，正在重新连接...");
            initializeConnectionsWithUISettings();
        });
        mysqlUrlField.getDocument().addDocumentListener(mysqlListener);
        mysqlDbNameField.getDocument().addDocumentListener(mysqlListener);
        mysqlUserField.getDocument().addDocumentListener(mysqlListener);
        mysqlPwdField.getDocument().addDocumentListener(mysqlListener);
    }

    // --- UI Utility Methods ---
    private void log(String msg) {
        if (!SwingUtilities.isEventDispatchThread()) {
            SwingUtilities.invokeLater(() -> log(msg));
            return;
        }
        logArea.append(msg + "\n");
        logArea.setCaretPosition(logArea.getDocument().getLength());
    }

    private void setupButton(JButton button, Color color) {
        button.setFont(new Font("微软雅黑", Font.BOLD, 16));
        button.setForeground(Color.WHITE);
        button.setBackground(color);
        button.setPreferredSize(new Dimension(200, 50));
    }

    private void addLabelAndField(JPanel panel, GridBagConstraints gbc, String labelText, JComponent field, int gridy) {
        JLabel label = new JLabel(labelText);
        label.setFont(new Font("微软雅黑", Font.BOLD, 14));
        gbc.gridx = 0;
        gbc.gridy = gridy;
        gbc.anchor = GridBagConstraints.EAST;
        panel.add(label, gbc);

        gbc.gridx = 1;
        gbc.anchor = GridBagConstraints.WEST;
        panel.add(field, gbc);
    }

    private TitledBorder createTitledBorder(String title) {
        return BorderFactory.createTitledBorder(
                BorderFactory.createEmptyBorder(5, 5, 5, 5),
                title,
                TitledBorder.LEFT,
                TitledBorder.TOP,
                new Font("微软雅黑", Font.BOLD, 14)
        );
    }

    private GridBagConstraints createGBC() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        return gbc;
    }

    // --- Getters for components needed by other classes ---
    public JFrame getFrame() { return frame; }
    public JTextArea getLogArea() { return logArea; }
    public JTextField getTableFilterField() { return tableFilterField; }
    public JTextField getOracleHostField() { return oracleHostField; }
    public JTextField getOraclePortField() { return oraclePortField; }
    public JTextField getOracleSIDField() { return oracleSIDField; }
    public JTextField getOracleUserField() { return oracleUserField; }
    public JPasswordField getOraclePwdField() { return oraclePwdField; }
    public JComboBox<String> getOracleConnectModeBox() { return oracleConnectModeBox; }
    public JTextField getMysqlUrlField() { return mysqlUrlField; }
    public JTextField getMysqlDbNameField() { return mysqlDbNameField; }
    public JTextField getMysqlUserField() { return mysqlUserField; }
    public JPasswordField getMysqlPwdField() { return mysqlPwdField; }
    public DefaultTableModel getMappingTableModel() { return mappingTableModel; }
    public JCheckBox getDropOldTableCheckBox() { return dropOldTableCheckBox; }
    public JCheckBox getMigrateForeignKeysCheckBox() { return migrateForeignKeysCheckBox; }


}
