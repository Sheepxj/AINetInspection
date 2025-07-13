<template>
    <div class="container">
        <div class="main-wrapper flex-between">
            <div class="filter-wrap card">
                <div class="filter-header border-bottom">
                    筛选条件
                </div>
                <div class="filter-body" v-loading="filterLoading">
                    <el-collapse v-model="activeNames">
                        <el-collapse-item title="时间选择" name="2">
                            <el-radio-group v-model="timePicker" @input="handleTimeChange">
                                <el-radio ref="radio" :label="1">不限</el-radio>
                                <el-radio ref="radio" :label="2">今日</el-radio>
                                <el-radio ref="radio" :label="3">近3天</el-radio>
                                <el-radio ref="radio" :label="4">近7天</el-radio>
                                <el-radio ref="radio" :label="5">自定义</el-radio>
                            </el-radio-group>
                            <div class="selfdefine-date" v-if="timePicker == 5">
                                <el-date-picker v-model="startTime" type="date" placeholder="开始时间" size="small"
                                    value-format="yyyy-MM-dd HH:mm:ss" :picker-options="pickerOptions"
                                    @change="handleStartTimeChange">
                                </el-date-picker>
                                <el-date-picker v-model="endTime" type="date" placeholder="结束时间" size="small"
                                    value-format="yyyy-MM-dd HH:mm:ss" :picker-options="pickerOptions"
                                    @change="handleEndTimeChange">
                                </el-date-picker>
                            </div>
                        </el-collapse-item>
                        <el-collapse-item title="预警类型" name="3" v-if="detectTypePicker == 1">
                            <div class="checkbox-group-list">
                                <div class="checkbox-group" v-for="(item, index) in alarmTypeList" :key="index">
                                    <el-checkbox v-model="item.checked"
                                        @change="handleAlarmTypeChange($event, index)">{{
                                            item.label
                                        }}</el-checkbox>
                                    <span class="warning-count">{{ item.value }}</span>
                                </div>
                                <el-empty description="暂无数据" v-if="alarmTypeList.length == 0"></el-empty>
                            </div>
                        </el-collapse-item>
                        <el-collapse-item title="摄像头点位" name="4">
                            <div class="checkbox-group-list">
                                <div class="checkbox-group" v-for="(item, index) in loactionList" :key="index">
                                    <el-checkbox v-model="item.checked" @change="handleLocationChange($event, index)">{{
                                        item.label
                                    }}</el-checkbox>
                                    <span class="warning-count">{{ item.value }}</span>
                                </div>
                                <el-empty description="暂无数据" v-if="loactionList.length == 0"></el-empty>
                            </div>
                        </el-collapse-item>
                    </el-collapse>
                </div>
            </div>
            <div class="main-content card">
                <div class="top-action">
                    <div class="search-box">
                        <el-input placeholder="请输入多个关键词，用空格隔开" v-model="params.searchText" size="medium"
                            @keyup.enter.native="filterList">
                        </el-input>
                    </div>
                </div>
                <div class="list-top">
                    <div class="statistics">
                        <div class="search-total">共有<span class="total-count">{{ totalCount }}</span>条告警事件</div>
                    </div>
                </div>

                <div class="search-result" v-loading="tableLoading">
                    <div class="image-list">
                        <div class="image-item" v-for="(item, index) in dataList" :key="index" @click="viewVideo(item)">
                            <div class="image">
                                <img :src="item.capturedImage" alt="">
                            </div>
                            <div class="position">
                                <span class="text-gray label">摄像头点位：</span>
                                <span class="value">{{ item.cameraPosition }}</span>
                            </div>
                            <div class="model" v-if="detectTypePicker == 1">
                                <span class="text-gray label">预警类型：</span>
                                <span class="value">{{ item.alertType }}</span>
                            </div>
                            <div class="content" v-if="detectTypePicker == 2">
                                <span class="text-gray label">预警内容：</span>
                                <span class="value " :title="item.textContent">{{ item.textContent }}</span>
                            </div>
                            <div class="date">
                                <span class="text-gray label">预警时间：</span>
                                <span class="value">{{ item.alertTime ? item.alertTime.slice(0, 16) : "" }}</span>
                            </div>
                        </div>
                    </div>
                    <el-empty description="暂无数据" v-if="dataList.length == 0"></el-empty>
                    <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                        :current-page="params.pageNum" :page-sizes="[10, 20, 30, 40, 50]" :page-size="params.pageSize"
                        layout="total, prev, pager, next" :total="totalCount" v-if="dataList.length > 0">
                    </el-pagination>
                </div>
            </div>
        </div>
        <el-dialog title="告警详情" :visible.sync="dialogVisible" width="65%">
            <div class="dialog-wrap" style="min-height: 360px;">
                <div class="left-box">
                    <div class="result-item">
                        <span class="result-item-key">摄像头点位：</span>
                        <span class="result-item-value">{{ alarmInfo.cameraPosition }}</span>
                    </div>
                    <div class="result-item">
                        <span class="result-item-key">监测任务：</span>
                        <span class="result-item-value">{{ detectTypePicker == 1 ?
                            alarmInfo.monitoringTask : alarmInfo.ocrTask }}</span>
                    </div>
                    <div class="result-item" v-if="detectTypePicker == 1">
                        <span class="result-item-key">预警类型：</span>
                        <span class="result-item-value">{{ alarmInfo.alertType }}</span>
                    </div>
                    <div class="result-item" v-if="detectTypePicker == 2">
                        <span class="result-item-key">预警内容：</span>
                        <span class="result-item-value">{{ alarmInfo.textContent }}</span>
                    </div>
                    <div class="result-item">
                        <span class="result-item-key">预警时间：</span>
                        <span class="result-item-value">{{ alarmInfo.alertTime ? alarmInfo.alertTime.slice(0, 16) : ""
                        }}</span>
                    </div>
                    <div class="result-item">
                        <span class="result-item-key">告警级别：</span>
                        <span class="result-item-value">{{ detectTypePicker == 1 ? alarmInfo.alertLevel
                            : detectTypePicker == 1 ?
                                alarmInfo.ocrLevel : alarmInfo.faceLevel
                        }}</span>
                    </div>
                </div>
                <div class="right-box">
                    <div class="title">{{ alarmInfo.capturedVideo ? "摄像头监控截取视频片段" : "摄像头监控截图" }}</div>
                    <div class="camera-wrap">
                        <video :src="alarmInfo.capturedVideo" :poster="alarmInfo.capturedImage" controls muted
                            preload="auto" autoplay="autoplay" loop="loop" v-if="alarmInfo.capturedVideo"></video>
                        <img :src="alarmInfo.capturedImage" alt="" v-viewer v-else>
                    </div>
                </div>
            </div>
        </el-dialog>
    </div>
</template>

<script>
import { getWarningEvent, getAllAlgorithm, getAllLocations, getWarningEventDetail, getTextDetectLocations, getTextDetectWarning, getTextDetectWarningDetail, getFaceDetectLocations, getFaceDetectWarning, getFaceDetectWarningDetail } from "@/api/warning";
import baseURL from "@/utils/request";
export default {
    components: {},
    props: {},
    data() {
        return {
            filterLoading: false,
            tableLoading: false,
            activeNames: ['1', '3'],
            detectTypePicker: 1,
            timePicker: 1,
            startTime: "",
            endTime: "",
            pickerOptions: {
                disabledDate(time) {
                    return time.getTime() > Date.now() - 8.64e6
                },
            },
            params: {
                pageNum: 1,
                pageSize: 12,
                searchText: "",
                alertTypes: [],
                cameraPosition: [],
                startTime: "",
                endTime: "",
            },
            alarmTypeList: [],
            loactionList: [],
            totalCount: 0,
            dataList: [],
            dialogLoading: false,
            dialogVisible: false,
            alarmInfo: {
                alertId: "",
                alertLevel: "",
                alertTime: "",
                alertType: "",
                cameraPosition: "",
                capturedImage: "",
                capturedVideo: "",
                monitoringTask: ""
            },
        };
    },
    created() {
        this.initFilterParams();
        this.getWarningEvent();
    },
    mounted() {

    },
    watch: {},
    computed: {},
    methods: {
        initFilterParams() {
            this.filterLoading = true;
            var requests = [getAllAlgorithm(), getAllLocations()];
            Promise.all(requests).then(results => {
                if (results[0].code == 200) {
                    if (Object.keys(results[0].data).length > 0) {
                        let totalCount = 0;
                        for (const key in results[0].data) {
                            totalCount += results[0].data[key];
                        }
                        this.alarmTypeList = [{ label: "不限", value: totalCount, checked: true }];
                        for (const key in results[0].data) {
                            this.alarmTypeList.push({ label: key, value: results[0].data[key], checked: false });
                        }
                    }
                }

                if (results[1].code == 200) {
                    if (Object.keys(results[1].data).length > 0) {
                        let totalCount = 0;
                        for (const key in results[1].data) {
                            totalCount += results[1].data[key];
                        }
                        this.loactionList = [{ label: "不限", value: totalCount, checked: true }];
                        for (const key in results[1].data) {
                            this.loactionList.push({ label: key, value: results[1].data[key], checked: false });
                        }
                    }
                }
            }).finally(() => {
                this.filterLoading = false;
            })
        },
        getAllAlgorithm() {
            this.filterLoading = true;
            this.alarmTypeList = [];
            getAllAlgorithm().then(res => {
                if (res.code == 200) {
                    if (Object.keys(res.data).length > 0) {
                        for (const key in res.data) {
                            this.alarmTypeList.push({ label: key, value: res.data[key], checked: false });
                        }
                    }
                }
            }).finally(() => {
                this.filterLoading = false;
            })
        },
        getAllLocations() {
            this.filterLoading = true;
            getAllLocations().then(res => {
                if (res.code == 200) {
                    if (Object.keys(res.data).length > 0) {
                        let totalCount = 0;
                        for (const key in res.data) {
                            totalCount += res.data[key];
                        }
                        this.loactionList = [{ label: "不限", value: totalCount, checked: true }];
                        for (const key in res.data) {
                            this.loactionList.push({ label: key, value: res.data[key], checked: false });
                        }
                    }
                }
            }).finally(() => {
                this.filterLoading = false;
            })
        },
        getTextDetectLocations() {
            this.filterLoading = true;
            getTextDetectLocations().then(res => {
                if (res.code == 200) {
                    if (Object.keys(res.data).length > 0) {
                        let totalCount = 0;
                        for (const key in res.data) {
                            totalCount += res.data[key];
                        }
                        this.loactionList = [{ label: "不限", value: totalCount, checked: true }];
                        for (const key in res.data) {
                            this.loactionList.push({ label: key, value: res.data[key], checked: false });
                        }
                    }
                }
            }).finally(() => {
                this.filterLoading = false;
            })
        },
        getFaceDetectLocations() {
            this.filterLoading = true;
            getFaceDetectLocations().then(res => {
                if (res.code == 200) {
                    if (Object.keys(res.data).length > 0) {
                        let totalCount = 0;
                        for (const key in res.data) {
                            totalCount += res.data[key];
                        }
                        this.loactionList = [{ label: "不限", value: totalCount, checked: true }];
                        for (const key in res.data) {
                            this.loactionList.push({ label: key, value: res.data[key], checked: false });
                        }
                    }
                }
            }).finally(() => {
                this.filterLoading = false;
            })
        },
        getWarningEvent() {
            this.dataList = [];
            this.tableLoading = true;
            if (this.detectTypePicker == 1) {
                getWarningEvent(this.params).then(res => {
                    if (res.code == 200) {
                        this.dataList = res.data;
                        this.dataList.forEach(item => {
                            item.capturedImage = baseURL.split("/api")[0] + item.capturedImage;
                        })
                        this.totalCount = res.count;
                    }
                }).finally(() => {
                    this.tableLoading = false;
                })
            } else if (this.detectTypePicker == 2) {
                var form = { pageNum: this.params.pageNum, pageSize: this.params.pageSize, searchText: this.params.searchText, cameraPosition: this.params.cameraPosition, startDate: this.params.startTime, endDate: this.params.endTime };
                getTextDetectWarning(form).then(res => {
                    if (res.code == 200) {
                        this.dataList = res.data;
                        this.dataList.forEach(item => {
                            item.capturedImage = baseURL.split("api")[0] + item.capturedImage;
                        })
                        this.totalCount = res.count;
                    }
                }).finally(() => {
                    this.tableLoading = false;
                })
            } else {
                var form = { pageNum: this.params.pageNum, pageSize: this.params.pageSize, faceData: this.params.searchText, cameraPosition: this.params.cameraPosition, startTime: this.params.startTime, endTime: this.params.endTime };
                getFaceDetectWarning(form).then(res => {
                    if (res.code == 200) {
                        this.dataList = res.data;
                        this.dataList.forEach(item => {
                            item.capturedImage = baseURL.split("/api")[0] + item.capturedImage;
                        })
                        this.totalCount = res.count;
                    }
                }).finally(() => {
                    this.tableLoading = false;
                })
            }
        },
        filterList() {
            this.params.pageNum = 1;
            this.getWarningEvent();
        },
        handleAlarmTypeChange(value, index) {
            this.params.alertTypes = [];
            if (index == 0) {
                if (value) {
                    this.alarmTypeList.forEach((item, index) => {
                        if (index != 0 && item.checked) {
                            item.checked = false;
                        }
                    })
                }
            } else {
                if (value && this.alarmTypeList[0].checked) {
                    this.alarmTypeList[0].checked = false;
                }
            }
            this.alarmTypeList.forEach((item, index) => {
                if (index != 0 && item.checked) {
                    this.params.alertTypes.push(item.label);
                }
            })
            this.filterList();
        },
        handleLocationChange(value, index) {
            this.params.cameraPosition = [];
            if (index == 0) {
                if (value) {
                    this.loactionList.forEach((item, index) => {
                        if (index != 0 && item.checked) {
                            item.checked = false;
                        }
                    })
                }
            } else {
                if (value && this.loactionList[0].checked) {
                    this.loactionList[0].checked = false;
                }
            }
            this.loactionList.forEach((item, index) => {
                if (index != 0 && item.checked) {
                    this.params.cameraPosition.push(item.label);
                }
            })
            this.filterList();
        },
        handleDetectTypeChange(value) {
            if (this.detectTypePicker == 1) {
                this.getAllLocations();
            } else if (this.detectTypePicker == 2) {
                this.getTextDetectLocations();
            } else {
                this.getFaceDetectLocations();
            }
            this.params.pageNum = 1;
            this.getWarningEvent();
        },
        handleTimeChange(value) {
            this.startTime = "";
            this.endTime = "";
            if (value == 1) {
                this.params.startTime = "";
                this.params.endTime = "";
            } else if (value == 2) {
                this.params.startTime = this.timestampToDate(new Date().getTime() - 3600 * 1000 * 24);
                this.params.endTime = this.timestampToDate(new Date().getTime());
            } else if (value == 3) {
                this.params.startTime = this.timestampToDate(new Date().getTime() - 3600 * 1000 * 24 * 3);
                this.params.endTime = this.timestampToDate(new Date().getTime());
            } else if (value == 4) {
                this.params.startTime = this.timestampToDate(new Date().getTime() - 3600 * 1000 * 24 * 7);
                this.params.endTime = this.timestampToDate(new Date().getTime());
            } else {
                return;
            }
            this.filterList();
        },
        handleStartTimeChange(value) {
            if (this.startTime && this.endTime) {
                if (this.checkDate(this.startTime, this.endTime)) {
                    this.params.startTime = this.startTime;
                    this.params.endTime = this.endTime;
                    this.filterList();
                } else {
                    this.endTime = "";
                    this.$message.error("结束时间不能早于开始时间");
                }
            }
        },
        handleEndTimeChange(value) {
            this.endTime = this.endTime.slice(0, 11) + "23:59:59";
            if (this.startTime && this.endTime) {
                if (this.checkDate(this.startTime, this.endTime)) {
                    this.params.startTime = this.startTime;
                    this.params.endTime = this.endTime;
                    this.filterList();
                } else {
                    this.endTime = "";
                    this.$message.error("结束时间不能早于开始时间");
                }
            }
        },
        checkDate(date1, date2) {
            var oDate1 = new Date(date1);
            var oDate2 = new Date(date2);
            if (oDate1.getTime() >= oDate2.getTime()) {
                return false;
            } else {
                return true;
            }
        },
        timestampToDate(timestamp) {
            let now = new Date(timestamp);
            let y = now.getFullYear();
            let m = now.getMonth() + 1;
            let d = now.getDate();
            return y + "-" + (m < 10 ? "0" + m : m) + "-" + (d < 10 ? "0" + d : d) + " " + now.toTimeString().substring(0, 8);
        },
        setWarning() {
            this.$router.push("/warning/settings");
        },
        viewVideo(row) {
            this.tableLoading = true;
            if (this.detectTypePicker == 1) {
                getWarningEventDetail({ alertId: row.alertId }).then(res => {
                    if (res.code == 200) {
                        this.dialogVisible = true;
                        this.alarmInfo = res.data;
                        if (Object.keys(this.alarmInfo).length > 0) {
                            if (this.alarmInfo.capturedImage) {
                                this.alarmInfo.capturedImage = baseURL.split("/api")[0] + this.alarmInfo.capturedImage;
                            }
                            if (this.alarmInfo.capturedVideo) {
                                this.alarmInfo.capturedVideo = baseURL.split("/api")[0] + this.alarmInfo.capturedVideo;
                            }
                        }
                    }
                }).finally(() => {
                    this.tableLoading = false;
                })
            } else if (this.detectTypePicker == 2) {
                getTextDetectWarningDetail({ Id: row.id }).then(res => {
                    if (res.code == 200) {
                        this.dialogVisible = true;
                        this.alarmInfo = res.data;
                        if (Object.keys(this.alarmInfo).length > 0) {
                            if (this.alarmInfo.capturedImage) {
                                this.alarmInfo.capturedImage = baseURL.split("api")[0] + this.alarmInfo.capturedImage;
                            }
                        }
                    }
                }).finally(() => {
                    this.tableLoading = false;
                })
            } else {
                getFaceDetectWarningDetail({ Id: row.id }).then(res => {
                    if (res.code == 200) {
                        this.dialogVisible = true;
                        this.alarmInfo = res.data;
                        if (Object.keys(this.alarmInfo).length > 0) {
                            if (this.alarmInfo.capturedImage) {
                                this.alarmInfo.capturedImage = baseURL.split("/api")[0] + this.alarmInfo.capturedImage;
                            }
                            if (this.alarmInfo.capturedVideo) {
                                this.alarmInfo.capturedVideo = baseURL.split("/api")[0] + this.alarmInfo.capturedVideo;
                            }
                        }
                    }
                }).finally(() => {
                    this.tableLoading = false;
                })
            }
        },
        handleSizeChange(val) {
            // console.log(`每页 ${val} 条`);
            this.params.pageNum = 1;
            this.params.pageSize = val;
            this.getWarningEvent();
        },
        handleCurrentChange(val) {
            // console.log(`当前页: ${val}`);
            this.params.pageNum = val;
            this.getWarningEvent();
        },
    }
};
</script>
<style lang="scss" scoped>
::v-deep input[aria-hidden="true"] {
    display: none !important;
}

::v-deep .el-radio:focus:not(.is-focus):not(:active):not(.is-disabled) .el-radio__inner {
    box-shadow: none !important;
}

.filter-wrap {
    width: 215px;
    position: fixed;
    left: 20px;
    top: 150px;
    box-sizing: border-box;
    height: calc(100vh - 160px);
    // overflow: hidden;
    padding: 0;

    .filter-header {
        padding: 0 12px;
        color: #343a40;
        font-family: Inter, sans-serif;
        font-size: 16px;
        font-weight: 600;
        height: 40px;
        line-height: 40px;

        i {
            margin-right: 5px;
        }
    }

    .filter-body {
        height: calc(100vh - 230px);
        overflow: auto;
        padding: 0 15px;
        box-sizing: border-box;

        // .title {
        //     color: #101010;
        //     font-size: 14px;
        //     font-weight: 600;
        //     margin-bottom: 10px;
        // }

        .el-collapse {
            border: none;

            // ::v-deep .el-collapse-item__header {
            //     height: 40px;
            //     line-height: 40px;
            // }

            .el-radio-group {

                .el-radio {
                    display: block;

                    &:not(:last-child) {
                        margin-bottom: 15px;
                    }
                }
            }


            .selfdefine-date {
                margin-top: 8px;
                padding-left: 25px;

                .el-date-editor {
                    width: 100%;

                    &+.el-date-editor {
                        margin-top: 10px;
                    }
                }
            }

            .checkbox-group-list {

                .checkbox-group {
                    display: flex;
                    justify-content: space-between;

                    &:not(:last-child) {
                        margin-bottom: 12px;
                    }

                    .el-checkbox {
                        width: 130px;
                        white-space: nowrap;
                        text-overflow: ellipsis;
                        overflow: hidden;
                    }

                    .warning-count {
                        color: #6b6b6b;
                        font-size: 13px;
                    }
                }
            }

        }
    }
}

.main-content {
    flex: 1;
    margin-left: 230px;

    .top-action {
        width: 65%;
        margin-bottom: 15px;


        .search-box {
            position: relative;

            .search-btn {
                background-color: #5664d2;
                color: #fff;
                border-top-left-radius: 0;
                border-bottom-left-radius: 0;
            }
        }

    }

    .list-top {
        display: flex;
        justify-content: space-between;

        .statistics {
            display: flex;
            align-items: center;

            .search-total {
                font-size: 15px;
                color: #343a40;

                .total-count {
                    margin: 0px 3px;
                }
            }

            .senior-search {
                display: flex;
                margin-left: 50px;

                .search-control {
                    border: none;

                    &:not(:last-child) {
                        margin-right: 30px;
                    }
                }
            }
        }

    }


    .search-result {
        margin-top: 15px;

        .image-list {
            display: flex;
            flex-wrap: wrap;

            .image-item {
                width: 24.1%;
                // height: 270px;
                padding-bottom: 12px;
                margin-right: 1.2%;
                margin-bottom: 20px;
                border: 1px solid #ebebeb;
                border-radius: 6px;
                box-sizing: border-box;
                font-size: 14px;
                overflow: hidden;
                // color: #a2a8b2;
                cursor: pointer;

                &:nth-child(4n) {
                    margin-right: 0;
                }

                .image {
                    width: 100%;
                    height: 169px;
                    margin-bottom: 12px;
                    position: relative;

                    img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .play-icon {
                        position: absolute;
                        bottom: 50%;
                        transform: translateY(50%);
                        right: 0;
                        left: 0;
                        text-align: center;


                        i {
                            display: inline-block;
                            background-color: rgba(0, 0, 0, 0.5);
                            width: 40px;
                            height: 40px;
                            line-height: 40px;
                            color: #fff;
                            font-size: 26px;
                            text-align: center;
                            box-shadow: 0 .5rem 1rem rgba(0, 0, 0, .15);
                            border-radius: 50%;
                            // cursor: pointer;

                            &:hover {
                                -webkit-text-stroke: 2px #5664d2;
                                -webkit-text-fill-color: #5664d2;
                            }
                        }
                    }
                }

                .position,
                .model {
                    // font-weight: 600;
                    padding: 0 12px;
                    margin-bottom: 6px;

                    .value {
                        color: #030a1a;
                    }
                }

                .content {
                    padding: 0 12px;
                    margin-bottom: 6px;
                    display: flex;

                    .value {
                        flex: 1;
                        color: #030a1a;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }
                }


                .date {
                    padding: 0 12px;

                    .value {
                        color: #030a1a;
                    }
                }
            }
        }
    }
}

.dialog-wrap {
    padding: 0 10px;
    max-height: 53vh;
    display: flex;
    justify-content: space-between;

    .form-control-merge {
        display: flex;

        ::v-deep .el-date-editor.el-input,
        .el-date-editor.el-input__inner {
            width: auto;
            flex: 1;
        }

        .connect {
            margin: 0 10px;
            line-height: 39px;
        }

        .required {
            color: #F56C6C;
            margin-right: 4px;
        }



        .form-control-merge-group {
            display: flex;
            flex: 1;



            ::v-deep .el-form-item .el-form-item__content {
                margin-left: 0 !important;
            }


        }

        &.interval {

            .el-form-item:nth-child(1) {
                flex: 1;
            }

            .el-form-item:nth-child(2) {
                width: 120px;
            }

            ::v-deep .el-form-item:nth-of-type(1) .el-input__inner {
                border-top-right-radius: 0;
                border-bottom-right-radius: 0;
            }

            ::v-deep .el-form-item:nth-of-type(2) .el-input__inner {
                border-top-left-radius: 0;
                border-bottom-left-radius: 0;
            }
        }
    }

    .left-box {
        width: 42%;
        padding: 12px 20px;
        box-sizing: border-box;

        .result-item {

            &:not(:last-child) {
                margin-bottom: 24px;
            }

            .result-item-key {
                color: #a6a6a6;
            }



            .result-item-value {
                flex: 1;

                .image-wrap {
                    position: relative;

                    .image-empty {
                        width: 100%;
                        height: 220px;
                        background-color: #D9D9D9;
                        display: flex;
                        justify-content: center;
                        align-items: center;

                        i {
                            font-size: 24px;
                        }
                    }
                }


            }
        }

    }

    .right-box {
        flex: 1;
        margin-left: 20px;
        box-sizing: border-box;

        .title {
            color: #1b1e26;
            font-size: 15px;
            margin-bottom: 6px;
        }

        .camera-wrap {
            width: 100%;
            height: calc(100% - 24px);
            background: #1e1e1e;

            video {
                width: 100%;
                height: 100%;
            }

            img {
                width: 100%;
                height: 100%;
                object-fit: contain;
            }
        }

    }
}

.upload-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    max-height: 60vh;
    overflow: auto;

    .title {
        font-size: 24px;
        color: #333;
        padding: 0 0 16px;
        font-weight: 600;
    }

    .sub-title {
        color: rgba(0, 0, 0, 0.65);
        font-size: 18px;
        padding: 0 0 24px;
    }

    .upload-imageUrl {
        width: 90%;
        margin-bottom: 24px;

        .search-btn {
            background-color: #5664d2;
            color: #fff;
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
            height: 38px;
            box-sizing: border-box;
        }
    }

    .upload-imageFile {
        width: 90%;

        ::v-deep .el-upload {
            width: 100%;

            .el-upload-dragger {
                width: 100%;
            }
        }
    }

}
</style>