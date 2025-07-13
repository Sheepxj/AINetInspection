package com.yys.entity.wechat;


import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
@TableName("chat_user")
public class ChatUser {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @TableField("chat_name")
    private String chatName;

    @TableField("chat_openid")
    private String chatOpenid;

    @TableField("chat_status")
    private Integer chatStatus;

    @TableField("create_time")
    private String createTime;

    @TableField("update_time")
    private String updateTime;

}