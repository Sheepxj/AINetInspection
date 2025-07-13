import trainInstance from "@/utils/trainingIntercept";

//获取模型训练项目列表
export function getProjectList(data) {
  return trainInstance({
    url: "/traintask/getTrainList",
    method: "get",
    params: data,
  });
}

//添加模型训练项目
export function createTargetProject(data) {
  return trainInstance({
    url: "/traintask/instertask",
    method: "get",
    params: data,
  });
}

//编辑模型训练项目
export function updateProject(data) {
  return trainInstance({
    url: "/traintask/updateTrainTask",
    method: "get",
    params: data,
  });
}

//删除模型训练项目
export function deleteProject(data) {
  return trainInstance({
    url: "/traintask/deleteTrainTask",
    method: "get",
    params: data,
  });
}

//获取标签列表
export function getLabelList(data) {
  return trainInstance({
    url: "/modeltags/getTrainTags",
    method: "get",
    params: data,
  });
}

//创建标签
export function createLabel(data) {
  return trainInstance({
    url: "/modeltags/insertTags",
    method: "get",
    params: data,
  });
}

//编辑标签
export function updateLabel(data) {
  return trainInstance({
    url: "/modeltags/updateTags",
    method: "get",
    params: data,
  });
}

//删除标签
export function deleteLabel(data) {
  return trainInstance({
    url: "/modeltags/deleteTags",
    method: "get",
    params: data,
  });
}

//获取模型的数据集
export function getModelDataset(data) {
  return trainInstance({
    url: "/modelsets/getSetsById",
    method: "get",
    params: data,
  });
}

//上传 图片数据集
export function uploadImageSet(data) {
  return trainInstance({
    url: "/upload/imgsFileUpload",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//上传 压缩包数据集
export function uploadZipSet(data) {
  return trainInstance({
    url: "/upload/zipFileUpload",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//上传 压缩包训练集
export function uploadDataSet(data) {
  return trainInstance({
    url: "/upload/uploadYoloTrainingSet",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//批量删除数据集
export function batchDeleteDataset(data) {
  return trainInstance({
    url: "/modelsets/deleteSets",
    method: "get",
    params: data,
  });
}

//全部删除数据集
export function deleteAllDataset(data) {
  return trainInstance({
    url: "/modelsets/deleteSetsbyType",
    method: "get",
    params: data,
  });
}

//获取数据集标注详情
export function getMarkResult(data) {
  return trainInstance({
    url: "/modelsets/getSetsBySetsId",
    method: "get",
    params: data,
  });
}

//保存数据集标注结果
export function saveMarkResult(data) {
  return trainInstance({
    url: "/modelsets/setstoLabel",
    method: "post",
    data,
  });
}

//开始训练
export function startTrain(data) {
  return trainInstance({
    url: "/combined/combinedCall",
    method: "get",
    params: data,
  });
}

//停止训练
export function stopTrain(data) {
  return trainInstance({
    url: "/traintask/stopTrain",
    method: "get",
    params: data,
  });
}

//判断模型是否训练完成
export function judgeTrainFinish(data) {
  return trainInstance({
    url: "/traintask/isTrainFinish",
    method: "get",
    params: data,
  });
}

//导出模型
export function exportModel(data) {
  return trainInstance({
    url: "/download/getzip",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    responseType: "blob",
    data,
  });
}
