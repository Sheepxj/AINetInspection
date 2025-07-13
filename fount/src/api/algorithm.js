import instance from "@/utils/intercept";

//应用场景
export function getSceneList() {
  return instance({
    url: "/plan/getModelTypes",
    method: "get",
  });
}

//算法列表
export function getAlgorithmList(data) {
  return instance({
    url: "/plan/getPlans",
    method: "get",
    params: data,
  });
}

//算法详情
export function getAlgorithDetail(data) {
  return instance({
    url: "/plan/getModelPlanbyid",
    method: "get",
    params: data,
  });
}

//模型导入
export function exportAlgorithModel(data) {
  return instance({
    url: "/plan/saveModelMsg",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//模型卸载
export function unloadModel(data) {
  return instance({
    url: "/plan/unload",
    method: "get",
    params: data,
  });
}

//模型预测图片
export function modelToPredictImage(data) {
  return instance({
    url: "/plan/getImgMsg",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//视频文件切片上传
export function videoSliceToUpload(data) {
  return instance({
    url: "",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//发生切片文件合并请求 返回模型预测视频结果
export function modelToPredictVideo(data) {
  return instance({
    url: "",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}

//模型预测图片
export function modelToPredictFace(data) {
  return instance({
    url: "/plan/getFaceMsg",
    method: "post",
    headers: {
      "Content-Type": "multipart/form-data",
    },
    data,
  });
}
