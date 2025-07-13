package com.yys.service.impl;

import com.alibaba.fastjson2.JSONObject;
import com.yys.config.MediaConfig;
import com.yys.entity.AiZlm;
import com.yys.service.ZlmediakitService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@Service
public class ZlmediakitServiceImpl implements ZlmediakitService {

    private static final Logger logger = LoggerFactory.getLogger(ZlmediakitServiceImpl.class);

    @Autowired
    private MediaConfig mediaConfig;

    @Autowired
    private RestTemplate restTemplate;

    @Value("${media.http-nginx}")
    private String zlmnginx;

    @Value("${datapath.downloadpath}")
    private String downloadpath;

    @Override
    public String getVideo(AiZlm aiZlm) {
        String url = "http://" + mediaConfig.getIp() + ":" + mediaConfig.getPort() + "/index/api/addStreamProxy";
        HttpHeaders headers = new HttpHeaders();

        headers.setContentType(MediaType.APPLICATION_JSON);
        // 创建请求体
        JSONObject json = new JSONObject();
        json.put("vhost", mediaConfig.getIp() + ":" + mediaConfig.getPort());
        json.put("app", aiZlm.getZlmApp());
        json.put("stream", aiZlm.getZlmStream());
        json.put("url", aiZlm.getVideoStream());
        json.put("secret", mediaConfig.getSecret());

        setFixedConfig(json);

        HttpEntity<String> request = new HttpEntity<>(json.toJSONString(), headers);


        // 发送 POST 请求
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);

        // 解析 JSON 响应
        if (response.getStatusCode() == HttpStatus.OK) {
            String responseBody = response.getBody();
            JSONObject jsonObject = JSONObject.parseObject(responseBody);
            if (jsonObject.getIntValue("code") == 0) {

                String videoUrl = "/" + zlmnginx + "/" + aiZlm.getZlmApp() + "/" + aiZlm.getZlmStream() + ".live.ts";

                return videoUrl;

            }
        }

        return null;
    }

    @Override
    public AiZlm addVideo(AiZlm aiZlm) {
        String url = "http://" + mediaConfig.getIp() + ":" + mediaConfig.getPort() + "/index/api/addStreamProxy";
        HttpHeaders headers = new HttpHeaders();

        aiZlm.setZlmVhost(mediaConfig.getIp() + ":" + mediaConfig.getPort());

        headers.setContentType(MediaType.APPLICATION_JSON);
        // 创建请求体
        JSONObject json = new JSONObject();
        json.put("vhost", aiZlm.getZlmVhost());
        json.put("app", aiZlm.getZlmApp());
        json.put("stream", aiZlm.getZlmStream());
        json.put("url", aiZlm.getVideoStream());
        json.put("secret", mediaConfig.getSecret());

        setFixedConfig(json);

        HttpEntity<String> request = new HttpEntity<>(json.toJSONString(), headers);

        // 发送 POST 请求
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);

        // 解析 JSON 响应
        if (response.getStatusCode() == HttpStatus.OK) {
            String responseBody = response.getBody();
            JSONObject jsonObject = JSONObject.parseObject(responseBody);
            if (jsonObject.getIntValue("code") == 0) {

                String videoUrl = jsonObject.getJSONObject("data").getString("key");

                aiZlm.setZlmKey(videoUrl);

                String Url = "/" + zlmnginx + "/" + aiZlm.getZlmApp() + "/" + aiZlm.getZlmStream() + ".live.ts";

                aiZlm.setZlmUrl(Url);

                return aiZlm;

            }
        }

        return null; // 解析失败或 code 不是 0
    }

    @Override
    public boolean deleteVideo(AiZlm aiZlm) {

        String url = "http://" + mediaConfig.getIp() + ":" + mediaConfig.getPort() + "/index/api/delStreamProxy";
        HttpHeaders headers = new HttpHeaders();

        aiZlm.setZlmVhost(mediaConfig.getIp() + ":" + mediaConfig.getPort());

        headers.setContentType(MediaType.APPLICATION_JSON);
        // 创建请求体
        JSONObject json = new JSONObject();
        json.put("secret", mediaConfig.getSecret());
        json.put("key", aiZlm.getZlmKey());


        HttpEntity<String> request = new HttpEntity<>(json.toJSONString(), headers);

        // 发送 POST 请求
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);

        // 解析 JSON 响应
        if (response.getStatusCode() == HttpStatus.OK) {
            String responseBody = response.getBody();
            JSONObject jsonObject = JSONObject.parseObject(responseBody);
            if (jsonObject.getIntValue("code") == 0) {
                return jsonObject.getJSONObject("data").getBooleanValue("flag");
            }
        }

        return false; // 解析失败或 code 不是 0
    }

    @Override
    public String getPlayUrl(AiZlm aiZlm) {
        return "";
    }

    @Override
    public boolean getZlmkey(AiZlm aiZlm) {
        String url = "http://" + mediaConfig.getIp() + ":" + mediaConfig.getPort() + "/index/api/isMediaOnline";
        HttpHeaders headers = new HttpHeaders();

        aiZlm.setZlmVhost(mediaConfig.getIp() + ":" + mediaConfig.getPort());

        headers.setContentType(MediaType.APPLICATION_JSON);
        // 创建请求体
        JSONObject json = new JSONObject();
        json.put("secret", mediaConfig.getSecret());
        json.put("schema", "ts");
        json.put("vhost", aiZlm.getZlmVhost());
        json.put("app", aiZlm.getZlmApp());
        json.put("stream", aiZlm.getZlmStream());


        HttpEntity<String> request = new HttpEntity<>(json.toJSONString(), headers);

        // 发送 POST 请求
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);

        // 解析 JSON 响应
        if (response.getStatusCode() == HttpStatus.OK) {
            String responseBody = response.getBody();
            JSONObject jsonObject = JSONObject.parseObject(responseBody);
            if (jsonObject.getIntValue("code") == 0) {
                return jsonObject.getBooleanValue("online");
            }
        }

        return false;
    }

    @Override
    public String getImg(String videoStream) {
        String url = "http://" + mediaConfig.getIp() + ":" + mediaConfig.getPort() + "/index/api/getSnap";
        HttpHeaders headers = new HttpHeaders();

        headers.setContentType(MediaType.APPLICATION_JSON);
        // 创建请求体
        JSONObject json = new JSONObject();
        json.put("secret", mediaConfig.getSecret());
        json.put("url", videoStream);
        json.put("timeout_sec", 10);
        json.put("expire_sec", 1);


        HttpEntity<String> request = new HttpEntity<>(json.toJSONString(), headers);

        // 发送 POST 请求
        ResponseEntity<byte[]> response = restTemplate.exchange(url, HttpMethod.POST, request, byte[].class);
        long currentTimestamp = System.currentTimeMillis();
        String filePath = downloadpath+currentTimestamp+".jpeg";

        // 检查响应状态码
        if (response.getStatusCode() == HttpStatus.OK) {
            byte[] imageBytes = response.getBody();

            // 保存图片到本地文件
            try {

                Files.write(Paths.get(filePath), imageBytes);
                System.out.println("图片已保存到: " + filePath);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            logger.error("获取图片失败，状态码: " + response.getStatusCode());
            return null;
        }

        return filePath;
    }


    private void setFixedConfig(JSONObject json) {
        json.put("retry_count", -1);
        json.put("rtp_type", 0);
        json.put("timeout_sec", 5);
        json.put("mp4_max_second", 10);
        json.put("enable_ts", true);
        json.put("auto_close", true);
        json.put("enable_hls", false);
        json.put("enable_hls_fmp4", false);
        json.put("enable_mp4", false);
        json.put("enable_rtsp", false);
        json.put("enable_rtmp", false);
        json.put("enable_fmp4", false);
        json.put("hls_demand", false);
        json.put("rtsp_demand", false);
        json.put("rtmp_demand", false);
        json.put("ts_demand", false);
        json.put("fmp4_demand", false);
        json.put("enable_audio", false);
        json.put("add_mute_audio", false);
        json.put("mp4_as_player", false);
    }
}
