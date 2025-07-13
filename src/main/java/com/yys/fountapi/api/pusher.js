import instance from "@/utils/intercept";

//微信推送用户列表
export function getPusherList(data) {
  return instance({
    url: "/wechat/getChatList",
    method: "post",
    data,
  });
}

//添加微信推送用户
export function addPusher(data) {
  return instance({
    url: "/wechat/addChatUser",
    method: "post",
    data,
  });
}

//删除微信推送用户
export function deletePusher(data) {
  return instance({
    url: "/wechat/deleteChatUser",
    method: "post",
    data,
  });
}

//编辑微信推送用户
export function updatePusher(data) {
  return instance({
    url: "/wechat/updateChatUser",
    method: "post",
    data,
  });
}
