package com.yys.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

/**
 * 摄像头信息类
 */
@Data
@Accessors(chain = true)
@TableName("ai_camera")
public class AiCamera {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @TableField("camera_id")
    private String cameraId;

    @TableField("camera_location")
    private String cameraLocation;

    @TableField("camera_group")
    private Integer cameraGroup;

    @TableField("camera_width")
    private Integer cameraWidth;

    @TableField("camera_height")
    private Integer cameraHeight;

    @TableField("video_scale")
    private Double videoScale; //视频比例

    @TableField("video_rate")
    private Integer videoRate; //视频帧率

    @TableField("camera_protocol")
    private String cameraProtocol;

    @TableField("camera_status")
    private Integer cameraStatus;

    @TableField("working_time")
    private String workingTime;

    @TableField("last_time")
    private String lastTime;

    @TableField("ip_address")
    private String ipAddress;

    @TableField("camera_port")
    private Integer cameraPort;

    @TableField("video_streaming")
    private String videoStreaming;

    @TableField("type_input")
    private Integer typeInput;

    @TableField("camera_img")
    private String cameraImg="";

    @TableField("zlm_id")
    private Integer zlmId;

    @TableField("zlm_url")
    private String zlmUrl;

    @TableField(exist = false)
    private String groupName;

    @TableField(exist = false)
    private String cameraTaskid;

    @TableField(exist = false)
    private String userName;

    @TableField(exist = false)
    private String passWord;

    @TableField(exist = false)
    private String address;

    @TableField(exist = false)
    private String agreement;

    @TableField("camera_id")
    private String gId;


}
