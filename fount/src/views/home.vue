<template>
    <div id="page">
        <div id="header">
            <div class="header-left">
                <div class="logo-img"><img src="@/assets/images/logo.png" alt=""></div>
                <div class="system-name">智能电网运维平台</div>
            </div>
            <div class="header-right">
                <!-- <div class="open-community" @click="gotoGitee">
                    <i class="iconfont icon-gitee-fill-round"></i>
                    <span>开源社区</span>
                </div>
                <div class="novice-start" @click="viewGuideDoc">
                    <i class="iconfont icon-xingzhuang"></i>
                    <span>新手入门</span>
                </div> -->
                <div class="user-center" @click="gotoUserInfo">
                    <i class="el-icon-user"></i>
                    <span>个人中心</span>
                </div>
                <div class="logout" @click="logout">
                    <i class="el-icon-switch-button"></i>
                    <span>退出</span>
                </div>
            </div>
        </div>
        <div id="nav">
            <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal" @select="handleSelect">
                <el-menu-item index="1">
                    <template slot="title">
                        <i class="el-icon-s-data"></i>
                        <span>数据看板</span>
                    </template>
                </el-menu-item>
                <el-menu-item index="2">
                    <template slot="title">
                        <i class="el-icon-map-location"></i>
                        <span>监测任务</span>
                    </template>
                </el-menu-item>
                <el-menu-item index="3">
                    <template slot="title">
                        <i class="el-icon-bell"></i>
                        <span>事件告警</span>
                    </template>
                </el-menu-item>
                <el-menu-item index="4">
                    <template slot="title">
                        <i class="el-icon-coin"></i>
                        <span>视频接入</span>
                    </template>
                </el-menu-item>
                <el-menu-item index="5">
                    <template slot="title">
                        <i class="el-icon-menu"></i>
                        <span>算法管理</span>
                    </template>
                </el-menu-item>
            </el-menu>
        </div>
        <div id="main">
            <router-view></router-view>
            <div class="copyright">{{ copyright }}</div>
        </div>
    </div>
</template>

<script>
import { logout } from "@/api/login";
import baseURL from "@/utils/request";
export default {
    components: {},
    data() {
        return {
            activeIndex: "1",
            username: "",
            copyright: ""
        }
    },
    watch: {
        '$route.path': function (newPath) {
            this.keepActive();
        },
    },
    created() {
        this.username = localStorage.getItem("username");
        this.keepActive();
        window.addEventListener("popstate", this.keepActive, false);

        var date = new Date();
        var year = date.getFullYear();
        this.copyright = "@2014-" + year + " 西南交通大学";
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
    methods: {
        logout() {
            logout().then(res => {
                if (res.code == 200) {
                    this.$message({
                        message: '退出登录',
                        type: 'success'
                    });
                    localStorage.removeItem("Authorization");
                    localStorage.removeItem("permissions");
                    this.$router.replace({ path: "/login" });
                }
            })

        },
        keepActive() {
            let path = this.$route.path;
            if (path.indexOf("/billboards") > -1) {
                this.activeIndex = "1";
            } else if (path.indexOf("/task") > -1) {
                this.activeIndex = "2";
            } else if (path.indexOf("/warning") > -1) {
                this.activeIndex = "3";
            } else if (path.indexOf("/access") > -1) {
                this.activeIndex = "4";
            } else if (path.indexOf("/algorithm") > -1) {
                this.activeIndex = "5";
            } else {
                this.activeIndex = "";
            }
        },
        handleSelect(key, keyPath) {
            // console.log(key, keyPath);
            if (key == "1") {
                this.$router.push("/billboards");
            } else if (key == "2") {
                this.$router.push("/task");
            } else if (key == "3") {
                this.$router.push("/warning");
            } else if (key == "4") {
                this.$router.push("/access");
            } else if (key == "5") {
                this.$router.push("/algorithm");
            }
        },
        gotoGitee() {
            window.open("https://gitee.com/stonedtx/stonedtaiv");
        },
        viewGuideDoc() {
            window.open("https://docs.qq.com/doc/DQXZXcFFFU3lrcENY");
        },
        gotoUserInfo() {
            this.$router.push("/myself");
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
}
</script>
<style lang="scss" scoped>
#header {
    height: 70px;
    background: #252b3b;
    padding: 0 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-sizing: border-box;
    // box-shadow: 0 0.05rem 0.01rem rgba(75, 75, 90, 0.075);
    position: fixed;
    width: 100%;
    z-index: 1999;
    color: #fff;

    .header-left {
        display: flex;
        // align-items: center;

        .logo-img {
            height: 30px;

            img {
                height: 100%;
            }
        }

        .system-name {
            font-size: 20px;
            // font-weight: 600;
            line-height: 31px;
        }
    }

    .header-right {
        display: flex;
        align-items: center;

        div {
            display: flex;
            align-items: center;
            cursor: pointer;

            &:not(:last-child) {
                margin-right: 20px;
            }

            &:hover {
                color: #5664d2;
            }

            i {
                font-size: 20px;
                margin-right: 5px;
            }

            span {
                font-size: 14px;
            }
        }
    }
}

#nav {
    position: fixed;
    left: 0;
    top: 70px;
    width: 100%;
    height: 60px;
    background: #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, .08);
    z-index: 1999;

    .el-menu {
        // display: inline-block;
        // margin: 0 auto;
        padding: 0 20px;

        &.el-menu--horizontal {
            border: none;
        }

        .el-menu-item {
            height: 55px;
            line-height: 55px;
            padding: 0 5px 0 2px;

            &:not(:last-child) {
                margin-right: 40px;
            }

            &.is-active {
                color: #5664d2 !important;
                border-color: #5664d2;
                font-weight: 600;
            }

            &:hover i {
                color: #5664d2;
            }

            &:hover span {
                color: #5664d2;
            }

        }

        .el-submenu {
            margin-right: 40px;

            &.is-active {

                ::v-deep .el-submenu__title {
                    color: #5664d2 !important;
                    border-color: #5664d2;
                    font-weight: 600;

                    i {
                        color: #5664d2 !important;
                        font-weight: 600;
                    }
                }

            }

            ::v-deep .el-submenu__title {
                height: 55px;
                line-height: 55px;
                padding: 0 5px 0 2px;

                &:hover {

                    i,
                    span {
                        color: #5664d2;
                    }
                }
            }
        }


    }
}

.el-menu--horizontal .el-menu .el-menu-item {
    padding-left: 20px !important;
}

.el-menu--horizontal .el-menu .el-menu-item.is-active,
.el-menu--horizontal .el-menu .el-submenu.is-active>.el-submenu__title {
    color: #5664d2;
}


#main {
    margin-top: 130px;
}

.copyright {
    text-align: center;
    color: #6c757d;
    font-size: 15px;
    padding: 20px 15px;
}
</style>