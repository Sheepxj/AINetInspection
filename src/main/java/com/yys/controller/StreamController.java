package com.yys.controller;

import com.alibaba.fastjson2.JSON;
import com.yys.entity.AiZlm;
import com.yys.entity.Result;
import com.yys.service.AiZlmService;
import com.yys.service.ZlmediakitService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


import java.util.Map;
import java.util.UUID;


@RestController
@RequestMapping("/streams")
@CrossOrigin
public class StreamController {

    private static final Logger logger = LoggerFactory.getLogger(StreamController.class);

    @Autowired
    private AiZlmService aiZlmService;

    @Autowired
    private ZlmediakitService zlmediakitService;


    @PostMapping("/Preview")
    public String startStream(@RequestBody Map<String, Object> requestBody) {

        String stream = (String) requestBody.get("videostream");

        AiZlm aiZlm = new AiZlm()
                .setZlmApp("test")
                .setZlmStream(generateFourCharUUID())
                .setVideoStream(stream);

        String videoUrl = zlmediakitService.getVideo(aiZlm);

        if (videoUrl != null){
            return JSON.toJSONString(Result.success(200, "获取成功", 1, videoUrl));
        }
        return JSON.toJSONString(Result.success(500, "获取失败", 0, null));

    }

    //启动忙流
    @GetMapping("/startzlm")
    public String getStreamUrl(@RequestParam(value = "id") Integer id){

        if (id == null || id <= 0) {
            logger.warn("无效的ID: {}", id);
            return JSON.toJSONString(Result.error("无效的ID"));
        }

        try {
            AiZlm aiZlm = aiZlmService.getById(id);
            if (aiZlm == null) {
                logger.warn("未找到对应的流 id: {}", id);
                return JSON.toJSONString(Result.error( "未找到对应的流"));
            }

            // 使用 synchronized 确保同一 id 的流启动逻辑不会被重复执行
            synchronized (this) {
                boolean isUsable = zlmediakitService.getZlmkey(aiZlm);
                if (!isUsable) {
                    logger.info("视频流开始播放id: {}", id);
                    zlmediakitService.getVideo(aiZlm);
                }
            }

            logger.info("id的流已成功启动: {}", id);
            return JSON.toJSONString(Result.success(200, "开启成功", 1, null));

        } catch (Exception e) {
            logger.error("处理id请求时出错: {}", id, e);
            return JSON.toJSONString(Result.success(500, "开启失败", 1, null));
        }
    }

    @GetMapping("/stopzlm")
    public String stopStream(@RequestParam(value = "id") Integer id){

        if (id == null || id <= 0) {
            logger.warn("无效的ID: {}", id);
            return JSON.toJSONString(Result.error("无效的ID"));
        }

        try {
            AiZlm aiZlm = aiZlmService.getById(id);

            if (aiZlm == null) {
                logger.warn("未找到对应的流 id: {}", id);
                return JSON.toJSONString(Result.error( "未找到对应的流"));
            }

            // 使用 synchronized 确保同一 id 的流启动逻辑不会被重复执行
            synchronized (this) {
                boolean isUsable = zlmediakitService.getZlmkey(aiZlm);
                if (isUsable) {
                    logger.info("Starting stream for id: {}", id);
                    zlmediakitService.deleteVideo(aiZlm);
                }
            }

            logger.info("id的流已成功停止: {}", id);
            return JSON.toJSONString(Result.success(200, "停止成功", 1, null));

        } catch (Exception e) {
            logger.error("处理id请求时出错: {}", id, e);
            return JSON.toJSONString(Result.success(500, "停止失败", 1, null));
        }

    }
    public static String generateFourCharUUID() {
        UUID uuid = UUID.randomUUID();
        String uuidStr = uuid.toString().replace("-", ""); // 去掉UUID中的连字符
        return uuidStr.substring(0, 4); // 提取前四个字符
    }


}

