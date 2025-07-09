package com.migrator.ui;

import javax.swing.*;
import java.awt.*;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Vector;

/**
 * A dialog window for selecting tables to migrate.
 * It displays a list of available tables with checkboxes for selection.
 */
public class TableSelectionDialog extends JDialog {

    private final JList<String> tableList;
    private final Set<String> selectedTables = new HashSet<>();

    /**
     * Constructor for TableSelectionDialog.
     * @param parent The parent frame.
     * @param tableNames A list of table names to display.
     */
    public TableSelectionDialog(Frame parent, List<String> tableNames) {
        super(parent, "选择要迁移的表", true);
        setSize(400, 600);
        setLocationRelativeTo(parent);
        setLayout(new BorderLayout(10, 10));

        // Instructions
        JLabel instructionLabel = new JLabel("请选择要迁移的表 (支持 Ctrl/Shift 多选):", SwingConstants.CENTER);
        instructionLabel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        add(instructionLabel, BorderLayout.NORTH);

        // Table List
        tableList = new JList<>(new Vector<>(tableNames));
        tableList.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        JScrollPane scrollPane = new JScrollPane(tableList);
        add(scrollPane, BorderLayout.CENTER);

        // Buttons Panel
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        JButton okButton = new JButton("确定");
        JButton cancelButton = new JButton("取消");
        JButton selectAllButton = new JButton("全选");

        buttonPanel.add(selectAllButton);
        buttonPanel.add(okButton);
        buttonPanel.add(cancelButton);
        add(buttonPanel, BorderLayout.SOUTH);

        // Action Listeners
        okButton.addActionListener(e -> {
            List<String> selected = tableList.getSelectedValuesList();
            if (selected != null) {
                selectedTables.addAll(selected);
            }
            setVisible(false);
            dispose();
        });

        cancelButton.addActionListener(e -> {
            selectedTables.clear();
            setVisible(false);
            dispose();
        });

        selectAllButton.addActionListener(e -> {
            tableList.setSelectionInterval(0, tableNames.size() - 1);
        });
    }

    /**
     * Returns the set of table names that the user selected.
     * @return A set of selected table names.
     */
    public Set<String> getSelectedTables() {
        return selectedTables;
    }
}
