package com.migrator.util;
import java.io.IOException;
import java.io.Reader;
import java.sql.Clob;
import java.sql.SQLException;

/**
 * A utility class for handling CLOB data types.
 */
public class ClobUtil {

    /**
     * Converts a java.sql.Clob object to a String.
     * @param clob The Clob object to convert.
     * @return The String representation of the Clob, or null if the input is null.
     * @throws SQLException if a database access error occurs.
     * @throws IOException if an I/O error occurs.
     */
    public static String clobToString(Clob clob) throws SQLException, IOException {
        if (clob == null) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        try (Reader reader = clob.getCharacterStream()) {
            char[] buffer = new char[1024];
            int len;
            while ((len = reader.read(buffer)) != -1) {
                sb.append(buffer, 0, len);
            }
        }
        return sb.toString();
    }
}
