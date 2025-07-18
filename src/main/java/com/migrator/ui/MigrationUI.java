package com.migrator.ui;

import com.migrator.config.ConfigManager;
import com.migrator.core.Migrator;
import com.migrator.db.DatabaseController;
import lombok.Data;

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
import javax.swing.text.DefaultCaret;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.Arrays; // 添加缺失的导入语句

/**
 * 数据库迁移工具的主用户界面。
 * 此类负责构建GUI、处理用户交互以及协调控制器、管理器和迁移器类的操作。
 */
@Data
public class MigrationUI {

    // --- UI Components ---
    private JFrame frame;
    private JLabel oracleStatusLabel;
    private JLabel mysqlStatusLabel;
    private JLabel progressLabel;
    private JTextField tableFilterField, oracleHostField, oraclePortField, oracleSIDField, oracleUserField,
            mysqlUrlField, mysqlUserField, mysqlDbNameField;
    private JPasswordField oraclePwdField, mysqlPwdField;
    private JComboBox<String> oracleConnectModeBox;
    private final JTextArea logArea = new JTextArea(20, 40);
    private DefaultTableModel mappingTableModel;
    private JCheckBox dropOldTableCheckBox, migrateForeignKeysCheckBox;
    private JButton migrateButton, testButton;

    // --- Controllers and Managers ---
    private final DatabaseController dbController;
    private final ConfigManager configManager;
    private final Migrator migratorMain;
    private JCheckBox regexFilterCheckBox;

    // --- State Flags ---
    private final AtomicBoolean isConnecting = new AtomicBoolean(false); // 连接状态标志（线程安全）

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
        // 设置系统外观以获得原生界面体验
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            log("无法设置系统外观: " + e.getMessage());
        }

        frame = new JFrame("Oracle → MySQL 表结构与数据迁移工具");
        frame.setMinimumSize(new Dimension(900, 650)); // 设置窗口最小尺寸

        // 添加顶部状态栏
        JPanel statusBar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        statusBar.setBorder(BorderFactory.createMatteBorder(0, 0, 1, 0, new Color(220, 220, 220)));
        statusBar.setBackground(new Color(245, 245, 245));

        oracleStatusLabel = new JLabel("Oracle: 未连接");
        mysqlStatusLabel = new JLabel("MySQL: 未连接");
        progressLabel = new JLabel("就绪");

        oracleStatusLabel.setFont(new Font("微软雅黑", Font.PLAIN, 12));
        mysqlStatusLabel.setFont(new Font("微软雅黑", Font.PLAIN, 12));
        progressLabel.setFont(new Font("微软雅黑", Font.PLAIN, 12));

        oracleStatusLabel.setForeground(Color.GRAY);
        mysqlStatusLabel.setForeground(Color.GRAY);
        progressLabel.setForeground(new Color(41, 128, 185));

        statusBar.add(oracleStatusLabel);
        statusBar.add(new JSeparator(SwingConstants.VERTICAL));
        statusBar.add(mysqlStatusLabel);
        statusBar.add(new JSeparator(SwingConstants.VERTICAL));
        statusBar.add(progressLabel);

        frame.add(statusBar, BorderLayout.NORTH);

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
        frame.setLayout(new BorderLayout(15, 15));
        frame.getContentPane().setBackground(new Color(245, 245, 245)); // 设置全局背景色

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
                BorderFactory.createEmptyBorder(12, 15, 12, 15),
                BorderFactory.createTitledBorder(BorderFactory.createLineBorder(new Color(200, 200, 200)),
                        "表名过滤 (支持正则, 逗号分隔, 留空则弹窗选择)", TitledBorder.LEFT, TitledBorder.TOP,
                        new Font("微软雅黑", Font.PLAIN, 13), new Color(60, 60, 60))));
        panel.setBackground(new Color(240, 240, 245));

        tableFilterField = new JTextField(75);
        tableFilterField.setToolTipText("例如: CUST_.*,ORDER_INFO,USER_TABLE");

        regexFilterCheckBox = new JCheckBox("使用正则匹配", true); // ✅ 默认启用
        regexFilterCheckBox.setToolTipText("关闭后将使用完全等于匹配");

        panel.add(tableFilterField);
        panel.add(regexFilterCheckBox);
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
        logArea.setLineWrap(true);
        logArea.setWrapStyleWord(true);

        // 添加行号显示
        JTextArea lineNumbers = new JTextArea();
        lineNumbers.setEditable(false);
        lineNumbers.setFont(logArea.getFont());
        lineNumbers.setBackground(new Color(240, 240, 240));
        lineNumbers.setForeground(Color.GRAY);

        JScrollPane scrollPane = new JScrollPane(logArea);
        scrollPane.setRowHeaderView(lineNumbers);

        // 自动滚动到底部
        DefaultCaret caret = (DefaultCaret) logArea.getCaret();
        caret.setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);

        // 同步行号
        logArea.getDocument().addDocumentListener(new DocumentListener() {
            public void changedUpdate(DocumentEvent e) {
                updateLineNumbers();
            }

            public void insertUpdate(DocumentEvent e) {
                updateLineNumbers();
            }

            public void removeUpdate(DocumentEvent e) {
                updateLineNumbers();
            }

            private void updateLineNumbers() {
                int lines = logArea.getLineCount();
                StringBuilder numbers = new StringBuilder();
                for (int i = 1; i <= lines; i++) {
                    numbers.append(i).append("\n");
                }
                lineNumbers.setText(numbers.toString());
            }
        });

        panel.add(scrollPane, BorderLayout.CENTER);
        return panel;
    }

    private JPanel createBottomButtonPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 10));
        migrateButton = new JButton("开始迁移");
        testButton = new JButton("测试并保存连接");

        setupButton(migrateButton, new Color(41, 128, 185));
        setupButton(testButton, new Color(39, 174, 96));

        // 添加按钮悬停效果
        migrateButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                migrateButton.setBackground(new Color(52, 152, 219));
            }

            public void mouseExited(java.awt.event.MouseEvent evt) {
                migrateButton.setBackground(new Color(41, 128, 185));
            }
        });

        testButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                testButton.setBackground(new Color(46, 204, 113));
            }

            public void mouseExited(java.awt.event.MouseEvent evt) {
                testButton.setBackground(new Color(39, 174, 96));
            }
        });

        // 设置按钮禁用状态样式
        migrateButton.setDisabledIcon(new ImageIcon());
        testButton.setDisabledIcon(new ImageIcon());

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
//        panel.setBorder(createTitledBorder("Oracle 数据库配置"));
        GridBagConstraints gbc = createGBC();

        oracleHostField = new JTextField(20);
        oraclePortField = new JTextField(20);
        oraclePortField.setText("1521");
        oraclePortField.setToolTipText("Oracle数据库端口，默认为1521");
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
//        panel.setBorder(createTitledBorder("MySQL 数据库配置"));
        GridBagConstraints gbc = createGBC();

        mysqlUrlField = new JTextField(20);
        mysqlUrlField.setText("localhost:3306");
        mysqlUrlField.setToolTipText("MySQL主机和端口，格式: 主机名:端口号，默认为localhost:3306");
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

    private boolean validateOracleSettings() {
        if (oracleHostField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(frame, "Oracle主机名不能为空", "输入错误", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        String portRegex = "^(0|([1-9]\\d{0,3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5]))$";
        if (oraclePortField.getText().trim().isEmpty() || !oraclePortField.getText().matches(portRegex)) {
            JOptionPane.showMessageDialog(frame, "请输入有效的Oracle端口号", "输入错误", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        if (oracleSIDField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(frame, "Oracle SID/服务名不能为空", "输入错误", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        if (oracleUserField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(frame, "Oracle用户名不能为空", "输入错误", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        return true;
    }

    private boolean validateMySQLSettings() {
        String mysqlUrlRegex = "^[^:]+:(0|([1-9]\\d{0,3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5]))$";
        if (mysqlUrlField.getText().trim().isEmpty() || !mysqlUrlField.getText().matches(mysqlUrlRegex)) {
            JOptionPane.showMessageDialog(frame, "请输入有效的MySQL主机:端口", "输入错误", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        if (mysqlDbNameField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(frame, "MySQL数据库名不能为空", "输入错误", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        if (mysqlUserField.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(frame, "MySQL用户名不能为空", "输入错误", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        return true;
    }

    private void initializeConnectionsWithUISettings() {
        if (!validateOracleSettings() || !validateMySQLSettings()) {
            return;
        }
        if (isConnecting.get()) {
            log("连接已在进行中，忽略新请求...");
            return;
        }
        isConnecting.set(true);
        SwingUtilities.invokeLater(() -> {
            migrateButton.setEnabled(false);
            testButton.setEnabled(false);
        });
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
                                oracleUserField.getText(), new String(oraclePwdField.getPassword()),
                                (String) oracleConnectModeBox.getSelectedItem()
                        );
                    } catch (Exception e) {
                        String errorMsg = "Oracle 连接失败: " + e.getMessage();
                        log("❌ " + errorMsg);
                        SwingUtilities.invokeLater(() ->
                                JOptionPane.showMessageDialog(frame, errorMsg, "数据库连接错误", JOptionPane.ERROR_MESSAGE)
                        );
                    } finally {
                        // 清除密码数组中的敏感信息
                        Arrays.fill(oraclePwdField.getPassword(), '0');
                        latch.countDown();
                    }
                }, "Oracle-Connection-Thread").start();

                // 并行连接MySQL
                new Thread(() -> {
                    try {
                        dbController.connectMySQL(
                                mysqlUrlField.getText(), mysqlDbNameField.getText(),
                                mysqlUserField.getText(), new String(mysqlPwdField.getPassword())
                        );
                    } catch (Exception e) {
                        String errorMsg = "MySQL 连接失败: " + e.getMessage();
                        log("❌ " + errorMsg);
                        SwingUtilities.invokeLater(() ->
                                JOptionPane.showMessageDialog(frame, errorMsg, "数据库连接错误", JOptionPane.ERROR_MESSAGE)
                        );
                    } finally {
                        latch.countDown();
                    }
                }, "MySQL-Connection-Thread").start();

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
                    isConnecting.set(false); // 重置连接状态
                    SwingUtilities.invokeLater(() -> {
                        migrateButton.setEnabled(true);
                        testButton.setEnabled(true);
                    });
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
            this.debounceTimer = new Timer(2000, e -> callback.run());
            this.debounceTimer.setRepeats(false);
        }

        @Override
        public void insertUpdate(DocumentEvent e) {
            restartTimer();
        }

        @Override
        public void removeUpdate(DocumentEvent e) {
            restartTimer();
        }

        @Override
        public void changedUpdate(DocumentEvent e) {
            restartTimer();
        }

        private void restartTimer() {
            debounceTimer.stop();
            debounceTimer.start();
        }
    }

    private void setupChangeListeners() {
        // Oracle配置变更监听器（带自动重连）
        DocumentListener oracleListener = new DocumentChangeListener(() -> {
            log("检测到Oracle配置变更，正在重新连接...");
            initializeConnectionsWithUISettings();
        });
        oracleHostField.getDocument().addDocumentListener(oracleListener);
        oraclePortField.getDocument().addDocumentListener(oracleListener);
        oracleSIDField.getDocument().addDocumentListener(oracleListener);
        oracleUserField.getDocument().addDocumentListener(oracleListener);
        oraclePwdField.getDocument().addDocumentListener(oracleListener);
        oracleConnectModeBox.addActionListener(e -> {
            log("检测到Oracle连接方式变更，正在重新连接...");
            initializeConnectionsWithUISettings();
        });

        // MySQL配置变更监听器（带自动重连）
        DocumentListener mysqlListener = new DocumentChangeListener(() -> {
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

    public void updateOracleStatus(boolean connected) {
        SwingUtilities.invokeLater(() -> {
            oracleStatusLabel.setText("Oracle: " + (connected ? "已连接" : "未连接"));
            oracleStatusLabel.setForeground(connected ? new Color(39, 174, 96) : Color.GRAY);
        });
    }

    public void updateMySQLStatus(boolean connected) {
        SwingUtilities.invokeLater(() -> {
            mysqlStatusLabel.setText("MySQL: " + (connected ? "已连接" : "未连接"));
            mysqlStatusLabel.setForeground(connected ? new Color(39, 174, 96) : Color.GRAY);
        });
    }

    public void updateProgress(String message) {
        SwingUtilities.invokeLater(() -> {
            progressLabel.setText(message);
        });
    }

    private void setupButton(JButton button, Color color) {
        button.setFont(new Font("微软雅黑", Font.BOLD, 16));
        // 将文字颜色修改为黑色
        button.setForeground(Color.BLACK);
        button.setBackground(color);
        button.setPreferredSize(new Dimension(200, 50));
        button.setCursor(new Cursor(Cursor.HAND_CURSOR));
        button.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(220, 220, 220)),
                BorderFactory.createEmptyBorder(8, 20, 8, 20)
        ));
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
        gbc.anchor = GridBagConstraints.NORTHWEST;
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.weightx = 1.0;
        gbc.weighty = 0.0;
        return gbc;
    }

    public boolean isRegexFilterEnabled() {
        return regexFilterCheckBox != null && regexFilterCheckBox.isSelected();
    }

}