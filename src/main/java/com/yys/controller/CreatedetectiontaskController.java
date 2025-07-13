package com.yys.controller;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.yys.entity.AiCamera;
import com.yys.entity.AiModel;
import com.yys.entity.DetectionTask;
import com.yys.entity.Result;
import com.yys.service.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/createdetectiontask")
@CrossOrigin
public class CreatedetectiontaskController {

    @Autowired
    private CreatedetectiontaskService createdetectiontaskService;

    @Autowired
    private DetectionTaskService detectionTaskService;

    @Autowired
    private AiCameraService aiCameraService;

    @Autowired
    private AiModelService aiModelService;

    @Autowired
    private StreamService streamService;

    @Value("${media.ip}")
    private String zlmip;

    @Value("${media.http-port}")
    private String zlmport;

    @Value("${media.http-nginx}")
    private String zlmnginx;

    @RequestMapping("/insertDetectiontask")
    public String insertDetectiontask(@RequestBody DetectionTask detectionTask) {

        if(detectionTask.getStatus() == 0){
            return waitstartDetectiontask(detectionTask);

        }else {
            return startDetectiontask(detectionTask);
        }
    }

    @RequestMapping("/updateDetectiontask")
    private String updateDetectiontask(@RequestBody DetectionTask detectionTask) {
        int i=detectionTaskService.selectDetectionTaskStatus(String.valueOf(detectionTask.getId()));
        if (i!=0){
            return JSON.toJSONString(Result.success(500,"任务未停止，请先停止任务再修改",1,null));
        }
        if(detectionTask.getStatus() == 0){
            return toupdateDetectiontask(detectionTask);
        }else {
            return JSON.toJSONString(Result.success(500,"任务创建失败",1,null));
        }
    }


    @RequestMapping("/selectAimodels")
    public String selectAimodels() {
        List<AiModel> list = createdetectiontaskService.selectAimodels();
        if (list != null) {
            return JSON.toJSONString(Result.success("获取成功",list.size(),list));
        }
        return JSON.toJSONString(Result.success("获取失败",0,list));
    }

    @RequestMapping("/startvideostream")
    public String starttvideostream(String Id) {
        DetectionTask detectionTask = detectionTaskService.getById(Id); // 根据ID获取任务信息
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // 读取数据库，获取摄像头信息
        Integer cameraId = detectionTask.getCameraId();
        AiCamera camera = aiCameraService.getById(cameraId);

        Integer width = camera.getCameraWidth(); // 摄像头宽度
        Integer height = camera.getCameraHeight(); // 摄像头高度
        Integer camerafps = camera.getVideoRate(); // 摄像头帧率
        Integer fps = 0;
        if (detectionTask.getSetTime() != null) {
            fps = camerafps * detectionTask.getSetTime(); // 计算任务的帧率
        }

        // 转换框选区域坐标
        String box = transformCoordinates(detectionTask.getFrameBoxs(), width, height);

        // 获取摄像头的RTSP地址和ZLM URL
        String[] rtspUrls = new String[1];
        rtspUrls[0] = camera.getVideoStreaming();
        String zlmUrl = getZlmUrl(camera.getZlmUrl());

        // 获取任务关联的模型路径
        List<AiModel> list = aiModelService.selectModel(detectionTask.getIds());
        String[] labels = new String[list.size()];
        String modelName = "";
        for (int i = 0; i < list.size(); i++) {
            labels[i] =  list.get(i).getModel();
        }

        // 启动视频流检测任务
        String taskId = detectionTaskService.selectTaskId(Integer.valueOf(Id));
        String taskTagging = streamService.startStream(rtspUrls, zlmUrl, labels, taskId, detectionTask.getFrameSelect(), box, fps, detectionTask.getFrameInterval());

        // 解析返回的JSON字符串
        JSONObject jsonObject = new JSONObject(taskTagging);
        String threadName = jsonObject.getString("thread_name");

        detectionTask.setTaskTagging(threadName); // 设置任务的线程名称
        if (detectionTask.getTaskTagging() != null && detectionTask.getTaskTagging().length() > 0) {
            detectionTask.setStatus(1); // 设置任务状态为1（启动）
            detectionTask.setStartTime(sdf.format(new Date()));
            detectionTask.setId(Integer.valueOf(Id));
            boolean success = detectionTaskService.updateById(detectionTask); // 更新任务信息
            if (success) {
                return JSON.toJSONString(Result.success("启动任务成功", 1, null)); // 启动成功
            }
        }
        return JSON.toJSONString(Result.success("启动任务失败", 0, null)); // 启动失败
    }

    @RequestMapping("/stopvideostream")
    public String stoptvideostream(String Id) {
        String taskTagging = createdetectiontaskService.selecttaskTagging(Id);

        streamService.stopStream(taskTagging);
        String endTime = getnowtime();
        int i=createdetectiontaskService.updateDetectiontask(Id,0,endTime);
        if (i>0){
            return JSON.toJSONString(Result.success("停止成功",1,null));
        }

        return JSON.toJSONString(Result.success("停止失败",0,null));
    }

    private String generateCameraId() {
        String oldId = createdetectiontaskService.selectdtid();
        if (oldId == null || oldId.isEmpty()) {
            return "task-001";
        }

        String numericPart = oldId.replaceAll("[^0-9]", "");
        if (numericPart.isEmpty()) {
            return "task-001";
        }
        int newNumericPart = Integer.parseInt(numericPart) + 1;
        return String.format("task-%03d", newNumericPart);
    }

    private String startDetectiontask(DetectionTask detectionTask) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        detectionTask.setCreateTime(sdf.format(new Date()));

        String[] rtspUrls = new String[1];
        rtspUrls[0] = createdetectiontaskService.selectvideostream(detectionTask.getCameraPosition());

        List<AiModel> list = createdetectiontaskService.selectModel(detectionTask.getIds());
        String[] modelPaths = new String[list.size()];


        // 生成 taskId 并插入检测任务
        detectionTask.setTaskId(generateCameraId());
        int insertResult = createdetectiontaskService.insertDetectiontask(detectionTask);
        if (insertResult <= 0) {
            return JSON.toJSONString(Result.success("创建任务失败", 0, null));
        }

        String zlmUrl = null;

        // 获取插入的检测任务的 ID
        String taskId = detectionTask.getTaskId();

        // 调用 streamService.startStream 传递 taskId
        String taskTagging = streamService.startStream(rtspUrls,zlmUrl, modelPaths, taskId,detectionTask.getFrameSelect(),detectionTask.getFrameBoxs(),500,detectionTask.getFrameInterval());

        // 解析 JSON 字符串
        JSONObject jsonObject = new JSONObject(taskTagging);

        // 提取 "thread_name" 字段的值
        String threadName = jsonObject.getString("thread_name");

        detectionTask.setTaskTagging(threadName);
        if (detectionTask.getTaskTagging() != null && detectionTask.getTaskTagging().length() > 0) {
            detectionTask.setStatus(detectionTask.getStatus());
            detectionTask.setStartTime(sdf.format(new Date()));
            detectionTask.setId(createdetectiontaskService.selectId(taskId));
            int updateResult = createdetectiontaskService.updateDetectiontasktag(detectionTask);
            if (updateResult > 0) {
                return JSON.toJSONString(Result.success("创建任务成功", 1, null));
            }
        }
        return JSON.toJSONString(Result.success("创建任务失败", 0, null));
    }


    private String waitstartDetectiontask(DetectionTask detectionTask){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        detectionTask.setCreateTime(sdf.format(new Date()));

        JSONArray jsonArray = JSON.parseArray(detectionTask.getFrameBoxs());

        detectionTask.setFrameBoxs(jsonArray.toJSONString());

        detectionTask.setStatus(detectionTask.getStatus());

        detectionTask.setTaskId(generateCameraId());

        int i= createdetectiontaskService.insertDetectiontask(detectionTask);
        if (i>0){
            return JSON.toJSONString(Result.success("创建任务成功",1,null));
        }
        return JSON.toJSONString(Result.success("任务插入失败,进程已停止",0,null));
    }

    private String getnowtime(){
        LocalDateTime now = LocalDateTime.now();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SS");

        String formattedDateTime = now.format(formatter);
        return formattedDateTime;
    }

    //任务修改
    private String toupdateDetectiontask(DetectionTask detectionTask){

        JSONArray jsonArray = JSON.parseArray(detectionTask.getFrameBoxs());

        detectionTask.setFrameBoxs(jsonArray.toJSONString());

        int i =createdetectiontaskService.toupdateDetectiontask(detectionTask);
        if (i>0){
            return JSON.toJSONString(Result.success("修改成功",1,null));
        }
        return JSON.toJSONString(Result.success("修改失败",1,null));
    }
    public static String transformCoordinates(String dataStr, int width, int height) {
        // 去掉字符串的外部括号并分割成矩形框的字符串数组
        dataStr = dataStr.replace("[[", "").replace("]]", "");
        String[] rectangles = dataStr.split("],\\[");

        // 用于存储结果
        List<String> transformedRectangles = new ArrayList<>();

        // 遍历每个矩形框
        for (String rect : rectangles) {
            // 分割矩形框的坐标并去掉多余的引号
            String[] values = rect.split(",");
            double x1 = Double.parseDouble(values[0].replace("\"", "")) * width;
            double y1 = Double.parseDouble(values[1].replace("\"", "")) * height;
            double x2 = Double.parseDouble(values[2].replace("\"", "")) * width;
            double y2 = Double.parseDouble(values[3].replace("\"", "")) * height;

            // 格式化为字符串并添加到结果列表
            transformedRectangles.add(String.format("[%.1f,%.1f,%.1f,%.1f]", x1, y1, x2, y2));
        }

        // 将结果拼接成字符串并返回
        return "[" + String.join(",", transformedRectangles) + "]";
    }

    private String getZlmUrl(String zlmNginxUrl){

        // 假设基础URL是固定的
        String baseUrl = "http://"+zlmip+":"+zlmport;

        // 找到第一个'/'的位置
        int firstSlashIndex = zlmNginxUrl.indexOf('/');

        // 找到第二个'/'的位置
        int secondSlashIndex = zlmNginxUrl.indexOf('/', firstSlashIndex + 1);

        // 从第二个'/'开始截取路径部分
        String path = zlmNginxUrl.substring(secondSlashIndex);

        // 构造完整的URL
        String fullUrl = baseUrl + path;

        return fullUrl;

    }


}
