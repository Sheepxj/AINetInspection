package com.yys.service;


import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.Map;

public interface StreamService {

    // 启动视频流
    String startStream(String[] rtspUrls,String zlmUrls,  String[] modelPaths,String taskId,Integer frameSelect ,String frameBoxs,Integer intervaltime,Integer frameInterval) ;

    // 停止视频流
    String stopStream(String name);

    int processModelFile(File file);

    //模型测试
    List<String> getimgmsg(String label,File file);


    Map<String ,Object> getVideoMsg(String videoStream, String cameraId);

    List<String> getImgMsg(String filePath);



}


