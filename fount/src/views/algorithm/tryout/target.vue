<template>
    <div class="container">
        <div class="page-breadcrumb">
            <el-breadcrumb separator="/">
                <el-breadcrumb-item :to="{ path: '/algorithm' }">算法列表</el-breadcrumb-item>
                <el-breadcrumb-item>模型预测</el-breadcrumb-item>
            </el-breadcrumb>
        </div>
        <div class="main-wrapper card" v-loading="loading">
            <div class="center-container">
                <div class="model-detail">
                    <div class="image"><img :src="modelInfo.image" alt=""></div>
                    <div class="info">
                        <div class="title">{{ modelInfo.title }}</div>
                        <div class="scenes" v-html="modelInfo.scenes"></div>
                        <div class="desc">{{ modelInfo.desc }}</div>
                    </div>
                </div>

                <div class="model-call">
                    <el-tabs v-model="activeFatherTab" type="card">
                        <el-tab-pane label="图像识别" name="first">
                            <div class="tryout-model">
                                <div class="left-box">
                                    <div class="title">识别图片</div>
                                    <div class="image-container request-image"
                                        :style="{ height: imageContainerHeight + 'px' }">
                                        <img :src="requestImageUrl" alt="" v-if="requestImageUrl">
                                        <div class="upload-container" v-else>
                                            <input type="file" class="fileUpload" accept=".jpg,.png,.jpeg"
                                                @change="handleImageFileChange">
                                            <div class="upload-icon"><i class="el-icon-upload"></i></div>
                                            <div class="upload-text">将文件拖到此处，或<span>点击上传</span></div>
                                            <div class="upload-tip">文件格式：jpg/png/jpeg，大小30M以内</div>
                                        </div>
                                    </div>
                                    <div class="action">
                                        <div class="upload-btn">
                                            <input type="file" class="fileUpload" accept=".jpg,.png,.jpeg"
                                                @change="handleImageFileChange">
                                            <el-button type="primary" size="small">上传图片</el-button>
                                        </div>
                                    </div>
                                </div>
                                <div class="right-box">
                                    <div class="mark">
                                        <el-tabs v-model="activeImageTab">
                                            <el-tab-pane label="识别结果" name="first">
                                                <div class="image-container return-image"
                                                    :style="{ height: imageContainerHeight + 'px' }"
                                                    v-loading="imageLoading" element-loading-text="识别中">
                                                    <div class="mark-image">
                                                        <img :src="returnImageUrl" alt="">
                                                        <div class="inside-iframe" v-for="(item, index) in coordinate"
                                                            :key="index"
                                                            :style="{ width: item.width + 'px', height: item.height + 'px', left: item.left + 'px', top: item.top + 'px', borderColor: item.color }">
                                                            <span :style="{ backgroundColor: item.color }">{{ item.label
                                                                }}
                                                                {{ item.score }}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </el-tab-pane>
                                            <el-tab-pane label="JSON结果" name="second">
                                                <div class="return-result"
                                                    :style="{ height: imageContainerHeight + 'px' }"
                                                    v-loading="imageLoading" element-loading-text="识别中">
                                                    <pre v-html="returnImageResult"></pre>
                                                </div>
                                            </el-tab-pane>
                                        </el-tabs>
                                        <div class="confidence-filter" v-if="activeImageTab == 'first'">
                                            置信度
                                            <el-tooltip placement="top" effect="light">
                                                <div slot="content">
                                                    置信度说明：图中方框的百分比置信度是衡量算法识别准确性的量化指标，<br />置信度越高表示当前算法对检测结果的准确度越有信心。
                                                </div>
                                                <span class="question-icon">
                                                    <svg viewBox="64 64 896 896" focusable="false"
                                                        data-icon="question-circle" width="1em" height="1em"
                                                        fill="currentColor" aria-hidden="true" class="el-tooltip"
                                                        aria-describedby="el-tooltip-3086" tabindex="0">
                                                        <path
                                                            d="M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64zm0 820c-205.4 0-372-166.6-372-372s166.6-372 372-372 372 166.6 372 372-166.6 372-372 372z">
                                                        </path>
                                                        <path
                                                            d="M623.6 316.7C593.6 290.4 554 276 512 276s-81.6 14.5-111.6 40.7C369.2 344 352 380.7 352 420v7.6c0 4.4 3.6 8 8 8h48c4.4 0 8-3.6 8-8V420c0-44.1 43.1-80 96-80s96 35.9 96 80c0 31.1-22 59.6-56.1 72.7-21.2 8.1-39.2 22.3-52.1 40.9-13.1 19-19.9 41.8-19.9 64.9V620c0 4.4 3.6 8 8 8h48c4.4 0 8-3.6 8-8v-22.7a48.3 48.3 0 0130.9-44.8c59-22.7 97.1-74.7 97.1-132.5.1-39.3-17.1-76-48.3-103.3zM472 732a40 40 0 1080 0 40 40 0 10-80 0z">
                                                        </path>
                                                    </svg>
                                                </span>
                                            </el-tooltip>
                                            <el-input v-model="imageConfidence" placeholder="请输入置信度(10~99)" size="small"
                                                @input="checkImageInputValue" @blur="filterImageConfidence"></el-input>
                                            <span class="unit">%</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </el-tab-pane>
                        <el-tab-pane label="视频识别" name="second">
                            <div class="tryout-model">
                                <div class="left-box">
                                    <div class="title">识别视频</div>
                                    <div class="video-container request-video"
                                        :style="{ height: videoContainerHeight + 'px' }">
                                        <video :src="requestVideoUrl" controls preload v-if="requestVideoUrl"></video>
                                        <!-- <el-progress :percentage="videoPercent"></el-progress> -->
                                        <div class="upload-container" v-else>
                                            <input type="file" class="fileUpload" accept=".mp4"
                                                @change="handleVideoFileChange">
                                            <div class="upload-icon"><i class="el-icon-upload"></i></div>
                                            <div class="upload-text">将文件拖到此处，或<span>点击上传</span></div>
                                            <div class="upload-tip">文件格式：mp4，大小100M以内</div>
                                        </div>
                                    </div>
                                    <div class="action">
                                        <div class="upload-btn">
                                            <input type="file" class="fileUpload" accept=".mp4"
                                                @change="handleVideoFileChange">
                                            <el-button type="primary" size="small">上传视频</el-button>
                                        </div>
                                    </div>
                                </div>
                                <div class="right-box">
                                    <div class="mark">
                                        <el-tabs v-model="activeVideoTab">
                                            <el-tab-pane label="识别视频结果" name="first">
                                                <div class="video-container return-video"
                                                    :style="{ height: videoContainerHeight + 'px' }"
                                                    v-loading="videoLoading" element-loading-text="识别中">
                                                    <div class="mark-image">
                                                        <video :src="returnVideoUrl" controls preload
                                                            v-if="returnVideoUrl"></video>
                                                    </div>
                                                </div>
                                            </el-tab-pane>
                                            <el-tab-pane label="识别图像结果" name="second">
                                                <div class="image-container return-catch-images"
                                                    :style="{ height: videoContainerHeight + 'px' }">
                                                    <div class="catch-images">
                                                        <div class="catch-images-item"
                                                            v-for="(item, index) in catchImagesList" :key="index"
                                                            v-viewer>
                                                            <img :src="item.imgPath" alt="">
                                                        </div>
                                                    </div>
                                                </div>
                                            </el-tab-pane>
                                            <el-tab-pane label="JSON结果" name="third">
                                                <div class="return-result"
                                                    :style="{ height: videoContainerHeight + 'px' }"
                                                    v-loading="videoLoading" element-loading-text="识别中">
                                                    <pre v-html="returnVideoResult"></pre>
                                                </div>
                                            </el-tab-pane>
                                        </el-tabs>
                                        <div class="confidence-filter" v-if="activeVideoTab == 'second'">
                                            置信度
                                            <el-tooltip placement="top" effect="light">
                                                <div slot="content">
                                                    置信度说明：图中方框的百分比置信度是衡量算法识别准确性的量化指标，<br />置信度越高表示当前算法对检测结果的准确度越有信心。
                                                </div>
                                                <span class="question-icon">
                                                    <svg viewBox="64 64 896 896" focusable="false"
                                                        data-icon="question-circle" width="1em" height="1em"
                                                        fill="currentColor" aria-hidden="true" class="el-tooltip"
                                                        aria-describedby="el-tooltip-3086" tabindex="0">
                                                        <path
                                                            d="M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64zm0 820c-205.4 0-372-166.6-372-372s166.6-372 372-372 372 166.6 372 372-166.6 372-372 372z">
                                                        </path>
                                                        <path
                                                            d="M623.6 316.7C593.6 290.4 554 276 512 276s-81.6 14.5-111.6 40.7C369.2 344 352 380.7 352 420v7.6c0 4.4 3.6 8 8 8h48c4.4 0 8-3.6 8-8V420c0-44.1 43.1-80 96-80s96 35.9 96 80c0 31.1-22 59.6-56.1 72.7-21.2 8.1-39.2 22.3-52.1 40.9-13.1 19-19.9 41.8-19.9 64.9V620c0 4.4 3.6 8 8 8h48c4.4 0 8-3.6 8-8v-22.7a48.3 48.3 0 0130.9-44.8c59-22.7 97.1-74.7 97.1-132.5.1-39.3-17.1-76-48.3-103.3zM472 732a40 40 0 1080 0 40 40 0 10-80 0z">
                                                        </path>
                                                    </svg>
                                                </span>
                                            </el-tooltip>
                                            <el-input v-model="videoConfidence" placeholder="请输入置信度(10~99)" size="small"
                                                @input="checkVideoInputValue" @blur="filterVideoConfidence"></el-input>
                                            <span class="unit">%</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </el-tab-pane>
                    </el-tabs>
                </div>

            </div>
        </div>
    </div>
</template>

<script>
import { getAlgorithDetail, modelToPredictImage, modelToPredictVideo } from "@/api/algorithm";
import baseURL from "@/utils/request";
export default {
    components: {},
    props: {},
    data() {
        return {
            loading: false,
            modelInfo: {
                modelId: null,
                image: "",
                title: "",
                scenes: "",
                desc: ""
            },
            activeFatherTab: "first",
            activeImageTab: "first",
            imageContainerHeight: "400",
            requestImageUrl: "",
            returnImageUrl: "",
            returnImageResult: "",
            imageConfidence: "",
            imageLoading: false,
            originalCoordinate: [],
            coordinate: [],
            activeVideoTab: "first",
            videoLoading: false,
            videoConfidence: "",
            videoReady: false, //视频是否加载完毕
            requestVideoUrl: "",
            returnVideoUrl: "",
            videoContainerHeight: "400",
            returnVideoResult: "",
            catchImagesList: [],
            videoPercent: 0, //视频上传进度
        };
    },
    created() {
        this.modelInfo.modelId = this.$route.query.id;
        this.getAlgorithDetail(this.modelInfo.modelId);
    },
    mounted() {

    },
    watch: {},
    computed: {},
    methods: {
        getAlgorithDetail(modelId) {
            this.loading = true;
            getAlgorithDetail({ Id: modelId }).then(res => {
                if (res.code == 200) {
                    this.modelInfo.image = baseURL.split("/api")[0] + res.data.imgs;
                    this.modelInfo.title = res.data.modelName;
                    this.modelInfo.scenes = /,/.test(res.data.scene) ? res.data.scene.replace(/,/g, "&nbsp;&nbsp;") : res.data.scene;
                    this.modelInfo.desc = res.data.modelExplain;
                    if (res.data.testResult) {
                        this.requestImageUrl = baseURL.split("/api")[0] + res.data.imgTest;
                        this.$nextTick(() => {
                            var testResult = JSON.parse(res.data.testResult);
                            // console.log(testResult)
                            this.imageLoading = true;
                            var imageElement = document.querySelector(".request-image img");
                            imageElement.onload = () => {
                                //获取页面上图片展示的宽高
                                var imageWidth = document.querySelector(".request-image img").offsetWidth;
                                var imageHeight = document.querySelector(".request-image img").offsetHeight;
                                // console.log(imageWidth, imageHeight)
                                this.imageContainerHeight = imageHeight;

                                setTimeout(() => {
                                    let image = new Image();
                                    image.onload = () => {
                                        this.returnImageUrl = baseURL.split("/api")[0] + res.data.imgTest;
                                        var primaryWidth = image.width;
                                        var primaryHeight = image.height;
                                        var widthRatio = (imageWidth / primaryWidth).toFixed(2);
                                        var heightRatio = (imageHeight / primaryHeight).toFixed(2);
                                        var tempCoordinate = testResult.data.coordinate;
                                        if (tempCoordinate.length > 0) {
                                            tempCoordinate.forEach((item) => {
                                                var obj = {
                                                    width: (item.xyxy[2] - item.xyxy[0]) * widthRatio,
                                                    height: (item.xyxy[3] - item.xyxy[1]) * heightRatio,
                                                    left: item.xyxy[0] * widthRatio,
                                                    top: item.xyxy[1] * heightRatio,
                                                    label: item.label,
                                                    score: item.score,
                                                    color: "#ff0000"
                                                };
                                                this.coordinate.push(obj);
                                            });
                                        }
                                        this.originalCoordinate = [...this.coordinate];
                                        this.returnImageResult = this.syntaxHighlight(testResult);
                                        this.imageLoading = false;
                                    };
                                    image.src = this.requestImageUrl;
                                }, 3000);
                            }
                        })

                    }
                }

            }).finally(() => {
                this.loading = false;
            })
        },
        async handleImageFileChange(event) {
            // console.log(event.target.files[0])
            this.returnImageUrl = "";
            this.returnImageResult = "";
            this.coordinate = [];
            this.originalCoordinate = [];

            var file = event.target.files[0];
            var fileSize = file.size / 1024 / 1024;

            var reader = new FileReader();
            reader.readAsDataURL(file);

            // 等待文件读取完成
            await new Promise((resolve, reject) => {
                reader.onload = resolve;
                reader.onerror = reject;
            });

            // 文件读取完成后，设置图片路径
            this.requestImageUrl = reader.result;

            this.$nextTick(async () => {
                // 等待图片加载完成
                var requestImageElement = document.querySelector(".request-image img");
                await new Promise((resolve, reject) => {
                    requestImageElement.onload = resolve;
                    requestImageElement.onerror = reject;
                });

                // 获取图片的宽度和高度
                var imageWidth = requestImageElement.offsetWidth;
                var imageHeight = requestImageElement.offsetHeight;
                this.imageContainerHeight = imageHeight;

                if (fileSize <= 30) {
                    // 准备发送请求的数据
                    let formData = new FormData();
                    formData.append("file", file);
                    formData.append("Id", this.modelInfo.modelId);

                    try {
                        this.imageLoading = true;
                        const res = await modelToPredictImage(formData);
                        if (res.code == 200) {
                            this.returnImageUrl = reader.result;
                            this.returnImageResult = this.syntaxHighlight(res.data);
                            if (typeof res.data == "object") {
                                var returnResult = res.data.labels;
                                var tempCoordinate = [];
                                if (returnResult.length > 0) {
                                    if (this.imageConfidence) {
                                        returnResult.forEach((item) => {
                                            if (item.score * 100 >= parseInt(this.imageConfidence)) {
                                                tempCoordinate.push(item);
                                            }
                                        });
                                    } else {
                                        tempCoordinate = returnResult;
                                    }
                                } else {
                                    tempCoordinate = returnResult;
                                }

                                // 等待图片加载完成
                                var rerurnImageElement = document.querySelector(".return-image img");
                                await new Promise((resolve, reject) => {
                                    rerurnImageElement.onload = resolve;
                                    rerurnImageElement.onerror = reject;
                                });

                                tempCoordinate.forEach((item) => {
                                    var obj = {
                                        width: item.width * imageWidth,
                                        height: item.height * imageHeight,
                                        left: item.x * imageWidth,
                                        top: item.y * imageHeight,
                                        label: item.zhLabel,
                                        score: item.confidence,
                                        color: item.bgColor
                                    };
                                    this.coordinate.push(obj);
                                });
                                this.originalCoordinate = [... this.coordinate];

                                if (this.coordinate.length == 0) {
                                    this.$message('图片中无相关目标，请更换图片再试试吧');
                                }

                            } else {
                                this.$message(res.msg);
                            }
                        }
                    } finally {
                        this.imageLoading = false;
                    }
                } else {
                    this.$message({
                        message: '上传图片的大小不能超过30M',
                        type: 'warning'
                    });
                }
            })

        },
        filterImageConfidence() {
            if (JSON.parse(this.imageConfidence) < 10) {
                this.imageConfidence = 10;
            }
            if (JSON.parse(this.imageConfidence) > 99) {
                this.imageConfidence = 99;
            }
            var tempList = [];
            this.originalCoordinate.forEach((item) => {
                if (item.score * 100 >= parseInt(this.imageConfidence)) {
                    tempList.push(item);
                }
            });
            this.coordinate = [...tempList];
            if (this.coordinate.length == 0) {
                this.$message('图片中无相关目标，请更换图片再试试吧');
            }
        },
        checkImageInputValue() {
            this.imageConfidence = this.imageConfidence.replace(/[^0-9]/g, "");
        },
        async handleVideoFileChange(event) {
            //清空上一个文件的内容
            this.returnVideoUrl = "";

            var file = event.target.files[0];
            var fileSize = file / 1024 / 1024;
            //大于30M切片上传
            // if (fileSize > 30) {
            //     const chunkSize = 1024 * 1024; // 每个块的大小为 1MB
            //     const fileSize = file.size;  // 文件大小
            //     const chunks = Math.ceil(fileSize / chunkSize);  // 总块数
            //     const tasks = [];  // 上传任务数组
            //     let uploaded = 0;  // 已上传块数

            //     // 文件切割
            //     for (let i = 0; i < chunks; i++) {
            //         const start = i * chunkSize;
            //         const end = Math.min(start + chunkSize, fileSize);

            //         tasks.push(
            //             new Promise((resolve, reject) => {
            //                 let formData = new FormData();
            //                 formData.append('chunk_index', i);  // 块编号
            //                 formData.append('chunk_count', chunks);  // 总块数
            //                 formData.append('file_id', file.id);  // 文件ID
            //                 formData.append('chunk_data', file.slice(start, end));  // 块数据

            //                 // 上传块数据
            //                 videoSliceToUpload(formData).then(res => {
            //                     if (res.code == 200) {
            //                         uploaded++;
            //                         this.videoPercent = Math.floor((uploaded / chunks) * 100);
            //                         resolve();
            //                     }
            //                 }).catch(error => {
            //                     reject(error);
            //                 })
            //             })
            //         );
            //     }

            //     // 待所有块上传完成后，发送合并请求
            //     await Promise.all(tasks);

            //     modelToPredictVideo({ file_id: file.id, chunks }).then(res => {
            //         if (res.code == 200) {

            //             this.$message({
            //                 type: 'success',
            //                 message: '上传成功!'
            //             });
            //             this.requestVideoUrl = e.target.result;
            //             this.$nextTick(() => {
            //                 var videoElement = document.querySelector(".request-video video");
            //                 videoElement.addEventListener('loadedmetadata', () => {
            //                     var videoWidth = document.querySelector(".request-video video").offsetWidth;
            //                     var videoHeight = document.querySelector(".request-video video").offsetHeight;
            //                     this.videoContainerHeight = videoHeight;
            //                 });
            //             })
            //         }
            //     })

            // } else {

            // }


        },
        filterVideoConfidence() {

        },
        checkVideoInputValue() {
            this.videoConfidence = this.videoConfidence.replace(/[^0-9]/g, "");
        },
        syntaxHighlight(json) {
            if (typeof json != "string") {
                json = JSON.stringify(json, undefined, 2);
            }
            json = json.replace(/&/g, "&").replace(/</g, "<").replace(/>/g, ">");
            return json.replace(
                /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g,
                function (match) {
                    var cls = "number";
                    if (/^"/.test(match)) {
                        if (/:$/.test(match)) {
                            cls = "key";
                        } else {
                            cls = "string";
                        }
                    } else if (/true|false/.test(match)) {
                        cls = "boolean";
                    } else if (/null/.test(match)) {
                        cls = "null";
                    }
                    return '<span class="' + cls + '">' + match + "</span>";
                }
            );
        }
    }
};
</script>
<style lang="scss" scoped>
.center-container {
    padding: 0 100px;

    .model-detail {
        display: flex;
        font-size: 16px;
        padding: 23px 0;

        .image {
            flex-shrink: 0;
            height: 154px;
            width: 211px;

            img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
        }

        .info {
            padding: 0 32px 0 40px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;

            .title {
                color: #3d3d3d;
                font-size: 36px;
            }

            .scenes {
                color: #999;
                font-size: 16px;
            }

            .desc {
                color: #3d3d3d;
                font-size: 16px;
            }
        }
    }

    .model-call {
        margin-top: 20px;
        padding-bottom: 40px;

        .tryout-model {
            display: flex;
            padding: 0 10px;

            .left-box {
                width: calc((100% - 20px)/2);

                .image-container,
                .video-container {
                    margin-top: 14px;
                }

                .upload-container {
                    width: 100%;
                    height: 100%;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    cursor: pointer;
                    position: relative;

                    .fileUpload {
                        position: absolute;
                        left: 0;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        opacity: 0;
                        cursor: pointer;
                    }

                    .upload-icon {
                        margin-bottom: 16px;

                        i {
                            font-size: 85px;
                            color: #c0c4cc;
                            line-height: 50px
                        }
                    }

                    .upload-text {
                        color: #151b26;
                        font-size: 16px;
                        font-weight: 400;
                        line-height: 26px;

                        span {
                            color: #5664d2;
                        }
                    }

                    .upload-tip {
                        color: #84868c;
                        font-size: 13px;
                        font-weight: 400;
                        line-height: 26px;
                    }

                }

                .action {
                    margin-top: 12px;

                    .upload-btn {
                        position: relative;

                        .fileUpload {
                            position: absolute;
                            left: 0;
                            top: 0;
                            width: 80px;
                            height: 32px;
                            opacity: 0;
                            cursor: pointer;
                        }
                    }


                }
            }

            .right-box {
                width: calc((100% - 20px)/2);
                margin-left: 20px;
                position: relative;

                .return-catch-images {
                    overflow: auto;

                    .catch-images {
                        display: flex;
                        flex-wrap: wrap;

                        .catch-images-item {
                            width: 49%;
                            margin-bottom: 20px;
                            cursor: pointer;

                            &:nth-child(2n+1) {
                                margin-right: 2%;
                            }
                        }
                    }
                }

                .confidence-filter {
                    position: absolute;
                    right: 0;
                    top: 4px;
                    display: flex;
                    align-items: center;
                    white-space: nowrap;

                    .question-icon {
                        margin: 0 10px 0 5px;

                        svg {
                            vertical-align: -0.125em;
                        }
                    }

                    .el-input {
                        width: 160px;
                    }

                    .unit {
                        margin-left: 5px;
                    }
                }
            }

            .title {
                font-size: 15px;
                font-weight: 600;
                color: #303133;
                height: 40px;
                line-height: 50px;
            }

            .image-container {
                border: 1px solid #ccc;
                padding: 24px;
                box-sizing: content-box;
                position: relative;

                .mark-image {
                    position: relative;

                    .inside-iframe {
                        position: absolute;
                        border: 3px solid;
                        box-sizing: border-box;

                        span {
                            display: inline-block;
                            white-space: nowrap;
                            color: #fff;
                            margin-top: -23px;
                            margin-left: -2px;
                            font-size: 13px;
                            position: absolute;
                        }
                    }
                }

                img {
                    width: 100%;
                    object-fit: contain;
                }


            }

            .video-container {
                border: 1px solid #ccc;
                padding: 24px;
                box-sizing: content-box;
                position: relative;

                video {
                    width: 100%;
                    object-fit: contain;
                }
            }

            .return-result {
                border: 1px solid #ccc;
                padding: 24px;
                box-sizing: content-box;

                pre {
                    padding: 5px;
                    height: 100%;
                    overflow: auto;
                    white-space: pre-wrap;
                    word-wrap: break-word;
                }

                ::v-deep .key {
                    color: red;
                }

                ::v-deep .string {
                    color: green;
                }


            }
        }
    }


}

::v-deep .el-tabs__item {
    font-weight: 600;
    padding: 0 10px;
}

::v-deep .el-tabs__nav-wrap::after {
    height: 1px;
}
</style>