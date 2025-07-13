import instance from "@/utils/intercept";

//算法模型列表
export function getAllAlgorithm() {
  return instance({
    url: "/createdetectiontask/selectAimodels",
    method: "get",
  });
}

//监控点位列表
export function getCameraList() {
  return instance({
    url: "/boards/location",
    method: "get",
  });
}

//目标统计任务列表
export function getTaskList(data) {
  return instance({
    url: "/track/getTracks",
    method: "post",
    data,
  });
}

//目标统计任务详情
export function getTaskDetail(data) {
  return instance({
    url: "/track/getTrack",
    method: "post",
    data,
  });
}

//添加目标统计任务
export function createTask(data) {
  return instance({
    url: "/track/createTrack",
    method: "post",
    data,
  });
}

//编辑目标统计任务
export function updateTask(data) {
  return instance({
    url: "/track/updateTrack",
    method: "post",
    data,
  });
}

//启动目标统计任务
export function playTask(data) {
  return instance({
    url: "/track/satartTrack",
    method: "post",
    data,
  });
}

//停用目标统计任务
export function pauseTask(data) {
  return instance({
    url: "/track/stopTrack",
    method: "post",
    data,
  });
}

//删除目标统计任务
export function deleteTask(data) {
  return instance({
    url: "/track/deleteTrack",
    method: "post",
    data,
  });
}
