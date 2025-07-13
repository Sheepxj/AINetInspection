package com.yys.service.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yys.service.StreamService;
import com.yys.util.MinioClientProvider;
import lombok.SneakyThrows;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

@Service
public class StreamServiceimpl implements StreamService {

    private static final Logger logger = LoggerFactory.getLogger(StreamServiceimpl.class);

    @Value("${stream.python-url}")
    private String pythonUrl;



    @Autowired
    private RestTemplate restTemplate;


    @Override
    public String startStream(String[] rtspUrls,String zlmUrls, String[] labels, String taskId, Integer frameSelect,
                              String frameBoxs, Integer intervalTime,Integer frameInterval) {
        String url = pythonUrl + "/start_stream";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        String rtspUrl = rtspUrls[0];

        // 将 frameBoxs 从字符串转换为数组格式（需要确保传入的 frameBoxs 是合法的 JSON 字符串）
        String formattedFrameBoxs;
        List<List<Float>> frameBoxList;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            frameBoxList = objectMapper.readValue(frameBoxs, new TypeReference<List<List<Float>>>() {});
            formattedFrameBoxs = objectMapper.writeValueAsString(frameBoxList);
        } catch (JsonProcessingException e) {
            throw new IllegalArgumentException("frameBoxs 格式错误，无法解析为数组: " + frameBoxs, e);
        }


        JSONObject json = new JSONObject();
        json.put("rtsp_urls", rtspUrl.toString());
        json.put("zlm_url", zlmUrls);
        json.put("labels",labels);
        json.put("frame_select", frameSelect);
        json.put("frame_boxs", frameBoxList);
        json.put("interval_time", intervalTime);
        json.put("frame_interval", frameInterval);
        json.put("task_id", taskId);

        System.out.println(json.toJSONString());

        HttpEntity<String> request = new HttpEntity<>(json.toJSONString(), headers);
        return restTemplate.postForObject(url, request, String.class);
    }



    @Override
    public String stopStream(String name) {
        String url = pythonUrl + "/stop_stream/";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        // 正确构建JSON字符串
        String json = "{\"name\":\"" + name + "\"}";
        HttpEntity<String> request = new HttpEntity<>(json, headers);
        return restTemplate.postForObject(url, request, String.class);
    }

    @SneakyThrows
    @Override
    public int processModelFile(File file) {
        String url = pythonUrl + "/up-model";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("file", new FileSystemResource(file));

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(url, requestEntity, String.class);

        // 检查上传结果
        if (response.getStatusCode().is2xxSuccessful()) {
            return 1;
        } else {
            System.err.println("文件上传失败: " + response.getBody());
            return -1; // 失败返回-1
        }
    }

    @SneakyThrows
    @Override
    public List<String> getimgmsg(String label,File file) {

        String url = pythonUrl + "/get-imgmsg";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("image", new FileSystemResource(file));
        body.add("labels", label);

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(url, requestEntity, String.class);
        List<String> list=new ArrayList<>();
        if (response.getStatusCode().is2xxSuccessful()){
            list = new ObjectMapper().readValue(response.getBody(), List.class);
        }
        return list;
    }



    @Override
    public  Map<String ,Object> getVideoMsg(String videoStream, String cameraId) {

        Map<String ,Object> resultMap = new HashMap<>();

        String url = pythonUrl + "/process_video";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // 创建请求体
        JSONObject json = new JSONObject();
        json.put("video_stream", videoStream);
        json.put("camera_id", cameraId);

        HttpEntity<String> request = new HttpEntity<>(json.toJSONString(), headers);

        // 发送 POST 请求
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);

        if (response.getStatusCode().is2xxSuccessful()) {
            // 解析成功的响应
            String responseBody = response.getBody();
            JSONObject jsonResponse = JSON.parseObject(responseBody);

            boolean success = jsonResponse.getBoolean("success");

            if (success) {
                // 成功时获取视频信息
                int width = jsonResponse.getInteger("width");
                int height = jsonResponse.getInteger("height");
                double fps = jsonResponse.getDouble("fps");
                double aspectRatio = jsonResponse.getDouble("aspect_ratio");
                String codec = jsonResponse.getString("codec");
                String savedImagePath = jsonResponse.getString("frame_path");
                resultMap.put("state", "success");
                resultMap.put("width", width);
                resultMap.put("height", height);
                resultMap.put("fps", fps);
                resultMap.put("codec", codec);
                resultMap.put("aspectRatio", aspectRatio);
                resultMap.put("savedImagePath", savedImagePath);

                return resultMap;
            } else {
                // 处理失败的情况
                resultMap.put("state", "error");
                return resultMap;
            }

        } else if (response.getStatusCode().is5xxServerError()) {
            resultMap.put("state", "error");
            return resultMap;
        } else {
            resultMap.put("state", "error");
            return resultMap;
        }
    }

    @Override
    public List<String> getImgMsg(String filePath) {
        return null;
    }


    // 将数组转换为JSON数组字符串
    private String toJsonArray(String[] array) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < array.length; i++) {
            sb.append("\"").append(array[i]).append("\"");
            if (i < array.length - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    // 自定义Resource类，确保文件名正确传递
    private static class MultipartFileResource extends ByteArrayResource {
        private final String filename;

        public MultipartFileResource(byte[] byteArray, String filename) {
            super(byteArray);
            this.filename = filename;
        }

        @Override
        public String getFilename() {
            return filename;
        }
    }


}
