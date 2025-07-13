package com.yys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yys.entity.wechat.ChatUser;
import com.yys.mapper.ChatUserMapper;
import com.yys.service.ChatUserService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChatUserServiceImpl extends ServiceImpl<ChatUserMapper, ChatUser> implements ChatUserService {

    @Override
    public Page<ChatUser> getTasks(String chatName, Integer pageNumber, Integer pageSize) {

        QueryWrapper<ChatUser> queryWrapper = new QueryWrapper<>();

        QueryWrapper<ChatUser> querycount = new QueryWrapper<>();

        if (chatName != null && !chatName.isEmpty()){
            queryWrapper.like("chat_name", chatName);
        }

        queryWrapper.orderByDesc("create_time");

        if (pageNumber != null && pageSize != null){
            queryWrapper.last("limit " + pageNumber + "," + pageSize);
        }

        List<ChatUser> chatUsers = baseMapper.selectList(queryWrapper);

        int count = count(querycount);

        Page<ChatUser> page = new Page<>();
        page.setRecords(chatUsers);
        page.setTotal(count);
        page.setSize(chatUsers.size());
        page.setCurrent(1);
        return page;
    }

    @Override
    public List<ChatUser> getChatUserList() {

        QueryWrapper<ChatUser> queryWrapper = new QueryWrapper<>();

        queryWrapper.eq("chat_status", 1);

        List<ChatUser> chatUsers = baseMapper.selectList(queryWrapper);

        if (chatUsers != null){
            return chatUsers;
        }
        return null;
    }
}
