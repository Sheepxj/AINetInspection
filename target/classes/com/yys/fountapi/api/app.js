import instance from "@/utils/intercept";

//监控设备列表
export function getMonitorDevice() {
  return instance({
    url: "/boards/location",
    method: "get",
  });
}

//最近预警列表清单
export function getWarningEvents(data) {
  return instance({
    url: "/warningTable/selectwarning",
    method: "post",
    data,
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
