<template>
    <div class="page">
        <div class="page-top">
            <div class="system-title">
                <div class="logo"><img src="@/assets/images/logo.png" alt=""></div>
                <div class="name">智能电网运维平台</div>
            </div>
            <!-- <div class="register-btn" v-if="loginType == 'account'">
                <el-button type="primary" size="medium">注册</el-button>
            </div> -->
        </div>
        <div class="page-main">
            <div class="left-box">
                <div class="center-box">
                    <div class="heading">智维电网，预见隐患——AI赋能，全时护航</div>
                    <div class="subheading">基于电网专属AI大模型，实现变电站/线路/设备实时监控与故障预警，精准识别异常状态，云边协同调度，自动警告异常，分析可能灾害，保障电网可靠运行</div>
                    <img class="center-images" src="@/assets/images/login_background.webp" alt="">
                </div>
            </div>
            <div class="right-box" :class="{ 'bg-gray': loginType == 'qrcode' }" v-loading="loading"
                element-loading-text="登录中">
                <div class="account-login" v-if="loginType == 'account'">
                    <div class="system-name">智能电网：AI大模型电网监控与运维系统</div>
                    <div class="login-form">
                        <el-form :model="form" :rules="rules" ref="loginForm">
                            <el-form-item label="账号" prop="username">
                                <el-input v-model="form.username" placeholder="请输入账号" size="medium"></el-input>
                            </el-form-item>
                            <el-form-item label="密码" prop="password">
                                <el-input v-model="form.password" placeholder="请输入密码" show-password
                                    auto-complete="new-password" size="medium"></el-input>
                            </el-form-item>
                        </el-form>
                        <el-button type="primary" class="login-btn" size="medium" @click="login">登录</el-button>
                        <!-- <div class="bottom-btns flex-between">
                            <el-button type="text" class="forgot-password"
                                style="margin-left: 0 !important;">忘记密码？</el-button>
                            <div class="weixin-login pointer" @click="changeLoginType(1)">
                                <i class="iconfont icon-weixin1"></i>
                                <span>微信登录</span>
                            </div>
                        </div> -->
                    </div>
                </div>
                <div class="qrcode-login" v-if="loginType == 'qrcode'">
                    <div class="login-title"><i class="iconfont icon-weixin1"></i>微信扫一扫登录</div>
                    <div class="qrcode-image-wrap">
                        <div class="qrcode-image" v-loading="qrcodeLoading" element-loading-text="二维码生成中">
                            <img :src="qrcodeUrl" alt="" v-if="qrcodeUrl">
                            <div class="qrcode-mark" v-if="qrcodeExpired">
                                <div class="refresh-icon"><i class="el-icon-refresh pointer" @click="getQrcode"></i>
                                </div>
                                <div class="invalid-tip">二维码已过期，点击刷新</div>
                            </div>
                        </div>
                    </div>
                    <div class="qrcode-desc">扫码成功后，点击“<span>关注公众号</span>”即可登录</div>
                    <div class="password-login pointer" @click="changeLoginType(2)">
                        <i class="el-icon-lock"></i>
                        <span>密码登录</span>
                    </div>
                </div>
                <div class="footer">{{ copyright }}</div>
            </div>
        </div>
    </div>
</template>

<script>
import { login, getWechatQrcode, checkWechartLogin } from "@/api/login.js";
export default {
    data() {
        return {
            copyright: "",
            loginType: "account",
            form: {
                username: "",
                password: ""
            },
            rules: {
                username: [
                    { required: true, message: '账号不能为空', trigger: 'blur' }
                ],
                password: [
                    { required: true, message: '密码不能为空', trigger: 'blur' }
                ],
            },
            loading: false,
            qrcodeUrl: "",
            qrcodeLoading: false,
            qrcodeExpired: false,
            timer: null,
            interval: null,
        }
    },
    created() {
        var date = new Date();
        var year = date.getFullYear();
        this.copyright = "@2014-" + year + " 思通数科(南京)信息技术有限公司 苏ICP备17066984号-1";

        //token在本地仍然存在直接跳转首页
        if (localStorage.getItem("Authorization")) {
            if (this.isMobileDevice()) {
                this.$router.replace({ path: "/app/index" });
            } else {
                this.$router.replace({ path: "/billboards" });
            }
        }
    },
    mounted() {
        var username = this.$route.query.username;
        var password = this.$route.query.password;
        if (username && password) {
            this.loading = true;
            var form = { userName: atob(decodeURIComponent(username)), userPwd: atob(decodeURIComponent(password)) };
            login(form).then(res => {
                // console.log(res)
                this.loading = false;
                if (res.code == 200) {
                    this.$message({
                        message: '登录成功',
                        type: 'success'
                    });
                    localStorage.setItem("Authorization", res.data.token);
                    localStorage.setItem("permissions", res.data.permissions);

                    if (this.isMobileDevice()) {
                        this.$router.replace({ path: "/app/index" });
                    } else {
                        this.$router.replace({ path: "/billboards" });
                    }
                }
            }).catch(() => {
                this.loading = false;
            })
        }
    },
    methods: {
        changeLoginType(type) {
            if (type == 1) {
                this.loginType = "qrcode";
                this.$nextTick(() => {
                    this.getQrcode();
                })
            } else {
                this.loginType = "account";
            }
        },
        login() {
            this.$refs["loginForm"].validate((valid) => {
                if (valid) {
                    this.loading = true;
                    var form = { userName: this.form.username, userPwd: this.form.password };
                    login(form).then(res => {
                        // console.log(res)
                        this.loading = false;
                        if (res.code == 200) {
                            this.$message({
                                message: '登录成功',
                                type: 'success'
                            });
                            localStorage.setItem("Authorization", res.data.token);
                            localStorage.setItem("permissions", res.data.permissions);

                            if (this.isMobileDevice()) {
                                this.$router.replace({ path: "/app/index" });
                            } else {
                                this.$router.replace({ path: "/billboards" });
                            }
                        }
                    }).catch(() => {
                        this.loading = false;
                    })
                }
            });
        },
        getQrcode() {
            this.qrcodeLoading = true;
            getWechatQrcode().then(res => {
                if (res.code == 200) {
                    if (this.loginType == "qrcode") {
                        this.qrcodeExpired = false;
                        this.qrcodeUrl = res.data.qrcodeUrl;

                        //每隔一秒判断是否扫码
                        this.interval = setInterval(() => {
                            this.judgeLogin(res.data.sceneStr);
                        }, 1000)

                        //5分钟后当前二维码过期
                        this.timer = setTimeout(() => {
                            clearInterval(this.interval);
                            this.qrcodeExpired = true;
                            this.qrcodeUrl = "";
                        }, 1000 * 60 * 5)
                    }
                }
            }).finally(() => {
                this.qrcodeLoading = false;
            })
        },
        judgeLogin(sceneStr) {
            checkWechartLogin({ sceneStr }).then(res => {
                if (res.code == 200) {
                    clearTimeout(this.timer);
                    clearInterval(this.interval);
                    this.$message({
                        message: '登录成功',
                        type: 'success'
                    });
                    localStorage.setItem("Authorization", res.data.token);
                    localStorage.setItem("permissions", res.data.permissions);
                    this.$router.replace({ path: "/billboards" });
                }
            })
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
.page {
    background-color: #fff;
    position: relative;

    .page-top {
        position: absolute;
        left: 0;
        top: 15px;
        width: 100%;
        height: 36px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 40px;
        box-sizing: border-box;
        z-index: 1;

        .system-title {
            display: flex;
            // align-items: center;

            .logo {
                height: 30px;

                img {
                    height: 100%;
                }
            }

            .name {
                font-size: 20px;
                font-weight: 600;
                line-height: 32px;
            }
        }
    }

    .page-main {
        display: flex;

        .left-box {
            width: 50%;
            height: 100vh;
            background-color: #f3f8ff;

            .center-box {
                width: 68vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                height: 100%;
                margin: 0 auto;

                .heading {
                    font-size: 24px;
                    margin-bottom: 24px;
                    text-align: left;
                    font-weight: 600;
                }

                .subheading {
                    font-size: 14px;
                    line-height: 24px;
                    margin-bottom: 12px;
                    text-align: left;
                    color: #656769;
                }

                .center-images {
                    width: 100%;
                }
            }
        }

        .right-box {
            width: 50%;
            height: 100vh;
            display: flex;
            justify-content: center;
            position: relative;

            .account-login {
                width: 65vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                height: 100%;
                margin: 0 auto;

                .system-name {
                    font-size: 20px;
                    font-weight: 500;
                    margin-bottom: 20px;
                    text-align: center;
                    letter-spacing: 1px;
                }

                .login-form {
                    padding: 0 5.5vw;

                    .el-form-item {
                        margin-bottom: 16px;
                    }

                    .weixin-login {
                        display: flex;
                        align-items: center;
                        color: #1ece29;
                        font-size: 14px;

                        i {
                            font-size: 20px;
                            margin-right: 3px;
                        }

                    }
                }


                .login-btn {
                    width: 100%;
                    margin-top: 20px;
                    margin-bottom: 5px;
                }

                .el-divider--horizontal {
                    margin: 12px 0;
                }

                .other-login {
                    padding: 0 5.5vw;

                    .change-login-text {
                        font-size: 14px;
                        color: #a7adc3;
                    }

                    .login-weixin {
                        width: 100%;
                        margin-top: 10px;
                    }
                }
            }

            .qrcode-login {
                width: 380px;
                border-radius: 12px;
                background: #fff;
                box-shadow: 0 3px 8px 0 rgba(0, 0, 0, 0.16);
                margin: auto;
                text-align: center;
                display: flex;
                flex-direction: column;
                justify-content: center;
                padding: 50px 15px;

                .login-title {
                    font-size: 20px;
                    line-height: 20px;
                    letter-spacing: 0.88px;
                    color: #212529;

                    i {
                        color: #1ece29;
                        margin-right: 8px;
                        font-size: 23px;
                        vertical-align: middle;
                    }
                }

                .login-sub-title {
                    margin-top: 20px;
                    font-size: 16px;
                    line-height: 17px;
                    letter-spacing: 0.75px;
                    color: #828282;
                }

                .qrcode-image-wrap {
                    position: relative;
                    width: 210px;
                    height: 210px;
                    margin: 15px auto;
                    color: #fff;
                    // background: #f4f4f4;
                    // padding: 10px;
                    // border: 1px solid #eee;
                    box-sizing: border-box;

                    .qrcode-image {
                        width: 100%;
                        height: 100%;

                        img {
                            width: 100%;
                            height: 100%;
                        }
                    }

                    .qrcode-mark {
                        width: 100%;
                        height: 100%;
                        display: flex;
                        flex-direction: column;
                        justify-content: center;
                        background: rgba(0, 0, 0, 0.75);
                        text-align: center;


                        i {
                            font-size: 40px;
                            margin-bottom: 10px;
                        }

                        .invalid-tip {
                            letter-spacing: 1px;
                        }
                    }

                }

                .qrcode-desc {

                    span {
                        color: #19ad1a;
                        font-weight: 600;
                    }
                }

                .password-login {
                    width: 228px;
                    margin: 50px auto 0;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    color: #128bed;
                    font-size: 15px;

                    i {
                        margin-right: 3px;
                    }
                }

            }



            .footer {
                width: 100%;
                bottom: 0;
                padding: 19px 15px 20px;
                position: absolute;
                right: 0;
                color: #6c757d;
                font-size: 16px;
                text-align: center;
            }
        }

        .bg-gray {
            background-color: #f2f3f5;
        }
    }
}

@media (max-width:767px) {
    .page {
        background-color: transparent;

        .page-top {
            padding: 12px 10px 0 10px;
            position: relative;
            top: 0;
            background-color: #f3f8ff;
        }

        .page-main {
            display: block;

            .left-box {
                width: 100%;
                height: auto;
                padding: 15px 22px 0 22px;
                box-sizing: border-box;

                .center-box {
                    width: auto;
                    display: block;

                    .heading {
                        font-size: 17px;
                        margin-bottom: 10px;
                    }

                    .subheading {
                        font-size: 13px;
                    }
                }
            }

            .right-box {
                width: 100%;
                height: auto;
                display: block;
                padding: 30px 15px;
                box-sizing: border-box;

                .account-login {
                    width: auto;

                    .system-name {
                        font-size: 16px;
                        margin-bottom: 10px;
                    }

                    .login-form {
                        padding: 0 20px;
                    }
                }

                .qrcode-login {
                    width: 100%;
                    padding: 25px 15px;
                    box-sizing: border-box;

                    .password-login {
                        margin-top: 20px;
                    }
                }

                .footer {
                    display: none;
                }
            }
        }
    }
}
</style>