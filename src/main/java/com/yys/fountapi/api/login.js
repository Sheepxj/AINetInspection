import instance from "@/utils/intercept";

export function login(data) {
  return instance({
    url: "/user/login",
    method: "post",
    data,
  });
}

export function logout() {
  return instance({
    url: "/user/logout",
    method: "get",
  });
}

export function getUserInfo() {
  return instance({
    url: "/user/queryById",
    method: "get",
  });
}

export function changePassword(data) {
  return instance({
    url: "/user/changePassword",
    method: "get",
    params: data,
  });
}

//获取微信二维码
export function getWechatQrcode() {
  return instance({
    url: "/wechat/getQrCode",
    method: "get",
  });
}

//校验微信二维码登录
export function checkWechartLogin(data) {
  return instance({
    url: "/wechat/checkLogin",
    method: "get",
    params: data,
  });
}
