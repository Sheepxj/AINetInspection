import instance from "@/utils/intercept";

//设备在线状态统计
export function getDeviceStatus() {
  return instance({
    url: "/sterams/getCamerastus",
    method: "get",
  });
}

//预警数据统计
export function getStatistics() {
  return instance({
    url: "/radis/returnmsg",
    method: "get",
  });
}

//预警排名走势分析 今天
export function getTodayAlarmTrend() {
  return instance({
    url: "/warningTable/getTodayTopAlertTypes",
    method: "get",
  });
}

//预警排名走势分析 过去七天
export function getLastWeekAlarmTrend() {
  return instance({
    url: "/warningTable/getSevenTopAlertTypes",
    method: "get",
  });
}

//预警排名走势分析 过去三十天
export function getLastMonthAlarmTrend() {
  return instance({
    url: "/warningTable/getMonthTopAlertTypes",
    method: "get",
  });
}

//监控设备列表
export function getMonitorDevice() {
  return instance({
    url: "/boards/location",
    method: "get",
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

//最近预警列表清单
export function getLatestWarning() {
  return instance({
    url: "/warningTable/getwarning",
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
