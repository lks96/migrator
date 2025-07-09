package com.migrator.update;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class ConfigLoader {
    private Properties config = new Properties();

    public ConfigLoader() {
        loadExternalConfig();
    }

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

    public Properties getConfig() {
        return config;
    }

    private void log(String message) {
        System.out.println(message);
    }
}