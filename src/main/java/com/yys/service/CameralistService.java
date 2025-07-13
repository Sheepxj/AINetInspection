package com.yys.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.yys.entity.*;

import java.util.List;


public interface CameralistService extends IService<AiCamera> {
    AiCamera insterCamera(AiCamera camera);
    int selectGroupExists(String groupName);
    int selectCameraExists(String cameraLocation);
    int selectCameraGroupExists(String cameraLocation,String cameraGroup);
    int insertCameralistCount(CameraSector cameraSector);
    int updateCamerStats(String cameraId, Integer cameraStatus);
    int selectWorkingCamera();
    int updateCameraImg(String cameraId, String cameraImg);
    int insterModel(AiModel aiModel);
    int updateModelname(Integer id, String modelName);

    Result selectGroups();
    Result deleteCameraGroup(String groupId);
    Result deleteCameraList(String cameraId);
    Result selectCameralistGroup(String groupName,int pageNum,int pageSize);
    Result selectCameralist(String gId);
    Result updateGroup(String groupId,String groupName);
    Result selectGroupMsg(String groupId);
    Result selectCameraMsg(String cameraId);
    Result updateCamera(AiCamera aiCamera);
    Result selectCameraLocation();

    String selectGroupid();
    String selectCameraid();
    String selectCameraStream(String cameraId);


    List<AiCamera> selectAicameralist();
    AiCamera selectedAiCamera(Integer id);



}
