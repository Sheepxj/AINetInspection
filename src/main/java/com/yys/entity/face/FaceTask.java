package com.yys.entity.face;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class FaceTask {

    private static final long serialVersionUID = 1L;

    @TableId(value = "face_id", type = IdType.AUTO)
    private Integer faceId;

    @TableField("face_name")
    private String faceName;

    @TableField("face_msg")
    private String faceMsg;

    @TableField("face_level")
    private String faceLevel;

    @TableField("face_box")
    private String faceBox;

    @TableField("face_status")
    private Integer faceStatus;

    @TableField("face_data_id")
    private Integer faceDataId;

    @TableField("face_data_name")
    private String faceDataName;

    @TableField("face_method")
    private Integer faceMethod;

    @TableField("camera_id")
    private Integer cameraId;

    @TableField("camera_adress")
    private String cameraAdress;

    @TableField("camera_group")
    private String cameraGroup;

    @TableField("camera_video")
    private String cameraVideo;

    @TableField("http_url")
    private String httpUrl;

    @TableField("stop_sign")
    private String stopSign;

    @TableField("create_time")
    private String createTime;

    @TableField(exist = false)
    private Integer zlmId;

    @TableField(exist = false)
    private String zlmUrl;

}
