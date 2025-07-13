<template>
    <div class="container">
        <div class="main-wrapper card" v-loading="loading">
            <div class="filter-params">
                <div class="filter-control">
                    <el-input v-model="params.keyword" prefix-icon="el-icon-search" size="medium" class="search-input"
                        placeholder="搜索算法" clearable @keyup.enter.native="filterList"></el-input>
                </div>
            </div>
            <div class="filter-container" v-if="!isfirst && (activeDetectType == '全部' || activeDetectType == '目标检测')">
                <div class="filter-options" :class="{ 'hidden': this.sceneContainerHeight > 88 && !isShowMore }">
                    <div class="option" :class="{ 'atv-option': activeScene == '全部' }" @click="filterScene('全部')">全部
                    </div>
                    <div class="option" v-for="(item, index) in sceneList" :key="index"
                        :class="{ 'atv-option': activeScene == item.modelType }" @click="filterScene(item.modelType)">{{
                            item.modelType
                        }}</div>
                </div>
                <div class="option-action text-primary pointer" @click="showMoreScene"
                    v-if="this.sceneContainerHeight > 88 && !isShowMore">更多</div>
                <div class="option-action text-primary pointer" @click="hiddenScene"
                    v-if="this.sceneContainerHeight > 88 && isShowMore">收起
                </div>
            </div>
            <div class="list-action flex-between">
                <div class="list-total">为您找到相关算法<span class="total-count">{{ totalCount }}</span>个</div>
                <div class="right-button">
                    <!-- <el-button type="primary" icon="el-icon-upload2" size="small"
                        @click="createAlgorithm">导入模型</el-button> -->
                </div>
            </div>
            <div class="algorithm-list" v-loading="loadingList">
                <div class="algorithm-card" v-for="(item, index) in renderAlgorithm" :key="index"
                    @click.stop="viewDetail(item)">
                    <div class="thumbnail">
                        <!-- <img :src="item.imgs" alt=""> -->
                        <el-image :src="item.imgs" lazy draggable="false"></el-image>
                    </div>
                    <div class="name">{{ item.modelName }}</div>
                    <div class="scene">{{ /,/.test(item.scene) ? item.scene.replace(/,/g, "&nbsp;&nbsp;") : item.scene
                    }}
                    </div>
                    <div class="desciription" :title="item.modelExplain">{{ item.modelExplain }}</div>
                    <div class="source" v-if="item.aiModel.modelSource">
                        <el-tag type="info" size="mini" v-if="item.aiModel.modelSource == 0">系统默认</el-tag>
                        <el-tag size="mini" v-else>用户上传</el-tag>
                    </div>
                    <div class="action" v-if="item.aiModel.modelSource && item.aiModel.modelSource == 1">
                        <div class="status"></div>
                        <div class="more">
                            <el-dropdown size="small" @command="handleCommand($event, item)">
                                <span class="el-dropdown-link">
                                    更多<i class="el-icon-arrow-down el-icon--right"></i>
                                </span>
                                <el-dropdown-menu slot="dropdown">
                                    <el-dropdown-item command="delete">
                                        <i class="el-icon-delete"></i>卸载
                                    </el-dropdown-item>
                                </el-dropdown-menu>
                            </el-dropdown>
                        </div>
                    </div>
                </div>
                <el-empty description="暂无数据" style="margin: 0 auto 60px;" v-if="renderAlgorithm.length == 0"></el-empty>
                <!-- <div class="finally-tip" v-if="!loading">
                    <div class="finally-tip-text">已经到最后啦！没有找到想要的算法？您提需求，我来补充！</div>
                    <el-button type="primary" size="small" @click="toMoreAlgorithm">我想要新算法</el-button>
                </div> -->
            </div>
        </div>
        <el-dialog title="导入模型" :visible.sync="uploadDialogVisible" width="40%" :close-on-click-modal="false">
            <div class="dialog-wrap" v-loading="dialogLoading">
                <el-upload class="upload-demo" drag action="" accept=".zip" :auto-upload="false" :file-list="fileList"
                    :limit="1" :on-change="handleFileChange" :on-remove="handleRemoveFile">
                    <i class="el-icon-upload"></i>
                    <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                    <div class="el-upload__tip" slot="tip">只能上传zip文件，一次性只能上传一个且不超过100M</div>
                </el-upload>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="uploadDialogVisible = false" size="small">取 消</el-button>
                <el-button type="primary" @click="submitCreate" size="small" :disabled="dialogLoading">确 定</el-button>
            </span>
        </el-dialog>
        <el-dialog title="我想要新算法" :visible.sync="demandDialogVisible" width="38%" :close-on-click-modal="false">
            <div class="demand-wrap">
                <div class="title">专注视觉 AI 算法定制</div>
                <div class="sub-title">1000+种 AI 场景落地经验</div>
                <div class="sub-title">最快 8 小时生产一个全新算法</div>
                <div class="qrcode">
                    <img src="@/assets/images/wxcode.jpg" alt="">
                </div>
            </div>
        </el-dialog>
    </div>

</template>

<script>
import { getSceneList, getAlgorithmList, getAlgorithDetail, exportAlgorithModel, unloadModel } from "@/api/algorithm";
import baseURL from "@/utils/request";
export default {
    components: {},
    props: {},
    data() {
        return {
            loading: false,
            isfirst: true,
            loadingList: false,
            params: {
                scene: "",
                keyword: ""
            },
            activeDetectType: "全部",
            sceneList: [],
            activeScene: "全部",
            sceneContainerHeight: 0,
            isShowMore: false,
            totalCount: 0,
            algorithmList: [],
            renderAlgorithm: [],
            uploadDialogVisible: false,
            demandDialogVisible: false,
            fileList: [],
            dialogLoading: false
        };
    },
    created() {
        this.inintLoading();
    },
    mounted() {
        //监听窗口尺寸变化
        window.addEventListener('resize', this.computeSceneContainerHeight);
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.computeSceneContainerHeight);
    },
    watch: {},
    computed: {},
    methods: {
        inintLoading() {
            this.loading = true;
            var requests = [getSceneList(), getAlgorithmList(this.params)];
            Promise.all(requests).then(results => {
                if (results[0].code == 200) {
                    this.sceneList = results[0].data;
                    if (this.sceneList.length > 0) {
                        this.isfirst = false;
                        this.$nextTick(() => {
                            this.computeSceneContainerHeight();
                        })
                    }
                }
                if (results[1].code == 200) {
                    this.totalCount = results[1].count;
                    if (results[1].data.length > 0) {
                        this.algorithmList = results[1].data;
                        this.algorithmList.forEach(item => {
                            if (item.imgs) {
                                item.imgs = baseURL.split("/api")[0] + item.imgs;
                            }
                        })
                        this.renderAlgorithm = [...this.algorithmList];
                    }

                }
            }).finally(() => {
                this.loading = false;
            })
        },
        getAlgorithmList() {
            this.loadingList = true;
            this.algorithmList = [];
            getAlgorithmList(this.params).then(res => {
                if (res.code == 200) {
                    this.totalCount = res.count;
                    if (res.data.length > 0) {
                        this.renderAlgorithm = res.data;
                        this.renderAlgorithm.forEach(item => {
                            if (item.imgs) {
                                item.imgs = baseURL.split("/api")[0] + item.imgs;
                            }
                        })
                    } else {
                        this.renderAlgorithm = [];
                    }
                }
            }).finally(() => {
                this.loadingList = false;
            })
        },
        filterScene(scene) {
            this.activeScene = scene;
            if (scene == "全部") {
                this.params.scene = "";
            } else {
                this.params.scene = scene;
            }

            this.getAlgorithmList();
        },
        computeSceneContainerHeight() {
            var filterContainers = document.querySelectorAll(".filter-container");
            var sceneItems = filterContainers[1].querySelector(".filter-options");
            var sceneItemsHeight = sceneItems.getBoundingClientRect().height;
            this.sceneContainerHeight = sceneItemsHeight;
        },
        showMoreScene() {
            this.isShowMore = true;
        },
        hiddenScene() {
            this.isShowMore = false;
        },
        filterList() {
            this.getAlgorithmList();
        },
        viewDetail(row) {
            this.$router.push({ path: "/algorithm/tryout/target", query: { id: row.id } });
        },
        createAlgorithm() {
            this.fileList = [];
            this.uploadDialogVisible = true;
        },
        handleCommand(command, row) {
            console.log(command, row)
            if (command == "delete") {
                this.$confirm('确定要删除吗?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'info'
                }).then(() => {
                    this.loading = true;
                    unloadModel({ Id: row.id }).then(res => {
                        if (res.code == 200) {
                            this.$message({
                                type: 'success',
                                message: '模型卸载成功!'
                            });
                            this.getProjectList();
                        }
                    }).finally(() => {
                        this.loading = false;
                    })
                })
            }

        },
        submitCreate() {
            if (this.fileList.length > 0) {
                this.dialogLoading = true;
                let formData = new FormData();
                let modelFile = this.fileList[0].raw;
                formData.append("modelFile", modelFile);
                exportAlgorithModel(formData).then(res => {
                    if (res.code == 200) {
                        this.$message({
                            type: 'success',
                            message: '上传成功!'
                        });
                        this.uploadDialogVisible = false;
                        this.getAlgorithmList();
                    }
                }).finally(() => {
                    this.dialogLoading = false;
                })
            } else {
                this.$message({
                    message: '请上传模型文件',
                    type: 'warning'
                });
            }
        },
        handleFileChange(file, fileList) {
            // console.log(file, fileList);
            var size = file.size / 1024 / 1024;
            if (size <= 100) {
                this.fileList = fileList;
            } else {
                this.$message({
                    message: '上传文件的大小不能超过100M',
                    type: 'warning'
                });
            }
        },
        handleRemoveFile(file, fileList) {
            // console.log(file, fileList);
            this.fileList = fileList;
        },
        toMoreAlgorithm() {
            this.demandDialogVisible = true;
        },

    }
};
</script>
<style lang="scss" scoped>
.filter-params {
    margin-bottom: 15px;

    .el-input {
        width: 35% !important;
    }
}

.filter-container {
    display: flex;
    position: relative;

    .filter-label {
        color: #1b1e26;
        font-size: 14px;
        min-width: 68px;
        padding: 4px 16px 4px 0;
    }

    .filter-options {
        display: flex;
        flex-wrap: wrap;
        padding-right: 50px;

        &.hidden {
            max-height: 88px;
            overflow: hidden;
        }

        .option {
            border-radius: 3px;
            cursor: pointer;
            margin-bottom: 15px;
            margin-right: 5px;
            padding: 4px 16px;
            font-size: 14px;

            &.atv-option {
                color: #3852dd;
                background-color: rgba(101, 118, 200, 0.18);
            }
        }
    }

    .option-action {
        position: absolute;
        right: 0;
        bottom: 15px;
        padding: 4px 16px;
        font-size: 14px;
    }
}

.list-action {
    margin-bottom: 10px;

    .list-total {
        font-size: 15px;
        color: #343a40;

        .total-count {
            margin: 0 3px;
        }
    }
}

.algorithm-list {
    display: flex;
    flex-wrap: wrap;
    margin-top: 10px;

    .algorithm-card {
        position: relative;
        border: 1px solid #ebebeb;
        border-radius: 6px;
        width: 23.5%;
        height: 330px;
        margin-bottom: 20px;
        margin-right: 2%;
        overflow: hidden;
        box-sizing: border-box;
        cursor: pointer;

        &:nth-child(4n) {
            margin-right: 0;
        }

        .thumbnail {
            height: 169px;
            margin-bottom: 12px;
            overflow: hidden;
            width: 100%;

            &:hover img {
                transform: scale(1.04);
                transition: all 0.3s;
            }

            img {
                height: 100%;
                object-fit: cover;
                width: 100%;
            }
        }

        .name {
            color: #333;
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 6px;
            padding: 0 90px 0 12px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .scene {
            color: #4d5869;
            font-size: 13px;
            font-weight: 400;
            margin-bottom: 6px;
            padding: 0 12px;
        }

        .desciription {
            color: #4d5869;
            font-size: 12px;
            font-weight: 400;
            height: 40px;
            line-height: 20px;
            padding: 0 12px;
            overflow: hidden;
            text-overflow: ellipsis;
            -webkit-line-clamp: 2;
            display: -webkit-box;
            -webkit-box-orient: vertical;
        }

        .source {
            position: absolute;
            top: 178px;
            right: 12px;
        }

        .action {
            display: flex;
            justify-content: flex-end;
            font-size: 13px;
            width: calc(100% - 24px);
            position: absolute;
            left: 12px;
            bottom: 10px;

            .status {
                color: #f27045;
                margin-right: 15px;
            }

            .more {

                .el-dropdown {
                    font-size: 13px;
                    color: #909399;
                }

            }
        }
    }

    .finally-tip {
        width: 100%;
        text-align: center;
        margin-top: 20px;

        .finally-tip-text {
            color: #b6b6b6;
            font-size: 14px;
            margin-bottom: 15px;
        }
    }

}

.upload-demo {
    width: 100%;

    ::v-deep .el-upload {
        width: 100%;

        .el-upload-dragger {
            width: 100%;
        }
    }
}



.rnav-menu {
    position: fixed;
    z-index: 999;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    background: #fff;
    border: 1px solid #eee;
    border-radius: 4px;
    transition: right .5s ease;
}

.rnav-menu .item {
    display: block;
    width: 55px;
    text-align: center;
    margin-top: 0;
    padding-top: 14px;
    padding-bottom: 12px;
    position: relative;
    border-bottom: 1px solid #eee;
    cursor: pointer;
}

.rnav-menu .item:last-of-type {
    border-bottom: none;
}

.rnav-menu .item .rnav_icon {
    width: 32px;
    height: 32px;
}

.rnav-menu .item .rnav-name {
    display: block;
    color: #333;
    font-size: 12px;
    text-align: center;
    transform: scale(.9);
    font-weight: 400;
    margin-bottom: 0;
    margin-top: 5px;
    cursor: pointer;
}

.rnav-menu .item .popover-img {
    position: absolute;
    top: -63px;
    left: -250px;
    z-index: 1099;
    width: 195px;
    opacity: 0;
    visibility: hidden;
    border-radius: 3px;
    transition: left .5s ease, opacity .5s ease-in;
}

.rnav-menu .item .popover-img img {
    width: 195px;
    border-radius: 3px;
    box-shadow: 0 0 8px 2px rgba(0, 0, 0, .1);
}

.circle-box {
    display: inline-block;
    width: 32px;
    height: 32px;
    line-height: 32px;
    border-radius: 50%;
    background-color: #e9f5ff;
}

.circle-box .iconfont {
    font-size: 20px;
    color: #1b6cff;
}

.rnav-menu .item:hover {
    background-color: #128bed;
    border-radius: 4px;
}

// .rnav-menu .item:first-of-type:hover {
//     border-radius: 4px 4px 0 0;
// }

// .rnav-menu .item:last-of-type:hover {
//     border-radius: 0 0 4px 4px;
// }


.rnav-menu .item:hover .rnav-name {
    color: #fff;
}

.rnav-menu .item:hover .circle-box {
    background-color: #fff;
}

.should-popover:hover .popover-img {
    opacity: 1;
    left: -210px;
    visibility: visible;
}

.feedback p {
    margin-bottom: 1rem;
}

.weixin-code img {
    width: 150px;
}

.form {
    width: 85%;
    margin: 0 auto;
}

.dialog-wrap {
    padding: 0 10px;
    max-height: 53vh;
    display: flex;
    justify-content: space-between;

    .detail-info {
        width: calc(100% - 558px);
        padding: 12px 20px;
        overflow-y: auto;
        box-sizing: border-box;

        .result-item {
            display: flex;
            margin-bottom: 24px;

            .result-item-key {
                width: 100px;
                color: #a6a6a6;
                margin-right: 20px;
            }



            .result-item-value {
                flex: 1;

                .image-wrap {
                    position: relative;

                    img {
                        width: 100%;
                        height: 260px;
                        object-fit: cover;
                    }

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
}


.scene-list {

    ::v-deep .el-form-item__content {
        line-height: 30px;
    }
}


.demand-wrap {
    text-align: center;

    .title {
        font-size: 24px;
        color: #3f3f40;
        letter-spacing: 0.88px;
        margin-bottom: 12px;
    }

    .sub-title {
        font-size: 16px;
        line-height: 28px;
        letter-spacing: 0.75px;
        color: #828282;
    }

    .qrcode {
        width: 340px;
        height: 340px;
        margin: 0 auto;

        img {
            width: 100%;
            height: 100%;
        }
    }
}
</style>