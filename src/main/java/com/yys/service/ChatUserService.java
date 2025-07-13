package com.yys.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yys.entity.wechat.ChatUser;

import java.util.List;

public interface ChatUserService extends IService<ChatUser> {

    Page<ChatUser> getTasks(String chatName,  Integer pageNumber, Integer pageSize);

    List<ChatUser> getChatUserList();

}
