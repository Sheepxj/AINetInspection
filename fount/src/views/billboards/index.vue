<template>
    <div class="container">
        <div class="main-wrapper" v-loading="loading">
            <el-row :gutter="20">
                <el-col :span="16" class="billboards-left">
                    <el-row :gutter="20" class="billboards-left-top">
                        <el-col :span="8">
                            <div class="card stats-digit">
                                <div class="card-body">
                                    <div class="stats-label">摄像头布控</div>
                                    <div class="stats-value">{{ statistics.deviceCount }}</div>
                                </div>
                                <div class="card-icon text-primary">
                                    <i class="iconfont icon-bukong"></i>
                                </div>
                            </div>
                            <div class="card stats-trend border-top">
                                <div class="card-body">
                                    <div class="stats-value-ratio badge"
                                        :class="{ 'badge-yellow': statistics.deviceCount == 0, 'badge-red': statistics.deviceCount > 0 && statistics.deviceCount != statistics.deviceWorkCount, 'badge-green': statistics.deviceCount > 0 && statistics.deviceCount == statistics.deviceWorkCount }">
                                        <i class="iconfont icon-yuandian"></i>
                                        <span>{{ statistics.deviceCount > 0 ? statistics.deviceRatio + "%" : "N/A"
                                            }}</span>
                                    </div>
                                    <div class="stats-value-desc text-gray">
                                        {{ statistics.deviceCount > 0 ? (statistics.deviceRatio == 100 ? "设备状态全部正常"
                                            : (statistics.deviceCount - statistics.deviceWorkCount) + "台设备状态异常") : "当前无设备"
                                        }}
                                    </div>
                                </div>
                            </div>
                        </el-col>
                        <el-col :span="8">
                            <div class="card stats-digit">
                                <div class="card-body">
                                    <div class="stats-label">今日预警数量</div>
                                    <div class="stats-value">{{ statistics.todayCount }}</div>
                                </div>
                                <div class="card-icon text-primary">
                                    <i class="iconfont icon-gaojingshijian"></i>
                                </div>
                            </div>
                            <div class="card stats-trend border-top">
                                <div class="card-body">
                                    <div class="stats-value-ratio badge"
                                        :class="{ 'badge-yellow': statistics.todayStatus == 0, 'badge-red': statistics.todayStatus == 1, 'badge-green': statistics.todayStatus == 2 }">
                                        <i
                                            :class="{ 'el-icon-caret-bottom': statistics.deviceCount > 0 && statistics.todayStatus == 0, 'el-icon-caret-top': statistics.deviceCount > 0 && statistics.todayStatus == 1, 'iconfont icon-yuandian': statistics.deviceCount == 0 || statistics.todayStatus == 2 }"></i>
                                        <span>{{ statistics.todayCount > 0 ? statistics.todayRatio + "%" : "N/A"
                                            }}</span>
                                    </div>
                                    <div class="stats-value-desc text-gray">{{
                                        statistics.todayCount > 0 ? (statistics.todayStatus == 0 ? "比昨天预警数量降低"
                                            :
                                            statistics.todayStatus == 1 ? "比昨天预警数量升高" : "与昨天预警数量相同") : "当前无预警信息" }}</div>
                                </div>
                            </div>
                        </el-col>
                        <el-col :span="8">
                            <div class="card stats-digit">
                                <div class="card-body">
                                    <div class="stats-label">昨日预警数量</div>
                                    <div class="stats-value">{{ statistics.yesterdayCount }}</div>
                                </div>
                                <div class="card-icon text-primary">
                                    <i class="iconfont icon-alarm"></i>
                                </div>
                            </div>
                            <div class="card stats-trend border-top">
                                <div class="card-body">
                                    <div class="stats-value-ratio badge"
                                        :class="{ 'badge-yellow': statistics.yesterdayStatus == 0, 'badge-red': statistics.yesterdayStatus == 1, 'badge-green': statistics.yesterdayStatus == 2 }">
                                        <i
                                            :class="{ 'el-icon-caret-bottom': statistics.deviceCount > 0 && statistics.yesterdayStatus == 0, 'el-icon-caret-top': statistics.deviceCount > 0 && statistics.yesterdayStatus == 1, 'iconfont icon-yuandian': statistics.deviceCount == 0 || statistics.yesterdayStatus == 2 }"></i>
                                        <span>{{ statistics.yesterdayCount > 0 ? statistics.yesterdayRatio + "%" : "N/A"
                                            }}</span>
                                    </div>
                                    <div class="stats-value-desc text-gray">{{ statistics.yesterdayCount > 0 ?
                                        (statistics.yesterdayStatus == 0 ?
                                            "比前天预警数量降低" :
                                            statistics.yesterdayStatus == 1 ? "比前天预警数量升高" : "与前天预警数量相同") : "无预警信息" }}</div>
                                </div>
                            </div>
                        </el-col>
                    </el-row>
                    <el-row :gutter="20" style="margin-top: 24px;">
                        <el-col :span="24">
                            <div class="layout card">
                                <div class="layout-top flex-between">
                                    <div class="title"><i class="el-icon-data-line"
                                            style="vertical-align: text-bottom;"></i>预警排名走势分析</div>
                                    <div class="action">
                                        <div class="filter-btn-group">
                                            <el-button-group>
                                                <el-button size="small" class="chart-filter"
                                                    :class="{ 'active': activeIndex == 1 }"
                                                    @click="filterWarningRank(1)">今天</el-button>
                                                <el-button size="small" class="chart-filter"
                                                    :class="{ 'active': activeIndex == 2 }"
                                                    @click="filterWarningRank(2)">7天</el-button>
                                                <el-button size="small" class="chart-filter"
                                                    :class="{ 'active': activeIndex == 3 }"
                                                    @click="filterWarningRank(3)">30天</el-button>
                                            </el-button-group>
                                        </div>
                                    </div>
                                </div>
                                <div class="layout-content" v-loading="chartLoading">
                                    <div class="line-chart" v-if="splineAreaChart.series.length > 0">
                                        <apexchart class="apex-charts" :height="lineChartHeight" type="area" dir="ltr"
                                            :series="splineAreaChart.series" :options="splineAreaChart.chartOptions">
                                        </apexchart>
                                    </div>
                                    <div class="chart-empty" v-else>
                                        <el-empty description="暂无预警排名走势信息"></el-empty>
                                    </div>
                                </div>
                            </div>
                        </el-col>
                    </el-row>
                </el-col>
                <el-col :span="8" class="billboards-right">
                    <el-row :gutter="20" class="realtime-monitor">
                        <el-col :span="24">
                            <div class="layout card">
                                <div class="layout-top flex-between">
                                    <div class="title"><i class="el-icon-video-camera"
                                            style="vertical-align: text-bottom;"></i>摄像头实时监控画面</div>
                                    <div class="action">
                                        <div class="device-options" v-if="locationList.length > 0">
                                            <el-cascader v-model="location" :options="locationList" size="small"
                                                @change="handleLocationChange"></el-cascader>
                                        </div>
                                        <div class="create-button" v-if="locationList.length == 0">
                                            <el-button type="text" @click="createDevice">添加摄像头</el-button>
                                        </div>
                                    </div>
                                </div>
                                <div class="layout-content">
                                    <div class="realtime-video" v-if="locationList.length > 0 && !deviceAbnormal">
                                        <live-player containerId="video-live" :streamId="streamId"
                                            :streamUrl="streamUrl"></live-player>
                                    </div>
                                    <div class="footage-empty" v-else>
                                        <el-empty
                                            :description="locationList.length == 0 ? '点击 添加摄像头 添加监控设备' : deviceAbnormal ? '监控设备失效，画面无法显示' : '暂无监控画面'"></el-empty>
                                    </div>
                                </div>
                            </div>
                        </el-col>
                    </el-row>
                    <el-row :gutter="20" style="margin-top: 24px;">
                        <el-col :span="24">
                            <div class="layout card">
                                <div class="layout-top flex-between">
                                    <div class="title"><i class="el-icon-bell"
                                            style="vertical-align: middle;"></i>最近预警列表清单</div>
                                    <div class="action">
                                        <div class="tomore-button" v-if="alarmList.length > 0">
                                            <el-button type="text" @click="toMoreWarning">更多</el-button>
                                        </div>
                                        <div class="create-button" v-if="locationList.length == 0">
                                            <el-button type="text" @click="createTask">添加监测任务</el-button>
                                        </div>
                                    </div>
                                </div>
                                <div class="layout-content" v-loading="alarmLoading">
                                    <div class="simple-list">
                                        <div class="simple-wrap" v-if="alarmList.length > 0">
                                            <vue-seamless-scroll ref="scrollBar" :data="alarmList" :loop="true"
                                                :class-option="classOption">
                                                <ul class="list-unstyled"
                                                    :class="{ 'activity-wid': alarmList.length > 1 }">
                                                    <li class="activity-list" v-for="(item, index) in alarmList"
                                                        :key="index">
                                                        <div class="activity-icon avatar-xs">
                                                            <span
                                                                class="avatar-title bg-primary text-primary rounded-circle">
                                                                <i class="iconfont icon-laba"></i>
                                                            </span>
                                                        </div>
                                                        <div class="event-list">
                                                            <div class="event-list-item pointer"
                                                                @click="viewDetail(item)">
                                                                <div class="event-list-item-left">
                                                                    <div class="event-date font-size-13">
                                                                        <span>{{ item.alertTime.slice(0, 16) }}</span>
                                                                        <!-- <small class="text-gray">12:07 中午</small> -->
                                                                    </div>
                                                                    <div class="event-name">
                                                                        <p>
                                                                            <span class="text-gray label">监控区域：</span>
                                                                            <span class="value">{{ item.cameraPosition
                                                                                }}</span>
                                                                        </p>
                                                                        <p><span class="text-gray label">预警类型：</span>
                                                                            <span class="value">{{
                                                                                item.alertType }}</span>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <div class="event-list-item-right">
                                                                    <div class="event-image">
                                                                        <img :src="item.capturedImage" alt="">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>
                                            </vue-seamless-scroll>
                                        </div>

                                        <div class="alarm-empty" v-else>
                                            <el-empty description="暂无预警信息"></el-empty>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </el-col>
                    </el-row>
                </el-col>
            </el-row>
        </div>
        <el-dialog title="告警详情" :visible.sync="dialogVisible" width="65%">
            <div class="dialog-wrap">
                <div class="detail">
                    <div class="left-box">
                        <div class="result-item">
                            <span class="result-item-key">预警编号：</span>
                            <span class="result-item-value">{{ alarmInfo.alertId }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">摄像头点位：</span>
                            <span class="result-item-value">{{ alarmInfo.cameraPosition }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">监测任务：</span>
                            <span class="result-item-value">{{ alarmInfo.monitoringTask }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">预警类型：</span>
                            <span class="result-item-value">{{ alarmInfo.alertType }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">预警时间：</span>
                            <span class="result-item-value">{{ alarmInfo.alertTime }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">告警级别：</span>
                            <span class="result-item-value">{{ alarmInfo.alertLevel }}</span>
                        </div>
                    </div>
                    <div class="right-box">
                        <div class="title">摄像头监控截取视频片段</div>
                        <div class="camera-wrap">
                            <video :src="alarmInfo.capturedVideo" :poster="alarmInfo.capturedImage" controls
                                preload="auto" autoplay="autoplay" loop="loop"></video>
                        </div>
                    </div>
                </div>
            </div>
        </el-dialog>
    </div>
</template>

<script>
import { getDeviceStatus, getStatistics, getTodayAlarmTrend, getLastWeekAlarmTrend, getLastMonthAlarmTrend, getMonitorDevice, getLatestWarning, getWarningEventDetail } from "@/api/billboards";
import baseURL from "@/utils/request";
import livePlayer from "@/components/livePlayer.vue";
export default {
    components: { livePlayer },
    props: {},
    data() {
        return {
            loading: false,
            countDuration: 2000,
            statistics: {
                deviceCount: 0,
                deviceWorkCount: 0,
                deviceRatio: 0,
                todayCount: 0,
                todayRatio: 0,
                todayStatus: 0,
                yesterdayCount: 0,
                yesterdayRatio: 0,
                yesterdayStatus: 0
            },
            locationList: [],
            location: [],
            splineAreaChart: {
                series: [
                    // {
                    //     name: '吸烟检测',
                    //     data: [34, 40, 28, 52, 42, 109, 100]
                    // },
                    // {
                    //     name: '打电话检测',
                    //     data: [32, 60, 34, 46, 34, 52, 41]
                    // },
                    // {
                    //     name: '交通事故检测',
                    //     data: [36, 50, 44, 62, 54, 12, 31]
                    // }
                ],
                chartOptions: {
                    chart: {
                        toolbar: {
                            show: false // 隐藏顶部工具栏
                        },
                        animations: {
                            enabled: false // 设置动画效果为禁用
                        },
                    },
                    dataLabels: {
                        enabled: false
                    },
                    stroke: {
                        curve: 'smooth',
                        width: 3,
                    },
                    colors: ['#556ee6', '#34c38f', "#4aa3ff"],
                    xaxis: {
                        // type: 'datetime',
                        categories: [],
                    },
                    yaxis: {
                        labels: {
                            formatter: function (value) {
                                return Math.floor(value);
                            }
                        }
                    },
                    grid: {
                        borderColor: '#f1f1f1',
                    },
                    tooltip: {
                        // x: {
                        //     format: 'yyyy/MM/dd HH:mm'
                        // },
                    },

                }
            },
            activeIndex: 1,
            dialogVisible: false,
            alarmList: [],
            isfirst: true,
            classOption: {
                step: 0.8
            },
            timer: null,
            deviceAbnormal: false, //当前摄像头是否正常
            alarmLoading: false,
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
            chartLoading: false,
            lineChartHeight: "",
            streamId: null,
            streamUrl: ""
        }
    },
    created() {
        this.initLoading();
    },
    mounted() {

    },
    beforeDestroy() {
        //清除定时器
        clearInterval(this.timer);
    },
    watch: {

    },
    computed: {},
    methods: {
        initLoading() {
            this.loading = true;
            this.locationList = [];
            var requests = [getMonitorDevice(), getLatestWarning(), getDeviceStatus(), getStatistics(), getTodayAlarmTrend()];
            Promise.all(requests).then(results => {
                // console.log(results);
                if (results[0].code == 200) {
                    if (results[0].data.length > 0) {
                        results[0].data.forEach(item => {
                            var obj = { label: item.groupName, value: item.groupName };
                            var children = [];
                            item.cameras.forEach(child => {
                                var childObj = { label: child.cameraLocation, value: child.zlmId, streamUrl: child.zlmUrl };
                                if (child.cameraStatus != undefined) {
                                    childObj.status = child.cameraStatus;
                                }
                                if (child.videoScale != undefined) {
                                    childObj.videoScale = child.videoScale;
                                }
                                children.push(childObj);
                            });
                            obj.children = children;
                            this.locationList.push(obj);
                        });


                        for (let i = 0; i < this.locationList.length; i++) {
                            const cameraList = this.locationList[i].children;
                            if (cameraList.length > 0) {
                                for (let j = 0; j < cameraList.length; j++) {
                                    if (cameraList[j].status == 1) {
                                        this.location = [this.locationList[i].value, cameraList[j].value];
                                        //获取第一个状态正常的摄像头画面
                                        this.streamId = cameraList[j].value;
                                        this.streamUrl = cameraList[j].streamUrl;
                                        break;
                                    }
                                }
                            }
                            if (this.location.length > 0) {
                                break;
                            }
                        }

                        this.$nextTick(() => {
                            var videoDom = document.querySelector(".realtime-video");
                            if (videoDom) {
                                videoDom.style.height = JSON.stringify(videoDom.offsetWidth * 0.75) + "px";
                            }
                        })
                    }
                } else {
                    var videoDom = document.querySelector(".realtime-video");
                    if (videoDom) {
                        videoDom.style.height = JSON.stringify(videoDom.offsetWidth * 0.75) + "px";
                    }
                }

                if (results[1].code == 200) {
                    if (results[1].data.length > 0) {
                        this.alarmList = results[1].data;
                        this.alarmList.forEach(item => {
                            item.capturedImage = baseURL.split("/api")[0] + item.capturedImage;
                            item.capturedVideo = baseURL.split("/api")[0] + item.capturedVideo;
                        })
                    }
                }
                //每隔俩分钟自动调接口获取一次预警信息
                this.timer = setInterval(() => {
                    getLatestWarning().then(res => {
                        if (res.code == 200) {
                            if (res.data.length > 0) {
                                this.alarmList = res.data;
                                this.alarmList.forEach(item => {
                                    item.capturedImage = baseURL.split("/api")[0] + item.capturedImage;
                                    item.capturedVideo = baseURL.split("/api")[0] + item.capturedVideo;
                                })
                            }
                        }
                    })
                }, 1000 * 120);

                if (results[2].code == 200) {
                    if (Object.keys(results[2].data).length > 0) {
                        var deviceStatistics = results[2].data;
                        this.statistics.deviceCount = deviceStatistics.Camerasum;
                        this.statistics.deviceWorkCount = deviceStatistics.working;
                        if (deviceStatistics.rate) {
                            this.statistics.deviceRatio = Number(deviceStatistics.rate.split("%")[0]);
                        } else {
                            this.statistics.deviceRatio = 0;
                        }
                    }
                }

                if (results[3].code == 200) {
                    if (Object.keys(results[3].data).length > 0) {
                        var alarmStatistics = results[3].data;
                        this.statistics.todayCount = alarmStatistics.today;
                        this.statistics.todayRatio = Math.abs(Number(alarmStatistics["day-yesterday"]));
                        this.statistics.todayStatus = Number(alarmStatistics["day-yesterday"]) > 0 ? 1 : Number(alarmStatistics["day-yesterday"]) < 0 ? 0 : 2;
                        this.statistics.yesterdayCount = alarmStatistics.yesterday;
                        this.statistics.yesterdayRatio = Math.abs(Number(alarmStatistics["yesterday-before"]));
                        this.statistics.yesterdayStatus = Number(alarmStatistics["yesterday-before"]) > 0 ? 1 : Number(alarmStatistics["yesterday-before"]) < 0 ? 0 : 2;;
                    }
                }

                if (results[4].code == 200) {
                    var result = results[4].data;
                    if (Object.keys(result).length > 0) {
                        var dataSets = [];
                        var categories = [];
                        var isfirst = true;
                        for (const key in result) {
                            var modelObject = {};
                            modelObject.name = key;
                            var dataArray = [];
                            for (const sonkey in result[key]) {
                                if (isfirst) {
                                    categories.push(sonkey);
                                }
                                dataArray.push(result[key][sonkey]);
                            }
                            isfirst = false;
                            modelObject.data = dataArray;
                            dataSets.push(modelObject);
                        }
                        this.splineAreaChart.series = dataSets;
                        this.splineAreaChart.chartOptions.xaxis.categories = categories;
                    }
                    this.$nextTick(() => {
                        var billboardsRightDom = document.querySelector(".billboards-right");
                        var billboardsLeftTopDom = document.querySelector(".billboards-left-top");
                        this.lineChartHeight = JSON.stringify(billboardsRightDom.offsetHeight - billboardsLeftTopDom.offsetHeight - 122);
                        var chartEmptyDom = document.querySelector(".chart-empty");
                        if (chartEmptyDom) {
                            chartEmptyDom.style.height = JSON.stringify(JSON.parse(this.lineChartHeight) + 15) + "px";
                        }

                    })
                }
            }).finally(() => {
                this.loading = false;
            })
        },
        handleLocationChange(value) {
            // console.log(value)
            for (let i = 0; i < this.locationList.length; i++) {
                const cameraList = this.locationList[i].children;
                if (cameraList.length > 0) {
                    for (let j = 0; j < cameraList.length; j++) {
                        if (cameraList[j].value == value[1]) {
                            this.streamId = cameraList[j].value;
                            this.streamUrl = cameraList[j].streamUrl;
                            break;
                        }
                    }
                }
            }
        },
        filterWarningRank(index) {
            this.activeIndex = index;
            if (index == 1) {
                this.getTodayAlarmTrend();
            } else if (index == 2) {
                this.getLastWeekAlarmTrend();
            } else {
                this.getLastMonthAlarmTrend();
            }
        },
        getTodayAlarmTrend() {
            this.chartLoading = true;
            getTodayAlarmTrend().then(res => {
                setTimeout(() => {
                    this.chartLoading = false;
                    if (res.code == 200) {
                        var result = res.data;
                        if (Object.keys(result).length > 0) {
                            var dataSets = [];
                            var categories = [];
                            var isfirst = true;
                            for (const key in result) {
                                var modelObject = {};
                                modelObject.name = key;
                                var dataArray = [];
                                for (const sonkey in result[key]) {
                                    if (isfirst) {
                                        categories.push(sonkey);
                                    }
                                    dataArray.push(result[key][sonkey]);
                                }
                                isfirst = false;
                                modelObject.data = dataArray;
                                dataSets.push(modelObject);
                            }
                            this.splineAreaChart.series = dataSets;
                            this.splineAreaChart.chartOptions.xaxis.categories = categories;
                        } else {
                            this.splineAreaChart.series = [];
                            this.splineAreaChart.chartOptions.xaxis.categories = [];
                        }
                    }
                }, 500);
            }).catch(() => {
                this.chartLoading = false;
            })
        },
        getLastWeekAlarmTrend() {
            this.chartLoading = true;
            getLastWeekAlarmTrend().then(res => {
                setTimeout(() => {
                    this.chartLoading = false;
                    if (res.code == 200) {
                        var result = res.data;
                        if (Object.keys(result).length > 0) {
                            var dataSets = [];
                            var categories = [];
                            var isfirst = true;
                            for (const key in result) {
                                var modelObject = {};
                                modelObject.name = key;
                                var dataArray = [];
                                for (const sonkey in result[key]) {
                                    if (isfirst) {
                                        categories.push(sonkey);
                                    }
                                    dataArray.push(result[key][sonkey]);
                                }
                                isfirst = false;
                                modelObject.data = dataArray;
                                dataSets.push(modelObject);
                            }
                            this.splineAreaChart.series = dataSets;
                            this.splineAreaChart.chartOptions.xaxis.categories = categories;
                        }
                    } else {
                        this.splineAreaChart.series = [];
                        this.splineAreaChart.chartOptions.xaxis.categories = [];
                    }
                }, 500);

            }).catch(() => {
                this.chartLoading = false;
            })
        },
        getLastMonthAlarmTrend() {
            this.chartLoading = true;
            getLastMonthAlarmTrend().then(res => {
                setTimeout(() => {
                    this.chartLoading = false;
                    if (res.code == 200) {
                        var result = res.data;
                        if (Object.keys(result).length > 0) {
                            var dataSets = [];
                            var categories = [];
                            var isfirst = true;
                            for (const key in result) {
                                var modelObject = {};
                                modelObject.name = key;
                                var dataArray = [];
                                for (const sonkey in result[key]) {
                                    if (isfirst) {
                                        categories.push(sonkey);
                                    }
                                    dataArray.push(result[key][sonkey]);
                                }
                                isfirst = false;
                                modelObject.data = dataArray;
                                dataSets.push(modelObject);
                            }
                            this.splineAreaChart.series = dataSets;
                            this.splineAreaChart.chartOptions.xaxis.categories = categories;
                        } else {
                            this.splineAreaChart.series = [];
                            this.splineAreaChart.chartOptions.xaxis.categories = [];
                        }
                    }
                }, 500);

            }).catch(() => {
                this.chartLoading = false;
            })
        },
        toMoreWarning() {
            this.$router.push("/warning");
        },
        viewDetail(row) {
            this.alarmLoading = true;
            getWarningEventDetail({ alertId: row.alertId }).then(res => {
                if (res.code == 200) {
                    this.dialogVisible = true;
                    this.alarmInfo = res.data;
                    if (Object.keys(this.alarmInfo).length > 0) {
                        this.alarmInfo.capturedImage = baseURL.split("/api")[0] + this.alarmInfo.capturedImage;
                        this.alarmInfo.capturedVideo = baseURL.split("/api")[0] + this.alarmInfo.capturedVideo;
                    }
                }
            }).finally(() => {
                this.alarmLoading = false;
            })

        },
        createDevice() {
            this.$router.push("/access");
        },
        createTask() {
            this.$router.push("/task");
        }
    }
};
</script>
<style lang="scss" scoped>
canvas {
    background-color: #000;
    object-fit: fill;
}

.stats-label {
    font-size: 14px;
}

.stats-value {
    color: #343a40;
    font-family: Inter, sans-serif;
    font-size: 22px;
    margin-top: 8px;
}


.stats-digit {
    display: flex;
    align-items: flex-start;
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;

    .card-body {
        flex: 1;
    }

    .card-icon i {
        font-size: 28px;
    }
}

.stats-trend {
    border-top-left-radius: 0;
    border-top-right-radius: 0;

    .card-body {
        display: flex;
        align-items: center;

        .stats-value-ratio {
            font-size: 11px;
            margin-right: 8px;

            i {
                margin-right: 3px;
            }

            .icon-yuandian {
                font-size: 11px;
            }
        }

        .stats-value-desc {
            font-size: 14px;
        }
    }
}

.layout-top {
    height: 32px;
    margin-bottom: 10px;

    .title {
        color: #343a40;
        font-size: 15px;
        font-weight: 500;
        font-family: Inter, sans-serif;
        // display: flex;
        // align-items: center;

        i {
            margin-right: 5px;
            font-size: 18px;
        }
    }

    .action {
        padding: 0 6px;

        .chart-filter {

            &.active {
                color: #FFFFFF;
                background-color: #5664d2;
                border-color: #5664d2;
            }
        }
    }
}

.layout-content {

    .realtime-video {
        position: relative;
    }

    .chart-empty,
    .footage-empty,
    .alarm-empty {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .simple-list {
        height: 45vh;
        padding-right: 15px;
        overflow: hidden;

        &:after {
            content: " ";
            display: table;
        }

        &:before {
            content: " ";
            display: table;
        }

        &::-webkit-scrollbar {
            width: 0;
        }
    }


    .list-unstyled {
        padding-left: 0;
        list-style: none;
        animation-timing-function: linear;
        margin-top: 8px;
        margin-left: 16px;
    }

    .activity-wid {

        .activity-list {

            &:before {
                content: "";
                border-left: 2px dashed rgba(86, 100, 210, .25);
                position: absolute;
                left: 0;
                bottom: 0;
                top: 32px;
            }
        }
    }

    .activity-list {
        position: relative;
        padding: 0 0 40px 30px;

        // &:last-child {
        //     padding-bottom: 0;
        // }

        .activity-icon {
            position: absolute;
            left: -15px;
            top: 0;
            z-index: 9;

            .avatar-title {
                align-items: center;
                display: flex;
                font-weight: 500;
                height: 100%;
                justify-content: center;
                width: 100%;
            }
        }

        .avatar-xs {
            width: 32px;
            height: 32px;
        }

        .event-list {

            .event-list-item {
                display: flex;
                justify-content: space-between;
                align-items: center;

                .event-list-item-left {
                    width: 65%;

                    .event-date {
                        color: #030a1a;
                        font-family: Inter, sans-serif;
                        font-weight: 500;
                        margin-bottom: 8px;

                        small {
                            font-size: 80%;
                            font-weight: 400;
                        }
                    }

                    .event-name {
                        font-size: 14px;
                        line-height: 24px;

                        .value {
                            color: #030a1a;
                        }
                    }
                }

                .event-list-item-right {
                    width: 30%;

                    .event-image {
                        height: 70px;

                        img {
                            width: 100%;
                            height: 100%;
                            object-fit: cover;
                            border-radius: 4px;
                        }
                    }
                }
            }
        }
    }
}

.dialog-wrap {
    max-height: 55vh;
    // overflow: auto;
    padding: 0 10px;

    .detail {
        display: flex;
        justify-content: space-between;

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
            }

        }
    }
}
</style>