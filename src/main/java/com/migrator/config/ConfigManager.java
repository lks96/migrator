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
 * Manages application configuration.
 * This class handles loading properties from a file, saving the current configuration,
 * and applying loaded settings to the UI components.
 */
public class ConfigManager {

    private final Properties config = new Properties();
    private final JTextArea logArea;
    private static final String CONFIG_FILE_PATH = "app/conf/migrator.properties";

    /**
     * Constructor for ConfigManager.
     * @param logArea The JTextArea to which log messages will be appended.
     */
    public ConfigManager(JTextArea logArea) {
        this.logArea = logArea;
    }

    /**
     * Loads configuration from an external .properties file.
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
     * Saves the current UI configuration to the .properties file.
     * @param ui The main UI frame from which to get the configuration values.
     */
    public void saveCurrentConfig(MigrationUI ui) {
        // Oracle Configuration
        config.setProperty("oracle.host", ui.getOracleHostField().getText());
        config.setProperty("oracle.port", ui.getOraclePortField().getText());
        config.setProperty("oracle.sid", ui.getOracleSIDField().getText());
        config.setProperty("oracle.user", ui.getOracleUserField().getText());
        config.setProperty("oracle.password", String.valueOf(ui.getOraclePwdField().getPassword()));
        config.setProperty("oracle.connectMode", (String) ui.getOracleConnectModeBox().getSelectedItem());

        // MySQL Configuration
        String[] mysqlHostPort = ui.getMysqlUrlField().getText().split(":");
        if (mysqlHostPort.length == 2) {
            config.setProperty("mysql.host", mysqlHostPort[0]);
            config.setProperty("mysql.port", mysqlHostPort[1]);
        } else {
            config.setProperty("mysql.host", ui.getMysqlUrlField().getText());
            config.setProperty("mysql.port", "3306"); // Default port
        }
        config.setProperty("mysql.dbname", ui.getMysqlDbNameField().getText());
        config.setProperty("mysql.user", ui.getMysqlUserField().getText());
        config.setProperty("mysql.password", String.valueOf(ui.getMysqlPwdField().getPassword()));

        // Type Mapping Configuration
        DefaultTableModel mappingModel = ui.getMappingTableModel();
        // Clear old mapping properties before saving new ones
        config.keySet().removeIf(key -> key.toString().startsWith("mapping."));
        for (int i = 0; i < mappingModel.getRowCount(); i++) {
            String oracleType = (String) mappingModel.getValueAt(i, 0);
            String mysqlType = (String) mappingModel.getValueAt(i, 1);
            if (oracleType != null && !oracleType.trim().isEmpty()) {
                config.setProperty("mapping." + i, oracleType + "->" + mysqlType);
            }
        }

        // Other Migration Configuration
        config.setProperty("migrate.dropOldTable", String.valueOf(ui.getDropOldTableCheckBox().isSelected()));
        config.setProperty("migrate.foreignKeys", String.valueOf(ui.getMigrateForeignKeysCheckBox().isSelected()));

        // Icon path
        if (config.getProperty("icon.path") == null) {
            config.setProperty("icon.path", "app/icon/icon.png");
        }

        // SQL log files path
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
     * Applies the loaded configuration to the UI components.
     * @param ui The main UI frame to which the configuration will be applied.
     */
    public void applyConfigToUI(MigrationUI ui) {
        // Apply Oracle fields
        ui.getOracleHostField().setText(config.getProperty("oracle.host", "127.0.0.1"));
        ui.getOraclePortField().setText(config.getProperty("oracle.port", "1521"));
        ui.getOracleSIDField().setText(config.getProperty("oracle.sid", ""));
        ui.getOracleUserField().setText(config.getProperty("oracle.user", ""));
        ui.getOraclePwdField().setText(config.getProperty("oracle.password", ""));
        ui.getOracleConnectModeBox().setSelectedItem(config.getProperty("oracle.connectMode", "SID"));

        // Apply MySQL fields
        String mysqlHost = config.getProperty("mysql.host", "127.0.0.1");
        String mysqlPort = config.getProperty("mysql.port", "3306");
        ui.getMysqlUrlField().setText(mysqlHost + ":" + mysqlPort);
        ui.getMysqlDbNameField().setText(config.getProperty("mysql.dbname", ""));
        ui.getMysqlUserField().setText(config.getProperty("mysql.user", ""));
        ui.getMysqlPwdField().setText(config.getProperty("mysql.password", ""));

        // Apply Type Mapping
        DefaultTableModel mappingModel = ui.getMappingTableModel();
        if (mappingModel != null) {
            mappingModel.setRowCount(0); // Clear existing rows
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

        // Apply Other Config
        if (ui.getDropOldTableCheckBox() != null) {
            ui.getDropOldTableCheckBox().setSelected(Boolean.parseBoolean(config.getProperty("migrate.dropOldTable", "false")));
        }
        if (ui.getMigrateForeignKeysCheckBox() != null) {
            ui.getMigrateForeignKeysCheckBox().setSelected(Boolean.parseBoolean(config.getProperty("migrate.foreignKeys", "true")));
        }
    }

    /**
     * Retrieves a configuration property by its key.
     * @param key The property key.
     * @return The property value, or null if not found.
     */
    public String getProperty(String key) {
        return config.getProperty(key);
    }

    /**
     * Retrieves a configuration property by its key, with a default value.
     * @param key The property key.
     * @param defaultValue The value to return if the key is not found.
     * @return The property value.
     */
    public String getProperty(String key, String defaultValue) {
        return config.getProperty(key, defaultValue);
    }

    /**
     * Logs a message to the UI's log area.
     * @param msg The message to log.
     */
    private void log(String msg) {
        if (logArea != null) {
            logArea.append(msg + "\n");
            logArea.setCaretPosition(logArea.getDocument().getLength());
        }
    }
}
