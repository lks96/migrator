package com.migrator.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    public static String YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
    public static String YYYY_MM_DD_HH_MM = "yyyy-MM-dd HH:mm";
    public static String YYYY_MM_DD = "yyyy-MM-dd";
    public static String YYYY_MM_DD_HH = "yyyy-MM-dd HH";
    public static String HHMMSS = "HHmmss";


    /**
     * 获取当前时间的字符串 YYYY_MM_DD_HH_MM_SS
     */
     public static String getNowStr(){
         Date date = new Date();
         DateFormat dateFormat = new SimpleDateFormat(YYYY_MM_DD_HH_MM_SS);
         return dateFormat.format(date);
     }

    /**
     * 获取当前时间的字符串 YYYY_MM_DD_HH_MM_SS
     */
    public static String getNowStr(String format){
        Date date = new Date();
        DateFormat dateFormat = new SimpleDateFormat(format);
        return dateFormat.format(date);
    }
}
