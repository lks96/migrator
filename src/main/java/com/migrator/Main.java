package com.migrator;


import com.migrator.ui.MigrationUI;

import javax.swing.SwingUtilities;

/**
 * 应用程序的主入口点。
 * 此类负责在事件调度线程上创建和显示主UI。
 */
public class Main {

    /**
 * 启动应用程序的主方法。
 * @param args 命令行参数（未使用）。
 */
    public static void main(String[] args) {
        // 确保GUI在事件调度线程上创建和更新。
        SwingUtilities.invokeLater(() -> {
            // 创建主UI类的实例并显示它。
            // MigrationUI构造函数将初始化所有必要的组件和控制器。
            new MigrationUI().createAndShowGUI();
        });
    }
}
