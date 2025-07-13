package com.yys.controller;

import com.alibaba.fastjson2.JSON;

import com.yys.entity.AiZlm;
import com.yys.service.AiZlmService;
import com.yys.service.StreamService;

import com.yys.service.ZlmediakitService;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import com.yys.entity.AiCamera;
import com.yys.entity.CameraSector;
import com.yys.entity.Result;
import com.yys.service.CameralistService;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@RestController
@RequestMapping(value = "/sterams",produces = "application/json;charset=UTF-8")
@CrossOrigin
public class CameralistController {

    @Autowired
    private CameralistService cameralistService;

    @Autowired
    private StreamService streamService;

    @Autowired
    private ZlmediakitService zlmediakitService;

    @Autowired
    private AiZlmService aiZlmService;

    @GetMapping("/getvideolist")
    public String getCameralist(@RequestParam(value = "gId", required = false) String gId){
        Result result = cameralistService.selectCameralist(gId);
        return JSON.toJSONString(result);
    }

    @GetMapping("/getvideolistgroup")
    public String getCameralistGroup(
            @RequestParam(value = "groupName", required = false) String groupName,
            @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
            @RequestParam(value = "pageSize", defaultValue = "5") int pageSize
    ){
        pageNum=(pageNum-1)*pageSize;
        Result result = cameralistService.selectCameralistGroup(groupName, pageNum,pageSize);
        return JSON.toJSONString(result);
    }

    @GetMapping("/getgroups")
    public String getCameralistgroup(){
        Result result = cameralistService.selectGroups();
        return JSON.toJSONString(result);
    }

    //更新分组名
    @GetMapping("/updateGroup")
    public String updateGroup(@RequestParam(value = "groupId", required = false)String groupId,
                              @RequestParam(value = "groupName", required = false)String groupName){
        Result result=cameralistService.updateGroup(groupId, groupName);
        return JSON.toJSONString(result);
    }

    //获取分组信息
    @GetMapping("/getGroupMsg")
    public String getGroupMsg(String groupId){
        Result result = cameralistService.selectGroupMsg(groupId);
        return JSON.toJSONString(result);
    }

    @GetMapping("/deleteCameraGroup")
    public String deleteCameraGroup(String groupId){
        Result result = cameralistService.deleteCameraGroup(groupId);
        return JSON.toJSONString(result);
    }

    @GetMapping("/deleteCameraList")
    public String deleteCameraList(String cameraId){
        Result result = cameralistService.deleteCameraList(cameraId);
        return JSON.toJSONString(result);
    }

    @GetMapping("/addgroups")
    public String getCameralistCount(@RequestParam(value = "groupName", required = false) String groupName){
        int i = cameralistService.selectGroupExists(groupName);
        if (i != 0){
            return JSON.toJSONString(Result.success(302,"分组已存在",0,null));
        }
        CameraSector cameraSector = new CameraSector();
        cameraSector.setGroupId(generateGroupId());
        cameraSector.setGroupName(groupName);
        cameraSector.setCreateTime(getnowtime());
        int count = cameralistService.insertCameralistCount(cameraSector);
        if (count == 0){
            return JSON.toJSONString(Result.success("添加失败",0,null));
        }
        return JSON.toJSONString(Result.success("添加成功",1,null));
    }

    @PostMapping("/addCamera")
    @Transactional
    public String addCamera(@RequestBody AiCamera aiCamera) {
        int i = cameralistService.selectCameraExists(aiCamera.getCameraLocation());
        if (i != 0) {
            Result result = Result.success(302, "摄像机点位已存在", 0, null);
            return JSON.toJSONString(result);
        } //

        aiCamera.setCameraProtocol(getupagreement(aiCamera.getVideoStreaming()));
        aiCamera.setCameraId(generateCameraId());
        aiCamera.setWorkingTime(getnowtime());

        cameralistService.save(aiCamera);

        AiZlm aiZlm = new AiZlm()
                .setZlmApp(aiCamera.getCameraId())
                .setVideoStream(aiCamera.getVideoStreaming())
                .setZlmStream(generateFourCharUUID());

        //添加摄像头
        aiZlm=zlmediakitService.addVideo(aiZlm);
        aiZlm.setCameraId(aiCamera.getId());
        aiZlmService.save(aiZlm);

        //获取摄像头信息
        Map<String, Object> map = streamService.getVideoMsg(aiCamera.getVideoStreaming(), aiCamera.getCameraId());

        if (map.get("state").equals("error")){
            return JSON.toJSONString(Result.error("添加失败"));
        }

        int width = (int) map.get("width");
        int height = (int) map.get("height");
        double thefps = (double) map.get("fps");
        int fps = (int) thefps;
        double aspectRatio = (double) map.get("aspectRatio");
        String savedImagePath = (String) map.get("savedImagePath");

        aiCamera.setZlmId(aiZlm.getZlmId());
        aiCamera.setCameraStatus(1);
        aiCamera.setCameraWidth(width);
        aiCamera.setCameraHeight(height);
        aiCamera.setVideoRate(fps);
        aiCamera.setCameraImg(savedImagePath);
        aiCamera.setVideoScale(aspectRatio);
        aiCamera.setZlmUrl(aiZlm.getZlmUrl());

        boolean result =cameralistService.updateById(aiCamera);

        if (!result) {
            return JSON.toJSONString(Result.error("添加失败"));
        }




        return JSON.toJSONString(Result.success("添加成功", 1, null));

    }

    @PostMapping("/updateCamera")
    public String updateCamera(@RequestBody AiCamera aiCamera){

        int i = cameralistService.selectCameraGroupExists(aiCamera.getCameraLocation(), String.valueOf(aiCamera.getCameraGroup()));
        if (i != 0){
            Result result = Result.success(302,"该分组内已存在摄像机点位,修改失败",0,null);
            return JSON.toJSONString(result);
        };
        cameralistService.updateCamera(aiCamera);
        return JSON.toJSONString(Result.success("修改成功",1,null));
    }

    //主页获取摄像头状态
    @GetMapping("/getCamerastus")
    public String getCamerastus(){
        int Camerasum=cameralistService.selectAicameralist().size();
        int working=cameralistService.selectWorkingCamera();

        String rate = "";
        Map<String, Object> map = new HashMap<>();
        map.put("Camerasum", Camerasum);
        map.put("working", working);
        if (Camerasum != 0) {
            double num = ((double) working) / Camerasum;
            rate = String.format("%.2f%%", num * 100);
            map.put("rate", rate);
        } else {
            return JSON.toJSONString(Result.success("还未添加摄像头",0,map));
        }

        return JSON.toJSONString(Result.success("获取成功",1,map));

    }

    //查询摄像头信息
    @GetMapping("/selectCameraMsg")
    public String selectCameraMsg(String cameraId) {
        Result result = cameralistService.selectCameraMsg(cameraId);
        return JSON.toJSONString(result);
    }

    @GetMapping("/selectCameraLocation")
    public String selectCameraLocation(){
        Result result = cameralistService.selectCameraLocation();
        return JSON.toJSONString(result);
    }

    //更新摄像头状态
    private String generateGroupId() {
        String oldId = cameralistService.selectGroupid();
        if (oldId == null || oldId.isEmpty()) {
            return "G001";
        }
        int numericPart = Integer.parseInt(oldId.substring(1)) + 1;
        return String.format("G%03d", numericPart);
    }
    private String generateCameraId() {
        String oldId = cameralistService.selectCameraid();
        if (oldId == null || oldId.isEmpty()) {


            return "C001";
        }
        int numericPart = Integer.parseInt(oldId.substring(1)) + 1;
        return String.format("C%03d", numericPart);
    }

    private String getnowtime(){
        LocalDateTime now = LocalDateTime.now();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SS");

        String formattedDateTime = now.format(formatter);
        return formattedDateTime;
    }


    //获取大写
    public static String getupagreement(String originalString) {
        String firstFourChars = originalString.substring(0, 4); // 获取前四位字符
        return firstFourChars;
    }


    public static String generateFourCharUUID() {
        UUID uuid = UUID.randomUUID();
        String uuidStr = uuid.toString().replace("-", ""); // 去掉UUID中的连字符
        return uuidStr.substring(0, 4); // 提取前四个字符
    }
}
