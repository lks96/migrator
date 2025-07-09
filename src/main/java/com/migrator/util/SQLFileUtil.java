package com.migrator.util;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

/**
 * A utility class for writing SQL statements to files.
 */
public class SQLFileUtil {

    /**
     * Appends an erroneous SQL statement to a specified error file.
     * @param sql The SQL statement that caused an error.
     * @param filePath The path to the error log file.
     */
    public static void errorSql(String sql, String filePath){

        try {
            if (filePath == null || filePath.trim().isEmpty()) return;
            Files.createDirectories(Paths.get(filePath).getParent());
            String content = sql + "\n\n";
            Files.write(Paths.get(filePath),
                    content.getBytes("UTF-8"),
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
        } catch (Exception e) {

        }
    }

    /**
     * Appends a successful SQL statement to a specified success file.
     * @param sql The SQL statement that was executed successfully.
     * @param filePath The path to the success log file.
     */
    public static void successSql(String sql, String filePath){
        try {
            if (filePath == null || filePath.trim().isEmpty()) return;
            Files.createDirectories(Paths.get(filePath).getParent());
            String content = sql + "\n\n";
            Files.write(Paths.get(filePath),
                    content.getBytes("UTF-8"),
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
        } catch (Exception e) {

        }

    }
}
