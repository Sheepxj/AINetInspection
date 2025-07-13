<template>
    <div class="module">
        <div class="page-top-action">
            <div class="table-filter">
                <div class="filter-params">
                    <div class="filter-control">
                        <el-input v-model="params.keyword" prefix-icon="el-icon-search" size="small"
                            class="search-input" placeholder="请输入搜索内容" clearable
                            @keyup.enter.native="filterList"></el-input>
                    </div>
                </div>
                <div class="else-params">
                    <div class="filter-params">
                        <div class="filter-control">
                            <el-select v-model="params.alertLevel" placeholder="请选择告警级别" size="small"
                                @change="filterList">
                                <el-option v-for="(item, index) in alarmLevelList" :label="item.label"
                                    :value="item.value" :key="index"></el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="filter-params">
                        <div class="filter-control">
                            <el-date-picker v-model="params.dateRange" type="datetimerange" range-separator="至"
                                start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd HH:mm:ss"
                                size="small" :picker-options="pickerOptions" @change="filterList">
                            </el-date-picker>
                        </div>
                    </div>
                </div>
            </div>
            <div class="right-search">
                <el-button type="primary" icon="el-icon-plus" size="small" @click="createTask">添加任务</el-button>
                <!-- <div class="filter-icon" @click="controlFilter"><i class="iconfont icon-icon-test"></i></div> -->
            </div>
        </div>
        <div class="table" v-loading="loading">
            <el-table :data="tableData" stripe style="width: 100%" empty-text="">
                <!-- <el-table-column type="selection" width="55">
                    </el-table-column> -->
                <el-table-column prop="taskName" label="任务名称">
                    <template slot-scope="scope">
                        <div class="text-primary pointer" @click="viewDetail(scope.row)">
                            {{ scope.row.taskName }}
                        </div>
                    </template>
                </el-table-column>
                <!-- <el-table-column label="任务类型">
                        <template slot-scope="scope">
                            <div>目标检测</div>
                        </template>
                    </el-table-column> -->
                <el-table-column prop="cameraPosition" label="摄像头点位">
                </el-table-column>
                <el-table-column label="算法模型">
                    <template slot-scope="scope">
                        <div>{{ scope.row.aiModels.join("，") }}</div>
                    </template>
                </el-table-column>
                <el-table-column prop="status" label="任务状态" align="center">
                    <template slot-scope="scope">
                        <div class="badge badge-purple font-size-12" v-if="scope.row.status == 0">
                            未启动
                        </div>
                        <div class="badge badge-green font-size-12" v-else-if="scope.row.status == 1">
                            已启动
                        </div>
                        <div class="badge badge-orange font-size-12" v-else>
                            任务丢失
                        </div>
                    </template>
                </el-table-column>
                <el-table-column prop="alertLevel" label="告警级别" align="center">
                    <template slot-scope="scope">
                        <div class="badge badge-red" v-if="scope.row.alertLevel == '高'">高</div>
                        <div class="badge badge-orange" v-else-if="scope.row.alertLevel == '中'">中</div>
                        <div class="badge badge-purple" v-else>低</div>
                    </template>
                </el-table-column>
                <el-table-column prop="createTime" label="创建时间" align="center">
                    <template slot-scope="scope">
                        <div>{{ scope.row.createTime.slice(0, 16) }}</div>
                    </template>
                </el-table-column>
                <el-table-column label="操作" align="center" width="150">
                    <template slot-scope="scope">
                        <el-tooltip class="item" effect="light" content="编辑" placement="top">
                            <el-button type="text" icon="el-icon-edit" class="font-size-16"
                                :class="{ 'text-gray': scope.row.status == 1 }" :disabled="scope.row.status == 1"
                                @click="confirmEdit(scope.row)"></el-button>
                        </el-tooltip>
                        <el-tooltip class="item" effect="light" content="删除" placement="top">
                            <el-button type="text" icon="el-icon-delete" class="font-size-16"
                                :class="{ 'text-gray': scope.row.status == 1, 'text-red': scope.row.status == 0 || scope.row.status == 2 }"
                                :disabled="scope.row.status == 1" @click="confirmDelete(scope.row)"></el-button>
                        </el-tooltip>
                        <el-tooltip class="item" effect="light" content="启动" placement="top"
                            v-if="scope.row.status == 0">
                            <el-button type="text" icon="el-icon-video-play" class="text-green font-size-16"
                                @click="confirmPlay(scope.row)"></el-button>
                        </el-tooltip>
                        <el-tooltip class="item" effect="light" content="停用" placement="top"
                            v-if="scope.row.status == 1">
                            <el-button type="text" icon="el-icon-video-pause" class="text-orange font-size-16"
                                @click="confirmPause(scope.row)"></el-button>
                        </el-tooltip>
                    </template>
                </el-table-column>
                <template v-slot:empty>
                    <el-empty description="暂无数据"></el-empty>
                </template>
            </el-table>
            <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                :current-page="params.pageNum" :page-sizes="[10, 20, 30, 40, 50]" :page-size="params.pageSize"
                layout="total, prev, pager, next" :total="totalCount" v-if="tableData.length > 0">
            </el-pagination>
        </div>
        <el-dialog title="监测任务详情" :visible.sync="dialogVisible" width="65%" :close-on-click-modal="false"
            :close-on-press-escape="false">
            <div class="dialog-wrap">
                <div class="detail">
                    <div class="left-box">
                        <div class="result-item">
                            <span class="result-item-key">任务名称：</span>
                            <span class="result-item-value">{{ taskInfo.taskName }}</span>
                        </div>
                        <div class="result-item" v-if="taskInfo.taskDescription">
                            <span class="result-item-key">任务描述：</span>
                            <span class="result-item-value">{{ taskInfo.taskDescription }}
                            </span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">摄像头点位：</span>
                            <span class="result-item-value">{{ taskInfo.cameraPosition }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">视频抽帧级别：</span>
                            <span class="result-item-value">{{ taskInfo.frameInterval == 0 ? "不抽帧" :
                                taskInfo.frameInterval == 1 ? "低" : taskInfo.frameInterval == 2 ? "中" : "高" }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">检测类型：</span>
                            <span class="result-item-value">{{
                                taskInfo.frameSelect == 1 ? "默认" : taskInfo.frameSelect == 2 ? "闯入检测" : "离开检测" }}</span>
                        </div>
                        <div class="result-item">
                            <span class="result-item-key">算法模型：</span>
                            <span class="result-item-value">{{ taskInfo.aiModels }}</span>
                        </div>
                        <div class="result-item" v-if="taskInfo.frameSelect != 1">
                            <span class="result-item-key">预警目标数量：</span>
                            <span class="result-item-value">{{ taskInfo.targetNumber }}</span>
                        </div>
                        <div class="result-item" v-if="taskInfo.frameSelect == 2">
                            <span class="result-item-key">预警目标停留时长：</span>
                            <span class="result-item-value">{{ taskInfo.setTime }}</span>
                        </div>
                        <div class="result-item" v-if="taskInfo.frameSelect == 3">
                            <span class="result-item-key">预警目标离开时长：</span>
                            <span class="result-item-value">{{ taskInfo.setTime }}</span>
                        </div>
                    </div>
                    <div class="right-box">
                        <div class="title">摄像头监控画面</div>
                        <div class="camera-wrap">
                            <live-player containerId="video-live" :streamId="streamId"
                                :streamUrl="streamUrl"></live-player>
                        </div>
                    </div>
                </div>
            </div>
        </el-dialog>
    </div>
</template>

<script>
import { getTaskList, getTaskDetail, playTask, pauseTask, deleteTask } from "@/api/task/target";
import baseURL from "@/utils/request";
import livePlayer from "@/components/livePlayer.vue";
export default {
    components: { livePlayer },
    props: {},
    data() {
        return {
            loading: false,
            tableData: [],
            totalCount: 0,
            params: {
                keyword: "",
                pageNum: 1,
                pageSize: 10,
                detectType: "",
                alertLevel: "",
                dateRange: []
            },
            alarmLevelList: [
                {
                    label: "全部",
                    value: "全部"
                },
                {
                    label: "高",
                    value: "高"
                },
                {
                    label: "中",
                    value: "中"
                },
                {
                    label: "低",
                    value: "低"
                },
            ],
            pickerOptions: {
                disabledDate(time) {
                    return time.getTime() > Date.now() - 8.64e6
                },
                shortcuts: [
                    {
                        text: '过去 1 小时内',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000);
                            picker.$emit('pick', [start, end]);
                        }
                    },
                    {
                        text: '过去 24 小时内',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24);
                            picker.$emit('pick', [start, end]);
                        }
                    },
                    {
                        text: '过去 1 周内',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', [start, end]);
                        }
                    },
                    {
                        text: '过去 1 个月内',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
                            picker.$emit('pick', [start, end]);
                        }
                    },
                    {
                        text: '过去 3 个月内',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
                            picker.$emit('pick', [start, end]);
                        }
                    }
                ]
            },
            createDialogVisible: false,
            form: {
                detectType: ""
            },
            dialogVisible: false,
            taskInfo: {},
            drawerLoading: false,
            streamId: "",
            streamUrl: ""
        };
    },
    created() {
        this.getTaskList();
    },
    mounted() {

    },
    watch: {},
    computed: {},
    methods: {
        getTaskList() {
            this.loading = true;
            this.tableData = [];
            var params = { taskName: this.params.keyword, pageNum: this.params.pageNum, pageSize: this.params.pageSize, alertLevel: this.params.alertLevel, startTime: this.params.dateRange.length > 0 ? this.params.dateRange[0] : "", endTime: this.params.dateRange.length > 0 ? this.params.dateRange[1] : "" };
            getTaskList(params).then(res => {
                if (res.code == 200) {
                    this.tableData = res.data;
                    this.tableData.forEach(item => {
                        var models = [];
                        item.aiModels.forEach(model => {
                            models.push(model.modelName);
                        })
                        item.aiModels = models;
                    })
                    this.totalCount = res.count;
                }
            }).finally(() => {
                this.loading = false;
            })
        },
        filterList() {
            this.params.pageNum = 1;
            this.getTaskList();
        },
        createTask() {
            this.$router.push("/task/target/create");
        },
        confirmEdit(row) {
            this.$router.push({ path: "/task/target/create", query: { id: row.id, name: row.taskName } });
        },
        viewDetail(row) {
            this.loading = true;
            getTaskDetail({ Id: row.id }).then(res => {
                if (res.code == 200) {
                    this.dialogVisible = true;
                    this.taskInfo = res.data;
                    if (this.taskInfo.aiModels.length > 0) {
                        var models = [];
                        this.taskInfo.aiModels.forEach(item => {
                            models.push(item.modelName);
                        });
                        this.taskInfo.aiModels = models.join("，");
                    }

                    if (this.taskInfo.setTime) {
                        if (this.taskInfo.setTime <= 60) {
                            this.taskInfo.setTime = this.taskInfo.setTime + "秒钟";
                        } else if (this.taskInfo.setTime > 60 && this.taskInfo.setTime <= 3600) {
                            this.taskInfo.setTime = this.taskInfo.setTime / 60 + "分钟";
                        } else {
                            this.taskInfo.setTime = this.taskInfo.setTime / 3600 + "小时";
                        }
                    }

                    this.$nextTick(async () => {
                        var dialogWrapElement = document.querySelector(".dialog-wrap");
                        dialogWrapElement.scrollTo({
                            top: 0,
                        });

                        this.streamId = this.taskInfo.zlmId;
                        this.streamUrl = this.taskInfo.zlmUrl;
                    })

                }
            }).finally(() => {
                this.loading = false;
            })
        },
        confirmDelete(row) {
            this.$confirm('确定要删除该任务吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'info'
            }).then(() => {
                this.loading = true;
                deleteTask({ Id: row.id }).then(res => {
                    if (res.code == 200) {
                        this.$message({
                            type: 'success',
                            message: '删除成功！'
                        });
                        if (this.tableData.length == 1 && this.params.pageNum > 1) {
                            this.params.pageNum--;
                        }
                        this.getTaskList();
                    }
                }).catch(() => {
                    this.loading = false;
                })
            })
        },
        confirmPlay(row) {
            this.$confirm('确定要启动该任务吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'info'
            }).then(() => {
                this.loading = true;
                playTask({ Id: row.id }).then(res => {
                    if (res.code == 200) {
                        this.$message({
                            type: 'success',
                            message: '启动成功！'
                        });
                        this.getTaskList();
                    }
                }).catch(() => {
                    this.loading = false;
                })

            })
        },
        confirmPause(row) {
            this.$confirm('确定要停用该任务吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'info'
            }).then(() => {
                this.loading = true;
                pauseTask({ Id: row.id }).then(res => {
                    if (res.code == 200) {
                        this.$message({
                            type: 'success',
                            message: '关闭成功！'
                        });
                        this.getTaskList();
                    }
                }).catch(() => {
                    this.loading = false;
                })

            })
        },
        handleSizeChange(val) {
            // console.log(`每页 ${val} 条`);
            this.params.pageNum = 1;
            this.params.pageSize = val;
            this.getTaskList();
        },
        handleCurrentChange(val) {
            // console.log(`当前页: ${val}`);
            this.params.pageNum = val;
            this.getTaskList();
        },
    }
};
</script>
<style lang="scss" scoped>
.dialog-wrap {
    max-height: 55vh;
    // overflow: auto;
    padding: 0 10px;

    .detail {
        display: flex;
        justify-content: space-between;

        .left-box {
            width: 42%;
            padding: 12px 0;
            box-sizing: border-box;

            .result-item {

                &:not(:last-child) {
                    margin-bottom: 24px;
                }

                .result-item-key {
                    color: #a6a6a6;
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