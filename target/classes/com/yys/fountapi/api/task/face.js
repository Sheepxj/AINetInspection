import instance from "@/utils/intercept";
import trainInstance from "@/utils/trainingIntercept";

//人脸识别任务列表
export function getTaskList(data) {
  return instance({
    url: "/facetask/getFaceTask",
    method: "post",
    data,
  });
}

//监控点位列表
export function getCameraList() {
  return instance({
    url: "/boards/location",
    method: "get",
  });
}

//人脸库列表
export function getFaceLibraryList(data) {
  return trainInstance({
    url: "/aifacetrain/getTrainList",
    method: "post",
    data,
  });
}

//添加人脸识别任务
export function createTask(data) {
  return instance({
    url: "/facetask/createtask",
    method: "post",
    data,
  });
}

//编辑人脸识别任务
export function updateTask(data) {
  return instance({
    url: "/facetask/updateFaceTask",
    method: "post",
    data,
  });
}

//启动人脸识别任务
export function playTask(data) {
  return instance({
    url: "/facetask/startFaceTask",
    method: "post",
    data,
  });
}

//停用人脸识别任务
export function pauseTask(data) {
  return instance({
    url: "/facetask/stopFaceTask",
    method: "post",
    data,
  });
}

//删除人脸识别任务
export function deleteTask(data) {
  return instance({
    url: "/facetask/deleteFaceTask",
    method: "post",
    data,
  });
}

//人脸识别任务详情
export function getTaskDetail(data) {
  return instance({
    url: "/facetask/getFaceTaskById",
    method: "post",
    data,
  });
}
