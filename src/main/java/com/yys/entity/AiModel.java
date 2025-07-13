package com.yys.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("ai_model")
public class AiModel {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @TableField("model")
    private String model;

    @TableField("model_name")
    private String modelName;

    @TableField("model_source")
    private Integer modelSource;

    @TableField("create_time")
    private String createTime;

    @TableField("update_time")
    private String updateTime;

    @TableField("model_version")
    private String modelVersion;


}
