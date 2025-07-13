import instance from "@/utils/intercept";

//计算节点列表
export function getComputeNodeList(data) {
  return instance({
    url: "/pyregister/getPyMsgList",
    method: "post",
    data,
  });
}
