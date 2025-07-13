/*
 Navicat Premium Data Transfer

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80036 (8.0.36)
 Source Host           : localhost:3306
 Source Schema         : yys_aivideos

 Target Server Type    : MySQL
 Target Server Version : 80036 (8.0.36)
 File Encoding         : 65001

 Date: 08/07/2025 15:13:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
  `update_time` datetime NULL DEFAULT NULL,
  `model_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 142 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_model
-- ----------------------------
INSERT INTO `ai_model` VALUES (1, 'person', '人物识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (2, 'bicycle', '自行车识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (3, 'car', '汽车识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (4, 'motorcycle', '摩托车识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (5, 'airplane', '飞机识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (6, 'bus', '公共汽车识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (7, 'train', '火车识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (8, 'truck', '卡车识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (9, 'boat', '船只识别', 0, '2024-12-26 19:29:36', '2024-12-26 19:29:36', 'v1.0.0');
INSERT INTO `ai_model` VALUES (10, 'traffic light', '交通信号灯识别', 0, '2025-01-03 15:21:54', '2025-01-03 15:21:54', 'v1.0.0');
INSERT INTO `ai_model` VALUES (11, 'fire hydrant', '消防栓识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (12, 'stop sign', '停车标志识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (13, 'parking meter', '停车计时器识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (14, 'bench', '长椅识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (15, 'bird', '鸟类识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (16, 'fallover', '人员跌倒检测', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (17, 'umbrella', '雨伞识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (18, 'handbag', '手提包识别', 0, '2024-08-01 00:00:00', '2024-12-26 19:29:36', 'v1.0.0');
INSERT INTO `ai_model` VALUES (19, 'suitcase', '手提箱识别', 0, '2024-12-26 19:29:36', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (20, 'kite', '风筝识别', 0, '2025-01-03 15:21:54', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (21, 'bottle', '瓶子识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (22, 'fire', '烟火检测', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (23, 'cup', '杯子识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (24, 'knife', '刀具识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (25, 'chair', '椅子识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (26, 'couch', '沙发识别', 0, '2024-08-01 00:00:00', '2024-12-26 19:29:36', 'v1.0.0');
INSERT INTO `ai_model` VALUES (27, 'potted plant', '盆栽植物识别', 0, '2024-08-01 00:00:00', '2025-01-03 15:21:54', 'v1.0.0');
INSERT INTO `ai_model` VALUES (28, 'bed', '床铺识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (29, 'dining table', '餐桌识别', 0, '2024-12-26 19:29:36', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (30, 'tv', '电视识别', 0, '2025-01-03 15:21:54', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (31, 'laptop', '笔记本电脑识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (32, 'cell phone', '手机识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');
INSERT INTO `ai_model` VALUES (33, 'backpack', '背包识别', 0, '2024-08-01 00:00:00', '2024-08-01 00:00:00', 'v1.0.0');

-- ----------------------------
-- Table structure for ai_model_type
-- ----------------------------
DROP TABLE IF EXISTS `ai_model_type`;
CREATE TABLE `ai_model_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 167 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_user
-- ----------------------------
INSERT INTO `ai_user` VALUES (1, 'admin', 'Stonedt,123', NULL, '0');
INSERT INTO `ai_user` VALUES (5, 'user', 'user', NULL, '0');

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_zlm
-- ----------------------------

-- ----------------------------
-- Table structure for camera_pymsg
-- ----------------------------
DROP TABLE IF EXISTS `camera_pymsg`;
CREATE TABLE `camera_pymsg`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `camera_id` int NOT NULL,
  `pymsg_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `camera_pymsg_ibfk_1`(`camera_id` ASC) USING BTREE,
  INDEX `camera_pymsg_ibfk_2`(`pymsg_id` ASC) USING BTREE,
  CONSTRAINT `camera_pymsg_ibfk_1` FOREIGN KEY (`camera_id`) REFERENCES `ai_camera` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `camera_pymsg_ibfk_2` FOREIGN KEY (`pymsg_id`) REFERENCES `py_msg` (`py_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of camera_pymsg
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
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '检测任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of detection_task
-- ----------------------------

-- ----------------------------
-- Table structure for face_task
-- ----------------------------
DROP TABLE IF EXISTS `face_task`;
CREATE TABLE `face_task`  (
  `face_id` int NOT NULL AUTO_INCREMENT COMMENT '人脸检测任务id',
  `face_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '人脸检测名称',
  `face_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '人脸检测描述',
  `face_level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务等级',
  `face_box` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '框选范围',
  `face_status` int NULL DEFAULT NULL COMMENT '任务状态',
  `face_data_id` int NULL DEFAULT NULL COMMENT '人脸库id',
  `face_data_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '人脸库名称',
  `face_method` int NULL DEFAULT NULL COMMENT '匹配规则',
  `camera_id` int NULL DEFAULT NULL COMMENT '绑定的摄像头id',
  `camera_adress` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '摄像头点位',
  `camera_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '摄像头分组',
  `camera_video` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '视频流',
  `http_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '视频播放地址',
  `stop_sign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务停止标识',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`face_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of face_task
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
  `ocr_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of job_record
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
) ENGINE = InnoDB AUTO_INCREMENT = 179 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of model_plan
-- ----------------------------
INSERT INTO `model_plan` VALUES (1, 1, '人物识别', '画面中具有四肢和躯干的生命体，涵盖不同姿态与衣着的人类个体，无论站立、行走、奔跑或坐卧等动态均能精准定位，可适应复杂场景下的人体特征。', '/planpath/1.png', NULL, NULL, NULL, '公共安全、公安行业、智慧社区、车站、活动管理');
INSERT INTO `model_plan` VALUES (2, 2, '自行车识别', '有两轮、车架、车把和座椅的非机动骑行工具，包含山地车、公路车、折叠车等不同类型，支持动态行驶状态检测，能准确分辨车架结构、车轮形态等细节特征，适用于户外道路等场景的。', '/planpath/2.png', NULL, NULL, NULL, '城市道路、交通治理、智慧停车、购物中心、社区');
INSERT INTO `model_plan` VALUES (3, 3, '汽车识别', '四轮、封闭车身的机动道路车辆，可区分轿车、SUV、MPV 等不同车型，适应白天、夜晚等各种光照条件，能精准车身轮廓、车窗形态及车轮数量等特征，适用于城市交通、停车场等多场景的目标检测。', '/planpath/3.png', NULL, NULL, NULL, '城市道路、交通治理、智慧停车、机场、智慧工地');
INSERT INTO `model_plan` VALUES (4, 4, '摩托车识别', '两轮、发动机驱动的机动交通工具，包括巡航、越野、踏板等不同款式，通过捕捉车身引擎、车轮、座椅等细节特征实现精准，可在道路、街道等场景中对行驶或停放的摩托车进行有效检测。', '/planpath/4.png', NULL, NULL, NULL, '消防行业、公安行业、城市道路、交通治理、智慧停车');
INSERT INTO `model_plan` VALUES (5, 5, '飞机识别', '具有机翼、机身的航空运输工具，可分辨民航客机、直升机、战斗机等不同类别，支持空中多角度，能捕捉机翼形状、机身轮廓及飞行姿态等特征，适用于机场、空域等场景的目标检测与分类。', '/planpath/5.png', NULL, NULL, NULL, '机场、交通枢纽、公安行业、公共安全、城市治理');
INSERT INTO `model_plan` VALUES (6, 6, '公共汽车识别', '包含单层、双层、铰接式等不同结构，能适应城市道路、公交站台等复杂背景环境，通过车身长度、车窗排列、车门位置等特征实现精准检测，适用于公共交通场景的目标任务', '/planpath/6.png', NULL, NULL, NULL, '城市道路、交通枢纽、交通治理、智慧停车、车站');
INSERT INTO `model_plan` VALUES (7, 7, '火车识别', '由多节车厢连接组成的轨道运输工具，包含客运列车、货运列车等不同类型，可检测列车行驶方向、车厢数量及轮廓特征，适用于铁路、火车站等场景的目标检测与追踪。', '/planpath/7.png', NULL, NULL, NULL, '火车站、交通枢纽、基础设施管理、交通治理、城市治理');
INSERT INTO `model_plan` VALUES (8, 8, '卡车识别', '大型载货的商用车辆，可区分厢式货车、平板货车、自卸车等不同车型，通过检测车身结构、车轮数量及货物装载特征实现精准分类，适用于物流园区、公路运输等场景的目标。', '/planpath/8.png', NULL, NULL, NULL, '智慧园区、城市道路、交通治理、基础设施管理、园区');
INSERT INTO `model_plan` VALUES (9, 9, '船只识别', '在水域航行的交通工具，包括货船、客船、游艇等不同类型，支持水面、港口等场景的多角度，能捕捉船体形状、甲板结构及航行状态等特征，实现水域目标的有效检测。', '/planpath/9.png', NULL, NULL, NULL, '交通枢纽、基础设施管理、环境保护、渔业管理、城市治理');
INSERT INTO `model_plan` VALUES (10, 10, '交通信号灯识别', '道路上用于指挥交通的信号装置，可区分红灯、绿灯、黄灯等不同状态，通过检测灯组颜色、亮灭模式及信号灯形状等特征，实现交通状态的智能，适用于城市路口等场景的交通监控。', '/planpath/10.png', NULL, NULL, NULL, '城市道路、交通治理、公共安全、智慧停车、基础设施管理');
INSERT INTO `model_plan` VALUES (11, 11, '消防栓识别', '安装在公共区域的消防供水设备，包含地上式、地下式等不同类型，通过检测栓体形状、阀门结构及周边环境特征，实现消防设施的精准定位，适用于城市街道、建筑物周边等场景的安全监测。', '/planpath/11.png', NULL, NULL, NULL, '消防行业、公共安全、城市治理、基础设施管理');
INSERT INTO `model_plan` VALUES (12, 12, '停车标志识别', '道路上指示停车的交通标志，通常为八角形红底白字，通过检测标志形状、颜色及文字特征实现精准，适用于城市道路、停车场等场景的交通设施检测。', '/planpath/12.png', NULL, NULL, NULL, '交通治理、城市道路、智慧停车、基础设施管理、公共安全');
INSERT INTO `model_plan` VALUES (13, 13, '停车计时器识别', '路边用于计时收费的设备，包含机械式、电子屏式等不同类型，通过检测设备外形、显示屏状态及安装位置等特征，实现城市公共停车区域的智能监控。', '/planpath/13.png', NULL, NULL, NULL, '智慧停车、城市道路、交通治理、基础设施管理、公共安全');
INSERT INTO `model_plan` VALUES (14, 14, '长椅识别', '公园、街道等公共场所供人休息的座椅，包含木质、金属、石质等不同材质，通过检测座椅形状、结构及周边环境特征，实现城市公共设施的智能。', '/planpath/14.png', NULL, NULL, NULL, '城市治理、基础设施管理、社区、园区、智慧园区');
INSERT INTO `model_plan` VALUES (15, 15, '鸟类识别', '具有羽毛、翅膀和喙的飞禽，涵盖麻雀、鸽子、喜鹊等不同种类，通过检测体型、羽毛颜色及飞行姿态等特征，实现自然环境中的鸟类与监测。', '/planpath/15.png', NULL, NULL, NULL, '环境保护、城市治理、园区、活动管理、平安校园');
INSERT INTO `model_plan` VALUES (16, 16, '人员跌倒检测', '实时检测人员跌倒行为，系统能够在检测到人员摔倒时立即发出警示，以便快速采取救援措施，确保受害者安全，特别适用于老年人、病患或高危工作环境。', '/planpath/18.png', NULL, NULL, NULL, '智慧医院、智慧社区、公共安全、工地、平安校园');
INSERT INTO `model_plan` VALUES (17, 17, '雨伞识别', '用于遮雨的工具，由伞面和伞骨组成，撑开后呈圆形，可通过检测开合状态、伞面颜色及骨架结构等特征，在雨天街道、建筑物入口等场景进行。', '/planpath/19.png', NULL, NULL, NULL, '城市道路、购物中心、车站、城市治理、公共安全');
INSERT INTO `model_plan` VALUES (18, 18, '手提包识别', '用于手持的包类，设计多样，有单肩带或手提带，可装随身物品，能通过检测包身形状、提带样式及装饰细节等特征，在商场、街道等场景实现。', '/planpath/20.png', NULL, NULL, NULL, '购物中心、城市道路、公共安全、活动管理、智慧零售');
INSERT INTO `model_plan` VALUES (19, 19, '手提箱识别', '用于旅行的有轮拉杆箱，箱体坚硬，有轮子和拉杆，方便拖拉，可通过检测箱体形状、轮子数量及拉杆状态等特征，在机场、火车站等场景实现。', '/planpath/21.png', NULL, NULL, NULL, '交通枢纽、智慧停车、公共安全、活动管理、基础设施管理');
INSERT INTO `model_plan` VALUES (20, 20, '风筝识别', '自动识别通过长线控制，可通过检测形状、颜色及飞行姿态等特征，在广场、郊外等空旷场景进行。', '/planpath/22.png', NULL, NULL, NULL, '城市治理、活动管理、园区、社区、环境保护');
INSERT INTO `model_plan` VALUES (21, 21, '瓶子识别', '用于盛装液体的容器，有不同材质和形状，可通过检测瓶身轮廓、瓶盖特征及标签纹理等实现，适用于超市、厨房等场景。', '/planpath/23.png', NULL, NULL, NULL, '智慧零售、后厨、基础设施管理、公共安全、智慧园区');
INSERT INTO `model_plan` VALUES (22, 22, '烟火检测', '公共安全在加油站、后厨以及公共场所等对卫生和安全要求较高的区域，实施烟火检测系统进行实时监控，确保及时检测并防范潜在的火灾风险。通过安装高灵敏度的烟火传感器和摄像头，结合图像识别技术，能够快速识别并报警，从而有效预防和减少火灾事故的发生。', '/planpath/24.png', NULL, NULL, NULL, '智慧医院 后厨 化工生产 智慧园区 园区 公安消防 消防行业');
INSERT INTO `model_plan` VALUES (23, 23, '杯子识别', '用于盛装液体的容器，有多种材质和样式，可通过检测杯口形状、杯身纹理及有无杯把等特征，在厨房、办公室等场景实现。', '/planpath/25.png', NULL, NULL, NULL, '后厨、智慧零售、办公室、基础设施管理、家庭');
INSERT INTO `model_plan` VALUES (24, 24, '刀具识别', '切割工具，由刀刃和刀柄组成，可通过检测形状、长度及使用状态等特征，在厨房、餐厅等场景进行，需注意安全场景下的特殊需求。', '/planpath/26.png', NULL, NULL, NULL, '后厨、公共安全、餐厅、智慧零售、活动管理');
INSERT INTO `model_plan` VALUES (25, 25, '椅子识别', '供人坐的家具，有椅面、椅背和椅腿，可通过检测结构、材质及使用状态等特征，在会议室、餐厅等场景实现。', '/planpath/27.png', NULL, NULL, NULL, '会议室、餐厅');
INSERT INTO `model_plan` VALUES (26, 26, '沙发识别', '多人坐的沙发家具，有多个座位和靠背，可通过检测形状、尺寸及与周围环境的关系等特征，在客厅、休息室等场景进行。', '/planpath/28.png', NULL, NULL, NULL, '客厅、休息室、智慧社区、活动管理');
INSERT INTO `model_plan` VALUES (27, 27, '盆栽植物识别', '种植在花盆中的植物，有茎叶和花盆，可通过检测植物形态、叶子纹理及花盆形状等特征，在室内外装饰场景进行。', '/planpath/29.png', NULL, NULL, NULL, '园区、智慧社区、平安校园');
INSERT INTO `model_plan` VALUES (28, 28, '床铺识别', '供人睡觉的家具，有床垫和床架，可通过检测形状、尺寸及床上用品状态等特征，在卧室等场景实现。', '/planpath/30.png', NULL, NULL, NULL, '智慧医院、智慧社区、基础设施管理、平安校园');
INSERT INTO `model_plan` VALUES (29, 29, '餐桌识别', '用餐家具，有桌面和桌腿，可通过检测形状、尺寸及与餐椅的组合关系等特征，在餐厅、厨房等场景进行。', '/planpath/31.png', NULL, NULL, NULL, '餐厅、后厨、活动管理');
INSERT INTO `model_plan` VALUES (30, 30, '电视识别', '播放图像和声音的设备，有屏幕和外壳，可通过检测屏幕形状、边框特征及播放内容状态等特征，在客厅、卧室等场景进行。', '/planpath/32.png', NULL, NULL, NULL, '智慧社区、基础设施管理、活动管理');
INSERT INTO `model_plan` VALUES (31, 31, '笔记本电脑识别', '可携带的计算机设备，有屏幕和键盘，可通过检测开合状态、屏幕尺寸及使用状态等特征，在办公室、图书馆等场景进行。', '/planpath/33.png', NULL, NULL, NULL, '智慧园区、基础设施管理、平安校园');
INSERT INTO `model_plan` VALUES (32, 32, '手机识别', '便携式通信设备，有屏幕和机身，可通过检测形状、尺寸及使用状态（如是否手持）等特征，在各种场景中进行。', '/planpath/34.png', NULL, NULL, NULL, '智慧零售、城市治理、智慧工地');
INSERT INTO `model_plan` VALUES (33, 33, '背包识别', '用于背负的包类，有双肩带设计，可装书本、衣物等物品，能通过检测包身形状、肩带结构及材质纹理等特征，实现校园、户外等场景下的背包。', '/planpath/35.png', NULL, NULL, NULL, '平安校园、公共安全、活动管理');

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ocr_task
-- ----------------------------

-- ----------------------------
-- Table structure for py_msg
-- ----------------------------
DROP TABLE IF EXISTS `py_msg`;
CREATE TABLE `py_msg`  (
  `py_id` int NOT NULL AUTO_INCREMENT COMMENT '从节点id',
  `py_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '节点名称',
  `py_system` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '节点操作系统',
  `py_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '节点ip',
  `py_port` int NULL DEFAULT NULL COMMENT '节点端口号',
  `py_isuse_cpu` double NULL DEFAULT NULL COMMENT 'cpu使用率',
  `py_cpu_memory` double NULL DEFAULT NULL COMMENT 'cpu内存',
  `py_cpu_usmemory` double NULL DEFAULT NULL COMMENT 'cpu已使用内存',
  `py_isuse_gpu` double NULL DEFAULT NULL COMMENT 'gpu使用率',
  `py_gpu_memory` double NULL DEFAULT NULL COMMENT 'gpu内存',
  `py_gpu_usmemory` double NULL DEFAULT NULL COMMENT 'gpu已使用内存',
  `py_isuse_memory` double NULL DEFAULT NULL COMMENT '已使用内存',
  `py_memory` double NULL DEFAULT NULL COMMENT '全部内存',
  `py_create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `py_detection_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '检测时间',
  `py_status` int NULL DEFAULT NULL COMMENT '计算节点状态',
  `is_use` int NULL DEFAULT NULL COMMENT '计算节点是否使用',
  PRIMARY KEY (`py_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of py_msg
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `qrtz_blob_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `BLOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `SCHED_NAME`(`SCHED_NAME` ASC, `TRIGGER_NAME` ASC, `TRIGGER_GROUP` ASC) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `qrtz_calendars`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `qrtz_cron_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CRON_EXPRESSION` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FFIRED_TRIGGERS`;
CREATE TABLE `qrtz_fired_triggers`  (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `qrtz_job_details`  (
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `qrtz_locks`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `LOCK_NAME` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `qrtz_scheduler_state`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `INSTANCE_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint NOT NULL,
  `CHECKIN_INTERVAL` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `qrtz_simple_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `REPEAT_COUNT` bigint NOT NULL,
  `REPEAT_INTERVAL` bigint NOT NULL,
  `TIMES_TRIGGERED` bigint NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `qrtz_simprop_triggers`  (
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
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------


-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `qrtz_triggers`  (
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
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for t_authorize
-- ----------------------------
DROP TABLE IF EXISTS `t_authorize`;
CREATE TABLE `t_authorize`  (
  `authorize_str` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_authorize
-- ----------------------------

-- ----------------------------
-- Table structure for track_task
-- ----------------------------
DROP TABLE IF EXISTS `track_task`;
CREATE TABLE `track_task`  (
  `track_id` int NOT NULL AUTO_INCREMENT COMMENT '跟踪任务id',
  `track_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '跟踪任务名称',
  `track_msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '跟踪任务描述',
  `track_level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务等级',
  `track_box` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '框选范围',
  `track_detection_range` int NULL DEFAULT NULL COMMENT '检测范围',
  `track_status` int NULL DEFAULT NULL COMMENT '任务状态',
  `track_frequency` int NULL DEFAULT NULL COMMENT '统计频率',
  `frequency_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '统计时长单位',
  `target_number` int NULL DEFAULT NULL COMMENT '目标数量\r\n',
  `target_rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计数规则（> = <）',
  `track_model_id` int NULL DEFAULT NULL COMMENT '检测目标（模型id）',
  `track_model_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型名称',
  `model_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型地址',
  `num_method` int NULL DEFAULT NULL COMMENT '计数方式',
  `camera_id` int NULL DEFAULT NULL COMMENT '绑定的摄像头id',
  `camera_adress` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '摄像头点位',
  `camera_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '摄像头分组',
  `camera_video` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '视频流',
  `http_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '视频播放地址',
  `stop_sign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务停止标识',
  `createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`track_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of track_task
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;


-- Quartz 表重命名为大写形式，避免大小写敏感导致的找不到表错误
SET FOREIGN_KEY_CHECKS = 0;

RENAME TABLE qrtz_blob_triggers TO QRTZ_BLOB_TRIGGERS;
RENAME TABLE qrtz_calendars TO QRTZ_CALENDARS;
RENAME TABLE qrtz_cron_triggers TO QRTZ_CRON_TRIGGERS;
RENAME TABLE qrtz_fired_triggers TO QRTZ_FIRED_TRIGGERS;
RENAME TABLE qrtz_job_details TO QRTZ_JOB_DETAILS;
RENAME TABLE qrtz_locks TO QRTZ_LOCKS;
RENAME TABLE qrtz_paused_trigger_grps TO QRTZ_PAUSED_TRIGGER_GRPS;
RENAME TABLE qrtz_scheduler_state TO QRTZ_SCHEDULER_STATE;
RENAME TABLE qrtz_simple_triggers TO QRTZ_SIMPLE_TRIGGERS;
RENAME TABLE qrtz_simprop_triggers TO QRTZ_SIMPROP_TRIGGERS;
RENAME TABLE qrtz_triggers TO QRTZ_TRIGGERS;

SET FOREIGN_KEY_CHECKS = 1;

