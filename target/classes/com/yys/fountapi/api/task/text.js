import instance from "@/utils/intercept";

//监控点位列表
export function getCameraList() {
  return instance({
    url: "/boards/location",
    method: "get",
  });
}

//监测任务列表
export function getTaskList(data) {
  return instance({
    url: "/ocrrask/getOcrTask",
    method: "post",
    data,
  });
}

//监测任务详情
export function getTaskDetail(data) {
  return instance({
    url: "/ocrrask/getOcrTaskById",
    method: "post",
    data,
  });
}

//添加文字检测任务
export function createTask(data) {
  return instance({
    url: "/ocrrask/createtask",
    method: "post",
    data,
  });
}

//编辑文字检测任务
export function updateTask(data) {
  return instance({
    url: "/ocrrask/updateOcrTask",
    method: "post",
    data,
  });
}

//启动文字检测任务
export function playTask(data) {
  return instance({
    url: "/ocrrask/startOcr",
    method: "post",
    data,
  });
}

//停用文字检测任务
export function pauseTask(data) {
  return instance({
    url: "/ocrrask/stopOcr",
    method: "post",
    data,
  });
}

//删除文字检测任务
export function deleteTask(data) {
  return instance({
    url: "/ocrrask/deleteOcrTask",
    method: "post",
    data,
  });
}
