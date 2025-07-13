package com.yys.util;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JobUtil {

    public static Map<String, Object> getCronMsg(String Email, String cronExpression){

        Map<String, Object> result = new HashMap<>();

        result.put("ChatIds", Email);

        String[] parts = cronExpression.split(" ");

        String minute = parts[1];

        String hour = parts[2];

        String dayOfWeek = parts[5];

        String[] hours =hour.split("-");
        result.put("startTime", String.format("%02d", Integer.parseInt(hours[0])));

        if(minute.length()>1){
            result.put("durationUnit","分钟");
            result.put("duration",minute.split("/")[1]);

            result.put("endTime", String.format("%02d", (Integer.parseInt(hours[1]))+1));
        }else {
            result.put("durationUnit","小时");
            result.put("duration",hour.split("/")[1]);

            result.put("endTime", String.format("%02d", (Integer.parseInt(hours[1].split("/")[0]))+1));
        }

        result.put("days",dayOfWeek.split(","));

        return result;

    }

    public static Map<String, Object> getCronMsg(String cronExpression){

        Map<String, Object> result = new HashMap<>();

        String[] parts = cronExpression.split(" ");

        String minute = parts[1];

        String hour = parts[2];

        String dayOfWeek = parts[5];

        String[] hours =hour.split("-");
        result.put("startTime", String.format("%02d", Integer.parseInt(hours[0])));

        if(minute.length()>1){
            result.put("durationUnit","分钟");
            result.put("duration",minute.split("/")[1]);

            result.put("endTime", String.format("%02d", (Integer.parseInt(hours[1]))+1));
        }else {
            result.put("durationUnit","小时");
            result.put("duration",hour.split("/")[1]);

            result.put("endTime", String.format("%02d", (Integer.parseInt(hours[1].split("/")[0]))+1));
        }

        result.put("days",dayOfWeek.split(","));

        return result;

    }

    public static Map<String, Object> getoneCronMsg( String cronExpression){

        Map<String, Object> result = new HashMap<>();


        String[] parts = cronExpression.split(" ");

        String second = parts[0];

        String minute = parts[1];

        String hour = parts[2];


        if(second.length()>1){
            result.put("durationUnit","秒");
            result.put("duration",second.split("/")[1]);

        }

        if(minute.length()>1){
            result.put("durationUnit","分钟");
            result.put("duration",minute.split("/")[1]);

        }
        if(hour.length()>1) {
            result.put("durationUnit","小时");
            result.put("duration",hour.split("/")[1]);

        }

        return result;

    }


    public static String[] getPreviousNodeTime(Map<String, Object> cronParams) {

        // 获取传入的参数
        Integer startTime = Integer.parseInt((String) cronParams.get("startTime"));
        Integer endTime = Integer.parseInt((String) cronParams.get("endTime"));
        String timeType = (String) cronParams.get("durationUnit");
        Integer duration = Integer.parseInt((String) cronParams.get("duration"));
        String[] days = (String[]) cronParams.get("days");

        // 获取当前时间
        Calendar currentCalendar = Calendar.getInstance();
        int currentHour = currentCalendar.get(Calendar.HOUR_OF_DAY);
        int currentMinute = currentCalendar.get(Calendar.MINUTE);
        int currentDayOfWeek = currentCalendar.get(Calendar.DAY_OF_WEEK) - 1;  // 0-6 (Sunday-Saturday)

        // 格式化时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // 当前时间
        String currentTime = dateFormat.format(currentCalendar.getTime());

        // 计算“上一个节点”时间
        Calendar previousNodeCalendar = (Calendar) currentCalendar.clone();
        if (timeType.equalsIgnoreCase("小时")) {
            previousNodeCalendar.add(Calendar.HOUR_OF_DAY, -duration);
        } else if (timeType.equalsIgnoreCase("分钟")) {
            previousNodeCalendar.add(Calendar.MINUTE, -duration);
        }

        String previousNodeTime = dateFormat.format(previousNodeCalendar.getTime());

        // 判断当前时间是否在有效的时间范围内
        boolean isWithinTimeRange = (startTime <= currentHour && currentHour < endTime);
        boolean isWithinSelectedDays = false;

        // 判断当前是否在选定的星期内
        for (String day : days) {
            if (Integer.parseInt(day) == currentDayOfWeek) {
                isWithinSelectedDays = true;
                break;
            }
        }

        // 如果当前时间不在有效区间内，处理跨周问题
        if (!isWithinTimeRange || !isWithinSelectedDays) {
            // 计算上一有效节点时间
            Calendar previousValidNode = findPreviousValidNode(days, startTime, endTime, currentCalendar);
            String previousValidNodeTime = dateFormat.format(previousValidNode.getTime());

            return new String[] { previousValidNodeTime, currentTime };
        } else {
            // 如果当前时间在有效时间区间内
            return new String[] { previousNodeTime,  currentTime};
        }
    }

    private static Calendar findPreviousValidNode(String[] days, Integer startTime, Integer endTime, Calendar currentCalendar) {
        // 找到最近的上一个有效节点时间（跨周处理）
        Calendar previousValidNode = (Calendar) currentCalendar.clone();
        int currentDayOfWeek = currentCalendar.get(Calendar.DAY_OF_WEEK) - 1;  // 0-6 (Sunday-Saturday)

        // 如果当前时间不在有效范围内，则需要查找上一个符合条件的日期时间
        boolean found = false;
        while (!found) {
            previousValidNode.add(Calendar.DATE, -1);  // 回退一天
            int prevDay = previousValidNode.get(Calendar.DAY_OF_WEEK) - 1;
            if (Arrays.asList(days).contains(String.valueOf(prevDay))) {
                // 找到上一个有效工作日
                previousValidNode.set(Calendar.HOUR_OF_DAY, endTime);  // 设置为结束时间
                previousValidNode.set(Calendar.MINUTE, 0);            // 设置分钟为 0
                found = true;
            }
        }
        return previousValidNode;
    }
}