<template>
    <div class="mobile-container">
        <div class="platform-name">思通数科AI视频卫士</div>
        <div class="platform-thumbnail">
            <img src="@/assets/images/platform_cover.png" alt="">
        </div>
        <div class="platform-experience-tip">请在电脑端浏览思通数科AI视频卫士</div>
        <div class="platform-experience-guide"><span style="color:#3372e4">aiv.stonedt.com</span> 体验更多专业功能</div>
    </div>
</template>

<script>
export default {
    components: {},
    props: {},
    data() {
        return {

        };
    },
    created() {

    },
    mounted() {
        // if (!this.isMobileDevice()) {
        //     if (localStorage.getItem("Authorization")) {
        //         this.$router.replace("/billboards");
        //     } else {
        //         this.$router.replace("/login");
        //     }
        // }
    },
    watch: {},
    computed: {},
    methods: {
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
.mobile-container {
    align-items: center;
    background-image: url("~@/assets/images/bg_cover.png");
    background-position: 50%;
    background-repeat: no-repeat;
    background-size: cover;
    display: flex;
    flex-direction: column;
    height: 100vh;
    padding: 13.33333vw 0;
    width: 100%;
    box-sizing: border-box;
    overflow: hidden;

    .platform-name {
        font-size: 6.33333vw;
        font-weight: bolder;
        padding: 0 7.46667vw;
        text-align: center;
        letter-spacing: 3px;
    }

    .platform-thumbnail img {
        margin: 16vw 0;
        width: 67.73333vw;
    }

    .platform-experience-tip {
        font-size: 5.33333vw;
        font-weight: bolder;
        /* padding: 0 7.46667vw; */
        text-align: center;
    }

    .platform-experience-guide {
        margin-top: 2.66667vw;
        font-size: 3.73333vw;
        font-weight: bolder;
        padding: 0 7.46667vw;
        text-align: center;
    }
}
</style>