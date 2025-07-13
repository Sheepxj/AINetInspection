<template>
    <div class="container">
        <div class="page-breadcrumb">
            <div class="page-title" style="color: #303133;font-weight: 700;margin-bottom: 12px;">个人中心</div>
        </div>
        <div class="main-wrapper card" v-loading="loading">
            <div class="part">
                <div class="header">
                    <div class="title">基本信息</div>
                </div>
                <div class="body">
                    <div class="item">
                        <span class="item-key">用户：</span>
                        <span class="item-value">{{ userInfo.username }}</span>
                    </div>
                    <div class="item">
                        <span class="item-key">密码：</span>
                        <span class="item-value">
                            <span class="text-primary pointer" @click="updatePassword">修改</span>
                        </span>
                    </div>
                    <div class="item">
                        <span class="item-key">角色：</span>
                        <span class="item-value">{{ userInfo.role }}</span>
                    </div>
                    <div class="item">
                        <span class="item-key">注册时间：</span>
                        <span class="item-value">{{ userInfo.createTime }}</span>
                    </div>
                </div>
            </div>
        </div>
        <el-dialog title="修改密码" :visible.sync="dialogVisible" width="35%">
            <div class="dialog-wrap" v-loading="dialogLoading">
                <el-form :model="ruleForm" :rules="rules" ref="ruleForm" label-width="90px" class="demo-ruleForm">
                    <el-form-item label="旧的密码" prop="oldPass">
                        <el-input v-model="ruleForm.oldPass" autocomplete="off" placeholder="请输入旧的密码" size="small"
                            show-password></el-input>
                    </el-form-item>
                    <el-form-item label="新的密码" prop="pass">
                        <el-input v-model="ruleForm.pass" autocomplete="off" placeholder="请输入新的的密码" size="small"
                            show-password></el-input>
                    </el-form-item>
                    <el-form-item label="确认密码" prop="checkPass">
                        <el-input v-model="ruleForm.checkPass" autocomplete="off" placeholder="请再次输入新的密码" size="small"
                            show-password></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false" size="small">取 消</el-button>
                <el-button type="primary" @click="submitForm" size="small" :disabled="dialogLoading">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import { getUserInfo, changePassword } from "@/api/login";
export default {
    components: {},
    props: {},
    data() {
        return {
            loading: false,
            userInfo: {
                username: "admin",
                password: "Stonedt,123",
                role: "管理员",
                createTime: "2024-10-31 09:40:12",
            },
            dialogVisible: false,
            ruleForm: {
                oldPass: "",
                pass: "",
                checkPass: ""
            },
            rules: {
                oldPass: [
                    { required: true, message: '请输入旧的密码', trigger: 'blur' },
                ],
                pass: [
                    { required: true, message: '请输入新的密码', trigger: 'blur' },
                    { min: 6, message: '密码不能少于六位数', trigger: 'blur' },
                    { validator: this.validatePass, trigger: 'blur' }
                ],
                checkPass: [
                    { required: true, message: '请再次输入新的密码', trigger: 'blur' },
                    { validator: this.validatePass2, trigger: 'blur' }
                ],
            },
            dialogLoading: false
        };
    },
    created() {
        this.getUserInfo();
    },
    mounted() {

    },
    watch: {},
    computed: {},
    methods: {
        getUserInfo() {
            this.loading = true;
            getUserInfo().then(res => {
                if (res.code == 200) {

                }
            }).finally(() => {
                this.loading = false;
            })
        },
        updatePassword() {
            this.dialogVisible = true;
            this.$nextTick(() => {
                if (this.$refs.ruleForm !== undefined) {
                    this.$refs.ruleForm.resetFields();
                }
            })
        },
        submitForm() {
            this.$refs["ruleForm"].validate((valid) => {
                if (valid) {
                    this.dialogLoading = true;
                    var form = { oldPassword: this.ruleForm.oldPass, newPassword: this.ruleForm.pass };
                    changePassword(form).then(res => {
                        if (res.code == 200) {
                            this.dialogVisible = false;
                            this.$message({
                                message: '密码修改成功，请重新登录',
                                type: 'success'
                            });
                            setTimeout(() => {
                                localStorage.removeItem("Authorization");
                                localStorage.removeItem("permissions");
                                this.$router.replace({ path: "/login" });
                            }, 2000);
                        }
                    }).finally(() => {
                        this.dialogLoading = false;
                    })
                }
            });
        },
        validatePass(rule, value, callback) {
            if (value === '') {
                callback(new Error('请输入新的密码'));
            } else {
                if (this.ruleForm.checkPass !== '') {
                    this.$refs.ruleForm.validateField('checkPass');
                }
                callback();
            }
        },
        validatePass2(rule, value, callback) {
            if (value === '') {
                callback(new Error('请再次输入新的密码'));
            } else if (value !== this.ruleForm.pass) {
                callback(new Error('两次输入密码不一致!'));
            } else {
                callback();
            }
        }
    }
};
</script>
<style lang="scss" scoped>
.part {

    .header {
        border-bottom: 1px solid #f6f6f7;
        padding-bottom: 8px;

        .title {
            font-weight: 600;
            font-size: 16px;
            color: rgba(0, 0, 0, .85);
        }
    }

    .body {

        .item {
            margin-top: 12px;
            font-size: 15px;
        }
    }
}
</style>