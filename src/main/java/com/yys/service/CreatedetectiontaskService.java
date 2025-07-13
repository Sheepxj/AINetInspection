package com.yys.service;

import com.yys.entity.AiModel;
import com.yys.entity.DetectionTask;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CreatedetectiontaskService {

    List<AiModel> selectAimodels();
    int insertDetectiontask(DetectionTask detectionTask);
    String selectvideostream(String cameraLocation);

    List<AiModel> selectModel(String ids);
    String selectdtid();

    String selecttaskTagging( String Id);

    int updateDetectiontask( String Id, Integer status,String endTime);

    DetectionTask selectlocationids(String Id);

    int updateDetectiontasktag(DetectionTask detectionTask);

    String selectTaskId(String Id);

    Integer selectId(String taskId);

    int toupdateDetectiontask(DetectionTask detectionTask);

    AiModel selectModelById(Integer id);

    int deleteModelPlan(@Param("id") Integer id);


}
