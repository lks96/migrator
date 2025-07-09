package com.migrator;


import com.migrator.ui.MigrationUI;

import javax.swing.SwingUtilities;

/**
 * Main entry point for the application.
 * This class is responsible for creating and showing the main UI on the Event Dispatch Thread.
 */
public class Main {

    /**
     * The main method that starts the application.
     * @param args Command line arguments (not used).
     */
    public static void main(String[] args) {
        // Ensure the GUI is created and updated on the Event Dispatch Thread.
        SwingUtilities.invokeLater(() -> {
            // Create an instance of the main UI class and display it.
            // The MigrationUI constructor will initialize all necessary components and controllers.
            new MigrationUI().createAndShowGUI();
        });
    }
}
