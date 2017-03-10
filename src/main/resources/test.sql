/*
SQLyog Ultimate v9.01 
MySQL - 5.6.14-log : Database - test
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`test` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `test`;

/*Table structure for table `Topic` */

DROP TABLE IF EXISTS `Topic`;

CREATE TABLE `Topic` (
  `TopicID` char(40) NOT NULL,
  `TopicFilePath` varchar(200) NOT NULL,
  `NewFileName` varchar(200) NOT NULL,
  `OriginalFileName` varchar(200) NOT NULL,
  `TopicName` varchar(255) NOT NULL,
  `TopicType` varchar(50) NOT NULL,
  `isFree` bit(1) NOT NULL,
  `isUpdated` bit(1) NOT NULL,
  PRIMARY KEY (`TopicID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='杂志主题';

/*Table structure for table `accesslog` */

DROP TABLE IF EXISTS `accesslog`;

CREATE TABLE `accesslog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `localname` varchar(30) DEFAULT NULL,
  `matchname` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40227 DEFAULT CHARSET=utf8;

/*Table structure for table `appointmentDoctor` */

DROP TABLE IF EXISTS `appointmentDoctor`;

CREATE TABLE `appointmentDoctor` (
  `appointmentDoctorId` char(40) NOT NULL,
  `ProvinceId` int(11) DEFAULT NULL COMMENT '省id',
  `CityId` int(11) DEFAULT NULL COMMENT '市Id',
  `DistrictId` int(11) DEFAULT NULL COMMENT '区域Id',
  KEY `AppointmentDoctorId` (`appointmentDoctorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `channelSetup_test` */

DROP TABLE IF EXISTS `channelSetup_test`;

CREATE TABLE `channelSetup_test` (
  `channelSetupId` varchar(40) NOT NULL COMMENT '渠道编号',
  `channelCode` varchar(100) DEFAULT NULL COMMENT '渠道代码',
  `name` varchar(50) DEFAULT NULL COMMENT '渠道名称',
  `weight` int(11) DEFAULT NULL COMMENT '渠道权重',
  `channelPrefix` varchar(10) DEFAULT NULL COMMENT '渠道前缀【排队号前缀】',
  `createDateTime` datetime DEFAULT NULL COMMENT '创建时间',
  `createUserId` varchar(40) DEFAULT NULL COMMENT '创建人',
  `updateDateTime` datetime DEFAULT NULL COMMENT '最后更新时间',
  `updateUserId` varchar(40) DEFAULT NULL COMMENT '最后更新人',
  `isDelete` bit(1) DEFAULT b'0' COMMENT '是否删除  0 未删除  1 已删除',
  PRIMARY KEY (`channelSetupId`),
  KEY `idx_channel_code` (`channelCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='渠道权重设置';

/*Table structure for table `general_log` */

DROP TABLE IF EXISTS `general_log`;

CREATE TABLE `general_log` (
  `event_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_host` mediumtext NOT NULL,
  `thread_id` bigint(21) unsigned NOT NULL,
  `server_id` int(10) unsigned NOT NULL,
  `command_type` varchar(64) NOT NULL,
  `argument` mediumtext NOT NULL,
  KEY `event_time` (`event_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='General log';

/*Table structure for table `heartbeat` */

DROP TABLE IF EXISTS `heartbeat`;

CREATE TABLE `heartbeat` (
  `ts` varchar(26) NOT NULL,
  `server_id` int(10) unsigned NOT NULL,
  `file` varchar(255) DEFAULT NULL,
  `position` bigint(20) unsigned DEFAULT NULL,
  `relay_master_log_file` varchar(255) DEFAULT NULL,
  `exec_master_log_pos` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `integral_acquire` */

DROP TABLE IF EXISTS `integral_acquire`;

CREATE TABLE `integral_acquire` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `userId` varchar(50) NOT NULL COMMENT '用户id',
  `acquireId` int(11) DEFAULT NULL COMMENT '获得类型id',
  `score` int(10) DEFAULT NULL COMMENT '获得积分值',
  `isEffective` char(1) DEFAULT 'Y' COMMENT '是否有效',
  `ctime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `acquireId` (`acquireId`),
  CONSTRAINT `integral_acquire_ibfk_1` FOREIGN KEY (`acquireId`) REFERENCES `integral_acquire_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=244 DEFAULT CHARSET=utf8 COMMENT='获得积分表\r\n';

/*Table structure for table `integral_acquire_type` */

DROP TABLE IF EXISTS `integral_acquire_type`;

CREATE TABLE `integral_acquire_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `typeName` varchar(4) NOT NULL COMMENT '类型名称',
  `score` tinyint(4) NOT NULL COMMENT '积分值',
  `description` varchar(255) DEFAULT NULL COMMENT '积分获得类型说明',
  `isEffective` char(1) NOT NULL DEFAULT 'Y' COMMENT '是否有效',
  `ctime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `cuser` varchar(255) DEFAULT NULL COMMENT '创建人',
  `uuser` varchar(255) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `typeName` (`typeName`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='积分获得类型表';

/*Table structure for table `integral_consumption` */

DROP TABLE IF EXISTS `integral_consumption`;

CREATE TABLE `integral_consumption` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `userId` varchar(80) NOT NULL COMMENT '用户ID',
  `preSumpId` int(11) DEFAULT NULL COMMENT '预消费ID',
  `orderId` varchar(255) NOT NULL COMMENT '兑吧订单ID',
  `instructions` varchar(255) DEFAULT NULL COMMENT '预消费说明',
  `score` int(11) NOT NULL COMMENT '预消费分值',
  `isEffective` char(1) DEFAULT 'Y' COMMENT '是否有效',
  `ctime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `preSumpId` (`preSumpId`),
  KEY `orderId` (`orderId`),
  CONSTRAINT `integral_consumption_ibfk_1` FOREIGN KEY (`preSumpId`) REFERENCES `integral_pre_consumption` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `integral_consumption_ibfk_2` FOREIGN KEY (`orderId`) REFERENCES `integral_pre_consumption` (`orderId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='积分消费表';

/*Table structure for table `integral_invite` */

DROP TABLE IF EXISTS `integral_invite`;

CREATE TABLE `integral_invite` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增ID',
  `userId` varchar(80) NOT NULL COMMENT '账户ID',
  `inviteCode` varchar(255) NOT NULL COMMENT '分享邀请码',
  `shareTravel` int(5) DEFAULT '0' COMMENT '分享次数',
  `inviteUA` varchar(255) NOT NULL DEFAULT '无' COMMENT '(被)邀请人UA标识',
  `inviteId` varchar(80) DEFAULT NULL COMMENT '被邀请人ID',
  `getStatus` tinyint(5) DEFAULT '0' COMMENT '是否已获得积分(0未获得，1已获得)',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `inviteId` (`inviteId`),
  KEY `userId` (`userId`) USING BTREE,
  KEY `inviteCode` (`inviteCode`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='分享邀请表';

/*Table structure for table `integral_pre_consumption` */

DROP TABLE IF EXISTS `integral_pre_consumption`;

CREATE TABLE `integral_pre_consumption` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `userId` varchar(255) NOT NULL COMMENT '用户ID',
  `orderId` varchar(255) NOT NULL COMMENT '兑吧订单ID',
  `instructions` varchar(255) DEFAULT NULL COMMENT '预消费说明',
  `score` int(11) NOT NULL COMMENT '预消费分值',
  `isStatement` tinyint(1) DEFAULT '0' COMMENT '是否已结单(0未结单，1已结单)',
  `resultStatus` tinyint(1) unsigned zerofill DEFAULT '0' COMMENT '兑吧处理状态(0失败1成功2未处理)',
  `isEffective` char(1) DEFAULT 'Y' COMMENT '是否有效(Y有效,N无效)',
  `ctime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `orderId` (`orderId`),
  KEY `userId` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='积分预消费表';

/*Table structure for table `integral_user` */

DROP TABLE IF EXISTS `integral_user`;

CREATE TABLE `integral_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户积分表主键Id',
  `userId` varchar(80) NOT NULL COMMENT '关联医生账户ID',
  `userName` varchar(255) DEFAULT NULL COMMENT '医生姓名',
  `telPhone` varchar(255) DEFAULT NULL COMMENT '手机号码',
  `yikeCode` varchar(255) DEFAULT NULL,
  `pastTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最新签到时间',
  `pastCount` tinyint(3) NOT NULL DEFAULT '0' COMMENT '连续签到次数',
  `totalScore` int(11) NOT NULL DEFAULT '0' COMMENT '总积分',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `failureTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '积分失效时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userId` (`userId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8 COMMENT='用户积分表';

/*Table structure for table `lai_yi_fa` */

DROP TABLE IF EXISTS `lai_yi_fa`;

CREATE TABLE `lai_yi_fa` (
  `id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `lai_yi_fa_2` */

DROP TABLE IF EXISTS `lai_yi_fa_2`;

CREATE TABLE `lai_yi_fa_2` (
  `id` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `log` */

DROP TABLE IF EXISTS `log`;

CREATE TABLE `log` (
  `log` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `mapinfo` */

DROP TABLE IF EXISTS `mapinfo`;

CREATE TABLE `mapinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `xpos` double(10,4) DEFAULT NULL,
  `ypos` double(10,4) DEFAULT NULL,
  `ctime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `xpos` (`xpos`,`ypos`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1304017 DEFAULT CHARSET=utf8;

/*Table structure for table `new_table` */

DROP TABLE IF EXISTS `new_table`;

CREATE TABLE `new_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text1` text,
  `text2` text,
  `text3` text,
  `text4` text,
  `text5` text,
  `text6` text,
  `text7` text,
  `text8` text,
  `text9` text,
  `text10` text,
  `text11` text,
  `text12` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `pay_mode_config` */

DROP TABLE IF EXISTS `pay_mode_config`;

CREATE TABLE `pay_mode_config` (
  `pay_mode_config_id` char(40) NOT NULL COMMENT '支付方式ID',
  `pay_name` varchar(40) DEFAULT NULL COMMENT '支付名称',
  `pay_mode_code` varchar(40) DEFAULT NULL COMMENT '支付方式编码.支付宝:alipay,微信:wechatpay,银联:unionpay,壹钱包:1qianbao',
  `pay_icon_url` varchar(100) DEFAULT NULL COMMENT '支付图标',
  `pay_discount_desc` varchar(20) DEFAULT NULL COMMENT '优惠描述',
  `pay_desc` varchar(200) DEFAULT NULL COMMENT '支付描述',
  `channel_id` int(11) DEFAULT NULL COMMENT '渠道ID，兼容老版本',
  `pay_status` int(11) DEFAULT NULL COMMENT '支付状态,1：有效；0：无效',
  `pay_sort` int(11) DEFAULT NULL,
  `create_user_id` varchar(40) DEFAULT NULL COMMENT '创建用户ID',
  `create_date_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_user_id` varchar(40) DEFAULT NULL,
  `update_date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`pay_mode_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付方式配置';

/*Table structure for table `pay_module` */

DROP TABLE IF EXISTS `pay_module`;

CREATE TABLE `pay_module` (
  `pay_module_id` char(40) NOT NULL COMMENT '支付模块ID',
  `pay_module_name` varchar(40) DEFAULT NULL,
  `pay_module_type` varchar(40) DEFAULT NULL COMMENT '主模块类型',
  `is_delete` bit(1) DEFAULT NULL COMMENT '0：否，1：是',
  `create_user_id` varchar(40) DEFAULT NULL COMMENT '创建用户ID',
  `create_date_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_user_id` varchar(40) DEFAULT NULL COMMENT '修改用户ID',
  `update_date_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`pay_module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付模块信息';

/*Table structure for table `pay_module_detail` */

DROP TABLE IF EXISTS `pay_module_detail`;

CREATE TABLE `pay_module_detail` (
  `pay_module_detail_id` char(40) NOT NULL COMMENT '支付模块详情ID',
  `pay_module_detail_name` varchar(40) DEFAULT NULL COMMENT '支付模块详情名称',
  `pay_module_id` char(40) NOT NULL DEFAULT '-1' COMMENT '支付模块ID（pay_module的主键ID）',
  `hospital_id` varchar(40) DEFAULT NULL COMMENT '医院ID，可以为空，不为空，则此模块与医院挂钩',
  `hospital_name` varchar(40) DEFAULT NULL COMMENT '医院名称',
  `pay_type` int(11) DEFAULT NULL COMMENT '0：业务支付方式，1：医院支付方式，-1：两者都不是，不显示开关',
  `pay_time_limit` bigint(20) DEFAULT NULL COMMENT '支付时间限制（单位，分钟）',
  `pay_time_limit_open` bit(1) DEFAULT NULL COMMENT '是否开启支付时间限制，0：否，1：是',
  `pay_module_detail_code` varchar(40) DEFAULT NULL COMMENT '支付模块详情编码',
  `is_delete` bit(1) DEFAULT NULL COMMENT '0：否，1：是',
  `create_user_id` varchar(40) DEFAULT NULL COMMENT '创建用户ID',
  `create_date_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_user_id` varchar(40) DEFAULT NULL COMMENT '修改用户ID',
  `update_date_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`pay_module_detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付模块详情';

/*Table structure for table `pay_module_detail_relation` */

DROP TABLE IF EXISTS `pay_module_detail_relation`;

CREATE TABLE `pay_module_detail_relation` (
  `relation_id` char(40) NOT NULL COMMENT '关系ID',
  `pay_module_detail_id` char(40) DEFAULT NULL COMMENT 'pay_module_detai表主键ID',
  `pay_mode_id` char(40) DEFAULT NULL COMMENT 'pay_mode表主键ID',
  `is_open` bit(1) DEFAULT NULL COMMENT '0：否，1：是',
  `business_id` varchar(100) DEFAULT NULL COMMENT '商户ID',
  `partner_id` varchar(200) DEFAULT NULL COMMENT '合作者身份',
  `alipay_account` varchar(100) DEFAULT NULL COMMENT '支付宝账号',
  `parameter_code_character` varchar(10) DEFAULT NULL COMMENT '参数编码字符集',
  `sign_mode` varchar(20) DEFAULT NULL COMMENT '签名方式',
  `safety_check_code` varchar(200) DEFAULT NULL COMMENT '安全校验码',
  `private_key` text COMMENT '密钥',
  `public_key` text COMMENT '公钥',
  `app_id` varchar(100) DEFAULT NULL COMMENT 'APP应用ID',
  `sign_key` varchar(100) DEFAULT NULL COMMENT '签名KEY',
  `certificate_file` text COMMENT '证书文件',
  `certificate_file_name` varchar(40) DEFAULT NULL COMMENT '证书文件名称',
  `op_name` varchar(40) DEFAULT NULL COMMENT '操作人名称',
  `area_code` varchar(10) DEFAULT NULL COMMENT '地区编码',
  `is_medicare_pay` bit(1) DEFAULT NULL COMMENT '0：否，1：是',
  `create_user_id` varchar(40) DEFAULT NULL COMMENT '创建用户ID',
  `create_date_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_user_id` varchar(40) DEFAULT NULL COMMENT '修改时间',
  `update_date_time` datetime DEFAULT NULL,
  `hospital_id` varchar(40) DEFAULT NULL COMMENT '医院ID',
  `hospital_name` varchar(40) DEFAULT NULL COMMENT '医院名称',
  `app_private_key` text COMMENT '当面付私钥',
  `op_full_name` varchar(40) DEFAULT NULL COMMENT '操作人姓名',
  PRIMARY KEY (`relation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付模块详情关系表,（pay_module_detail表与pay_mode_config关系表）';

/*Table structure for table `t` */

DROP TABLE IF EXISTS `t`;

CREATE TABLE `t` (
  `id` int(11) DEFAULT NULL,
  `id2` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tempdb` */

DROP TABLE IF EXISTS `tempdb`;

CREATE TABLE `tempdb` (
  `a1` datetime DEFAULT NULL,
  `a2` varchar(50) DEFAULT NULL,
  `a3` varchar(50) DEFAULT NULL,
  `a4` varchar(50) DEFAULT NULL,
  `a5` varchar(50) DEFAULT NULL,
  `a6` decimal(10,2) DEFAULT NULL,
  `a7` varchar(50) DEFAULT NULL,
  `a8` decimal(10,2) DEFAULT NULL,
  `a9` decimal(10,2) DEFAULT NULL,
  `a10` decimal(10,2) DEFAULT NULL,
  `a11` decimal(10,2) DEFAULT NULL,
  `tp` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `pwd` varchar(32) NOT NULL,
  `test` int(11) DEFAULT NULL,
  `testdt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

/* Procedure structure for procedure `gather_table_stats` */

/*!50003 DROP PROCEDURE IF EXISTS  `gather_table_stats` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `gather_table_stats`()
BEGIN
	#Routine body goes here...
	declare icat varchar(10);
	declare x DOUBLE;
	declare y DOUBLE;
	declare n int;
  SET @i = 0;

while @i<100000 do
		SET x = truncate(RAND() * 10000,4);
		SET y = truncate(RAND() * 10000,4);
		SET n = ceiling((RAND() * 100));
		
		SET icat = (SELECT 
		CASE ceiling((RAND() * 10)) 
			WHEN 1
				THEN '休闲会所'
			WHEN 2
				THEN '酒店'
			WHEN 3
				THEN '婚纱店'
			WHEN 4
					THEN '美甲店'
			WHEN 5
					THEN '洗脚按摩'
			WHEN 6
					THEN '购物商场'
			WHEN 7
					THEN '亲子乐园'
			WHEN 8
					THEN '运动天地'
			WHEN 9
					THEN '家庭港湾'
			WHEN 10
					THEN '车辆服务'
			ELSE
					'其他'
		END AS 'icat_copy' );

		insert into mapinfo(category,name,xpos,ypos) values(icat,CONCAT(icat,n), x, y);
		SET @i=@i+1;
	end while;
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_ApplyClinicRefound` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_ApplyClinicRefound` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_ApplyClinicRefound`(
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName VarCHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory int,
hospitalOrderNumber CHAR(40),
invoiceCode CHAR(40),
refoundReason CHAR(40),
applyDateTime Date
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"HIS窗口门诊退费申请发起成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as platformOrderNumber/*第三方平台收单流水号*/);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_AppointmentLockNo` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_AppointmentLockNo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_AppointmentLockNo`(
scheduleId CHAR(40),
scheduleDate CHAR(40),
timeFlag INT,
beginTime CHAR(40), 
endTime CHAR(40),
scheduleDetailId CHAR(40),
isCurrentDay bool,
hospitalCode CHAR(40),
departmentCode CHAR(40),
doctorCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName CHAR(40),
patientSex int,
patientMobile CHAR(40),
patientAge int,
patientBirthday CHAR(40),
patientIdentityCardType int,
patientIdentityCardNumber CHAR(40),
patientCategory int,
guardianName CHAR(40),
guardianIdentityCardType CHAR(40),
guardianIdentityCardNumber CHAR(40),
guardianMobile CHAR(40),
guardianShip int,
platformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"锁号成功!" AS resultMessage,
		DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')  AS appointmentCode,
		FLOOR(100 + (RAND() * 1000)) AS appointmentPwd,
		FLOOR(1 + (RAND() * 100)) AS serialNumber,
		'门诊部二楼对应科室就诊' AS location,
		'请带好有效证件前往医院就诊' AS description,
		2 AS payCategory);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_AppointmentPay` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_AppointmentPay` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_AppointmentPay`(
hospitalCode CHAR(40),
appointmentCode CHAR(40),
presettlementCode  CHAR(40),
payChannel INT,
payCategory INT,
totalFee decimal,
selfFee DECIMAL,
medicalInsuranceFee decimal,
paymentPlatformOrderNumber CHAR(40),
platformOrderNumber CHAR(40),
payDateTime datetime,
platformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"预约支付成功!" AS resultMessage,
		DATE_FORMAT(NOW(),'%Y%m%d%h%i%s')  AS hospitalOrderNumber,
		DATE_FORMAT(NOW(),'%Y%m%d%h%i%s')  AS invoiceCode,
		appointmentCode as appointmentCode,
		FLOOR(100 + (RAND() * 1000)) as appointmentPwd,
		FLOOR(1 + (RAND() * 100)) as serialNumber,
		"市一医院门诊大楼!" AS location,
		'支付成功后，请到医院指定分诊台领取预约挂号单!' AS description);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_AppointmentPresettlement` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_AppointmentPresettlement` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_AppointmentPresettlement`(
hospitalCode CHAR(40),
appointmentCode CHAR(40),
payChannel  INT,
payCategory INT,
platformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"预结算成功!" AS resultMessage,
		
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS presettlementCode, -- 预结算单号
		FLOOR(1 + (RAND() * 1000)) AS selfFee, -- 自费金额
		FLOOR(100 + (RAND() * 1000)) AS medicalInsuranceFee, -- 医保报销金额
		2 AS benefitCategory, -- 优惠类型
		FLOOR(50 + (RAND() * 500)) AS benefitFee, -- 优惠金额
		'预约支付预结算....' AS description);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_AppointmentRefound` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_AppointmentRefound` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_AppointmentRefound`(
hospitalCode CHAR(40),
appointmentCode CHAR(40),/*预约编号*/
paymentPlatformOrderNumber  CHAR(40),/*支付平台支付流水号*/
platformRefoundOrderNumber CHAR(40),/*第三方平台单号*/
selfRefoundFee decimal,/*自费退款金额*/
medicalInsuranceRefoundFee decimal,/*医保退款金额*/
refoundDateTime Date,/*退款时间*/
platformSource CHAR(40)/*第三方渠道来源*/
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"预约退费成功!" AS resultMessage,
	        CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as hospitalRefoundCode /*医院退款流水号*/);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_AppointmentRefoundApply` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_AppointmentRefoundApply` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_AppointmentRefoundApply`(
hospitalCode CHAR(40),
appointmentCode CHAR(40),
platformOrderNumber  CHAR(40),
platformSource CHAR(40),
paymentPlatformOrderNumber CHAR(40),
applyDateTime Date,
applyReason NVARCHAR(50)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"预约退费申请成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as platformRefoundOrderNumber); -- 第三方收款流水号
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_BindPatientArchiving` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_BindPatientArchiving` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_BindPatientArchiving`(
patientName CHAR(40), 
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientMobile CHAR(40),
patientSex CHAR(40),
patientAge CHAR(40),
patientBirthday CHAR(40),
patientAddress CHAR(40),
patientCategory INT (11),
guardianName CHAR(40),
guardianIdentityCardType CHAR(40),
guardianIdentityCardNumber CHAR(40),
guardianMobile  CHAR(40),
guardianShip  CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
familyMemberId CHAR(40)
)
BEGIN
SELECT 
1 AS isSuccess,"1001" AS resultCode,"绑定就诊卡成功!" AS resultMessage,
CONCAT(patientMedicalCardNumber,DATE_FORMAT(NOW(),'%Y%m%d%h%i%s')) AS patientCode;
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_BuildPatientArchiving` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_BuildPatientArchiving` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_BuildPatientArchiving`(
patientName CHAR(40), 
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientMobile CHAR(40),
patientSex CHAR(40),
patientAge CHAR(40),
patientBirthday CHAR(40),
patientAddress CHAR(40),
patientCategory INT (11),
guardianName CHAR(40),
guardianIdentityCardType CHAR(40),
guardianIdentityCardNumber CHAR(40),
guardianMobile  CHAR(40)
)
BEGIN
SELECT 
1 AS isSuccess,"1001" AS resultCode,"首诊建档成功!" AS resultMessage,
DATE_FORMAT(NOW(),'%Y%m%d%h%i%s') as patientCode;
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_CancelAppointment` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_CancelAppointment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_CancelAppointment`(
hospitalCode CHAR(40),
appointmentCode CHAR(40),
cancelReason  NVARCHAR(40),
cancelDateTime Date,
cancelPlatformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"取消预约成功!" AS resultMessage);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_CancelLockNo` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_CancelLockNo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_CancelLockNo`(
hospitalCode CHAR(40),
appointmentCode CHAR(40),
cancelReason  NVARCHAR(40),
cancelDateTime Date,
cancelPlatformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"取消锁号成功!" AS resultMessage);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_CheckAppointment` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_CheckAppointment` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_CheckAppointment`(
hospitalCode CHAR(40),
scheduleId CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory INT,
patientName VARCHAR(40),
patientSex int,
patientAge int,
patientMobile CHAR(40),
patientBirthday CHAR(40),
guardianName CHAR(40),
guardianIdentityCardType int,
guardianIdentityCardNumber CHAR(40),
guardianMobile CHAR(40),
guardianShip int,
platformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"检查预约成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as appointmentCode,
		FLOOR(100 + (RAND() * 1000)) as serialNumber,
		'二楼外科检查室'as location,
		CONCAT('通过',platformSource,'渠道,预约外科检查成功！' )AS description);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_ClinicRefound` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_ClinicRefound` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_ClinicRefound`(
platformOrderNumber CHAR(40),
platformSource CHAR(40),
paymentChannelRefoundOrderNumber CHAR(40),
payChannel CHAR(40),
hospitalOrderNumber CHAR(40),
invoiceCode  CHAR(40),
refoundDatetime DATE,
refoundSelfFee decimal,
refoundMedicalInsuranceFee DECIMAL
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"门诊退费成功!" AS resultMessage);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_HKApplyClinicRefound` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_HKApplyClinicRefound` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_HKApplyClinicRefound`(
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory int,
hospitalOrderNumber CHAR(40),
invoiceCode CHAR(40),
refoundReason CHAR(40),
applyDateTime Date
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"华康App门诊退费申请发起成功!" AS resultMessage);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_PayClinicFee` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_PayClinicFee` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_PayClinicFee`(
hospitalCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName VarCHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory CHAR(40),
pendingFeeOrderNumber CHAR(40),
prescriptionCode VARCHAR(40),
presettlementCode VARCHAR(40),
payChannel INT,
payCategory INT,
paymentPlatformOrderNumber CHAR(40),
platformSource CHAR(40),
platformOrderNumber CHAR(40),
selfFee DEcimal,
medicalInsuranceFee DECimal,
payDateTime DATE
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"门诊缴费成功!" AS resultMessage,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as hospitalOrderNumber, /*医院收单流水号*/
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS invoiceCode, /*发票号*/
		CONCAT('患者：',patientName,"您已经成功缴费，请到二楼西药房窗口取药!") as location/*取药位置*/);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_PayHospitalizationForegift` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_PayHospitalizationForegift` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_PayHospitalizationForegift`(
hospitalCode CHAR(40),
hospitalizationCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName VARCHAR(40),
patientIdentityCardType INT,
patientIdentityCardNumber CHAR(40),
pendingFeeCode CHAR(40),
prescriptionCode CHAR(40),
payChannel INT,
paymentPlatformOrderNumber CHAR(40),
platformSource CHAR(40),
platformOrderNumber CHAR(40),
selfFee DECIMAL,
payDateTime DATE
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"住院押金补缴成功!" AS resultMessage,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS hospitalOrderNumber,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS invoiceCode,
		 4963.21 AS foregiftBalance
		);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_PresettlementClinicFee` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_PresettlementClinicFee` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_PresettlementClinicFee`(
prescriptionCode CHAR(40),
payChannel int,
payCategory int,
platformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取门诊缴费预结算信息成功!" AS resultMessage,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as presettlementCode, /*预结算单号*/
		 569.36 as selfFee, /*自费金额*/
		 1693.20 as medicalInsuranceFee, /*医保金额*/
		5 AS benefitCategory, /*优惠类型*/
		263.22 as benefitFee,/* 优惠金额*/
		CONCAT('处方号为：',prescriptionCode,"的门诊待缴费预结算信息....") as description);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryCheckAppointments` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryCheckAppointments` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryCheckAppointments`(
hospitalCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName VARCHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory INT,
beginDate CHAR(40),
endDate CHAR(40),
itemCode CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"检查预约记录查询成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as appointmentCode,
		FLOOR(100 + (RAND() * 1000)) as serialNumber,
		'二楼外科检查室'as location,
		CONCAT('检查项目：',itemCode)AS description)union
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"检查预约记录查询成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS appointmentCode,
		FLOOR(100 + (RAND() * 1000)) AS serialNumber,
		'二楼外科检查室'AS location,
		CONCAT('检查项目：',itemCode)AS description);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryCheckProjects` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryCheckProjects` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryCheckProjects`(
hospitalCode CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取检查项目成功!" AS resultMessage,
		 FLOOR(100 + (RAND() * 1000)) as itemCode, /*检查项编号*/
		 '膝关节检查' AS itemName, /*检查项名称*/
		'用于确认查看患者是否有扭伤！' as description/*检查说明*/)union
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取检查项目成功!" AS resultMessage,
		 FLOOR(100 + (RAND() * 1000)) AS itemCode, /*检查项编号*/
		 '踝关节检查' AS itemName, /*检查项名称*/
		'用于确认查看患者是否有崴伤！' AS description/*检查说明*/)union
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取检查项目成功!" AS resultMessage,
		 FLOOR(100 + (RAND() * 1000)) AS itemCode, /*检查项编号*/
		 '肩关节检查' AS itemName, /*检查项名称*/
		'用于确认查看患者是否有拉伤！' AS description/*检查说明*/);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryCheckReports` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryCheckReports` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryCheckReports`(
hospitalCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName VARCHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory INT,
beginDate CHAR(40),
endDate CHAR(40),
checkReportId CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取检查项目成功!" AS resultMessage,
		patientCode as patientCode,
		 patientName as patientName,
		 FLOOR(0 + (RAND() * 1)) as patientSex,
		 FLOOR(1 + (RAND() * 100)) as patientAge,
		 '   XXX 第一医院' as hospitalName,
		 checkReportId as checkReportId,
		 patientCategory as patientCategory,
		 '肝胆胰脾肾(彩超)' as checkReportName,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')as checkReportDate,
		 FLOOR(10 + (RAND() * 100))as applyDoctorCode,
		 '内科' as applyDepartmentName,
		 FLOOR(100 + (RAND() * 500)) as applyDepartmentCode,
		 '李医生' as applyDoctorName,
		 '无' as checkPosition,
		 '检查方式' as checkMethod,
		 ' 胎心率在正常范围内，心律整齐。
	      胎盘位于后壁 ，厚约3.6cm，成熟度：Ⅱ  级。
	      羊水：透声较差，指数13.5 cm。
	      脐带：无缠绕。
	      脐血流指数：PI1.08   RI0.66   S/D2.90 。
	     'AS checkSeen,
		 '左足骨质未见明显异常。'AS advise,
		 '无异常情况' as checkSuggestion,
		 '血液检科' as reportDepartment,
		 '孙医生' as reportDoctor,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s') as reportDate,
		 FLOOR(10 + (RAND() * 100)) hospitalizationCode) union
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取检查项目成功!" AS resultMessage,
		patientCode AS patientCode,
		 patientName AS patientName,
		 FLOOR(0 + (RAND() * 1)) AS patientSex,
		 FLOOR(1 + (RAND() * 100)) AS patientAge,
		 '   XXX 第一医院' AS hospitalName,
		 checkReportId AS checkReportId,
		 patientCategory AS patientCategory,
		 '腹腔(阑尾或肠套)' AS checkReportName,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')AS checkReportDate,
		 FLOOR(10 + (RAND() * 100))AS applyDoctorCode,
		 '内科' AS applyDepartmentName,
		 FLOOR(100 + (RAND() * 500)) AS applyDepartmentCode,
		 '李医生' AS applyDoctorName,
		 '无' AS checkPosition,
		 '检查方式' AS checkMethod,
		 ' 腹腔内未查见明显包块回声及游动性暗区。'AS checkSeen,
		 '左足骨质未见明显异常。'AS advise,
		 '无异常情况' AS checkSuggestion,
		 '血液检科' AS reportDepartment,
		 '张医生' AS reportDoctor,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s') AS reportDate,
		 FLOOR(10 + (RAND() * 100)) hospitalizationCode) ;
		 
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryCheckSchedules` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryCheckSchedules` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryCheckSchedules`(
hospitalCode CHAR(40),
itemCode CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"查询检查排班成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as scheduleId,
		'需要预约做检查的患者，请先与您的主治医生确认相关检查项目，再进行预约！' as appointmentDescription,
		'外科检查'as itemName,
		'二楼外科检查室'as appointmentLocation,
		DATE_FORMAT(NOW(),'%Y-%m-%d') as scheduleDate,
		DATE_FORMAT(NOW(),'%H:%i') AS  beginTime,
		DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 HOUR),'%H:%i') AS  endTime,
		FLOOR(1 + (RAND() * 500)) as surplusCount,
		'外科检查排班' as description)
		union
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"查询检查排班成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleId,
		'需要预约做检查的患者，请先与您的主治医生确认相关检查项目，再进行预约！' AS appointmentDescription,
		'内科检查'AS itemName,
		'三楼内科检查室'AS appointmentLocation,
		DATE_FORMAT(NOW(),'%Y-%m-%d') AS scheduleDate,
		DATE_FORMAT(NOW(),'%H:%i') AS  beginTime,
		DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 HOUR),'%H:%i') AS  endTime,
		FLOOR(1 + (RAND() * 500)) AS surplusCount,
		'内科检查排班' AS description)
		union
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"查询检查排班成功!" AS resultMessage,
		CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleId,
		'需要预约做检查的患者，请先与您的主治医生确认相关检查项目，再进行预约！' AS appointmentDescription,
		'外科检查'AS itemName,
		'二楼神经外科检查室'AS appointmentLocation,
		DATE_FORMAT(NOW(),'%Y-%m-%d') AS scheduleDate,
		DATE_FORMAT(NOW(),'%H:%i') AS  beginTime,
		DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 HOUR),'%H:%i') AS  endTime,
		FLOOR(1 + (RAND() * 500)) AS surplusCount,
		'神经外科检查排班' AS description);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryClinicFeeStatus` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryClinicFeeStatus` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryClinicFeeStatus`(
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName VarCHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory int,
hospitalCode CHAR(40),
hospitalOrderNumber CHAR(40),
invoiceCode CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取门诊缴费状态信息成功!" AS resultMessage,
		6 as feeStatus/*门诊缴费状态*/);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryClinicLineUps` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryClinicLineUps` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryClinicLineUps`(
hospitalCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName  VARCHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取门诊候诊信息成功!" AS resultMessage,
		 FLOOR(1 + (RAND() * 500)) as patientSerialNumber, /*患者的排队序号*/
		 FLOOR(1 + (RAND() * 500)) AS currentSerialNumber, /*当前实时叫到的序号*/
		 FLOOR(1 + (RAND() * 500))as totalAmount,/* 队列总人数*/
		 ' 李医生' as doctorName,/* 费用类别*/
		 '内科' as departmentName,
		 '二楼内科2室' as location);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryClinicPendingFees` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryClinicPendingFees` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryClinicPendingFees`(
hospitalCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取门诊待缴费信息成功!" AS resultMessage,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as pendingFeeOrderNumber, /*医院待缴费流水号*/
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS prescriptionCode, /*处方号*/
		  patientCode as patientCode,
		  6 as feeCategory,/* 费用类别*/
		 '内科' as billingDepartmentName, /*  开单科室*/
		 DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s') as billingDate, /* 开单日期*/
		'门诊办收费科' AS execDepartmentName, /* 执行科室*/
		'伤风感冒引起的上呼吸道感染' as clinicalDiagnosis,/* 临床诊断*/
		693.00 as totalFee, /*费用总金额*/
		CONCAT('患者编码为：',patientCode,"的门诊待缴费信息!") as description,
		/*以下为明细*/
		'西药类' as itemCategory,
		'幸福伤风素' as itemCostName,
		'2' as itemAmount,
		'16.9' as itemPrice,
		'盒' as itemUnit,
		'每粒' as itemSpec)
		union 
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取门诊待缴费信息成功!" AS resultMessage,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS pendingFeeOrderNumber, /*医院待缴费流水号*/
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS prescriptionCode, /*处方号*/
		  patientCode AS patientCode,
		  6 AS feeCategory,/* 费用类别*/
		 '内科' AS billingDepartmentName, /*  开单科室*/
		 DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s') AS billingDate, /* 开单日期*/
		'门诊办收费科' AS execDepartmentName, /* 执行科室*/
		'伤风感冒引起的上呼吸道感染' AS clinicalDiagnosis,/* 临床诊断*/
		693.00 AS totalFee, /*费用总金额*/
		CONCAT('患者编码为：',patientCode,"的门诊待缴费信息!") AS description,
		/*以下为明细*/
		'西药类' as itemCategory,
		'感康' as itemCostName,
		'2' as itemAmount,
		'19.9' as itemPrice,
		'盒' as itemUnit,
		'每粒' as itemSpec
		);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryDepartments` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryDepartments` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryDepartments`()
BEGIN
  (SELECT 
    1 AS isSuccess,
    "1001" AS resultCode,
    "获取科室信息成功!" AS resultMessage,
    "jxmmkjis" AS hospitalCode,
    "kkjiiiks" AS departmentCode,
    "内科" AS departmentName,
    "医学科属。包括呼吸内科，消化内科，心血管内科，神经内科，肿瘤科，内分泌科，血液内科，传染病科，小儿科等等等。 " AS departmentDescription,
    "上海市徐汇区漕溪路135号" AS departmentAddress)
union 
  (SELECT 
    1 AS isSuccess,
    "1001" AS resultCode,
    "获取科室信息成功!" AS resultMessage,
    "yydghj" AS hospitalCode,
    "bbhgrt" AS departmentCode,
    "外科" AS departmentName,
    " 外科是研究外科疾病的发生，发展规律及其临床表现，诊断，预防和治疗的科学，是以手术切除、修补为主要治病手段的..." AS departmentDescription,
    "上海市徐汇区漕溪路135号" AS departmentAddress );
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryDoctors` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryDoctors` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryDoctors`()
BEGIN
(SELECT 
1 AS isSuccess,
"1001" AS resultCode,
"获取医生信息成功!" AS resultMessage,
"jxmmkjis" AS hospitalCode,
"kkjiiiks" AS departmentCode,
"2556" AS belongDepartmentCode,
"6693" AS clinicDepartmentCode,
"9965" AS doctorCode ,
"何老师" AS doctorName ,
"0" AS doctorSex ,
"1" AS doctorTeachingTitle ,
"4" AS doctorTitle ,
"1" AS doctorCategory,
"拥有十数年至数十年丰富的临床治疗经验。在电子胃镜诊断各类胃部疾病、肠道疾病、各类肝病诊治、高血压、呼吸道疾病治疗方面有着出色的表现。至今已经帮助众多患者摆脱疾病困扰，重获健康人生！" AS doctorDescription,
"内科医护人员工作经验丰富，技术出色，坚持弘扬医德医风，为广大患者提供优质的健康服务，获得了广大患者的青睐和赞誉。" AS goodAt,
"0" AS doctorStatus,
100 AS surplusCount)
UNION 
(SELECT 
1 AS isSuccess,
"1001" AS resultCode,
"获取医生信息成功!" AS resultMessage,
"jjghfhf" AS hospitalCode,
"hhfdsg" AS departmentCode,
"885698" AS belongDepartmentCode,
"6652" AS clinicDepartmentCode,
"2569" AS doctorCode ,
"李老师" AS doctorName ,
"0" AS doctorSex ,
"1" AS doctorTeachingTitle ,
"4" AS doctorTitle ,
"1" AS doctorCategory,
"至今已经帮助众多患者摆脱疾病困扰，重获健康人生！" AS doctorDescription,
"内科医护人员工作经验丰富，技术出色，坚持弘扬医德医风，为广大患者提供优质的健康服务，获得了广大患者的青睐和赞誉。" AS goodAt,
"0" AS doctorStatus,
100 AS surplusCount)
UNION
(SELECT 
1 AS isSuccess,
"1001" AS resultCode,
"获取医生信息成功!" AS resultMessage,
"hhfdgf" AS hospitalCode,
"rrtyghh" AS departmentCode,
"2698" AS belongDepartmentCode,
"1496" AS clinicDepartmentCode,
"3320" AS doctorCode ,
"王老师" AS doctorName ,
"1" AS doctorSex ,
"1" AS doctorTeachingTitle ,
"2" AS doctorTitle ,
"1" AS doctorCategory,
"拥有十数年至数十年丰富的临床治疗经验。在电子胃镜诊断各类胃部疾病、肠道疾病、各类肝病诊治、高血压、呼吸道疾病治疗方面有着出色的表现。" AS doctorDescription,
"在电子胃镜诊断各类胃部疾病、肠道疾病、各类肝病诊治、高血压、呼吸道疾病治疗方面有着出色的表现。" AS goodAt,
"0" AS doctorStatus,
100 AS surplusCount);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryHospitalizationListing` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryHospitalizationListing` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryHospitalizationListing`(
hospitalCode CHAR(40),
hospitalizationCode CHAR(40),
hospitalizationTimes INT,
patientCode CHAR(40),
patientName VARCHAR(40),
patientSex INT,
patientAge INT,
patientBirthday VARCHAR(40),
patientIdentityCardType INT,
patientIdentityCardNumber CHAR(40),
patientCategory INT,
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
beginDate CHAR(40),
endDate CHAR(40),
hospitalizationStatus INT
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"住院清单获取成功!" AS resultMessage,
		 patientName AS patientName,
		 patientSex AS patientSex,
		 patientAge AS patientAge,
		 hospitalCode AS hospitalCode,
		 'XXXX第一人民医院' AS hospitalName,
		 FLOOR(1 + (RAND() * 100)) AS departmentCode,
		 '外科' AS departmentName,
		 hospitalizationCode AS hospitalizationCode,
		 FLOOR(1 + (RAND() * 100)) AS bedNumber,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -10 DAY),'%Y-%m-%d %H:%i:%s') AS hospitalizedDate,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -2 DAY),'%Y-%m-%d %H:%i:%s') AS leaveDate,
		 hospitalizationStatus AS hospitalizationStatus,
		 693.00 AS totalForegift,
		 456.32 AS foregiftBalance,
		 patientCategory AS patientCategory,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s') AS feeDate,
		 FLOOR(1 + (RAND() * 100)) AS execDepartmentCode,
		 '住院部'AS execDepartmentName,
		 FLOOR(1 + (RAND() * 100)) AS execDoctorCode,
		 '张医生' AS execDoctorName,
                /*住院清单明细*/
		 '青霉素' as ItemName,
		 '支、盒' as ItemSpec,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s')  as ExecDate,
		 '4' as ItemAmount,
		 56.36 as ItemPrice		 
		 ) union
		 (SELECT 
		1 AS isSuccess,"1001" AS resultCode,"住院清单获取成功!" AS resultMessage,
		 patientName AS patientName,
		 patientSex AS patientSex,
		 patientAge AS patientAge,
		 hospitalCode AS hospitalCode,
		 'XXXX第一人民医院' AS hospitalName,
		 FLOOR(1 + (RAND() * 100)) AS departmentCode,
		 '心内科' AS departmentName,
		 hospitalizationCode AS hospitalizationCode,
		 FLOOR(1 + (RAND() * 100)) AS bedNumber,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -10 DAY),'%Y-%m-%d %H:%i:%s') AS hospitalizedDate,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -2 DAY),'%Y-%m-%d %H:%i:%s') AS leaveDate,
		 hospitalizationStatus AS hospitalizationStatus,
		 25639.00 AS totalForegift,
		 95632.32 AS foregiftBalance,
		 patientCategory AS patientCategory,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s') AS feeDate,
		 FLOOR(1 + (RAND() * 100)) AS execDepartmentCode,
		 '住院部'AS execDepartmentName,
		 FLOOR(1 + (RAND() * 100)) AS execDoctorCode,
		 '李医生' AS execDoctorName,
                 /*住院清单明细*/
		 '头雹消炎药' as ItemName,
		 '粒' as ItemSpec,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s')  as ExecDate,
		 '5' as ItemAmount,
		 58.30 as ItemPrice);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryHospitalizationRecords` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryHospitalizationRecords` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryHospitalizationRecords`(
hospitalCode CHAR(40),
patientCode CHAR(40),
patientName VARCHAR(40),
patientSex int,
patientAge int,
patientBirthday CHAR(40),
patientIdentityCardType INT,
patientIdentityCardNumber CHAR(40),
patientCategory INT,
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
beginDate CHAR(40),
endDate CHAR(40),
hospitalizationStatus CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取住院记录成功!" AS resultMessage,
		patientName as patientName,
		patientSex as patientSex,
		patientAge as patientAge,
		hospitalCode as hospitalCode,
		'XXXX第一人民医院' as hospitalName,
		'D099' as departmentCode,
		'内科' as departmentName,
		FLOOR(1 + (RAND() * 10)) as hospitalizationCount,
		FLOOR(100 + (RAND() * 1000)) as hospitalizationCode,
		FLOOR(100 + (RAND() * 1000)) as bedNumber,
		DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s') as hospitalizedDate,
		DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s') as leaveDate,
		FLOOR(1 + (RAND() * 2)) AS hospitalizationStatus,
		693.55 as totalForegift,
		89.00 as foregiftBalance,
		156.00 as chargeBalance,
		FLOOR(1 + (RAND() * 2))  as patientCategory,
		FLOOR(100 + (RAND() * 1000)) as execDepartmentCode,
		'住院部' as execDepartmentName,
		FLOOR(100 + (RAND() * 1000)) AS execDoctorCode,
		 '杨医生' as execDoctorName,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as pendingFeeCode
		) union 
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取住院记录成功!" AS resultMessage,
		patientName AS patientName,
		patientSex AS patientSex,
		patientAge AS patientAge,
		hospitalCode AS hospitalCode,
		'XXXX第一人民医院' AS hospitalName,
		'D099' AS departmentCode,
		'外科' AS departmentName,
		FLOOR(1 + (RAND() * 10)) AS hospitalizationCount,
		FLOOR(100 + (RAND() * 1000)) AS hospitalizationCode,
		FLOOR(100 + (RAND() * 1000)) AS bedNumber,
		DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s') AS hospitalizedDate,
		DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s') AS leaveDate,
		FLOOR(1 + (RAND() * 2)) AS hospitalizationStatus,
		450.55 AS totalForegift,
		142.00 AS foregiftBalance,
		173.00 AS chargeBalance,
		FLOOR(1 + (RAND() * 2))  AS patientCategory,
		FLOOR(100 + (RAND() * 1000)) AS execDepartmentCode,
		'住院部' AS execDepartmentName,
		FLOOR(100 + (RAND() * 1000)) AS execDoctorCode,
		 '张医生' AS execDoctorName,
		 CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS pendingFeeCode
		);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryHospitals` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryHospitals` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryHospitals`()
BEGIN
SELECT 1 AS isSuccess,"001" AS resultCode,"成功获取医院信息" AS resultMessage,"jininghospital" AS hospitalCode,
"济宁市第一人民医院" AS hospitalName,"位于孔孟之乡、运河之都的山东省济宁市市中心，是一所专业科室齐全、医疗设备先进、技术特色突出、鲁西南地区唯一的三级甲等医院..." AS hospitalDescription,"中国山东省济宁市高新区诗仙路99号" AS hospitalAddress,"0537-2257120" AS hospitalTel;
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryInspectionReports` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryInspectionReports` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryInspectionReports`(
hospitalCode CHAR(40),
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName VARCHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientCategory INT,
beginDate CHAR(40),
endDate CHAR(40),
inspectionId CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取检验报告成功!" AS resultMessage,
		 patientCode as patientCode,
		 patientName as patientName,
		 FLOOR(0 + (RAND() * 1)) as patientSex,
		 FLOOR(1 + (RAND() * 100)) as patientAge,
		 '   XXX 第一医院' as hospitalName,
		 inspectionId as inspectionId,
		 patientCategory as patientCategory,
		 '尿酸盐结晶' as inspectionName,
		 '标本类型' as specimenCategory,
		 FLOOR(10 + (RAND() * 100))as applyDepartmentCode,
		 '内科' as applyDepartmentName,
		 FLOOR(100 + (RAND() * 500)) as applyDoctorCode,
		 '李医生' as applyDoctorName,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')as sendDateTime,
		 '尿检科' as sendDepartmentName,
		 '张医生' as sendDoctorName,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')AS inspectionDateTime,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')AS reportDateTime,
		 FLOOR(10 + (RAND() * 100)) hospitalizationCode,
		 'PH' as itemName,
		 '5.0' as itemResult,
		 '4.50～8.00' as referenceRange,
		 '1' as abnormalPrompt) union
		 (SELECT 
		 1 AS isSuccess,"1001" AS resultCode,"获取检验报告成功!" AS resultMessage,
		 patientCode AS patientCode,
		 patientName AS patientName,
		 FLOOR(0 + (RAND() * 1)) AS patientSex,
		 FLOOR(1 + (RAND() * 100)) AS patientAge,
		 'XXX 第一医院' AS hospitalName,
		 inspectionId AS inspectionId,
		 patientCategory AS patientCategory,
		 '红细胞荧光强度分布宽度-SD' AS inspectionName,
		 '标本类型' AS specimenCategory,
		 FLOOR(10 + (RAND() * 100))AS applyDepartmentCode,
		 '内科' AS applyDepartmentName,
		 FLOOR(100 + (RAND() * 500)) AS applyDoctorCode,
		 '孙医生' AS applyDoctorName,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')AS sendDateTime,
		 '血液检科' AS sendDepartmentName,
		 '王医生' AS sendDoctorName,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')AS inspectionDateTime,
		 DATE_FORMAT(NOW(),'%Y-%m-%d %h:%i:%s')AS reportDateTime,
		 FLOOR(10 + (RAND() * 100)) hospitalizationCode ,
		 '酮体' as itemName,
		 '+' as itemResult,
		 '阴性' as referenceRange,
		 '4' as abnormalPrompt);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryScheduleDetails` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryScheduleDetails` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryScheduleDetails`(
hospitalCode CHAR(40), 
departmentCode CHAR(40),
doctorCode CHAR(40),
scheduleId CHAR(40),
scheduleDate CHAR(40),
timeFlag INT
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取排班明细成功!" AS resultMessage,
		hospitalCode AS hospitalCode,
		departmentCode AS departmentCode,
		doctorCode AS doctorCode,
		CONCAT(FLOOR(1000 + (RAND() * 9000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'))  AS scheduleDetailId,
		1 AS scheduleDetailCategory,
		2 AS timeFlag,
		 DATE_FORMAT(NOW(),'%h:%i') AS  beginTime,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 HOUR),'%h:%i') AS  endTime,
		 26.3 AS appointmentFee,
		 3.6 AS treatFee,
		 50 AS appointmentCount,
		 15 AS surplusCount)
UNION 
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取排班明细成功!" AS resultMessage,
		hospitalCode AS hospitalCode,
		departmentCode AS departmentCode,
		doctorCode AS doctorCode,
		CONCAT(FLOOR(1000 + (RAND() * 9000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleDetailId,
		1 AS scheduleDetailCategory,
		2 AS timeFlag,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 HOUR),'%h:%i') AS  beginTime,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR),'%h:%i') AS  endTime,
		 19.9 AS appointmentFee,
		 34.5 AS treatFee,
		 100 AS appointmentCount,
		 150 AS surplusCount);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QuerySchedules` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QuerySchedules` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QuerySchedules`(
hospitalCode CHAR(40), 
departmentCode CHAR(40),
doctorCode CHAR(40),
beginDate CHAR(40),
endDate CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取排班列表成功!" AS resultMessage,
		hospitalCode as hospitalCode,
		departmentCode as departmentCode,
		'儿童内科' as departmentName,
		CONCAT(FLOOR(1000 + (RAND() * 9000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as scheduleId,
		doctorCode as doctorCode,
		'何医师' as doctorName,
		1 as scheduleCategory,
		DATE_FORMAT(NOW(),'%Y-%m-%d') as scheduleDate,
		2 as timeFlag,
		 DATE_FORMAT(NOW(),'%h:%i') AS  beginTime,
		 DATE_FORMAT(date_add(NOW(), interval 1 hour),'%h:%i') AS  endTime,
		1 as isCanAppointment,
		 26.3 as appointmentFee,
		 3.6 as treatFee,
		 50 as appointmentCount,
		 15 as surplusCount)
UNION 
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取排班列表成功!" AS resultMessage,
		hospitalCode AS hospitalCode,
		departmentCode AS departmentCode,
		'儿童内科' AS departmentName,
		CONCAT(FLOOR(1000 + (RAND() * 9000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleId,
		doctorCode AS doctorCode,
		'张医师' AS doctorName,
		1 AS scheduleCategory,
		DATE_FORMAT(NOW(),'%Y-%m-%d') AS scheduleDate,
		2 AS timeFlag,
		 DATE_FORMAT(NOW(),'%H:%i') AS  beginTime,
		 DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 HOUR),'%H:%i') AS  endTime,
		1 AS isCanAppointment,
		 19.3 AS appointmentFee,
		 4.9AS treatFee,
		 FLOOR(1 + (RAND() * 500))  AS appointmentCount,
		 FLOOR(1 + (RAND() * 500))  AS surplusCount);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryStopSchedules` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryStopSchedules` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryStopSchedules`(
hospitalCode CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取停诊排班信息成功!" AS resultMessage,
		 hospitalCode as hospitalCode,
		 '203' as departmentCode,
		 '599' as doctorCode,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as scheduleId,
		  DATE_FORMAT(NOW(),'%Y-%m-%d') as scheduleDate,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as scheduleDetailId,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 HOUR),'%h:%i') AS  beginTime,
		  dATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR),'%h:%i') AS  endTime,
		  1 as isAllowRefound/*是否允许退费*/)
		  union 
		  (SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取停诊排班信息成功!" AS resultMessage,
		 hospitalCode AS hospitalCode,
		 '204' AS departmentCode,
		 '600' AS doctorCode,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleId,
		  DATE_FORMAT(NOW(),'%Y-%m-%d') AS scheduleDate,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleDetailId,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 HOUR),'%h:%i') AS  beginTime,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR),'%h:%i') AS  endTime,
		  1 AS isAllowRefound/*是否允许退费*/)
		  union 
		 (SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取停诊排班信息成功!" AS resultMessage,
		 hospitalCode AS hospitalCode,
		 '205' AS departmentCode,
		 '601' AS doctorCode,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleId,
		  DATE_FORMAT(NOW(),'%Y-%m-%d') AS scheduleDate,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleDetailId,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 HOUR),'%h:%i') AS  beginTime,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR),'%h:%i') AS  endTime,
		  1 AS isAllowRefound/*是否允许退费*/);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_QueryTreatmentInfos` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_QueryTreatmentInfos` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_QueryTreatmentInfos`(
appointmentCode CHAR(40),
hospitalCode CHAR(40),
patientCode CHAR(40),
patientName CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientMobile CHAR(40),
patientCategory CHAR(40),
beginDate CHAR(40),
endDate CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取预约就诊信息成功!" AS resultMessage,
		 appointmentCode as appointmentCode,
		FLOOR(1 + (RAND() * 100)) AS serialNumber,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as scheduleId,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) as scheduleDetailId,
		  DATE_FORMAT(NOW(),'%Y-%m-%d') AS appointmentDate,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 HOUR),'%h:%i') AS  beginTime,
		  dATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR),'%h:%i') AS  endTime,
		  '2' as timeFlag/*午别*/,
		  hospitalCode AS hospitalCode,
		'3002' AS departmentCode,
		'6300' AS doctorCode,
		'张哈哈' AS patientName,
		'0' AS patientSex,
		'36' AS patientAge,
		'13659862033' AS patientMobile,
		'100236' AS patientCode,
		'5' AS patientIdentityCardType,
		'510566198803126945' AS patientIdentityCardNumber,
		'2' AS patientMedicalCardType,
		'201636524566' AS patientMedicalCardNumber,
		59.6 AS appointmentFee,
		196.36 AS treatFee,
		12 AS appointmentStatus,
		1 AS payStatus)
		  union 
		(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"获取预约就诊信息成功!" AS resultMessage,
		 appointmentCode AS appointmentCode,
		FLOOR(1 + (RAND() * 100)) AS serialNumber,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleId,
		  CONCAT(FLOOR(100 + (RAND() * 1000)),DATE_FORMAT(NOW(),'%Y%m%d%H%i%s')) AS scheduleDetailId,
		  DATE_FORMAT(NOW(),'%Y-%m-%d') AS appointmentDate,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 HOUR),'%h:%i') AS  beginTime,
		  DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR),'%h:%i') AS  endTime,
		  '1' AS timeFlag/*午别*/,
		  hospitalCode AS hospitalCode,
		'3004' AS departmentCode,
		'6303' AS doctorCode,
		'何哈哈' AS patientName,
		'1' AS patientSex,
		'18' AS patientAge,
		'13596845622' AS patientMobile,
		'100235' AS patientCode,
		'5' AS patientIdentityCardType,
		'510599199005196945' AS patientIdentityCardNumber,
		'2' AS patientMedicalCardType,
		'201635986' AS patientMedicalCardNumber,
		89.67 AS appointmentFee,
		269.12 AS treatFee,
		6 AS appointmentStatus,
		1 AS payStatus);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_TakeNoOnline` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_TakeNoOnline` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_TakeNoOnline`(
appointmentCode CHAR(40),
hospitalCode CHAR(40),
patientCode  CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientName CHAR(40),
patientIdentityCardType int,
patientIdentityCardNumber CHAR(40),
patientCategory int,
platformSource CHAR(40)
)
BEGIN
(SELECT 
		1 AS isSuccess,"1001" AS resultCode,"在线取号成功!" AS resultMessage,
		appointmentCode as appointmentCode,
		patientCode as patientCode,
		patientMedicalCardType as patientMedicalCardType,
		patientMedicalCardNumber as patientMedicalCardNumber,
		patientName as patientName,
		0 as patientSex,
		'13698695200' as patientMobile,
		25 as patientAge,
		'1990-07-09' as patientBirthday,
		1 as patientIdentityCardType,
		'510566199602154696' as patientIdentityCardNumber,
		2 as patientCategory,
		'监护人' as guardianName,
		1 as guardianIdentityCardType,
		'510566199502163652' as guardianIdentityCardNumber,
		'13589652100' as guardianMobile,
		'1' as guardianShip,
		date_format(NOW(),'%Y-%m-%d') AS appointmentDate,
		DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 HOUR),'%H:%i') AS  beginTime,
		DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR),'%H:%i') AS  endTime,
		1 AS isPayed,
		1 AS payStatus,
		FLOOR(100 + (RAND() * 1000)) AS appointmentPwd,
		FLOOR(1 + (RAND() * 100)) AS serialNumber,
		'门诊部二楼对应科室就诊' AS location,
		'请带好有效证件前往医院就诊' AS description,
		1 as payCategory);
END */$$
DELIMITER ;

/* Procedure structure for procedure `HK_Proc_UnbindPatientArchiving` */

/*!50003 DROP PROCEDURE IF EXISTS  `HK_Proc_UnbindPatientArchiving` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `HK_Proc_UnbindPatientArchiving`(
patientName CHAR(40), 
patientCode CHAR(40),
patientMedicalCardType CHAR(40),
patientMedicalCardNumber CHAR(40),
patientIdentityCardType CHAR(40),
patientIdentityCardNumber CHAR(40),
patientMobile CHAR(40),
patientSex CHAR(40),
patientAge CHAR(40),
patientBirthday CHAR(40),
patientCategory INT (11),
guardianName CHAR(40),
guardianIdentityCardType CHAR(40),
guardianIdentityCardNumber CHAR(40),
guardianMobile  CHAR(40),
guardianShip  CHAR(40),
familyMemberId CHAR(40)
)
BEGIN
SELECT 1 AS isSuccess,"1001" AS resultCode,"解绑定就诊卡成功!" AS resultMessage;
END */$$
DELIMITER ;

/* Procedure structure for procedure `testp` */

/*!50003 DROP PROCEDURE IF EXISTS  `testp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `testp`(IN td text)
BEGIN
 
END */$$
DELIMITER ;

/* Procedure structure for procedure `YK_Proc_ContinuousSignIn` */

/*!50003 DROP PROCEDURE IF EXISTS  `YK_Proc_ContinuousSignIn` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `YK_Proc_ContinuousSignIn`(IN `uid`  varchar(80),OUT  `status`  tinyint,OUT `plus`  tinyint,OUT `credits`  tinyint,OUT  `errMsg`  varchar(20))
    COMMENT '用户签到存储过程'
BEGIN
	#Routine body goes here...
			/* 定义变量 */  
		SET @newTime = NULL; 
		SET @pastNum = 0;
		SET @scoreDay = 1;
    SET @scoreLianXu = 4;  
    SET @typeId = 1;-- 默认为天签到
		SET @zongScore = 0;

		SELECT @newTime:=pastTime,@zongScore:=totalScore FROM integral_user WHERE userId = uId;
	  
		IF(TO_DAYS(@newTime) = TO_DAYS(NOW())) THEN   	
			SET status = 0;
			SET plus = 0;
			SET credits = @zongScore;
			SET errMsg = '今天签到过了~明天再来把^V^'; 
		ELSE
			 -- 由于无法赋值给外部变量,先查询处理
			 SET @pastCount = 
			(SELECT 
					 CASE 
								WHEN TO_DAYS(pastTime) = TO_DAYS(NOW()) - 1 
									/*外层处理连续签到*/
									THEN
											pastCount
								ELSE/*间断一天重置*/
									0
						END
					FROM integral_user WHERE userId = uId);
			 
       -- 查询天积分和连续签到积分
			 SET @scoreDay = (SELECT score FROM integral_acquire_type WHERE id = 1);
			 SET @scoreLianXu = (SELECT score FROM integral_acquire_type WHERE id = 3);
			 		
       -- 修改签到分数
			 IF @pastCount = 6 THEN
					-- 连续签到分数
					SET @typeId = 3; 
					SET @scoreDay = @scoreDay + @scoreLianXu;          
			 END IF;
			 
			 SET @pastCount = (@pastCount + 1) MOD 8 ;
       -- 修改连续签到天数和分数(满一个周期置0)
			 UPDATE integral_user SET pastCount = (CASE 
																								WHEN @pastCount = 0 
																									THEN 
																											1
																									ELSE 
                                                   @pastCount
																							END),totalScore = totalScore + @scoreDay  WHERE userId = uId; 
			 
			 INSERT INTO integral_acquire(userId,acquireId,score) VALUES(uId,@typeId,@scoreDay);
			 -- 签到成功
       SET status = 1;
       -- 增加的积分
			 SET plus = @scoreDay;
       -- 当前总积分
       SET credits = @zongScore + @scoreDay;
		END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `YK_Proc_GetSignInRelateData` */

/*!50003 DROP PROCEDURE IF EXISTS  `YK_Proc_GetSignInRelateData` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `YK_Proc_GetSignInRelateData`(IN `uId` varchar(80),OUT `toDayScore` tinyint,OUT `tomorrowScore` tinyint,OUT `signCount` tinyint)
    COMMENT '查询签到关联数据'
BEGIN
	#Routine body goes here...
  SET @pastNum = 1;-- 连续签到天数
  SET @scoreNow = 1;-- 今天签到积分
  SET @scoreTomorrow = 1;-- 明天签到积分
  SET @scoreDay = 1;-- 一次签到分数
  SET @scoreLianXu = 4;-- 连续签到分数
  -- 获取签到次数  
  SET @pastNum = (SELECT pastCount FROM integral_user WHERE userId = uId);
	
  -- 查询天积分和连续签到积分
  SET @scoreDay = (SELECT score FROM integral_acquire_type WHERE id = 1);
  SET @scoreLianXu = (SELECT score FROM integral_acquire_type WHERE id = 3);
   
	-- 查询今天连续签到7天,连续签到字段为0的情况
	SET @isTodayLianXu = (SELECT COUNT(1) FROM integral_acquire ac WHERE ac.score = @scoreDay + @scoreLianXu AND TO_DAYS(ac.ctime) = TO_DAYS(NOW()) AND ac.userId = uId);
   
   -- 满足本次连续签到6、7天
   IF(@pastNum = 6) THEN
      SET @scoreTomorrow = @scoreDay + @scoreLianXu;
	 ELSEIF(@isTodayLianXu = 1) THEN
			SET @scoreNow = @scoreDay + @scoreLianXu;
   END IF;
	
   -- RETURN OUT PARAMS 
   SET toDayScore = @scoreNow;
   SET tomorrowScore = @scoreTomorrow;
   SET signCount = @pastNum;
END */$$
DELIMITER ;

/* Procedure structure for procedure `YK_Proc_ShareInvite` */

/*!50003 DROP PROCEDURE IF EXISTS  `YK_Proc_ShareInvite` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`hk`@`%` PROCEDURE `YK_Proc_ShareInvite`(IN `inviteUId` varchar(80),OUT `msgCode` varchar(20),OUT `msgContext` varchar(20))
    COMMENT '用户分享邀请过程'
BEGIN
	#Routine body goes here...
	SET @uId = NULL;
	SET @getStatus = NULL;

  -- 查询邀请人ID	
	SELECT @uId:=userId,@getStatus:=getStatus FROM integral_invite WHERE inviteId = inviteUId; 
	
  IF(@getStatus = 1) THEN
			SET msgCode = '101';
			SET msgContext = '用户已获取过邀请积分!!!';
	ELSE
		  SET @score = (SELECT score FROM integral_acquire_type WHERE id = 2);
			-- 插入积分获取表
			-- 邀请方 and 被邀请方
			INSERT INTO integral_acquire(userId,acquireId,score) VALUES(@uId,2,@score),(inviteUId,2,@score);
			-- 修改邀请方AND邀方总积分
			UPDATE integral_user SET totalScore = totalScore + @score WHERE userId = @uId OR userId = inviteUId;
			-- 修改邀请表
			UPDATE integral_invite SET getStatus = 1 WHERE inviteId = inviteUId;
	END IF;
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
