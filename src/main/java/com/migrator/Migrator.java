
package com.migrator;
public class Migrator {
    public static void main(String[] args) {
        javax.swing.SwingUtilities.invokeLater(() -> new MigrationUI().createAndShowGUI());
    }
}
