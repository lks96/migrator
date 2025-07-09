package com.migrator;

import javax.swing.*;
import java.awt.*;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class TableSelectionDialog extends JDialog {
    private final JList<String> tableList;
    private final DefaultListModel<String> listModel;
    private final JButton confirmButton;
    private final Set<String> selectedTables = new HashSet<>();

    public TableSelectionDialog(Frame owner, List<String> tables) {
        super(owner, "选择要迁移的表", true);
        setSize(400, 500);
        setLocationRelativeTo(owner);

        listModel = new DefaultListModel<>();
        tables.forEach(listModel::addElement);

        tableList = new JList<>(listModel);
        tableList.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        tableList.setFont(new Font("微软雅黑", Font.PLAIN, 14));

        JScrollPane scrollPane = new JScrollPane(tableList);

        // 底部按钮
        JPanel buttonPanel = new JPanel();
        JButton selectAll = new JButton("全选");
        JButton deselectAll = new JButton("取消选择");
        confirmButton = new JButton("开始迁移");

        selectAll.addActionListener(e -> tableList.setSelectionInterval(0, listModel.size() - 1));
        deselectAll.addActionListener(e -> tableList.clearSelection());

        confirmButton.addActionListener(e -> {
            selectedTables.clear();
            selectedTables.addAll(tableList.getSelectedValuesList());
            setVisible(false); // 关闭对话框
        });

        buttonPanel.add(selectAll);
        buttonPanel.add(deselectAll);
        buttonPanel.add(confirmButton);

        add(scrollPane, BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);
    }

    public Set<String> getSelectedTables() {
        return selectedTables;
    }
}
