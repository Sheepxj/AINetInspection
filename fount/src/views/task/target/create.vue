<template>
    <div class="container">
        <div class="page-breadcrumb">
            <el-breadcrumb separator="/">
                <el-breadcrumb-item :to="{ path: '/task/target' }">任务列表</el-breadcrumb-item>
                <el-breadcrumb-item :to="{ path: '/task/target' }" v-if="taskName">{{ taskName }}</el-breadcrumb-item>
                <el-breadcrumb-item>{{ pageTitle }} 监测任务</el-breadcrumb-item>
            </el-breadcrumb>
            <div class="text-primary pointer font-size-15" @click="fallback">返回列表</div>
        </div>
        <div class="main-wrapper card" v-loading="loading">
            <el-form ref="ruleForm" :model="form" :rules="rules" label-width="110px">
                <div class="form-container">
                    <div class="left-box">
                        <el-form-item label="任务名称" prop="taskName">
                            <el-input v-model="form.taskName" size="small" placeholder="请输入任务名称" maxlength="10"
                                show-word-limit></el-input>
                        </el-form-item>
                        <el-form-item label="任务描述" prop="taskDesc">
                            <el-input type="textarea" v-model="form.taskDesc" placeholder="请输入任务描述" rows="3"
                                resize="none"></el-input>
                        </el-form-item>
                        <el-form-item label="任务优先级" prop="taskLevel">
                            <el-select v-model="form.taskLevel" placeholder="请选择任务优先级" size="small">
                                <el-option label="高" value="高"></el-option>
                                <el-option label="中" value="中"></el-option>
                                <el-option label="低" value="低"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="检测类型" prop="detectType">
                            <el-select v-model="form.detectType" placeholder="请选择检测类型" size="small"
                                @input="handleDetectTypeChange">
                                <!-- <el-option label="默认（不框选）" value="1"></el-option> -->
                                <el-option label="闯入检测" value="2"></el-option>
                                <el-option label="离开检测" value="3"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="算法模型" prop="model">
                            <el-select v-model="form.model" :placeholder="modelPlaceholder" filterable multiple
                                :multiple-limit="modelLimit" size="small">
                                <el-option v-for="(item, index) in modelList" :label="item.label" :value="item.value"
                                    :key="index"></el-option>
                            </el-select>
                        </el-form-item>
                        <div class="form-control-merge" v-if="form.detectType == 2 || form.detectType == 3">
                            <el-form-item label="目标数量" prop="statsIntervalUnit">
                                <el-select v-model="form.targetOperator" placeholder="请选择" class="short-input"
                                    size="small">
                                    <el-option label="大于" value="1"></el-option>
                                    <el-option label="小于" value="2"></el-option>
                                    <el-option label="大于等于" value="3"></el-option>
                                    <el-option label="小于等于" value="4"></el-option>
                                    <el-option label="等于" value="5"></el-option>
                                </el-select>
                            </el-form-item>
                            <el-form-item prop="targetNumber">
                                <el-input type="number" v-model="form.targetNumber" size="small" placeholder="例：5"
                                    class="medium-input" min="1"></el-input>
                            </el-form-item>
                        </div>
                        <div class="form-control-merge" v-if="form.detectType == 2">
                            <el-form-item label="目标停留时长" prop="stayTiming">
                                <el-input type="number" v-model="form.stayTiming" size="small" placeholder="例：60"
                                    class="medium-input" min="1"></el-input>
                            </el-form-item>
                            <el-form-item prop="stayTimeUnit">
                                <el-select v-model="form.stayTimeUnit" placeholder="时长单位" class="short-input"
                                    size="small">
                                    <el-option label="秒钟" value="秒钟"></el-option>
                                    <el-option label="分钟" value="分钟"></el-option>
                                    <el-option label="小时" value="小时"></el-option>
                                </el-select>
                            </el-form-item>
                        </div>
                        <div class="form-control-merge" v-if="form.detectType == 3">
                            <el-form-item label="目标离开时长" prop="leaveTiming">
                                <el-input type="number" v-model="form.leaveTiming" size="small" placeholder="例：60"
                                    class="medium-input" min="1"></el-input>
                            </el-form-item>
                            <el-form-item prop="leaveTimeUnit">
                                <el-select v-model="form.leaveTimeUnit" placeholder="时长单位" class="short-input"
                                    size="small">
                                    <el-option label="秒钟" value="秒钟"></el-option>
                                    <el-option label="分钟" value="分钟"></el-option>
                                    <el-option label="小时" value="小时"></el-option>
                                </el-select>
                            </el-form-item>
                        </div>
                    </div>
                    <div class="right-box">
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="摄像头点位" prop="location" class="label-left">
                                    <el-cascader v-model="form.location" size="small" :options="locationList" clearable
                                        placeholder="请选择摄像头点位" @change="handleLocationChange"></el-cascader>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="视频抽帧级别" prop="rateLevel">
                                    <el-select v-model="form.rateLevel" placeholder="请选择视频抽帧级别" size="small">
                                        <el-option label="不抽帧" value="0"></el-option>
                                        <el-option label="低" value="1"></el-option>
                                        <el-option label="中" value="2"></el-option>
                                        <el-option label="高" value="3"></el-option>
                                    </el-select>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <div class="el-form-item is-required">
                            <div class="el-form-item__label" style="float: none;width: 100%;text-align: left;">框选电子围栏
                            </div>
                            <div class="screen-container">
                                <div class="box-selection">
                                    <live-player containerId="video-live" :streamId="streamId" :streamUrl="streamUrl"
                                        :showPointer="false" @updateLoading="updateLoading"
                                        @drawMarkFrame="drawMarkFrame"></live-player>
                                    <div id="drawArea">
                                        <div class="frame-list">
                                            <div class="frame-wrap" v-for="(mark, index) in markList" :key="index">
                                                <div class="outside-frame" :id="mark.index"
                                                    :style="{ width: mark.width + 'px', height: mark.height + 'px', top: mark.top + 'px', left: mark.left + 'px', borderColor: activeFrameIndex == index ? '#229fe7' : '#ff0000', backgroundColor: activeFrameIndex == index ? mark.bgColor : 'transparent', opacity: activeFrameIndex == index ? 0.5 : 1 }">
                                                    <span class="delete-btn"
                                                        :class="{ 'inactive': activeFrameIndex != index }"
                                                        @click.stop="removeFrame(index)" @mousedown.stop><i
                                                            class="el-icon-close"></i></span>
                                                    <!-- 拉伸角 -->
                                                    <span class="tl-horn" v-show="activeFrameIndex == index"></span>
                                                    <span class="tc-horn" v-show="activeFrameIndex == index"></span>
                                                    <span class="tr-horn" v-show="activeFrameIndex == index"></span>
                                                    <span class="bl-horn" v-show="activeFrameIndex == index"></span>
                                                    <span class="bc-horn" v-show="activeFrameIndex == index"></span>
                                                    <span class="br-horn" v-show="activeFrameIndex == index"></span>
                                                    <span class="lc-horn" v-show="activeFrameIndex == index"></span>
                                                    <span class="rc-horn" v-show="activeFrameIndex == index"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </el-form>
            <div class="bottom-actions">
                <el-button size="small" @click="resetForm">重置</el-button>
                <el-button type="primary" size="small" @click="submitTask" :disabled="loadingCamera">提 交</el-button>
            </div>
        </div>
    </div>
</template>

<script>
import { getTaskDetail, getAllAlgorithm, getCameraList, createTask, updateTask } from "@/api/task/target";
import livePlayer from "@/components/livePlayer.vue";
export default {
    components: { livePlayer },
    props: {},
    data() {
        return {
            pageTitle: "添加目标检测",
            taskName: "",
            loading: false,
            form: {
                taskName: '',
                taskDesc: '',
                taskLevel: '',
                detectType: '',
                model: [],
                location: [],
                rateLevel: "0",
                targetOperator: "1",
                targetNumber: '',
                stayTiming: '',
                stayTimeUnit: '秒钟',
                leaveTiming: '',
                leaveTimeUnit: '秒钟',
                taskStatus: '',
            },
            modelPlaceholder: "请选择算法模型(最多一个)",
            modelLimit: 1,
            rules: {
                taskName: [
                    { required: true, message: '请输入任务名称', trigger: 'blur' }
                ],
                taskLevel: [
                    { required: true, message: '请选择任务优先级', trigger: 'change' }
                ],
                location: [
                    { required: true, message: '请选择摄像头点位', trigger: 'change' }
                ],
                rateLevel: [
                    { required: true, message: '请选择视频抽帧级别', trigger: 'change' }
                ],
                model: [
                    { required: true, message: '请选择算法模型', trigger: 'change' }
                ],
                detectType: [
                    { required: true, message: '请选择检测类型', trigger: 'change' }
                ],
            },
            detectPickerOptions: {
                disabledDate(time) {
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);

                    // 将选择器中的日期时间设置为0点
                    time = new Date(time.getFullYear(), time.getMonth(), time.getDate()).getTime();

                    // 如果选择的日期小于今天的日期，则禁用
                    return time < today.getTime();
                },
            },
            modelList: [],
            timeList: [
                {
                    label: "5秒",
                    value: "5秒",
                },
                {
                    label: "10秒",
                    value: "10秒",
                },
                {
                    label: "30秒",
                    value: "30秒",
                },
                {
                    label: "自定义秒钟",
                    value: "自定义秒钟",
                },
            ],
            locationList: [],
            markList: [],
            tempMarkList: [],
            activeFrameIndex: null,
            checkedTaskId: null,
            streamId: null,
            streamUrl: "",
            loadingCamera: false,
        };
    },
    created() {
        if (this.$route.query.id) {
            this.pageTitle = "编辑" + this.pageTitle.slice(2);
            this.checkedTaskId = this.$route.query.id;
        }

        if (this.$route.query.name) {
            this.taskName = this.$route.query.name;
        }

        this.initLoading();
    },
    mounted() {
        //监听全局的点击事件 移除标注框高亮效果
        document.addEventListener('click', this.handleClick);
    },
    beforeDestroy() {
        document.removeEventListener('click', this.handleClick);
    },
    watch: {},
    computed: {},
    methods: {
        initLoading() {
            var request = [getAllAlgorithm(), getCameraList()];
            if (this.checkedTaskId) {
                request.push(getTaskDetail({ Id: this.checkedTaskId }))
            }
            Promise.all(request).then(results => {
                this.drawerVisible = true;
                if (results[0].code == 200) {
                    if (results[0].data.length > 0) {
                        results[0].data.forEach(item => {
                            this.modelList.push({ label: item.modelName, value: item.id });
                        })
                    }
                }

                if (results[1].code == 200) {
                    if (results[1].data.length > 0) {
                        results[1].data.forEach(item => {
                            var obj = { label: item.groupName, value: item.groupName };
                            var children = [];
                            item.cameras.forEach(child => {
                                var childObj = { label: child.cameraLocation, value: child.id, streamId: child.zlmId, streamUrl: child.zlmUrl };
                                if (child.cameraStatus != undefined) {
                                    childObj.status = child.cameraStatus;
                                }
                                if (child.videoScale != undefined) {
                                    childObj.videoScale = child.videoScale;
                                }
                                children.push(childObj);
                            });
                            obj.children = children;
                            this.locationList.push(obj);
                        });
                    }
                }

                if (this.checkedTaskId) {
                    if (results[2].code == 200) {
                        var taskInfo = results[2].data;
                        if (Object.keys(taskInfo).length > 0) {
                            this.form.taskName = taskInfo.taskName;
                            this.form.taskDesc = taskInfo.taskDescription ? taskInfo.taskDescription : "";
                            this.form.taskLevel = taskInfo.alertLevel;
                            this.form.model = /,/.test(taskInfo.ids) ? taskInfo.ids = taskInfo.ids.split(",").map((item) => item = JSON.parse(item)) : [JSON.parse(taskInfo.ids)];
                            this.form.email = taskInfo.notificationEmail;
                            this.form.location[0] = taskInfo.groupName;
                            this.form.location[1] = taskInfo.cameraId;
                            this.form.detectType = JSON.stringify(taskInfo.frameSelect);
                            this.form.rateLevel = JSON.stringify(taskInfo.frameInterval);
                            if (this.form.detectType == 2) {
                                this.form.targetNumber = taskInfo.targetNumber;
                                if (taskInfo.setTime) {
                                    if (taskInfo.setTime <= 60) {
                                        this.form.stayTiming = taskInfo.setTime;
                                        this.form.stayTimeUnit = "秒钟";
                                    } else if (taskInfo.setTime > 60 && taskInfo.setTime <= 3600) {
                                        this.form.stayTiming = taskInfo.setTime / 60;
                                        this.form.stayTimeUnit = "分钟";
                                    } else {
                                        this.form.stayTiming = taskInfo.setTime / 3600;
                                        this.form.stayTimeUnit = "小时";
                                    }
                                }
                            }
                            if (this.form.detectType == 3) {
                                this.form.targetNumber = taskInfo.targetNumber;
                                if (taskInfo.setTime) {
                                    if (taskInfo.setTime <= 60) {
                                        this.form.leaveTiming = taskInfo.setTime;
                                        this.form.leaveTimeUnit = "秒钟";
                                    } else if (taskInfo.setTime > 60 && taskInfo.setTime <= 3600) {
                                        this.form.leaveTiming = taskInfo.setTime / 60;
                                        this.form.leaveTimeUnit = "分钟";
                                    } else {
                                        this.form.leaveTiming = taskInfo.setTime / 3600;
                                        this.form.leaveTimeUnit = "小时";
                                    }
                                }
                            }

                            this.$nextTick(() => {
                                this.streamId = taskInfo.zlmId;
                                this.streamUrl = taskInfo.zlmUrl;
                                this.initDrawReact();
                                if (taskInfo.frameBoxs) {
                                    this.tempMarkList = JSON.parse(taskInfo.frameBoxs);
                                }
                            })
                        }
                    }
                }
            }).finally(() => {
                this.loading = false;
            })
        },
        drawMarkFrame() {
            //数据回显时需要等待监控画面显示后才渲染框选区域
            if (this.tempMarkList.length > 0) {
                var drawAreaElement = document.querySelector("#drawArea");
                var drawAreaWidth = drawAreaElement.offsetWidth;
                var drawAreaHeight = drawAreaElement.offsetHeight;
                this.tempMarkList.forEach((item, index) => {
                    var obj = {};
                    obj.left = drawAreaWidth * item[0];
                    obj.top = drawAreaHeight * item[1];
                    obj.width = drawAreaWidth * item[2] - drawAreaWidth * item[0];
                    obj.height = drawAreaHeight * item[3] - drawAreaHeight * item[1];
                    obj.index = index + 1;
                    this.markList.push(obj);
                })
                this.$nextTick(() => {
                    //八个角拉伸事件绑定
                    this.hornStretchEvent();
                    //边框拖拽事件
                    this.frameDragEvent();
                })
            }
        },
        updateLoading(value) {
            this.loadingCamera = value;
        },
        async handleLocationChange(value) {
            this.markList = [];
            for (let i = 0; i < this.locationList.length; i++) {
                const cameraList = this.locationList[i].children;
                if (cameraList.length > 0) {
                    for (let j = 0; j < cameraList.length; j++) {
                        if (cameraList[j].value == value[1]) {
                            this.streamId = cameraList[j].streamId;
                            this.streamUrl = cameraList[j].streamUrl;
                            this.initDrawReact();
                            break;
                        }
                    }
                }
            }
        },
        submitTask() {
            this.$refs["ruleForm"].validate((valid) => {
                if (valid) {
                    if (this.markList.length == 0) {
                        this.$message.error("请框选需要监测的监控区域");
                        return;
                    }
                    var form = {};
                    form.taskName = this.form.taskName;
                    form.taskDescription = this.form.taskDesc;
                    this.locationList.forEach(item => {
                        if (item.value == this.form.location[0]) {
                            if (item.children.length > 0) {
                                item.children.forEach(data => {
                                    if (data.value == this.form.location[1]) {
                                        form.cameraPosition = data.label;
                                        form.cameraId = data.value;
                                    }
                                })
                            }
                        }
                    })
                    form.alertLevel = this.form.taskLevel;
                    form.notificationEmail = this.form.email;
                    form.ids = this.form.model.join(",");
                    form.status = 0;
                    form.frameInterval = this.form.rateLevel;

                    if (this.markList.length > 0) {
                        var markResult = [];
                        var drawAreaElement = document.querySelector("#drawArea");
                        var drawAreaWidth = drawAreaElement.offsetWidth;
                        var drawAreaHeight = drawAreaElement.offsetHeight;

                        this.markList.forEach(item => {
                            var child = [];
                            child[0] = (item.left / drawAreaWidth).toFixed(1);
                            child[1] = (item.top / drawAreaHeight).toFixed(1);
                            child[2] = ((item.left + item.width) / drawAreaWidth).toFixed(1);
                            child[3] = ((item.top + item.height) / drawAreaHeight).toFixed(1);
                            markResult.push(child);
                        })
                        form.frameBoxs = JSON.stringify(markResult);
                    } else {
                        form.frameBoxs = "";
                    }
                    form.frameSelect = this.form.detectType;
                    form.targetNumber = this.form.targetNumber ? this.form.targetNumber : 0;
                    if (this.form.stayTiming && this.form.stayTimeUnit) {
                        if (this.form.stayTimeUnit == "秒钟") {
                            form.setTime = this.form.stayTiming;
                        } else if (this.form.stayTimeUnit == "分钟") {
                            form.setTime = this.form.stayTiming * 60;
                        } else {
                            form.setTime = this.form.stayTiming * 60 * 60;
                        }
                    }
                    if (this.form.leaveTiming && this.form.leaveTimeUnit) {
                        if (this.form.stayTimeUnit == "秒钟") {
                            form.setTime = this.form.leaveTiming;
                        } else if (this.form.stayTimeUnit == "分钟") {
                            form.setTime = this.form.leaveTiming * 60;
                        } else {
                            form.setTime = this.form.leaveTiming * 60 * 60;
                        }
                    }

                    this.loading = true;
                    if (!this.checkedTaskId) {
                        createTask(form).then(res => {
                            if (res.code == 200) {
                                this.$message({
                                    type: 'success',
                                    message: '添加成功'
                                });
                                this.$router.push("/task/target");
                            }
                        }).finally(() => {
                            this.loading = false;
                        })
                    } else {
                        form.id = this.checkedTaskId;
                        updateTask(form).then(res => {
                            if (res.code == 200) {
                                this.$message({
                                    type: 'success',
                                    message: '修改成功'
                                });
                                this.$router.push("/task/target");
                            }

                        }).finally(() => {
                            this.loading = false;
                        })
                    }
                } else {
                    if (this.form.location.length > 0) {
                        if (this.markList.length == 0) {
                            this.$message.error("请框选需要监测的监控区域");
                        }
                    }
                }
            });
        },
        resetForm() {
            this.form = {
                taskName: '',
                taskLevel: '',
                model: [],
                taskDesc: '',
                date: "",
                selfDate: "",
                timeRange: "",
                duration: "",
                selfDuration: "",
                selfDurationUnit: "",
                location: [],
                detectType: '',
                rateLevel: "0",
                targetNumber: '',
                stayTiming: '',
                stayTimeUnit: '',
                leaveTiming: '',
                leaveTimeUnit: '',
                taskStatus: '',
            };
            this.markList = [];
        },
        handleDetectTypeChange(value) {
            if (value == 1) {
                this.modelPlaceholder = "请选择算法模型(最多三个)";
                this.modelLimit = 3;
                this.markList = [];
            } else {
                this.modelPlaceholder = "请选择算法模型(最多一个)";
                this.modelLimit = 1;
                if (this.form.model.length > 1) {
                    this.form.model = [];
                }
            }
        },
        initDrawReact() {
            var drawArea = document.getElementById("drawArea");
            drawArea.onmousedown = (event) => {
                event.stopPropagation();//阻止事件冒泡
                if (this.form.detectType != 1) {
                    if (this.markList.length < 3) {
                        // 创建矩形框
                        var drawReact = document.createElement('div');
                        drawReact.className = "outside-frame";
                        drawReact.style.boxSizing = 'border-box';
                        drawReact.style.borderColor = "#ff0000";
                        drawReact.style.backgroundColor = "#ff0000";
                        drawReact.style.opacity = '0.5';
                        drawReact.style.position = 'absolute';
                        drawReact.style.display = 'none';
                        document.querySelector(".frame-list").appendChild(drawReact);

                        var areaInfo = drawArea.getBoundingClientRect(); // 返回元素的大小及其相对于视口的位置
                        var reactWidth, reactHeight, reactTop, reactLeft; // 定义矩形框的宽、高、top、left
                        // xy坐标是以画布的左上角为原点，方向矢量以向下和向右为正方向。
                        var beginPoint = {}; // 标记起点
                        var endPoint = {}; // 标记终点

                        drawReact.style.display = 'block'; // 进入画布按下鼠标显示默认矩形框
                        // 鼠标按下的位置作为矩形框的起点，横纵坐标记为 x0, y0
                        beginPoint = { x: event.clientX - areaInfo.x, y: event.clientY - areaInfo.y }
                        // 起点的横坐标
                        var x0 = event.clientX - areaInfo.x;
                        // 起点的纵坐标
                        var y0 = event.clientY - areaInfo.y;

                        // 绑定鼠标事件--onmousemove 
                        document.onmousemove = (event) => {
                            event.stopPropagation();
                            // 终点的横坐标
                            var x1 = event.clientX - areaInfo.x;
                            // 终点的纵坐标
                            var y1 = event.clientY - areaInfo.y;
                            // 对终点相对于起点的位置进行分类讨论
                            if (x1 >= x0 && y1 < y0) {
                                // x 越界处理
                                reactWidth = event.clientX >= areaInfo.right ? areaInfo.width - x0 : x1 - x0;
                                reactLeft = x0;
                                // y 越界处理
                                reactHeight = event.clientY <= areaInfo.top ? y0 : y0 - y1;
                                reactTop = event.clientY <= areaInfo.top ? 0 : y1;
                                // 终点
                                endPoint = { x: x0 + reactWidth, y: y0 - reactHeight };
                            } else if (x1 < x0 && y1 < y0) {
                                // x 越界处理
                                reactWidth = event.clientX <= areaInfo.left ? x0 : x0 - x1;
                                reactLeft = event.clientX <= areaInfo.left ? 0 : x1;
                                // y 越界处理
                                reactHeight = event.clientY <= areaInfo.top ? y0 : y0 - y1;
                                reactTop = event.clientY <= areaInfo.top ? 0 : y1;
                                // 终点
                                endPoint = { x: x0 - reactWidth, y: y0 - reactHeight };
                            } else if (x1 < x0 && y1 >= y0) {
                                // x 越界处理
                                reactWidth = event.clientX <= areaInfo.left ? x0 : x0 - x1;
                                reactLeft = event.clientX <= areaInfo.left ? 0 : x1;
                                // y 越界处理
                                reactHeight = event.clientY >= areaInfo.bottom ? areaInfo.height - y0 : y1 - y0;
                                reactTop = y0;
                                // 终点
                                endPoint = { x: x0 - reactWidth, y: y0 + reactHeight };
                            } else if (x1 >= x0 && y1 >= y0) {
                                // x 越界处理
                                reactWidth = event.clientX >= areaInfo.right ? areaInfo.width - x0 : x1 - x0;
                                reactLeft = x0
                                // y 越界处理
                                reactHeight = event.clientY >= areaInfo.bottom ? areaInfo.height - y0 : y1 - y0;
                                reactTop = y0;
                                // 终点
                                endPoint = { x: x0 + reactWidth, y: y0 + reactHeight };
                            }

                            drawReact.style.width = reactWidth + 'px'; // 宽
                            drawReact.style.height = reactHeight + 'px'; // 高
                            drawReact.style.top = reactTop + 'px';
                            drawReact.style.left = reactLeft + 'px';
                        }

                        // 绑定鼠标事件--onmousedown 
                        document.onmouseup = (event) => {
                            event.stopPropagation();
                            document.onmousemove = null
                            document.onmouseup = null
                            // 回调
                            var options = { reactWidth, reactHeight, reactTop, reactLeft, beginPoint, endPoint }
                            // console.log(options);
                            //如果长宽左边距和上边距都有数据，才显示边框和标签，否则移除边框dom元素
                            if (options.reactWidth && options.reactHeight && options.reactTop && options.reactLeft) {
                                //设置标注框的最小宽高为40px
                                if (options.reactWidth < 40) {
                                    options.reactWidth = 40;
                                }
                                if (options.reactHeight < 40) {
                                    options.reactHeight = 40;
                                }

                                drawReact.remove();
                                var obj = { width: options.reactWidth, height: options.reactHeight, top: options.reactTop, left: options.reactLeft, index: this.markList.length + 1 };
                                this.markList.push(obj);

                                this.$nextTick(() => {
                                    //八个角拉伸事件绑定
                                    this.hornStretchEvent();
                                    //边框拖拽事件
                                    this.frameDragEvent();
                                })

                            } else {
                                drawReact.remove();
                            }

                        }
                    } else {
                        this.$message({
                            type: 'warning',
                            message: '一次性最多框选三个监控区域'
                        });
                    }
                }
            }
        },
        frameDragEvent() {
            var that = this;
            var frameList = document.querySelectorAll(".outside-frame");
            for (var i = 0; i < frameList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    frameList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        if (that.activeFrameIndex != null) {
                            if (that.activeFrameIndex != i) {
                                that.activeFrameIndex = i;
                            }
                        } else {
                            that.activeFrameIndex = i;
                        }

                        var distanceX = event.clientX - frameList[i].offsetLeft;
                        var distanceY = event.clientY - frameList[i].offsetTop;

                        var reactWidth, reactHeight, reactTop, reactLeft; // 定义矩形框的宽、高、top、left

                        document.onmousemove = (event) => {
                            event.stopPropagation();//阻止事件冒泡

                            frameList[i].style.left = event.clientX - distanceX + 'px';
                            frameList[i].style.top = event.clientY - distanceY + 'px';

                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                frameList[i].style.left = 0 + 'px'
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                frameList[i].style.left = maxWidth - domWidth + 'px'
                            }
                            //上边界
                            if (domTop <= 0) {
                                frameList[i].style.top = 0 + 'px'
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                frameList[i].style.top = maxHeight - domHeight + 'px'
                            }

                        }

                        document.onmouseup = () => {
                            event.stopPropagation();//阻止事件冒泡

                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);


                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        };
                    }

                    frameList[i].onclick = (event) => {
                        event.stopPropagation();//阻止事件冒泡
                    }
                }(i, that))
            }

        },
        hornStretchEvent() {
            var frameList = document.querySelectorAll(".outside-frame");//获取所有的标注边框

            var drawArea = document.getElementById("drawArea"); // 获取画布元素
            var areaInfo = drawArea.getBoundingClientRect(); // 返回元素的大小及其相对于视口的位置
            var reactWidth, reactHeight, reactTop, reactLeft; // 定义矩形框的宽、高、top、left
            var that = this;

            //左上角
            var tlHornList = document.querySelectorAll(".tl-horn");
            for (var i = 0; i < tlHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    tlHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = tlHornList[i].parentNode.offsetWidth;
                        var oldHeight = tlHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = tlHornList[i].parentNode.offsetLeft;
                        var oldTop = tlHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;


                        document.onmousemove = (event) => {
                            if (minWidth > oldWidth - (event.clientX - oldX)) {
                                return
                            } else if (minHeight > oldHeight - (event.clientY - oldY)) {
                                return
                            }

                            frameList[i].style.left = oldLeft + (event.clientX - oldX) + 'px';
                            frameList[i].style.top = oldTop + (event.clientY - oldY) + 'px';

                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                if (event.clientX <= oldX) {
                                    frameList[i].style.left = 0 + 'px';
                                } else {
                                    frameList[i].style.width = oldWidth - (event.clientX - oldX) + 'px';
                                }
                            } else {
                                frameList[i].style.width = oldWidth - (event.clientX - oldX) + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                frameList[i].style.left = maxWidth - domWidth + 'px'
                            }
                            //上边界
                            if (domTop <= 0) {
                                if (event.clientY <= oldY) {
                                    frameList[i].style.top = 0 + 'px';
                                } else {
                                    frameList[i].style.height = oldHeight - (event.clientY - oldY) + 'px';
                                }
                            } else {
                                frameList[i].style.height = oldHeight - (event.clientY - oldY) + 'px';
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                frameList[i].style.top = maxHeight - domHeight + 'px'
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })

                        }
                    }
                }(i, that))
            }

            //中上角
            var tcHornList = document.querySelectorAll(".tc-horn");
            for (var i = 0; i < tcHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    tcHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = tcHornList[i].parentNode.offsetWidth;
                        var oldHeight = tcHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = tcHornList[i].parentNode.offsetLeft;
                        var oldTop = tcHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;


                        document.onmousemove = (event) => {
                            if (minWidth > oldWidth - (event.clientX - oldX)) {
                                return
                            } else if (minHeight > oldHeight - (event.clientY - oldY)) {
                                return
                            }

                            frameList[i].style.top = oldTop + (event.clientY - oldY) + 'px';

                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                frameList[i].style.left = 0 + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                frameList[i].style.left = maxWidth - domWidth + 'px'
                            }
                            //上边界
                            if (domTop <= 0) {
                                if (event.clientY <= oldY) {
                                    frameList[i].style.top = 0 + 'px';
                                } else {
                                    frameList[i].style.height = oldHeight - (event.clientY - oldY) + 'px';
                                }
                            } else {
                                frameList[i].style.height = oldHeight - (event.clientY - oldY) + 'px';
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                frameList[i].style.top = maxHeight - domHeight + 'px'
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        }
                    }
                }(i, that))
            }

            //右上角
            var trHornList = document.querySelectorAll(".tr-horn");
            for (var i = 0; i < trHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    trHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = trHornList[i].parentNode.offsetWidth;
                        var oldHeight = trHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = trHornList[i].parentNode.offsetLeft;
                        var oldTop = trHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;

                        document.onmousemove = (event) => {
                            if (minWidth > oldWidth - (oldX - event.clientX)) {
                                return
                            } else if (minHeight > oldHeight - (event.clientY - oldY)) {
                                return
                            }

                            frameList[i].style.top = oldTop + (event.clientY - oldY) + 'px';


                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                frameList[i].style.left = 0 + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                if (event.clientX >= oldX) {
                                    frameList[i].style.left = maxWidth - domWidth + 'px';
                                } else {
                                    frameList[i].style.width = oldWidth + (event.clientX - oldX) + 'px';
                                }
                            } else {
                                frameList[i].style.width = oldWidth + (event.clientX - oldX) + 'px';
                            }
                            //上边界
                            if (domTop <= 0) {
                                if (event.clientY <= oldY) {
                                    frameList[i].style.top = 0 + 'px';
                                } else {
                                    frameList[i].style.height = oldHeight - (event.clientY - oldY) + 'px';
                                }
                            } else {
                                frameList[i].style.height = oldHeight - (event.clientY - oldY) + 'px';
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                frameList[i].style.top = maxHeight - domHeight + 'px'
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        }
                    }
                }(i, that))
            }

            //左下角
            var blHornList = document.querySelectorAll(".bl-horn");
            for (var i = 0; i < blHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    blHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = blHornList[i].parentNode.offsetWidth;
                        var oldHeight = blHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = blHornList[i].parentNode.offsetLeft;
                        var oldTop = blHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;


                        document.onmousemove = (event) => {
                            if (minWidth > oldWidth - (event.clientX - oldX)) {
                                return
                            } else if (minHeight > oldHeight + (event.clientY - oldY)) {
                                return
                            }


                            frameList[i].style.left = oldLeft + (event.clientX - oldX) + 'px';

                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                if (event.clientX <= oldX) {
                                    frameList[i].style.left = 0 + 'px';
                                } else {
                                    frameList[i].style.width = oldWidth - (event.clientX - oldX) + 'px';
                                }
                            } else {
                                frameList[i].style.width = oldWidth - (event.clientX - oldX) + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                frameList[i].style.left = maxWidth - domWidth + 'px'
                            }
                            //上边界
                            if (domTop <= 0) {
                                frameList[i].style.top = 0 + 'px'
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                if (event.clientY >= oldY) {
                                    frameList[i].style.top = maxHeight - domHeight + 'px';
                                } else {
                                    frameList[i].style.height = oldHeight + (event.clientY - oldY) + 'px';
                                }
                            } else {
                                frameList[i].style.height = oldHeight + (event.clientY - oldY) + 'px';
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        }
                    }
                }(i, that))
            }

            //中下角
            var bcHornList = document.querySelectorAll(".bc-horn");
            for (var i = 0; i < bcHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    bcHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = bcHornList[i].parentNode.offsetWidth;
                        var oldHeight = bcHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = bcHornList[i].parentNode.offsetLeft;
                        var oldTop = bcHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;

                        document.onmousemove = (event) => {
                            if (minHeight > oldHeight + (event.clientY - oldY)) {
                                return
                            }

                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                frameList[i].style.left = 0 + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                frameList[i].style.left = maxWidth - domWidth + 'px'
                            }
                            //上边界
                            if (domTop <= 0) {
                                frameList[i].style.top = 0 + 'px'
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                if (event.clientY >= oldY) {
                                    //到达下边界后往下拖
                                    frameList[i].style.top = maxHeight - domHeight + 'px';
                                } else {
                                    //到达下边界后往上拖
                                    frameList[i].style.height = oldHeight + (event.clientY - oldY) + 'px';
                                }
                            } else {
                                frameList[i].style.height = oldHeight + (event.clientY - oldY) + 'px';
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        }
                    }
                }(i, that))
            }
            //右下角
            var brHornList = document.querySelectorAll(".br-horn");
            for (var i = 0; i < brHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    brHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = brHornList[i].parentNode.offsetWidth;
                        var oldHeight = brHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = brHornList[i].parentNode.offsetLeft;
                        var oldTop = brHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;


                        document.onmousemove = (event) => {
                            if (minWidth > oldWidth - (oldX - event.clientX)) {
                                return
                            } else if (minHeight > oldHeight + (event.clientY - oldY)) {
                                return
                            }


                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                frameList[i].style.left = 0 + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                if (event.clientX >= oldX) {
                                    frameList[i].style.left = maxWidth - domWidth + 'px';
                                } else {
                                    frameList[i].style.width = oldWidth + (event.clientX - oldX) + 'px';
                                }
                            } else {
                                frameList[i].style.width = oldWidth + (event.clientX - oldX) + 'px';
                            }
                            //上边界
                            if (domTop <= 0) {
                                frameList[i].style.top = 0 + 'px'
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                if (event.clientY >= oldY) {
                                    frameList[i].style.top = maxHeight - domHeight + 'px';
                                } else {
                                    frameList[i].style.height = oldHeight + (event.clientY - oldY) + 'px';
                                }
                            } else {
                                frameList[i].style.height = oldHeight + (event.clientY - oldY) + 'px';
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        }
                    }
                }(i))
            }


            //左中
            var lcHornList = document.querySelectorAll(".lc-horn");
            for (var i = 0; i < lcHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    lcHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = lcHornList[i].parentNode.offsetWidth;
                        var oldHeight = lcHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = lcHornList[i].parentNode.offsetLeft;
                        var oldTop = lcHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;


                        document.onmousemove = (event) => {
                            if (minWidth > oldWidth - (event.clientX - oldX)) {
                                return
                            } else if (minHeight > oldHeight - (event.clientY - oldY)) {
                                return
                            }


                            frameList[i].style.left = oldLeft + (event.clientX - oldX) + 'px';

                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                if (event.clientX <= oldX) {
                                    frameList[i].style.left = 0 + 'px';
                                } else {
                                    frameList[i].style.width = oldWidth - (event.clientX - oldX) + 'px';
                                }
                            } else {
                                frameList[i].style.width = oldWidth - (event.clientX - oldX) + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                frameList[i].style.left = maxWidth - domWidth + 'px'
                            }
                            //上边界
                            if (domTop <= 0) {
                                frameList[i].style.top = 0 + 'px'
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                frameList[i].style.top = maxHeight - domHeight + 'px'
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        }
                    }
                }(i, that))
            }

            //右中
            var rcHornList = document.querySelectorAll(".rc-horn");
            for (var i = 0; i < rcHornList.length; i++) {
                //在添加事件外部，添加一个自执行函数，每次循环都会执行，同时，通过形参，传入当前循环中的i值。
                (function (i, that) {
                    rcHornList[i].onmousedown = (event) => {
                        event.stopPropagation();//阻止事件冒泡

                        // 获取移动前盒子的宽高
                        var oldWidth = rcHornList[i].parentNode.offsetWidth;
                        var oldHeight = rcHornList[i].parentNode.offsetHeight;

                        // 获取鼠标距离屏幕的left和top值
                        var oldX = event.clientX;
                        var oldY = event.clientY;

                        // 元素相对于最近的父级定位
                        var oldLeft = rcHornList[i].parentNode.offsetLeft;
                        var oldTop = rcHornList[i].parentNode.offsetTop;

                        // 设置最小的宽度
                        var minWidth = 40;
                        var minHeight = 40;


                        document.onmousemove = (event) => {
                            if (minWidth > oldWidth - (oldX - event.clientX)) {
                                return
                            } else if (minHeight > oldHeight + (event.clientY - oldY)) {
                                return
                            }


                            let domWidth = frameList[i].offsetWidth;
                            let domHeight = frameList[i].offsetHeight;
                            let domLeft = frameList[i].offsetLeft;
                            let domTop = frameList[i].offsetTop;
                            let maxWidth = document.getElementById("drawArea").clientWidth;
                            let maxHeight = document.getElementById("drawArea").clientHeight;

                            // 左边界
                            if (domLeft <= 0) {
                                frameList[i].style.left = 0 + 'px';
                            }
                            // 右边界 
                            if ((domLeft + domWidth) >= (maxWidth)) {
                                if (event.clientX >= oldX) {
                                    frameList[i].style.left = maxWidth - domWidth + 'px';
                                } else {
                                    frameList[i].style.width = oldWidth + (event.clientX - oldX) + 'px';
                                }

                            } else {
                                frameList[i].style.width = oldWidth + (event.clientX - oldX) + 'px';
                            }
                            //上边界
                            if (domTop <= 0) {
                                frameList[i].style.top = 0 + 'px'
                            }
                            // 下边界 
                            if (domTop + domHeight >= maxHeight) {
                                frameList[i].style.top = maxHeight - domHeight + 'px'
                            }

                        }

                        document.onmouseup = (event) => {
                            document.onmousemove = null;
                            document.onmouseup = null;

                            reactWidth = Number(frameList[i].style.width.split("px")[0]);
                            reactHeight = Number(frameList[i].style.height.split("px")[0]);
                            reactTop = Number(frameList[i].style.top.split("px")[0]);
                            reactLeft = Number(frameList[i].style.left.split("px")[0]);

                            //拉伸完毕后更新矩形框存储的位置信息
                            var id = frameList[i].getAttribute("id");
                            that.markList.forEach(item => {
                                if (id == item.index) {
                                    item.width = reactWidth;
                                    item.height = reactHeight;
                                    item.top = reactTop;
                                    item.left = reactLeft;
                                }
                            })
                        }
                    }
                }(i, that))
            }
        },
        removeFrame(index) {
            this.markList.splice(index, 1);
        },
        handleClick(event) {
            event.stopPropagation();
            this.activeFrameIndex = null;
        },
        disabledDate(date) {
            // 获取今天的日期
            const today = new Date();
            // 设置时间为今天的23:59:59，即当天的结束时间
            today.setHours(23, 59, 59, 999);

            // 如果选择的日期在今天之前，则禁用选择
            return date && date < today;
        },
        fallback() {
            this.$router.push("/task/target");
        },
    }
};
</script>
<style lang="scss" scoped>
.page-breadcrumb {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.form-container {
    display: flex;

    .left-box {
        width: 45%;

        .el-select,
        .el-cascader {
            width: 100%;
        }

        .medium-input {
            width: 240px;
        }

        .short-input {
            width: 120px;
        }

        .flex-center {
            display: flex;
            align-items: center;
        }

        .form-control-merge {
            display: flex;

            ::v-deep .el-form-item:nth-child(1) .el-input__inner {
                border-top-right-radius: 0;
                border-bottom-right-radius: 0;
            }

            ::v-deep .el-form-item:nth-child(2) .el-form-item__content {
                margin-left: 0 !important;
            }

            ::v-deep .el-form-item:nth-child(2) .el-input__inner {
                border-top-left-radius: 0;
                border-bottom-left-radius: 0;
            }
        }
    }

    .right-box {
        width: calc(55% - 80px);
        margin-left: 80px;

        .top {
            display: flex;
            justify-content: space-between;
            align-items: center;

            .title {
                color: #1b1e26;
                font-size: 15px;

                .tips {
                    font-size: 13.5px;
                    margin-left: 5px;
                    color: #a6a6a6;
                }
            }

            .action {

                .el-button {
                    padding: 3px 10px;
                }
            }
        }

        .screen-container {
            position: relative;

            .box-selection {
                position: relative;

                video {
                    background: #1e1e1e;
                    width: 100%;
                }


                #drawArea {
                    position: absolute;
                    left: 0;
                    top: 0;
                    width: 100%;
                    height: 100%;
                    z-index: 10;

                    .frame-list {
                        width: 100%;
                        height: 100%;

                        .outside-frame {
                            position: absolute;
                            border: 3px solid;
                            background-color: transparent;
                            box-sizing: border-box;

                            .delete-btn {
                                position: absolute;
                                right: -8px;
                                top: -10px;
                                display: inline-block;
                                width: 16px;
                                height: 16px;
                                line-height: 16px;
                                border-radius: 50%;
                                background-color: red;
                                font-size: 13px;
                                text-align: center;
                                color: #fff;
                                user-select: none;
                                cursor: pointer;
                                display: none;
                            }

                            &:hover .delete-btn.inactive {
                                display: inline-block;
                            }

                            .tl-horn,
                            .tc-horn,
                            .tr-horn,
                            .bl-horn,
                            .bc-horn,
                            .br-horn,
                            .lc-horn,
                            .rc-horn {
                                width: 12px;
                                height: 12px;
                                background-color: #fff;
                                border: 1.5px solid #229fe7;
                                box-sizing: border-box;
                                -webkit-user-drag: none;
                                user-select: none;
                            }

                            .tl-horn {
                                position: absolute;
                                left: -7px;
                                top: -7px;
                                cursor: nw-resize;
                            }

                            .tc-horn {
                                position: absolute;
                                left: 50%;
                                transform: translateX(-50%);
                                top: -7px;
                                cursor: n-resize;
                            }

                            .tr-horn {
                                position: absolute;
                                right: -7px;
                                top: -7px;
                                cursor: ne-resize;
                            }

                            .bl-horn {
                                position: absolute;
                                left: -7px;
                                bottom: -7px;
                                cursor: sw-resize;
                            }

                            .bc-horn {
                                position: absolute;
                                left: 50%;
                                transform: translateX(-50%);
                                bottom: -7px;
                                cursor: s-resize;
                            }

                            .br-horn {
                                position: absolute;
                                right: -7px;
                                bottom: -7px;
                                cursor: se-resize;
                            }

                            .lc-horn {
                                position: absolute;
                                left: -7px;
                                top: 50%;
                                transform: translateY(-50%);
                                cursor: w-resize;
                            }

                            .rc-horn {
                                position: absolute;
                                right: -7px;
                                top: 50%;
                                transform: translateY(-50%);
                                cursor: e-resize;
                            }
                        }
                    }
                }
            }

            .screen-controls {
                position: absolute;
                left: 0;
                bottom: 0;
                width: 100%;
                padding: 12px;
                box-sizing: border-box;
                color: #fff;
                z-index: 1;

                div {
                    cursor: pointer;

                    i {
                        margin-right: 6px;
                    }
                }


            }

            .image-empty {
                width: 400px;
                height: 300px;
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

    ::v-deep .label-left .el-form-item__label {
        text-align: left;
    }
}

.bottom-actions {
    position: fixed;
    left: 0;
    bottom: 0;
    width: 100%;
    background: #fff;
    box-shadow: 0 1px 10px 0 rgba(0, 0, 0, .1);
    padding: 10px 20px;
    box-sizing: border-box;
    z-index: 100;
    text-align: right;
}
</style>