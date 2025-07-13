import trainInstance from "@/utils/trainingIntercept";

//获取模型训练项目列表
export function getProjectList(data) {
  return trainInstance({
    url: "/aifacetrain/getTrainList",
    method: "post",
    data,
  });
}

//添加模型训练项目
export function createFaceProject(data) {
  return trainInstance({
    url: "/aifacetrain/createTrain",
    method: "post",
    data,
  });
}

//编辑模型训练项目
export function updateProject(data) {
  return trainInstance({
    url: "/aifacetrain/updateTrain",
    method: "post",
    data,
  });
}

//删除模型训练项目
export function deleteProject(data) {
  return trainInstance({
    url: "/aifacetrain/deleteTrain",
    method: "post",
    data,
  });
}

//获取所有数据集
export function getAllDataset(data) {
  return trainInstance({
    url: "/aifaceset/getallname",
    method: "post",
    data,
  });
}

//获取标签列表
export function getLabelList(data) {
  return trainInstance({
    url: "/modeltags/getfaceTags",
    method: "post",
    data,
  });
}

//创建标签
export function createLabel(data) {
  return trainInstance({
    url: "/modeltags/insertfaceTags",
    method: "post",
    data,
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

//获取人员信息列表
export function getModelDataset(data) {
  return trainInstance({
    url: "/aifaceset/getSetList",
    method: "post",
    data,
  });
}

//添加人员信息
export function createDataset(data) {
  return trainInstance({
    url: "/aifaceset/createSet",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//编辑人员信息
export function updateDataset(data) {
  return trainInstance({
    url: "/aifaceset/updateSet",
    method: "post",
    data,
  });
}

//添加人脸照片
export function addFaceImage(data) {
  return trainInstance({
    url: "/aifaceset/addimages",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//删除人脸照片
export function deleteFaceImage(data) {
  return trainInstance({
    url: "/aifaceset/deleteResult",
    method: "post",
    data,
  });
}

//批量删除数据集
export function batchDeleteDataset(data) {
  return trainInstance({
    url: "/aifaceset/deleteSets",
    method: "post",
    data,
  });
}

//全部删除数据集
export function deleteAllDataset(data) {
  return trainInstance({
    url: "/aifaceset/deleteallSets",
    method: "post",
    data,
  });
}

//获取人员信息详情
export function getFaceDetail(data) {
  return trainInstance({
    url: "/aifaceset/getSetById",
    method: "post",
    data,
  });
}

//获取数据集标注详情
export function getMarkResult(data) {
  return trainInstance({
    url: "/aifaceset/getResults",
    method: "post",
    data,
  });
}

//保存数据集标注结果
export function saveMarkResult(data) {
  return trainInstance({
    url: "/aifaceset/updateResult",
    method: "post",
    data,
  });
}
