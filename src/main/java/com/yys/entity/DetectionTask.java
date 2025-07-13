package com.yys.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.List;

@Data
@TableName("detection_task")
public class DetectionTask {

    @TableId(type = IdType.AUTO)
    private Integer id;

    @TableField("task_id")
    private String taskId;

    @TableField("task_name")
    private String taskName;

    @TableField("camera_position")
    private String cameraPosition;

    @TableField("camera_id")
    private Integer cameraId;

    @TableField("algorithm_model")
    private String algorithmModel;

    @TableField("task_description")
    private String taskDescription;

    @TableField("priority")
    private Integer priority;

    @TableField("alert_method")
    private String alertMethod;

    @TableField("alert_level")
    private String alertLevel;

    @TableField("notification_email")
    private String notificationEmail;

    @TableField("target_count_threshold")
    private Integer targetCountThreshold;

    @TableField("target_dwell_time")
    private Integer targetDwellTime;

    @TableField("create_time")
    private String createTime;

    @TableField("start_time")
    private String startTime;

    @TableField("end_time")
    private String endTime;

    @TableField("status")
    private Integer status;

    @TableField("task_tagging")
    private String taskTagging;

    @TableField("ids")
    private String ids;

    @TableField("frame_select")
    private Integer frameSelect;

    @TableField("frame_boxs")
    private String frameBoxs;

    @TableField("target_number")
    private Integer targetNumber;

    @TableField("frame_interval")
    private Integer frameInterval;

    @TableField("set_time")
    private Integer setTime;

    @TableField(exist = false)
    private String modelName;

    @TableField(exist = false)
    private String videoStreaming;

    @TableField(exist = false)
    private String groupName;

    @TableField(exist = false)
    List<AiModel> aiModels;

    @TableField(exist = false)
    private Integer zlmId;

    @TableField(exist = false)
    private String zlmUrl;
}