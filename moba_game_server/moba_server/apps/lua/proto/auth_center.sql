/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50168
Source Host           : localhost:3306
Source Database       : auth_center

Target Server Type    : MYSQL
Target Server Version : 50168
File Encoding         : 65001

Date: 2019-07-10 22:40:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for uinfo
-- ----------------------------
DROP TABLE IF EXISTS `uinfo`;
CREATE TABLE `uinfo` (
  `uid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '玩家唯一的UID号,仅供服务端识别使用',
  `brandid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家id，客户端使用，区别玩家',
  `numberid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家numberid,识别第几号用户',
  `areaid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '地区areaid,识别地区',
  `unick` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '""' COMMENT '玩家的昵称',
  `usex` int(8) NOT NULL DEFAULT '0' COMMENT '0:男, 1:女的',
  `uface` int(8) NOT NULL DEFAULT '0' COMMENT '系统默认图像，自定义图像后面再加上',
  `uname` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '""' COMMENT '玩家的账号名称',
  `upwd` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '""' COMMENT '玩家密码的MD5值',
  `phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '""' COMMENT '玩家的电话',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '""' COMMENT '玩家的email',
  `address` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '""' COMMENT '玩家的地址',
  `uvip` int(8) NOT NULL DEFAULT '0' COMMENT '玩家VIP的等级，这个是最普通的',
  `vip_end_time` int(32) NOT NULL DEFAULT '0' COMMENT '玩家VIP到期的时间撮',
  `is_guest` int(8) NOT NULL DEFAULT '0' COMMENT '标志改账号是否为游客账号',
  `guest_key` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '游客账号的唯一的key',
  `status` int(8) NOT NULL DEFAULT '0' COMMENT '0表示正常，其他根据需求定',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 COMMENT='存放我们的玩家信息';

-- ----------------------------
-- Records of uinfo
-- ----------------------------
INSERT INTO `uinfo` VALUES ('31', '1111111', '1', '7533', '萧炎001', '0', '3', 'hccfuck', '123456', '\"\"', '\"\"', '\"\"', '0', '0', '0', '5034358JvrDstUNDuTNnnCKFEw821171', '0');
INSERT INTO `uinfo` VALUES ('68', '8278442', '0', '0', 'gst101126', '0', '6', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '8199358JvrDstUNDuTNnnCKFEw633089', '0');
INSERT INTO `uinfo` VALUES ('70', '3846282', '0', '0', 'player1111', '1', '9', 'test1111', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('71', '1383972', '0', '0', 'player2222', '0', '6', 'test2222', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('72', '9214752', '0', '0', 'gst474880', '1', '7', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '7540328JvrDstUNDuTNnnCKFEw313406', '0');
INSERT INTO `uinfo` VALUES ('73', '5561523', '0', '0', 'gst704110', '1', '7', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '3081368JvrDstUNDuTNnnCKFEw913902', '0');
INSERT INTO `uinfo` VALUES ('74', '9536102', '0', '0', 'player3333', '1', '6', 'test3333', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('75', '8188354', '0', '0', 'player4444', '1', '4', 'test4444', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('76', '2978088', '0', '0', 'player5555', '0', '4', 'test5555', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('77', '6094909', '0', '0', 'gst173388', '1', '6', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '1733018JvrDstUNDuTNnnCKFEw390814', '0');
INSERT INTO `uinfo` VALUES ('78', '4296447', '0', '0', 'gst540798', '0', '4', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '3598168JvrDstUNDuTNnnCKFEw240091', '0');
INSERT INTO `uinfo` VALUES ('79', '4982818', '0', '0', 'gst968579', '1', '5', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '6505568JvrDstUNDuTNnnCKFEw225022', '0');
INSERT INTO `uinfo` VALUES ('80', '2875915', '0', '0', 'player9999', '0', '3', 'test9999', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('81', '6905975', '0', '0', 'player1130', '1', '8', 'test1130', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('82', '5426940', '0', '0', 'gst473837', '1', '6', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '6472148JvrDstUNDuTNnnCKFEw253876', '0');
INSERT INTO `uinfo` VALUES ('83', '3115966', '0', '0', 'player6666', '0', '5', 'test6666', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('84', '2980285', '0', '0', 'player7777', '0', '5', 'test7777', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('85', '7189422', '0', '0', 'player8888', '0', '6', 'test8888', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('86', '1635833', '0', '0', 'player0000', '0', '1', 'test0000', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('87', '4947387', '0', '0', 'gst115682', '1', '1', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '6910218JvrDstUNDuTNnnCKFEw649072', '0');
INSERT INTO `uinfo` VALUES ('88', '4653503', '0', '0', 'gst679391', '1', '8', 'test1131', '111111', '\"\"', '\"\"', '\"\"', '0', '0', '0', '0', '0');
INSERT INTO `uinfo` VALUES ('89', '3759216', '0', '0', 'gst397070', '1', '9', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '7122408JvrDstUNDuTNnnCKFEw465930', '0');
