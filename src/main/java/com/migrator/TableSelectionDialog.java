package com.migrator;

import javax.swing.*;
import java.awt.*;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class TableSelectionDialog extends JDialog {
    private JList<String> tableList;
    private DefaultListModel<String> listModel;
    private JButton selectAllButton, deselectAllButton, okButton, cancelButton;
    private Set<String> selectedTables = new TreeSet<>();

    public TableSelectionDialog(Frame owner, List<String> tables) {
        super(owner, "选择要迁移的表", true);
        setSize(600, 400);
        setLocationRelativeTo(owner);
        setLayout(new BorderLayout());

        // 创建列表
        listModel = new DefaultListModel<>();
        for (String table : tables) {
            listModel.addElement(table);
        }
        tableList = new JList<>(listModel);
        tableList.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        tableList.setVisibleRowCount(15);
        JScrollPane scrollPane = new JScrollPane(tableList);

        // 创建按钮面板
        JPanel buttonPanel = new JPanel();
        selectAllButton = new JButton("全选");
        deselectAllButton = new JButton("取消全选");
        okButton = new JButton("确定");
        cancelButton = new JButton("取消");

        buttonPanel.add(selectAllButton);
        buttonPanel.add(deselectAllButton);
        buttonPanel.add(okButton);
        buttonPanel.add(cancelButton);

        // 添加组件
        add(scrollPane, BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);

        // 添加事件监听器
        selectAllButton.addActionListener(e -> tableList.setSelectionInterval(0, listModel.size() - 1));
        deselectAllButton.addActionListener(e -> tableList.clearSelection());
        okButton.addActionListener(e -> {
            List<String> selected = tableList.getSelectedValuesList();
            selectedTables.addAll(selected);
            dispose();
        });
        cancelButton.addActionListener(e -> dispose());
    }

    public Set<String> getSelectedTables() {
        return selectedTables;
    }
}    