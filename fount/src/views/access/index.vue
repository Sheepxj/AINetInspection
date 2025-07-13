<template>
    <div class="container">
        <div class="main-wrapper flex-between">
            <div class="menu-list">
                <div class="menu-header flex-between">
                    <div class="header-left">设备列表</div>
                    <div class="header-right"><el-button type="text" @click="createDeviceGroup"><i
                                class="el-icon-plus icon-left"></i>添加分组</el-button></div>
                </div>
                <div class="menu-body">
                    <el-input placeholder="输入分组或点位进行过滤" v-model="filterText" size="small"></el-input>
                    <div class="menu-wrap" v-loading="loadingMenu">
                        <el-tree ref="tree" :data="treeData" :props="defaultProps" node-key="id"
                            :expand-on-click-node="false" :filter-node-method="filterNode" :highlight-current="true"
                            @node-click="nodeClick" empty-text="">
                            <span class="custom-tree-node father" slot-scope="{ node, data }">
                                <span class="node-label">
                                    <i class="iconfont icon-list font-size-14" v-if="data.children"></i>
                                    <i class="el-icon-video-camera" v-else></i>
                                    <span :title="node.label">{{ node.label }}</span>
                                    <span class="dot"
                                        :class="{ 'normal': data.cameraStatus == 1, 'abnormal': data.cameraStatus == 0 }"></span>
                                </span>
                                <span class="child" @click.stop>
                                    <el-dropdown trigger="click" size="small" @command="clickMore">
                                        <span class="el-dropdown-link">
                                            <el-button icon="el-icon-more" type="text" size="small" />
                                        </span>
                                        <el-dropdown-menu slot="dropdown">
                                            <el-dropdown-item icon="el-icon-edit-outline" v-if="data.children"
                                                :command="beforeClickMore('updateGroup', data, node)">
                                                编辑分组
                                            </el-dropdown-item>
                                            <el-dropdown-item icon="el-icon-delete" v-if="data.children"
                                                :command="beforeClickMore('deleteGroup', data, node)">
                                                删除分组
                                            </el-dropdown-item>
                                            <el-dropdown-item icon="el-icon-plus"
                                                :command="beforeClickMore('createDevice', data, node)"
                                                v-if="data.children">
                                                添加设备
                                            </el-dropdown-item>
                                            <el-dropdown-item icon="el-icon-edit-outline" v-if="!data.children"
                                                :command="beforeClickMore('updateDevice', data, node)">
                                                编辑设备
                                            </el-dropdown-item>
                                            <el-dropdown-item icon="el-icon-delete" v-if="!data.children"
                                                :command="beforeClickMore('deleteDevice', data, node)">
                                                删除设备
                                            </el-dropdown-item>
                                        </el-dropdown-menu>
                                    </el-dropdown>
                                </span>
                            </span>
                        </el-tree>
                        <el-empty description="暂无数据" v-if="treeData.length == 0"></el-empty>
                    </div>
                </div>
            </div>
            <div class="main-content">
                <div class="top-action flex-between">
                    <div class="left-action">
                        <div class="split-screen">
                            分屏：
                            <el-dropdown trigger="click" @command="handleCommand">
                                <span class="el-dropdown-link">
                                    {{ screenNumber }}<i class="el-icon-arrow-down el-icon--right"></i>
                                </span>
                                <el-dropdown-menu slot="dropdown">
                                    <el-dropdown-item command="16分屏">16分屏</el-dropdown-item>
                                    <el-dropdown-item command="9分屏">9分屏</el-dropdown-item>
                                    <el-dropdown-item command="4分屏">4分屏</el-dropdown-item>
                                </el-dropdown-menu>
                            </el-dropdown>
                        </div>
                    </div>
                    <div class="right-action">
                        <el-button type="primary" icon="el-icon-plus" size="mini" @click="createDevice">添加设备</el-button>
                    </div>
                </div>
                <div v-loading="loadingTable">
                    <div class="device-list">
                        <div class=" device-item"
                            :class="{ 'col-4': screenNumber == '16分屏', 'col-3': screenNumber == '9分屏', 'col-2': screenNumber == '4分屏' }"
                            v-for="(item, index) in renderDeviceList" :key="index">
                            <div class="device-wrap" :class="{ 'active': activeDeviceId == item.cameraId }">
                                <div class="device-video">
                                    <div class="device-info flex-between">
                                        <div class="left-box">
                                            <i class="el-icon-video-camera icon-left"></i>
                                            <span class="device-location">{{ item.cameraLocation }}</span>
                                            <span class="dot"
                                                :class="{ 'normal': item.cameraStatus == 1, 'abnormal': item.cameraStatus == 0 }"></span>
                                        </div>
                                        <div class="right-box">
                                            <span class="device-group">{{ item.groupName }}</span>
                                        </div>
                                    </div>
                                    <div class="video" v-show="item.cameraStatus == 1 && item.zlmId && item.zlmUrl">
                                        <live-player ref="camera-live" :containerId="'video-live-' + item.id"
                                            :streamId="item.zlmId" :streamUrl="item.zlmUrl"
                                            @pauseStream="pauseStream"></live-player>
                                    </div>
                                    <div class="screen-abnormal"
                                        v-show="item.cameraStatus != 1 || !item.zlmId || !item.zlmUrl">
                                        <el-empty
                                            :description="item.cameraStatus == 0 ? '监控设备失效，画面无法显示' : '暂无监控画面'"></el-empty>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="device-create"
                            :class="{ 'col-4': screenNumber == '16分屏', 'col-3': screenNumber == '9分屏', 'col-2': screenNumber == '4分屏' }"
                            v-if="screenNumber == '16分屏' ? totalCount < 16 : screenNumber == '9分屏' ? totalCount < 9 : totalCount < 4">
                            <div class="device-create-wrap">
                                <div class="create-icon">
                                    <i class="el-icon-plus" title="添加监控设备" @click="createDevice"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                        :current-page="params.pageNum" :page-sizes="[10, 20, 30, 40, 50]" :page-size="params.pageSize"
                        layout="total, prev, pager, next" :total="totalCount" v-if="renderDeviceList.length > 0">
                    </el-pagination>
                </div>
            </div>
        </div>
        <el-dialog :title="groupTitle" :visible.sync="groupDialogVisible" width="35%" :close-on-click-modal="false">
            <div class="dialog-wrap" v-loading="dialogLoading">
                <div class="groupForm">
                    <el-form :model="groupForm" ref="groupForm" label-position="left" label-width="100px"
                        class="demo-ruleForm">
                        <div class="form-group">
                            <el-form-item label="分组名称" prop="groupName"
                                :rules="[{ required: true, message: '分组名称不能为空', trigger: 'blur' }]">
                                <el-input v-model="groupForm.groupName" size="small" placeholder="请输入分组名称"
                                    maxlength="10" show-word-limit></el-input>
                            </el-form-item>
                        </div>
                    </el-form>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="groupDialogVisible = false" size="small">取 消</el-button>
                <el-button type="primary" @click="submitCreateGroup" size="small" :disabled="dialogLoading">确
                    定</el-button>
            </span>
        </el-dialog>
        <el-dialog class="form-dialog" :title="deviceTitle" :visible.sync="deviceDialogVisible" width="75%"
            :close-on-click-modal="false" :close-on-press-escape="false" :before-close="handleCloseDialog">
            <div class="dialog-wrap" v-loading="dialogLoading">
                <div class="left-box">
                    <el-form :model="deviceForm" :rules="rules" ref="deviceForm" label-position="left"
                        label-width="120px" class="demo-ruleForm">
                        <div class="form-group">
                            <el-form-item label="摄像头点位" prop="location">
                                <el-input v-model="deviceForm.location" size="small" placeholder="请输入摄像头点位，例：北区加油站"
                                    maxlength="15" show-word-limit></el-input>
                            </el-form-item>
                        </div>
                        <div class="form-group">
                            <el-form-item label="摄像头分组" prop="group">
                                <el-select v-model="deviceForm.group" size="small" placeholder="请选择摄像头分组"
                                    style="width: 100%;">
                                    <el-option v-for="(item, index) in cameraGroupList" :key="index" :label="item.label"
                                        :value="item.value"></el-option>
                                </el-select>
                            </el-form-item>
                        </div>
                        <!-- <div class="form-group">
                            <el-form-item label="视频协议" prop="protocol">
                                <el-select v-model="deviceForm.protocol" size="small" placeholder="请选择视频协议"
                                    style="width: 100%;">
                                    <el-option v-for="(item, index) in protocolList" :key="index" :label="item.label"
                                        :value="item.value"></el-option>
                                </el-select>
                            </el-form-item>
                        </div> -->
                        <div class="form-group">
                            <el-form-item label="视频流地址" prop="videoStreaming">
                                <el-input type="textarea" v-model="deviceForm.videoStreaming" rows="8"
                                    placeholder="请输入视频流地址" resize="none"></el-input>
                            </el-form-item>
                            <div class="video-streaming-prompt">例：rtsp://用户名:密码@ip地址:端口号/路径</div>
                        </div>
                    </el-form>
                </div>
                <div class="right-box">
                    <div class="title">摄像头监控画面</div>
                    <div class="camera-wrap">
                        <live-player ref="livePlayer" containerId="test-video-live"
                            :streamUrl="testStreamUrl"></live-player>
                    </div>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button type="success" plain @click="testConnect" size="small"
                    :disabled="dialogLoading">测试连接</el-button>
                <el-button type="primary" @click="submitCreateDevice" size="small" :disabled="dialogLoading">提
                    交</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import { createVideoDeviceGroup, deleteVideoDeviceGroup, updateVideoDeviceGroup, getVideoDevice, getVideoList, getVideoDeviceDetail, createVideoDevice, updateVideoDevice, getAllVideoDeviceGroup, deleteVideoDevice, previewCamera, getComputeNodes } from "@/api/access";
import baseURL from "@/utils/request";
import livePlayer from "@/components/livePlayer.vue";
export default {
    components: { livePlayer },
    props: {},
    data() {
        return {
            filterText: '',
            treeData: [],
            defaultProps: {
                children: 'children',
                label: 'label'
            },
            totalCount: 0,
            params: {
                gId: "",
                pageNum: 1,
                pageSize: 9
            },
            screenNumber: "9分屏",
            deviceList: [],
            renderDeviceList: [],
            activeDeviceId: null,
            loadingMenu: false,
            loadingTable: false,
            dialogLoading: false,
            groupTitle: "添加设备分组",
            groupDialogVisible: false,
            groupForm: {
                groupName: ""
            },
            checkedGroupId: null,
            deviceTitle: "添加监控设备",
            deviceDialogVisible: false,
            deviceForm: {
                location: "",
                group: "",
                // protocol: "",
                videoStreaming: "",
            },
            rules: {
                location: [
                    { required: true, message: '摄像头点位不能为空', trigger: 'blur' },
                ],
                group: [
                    { required: true, message: '摄像头分组不能为空', trigger: 'change' },
                ],
                // protocol: [
                //     { required: true, message: '协议类型不能为空', trigger: 'change' },
                // ],
                videoStreaming: [
                    { required: true, message: '视频流地址不能为空', trigger: 'blur' },
                ],
            },
            cameraGroupList: [],
            protocolList: [
                {
                    label: "RTSP",
                    value: "RTSP",
                },
                {
                    label: "RTMP",
                    value: "RTMP",
                },
                {
                    label: "ONVIF",
                    value: "ONVIF",
                },
                {
                    label: "GB28181",
                    value: "GB28181",
                },
                {
                    label: "HTTP/HTTPS ",
                    value: "HTTP/HTTPS ",
                },
            ],
            testStreamUrl: "",
        };
    },
    created() {
        this.getVideoDevice();
    },
    mounted() {

    },
    beforeDestroy() {

    },
    watch: {
        filterText(val) {
            this.$refs.tree.filter(val);
        }
    },
    computed: {

    },
    methods: {
        filterNode(value, data) {
            if (!value) return true;
            return data.label.indexOf(value) !== -1;
        },
        beforeClickMore(type, data, node) {
            // console.log(type, data, node)
            return {
                type: type,
                data: data,
                node: node,
            }
        },
        clickMore(params) {
            // console.log(params);
            switch (params.type) {
                case 'updateGroup':
                    this.confirmEditGroup(params.data);
                    break
                case 'deleteGroup':
                    this.confirmDeleteGroup(params.data);
                    break
                case 'createDevice':
                    this.createDevice(params.data);
                    break
                case 'updateDevice':
                    this.confirmEditDevice(params.data);
                    break
                case 'deleteDevice':
                    this.confirmDeleteDevice(params.data);
                    break

            }
        },
        //点击树形节点触发事件
        nodeClick(data, node) {
            // console.log(data, node)
            if (data.children) {
                this.activeDeviceId = "";
                this.params.gId = data.id;
                this.params.pageNum = 1;
                this.getVideoList();
            } else {
                this.activeDeviceId = data.cameraId;
                if (this.params.gId !== data.gId) {
                    this.params.gId = data.gId;
                    this.params.pageNum = 1;
                    this.getVideoList(data.id);
                } else {
                    this.totalCount = 1;
                    this.renderDeviceList = this.deviceList.filter(item => {
                        return item.id == data.id;
                    })
                }
            }
        },
        handleCommand(command) {
            if (command == "16分屏") {
                this.params.pageNum = 1;
                this.params.pageSize = 16;
            } else if (command == "9分屏") {
                this.params.pageNum = 1;
                this.params.pageSize = 9;

            } else if (command == "4分屏") {
                this.params.pageNum = 1;
                this.params.pageSize = 4;

            }
            this.screenNumber = command;
            this.renderDeviceList = this.deviceList.slice((this.params.pageNum - 1) * this.params.pageSize, this.params.pageNum * this.params.pageSize);
            this.$nextTick(() => {
                this.autoFitScreenRatio();
            })
        },
        autoFitScreenRatio() {
            //切换分屏后保证画面的比例始终是 4:3
            var screenElements = document.querySelectorAll(".device-video");
            if (screenElements.length > 0) {
                for (let i = 0; i < screenElements.length; i++) {
                    screenElements[i].style.height = JSON.stringify(screenElements[i].offsetWidth / 4 * 3) + "px";
                }
            }

            var createElement = document.querySelector(".device-create-wrap");
            if (createElement) {
                createElement.style.height = JSON.stringify(createElement.offsetWidth / 4 * 3) + "px";
            }
        },
        getVideoDevice() {
            this.loadingMenu = true;
            this.treeData = [];
            getVideoDevice().then(res => {
                if (res.code == 200) {
                    var deviceList = res.data;
                    if (deviceList.length > 0) {
                        deviceList.forEach(item => {
                            var obj = {};
                            obj.id = item.id;
                            obj.label = item.groupName;
                            obj.groupId = item.groupId;
                            var children = [];
                            if (item.cameras != undefined) {
                                item.cameras.forEach(child => {
                                    children.push({ id: child.id, label: child.cameraLocation, cameraId: child.cameraId, videoStreaming: child.videoStreaming, cameraStatus: child.cameraStatus, gId: item.id });
                                })
                            }
                            obj.children = children;
                            this.treeData.push(obj);
                        })
                        this.getVideoList();
                        // this.$nextTick(() => {
                        //     // 手动触发一次节点的高亮
                        //     this.$refs.tree.setCurrentKey(this.treeData[0].id);
                        // })
                    }
                }
                this.$nextTick(() => {
                    this.autoFitScreenRatio();
                })
            }).finally(() => {
                this.loadingMenu = false;
            })
        },
        getVideoList(cameraId) {
            this.loadingTable = true;
            this.deviceList = [];
            getVideoList({ gId: this.params.gId }).then(res => {
                if (res.code == 200) {
                    this.totalCount = res.count;
                    this.deviceList = res.data;
                    this.deviceList.forEach(item => {
                        if (item.cameraImg) {
                            item.cameraImg = baseURL.split("/api")[0] + item.cameraImg;
                        }

                    })
                    if (cameraId) {
                        this.totalCount = 1;
                        this.renderDeviceList = this.deviceList.filter(item => {
                            return item.id == cameraId;
                        })
                    } else {
                        this.renderDeviceList = this.deviceList.slice((this.params.pageNum - 1) * this.params.pageSize, this.params.pageNum * this.params.pageSize);
                    }
                    this.$nextTick(() => {
                        this.autoFitScreenRatio();
                    })
                }
            }).finally(() => {
                this.loadingTable = false;
            })
        },
        pauseStream(streamId) {
            //所有摄像头画面中只播放当前正在查看的
            var videos = this.$refs["camera-live"];
            for (let index = 0; index < videos.length; index++) {
                videos[index].pausePlayer(streamId);
            }
        },
        createDeviceGroup() {
            this.groupForm = {
                groupName: ""
            };
            if (this.$refs.groupForm !== undefined) {
                this.$refs.groupForm.resetFields();
            }
            this.groupTitle = "添加设备分组";
            this.groupDialogVisible = true;
        },
        confirmEditGroup(row) {
            this.groupForm = {
                groupName: ""
            };
            if (this.$refs.groupForm !== undefined) {
                this.$refs.groupForm.resetFields();
            }
            this.checkedGroupId = row.groupId;
            this.groupTitle = "编辑设备分组";

            this.groupForm.groupName = row.label;
            this.groupDialogVisible = true;
        },
        submitCreateGroup() {
            this.$refs["groupForm"].validate((valid) => {
                if (valid) {
                    this.dialogLoading = true;
                    if (this.groupTitle == "添加设备分组") {
                        createVideoDeviceGroup(this.groupForm).then(res => {
                            if (res.code == 200) {
                                this.$message({
                                    message: '添加成功',
                                    type: 'success'
                                });
                                this.groupDialogVisible = false;
                                this.getVideoDevice();
                            }
                        }).finally(() => {
                            this.dialogLoading = false;
                        })
                    } else {
                        var form = { groupId: this.checkedGroupId, groupName: this.groupForm.groupName };
                        updateVideoDeviceGroup(form).then(res => {
                            if (res.code == 200) {
                                this.$message({
                                    message: '修改成功',
                                    type: 'success'
                                });
                                this.groupDialogVisible = false;
                                this.getVideoDevice();
                            }
                        }).finally(() => {
                            this.dialogLoading = false;
                        })
                    }

                }
            });
        },
        confirmDeleteGroup(row) {
            this.$confirm('确定要删除该分组吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'info'
            }).then(() => {
                this.loadingMenu = true;
                deleteVideoDeviceGroup({ groupId: row.groupId }).then(res => {
                    if (res.code == 200) {
                        this.$message({
                            type: 'success',
                            message: '删除成功!'
                        });
                        this.getVideoDevice();
                    }
                }).catch(() => {
                    this.loadingMenu = false;
                })
            })
        },
        async createDevice() {
            this.deviceForm = {
                location: "",
                group: "",
                videoStreaming: ""
            };
            if (this.$refs.deviceForm !== undefined) {
                this.$refs.deviceForm.resetFields();
            }
            this.deviceTitle = "添加监控设备";
            this.loadingTable = true;
            this.cameraGroupList = [];

            var requests = [getAllVideoDeviceGroup()];
            Promise.all(requests).then(results => {
                this.deviceDialogVisible = true;
                this.$nextTick(() => {
                    var dialogWrapElement = document.querySelector(".form-dialog .dialog-wrap");
                    dialogWrapElement.scrollTo({
                        top: 0,
                    });
                });
                if (results[0].code == 200) {
                    if (results[0].data.length > 0) {
                        results[0].data.forEach(item => {
                            this.cameraGroupList.push({ label: item.groupName, value: item.id })
                        })
                    }
                }
            }).finally(() => {
                this.loadingTable = false;
            })
        },
        confirmEditDevice(row) {
            this.deviceForm = {
                location: "",
                group: "",
                videoStreaming: ""
            };
            if (this.$refs.deviceForm !== undefined) {
                this.$refs.deviceForm.resetFields();
            }
            this.checkedDeviceId = row.cameraId;
            this.deviceTitle = "编辑监控设备";
            this.loadingTable = true;
            this.cameraGroupList = [];

            var requests = [getAllVideoDeviceGroup(), getVideoDeviceDetail({ cameraId: row.cameraId })];
            Promise.all(requests).then(results => {
                this.deviceDialogVisible = true;
                this.$nextTick(() => {
                    var dialogWrapElement = document.querySelector(".form-dialog .dialog-wrap");
                    dialogWrapElement.scrollTo({
                        top: 0,
                    });
                });
                if (results[0].code == 200) {
                    if (results[0].data.length > 0) {
                        results[0].data.forEach(item => {
                            this.cameraGroupList.push({ label: item.groupName, value: item.id })
                        })
                    }
                }

                if (results[1].code == 200) {
                    if (Object.keys(results[1].data).length > 0) {
                        this.deviceForm.location = results[1].data.cameraLocation;
                        this.cameraGroupList.forEach(item => {
                            if (results[1].data.groupName == item.label) {
                                this.deviceForm.group = item.value;
                            }
                        })
                        this.deviceForm.videoStreaming = results[1].data.videoStreaming;
                    }
                }
            }).finally(() => {
                this.loadingTable = false;
            })
        },
        //测试填写的参数是否可以连接摄像头
        testConnect() {
            this.$refs["deviceForm"].validate((valid) => {
                if (valid) {
                    this.dialogLoading = true;
                    previewCamera({ videostream: this.deviceForm.videoStreaming }).then(res => {
                        if (res.code == 200) {
                            this.testStreamUrl = res.data;
                        }
                    }).finally(() => {
                        this.dialogLoading = false;
                    })
                }
            });
        },
        submitCreateDevice() {
            this.$refs["deviceForm"].validate((valid) => {
                if (valid) {
                    this.dialogLoading = true;
                    var form = { cameraLocation: this.deviceForm.location, cameraGroup: this.deviceForm.group, typeInput: 1, videoStreaming: this.deviceForm.videoStreaming };

                    if (this.deviceTitle == "添加监控设备") {
                        createVideoDevice(form).then(res => {
                            if (res.code == 200) {
                                this.$message({
                                    message: '添加成功',
                                    type: 'success'
                                });
                                this.getVideoDevice();
                                this.deviceDialogVisible = false;
                                this.testStreamUrl = "";
                                this.$refs.livePlayer.destroyPlayer();
                            }

                        }).finally(() => {
                            this.dialogLoading = false;
                        })
                    } else {
                        form.cameraId = this.checkedDeviceId;
                        updateVideoDevice(form).then(res => {
                            if (res.code == 200) {
                                this.$message({
                                    message: '修改成功',
                                    type: 'success'
                                });
                                this.getVideoDevice();
                                this.deviceDialogVisible = false;
                                this.testStreamUrl = "";
                                this.$refs.livePlayer.destroyPlayer();
                            }

                        }).finally(() => {
                            this.dialogLoading = false;
                        })
                    }
                }
            });
        },
        handleCloseDialog() {
            this.deviceDialogVisible = false;
            this.testStreamUrl = "";
            this.$refs.livePlayer.destroyPlayer();
        },
        confirmDeleteDevice(row) {
            this.$confirm('确定要删除该设备吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'info'
            }).then(() => {
                this.loadingTable = true;
                deleteVideoDevice({ cameraId: row.cameraId }).then(res => {
                    if (res.code == 200) {
                        this.$message({
                            type: 'success',
                            message: '删除成功!'
                        });
                        if (this.deviceList.length == 1 && this.params.pageNum > 1) {
                            this.params.pageNum--;
                        }
                        this.getVideoDevice();
                    }
                }).finally(() => {
                    this.loadingTable = false;
                })
            })
        },
        handleSizeChange(val) {
            // console.log(`每页 ${val} 条`);
            this.params.pageNum = 1;
            this.params.pageSize = val;
            this.getVideoList();
        },
        handleCurrentChange(val) {
            // console.log(`当前页: ${val}`);
            this.params.pageNum = val;
            this.renderDeviceList = this.deviceList.slice((this.params.pageNum - 1) * this.params.pageSize, this.params.pageNum * this.params.pageSize);
        },
    }
};
</script>
<style lang="scss" scoped>
canvas {
    background-color: #000;
    object-fit: fill;
}

.menu-list {
    width: 255px;
    height: calc(100vh - 160px);
    background-color: #fff;
    border-radius: 4px;
    position: fixed;
    left: 20px;
    top: 150px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;

    .menu-header {
        height: 40px;
        line-height: 40px;
        padding: 0 12px;
        font-size: 16px;
        font-weight: 600;
        color: #606266;
        border-bottom: 1px solid #eff2f7;
    }

    .menu-body {
        padding: 15px 20px;
        flex: 1;
        overflow: hidden;
        box-sizing: border-box;

        .menu-wrap {
            height: calc(100% - 50px);
            margin-top: 10px;
            overflow: auto;

            ::v-deep .el-tree-node__content {
                height: 33px;
            }

            .father {
                padding: 0 8px;
                flex: 1;
                display: flex;
                align-items: center;
                -webkit-box-pack: justify;
                -ms-flex-pack: justify;
                justify-content: space-between;
                font-size: 14px;

                &:hover .child {
                    visibility: visible;
                }

                .node-label {
                    display: flex;
                    align-items: center;
                    flex: 1 1 0%;
                    width: 0px;
                    margin-right: 5px;

                    span {
                        width: calc(100% - 15px);
                        margin-left: 6px;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .dot {
                        display: inline-block;
                        width: 5px;
                        height: 5px;
                        border-radius: 50%;
                        margin-left: 5px;


                        &.normal {
                            background-color: #1cbb8c;
                        }

                        &.abnormal {
                            background-color: #ff3d60;
                        }
                    }
                }

                .child {
                    width: 35px;
                    visibility: hidden;

                }
            }


        }
    }
}

.main-content {
    flex: 1;
    margin-left: 270px;
    background-color: #fff;
    // min-height: calc(100vh - 160px);
    min-height: 420px;
    padding-bottom: 20px;
    box-sizing: border-box;
    overflow-x: hidden;

    .top-action {
        height: 40px;
        line-height: 40px;
        padding: 0 12px;
        font-size: 14px;
        border-bottom: 1px solid #eff2f7;

        .el-dropdown-link {
            cursor: pointer;
            color: #5664d2;
        }

        .el-icon-arrow-down {
            font-size: 12px;
        }

        .right-action {

            .el-button {
                padding: 7px;
            }
        }
    }

    .device-list {
        display: flex;
        flex-wrap: wrap;
        padding: 7px;

        .device-item,
        .device-create {
            padding: 5px;
            box-sizing: border-box;

            &.col-3 {
                width: 33.33%;
            }

            &.col-4 {
                width: 25%;
            }

            &.col-2 {
                width: 50%;
            }

            .device-wrap {
                height: 100%;
                // border: 1px solid #ebebeb;
                // padding: 5px;
                box-sizing: border-box;

                &.active {
                    outline: 4px solid #5664d2;
                }

                .device-video {
                    position: relative;
                    height: 100%;

                    .device-info {
                        width: 100%;
                        height: 26px;
                        line-height: 26px;
                        position: absolute;
                        left: 0;
                        top: 0;
                        font-size: 14px;
                        padding: 0 5px;
                        box-sizing: border-box;
                        color: #fff;
                        background-color: rgba(0, 0, 0, .6);

                        .left-box {
                            display: flex;
                            align-items: center;

                            i {
                                font-size: 16px;
                            }

                            .dot {
                                display: inline-block;
                                width: 5px;
                                height: 5px;
                                border-radius: 50%;
                                margin-left: 5px;


                                &.normal {
                                    background-color: #1cbb8c;
                                }

                                &.abnormal {
                                    background-color: #ff3d60;
                                }
                            }

                        }


                    }

                    .video {
                        height: 100%;
                    }

                    .screen-abnormal {
                        height: 100%;
                        background-color: rgba(0, 0, 0, .2);
                        display: flex;
                        justify-content: center;
                        align-items: center;

                        ::v-deep .el-empty__image {
                            width: 140px;
                        }

                        ::v-deep .el-empty__description p {
                            color: #f4f5f7;
                            letter-spacing: 1px;
                        }
                    }
                }
            }

            .device-create-wrap {
                height: 290px;
                box-sizing: border-box;
                background-color: #f5f6fa;
                display: flex;
                justify-content: center;
                align-items: center;

                i {
                    font-size: 50px;
                    color: #5664d2;
                    cursor: pointer;
                }
            }
        }
    }

    .el-pagination {
        margin-top: 15px;
    }
}

.dialog-wrap {
    padding: 0 10px;
    max-height: 53vh;
    overflow: auto;
    display: flex;
    justify-content: space-between;

    .groupForm {
        width: 80%;
        margin: 0 auto;
    }

    .left-box {
        width: 50%;
        padding: 0 20px;
        box-sizing: border-box;
        overflow-y: auto;

        .el-cascader {
            width: 100%;
        }

        .el-divider--horizontal {
            margin-left: -25px;
            width: calc(100% + 35px);
        }
    }

    .right-box {
        width: calc(50% - 20px);
        margin-left: 20px;
        box-sizing: border-box;
        display: flex;
        flex-direction: column;

        .title {
            color: #1b1e26;
            font-size: 15px;
            margin-bottom: 6px;
        }

        .camera-wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            flex: 1;
        }
    }

    .video-streaming-prompt {
        font-size: 14px;
        color: #999;
        margin-left: 120px;
    }
}
</style>