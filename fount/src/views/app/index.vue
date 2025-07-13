<template>
    <div class="app">
        <van-nav-bar title="AI视频卫士" />
        <div class="mask" v-loading="loading">
            <div class="monitor-container">
                <div class="action vertical">
                    <div class="filter">
                        <el-cascader v-model="location" :options="locationList" placeholder="请选择监控画面" size="small"
                            @change="handleLocationChange"></el-cascader>
                    </div>
                </div>
                <div class="content">
                    <live-player containerId="video-live" :streamId="streamId" :streamUrl="streamUrl"></live-player>
                </div>
            </div>
            <div class="warning-container">
                <div class="title">
                    <i class="el-icon-bell"></i>
                    <span>预警事件</span>
                </div>
                <div class="content">
                    <div class="event-list">
                        <van-list v-model="loadingMore" :finished="finished" :error.sync="error"
                            error-text="请求失败，点击重新加载" finished-text="没有更多了" @load="onLoad">
                            <div class="event-item pointer" v-for="(item, index) in alarmList" :key="index"
                                @click="viewEventDetail(item)">
                                <div class="event-item-left">
                                    <div class="event-date font-size-13">
                                        <span>{{ item.alertTime.slice(0, 16) }}</span>
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
                                <div class="event-item-right">
                                    <div class="event-image">
                                        <img :src="item.capturedImage" alt="">
                                    </div>
                                </div>
                            </div>
                        </van-list>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { getMonitorDevice, getWarningEvents } from "@/api/app";
import baseURL from "@/utils/request";
import livePlayer from "@/components/livePlayer.vue";
export default {
    components: { livePlayer },
    props: {},
    data() {
        return {
            loading: false,
            locationList: [],
            location: [],
            streamId: null,
            streamUrl: "",
            params: {
                pageNum: 1,
                pageSize: 10,
                searchText: "",
                alertTypes: [],
                cameraPosition: [],
                startTime: "",
                endTime: "",
            },
            totalCount: 0,
            alarmList: [],
            loadingMore: false,
            finished: false,
            error: false
        };
    },
    created() {
        this.initLoading();
    },
    mounted() {
        if (this.isMobileDevice()) {
            if (window.location.pathname.indexOf("app") == -1) {
                this.$router.replace("/app/index");
            }
        } else {
            if (window.location.pathname.indexOf("app") > -1) {
                this.$router.replace("/billboards");
            }
        }
    },
    watch: {},
    computed: {},
    methods: {
        initLoading() {
            var requests = [getMonitorDevice(), getWarningEvents(this.params)];
            this.loading = true;
            Promise.all(requests).then(results => {
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
                    }
                }

                if (results[1].code == 200) {
                    if (results[1].data.length > 0) {
                        this.totalCount = results[1].count;
                        this.alarmList = results[1].data;
                        this.alarmList.forEach(item => {
                            item.capturedImage = baseURL.split("/api")[0] + item.capturedImage;
                            item.capturedVideo = baseURL.split("/api")[0] + item.capturedVideo;
                        });
                        this.params.pageNum++;
                    }
                }
            }).finally(() => {
                this.loading = false;
            })
        },
        handleLocationChange(value) {
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
        onLoad() {
            if (!this.finished) {
                getWarningEvents(this.params).then(res => {
                    if (res.code == 200) {
                        var tempList = res.data;
                        tempList.forEach(item => {
                            item.capturedImage = baseURL.split("/api")[0] + item.capturedImage;
                            item.capturedVideo = baseURL.split("/api")[0] + item.capturedVideo;
                        });
                        this.params.pageNum++;

                        this.alarmList = this.alarmList.concat(tempList);
                        // 数据全部加载完成
                        if (this.alarmList.length >= this.totalCount) {
                            this.finished = true;
                        }
                    }
                }).finally(() => {
                    this.loadingMore = false;
                }).catch(() => {
                    this.error = true;
                })
            }
        },
        viewEventDetail(row) {
            this.$router.push({ path: "/app/event", query: { id: row.alertId } });
        },
        isMobileDevice() {
            //判断当前设备是移动设备还是PC设备 
            if (/(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i.test(
                navigator.userAgent
            )) {
                return true;
            } else {
                return false;
            }
        }
    }
};
</script>
<style lang="scss" scoped>
.van-nav-bar {
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
}

.mask {
    margin-top: 46px;

    .monitor-container {
        background-color: #fff;
        padding: 12px;


        .action {
            display: flex;
            align-items: center;
            gap: 12px;



            &.vertical .filter {
                flex: 1;

                .el-cascader {
                    width: 100%;
                }
            }
        }

        .content {
            margin-top: 10px;

            video {
                width: 100%;
            }
        }

    }

    .warning-container {
        margin-top: 15px;
        background-color: #fff;
        padding: 12px;

        .title {

            i {
                font-size: 20px;
                vertical-align: -0.125em;
            }

            span {
                margin-left: 4px;
                font-size: 15px;
            }
        }

        .content {
            margin-top: 12px;

            .event-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 0;

                &:not(:last-child) {
                    border-top: 1px solid #eff2f7;
                }

                .event-item-left {
                    width: 65%;

                    .event-date {
                        color: #909399;
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
                            color: #4d5869;
                        }
                    }
                }

                .event-item-right {
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
</style>