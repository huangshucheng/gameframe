/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50168
Source Host           : localhost:3306
Source Database       : auth_center

Target Server Type    : MYSQL
Target Server Version : 50168
File Encoding         : 65001

Date: 2018-10-07 23:01:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for uinfo
-- ----------------------------
DROP TABLE IF EXISTS `uinfo`;
CREATE TABLE `uinfo` (
  `uid` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '玩家唯一的UID号',
  `unick` varchar(32) NOT NULL DEFAULT '""' COMMENT '玩家的昵称',
  `usex` int(8) NOT NULL DEFAULT '0' COMMENT '0:男, 1:女的',
  `uface` int(8) NOT NULL DEFAULT '0' COMMENT '系统默认图像，自定义图像后面再加上',
  `uname` varchar(32) NOT NULL DEFAULT '""' COMMENT '玩家的账号名称',
  `upwd` varchar(32) NOT NULL DEFAULT '""' COMMENT '玩家密码的MD5值',
  `phone` varchar(16) NOT NULL DEFAULT '""' COMMENT '玩家的电话',
  `email` varchar(64) NOT NULL DEFAULT '""' COMMENT '玩家的email',
  `address` varchar(128) NOT NULL DEFAULT '""' COMMENT '玩家的地址',
  `uvip` int(8) NOT NULL DEFAULT '0' COMMENT '玩家VIP的等级，这个是最普通的',
  `vip_end_time` int(32) NOT NULL DEFAULT '0' COMMENT '玩家VIP到期的时间撮',
  `is_guest` int(8) NOT NULL DEFAULT '0' COMMENT '标志改账号是否为游客账号',
  `guest_key` varchar(64) NOT NULL DEFAULT '0' COMMENT '游客账号的唯一的key',
  `status` int(8) NOT NULL DEFAULT '0' COMMENT '0表示正常，其他根据需求定',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='存放我们的玩家信息';

-- ----------------------------
-- Records of uinfo
-- ----------------------------
INSERT INTO `uinfo` VALUES ('6', 'gst113485', '0', '1', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '8060238JvrDstUNDuTNnnCKFEw4pKFsn', '0');
INSERT INTO `uinfo` VALUES ('7', 'gst232577', '1', '2', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '7931508JvrDstUNDuTNnnCKFEw4pKFsn', '0');
INSERT INTO `uinfo` VALUES ('8', 'gst501110', '0', '2', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '5107028JvrDstUNDuTNnnCKFEw4pKFsn', '0');
INSERT INTO `uinfo` VALUES ('9', 'gst108020', '1', '4', '\"\"', '\"\"', '\"\"', '\"\"', '\"\"', '0', '0', '1', '8JvrDstUNDuTNnnCKFEw4pKFsn666666', '0');
