/*
 Navicat Premium Data Transfer

 Source Server         : 服务器
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41-0ubuntu0.20.04.1)
 Source Host           : 192.168.71.25:3306
 Source Schema         : yys_aivideo

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41-0ubuntu0.20.04.1)
 File Encoding         : 65001

 Date: 01/03/2025 16:39:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for QRTZ_BLOB_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `BLOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `SCHED_NAME`(`SCHED_NAME` ASC, `TRIGGER_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CALENDARS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CRON_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CRON_EXPRESSION` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_FIRED_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ENTRY_ID` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `INSTANCE_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `FIRED_TIME` bigint NOT NULL,
  `SCHED_TIME` bigint NOT NULL,
  `PRIORITY` int NOT NULL,
  `STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `ENTRY_ID`) USING BTREE,
  INDEX `IDX_QRTZ_FT_TRIG_INST_NAME`(`SCHED_NAME` ASC, `INSTANCE_NAME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY`(`SCHED_NAME` ASC, `INSTANCE_NAME` ASC, `REQUESTS_RECOVERY` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_J_G`(`SCHED_NAME` ASC, `JOB_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_JG`(`SCHED_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_T_G`(`SCHED_NAME` ASC, `TRIGGER_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_FT_TG`(`SCHED_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_JOB_DETAILS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_DURABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_J_REQ_RECOVERY`(`SCHED_NAME` ASC, `REQUESTS_RECOVERY` ASC) USING BTREE,
  INDEX `IDX_QRTZ_J_GRP`(`SCHED_NAME` ASC, `JOB_GROUP` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_LOCKS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `LOCK_NAME` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------
INSERT INTO `QRTZ_LOCKS` VALUES ('quartzScheduler', 'TRIGGER_ACCESS');

-- ----------------------------
-- Table structure for QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SCHEDULER_STATE
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `INSTANCE_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint NOT NULL,
  `CHECKIN_INTERVAL` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `REPEAT_COUNT` bigint NOT NULL,
  `REPEAT_INTERVAL` bigint NOT NULL,
  `TIMES_TRIGGERED` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `STR_PROP_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `STR_PROP_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `STR_PROP_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `INT_PROP_1` int NULL DEFAULT NULL,
  `INT_PROP_2` int NULL DEFAULT NULL,
  `LONG_PROP_1` bigint NULL DEFAULT NULL,
  `LONG_PROP_2` bigint NULL DEFAULT NULL,
  `DEC_PROP_1` decimal(13, 4) NULL DEFAULT NULL,
  `DEC_PROP_2` decimal(13, 4) NULL DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PREV_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PRIORITY` int NULL DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `START_TIME` bigint NOT NULL,
  `END_TIME` bigint NULL DEFAULT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `MISFIRE_INSTR` smallint NULL DEFAULT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_T_J`(`SCHED_NAME` ASC, `JOB_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_JG`(`SCHED_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_C`(`SCHED_NAME` ASC, `CALENDAR_NAME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_G`(`SCHED_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_STATE`(`SCHED_NAME` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_N_STATE`(`SCHED_NAME` ASC, `TRIGGER_NAME` ASC, `TRIGGER_GROUP` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_N_G_STATE`(`SCHED_NAME` ASC, `TRIGGER_GROUP` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NEXT_FIRE_TIME`(`SCHED_NAME` ASC, `NEXT_FIRE_TIME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST`(`SCHED_NAME` ASC, `TRIGGER_STATE` ASC, `NEXT_FIRE_TIME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_MISFIRE`(`SCHED_NAME` ASC, `MISFIRE_INSTR` ASC, `NEXT_FIRE_TIME` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE`(`SCHED_NAME` ASC, `MISFIRE_INSTR` ASC, `NEXT_FIRE_TIME` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP`(`SCHED_NAME` ASC, `MISFIRE_INSTR` ASC, `NEXT_FIRE_TIME` ASC, `TRIGGER_GROUP` ASC, `TRIGGER_STATE` ASC) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for ai_camera
-- ----------------------------
DROP TABLE IF EXISTS `ai_camera`;
CREATE TABLE `ai_camera`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `camera_id` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `camera_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `camera_group` int NULL DEFAULT NULL,
  `camera_width` int NULL DEFAULT NULL,
  `camera_height` int NULL DEFAULT NULL,
  `video_scale` double NULL DEFAULT NULL,
  `video_rate` int NULL DEFAULT NULL,
  `camera_protocol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `camera_status` int NULL DEFAULT NULL,
  `working_time` date NULL DEFAULT NULL,
  `last_time` datetime NULL DEFAULT NULL,
  `ip_address` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `camera_port` int NULL DEFAULT NULL,
  `video_streaming` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type_input` int NULL DEFAULT NULL,
  `camera_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `zlm_id` int NULL DEFAULT NULL,
  `zlm_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_camera
-- ----------------------------

-- ----------------------------
-- Table structure for ai_model
-- ----------------------------
DROP TABLE IF EXISTS `ai_model`;
CREATE TABLE `ai_model`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '模型id',
  `model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `model_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `model_source` int NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT NULL,
  `model_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  `model_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_model
-- ----------------------------
INSERT INTO `ai_model` VALUES (1, 'FallDetect.pt', '人体跌倒识别', 0, '2024-08-01 00:00:00', 'upweights', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (2, 'safeHat.pt', '佩戴安全帽识别', 0, '2024-08-01 00:00:00', 'upweights', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (3, 'Mask.pt', '口罩识别', 0, '2024-08-01 00:00:00', 'upweights', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (4, 'SafetyGloves.pt', '安全手套识别', 0, '2024-08-01 00:00:00', 'upweights', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (5, 'smoken.pt', '吸烟监测', 0, '2024-08-01 00:00:00', 'upweights', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (6, 'truck.pt', '大货车监测', 0, '2024-08-01 00:00:00', 'upweights', '2024-08-01 00:00:00', 'v1.0.0');


-- ----------------------------
-- Table structure for ai_model_type
-- ----------------------------
DROP TABLE IF EXISTS `ai_model_type`;
CREATE TABLE `ai_model_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_model_type
-- ----------------------------
INSERT INTO `ai_model_type` VALUES (1, '智慧工地');
INSERT INTO `ai_model_type` VALUES (2, '公安行业');
INSERT INTO `ai_model_type` VALUES (3, '智慧医院');
INSERT INTO `ai_model_type` VALUES (4, '地铁站');
INSERT INTO `ai_model_type` VALUES (5, '交通枢纽');
INSERT INTO `ai_model_type` VALUES (6, '城市道路');
INSERT INTO `ai_model_type` VALUES (7, '社区');
INSERT INTO `ai_model_type` VALUES (8, '园区');
INSERT INTO `ai_model_type` VALUES (9, '城市治理');
INSERT INTO `ai_model_type` VALUES (10, '交通治理');
INSERT INTO `ai_model_type` VALUES (11, '平安校园');
INSERT INTO `ai_model_type` VALUES (12, '智慧零售');
INSERT INTO `ai_model_type` VALUES (13, '小区');
INSERT INTO `ai_model_type` VALUES (14, '写字楼');
INSERT INTO `ai_model_type` VALUES (15, '消防行业');
INSERT INTO `ai_model_type` VALUES (16, '购物中心');
INSERT INTO `ai_model_type` VALUES (17, '车站');
INSERT INTO `ai_model_type` VALUES (18, '化工生产');
INSERT INTO `ai_model_type` VALUES (19, '智慧电网');
INSERT INTO `ai_model_type` VALUES (20, '监控室');
INSERT INTO `ai_model_type` VALUES (21, '后厨');
INSERT INTO `ai_model_type` VALUES (22, '火车站');
INSERT INTO `ai_model_type` VALUES (23, '娱乐场所');
INSERT INTO `ai_model_type` VALUES (24, '机场');
INSERT INTO `ai_model_type` VALUES (25, '电焊车间');
INSERT INTO `ai_model_type` VALUES (33, '化工重工');
INSERT INTO `ai_model_type` VALUES (34, '消防');
INSERT INTO `ai_model_type` VALUES (35, '工地');
INSERT INTO `ai_model_type` VALUES (36, '公安消防');
INSERT INTO `ai_model_type` VALUES (37, '公共安全');
INSERT INTO `ai_model_type` VALUES (38, '智慧社区');
INSERT INTO `ai_model_type` VALUES (39, '环境保护');
INSERT INTO `ai_model_type` VALUES (40, '智慧园区');
INSERT INTO `ai_model_type` VALUES (41, '基础设施管理');
INSERT INTO `ai_model_type` VALUES (42, '活动管理');
INSERT INTO `ai_model_type` VALUES (43, '渔业管理');
INSERT INTO `ai_model_type` VALUES (44, '智慧停车');

-- ----------------------------
-- Table structure for ai_modeltotype
-- ----------------------------
DROP TABLE IF EXISTS `ai_modeltotype`;
CREATE TABLE `ai_modeltotype`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_id` int NULL DEFAULT NULL,
  `model_type_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 167 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_modeltotype
-- ----------------------------
INSERT INTO `ai_modeltotype` VALUES (71, 1, 1);
INSERT INTO `ai_modeltotype` VALUES (72, 2, 2);
INSERT INTO `ai_modeltotype` VALUES (73, 2, 3);
INSERT INTO `ai_modeltotype` VALUES (74, 2, 4);
INSERT INTO `ai_modeltotype` VALUES (75, 2, 5);
INSERT INTO `ai_modeltotype` VALUES (76, 2, 6);
INSERT INTO `ai_modeltotype` VALUES (77, 2, 7);
INSERT INTO `ai_modeltotype` VALUES (78, 2, 8);
INSERT INTO `ai_modeltotype` VALUES (79, 3, 6);
INSERT INTO `ai_modeltotype` VALUES (80, 3, 7);
INSERT INTO `ai_modeltotype` VALUES (81, 4, 1);
INSERT INTO `ai_modeltotype` VALUES (82, 4, 9);
INSERT INTO `ai_modeltotype` VALUES (83, 4, 10);
INSERT INTO `ai_modeltotype` VALUES (84, 4, 5);
INSERT INTO `ai_modeltotype` VALUES (85, 4, 6);
INSERT INTO `ai_modeltotype` VALUES (86, 5, 1);
INSERT INTO `ai_modeltotype` VALUES (87, 5, 11);
INSERT INTO `ai_modeltotype` VALUES (88, 5, 12);
INSERT INTO `ai_modeltotype` VALUES (89, 5, 13);
INSERT INTO `ai_modeltotype` VALUES (90, 5, 14);
INSERT INTO `ai_modeltotype` VALUES (91, 6, 11);
INSERT INTO `ai_modeltotype` VALUES (92, 6, 15);
INSERT INTO `ai_modeltotype` VALUES (93, 6, 13);
INSERT INTO `ai_modeltotype` VALUES (94, 6, 16);
INSERT INTO `ai_modeltotype` VALUES (95, 6, 17);
INSERT INTO `ai_modeltotype` VALUES (96, 6, 14);
INSERT INTO `ai_modeltotype` VALUES (97, 7, 9);
INSERT INTO `ai_modeltotype` VALUES (98, 7, 13);
INSERT INTO `ai_modeltotype` VALUES (99, 7, 14);
INSERT INTO `ai_modeltotype` VALUES (100, 7, 8);
INSERT INTO `ai_modeltotype` VALUES (101, 8, 11);
INSERT INTO `ai_modeltotype` VALUES (102, 8, 2);
INSERT INTO `ai_modeltotype` VALUES (103, 8, 15);
INSERT INTO `ai_modeltotype` VALUES (104, 8, 13);
INSERT INTO `ai_modeltotype` VALUES (105, 8, 14);
INSERT INTO `ai_modeltotype` VALUES (106, 8, 8);
INSERT INTO `ai_modeltotype` VALUES (107, 8, 18);
INSERT INTO `ai_modeltotype` VALUES (108, 9, 11);
INSERT INTO `ai_modeltotype` VALUES (109, 9, 2);
INSERT INTO `ai_modeltotype` VALUES (110, 9, 15);
INSERT INTO `ai_modeltotype` VALUES (111, 9, 13);
INSERT INTO `ai_modeltotype` VALUES (112, 9, 14);
INSERT INTO `ai_modeltotype` VALUES (113, 10, 19);
INSERT INTO `ai_modeltotype` VALUES (114, 10, 18);
INSERT INTO `ai_modeltotype` VALUES (115, 11, 6);
INSERT INTO `ai_modeltotype` VALUES (116, 11, 7);
INSERT INTO `ai_modeltotype` VALUES (117, 12, 9);
INSERT INTO `ai_modeltotype` VALUES (118, 13, 18);
INSERT INTO `ai_modeltotype` VALUES (119, 14, 20);
INSERT INTO `ai_modeltotype` VALUES (120, 15, 20);
INSERT INTO `ai_modeltotype` VALUES (121, 15, 21);
INSERT INTO `ai_modeltotype` VALUES (122, 16, 20);
INSERT INTO `ai_modeltotype` VALUES (123, 17, 11);
INSERT INTO `ai_modeltotype` VALUES (124, 17, 3);
INSERT INTO `ai_modeltotype` VALUES (125, 17, 12);
INSERT INTO `ai_modeltotype` VALUES (126, 17, 22);
INSERT INTO `ai_modeltotype` VALUES (127, 17, 20);
INSERT INTO `ai_modeltotype` VALUES (128, 18, 20);
INSERT INTO `ai_modeltotype` VALUES (129, 19, 9);
INSERT INTO `ai_modeltotype` VALUES (130, 20, 10);
INSERT INTO `ai_modeltotype` VALUES (131, 21, 11);
INSERT INTO `ai_modeltotype` VALUES (132, 21, 2);
INSERT INTO `ai_modeltotype` VALUES (133, 21, 23);
INSERT INTO `ai_modeltotype` VALUES (134, 22, 9);
INSERT INTO `ai_modeltotype` VALUES (135, 23, 12);
INSERT INTO `ai_modeltotype` VALUES (136, 23, 22);
INSERT INTO `ai_modeltotype` VALUES (137, 23, 20);
INSERT INTO `ai_modeltotype` VALUES (138, 24, 22);
INSERT INTO `ai_modeltotype` VALUES (139, 24, 17);
INSERT INTO `ai_modeltotype` VALUES (140, 25, 19);
INSERT INTO `ai_modeltotype` VALUES (141, 26, 19);
INSERT INTO `ai_modeltotype` VALUES (142, 27, 7);
INSERT INTO `ai_modeltotype` VALUES (143, 28, 3);
INSERT INTO `ai_modeltotype` VALUES (144, 28, 24);
INSERT INTO `ai_modeltotype` VALUES (145, 29, 16);
INSERT INTO `ai_modeltotype` VALUES (146, 29, 24);
INSERT INTO `ai_modeltotype` VALUES (147, 30, 5);
INSERT INTO `ai_modeltotype` VALUES (148, 31, 21);
INSERT INTO `ai_modeltotype` VALUES (149, 32, 4);
INSERT INTO `ai_modeltotype` VALUES (150, 32, 17);
INSERT INTO `ai_modeltotype` VALUES (151, 32, 25);
INSERT INTO `ai_modeltotype` VALUES (152, 33, 9);
INSERT INTO `ai_modeltotype` VALUES (153, 33, 10);
INSERT INTO `ai_modeltotype` VALUES (154, 33, 5);
INSERT INTO `ai_modeltotype` VALUES (155, 34, 9);
INSERT INTO `ai_modeltotype` VALUES (156, 34, 10);
INSERT INTO `ai_modeltotype` VALUES (157, 35, 2);
INSERT INTO `ai_modeltotype` VALUES (158, 35, 20);
INSERT INTO `ai_modeltotype` VALUES (159, 36, 9);
INSERT INTO `ai_modeltotype` VALUES (160, 36, 2);
INSERT INTO `ai_modeltotype` VALUES (161, 36, 15);
INSERT INTO `ai_modeltotype` VALUES (162, 36, 6);
INSERT INTO `ai_modeltotype` VALUES (163, 36, 8);
INSERT INTO `ai_modeltotype` VALUES (164, 37, 9);
INSERT INTO `ai_modeltotype` VALUES (165, 37, 2);
INSERT INTO `ai_modeltotype` VALUES (166, 37, 10);

-- ----------------------------
-- Table structure for ai_user
-- ----------------------------
DROP TABLE IF EXISTS `ai_user`;
CREATE TABLE `ai_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_pwd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_emial` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `permissions` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_user
-- ----------------------------
INSERT INTO `ai_user` VALUES (1, 'admin', 'Stonedt,123', NULL, '0');
INSERT INTO `ai_user` VALUES (2, 'user', 'user', NULL, '1');

INSERT INTO `ai_user` VALUES (3, 'guard', 'guard123', NULL, '1');


-- ----------------------------
-- Table structure for ai_zlm
-- ----------------------------
DROP TABLE IF EXISTS `ai_zlm`;
CREATE TABLE `ai_zlm`  (
  `zlm_id` int NOT NULL AUTO_INCREMENT COMMENT 'zlm视频流主键',
  `camera_id` int NOT NULL COMMENT '绑定的摄像头id',
  `zlm_vhost` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '添加的流的虚拟主机',
  `zlm_app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '添加流的应用名',
  `zlm_stream` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '添加的流的id名',
  `zlm_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '视频标识',
  `zlm_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '视频播放地址',
  `video_stream` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '视频流',
  PRIMARY KEY (`zlm_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_zlm
-- ----------------------------

-- ----------------------------
-- Table structure for camera_sector
-- ----------------------------
DROP TABLE IF EXISTS `camera_sector`;
CREATE TABLE `camera_sector`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of camera_sector
-- ----------------------------


-- ----------------------------
-- Table structure for detection_task
-- ----------------------------
DROP TABLE IF EXISTS `detection_task`;
CREATE TABLE `detection_task`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `task_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务ID',
  `task_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `camera_position` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '摄像头位置',
  `camera_id` int NULL DEFAULT NULL COMMENT '摄像头id',
  `algorithm_model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '算法模型',
  `task_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '任务描述',
  `priority` int NULL DEFAULT NULL COMMENT '任务优先级',
  `alert_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警方式',
  `alert_level` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警严重程度',
  `notification_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电子邮件地址',
  `target_count_threshold` int NULL DEFAULT NULL COMMENT '触发告警的目标数量阈值',
  `target_dwell_time` int NULL DEFAULT NULL COMMENT '目标停留的最短时间，用于告警触发',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` int NULL DEFAULT NULL COMMENT '任务当前的状态',
  `task_tagging` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务标识',
  `ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '多选模型id',
  `frame_select` int NULL DEFAULT NULL,
  `frame_boxs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `target_number` int NULL DEFAULT NULL COMMENT '目标数量',
  `frame_interval` int NULL DEFAULT NULL COMMENT '抽帧\r\n',
  `set_time` int NULL DEFAULT NULL COMMENT '等待时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '检测任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of detection_task
-- ----------------------------

-- ----------------------------
-- Table structure for flyway_schema_history
-- ----------------------------
DROP TABLE IF EXISTS `flyway_schema_history`;
CREATE TABLE `flyway_schema_history`  (
  `installed_rank` int NOT NULL,
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `script` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `checksum` int NULL DEFAULT NULL,
  `installed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`) USING BTREE,
  INDEX `flyway_schema_history_s_idx`(`success` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of flyway_schema_history
-- ----------------------------

-- ----------------------------
-- Table structure for job_record
-- ----------------------------
DROP TABLE IF EXISTS `job_record`;
CREATE TABLE `job_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `job_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `job_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `chat_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `f` bigint NOT NULL,
  `a` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `allatorixdemo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `e` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `h` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `m` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `d` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ocr_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of job_record
-- ----------------------------

-- ----------------------------
-- Table structure for mediamtx_streams
-- ----------------------------
DROP TABLE IF EXISTS `mediamtx_streams`;
CREATE TABLE `mediamtx_streams`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `camera_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `stream_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mediamtx_streams
-- ----------------------------

-- ----------------------------
-- Table structure for model_plan
-- ----------------------------
DROP TABLE IF EXISTS `model_plan`;
CREATE TABLE `model_plan`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_id` int NULL DEFAULT NULL COMMENT '模型id',
  `model_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型名称',
  `model_explain` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '模型描述',
  `imgs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '概念图',
  `img_detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缩略图',
  `img_test` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '测试图',
  `test_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '测试结果',
  `scene` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '应用场景标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of model_plan
-- ----------------------------

INSERT INTO `model_plan` VALUES (1, 1, '人体跌倒识别', '实时检测人员跌倒行为，系统能够在检测到人员摔倒时立即发出警示，以便快速采取救援措施，确保受害者安全，特别适用于老年人、病患或高危工作环境。', '/planpath/img_falldown.jpg', null, null , null , '智慧工地');
INSERT INTO `model_plan` VALUES (2, 2, '佩戴安全帽识别', '自动识别建筑工地等场景的现场作业人员的安全帽佩戴情况,常见红白蓝黄4种颜色安全帽均能识别。', '/planpath/hard_hat.jpg' , null, null , null , '智慧工地');
INSERT INTO `model_plan` VALUES (3, 3, '口罩识别', '对如医院、后厨等对卫生要求较高的人员工作场所，有效监测工作人员口罩佩戴情况，检测到未佩戴者立即标注并进行提醒。', '/planpath/mask.jpg' , null, null , null , '智慧工地');
INSERT INTO `model_plan` VALUES (4, 4, '安全手套识别', '在能源和电力园区等关键作业环境中，利用深度学习算法对作业人员进行智能监控，以确保他们在操作带电设备时正确穿戴绝缘手套，一旦发现违规未穿戴情况，系统将立即发出警报，提醒安全监管人员及时介入，保障作业安全。。', '/planpath/glove.jpg' , null, null , null , '智慧工地');
INSERT INTO `model_plan` VALUES (5, 5, '吸烟监测', '在加油站、后厨以及公共场所等对卫生和安全要求较高的区域，实施抽烟识别系统进行实时监控，确保及时检测并防范潜在的火灾风险和卫生问题。。', '/planpath/smoken.jpg' , null, null , null , '智慧工地');
INSERT INTO `model_plan` VALUES (6, 6, '大货车监测', '自动识别和检测限定区域内是否有渣土车、大货车出现，以极大地提高城市管理的效率和响应速度，同时对于环境保护和交通安全也有着积极的影响。。', '/planpath/truck.jpg' , null, null , null , '智慧工地');

-- ----------------------------
-- Table structure for ocr_task
-- ----------------------------
DROP TABLE IF EXISTS `ocr_task`;
CREATE TABLE `ocr_task`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ocric',
  `ocr_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ocr_describe` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `ocr_level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `has_box` int NULL DEFAULT NULL,
  `ocr_box` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ocr_status` int NULL DEFAULT NULL,
  `ocr_keyword` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ocr_shield` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ocr_frequency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `camera_id` int NULL DEFAULT NULL,
  `camera_adress` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `camera_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `camera_video` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `http_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `job_sign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ocr_task
-- ----------------------------

-- ----------------------------
-- Table structure for t_authorize
-- ----------------------------
DROP TABLE IF EXISTS `t_authorize`;
CREATE TABLE `t_authorize`  (
                                `authorize_str` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_authorize
-- ----------------------------
INSERT INTO `t_authorize` VALUES ('V8PXh6KyVzdw8qwNnQlXttTuSwT+HDilZAh/VONzP24M5hVuOMD9NZSVTxmn1z2RHYd8f1dgDk//5pN8dZcS+Gs3PJU+ttk5KZeGm3eX+T/fDDFx3h4MDPCykg3QXl257H2H6kSSNkYqeJBelxmCD9uQ11Sv2DO3xjKy65sB/8Q=');

SET FOREIGN_KEY_CHECKS = 1;