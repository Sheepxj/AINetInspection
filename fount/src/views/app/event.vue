<template>
    <div class="app">
        <van-nav-bar title="预警事件详情" left-text="返回" left-arrow @click-left="onClickLeft" />
        <div class="mask" v-loading="loading">
            <div class="content">
                <p>您好！</p>
                <p>检测到在 {{ eventInfo.alertTime }} 存在异常活动，</p>
                <p>事件类型：<strong>{{ eventInfo.alertType }}</strong></p>
                <p>发生地点：<strong>{{ eventInfo.cameraPosition }}</strong></p>
                <p>风险等级：<strong>{{ eventInfo.alertLevel }}</strong></p>
                <p>事件截图：</p>
                <p><img :src="eventInfo.capturedImage" alt=""></p>
            </div>
        </div>
        <div class="bottom-action">
            <div class="prev" @click="viewPrevEvent">上一条</div>
            <div class="next" @click="viewNextEvent">下一条</div>
        </div>
    </div>
</template>

<script>
import { getWarningEvents, getWarningEventDetail } from "@/api/app";
import baseURL from "@/utils/request";
import livePlayer from "@/components/livePlayer.vue";
export default {
    components: { livePlayer },
    props: {},
    data() {
        return {
            loading: false,
            params: {
                pageNum: "",
                pageSize: "",
                searchText: "",
                alertTypes: [],
                cameraPosition: [],
                startTime: "",
                endTime: "",
            },
            eventList: [],
            eventId: "",
            eventInfo: {
                cameraPosition: "",
                alertType: "",
                alertLevel: "",
                alertTime: "",
                capturedImage: "",
                capturedVideo: ""
            },
            current: null
        };
    },
    created() {
        if (this.$route.query.id) {
            this.eventId = this.$route.query.id;
            // this.initLoading();
            this.getWarningEventDetail();
        }
    },
    mounted() {

    },
    watch: {},
    computed: {},
    methods: {
        onClickLeft() {
            this.$router.push("/app/index");
        },
        initLoading() {
            var requests = [getWarningEvents(this.params), getWarningEventDetail({ alertId: this.eventId })];
            this.loading = true;
            Promise.all(requests).then(results => {
                if (results[0].code == 200) {
                    this.eventList = results[0].data;
                    for (let index = 0; index < this.eventList.length; index++) {
                        if (this.eventList[index].alertId == this.eventId) {
                            this.current = index;
                        }
                    }
                }

                if (results[1].code == 200) {
                    this.eventInfo.cameraPosition = results[1].data.cameraPosition;
                    this.eventInfo.alertType = results[1].data.alertType;
                    this.eventInfo.alertLevel = results[1].data.alertLevel;
                    this.eventInfo.alertTime = results[1].data.alertTime;
                    this.eventInfo.capturedImage = baseURL.split("/api")[0] + results[1].data.capturedImage;
                    this.eventInfo.capturedVideo = baseURL.split("/api")[0] + results[1].data.capturedVideo;
                }
            }).finally(() => {
                this.loading = false;
            })
        },
        getWarningEventDetail() {
            this.loading = true;
            getWarningEventDetail({ alertId: this.eventId }).then(res => {
                if (res.code == 200) {
                    this.eventInfo.cameraPosition = res.data.cameraPosition;
                    this.eventInfo.alertType = res.data.alertType;
                    this.eventInfo.alertLevel = res.data.alertLevel;
                    this.eventInfo.alertTime = res.data.alertTime;
                    this.eventInfo.capturedImage = baseURL.split("/api")[0] + res.data.capturedImage;
                    this.eventInfo.capturedVideo = baseURL.split("/api")[0] + res.data.capturedVideo;
                }
            }).finally(() => {
                this.loading = false;
            })
        },
        viewPrevEvent() {
            if (this.current == 0) {
                this.$toast('当前已是第一条');
                return;
            }
            this.eventId = this.eventList[this.current - 1].alertId;
            this.getWarningEventDetail();
        },
        viewNextEvent() {
            if (this.current == this.eventList.length - 1) {
                this.$toast('当前已是最后一条');
                return;
            }
            this.eventId = this.eventList[this.current + 1].alertId;
            this.getWarningEventDetail();
        }
    }
};
</script>
<style lang="scss" scoped>
.app {
    background-color: #fff;
    height: 100%;
    min-height: 100vh;

    .van-nav-bar {
        position: fixed;
        left: 0;
        top: 0;
        width: 100%;
    }

    .mask {
        margin-top: 46px;
        padding: 25px 12px;

        .content {
            font-size: 15px;

            p {
                line-height: 36px;
            }

            img {
                max-width: 100%;
                object-fit: contain;
            }
        }
    }

    .bottom-action {
        position: fixed;
        left: 0;
        bottom: 0;
        width: 100%;
        display: flex;
        justify-content: space-between;
        padding: 8px 12px;
        box-sizing: border-box;
        border-top: 1px solid #ebedf0;

        div {
            padding: 4px 12px;
            cursor: pointer;
        }
    }
}
</style>