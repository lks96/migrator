package com.migrator.update;

import javax.swing.*;

public class MigratorNew {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            ConfigLoader configLoader = new ConfigLoader();
            JTextArea logArea = new JTextArea();
            ConnectionManager connectionManager = new ConnectionManager(logArea, configLoader.getConfig());
            UIBuilder uiBuilder = new UIBuilder();
            uiBuilder.createAndShowGUI(configLoader, connectionManager);
        });
    }
}
