import instance from "@/utils/intercept";

//预警事件列表
export function getWarningEvent(data) {
  return instance({
    url: "/warningTable/selectwarning",
    method: "post",
    data,
  });
}

//预警类型列表
export function getAllAlgorithm() {
  return instance({
    url: "/warningTable/getalertTypes",
    method: "get",
  });
}

//摄像头点位
export function getAllLocations() {
  return instance({
    url: "/warningTable/getcameraPosition",
    method: "get",
  });
}

//预警信息详情
export function getWarningEventDetail(data) {
  return instance({
    url: "/warningTable/selectbytaskid",
    method: "get",
    params: data,
  });
}

//设置预警推送
export function setWarningPush(data) {
  return instance({
    url: "/job/startJob",
    method: "post",
    data,
  });
}

//获取预警推送详情
export function getWarningPushDetail() {
  return instance({
    url: "/job/getJobMsg",
    method: "get",
  });
}

//获取文字检测摄像头点位
export function getTextDetectLocations() {
  return instance({
    url: "/ocrTable/getcameraPosition",
    method: "post",
  });
}

//获取文字检测预警事件
export function getTextDetectWarning(data) {
  return instance({
    url: "/ocrTable/getOcrTalbes",
    method: "post",
    data,
  });
}

//获取文字检测预警事件详情
export function getTextDetectWarningDetail(data) {
  return instance({
    url: "/ocrTable/getOcrTalbe",
    method: "post",
    data,
  });
}

//获取人脸识别摄像头点位
export function getFaceDetectLocations() {
  return instance({
    url: "/faceTable/getcameraPosition",
    method: "post",
  });
}

//获取人脸识别预警事件
export function getFaceDetectWarning(data) {
  return instance({
    url: "/faceTable/getOcrTalbes",
    method: "post",
    data,
  });
}

//获取人脸识别预警事件详情
export function getFaceDetectWarningDetail(data) {
  return instance({
    url: "/faceTable/getOcrTalbe",
    method: "post",
    data,
  });
}
