<template>
    <div class="player-container" v-loading="loading" element-loading-text="画面加载中">
        <video :id="containerId" :class="{ 'disabled': !showPointer }" controls muted autoplay playsinline></video>
    </div>
</template>

<script>
import mpegts from 'mpegts.js';
import { enabledStream } from "@/api/access";
import baseURL from "@/utils/request";
export default {
    components: {},
    props: {
        containerId: {
            type: String,
            required: true
        },
        streamId: {
            type: Number,
        },
        streamUrl: {
            type: String,
            required: true
        },
        showPointer: {
            type: Boolean,
            default: true
        }
    },
    data() {
        return {
            loading: false,
            player: null,
            isfirst: true,
            paused: true
        };
    },
    created() {

    },
    mounted() {

    },
    beforeDestroy() {
        this.destroyPlayer();
    },
    watch: {
        streamUrl: {
            handler(newVal) {
                if (newVal) {
                    if (this.streamId) {
                        try {
                            this.loading = true;
                            this.$emit("updateLoading", true);
                            enabledStream({ id: this.streamId }).then(res => {
                                if (res.code == 200) {
                                    this.initializePlayer();
                                }
                            })
                        } catch {
                            this.loading = true;
                        }
                    } else {
                        this.initializePlayer();
                    }
                }
            },
            immediate: true
        }
    },
    computed: {},
    methods: {
        initializePlayer() {
            if (mpegts.isSupported()) {
                const videoElement = document.getElementById(this.containerId);
                var cameraAddress = baseURL.split("/api")[0] + this.streamUrl;
                if (cameraAddress.indexOf("http") > -1) {
                    cameraAddress = "ws" + cameraAddress.split("http")[1];
                } else if (cameraAddress.indexOf("https") > -1) {
                    cameraAddress = "wss" + cameraAddress.split("https")[1];
                }
                // 根据协议类型创建不同的配置
                const config = cameraAddress.startsWith('ws')
                    ? {
                        type: 'mse',  // WebSocket需要MSE支持
                        isLive: true,
                        url: cameraAddress
                    }
                    : {
                        type: 'mpegts',  // HTTP-TS
                        isLive: true,
                        url: cameraAddress
                    };

                this.player = mpegts.createPlayer(config, {
                    enableWorker: false,
                    // enableStashBuffer: false, //最小延迟）进行实时流播放，请设置为 false
                    // lazyLoad: false,
                    lazyLoadMaxDuration: 60,
                    autoCleanupSourceBuffer: true, //对 SourceBuffer 执行自动清理
                });

                this.player.attachMediaElement(videoElement);
                this.player.load();
                this.player.play();

                // videoElement.addEventListener('play', () => {
                //     if (!this.isfirst) {
                //         const videoElement = document.getElementById(this.containerId);
                //         videoElement.currentTime = 0;
                //         this.player.load();
                //         this.$emit("pauseStream", this.streamId);
                //     }
                // });

                videoElement.addEventListener('loadedmetadata', () => {
                    this.loading = false;
                    this.$emit("drawMarkFrame");
                    this.$emit("updateLoading", false);
                    // if (this.isfirst) {
                    //     this.player.pause();
                    //     this.player.unload();
                    //     this.isfirst = false;
                    // }
                });

                // videoElement.addEventListener('pause', () => {
                //     if (!this.isfirst) {
                //         this.player.unload();
                //     }
                // });

                // videoElement.addEventListener('error', () => {
                //     console.error('Video error:', videoElement.error);
                // });

                // this.player.on(mpegts.Events.ERROR, (error) => {
                //     console.error('Player error:', error);
                // });
            } else {
                console.error("浏览器不支持");
            }
        },
        pausePlayer(streamId) {
            const videoElement = document.getElementById(this.containerId);
            //当前摄像头画面在播放，并且不是手动开启的摄像头画面
            if (!videoElement.paused && this.streamId !== streamId) {
                this.player.pause();
                this.player.unload();
            }
        },
        destroyPlayer() {
            if (this.player) {
                this.player.pause();
                this.player.unload();
                this.player.detachMediaElement();
                this.player.destroy();
                this.player = null;
                const videoElement = document.getElementById(this.containerId);
                videoElement.currentTime = 0;
            }
        },
    }
};
</script>
<style lang="scss" scoped>
.player-container {
    height: 100%;

    video {
        width: 100%;
        height: 100%;
        background-color: rgb(30, 30, 30);

        &.disabled {
            pointer-events: none;
        }
    }
}
</style>