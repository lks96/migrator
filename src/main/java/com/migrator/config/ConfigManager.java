package com.migrator.config;

import com.migrator.ui.MigrationUI;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

/**
 * 管理应用程序配置。
 * 此类负责从文件加载属性、保存当前配置以及将加载的设置应用到UI组件。
 */
public class ConfigManager {

    private final Properties config = new Properties();
    private final JTextArea logArea;
    private static final String CONFIG_FILE_PATH = "app/conf/migrator.properties";

    /**
 * ConfigManager的构造方法。
 * @param logArea 用于追加日志消息的JTextArea。
 */
    public ConfigManager(JTextArea logArea) {
        this.logArea = logArea;
    }

    /**
 * 从外部.properties文件加载配置。
 */
    public void loadExternalConfig() {
        File configFile = new File(CONFIG_FILE_PATH);
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

    /**
 * 将当前UI配置保存到.properties文件。
 * @param ui 从中获取配置值的主UI框架。
 */
    public void saveCurrentConfig(MigrationUI ui) {
        // Oracle配置
        config.setProperty("oracle.host", ui.getOracleHostField().getText());
        config.setProperty("oracle.port", ui.getOraclePortField().getText());
        config.setProperty("oracle.sid", ui.getOracleSIDField().getText());
        config.setProperty("oracle.user", ui.getOracleUserField().getText());
        config.setProperty("oracle.password", String.valueOf(ui.getOraclePwdField().getPassword()));
        config.setProperty("oracle.connectMode", (String) ui.getOracleConnectModeBox().getSelectedItem());

        // MySQL配置
        String[] mysqlHostPort = ui.getMysqlUrlField().getText().split(":");
        if (mysqlHostPort.length == 2) {
            config.setProperty("mysql.host", mysqlHostPort[0]);
            config.setProperty("mysql.port", mysqlHostPort[1]);
        } else {
            config.setProperty("mysql.host", ui.getMysqlUrlField().getText());
            config.setProperty("mysql.port", "3306"); // 默认端口
        }
        config.setProperty("mysql.dbname", ui.getMysqlDbNameField().getText());
        config.setProperty("mysql.user", ui.getMysqlUserField().getText());
        config.setProperty("mysql.password", String.valueOf(ui.getMysqlPwdField().getPassword()));

        // 类型映射配置
        DefaultTableModel mappingModel = ui.getMappingTableModel();
        // 保存新映射前清除旧的映射属性
        config.keySet().removeIf(key -> key.toString().startsWith("mapping."));
        for (int i = 0; i < mappingModel.getRowCount(); i++) {
            String oracleType = (String) mappingModel.getValueAt(i, 0);
            String mysqlType = (String) mappingModel.getValueAt(i, 1);
            if (oracleType != null && !oracleType.trim().isEmpty()) {
                config.setProperty("mapping." + i, oracleType + "->" + mysqlType);
            }
        }

        // 其他迁移配置
        config.setProperty("migrate.dropOldTable", String.valueOf(ui.getDropOldTableCheckBox().isSelected()));
        config.setProperty("migrate.foreignKeys", String.valueOf(ui.getMigrateForeignKeysCheckBox().isSelected()));

        // 图标路径
        if (config.getProperty("icon.path") == null) {
            config.setProperty("icon.path", "app/icon/icon.png");
        }

        // SQL日志文件路径
        if (config.getProperty("file.error") == null) {
            config.setProperty("file.error", "log/error.sql");
        }
        if (config.getProperty("file.success") == null) {
            config.setProperty("file.success", "log/success.sql");
        }


        try (FileOutputStream fos = new FileOutputStream(CONFIG_FILE_PATH)) {
            config.store(fos, "Database Migration Tool Configuration");
            log("✅ 已保存当前配置到 " + CONFIG_FILE_PATH);
        } catch (IOException e) {
            log("❌ 配置保存失败: " + e.getMessage());
        }
    }

    /**
 * 将加载的配置应用到UI组件。
 * @param ui 将应用配置的主UI框架。
 */
    public void applyConfigToUI(MigrationUI ui) {
        // 应用Oracle字段
        ui.getOracleHostField().setText(config.getProperty("oracle.host", "127.0.0.1"));
        ui.getOraclePortField().setText(config.getProperty("oracle.port", "1521"));
        ui.getOracleSIDField().setText(config.getProperty("oracle.sid", ""));
        ui.getOracleUserField().setText(config.getProperty("oracle.user", ""));
        ui.getOraclePwdField().setText(config.getProperty("oracle.password", ""));
        ui.getOracleConnectModeBox().setSelectedItem(config.getProperty("oracle.connectMode", "SID"));

        // 应用MySQL字段
        String mysqlHost = config.getProperty("mysql.host", "127.0.0.1");
        String mysqlPort = config.getProperty("mysql.port", "3306");
        ui.getMysqlUrlField().setText(mysqlHost + ":" + mysqlPort);
        ui.getMysqlDbNameField().setText(config.getProperty("mysql.dbname", ""));
        ui.getMysqlUserField().setText(config.getProperty("mysql.user", ""));
        ui.getMysqlPwdField().setText(config.getProperty("mysql.password", ""));

        // 应用类型映射
        DefaultTableModel mappingModel = ui.getMappingTableModel();
        if (mappingModel != null) {
            mappingModel.setRowCount(0); // 清除现有行
            int i = 0;
            while (true) {
                String mapping = config.getProperty("mapping." + i);
                if (mapping == null) break;
                String[] parts = mapping.split("->", 2);
                if (parts.length == 2) {
                    mappingModel.addRow(new Object[]{parts[0], parts[1]});
                }
                i++;
            }
        }

        // 应用其他配置
        if (ui.getDropOldTableCheckBox() != null) {
            ui.getDropOldTableCheckBox().setSelected(Boolean.parseBoolean(config.getProperty("migrate.dropOldTable", "false")));
        }
        if (ui.getMigrateForeignKeysCheckBox() != null) {
            ui.getMigrateForeignKeysCheckBox().setSelected(Boolean.parseBoolean(config.getProperty("migrate.foreignKeys", "true")));
        }
    }

    /**
 * 通过键检索配置属性。
 * @param key 属性键。
 * @return 属性值，如果未找到则为null。
 */
    public String getProperty(String key) {
        return config.getProperty(key);
    }

    /**
 * 通过键检索配置属性，带有默认值。
 * @param key 属性键。
 * @param defaultValue 如果未找到键则返回的值。
 * @return 属性值。
 */
    public String getProperty(String key, String defaultValue) {
        return config.getProperty(key, defaultValue);
    }

    /**
 * 将消息记录到UI的日志区域。
 * @param msg 要记录的消息。
 */
    private void log(String msg) {
        if (logArea != null) {
            logArea.append(msg + "\n");
            logArea.setCaretPosition(logArea.getDocument().getLength());
        }
    }
}
