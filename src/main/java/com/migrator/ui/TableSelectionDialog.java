package com.migrator.ui;

import javax.swing.*;
import java.awt.*;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Vector;

/**
 * 用于选择要迁移的表的对话框窗口。
 * 它显示可用表的列表，并带有用于选择的复选框。
 */
public class TableSelectionDialog extends JDialog {

    private final JList<String> tableList;
    private final Set<String> selectedTables = new HashSet<>();

    /**
 * TableSelectionDialog的构造方法。
 * @param parent 父框架。
 * @param tableNames 要显示的表名列表。
 */
    public TableSelectionDialog(Frame parent, List<String> tableNames) {
        super(parent, "选择要迁移的表", true);
        setSize(400, 600);
        setLocationRelativeTo(parent);
        setLayout(new BorderLayout(10, 10));

        // 说明
        JLabel instructionLabel = new JLabel("请选择要迁移的表 (支持 Ctrl/Shift 多选):", SwingConstants.CENTER);
        instructionLabel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        add(instructionLabel, BorderLayout.NORTH);

        // 表列表
        tableList = new JList<>(new Vector<>(tableNames));
        tableList.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        JScrollPane scrollPane = new JScrollPane(tableList);
        add(scrollPane, BorderLayout.CENTER);

        // 按钮面板
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        JButton okButton = new JButton("确定");
        JButton cancelButton = new JButton("取消");
        JButton selectAllButton = new JButton("全选");

        buttonPanel.add(selectAllButton);
        buttonPanel.add(okButton);
        buttonPanel.add(cancelButton);
        add(buttonPanel, BorderLayout.SOUTH);

        // 动作监听器
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
 * 返回用户选择的表名集合。
 * @return 选中的表名集合。
 */
    public Set<String> getSelectedTables() {
        return selectedTables;
    }
}
