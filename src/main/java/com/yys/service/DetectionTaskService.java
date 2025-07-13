package com.yys.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yys.entity.DetectionTask;
import com.yys.entity.Result;

import java.time.LocalDateTime;
import java.util.List;

public interface DetectionTaskService extends IService<DetectionTask> {

    String selectTaskId(Integer id);

    Result getDetectionTasks(String taskName, String alertLevel, LocalDateTime startTime, LocalDateTime endTime, int pageNum, int pageSize);
    Result getDetailedTask(String taskId);
    Result deleteDetectionTask(String id);
    DetectionTask selectDetectionType(String taskId);
    String modelName(String model);
    Integer selectDetectionTaskStatus(String id);

    Result selectDetectiontask(String id);

    List<DetectionTask> selectDetectiontask();

}
