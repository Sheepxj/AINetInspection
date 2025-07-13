package com.yys.entity.ocr;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.Map;

@Data
@Accessors(chain = true)
@TableName("ocr_task")
public class OcrTask {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @TableField("ocr_name")
    private String ocrName;

    @TableField("ocr_describe")
    private String ocrDescribe;

    @TableField("ocr_level")
    private String ocrLevel;

    @TableField("has_box")
    private Integer hasBox;

    @TableField("ocr_box")
    private String ocrBox;

    @TableField("ocr_status")
    private Integer ocrStatus;

    @TableField("ocr_keyword")
    private String ocrKeyword;

    @TableField("ocr_shield")
    private String ocrShield;

    @TableField("ocr_frequency")
    private String ocrFrequency;

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

    @TableField("job_sign")
    private String jobSign;

    @TableField("create_time")
    private String createTime;

    @TableField("update_time")
    private String updateTime;

    @TableField(exist = false)
    Map<String, Object> cronParams;
}
