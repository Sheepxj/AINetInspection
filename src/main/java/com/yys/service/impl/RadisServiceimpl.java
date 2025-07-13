package com.yys.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.yys.mapper.RadisCounterMapper;
import com.yys.service.RadisService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import com.yys.util.MyHttpRequestUtil;
import com.yys.wechatconfig.WechatConstant;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;

// Redis计数器服务实现类
@Service
public class RadisServiceimpl implements RadisService {

    private static final Logger logger = LoggerFactory.getLogger(RadisServiceimpl.class);

    // 定义日期格式化器，用于生成Redis键名中的日期部分
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");


    // 注入Redis模板，用于操作Redis数据库
    @Autowired
    private StringRedisTemplate redisTemplate;

    @Autowired
    private RadisCounterMapper redisCounterMapper;

    private static final String ACCESS_TOKEN_KEY = "access_token";

    @Override
    public String getAccessTokenKey() throws IOException {
        // 尝试从 Redis 中获取 access_token
        String accessToken = redisTemplate.opsForValue().get(ACCESS_TOKEN_KEY);

        // 检查 access_token 是否存在且有效
        if (StringUtils.isNotBlank(accessToken) && validateAccessToken(accessToken)) {
            logger.info("从Redis中获取到access_token：{}", accessToken);
            return accessToken;
        }

        // 使用同步锁防止并发重复获取
        synchronized (this) {
            // 双重检查锁定
            accessToken = redisTemplate.opsForValue().get(ACCESS_TOKEN_KEY);
            if (StringUtils.isNotBlank(accessToken) && validateAccessToken(accessToken)) {
                logger.info("从Redis中获取到access_token：{}", accessToken);
                return accessToken;
            }

            // 获取新token
            String response = MyHttpRequestUtil.HttpGet(WechatConstant.api_wechat_template);
            JSONObject jsonResponse = JSONObject.parseObject(response);
            accessToken = jsonResponse.getString("access_token");

            // 存入Redis（建议使用微信返回的expires_in设置过期时间）
            int expiresIn = jsonResponse.getIntValue("expires_in");
            redisTemplate.opsForValue().set(
                    ACCESS_TOKEN_KEY,
                    accessToken,
                    expiresIn - 300,  // 提前5分钟过期
                    TimeUnit.SECONDS
            );

            logger.info("获取access_token成功：{}", accessToken);

            return accessToken;
        }
    }

    // 优化后的验证方法
    private boolean validateAccessToken(String accessToken) {
        try {
            String testUrl = "https://api.weixin.qq.com/cgi-bin/get_api_domain_ip?access_token=" + accessToken;
            String response = MyHttpRequestUtil.HttpGet(testUrl);
            JSONObject jsonResponse = JSONObject.parseObject(response);
            return !jsonResponse.containsKey("errcode");
        } catch (Exception e) {
            logger.error("验证access_token失败", e);
            return false;
        }
    }

    /**
     * 增加计数器的值
     * 每天对应一个唯一的Redis键，此方法用于增加当天的计数
     */
    @Override
    public void incrementCounter() {
        // 获取当前日期对应的Redis键名
        String todayKey = getKeyForDate(LocalDate.now());
        // 增加当天计数器的值
        redisTemplate.opsForValue().increment(todayKey);
        // 设置过期时间为3天，以确保计数器不会无限增长
        redisTemplate.expire(todayKey, 4, TimeUnit.DAYS);
    }

    @Override
    public void setWarningTableId(String uuId, String Id) {
        redisTemplate.opsForValue().set(uuId, Id);
    }

    @Override
    public String getWarningTableId(String uuId) {
        return redisTemplate.opsForValue().get(uuId);
    }

    @Override
    public boolean deleteWarningTableId(String uuId) {
        return redisTemplate.delete(uuId);
    }

    /**
     * 获取当天的计数
     *
     * @return 当天的计数
     */
    @Override
    public Long getTodayCount() {
        String todayKey = getKeyForDate(LocalDate.now());
        return getCount(todayKey);
    }

    /**
     * 获取昨天的计数
     *
     * @return 昨天的计数
     */
    @Override
    public Long getYesterdayCount() {
        String yesterdayKey = getKeyForDate(LocalDate.now().minusDays(1));
        return getCount(yesterdayKey);
    }

    /**
     * 获取前天的计数
     *
     * @return 前天的计数
     */
    @Override
    public Long getDayBeforeYesterdayCount() {
        String dayBeforeYesterdayKey = getKeyForDate(LocalDate.now().minusDays(2));
        return getCount(dayBeforeYesterdayKey);
    }

    @Override
    public Integer insertDataSuns(String date, String sums) {
        return redisCounterMapper.insertDataSuns(date, sums);
    }

    @Override
    public Integer updateDataSuns(String date, String sums) {
        return redisCounterMapper.updateDataSuns(date, sums);
    }

    @Override
    public Integer selectDataSuns(String date) {
        return redisCounterMapper.selectDataSuns(date);
    }

    @Override
    public String getValue(String key) {
        return redisTemplate.opsForValue().get(key);
    }

    @Override
    public String setValue(String key, String value) {
        redisTemplate.opsForValue().set(key, value, 20, TimeUnit.MINUTES);
        return "保存成功";
    }

    /**
     * 根据日期生成Redis键名
     *
     * @param date 需要生成键名的日期
     * @return 生成的Redis键名
     */
    private String getKeyForDate(LocalDate date) {
        return "counter:" + date.format(FORMATTER);
    }

    /**
     * 获取指定键的计数
     * 如果键不存在或值不是数字，将返回0
     *
     * @param key Redis键名
     * @return 键对应的计数
     */
    private Long getCount(String key) {
        String count = redisTemplate.opsForValue().get(key);
        return count != null ? Long.parseLong(count) : 0L;
    }
}

