package com.yys.controller;

import com.alibaba.fastjson2.JSON;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yys.entity.Result;
import com.yys.entity.wechat.ChatUser;
import com.yys.service.ChatUserService;
import com.yys.util.MinioClientProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/wechat")
@CrossOrigin
public class ChatUserController {

    private static final Logger logger = LoggerFactory.getLogger(ChatUserController.class);

    @Autowired
    private ChatUserService chatUserService;

    /**
     * 添加推送用户
     * @param chatUser 推送用户对象
     * @return 添加结果
     */
    @PostMapping("/addChatUser")
    public String addChatUser(@RequestBody ChatUser chatUser) {
        // 保存推送用户
        boolean success = chatUserService.save(chatUser);

        if (success) {
            // 返回成功结果
            return JSON.toJSONString(Result.success("添加成功",1,null));
        } else {
            // 返回失败结果
            return JSON.toJSONString(Result.error("添加失败"));
        }
    }

    /**
     * 获取推送用户信息
     * @param chatUser 推送用户对象，包含用户ID
     * @return 用户信息结果
     */
    @PostMapping("/getChatUser")
    public String getChatUser(@RequestBody ChatUser chatUser) {
        // 根据ID获取推送用户
        ChatUser result = chatUserService.getById(chatUser.getId());

        if (result != null) {
            // 返回成功结果
            return JSON.toJSONString(Result.success("查询成功",1,result));
        } else {
            // 返回失败结果
            return JSON.toJSONString(Result.error("查询失败"));
        }
    }

    /**
     * 获取推送用户列表
     * @param requestBody 请求体，包含查询参数
     * @return 用户列表结果
     */
    @PostMapping("/getChatList")
    public String getChatList(@RequestBody Map<String, Object> requestBody) {
        // 提取查询参数
        String chatName = (String) requestBody.get("chatName");
        Integer pageNum = (Integer) requestBody.get("pageNum");
        Integer pageSize = (Integer) requestBody.get("pageSize");

        // 校验分页参数
        if (pageNum != null && pageSize >0 ){
            pageNum=pageNum-1;
        }

        // 执行分页查询
        Page<ChatUser> page = chatUserService.getTasks(chatName,pageNum,pageSize);

        if (page != null){
            // 返回查询成功结果
            return JSON.toJSONString(Result.success(200,"查询成功", (int) page.getTotal(),page.getRecords()));
        }
        // 返回查询无数据结果
        return JSON.toJSONString(Result.success(200,"暂无数据",0,null));
    }

    /**
     * 删除推送用户
     * @param chatUser 推送用户对象，包含用户ID
     * @return 删除结果
     */
    @PostMapping("/deleteChatUser")
    public String deleteChatUser(@RequestBody ChatUser chatUser) {
        // 根据ID获取推送用户
        ChatUser result=chatUserService.getById(chatUser.getId());

        if (result==null){
            // 返回用户不存在结果
            return JSON.toJSONString(Result.error("该用户不存在"));
        }

        if (result.getChatStatus()==1){
            // 返回用户状态不允许删除结果
            return JSON.toJSONString(Result.error("该用户已开启预警推送，无法删除"));
        }

        // 执行删除操作
        boolean success = chatUserService.removeById(chatUser.getId());

        if (success) {
            // 返回删除成功结果
            return JSON.toJSONString(Result.success("删除成功",1,null));
        } else {
            // 返回删除失败结果
            return JSON.toJSONString(Result.error("删除失败"));
        }
    }

    /**
     * 更新推送用户信息
     * @param chatUser 聊天用户对象，包含更新信息
     * @return 更新结果
     */
    @PostMapping("/updateChatUser")
    public String updateChatUser(@RequestBody ChatUser chatUser) {
        // 执行更新操作
        boolean success = chatUserService.updateById(chatUser);

        if (success) {
            // 返回更新成功结果
            return JSON.toJSONString(Result.success("修改成功",1,null));
        } else {
            // 返回更新失败结果
            return JSON.toJSONString(Result.error("修改失败"));
        }
    }

    /**
     * 批量更新推送用户状态
     * @param chatIds 推送用户ID列表
     * @return 更新结果
     */

    @Transactional
    @PostMapping("/updateChatUsers")
    public String updateChatUsers(@RequestBody List<Integer> chatIds ) {
        // 重置所有用户状态
        UpdateWrapper<ChatUser> resetWrapper = new UpdateWrapper<>();
        resetWrapper.set("chat_status", 0);
        boolean resetResult = chatUserService.update(resetWrapper);

        if (!resetResult) {
            // 返回重置状态失败结果
            return JSON.toJSONString(Result.error("重置状态失败"));
        }

        // 更新指定用户状态
        UpdateWrapper<ChatUser> updateWrapper = new UpdateWrapper<>();
        updateWrapper.in("id", chatIds).set("chat_status", 1);

        // 执行批量更新
        boolean result = chatUserService.update(updateWrapper);

        if (result){
            // 返回更新成功结果
            return JSON.toJSONString(Result.success("修改成功",1,null));
        }

        // 返回更新失败结果
        return JSON.toJSONString(Result.error("修改失败"));
    }


}
