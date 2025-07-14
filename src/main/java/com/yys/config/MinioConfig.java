package com.yys.config;

import java.time.LocalDate;
import java.util.Date;

public class MinioConfig {

    public static final String  BUCKER_NAME = "ai-video";

    public static final String  OCR_IMG = "ocr-database";

    // 获取时间戳
    public static String sanitizeFileName() {
        String sanitized = String.valueOf(new Date().getTime());
        return sanitized;
    }



    // 获取当前年份
    public static String getCurrentYear() {
        return String.valueOf(LocalDate.now().getYear());
    }

    // 获取当前月份
    public static String getCurrentMonth() {
        return String.valueOf(LocalDate.now().getMonthValue());
    }

    // 获取当前日
    public static String getCurrentDay() {
        return String.valueOf(LocalDate.now().getDayOfMonth());
    }


}
