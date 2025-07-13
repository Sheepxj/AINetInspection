package com.yys.service;


import java.io.IOException;

public interface RadisService {

    //radis部分
    void incrementCounter();

    void setWarningTableId(String uuId, String Id);

    String getWarningTableId(String uuId);

    boolean deleteWarningTableId(String uuId);

    Long getTodayCount();

    Long getYesterdayCount();

    Long getDayBeforeYesterdayCount();

    //获取
    String getAccessTokenKey() throws IOException;




    //插入datasums表。计数
    Integer insertDataSuns(String date, String sums);

    //更新计数
    Integer updateDataSuns(String date, String sums);

    //判断日期是否已经插入
    Integer selectDataSuns(String date);

    String getValue(String key);

    String setValue(String key, String value);

}
