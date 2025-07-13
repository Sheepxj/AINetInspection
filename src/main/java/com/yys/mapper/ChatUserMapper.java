package com.yys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yys.entity.wechat.ChatUser;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatUserMapper extends BaseMapper<ChatUser> {
}
