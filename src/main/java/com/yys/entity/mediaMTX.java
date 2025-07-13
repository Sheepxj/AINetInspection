package com.yys.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
@TableName("mediamtx_streams")
public class mediaMTX {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @TableField("camera_id")
    private Integer cameraId;

    @TableField("stream_address")
    private String streamAddress;
}
