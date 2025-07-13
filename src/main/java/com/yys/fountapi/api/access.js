import instance from "@/utils/intercept";

//摄像头列表
export function getVideoDevice() {
  return instance({
    url: "/boards/location",
    method: "get",
  });
}

//摄像头视频画面列表
export function getVideoList(data) {
  return instance({
    url: "/sterams/getvideolist",
    method: "get",
    params: data,
  });
}

//摄像头详情信息
export function getVideoDeviceDetail(data) {
  return instance({
    url: "/sterams/selectCameraMsg",
    method: "get",
    params: data,
  });
}

//添加摄像头
export function createVideoDevice(data) {
  return instance({
    url: "/sterams/addCamera",
    method: "post",
    data,
  });
}

//删除摄像头
export function deleteVideoDevice(data) {
  return instance({
    url: "/sterams/deleteCameraList",
    method: "get",
    params: data,
  });
}

//编辑添加摄像头
export function updateVideoDevice(data) {
  return instance({
    url: "/sterams/updateCamera",
    method: "post",
    data,
  });
}

//摄像头分组(不分页)
export function getAllVideoDeviceGroup() {
  return instance({
    url: "/sterams/getgroups",
    method: "get",
  });
}

//摄像头分组列表
export function getVideoDeviceGroup(data) {
  return instance({
    url: "/sterams/getvideolistgroup",
    method: "get",
    params: data,
  });
}

//添加摄像头分组
export function createVideoDeviceGroup(data) {
  return instance({
    url: "/sterams/addgroups",
    method: "get",
    params: data,
  });
}

//编辑摄像头分组
export function updateVideoDeviceGroup(data) {
  return instance({
    url: "/sterams/updateGroup",
    method: "get",
    params: data,
  });
}

//删除摄像头分组
export function deleteVideoDeviceGroup(data) {
  return instance({
    url: "/sterams/deleteCameraGroup",
    method: "get",
    params: data,
  });
}

//摄像头分组详情
export function getVideoDeviceGroupDetail(data) {
  return instance({
    url: "/sterams/getGroupMsg",
    method: "get",
    params: data,
  });
}

//摄像头接入时测试连接
export function previewCamera(data) {
  return instance({
    url: "/streams/Preview",
    method: "post",
    data,
  });
}

//计算节点列表
export function getComputeNodes(data) {
  return instance({
    url: "/pyregister/getPyMsgs",
    method: "post",
    data,
  });
}

//开始播放视频流
export function enabledStream(data) {
  return instance({
    url: "/streams/startzlm",
    method: "get",
    params: data,
  });
}

//停止播放视频流
export function stopStream(data) {
  return instance({
    url: "/streams/stopzlm",
    method: "get",
    params: data,
  });
}
