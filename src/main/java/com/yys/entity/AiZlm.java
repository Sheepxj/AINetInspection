package com.yys.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
@TableName("ai_zlm")
public class AiZlm {

    @TableId(value = "zlm_id", type = IdType.AUTO)
    private Integer zlmId; // zlm视频流主键

    @TableField("camera_id")
    private Integer cameraId; // 绑定的摄像头id

    @TableField("zlm_vhost")
    private String zlmVhost; // 添加的流的虚拟主机

    @TableField("zlm_app")
    private String zlmApp; // 添加流的应用名

    @TableField("zlm_stream")
    private String zlmStream; // 添加的流的id名

    @TableField("zlm_key")
    private String zlmKey; // 视频标识

    @TableField("zlm_url")
    private String zlmUrl; // 视频播放地址

    @TableField("video_stream")
    private String videoStream; // 视频流地址
}
