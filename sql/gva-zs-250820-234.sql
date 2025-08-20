/*
SQLyog Trial v13.1.8 (64 bit)
MySQL - 5.6.50-log : Database - gva
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`gva` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `gva`;

/*Table structure for table `bs_orders` */

DROP TABLE IF EXISTS `bs_orders`;

CREATE TABLE `bs_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `created_at` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(3) DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime(3) DEFAULT NULL COMMENT '删除时间',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `order_sn` varchar(32) NOT NULL COMMENT '商户订单号（唯一）',
  `goods_id` int(11) NOT NULL COMMENT '商品Id',
  `cert_type` varchar(128) NOT NULL COMMENT '订单类型',
  `transaction_id` varchar(32) DEFAULT NULL COMMENT '微信支付订单号',
  `prepay_id` varchar(64) DEFAULT NULL COMMENT '预支付交易会话标识',
  `total_fee` int(11) NOT NULL COMMENT '订单总金额（分）',
  `fee_type` varchar(10) NOT NULL DEFAULT 'CNY' COMMENT '货币类型',
  `body` varchar(128) NOT NULL COMMENT '商品描述',
  `detail` varchar(1024) DEFAULT NULL COMMENT '商品详情（JSON格式）',
  `attach` varchar(127) DEFAULT NULL COMMENT '附加数据',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '订单状态：0-待支付，1-支付成功，2-已关闭，3-已退款',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `expire_time` datetime DEFAULT NULL COMMENT '订单过期时间',
  `end_time` datetime DEFAULT NULL COMMENT '交易完成时间',
  `pay_type` varchar(20) DEFAULT NULL COMMENT '支付方式（JSAPI/APP/NATIVE）',
  `notify_data` text COMMENT '支付结果通知完整内容',
  `refund_fee` int(11) NOT NULL DEFAULT '0' COMMENT '退款金额（分）',
  `extra_field1` varchar(255) DEFAULT NULL COMMENT '扩展字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_order_sn` (`order_sn`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

/*Data for the table `bs_orders` */

insert  into `bs_orders`(`id`,`created_at`,`updated_at`,`deleted_at`,`user_id`,`order_sn`,`goods_id`,`cert_type`,`transaction_id`,`prepay_id`,`total_fee`,`fee_type`,`body`,`detail`,`attach`,`status`,`pay_time`,`expire_time`,`end_time`,`pay_type`,`notify_data`,`refund_fee`,`extra_field1`) values 
(1,'2025-08-09 17:15:21.322','2025-08-09 17:15:21.322',NULL,12,'2025080917152112A1CB5T0N',0,'graduation','','',20,'CNY','培训证书','在线培训书申请','',0,'0000-00-00 00:00:00','2025-08-09 17:30:21','0000-00-00 00:00:00','NATIVE','',0,''),
(2,'2025-08-09 17:48:22.069','2025-08-09 17:48:22.069',NULL,4,'202508091748224H11GZO4O',0,'training','','',20,'CNY','培训证书','在线培训书申请','',1,'0000-00-00 00:00:00','2025-08-09 18:03:22','0000-00-00 00:00:00','NATIVE','',0,''),
(3,'2025-08-11 20:11:21.718','2025-08-11 20:11:21.718','2025-08-17 21:16:22.962',4,'202508112011214N57IU8Y4',0,'training','','',20,'CNY','培训证书','在线培训书申请','',0,'0000-00-00 00:00:00','2025-08-11 20:26:22','0000-00-00 00:00:00','NATIVE','',0,''),
(4,'2025-08-11 22:23:27.582','2025-08-11 22:23:27.582',NULL,29,'2025081122232729YPEK347L',0,'graduation','','',10,'CNY','毕业证书','在线毕业证书申请','',0,'0000-00-00 00:00:00','2025-08-11 22:38:28','0000-00-00 00:00:00','NATIVE','',0,''),
(6,'2025-08-13 09:22:57.680','2025-08-13 09:22:57.680',NULL,4,'202508130922574F73HT1II',0,'training','','',20000,'CNY','培训证书','在线培训书申请','',0,'0000-00-00 00:00:00','2025-08-13 09:37:58','0000-00-00 00:00:00','NATIVE','',0,''),
(7,'2025-08-15 21:55:28.233','2025-08-15 21:55:28.233',NULL,4,'202508152155284SNUILXDD',19,'training','','',2,'CNY','培训证书','在线培训书申请','',1,'0000-00-00 00:00:00','2025-08-15 22:10:28','0000-00-00 00:00:00','NATIVE','',0,'');

/*Table structure for table `bs_students` */

DROP TABLE IF EXISTS `bs_students`;

CREATE TABLE `bs_students` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `uuid` char(36) NOT NULL DEFAULT '' COMMENT '用户UUID',
  `useraccount` varchar(50) NOT NULL DEFAULT '' COMMENT '登录账号',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '姓名',
  `password` varchar(50) NOT NULL DEFAULT '' COMMENT '密码',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `verificationcode` varchar(50) NOT NULL DEFAULT '' COMMENT '验证码',
  `id_card_number` varchar(20) NOT NULL COMMENT '身份证号',
  `extra_field1` varchar(255) DEFAULT NULL COMMENT '扩展字段1',
  `extra_field2` varchar(255) DEFAULT NULL COMMENT '扩展字段2',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uuid` (`uuid`),
  KEY `idx_useraccount` (`useraccount`),
  KEY `idx_email` (`email`),
  KEY `idx_id_card_number` (`id_card_number`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

/*Data for the table `bs_students` */

insert  into `bs_students`(`id`,`uuid`,`useraccount`,`name`,`password`,`email`,`verificationcode`,`id_card_number`,`extra_field1`,`extra_field2`,`created_at`,`updated_at`,`deleted_at`) values 
(4,'b34c9ae5-690e-4978-9b08-723c52bd2660','stone531','李儒伦','47005f33a9a15195fc9548ab86c81c2a','lirulun@126.com','','420222199601185453','','','2025-07-27 17:16:22','2025-08-11 21:16:11',NULL),
(6,'f7bc849f-4162-46e5-87c8-b349293556c2','stoneaaa','','ca6a7064fcebcf2b73735138a49cad87','lirulun@126.com','','','','','2025-07-27 17:26:52','2025-07-27 18:08:31',NULL);

/*Table structure for table `bs_training_students` */

DROP TABLE IF EXISTS `bs_training_students`;

CREATE TABLE `bs_training_students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '学生姓名',
  `gender` tinyint(1) NOT NULL COMMENT '性别（男/女）',
  `id_card_number` varchar(20) NOT NULL COMMENT '身份证号',
  `certificate_name` varchar(500) DEFAULT NULL COMMENT '证书名称',
  `certificate_id` varchar(80) DEFAULT NULL COMMENT '证书编号',
  `issue_date` varchar(100) DEFAULT NULL COMMENT '发证日期',
  `training_program` varchar(800) DEFAULT NULL COMMENT '培训项目',
  `grade` varchar(20) DEFAULT NULL COMMENT '成绩评定',
  `editer` varchar(20) NOT NULL DEFAULT '',
  `extra_field1` varchar(255) DEFAULT NULL COMMENT '扩展字段1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COMMENT='培训技能学生表';

/*Data for the table `bs_training_students` */

insert  into `bs_training_students`(`id`,`name`,`gender`,`id_card_number`,`certificate_name`,`certificate_id`,`issue_date`,`training_program`,`grade`,`editer`,`extra_field1`,`created_at`,`updated_at`,`deleted_at`) values 
(1,'test1',1,'420222198903329874','测试1','114000000000','2023-07','计算机管理','','admin','','2025-07-09 13:34:13','2025-07-09 13:34:13','2025-07-09 14:22:37'),
(2,'test22',1,'420222199601185452','测试1','114000000000','2023-07','计算机管理','合格','admin','','2025-07-09 13:36:15','2025-08-08 20:05:55',NULL),
(3,'test3',1,'420222199601185456','测试3','114000000001','2023-07','计算机管理','合格','admin','','2025-07-09 14:22:29','2025-08-08 20:05:43',NULL),
(4,'abc',1,'420333198901185458','测试001','12323434454','2020-01','测试002','合格','admin','','2025-07-09 21:43:03','2025-07-09 21:43:03',NULL),
(5,'泽泽',1,'430222198901198732','高级管理','1110323243','2022-02','计算机','合格','admin','','2025-07-10 20:45:46','2025-07-10 20:45:46',NULL),
(6,'恩恩1',2,'420333198901198974','测试','1234343','2025-06','aa','合格','admin','','2025-07-12 17:01:08','2025-07-12 17:01:31','2025-07-12 17:03:34'),
(16,'李儒伦',1,'420222199601185453','测试数据','1110323248','2025-01','测试数据1','合格','student','no','2025-08-13 09:17:42','2025-08-13 09:17:42',NULL),
(8,'李儒伦',1,'420222198901185457','计算机','','2025-06','夸你讲','','','','2025-08-09 07:33:34','2025-08-09 07:33:34','2025-08-09 07:48:19'),
(9,'李儒伦',1,'420222198901185457','计算机','','2025-06','会计','','','','2025-08-09 07:48:57','2025-08-09 07:48:57','2025-08-09 07:49:24'),
(10,'李儒伦',1,'420222198901185457','计算机','1110323244','2025-06','会计','','','','2025-08-09 07:50:47','2025-08-09 07:50:47','2025-08-09 07:57:34'),
(11,'李儒伦',1,'420222198901185457','计算机','1110323244','2025-06','测试数据','','student','','2025-08-09 07:58:07','2025-08-09 07:58:07',NULL),
(19,'李儒伦',1,'420222199601185453','测试002','1110323251','2025-07','测试003','合格','student','no','2025-08-15 21:55:28','2025-08-15 21:55:28',NULL),
(18,'李儒伦',1,'420222199601185453','测试002','1110323250','2025-07','测试003','合格','student','no','2025-08-15 21:51:52','2025-08-15 21:51:52',NULL),
(17,'李儒伦',1,'420222199601185453','测试数据1','1110323249','2025-03','测试数据1','合格','student','yes','2025-08-13 09:22:58','2025-08-13 09:22:58',NULL);

/*Table structure for table `bs_zhengshu` */

DROP TABLE IF EXISTS `bs_zhengshu`;

CREATE TABLE `bs_zhengshu` (
  `id` int(200) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `sex` tinyint(1) NOT NULL DEFAULT '1',
  `age` varchar(200) NOT NULL DEFAULT '0',
  `pic` varchar(200) DEFAULT NULL,
  `mingzhu` varchar(10) NOT NULL DEFAULT '0',
  `nativeplace` varchar(50) NOT NULL DEFAULT '1',
  `zzmm` varchar(100) DEFAULT NULL,
  `chengchi` varchar(100) DEFAULT NULL,
  `certificatenumber2` varchar(200) NOT NULL DEFAULT '1212',
  `zhuanye` varchar(100) DEFAULT '0',
  `graduschool` varchar(200) NOT NULL DEFAULT '0',
  `graduschool2` varchar(200) DEFAULT '0',
  `bysj` varchar(100) DEFAULT '0',
  `zwjd` varchar(200) NOT NULL DEFAULT '',
  `demo` mediumtext NOT NULL,
  `editer` varchar(20) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  `publish` varchar(10) DEFAULT 'yes',
  `operation` varchar(256) DEFAULT '',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;

/*Data for the table `bs_zhengshu` */

insert  into `bs_zhengshu`(`id`,`name`,`sex`,`age`,`pic`,`mingzhu`,`nativeplace`,`zzmm`,`chengchi`,`certificatenumber2`,`zhuanye`,`graduschool`,`graduschool2`,`bysj`,`zwjd`,`demo`,`editer`,`date`,`publish`,`operation`,`created_at`,`updated_at`,`deleted_at`) values 
(1,'test1',1,'2025-07-01','uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250705211915.png','汉族','山西','团员','本科','420222199807235434','英语','114158200206036369','北京长城学院','2025-03','good','1234','test001','0000-00-00','yes','','2025-07-02 22:03:45','2025-07-06 18:37:36',NULL),
(2,'张三2',1,'2021-04-11','uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250705094543.jpeg','汉族','北京','','','420222199701235346','compute','11423434232323','0','2017-06','','','admin','0000-00-00','yes','','2025-07-02 22:20:41','2025-07-05 21:11:01',NULL),
(3,'test3',1,'2020-02-07','','藏族','上海','','','1212','水利工程','0','0','2025-02','','','','0000-00-00','yes','','2025-07-03 20:26:27','2025-07-05 21:21:46',NULL),
(4,'aa',1,'yyyy-02','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-03 21:16:34','2025-07-05 21:42:07','2025-07-05 21:42:07'),
(5,'aa',1,'2001-06','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-03 21:24:57','2025-07-05 16:26:44','2025-07-05 16:26:44'),
(6,'stone',1,'yyyy-01','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-04 22:12:45','2025-07-04 22:12:45',NULL),
(7,'aaa',1,'2010-03','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-04 22:24:03','2025-07-04 22:24:03',NULL),
(8,'aaa',1,'2010-03','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-04 22:26:28','2025-07-05 13:30:02','2025-07-05 13:30:02'),
(9,'aaa111',1,'2016-02','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-04 22:39:00','2025-07-04 22:39:00',NULL),
(10,'aaa111',1,'2016-02','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-04 22:41:31','2025-07-04 22:41:31',NULL),
(11,'abcli',1,'2023-02','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-05 09:37:11','2025-07-05 09:37:11',NULL),
(12,'aaa',1,'2024-01','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-05 09:45:04','2025-07-05 09:45:04',NULL),
(13,'stone521',1,'2019-01','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-05 09:46:30','2025-07-05 09:46:30',NULL),
(14,'stone521',1,'2019-01','','0','1','','','1212','0','0','0','0','','','','0000-00-00','yes','','2025-07-05 09:50:56','2025-07-05 09:50:56',NULL),
(15,'stone521',2,'2019-01','uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250705094543.jpeg','0','湖北','tuany','chengci','420222198901185457','manager','111111122222','北京长城学院','2017-06','good','vabc','admin','2025-07-05','yes','','2025-07-05 10:11:48','2025-07-05 10:11:48',NULL),
(16,'stone521',2,'2019-01','uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250705094543.jpeg','0','湖北','tuany','chengci','420222198901185457','manager','111111122222','北京长城学院','2017-06','good','vabc','admin','2025-07-05','yes','','2025-07-05 10:18:39','2025-07-05 10:18:39',NULL),
(17,'stone521',2,'2019-01','uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250705094543.jpeg','汉族','湖北','tuany','chengci','420222198901185457','manager','111111122222','北京长城学院','2017-06','good','vabc','admin','2025-07-05','yes','','2025-07-05 10:23:11','2025-07-05 10:23:11',NULL),
(18,'stone521',2,'2019-01','uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250705094543.jpeg','汉族','湖北','tuany','chengci','420222198901185457','manager','111111122222','北京长城学院','2017-06','good','vabc','admin','2025-07-05','yes','','2025-07-05 10:24:26','2025-07-05 10:24:26',NULL),
(19,'stone521',2,'2019-01','uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250705094543.jpeg','汉族','湖北','tuany','chengci','420222198901185458','manager','114158200206036367','北京长城学院','2017-06','good','vabc','admin','2025-07-05','yes','','2025-07-05 10:45:38','2025-07-05 10:45:38',NULL),
(20,'小高',2,'1990-03-15','uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250711224459.png','苗族','上海','党员','研究生','130234199904213461','英语','114158200206036367','北京长城学院','2021-07','还可以','很不错','admin','2025-07-11','yes','','2025-07-11 21:59:30','2025-07-11 22:45:02',NULL),
(21,'好的',2,'2025-07-16','uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250712175615.png','汉族','重庆','','','110222200311133245','专业','114158200206036367','北京长城学院','2025-10','','','admin','2025-07-12','yes','','2025-07-12 15:45:47','2025-07-12 18:15:17',NULL),
(22,'恩恩',2,'2020-12-29','uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250713113756.png','汉族','湖北','党员','博士后','420222202212234359','人工智能','114158200206036368','北京长城学院','2025-08','非常优秀','很好','admin','2025-07-13','yes','','2025-07-13 11:38:00','2025-07-13 11:38:00',NULL),
(23,'司亚鹏',1,'1980-04-28','img_certificate/2018/202406131718248158.gif','汉族','河北','团员','大专','130705800428091','计算机网络工程','114158200605001057','长城学院','2006-07-30','学习良好','','管理员','0000-00-00',NULL,'','2025-07-15 21:24:11','2025-07-15 21:47:34',NULL),
(24,'李儒伦',1,'1993-07-14','img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250805212703.jpg','汉族','上海','党员','本科','420222199601185453','计算机','114158200605001058','北京长城学院','2015-06','','','admin','2025-08-05','yes','','2025-08-05 21:28:27','2025-08-11 20:41:49','2025-08-11 20:41:47'),
(25,'李恩',2,'2021-08-03','img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807224815.jpg','汉族','重庆','','','420222199012145476','会计','114158200605001059','北京长城学院','2025-03','','','student','2025-08-07','yes','','2025-08-07 22:48:21','2025-08-07 22:56:30','2025-08-07 22:56:30'),
(26,'李恩1',2,'2021-08-03','img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807224815.jpg','汉族','重庆','','','420222199012145472','会计','114158200605001060','北京长城学院','2025-03','','','student','2025-08-07','yes','','2025-08-07 22:52:04','2025-08-07 22:56:32','2025-08-07 22:56:32'),
(27,'李是他',2,'2019-08-05','img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807225745.jpg','汉族','河北','','','420222199809234532','管理学','114158200605001059','北京长城学院','2025-06','','','student','2025-08-07','yes','','2025-08-07 22:57:48','2025-08-07 22:57:48',NULL),
(28,'滴否',1,'2025-07-29','img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807225923.jpg','汉族','山西','','','110222200311133242','外语','114158200605001060','北京长城学院','2025-06','','','student','2025-08-07','yes','','2025-08-07 23:00:05','2025-08-07 23:00:05',NULL),
(29,'李儒伦',1,'2025-08-05','img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250811222257.jpg','汉族','天津','','','420222199601185453','计算机应用','114158200605001061','北京长城学院','2021-06','','','student','2025-08-11','no','','2025-08-11 22:23:28','2025-08-11 22:23:28',NULL);

/*Table structure for table `casbin_rule` */

DROP TABLE IF EXISTS `casbin_rule`;

CREATE TABLE `casbin_rule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ptype` varchar(100) DEFAULT NULL,
  `v0` varchar(100) DEFAULT NULL,
  `v1` varchar(100) DEFAULT NULL,
  `v2` varchar(100) DEFAULT NULL,
  `v3` varchar(100) DEFAULT NULL,
  `v4` varchar(100) DEFAULT NULL,
  `v5` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`)
) ENGINE=InnoDB AUTO_INCREMENT=4484 DEFAULT CHARSET=utf8mb4;

/*Data for the table `casbin_rule` */

insert  into `casbin_rule`(`id`,`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`) values 
(4375,'p','888','/api/createApi','POST','','',''),
(4374,'p','888','/api/deleteApi','POST','','',''),
(4369,'p','888','/api/deleteApisByIds','DELETE','','',''),
(4366,'p','888','/api/enterSyncApi','POST','','',''),
(4371,'p','888','/api/getAllApis','POST','','',''),
(4370,'p','888','/api/getApiById','POST','','',''),
(4367,'p','888','/api/getApiGroups','GET','','',''),
(4372,'p','888','/api/getApiList','POST','','',''),
(4365,'p','888','/api/ignoreApi','POST','','',''),
(4368,'p','888','/api/syncApi','GET','','',''),
(4373,'p','888','/api/updateApi','POST','','',''),
(4377,'p','888','/attachmentCategory/addCategory','POST','','',''),
(4376,'p','888','/attachmentCategory/deleteCategory','POST','','',''),
(4378,'p','888','/attachmentCategory/getCategoryList','GET','','',''),
(4471,'p','888','/authority/copyAuthority','POST','','',''),
(4470,'p','888','/authority/createAuthority','POST','','',''),
(4469,'p','888','/authority/deleteAuthority','POST','','',''),
(4467,'p','888','/authority/getAuthorityList','POST','','',''),
(4466,'p','888','/authority/setDataAuthority','POST','','',''),
(4468,'p','888','/authority/updateAuthority','PUT','','',''),
(4401,'p','888','/authorityBtn/canRemoveAuthorityBtn','POST','','',''),
(4402,'p','888','/authorityBtn/getAuthorityBtn','POST','','',''),
(4403,'p','888','/authorityBtn/setAuthorityBtn','POST','','',''),
(4424,'p','888','/autoCode/addFunc','POST','','',''),
(4432,'p','888','/autoCode/createPackage','POST','','',''),
(4440,'p','888','/autoCode/createTemp','POST','','',''),
(4429,'p','888','/autoCode/delPackage','POST','','',''),
(4425,'p','888','/autoCode/delSysHistory','POST','','',''),
(4438,'p','888','/autoCode/getColumn','GET','','',''),
(4442,'p','888','/autoCode/getDB','GET','','',''),
(4428,'p','888','/autoCode/getMeta','POST','','',''),
(4430,'p','888','/autoCode/getPackage','POST','','',''),
(4426,'p','888','/autoCode/getSysHistory','POST','','',''),
(4441,'p','888','/autoCode/getTables','GET','','',''),
(4431,'p','888','/autoCode/getTemplates','GET','','',''),
(4437,'p','888','/autoCode/installPlugin','POST','','',''),
(4435,'p','888','/autoCode/mcp','POST','','',''),
(4433,'p','888','/autoCode/mcpList','POST','','',''),
(4434,'p','888','/autoCode/mcpTest','POST','','',''),
(4439,'p','888','/autoCode/preview','POST','','',''),
(4436,'p','888','/autoCode/pubPlug','POST','','',''),
(4427,'p','888','/autoCode/rollback','POST','','',''),
(4352,'p','888','/bstraining/create','POST','','',''),
(4350,'p','888','/bstraining/delTrainingById','DELETE','','',''),
(4348,'p','888','/bstraining/getOneTraining','POST','','',''),
(4351,'p','888','/bstraining/getTrainingList','POST','','',''),
(4349,'p','888','/bstraining/setTrainingInfo','PUT','','',''),
(4357,'p','888','/bszhengshu/create','POST','','',''),
(4330,'p','888','/bszhengshu/delOrderById','DELETE','','',''),
(4355,'p','888','/bszhengshu/delZhengshuById','DELETE','','',''),
(4353,'p','888','/bszhengshu/getOneZhengshu','POST','','',''),
(4331,'p','888','/bszhengshu/getOrderList','POST','','',''),
(4356,'p','888','/bszhengshu/getZhengshuList','POST','','',''),
(4354,'p','888','/bszhengshu/setZhengshuInfo','PUT','','',''),
(4464,'p','888','/casbin/getPolicyPathByAuthorityId','POST','','',''),
(4465,'p','888','/casbin/updateCasbin','POST','','',''),
(4360,'p','888','/customer/customer','DELETE','','',''),
(4359,'p','888','/customer/customer','GET','','',''),
(4361,'p','888','/customer/customer','POST','','',''),
(4362,'p','888','/customer/customer','PUT','','',''),
(4358,'p','888','/customer/customerList','GET','','',''),
(4364,'p','888','/demoRecord/create','POST','','',''),
(4363,'p','888','/demoRecord/list','GET','','',''),
(4405,'p','888','/email/emailTest','POST','','',''),
(4404,'p','888','/email/sendEmail','POST','','',''),
(4453,'p','888','/fileUploadAndDownload/breakpointContinue','POST','','',''),
(4452,'p','888','/fileUploadAndDownload/breakpointContinueFinish','POST','','',''),
(4449,'p','888','/fileUploadAndDownload/deleteFile','POST','','',''),
(4448,'p','888','/fileUploadAndDownload/editFileName','POST','','',''),
(4454,'p','888','/fileUploadAndDownload/findFile','GET','','',''),
(4447,'p','888','/fileUploadAndDownload/getFileList','POST','','',''),
(4446,'p','888','/fileUploadAndDownload/importURL','POST','','',''),
(4451,'p','888','/fileUploadAndDownload/removeChunk','POST','','',''),
(4450,'p','888','/fileUploadAndDownload/upload','POST','','',''),
(4391,'p','888','/info/createInfo','POST','','',''),
(4390,'p','888','/info/deleteInfo','DELETE','','',''),
(4389,'p','888','/info/deleteInfoByIds','DELETE','','',''),
(4387,'p','888','/info/findInfo','GET','','',''),
(4386,'p','888','/info/getInfoList','GET','','',''),
(4388,'p','888','/info/updateInfo','PUT','','',''),
(4483,'p','888','/jwt/jsonInBlacklist','POST','','',''),
(4463,'p','888','/menu/addBaseMenu','POST','','',''),
(4455,'p','888','/menu/addMenuAuthority','POST','','',''),
(4461,'p','888','/menu/deleteBaseMenu','POST','','',''),
(4459,'p','888','/menu/getBaseMenuById','POST','','',''),
(4457,'p','888','/menu/getBaseMenuTree','POST','','',''),
(4462,'p','888','/menu/getMenu','POST','','',''),
(4456,'p','888','/menu/getMenuAuthority','POST','','',''),
(4458,'p','888','/menu/getMenuList','POST','','',''),
(4460,'p','888','/menu/updateBaseMenu','POST','','',''),
(4407,'p','888','/simpleUploader/checkFileMd5','GET','','',''),
(4406,'p','888','/simpleUploader/mergeFileMd5','GET','','',''),
(4408,'p','888','/simpleUploader/upload','POST','','',''),
(4341,'p','888','/student/changePassword','POST','','',''),
(4340,'p','888','/student/getCertificateList','GET','','',''),
(4343,'p','888','/student/getInfo','GET','','',''),
(4344,'p','888','/student/initPassword','POST','','',''),
(4346,'p','888','/student/login','POST','','',''),
(4345,'p','888','/student/register','POST','','',''),
(4347,'p','888','/student/sendEmailCode','POST','','',''),
(4342,'p','888','/student/updateField','PUT','','',''),
(4418,'p','888','/sysDictionary/createSysDictionary','POST','','',''),
(4417,'p','888','/sysDictionary/deleteSysDictionary','DELETE','','',''),
(4415,'p','888','/sysDictionary/findSysDictionary','GET','','',''),
(4414,'p','888','/sysDictionary/getSysDictionaryList','GET','','',''),
(4416,'p','888','/sysDictionary/updateSysDictionary','PUT','','',''),
(4422,'p','888','/sysDictionaryDetail/createSysDictionaryDetail','POST','','',''),
(4421,'p','888','/sysDictionaryDetail/deleteSysDictionaryDetail','DELETE','','',''),
(4420,'p','888','/sysDictionaryDetail/findSysDictionaryDetail','GET','','',''),
(4419,'p','888','/sysDictionaryDetail/getSysDictionaryDetailList','GET','','',''),
(4423,'p','888','/sysDictionaryDetail/updateSysDictionaryDetail','PUT','','',''),
(4400,'p','888','/sysExportTemplate/createSysExportTemplate','POST','','',''),
(4399,'p','888','/sysExportTemplate/deleteSysExportTemplate','DELETE','','',''),
(4398,'p','888','/sysExportTemplate/deleteSysExportTemplateByIds','DELETE','','',''),
(4394,'p','888','/sysExportTemplate/exportExcel','GET','','',''),
(4393,'p','888','/sysExportTemplate/exportTemplate','GET','','',''),
(4396,'p','888','/sysExportTemplate/findSysExportTemplate','GET','','',''),
(4395,'p','888','/sysExportTemplate/getSysExportTemplateList','GET','','',''),
(4392,'p','888','/sysExportTemplate/importExcel','POST','','',''),
(4397,'p','888','/sysExportTemplate/updateSysExportTemplate','PUT','','',''),
(4413,'p','888','/sysOperationRecord/createSysOperationRecord','POST','','',''),
(4410,'p','888','/sysOperationRecord/deleteSysOperationRecord','DELETE','','',''),
(4409,'p','888','/sysOperationRecord/deleteSysOperationRecordByIds','DELETE','','',''),
(4412,'p','888','/sysOperationRecord/findSysOperationRecord','GET','','',''),
(4411,'p','888','/sysOperationRecord/getSysOperationRecordList','GET','','',''),
(4385,'p','888','/sysParams/createSysParams','POST','','',''),
(4384,'p','888','/sysParams/deleteSysParams','DELETE','','',''),
(4383,'p','888','/sysParams/deleteSysParamsByIds','DELETE','','',''),
(4381,'p','888','/sysParams/findSysParams','GET','','',''),
(4379,'p','888','/sysParams/getSysParam','GET','','',''),
(4380,'p','888','/sysParams/getSysParamsList','GET','','',''),
(4382,'p','888','/sysParams/updateSysParams','PUT','','',''),
(4445,'p','888','/system/getServerInfo','POST','','',''),
(4444,'p','888','/system/getSystemConfig','POST','','',''),
(4443,'p','888','/system/setSystemConfig','POST','','',''),
(4481,'p','888','/user/admin_register','POST','','',''),
(4475,'p','888','/user/changePassword','POST','','',''),
(4482,'p','888','/user/deleteUser','DELETE','','',''),
(4477,'p','888','/user/getUserInfo','GET','','',''),
(4480,'p','888','/user/getUserList','POST','','',''),
(4473,'p','888','/user/resetPassword','POST','','',''),
(4478,'p','888','/user/setSelfInfo','PUT','','',''),
(4472,'p','888','/user/setSelfSetting','PUT','','',''),
(4476,'p','888','/user/setUserAuthorities','POST','','',''),
(4474,'p','888','/user/setUserAuthority','POST','','',''),
(4479,'p','888','/user/setUserInfo','PUT','','',''),
(4333,'p','888','student/certificate-create','POST','','',''),
(4334,'p','888','student/order-detail/:orderSn','GET','','',''),
(4339,'p','888','student/order-my-pending','GET','','',''),
(4338,'p','888','student/order-pay/:orderSn','POST','','',''),
(4336,'p','888','student/order-refresh/:orderSn','POST','','',''),
(4337,'p','888','student/order-status/:orderSn','GET','','',''),
(4335,'p','888','student/order-wechat-notify','POST','','',''),
(4332,'p','888','student/training-create','POST','','',''),
(128,'p','8881','/api/createApi','POST','','',''),
(131,'p','8881','/api/deleteApi','POST','','',''),
(133,'p','8881','/api/getAllApis','POST','','',''),
(130,'p','8881','/api/getApiById','POST','','',''),
(129,'p','8881','/api/getApiList','POST','','',''),
(132,'p','8881','/api/updateApi','POST','','',''),
(134,'p','8881','/authority/createAuthority','POST','','',''),
(135,'p','8881','/authority/deleteAuthority','POST','','',''),
(136,'p','8881','/authority/getAuthorityList','POST','','',''),
(137,'p','8881','/authority/setDataAuthority','POST','','',''),
(156,'p','8881','/casbin/getPolicyPathByAuthorityId','POST','','',''),
(155,'p','8881','/casbin/updateCasbin','POST','','',''),
(162,'p','8881','/customer/customer','DELETE','','',''),
(163,'p','8881','/customer/customer','GET','','',''),
(160,'p','8881','/customer/customer','POST','','',''),
(161,'p','8881','/customer/customer','PUT','','',''),
(164,'p','8881','/customer/customerList','GET','','',''),
(152,'p','8881','/fileUploadAndDownload/deleteFile','POST','','',''),
(153,'p','8881','/fileUploadAndDownload/editFileName','POST','','',''),
(151,'p','8881','/fileUploadAndDownload/getFileList','POST','','',''),
(154,'p','8881','/fileUploadAndDownload/importURL','POST','','',''),
(150,'p','8881','/fileUploadAndDownload/upload','POST','','',''),
(157,'p','8881','/jwt/jsonInBlacklist','POST','','',''),
(140,'p','8881','/menu/addBaseMenu','POST','','',''),
(142,'p','8881','/menu/addMenuAuthority','POST','','',''),
(144,'p','8881','/menu/deleteBaseMenu','POST','','',''),
(146,'p','8881','/menu/getBaseMenuById','POST','','',''),
(141,'p','8881','/menu/getBaseMenuTree','POST','','',''),
(138,'p','8881','/menu/getMenu','POST','','',''),
(143,'p','8881','/menu/getMenuAuthority','POST','','',''),
(139,'p','8881','/menu/getMenuList','POST','','',''),
(145,'p','8881','/menu/updateBaseMenu','POST','','',''),
(158,'p','8881','/system/getSystemConfig','POST','','',''),
(159,'p','8881','/system/setSystemConfig','POST','','',''),
(127,'p','8881','/user/admin_register','POST','','',''),
(147,'p','8881','/user/changePassword','POST','','',''),
(165,'p','8881','/user/getUserInfo','GET','','',''),
(148,'p','8881','/user/getUserList','POST','','',''),
(149,'p','8881','/user/setUserAuthority','POST','','',''),
(167,'p','9528','/api/createApi','POST','','',''),
(170,'p','9528','/api/deleteApi','POST','','',''),
(172,'p','9528','/api/getAllApis','POST','','',''),
(169,'p','9528','/api/getApiById','POST','','',''),
(168,'p','9528','/api/getApiList','POST','','',''),
(171,'p','9528','/api/updateApi','POST','','',''),
(173,'p','9528','/authority/createAuthority','POST','','',''),
(174,'p','9528','/authority/deleteAuthority','POST','','',''),
(175,'p','9528','/authority/getAuthorityList','POST','','',''),
(176,'p','9528','/authority/setDataAuthority','POST','','',''),
(204,'p','9528','/autoCode/createTemp','POST','','',''),
(195,'p','9528','/casbin/getPolicyPathByAuthorityId','POST','','',''),
(194,'p','9528','/casbin/updateCasbin','POST','','',''),
(202,'p','9528','/customer/customer','DELETE','','',''),
(200,'p','9528','/customer/customer','GET','','',''),
(201,'p','9528','/customer/customer','POST','','',''),
(199,'p','9528','/customer/customer','PUT','','',''),
(203,'p','9528','/customer/customerList','GET','','',''),
(191,'p','9528','/fileUploadAndDownload/deleteFile','POST','','',''),
(192,'p','9528','/fileUploadAndDownload/editFileName','POST','','',''),
(190,'p','9528','/fileUploadAndDownload/getFileList','POST','','',''),
(193,'p','9528','/fileUploadAndDownload/importURL','POST','','',''),
(189,'p','9528','/fileUploadAndDownload/upload','POST','','',''),
(196,'p','9528','/jwt/jsonInBlacklist','POST','','',''),
(179,'p','9528','/menu/addBaseMenu','POST','','',''),
(181,'p','9528','/menu/addMenuAuthority','POST','','',''),
(183,'p','9528','/menu/deleteBaseMenu','POST','','',''),
(185,'p','9528','/menu/getBaseMenuById','POST','','',''),
(180,'p','9528','/menu/getBaseMenuTree','POST','','',''),
(177,'p','9528','/menu/getMenu','POST','','',''),
(182,'p','9528','/menu/getMenuAuthority','POST','','',''),
(178,'p','9528','/menu/getMenuList','POST','','',''),
(184,'p','9528','/menu/updateBaseMenu','POST','','',''),
(197,'p','9528','/system/getSystemConfig','POST','','',''),
(198,'p','9528','/system/setSystemConfig','POST','','',''),
(166,'p','9528','/user/admin_register','POST','','',''),
(186,'p','9528','/user/changePassword','POST','','',''),
(205,'p','9528','/user/getUserInfo','GET','','',''),
(187,'p','9528','/user/getUserList','POST','','',''),
(188,'p','9528','/user/setUserAuthority','POST','','','');

/*Table structure for table `demo_records` */

DROP TABLE IF EXISTS `demo_records`;

CREATE TABLE `demo_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='Demo记录表';

/*Data for the table `demo_records` */

insert  into `demo_records`(`id`,`title`,`content`,`created_at`,`updated_at`,`deleted_at`) values 
(1,'test001','001 content.l love beijing','2025-06-28 21:59:42','2025-06-28 21:59:42',NULL),
(2,'test001','abcdefg','2025-06-28 22:05:50','2025-06-28 22:05:50',NULL),
(3,'111','222','2025-06-28 22:43:11','2025-06-28 22:43:11',NULL);

/*Table structure for table `exa_attachment_category` */

DROP TABLE IF EXISTS `exa_attachment_category`;

CREATE TABLE `exa_attachment_category` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT '分类名称',
  `pid` bigint(20) DEFAULT '0' COMMENT '父节点ID',
  PRIMARY KEY (`id`),
  KEY `idx_exa_attachment_category_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `exa_attachment_category` */

/*Table structure for table `exa_customers` */

DROP TABLE IF EXISTS `exa_customers`;

CREATE TABLE `exa_customers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `customer_name` varchar(191) DEFAULT NULL COMMENT '客户名',
  `customer_phone_data` varchar(191) DEFAULT NULL COMMENT '客户手机号',
  `sys_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '管理ID',
  `sys_user_authority_id` bigint(20) unsigned DEFAULT NULL COMMENT '管理角色ID',
  PRIMARY KEY (`id`),
  KEY `idx_exa_customers_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `exa_customers` */

/*Table structure for table `exa_file_chunks` */

DROP TABLE IF EXISTS `exa_file_chunks`;

CREATE TABLE `exa_file_chunks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `exa_file_id` bigint(20) unsigned DEFAULT NULL,
  `file_chunk_number` bigint(20) DEFAULT NULL,
  `file_chunk_path` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_exa_file_chunks_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `exa_file_chunks` */

/*Table structure for table `exa_file_upload_and_downloads` */

DROP TABLE IF EXISTS `exa_file_upload_and_downloads`;

CREATE TABLE `exa_file_upload_and_downloads` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '文件名',
  `class_id` bigint(20) DEFAULT '0' COMMENT '分类id',
  `url` varchar(191) DEFAULT NULL COMMENT '文件地址',
  `tag` varchar(191) DEFAULT NULL COMMENT '文件标签',
  `key` varchar(191) DEFAULT NULL COMMENT '编号',
  PRIMARY KEY (`id`),
  KEY `idx_exa_file_upload_and_downloads_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;

/*Data for the table `exa_file_upload_and_downloads` */

insert  into `exa_file_upload_and_downloads`(`id`,`created_at`,`updated_at`,`deleted_at`,`name`,`class_id`,`url`,`tag`,`key`) values 
(1,'2025-06-23 17:31:41.283','2025-06-23 17:31:41.283',NULL,'10.png',0,'https://qmplusimg.henrongyi.top/gvalogo.png','png','158787308910.png'),
(2,'2025-06-23 17:31:41.283','2025-06-23 17:31:41.283',NULL,'logo.png',0,'https://qmplusimg.henrongyi.top/1576554439myAvatar.png','png','1587973709logo.png'),
(3,'2025-07-02 20:16:45.990','2025-07-02 20:16:45.990',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250702201645.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250702201645.jpeg'),
(4,'2025-07-03 21:49:22.273','2025-07-03 21:49:22.273',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250703214922.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250703214922.jpeg'),
(5,'2025-07-04 21:47:23.104','2025-07-04 21:47:23.104',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250704214723.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250704214723.jpeg'),
(6,'2025-07-04 21:55:33.020','2025-07-04 21:55:33.020',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250704215532.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250704215532.jpeg'),
(7,'2025-07-04 22:12:37.287','2025-07-04 22:12:37.287',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250704221237.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250704221237.jpeg'),
(8,'2025-07-04 22:26:14.088','2025-07-04 22:26:14.088',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250704222614.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250704222614.jpeg'),
(9,'2025-07-04 22:33:43.646','2025-07-04 22:33:43.646',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250704223343.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250704223343.jpeg'),
(10,'2025-07-04 22:38:54.576','2025-07-04 22:38:54.576',NULL,'WechatIMG23.jpeg',0,'uploads/file/7a3ba10cafc239b8944fdb79cca7345b_20250704223854.jpeg','jpeg','7a3ba10cafc239b8944fdb79cca7345b_20250704223854.jpeg'),
(14,'2025-07-05 21:19:15.527','2025-07-05 21:19:15.527',NULL,'aaa.png',0,'uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250705211915.png','png','47bce5c74f589f4867dbd57e9ca9f808_20250705211915.png'),
(15,'2025-07-11 22:44:59.363','2025-07-11 22:44:59.363',NULL,'aaa.png',0,'uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250711224459.png','png','47bce5c74f589f4867dbd57e9ca9f808_20250711224459.png'),
(16,'2025-07-12 17:56:15.889','2025-07-12 17:56:15.889',NULL,'aaa.png',0,'uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250712175615.png','png','47bce5c74f589f4867dbd57e9ca9f808_20250712175615.png'),
(17,'2025-07-13 11:37:56.982','2025-07-13 11:37:56.982',NULL,'aaa.png',0,'uploads/file/47bce5c74f589f4867dbd57e9ca9f808_20250713113756.png','png','47bce5c74f589f4867dbd57e9ca9f808_20250713113756.png'),
(18,'2025-08-05 21:27:03.451','2025-08-05 21:27:03.451',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250805212703.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250805212703.jpg'),
(19,'2025-08-07 22:48:15.773','2025-08-07 22:48:15.773',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807224815.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250807224815.jpg'),
(20,'2025-08-07 22:57:03.051','2025-08-07 22:57:03.051',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807225703.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250807225703.jpg'),
(21,'2025-08-07 22:57:45.100','2025-08-07 22:57:45.100',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807225745.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250807225745.jpg'),
(22,'2025-08-07 22:59:23.780','2025-08-07 22:59:23.780',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250807225923.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250807225923.jpg'),
(23,'2025-08-11 21:53:32.687','2025-08-11 21:53:32.687',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250811215332.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250811215332.jpg'),
(24,'2025-08-11 21:54:07.760','2025-08-11 21:54:07.760',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250811215407.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250811215407.jpg'),
(25,'2025-08-11 22:22:57.581','2025-08-11 22:22:57.581',NULL,'pic.jpg',0,'img_certificate/2018/ed09636a6ea24a292460866afdd7a89a_20250811222257.jpg','jpg','ed09636a6ea24a292460866afdd7a89a_20250811222257.jpg');

/*Table structure for table `exa_files` */

DROP TABLE IF EXISTS `exa_files`;

CREATE TABLE `exa_files` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `file_name` varchar(191) DEFAULT NULL,
  `file_md5` varchar(191) DEFAULT NULL,
  `file_path` varchar(191) DEFAULT NULL,
  `chunk_total` bigint(20) DEFAULT NULL,
  `is_finish` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_exa_files_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `exa_files` */

/*Table structure for table `gva_announcements_info` */

DROP TABLE IF EXISTS `gva_announcements_info`;

CREATE TABLE `gva_announcements_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `title` varchar(191) DEFAULT NULL COMMENT '公告标题',
  `content` text COMMENT '公告内容',
  `user_id` bigint(20) DEFAULT NULL COMMENT '发布者',
  `attachments` varchar(191) DEFAULT NULL COMMENT '相关附件',
  PRIMARY KEY (`id`),
  KEY `idx_gva_announcements_info_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='公告信息表';

/*Data for the table `gva_announcements_info` */

insert  into `gva_announcements_info`(`id`,`created_at`,`updated_at`,`deleted_at`,`title`,`content`,`user_id`,`attachments`) values 
(1,'2025-06-30 20:17:16.000',NULL,NULL,'欢迎使用来到北京长城学院证书后台管理平台','这是系统自动生成的公告。',NULL,NULL);

/*Table structure for table `jwt_blacklists` */

DROP TABLE IF EXISTS `jwt_blacklists`;

CREATE TABLE `jwt_blacklists` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `jwt` text COMMENT 'jwt',
  PRIMARY KEY (`id`),
  KEY `idx_jwt_blacklists_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;

/*Data for the table `jwt_blacklists` */

insert  into `jwt_blacklists`(`id`,`created_at`,`updated_at`,`deleted_at`,`jwt`) values 
(5,'2025-06-30 09:12:51.198','2025-06-30 09:12:51.198',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MTQzNjMyMSwibmJmIjoxNzUwODMxNTIxfQ.0HI-ragUK30MhQx6HyE3i6NjWXSyh6B3Am236l38fBw'),
(6,'2025-06-30 21:00:50.756','2025-06-30 21:00:50.756',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MTg5MTM2MiwibmJmIjoxNzUxMjg2NTYyfQ.j0WkGcSd0dopH7QIipH2Y7UXxU6B-s6FNsqI8FVD_Kw'),
(7,'2025-06-30 21:20:26.636','2025-06-30 21:20:26.636',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MTg5MzI2OSwibmJmIjoxNzUxMjg4NDY5fQ.f6WnOTlF4FAxKK_dwJTum0087Q23LUHfcN6jN1oXgr8'),
(8,'2025-06-30 21:27:10.755','2025-06-30 21:27:10.755',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MTg5NDQ0OSwibmJmIjoxNzUxMjg5NjQ5fQ.ZLEeTbr4VwPLljwyosJofhkGpbxMkRz7LYiLagH8D7s'),
(9,'2025-07-05 21:16:04.536','2025-07-05 21:16:04.536',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MjMwMzExMywibmJmIjoxNzUxNjk4MzEzfQ.Lg1Vnx0oy_6Z2K8_Q8uyS3rBBqpc7jLdK326xfbfYPA'),
(10,'2025-07-06 08:01:06.140','2025-07-06 08:01:06.140',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MjMyNjE3NywibmJmIjoxNzUxNzIxMzc3fQ.dtpHRHNjDmzzdyGEOGzTsfsz1uGaAhRK_YjnbMcoQeg'),
(11,'2025-07-06 20:43:03.275','2025-07-06 20:43:03.275',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MjM2NjgyOSwibmJmIjoxNzUxNzYyMDI5fQ.EERlqiXTmM4OFTbdujF1j9k11KOAsx7Dduy1eUOWXHQ'),
(12,'2025-07-06 21:25:57.451','2025-07-06 21:25:57.451',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MjQxMjc4OSwibmJmIjoxNzUxODA3OTg5fQ.4fJD3WQKdsLd_x2ZzDLKVvWQdjNkIjPsd8y4uzJdE3c'),
(13,'2025-07-07 20:36:06.163','2025-07-07 20:36:06.163',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MjQxMzU5OSwibmJmIjoxNzUxODA4Nzk5fQ.tvklv0hsgAbgzKUui1y1jzlIVvy9XFMRb97zJUU80TU'),
(14,'2025-07-15 12:33:45.154','2025-07-15 12:33:45.154',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MjY1MDEwMiwibmJmIjoxNzUyMDQ1MzAyfQ.4btWDIG-XcJ9XtKRE7jThrmey_iJQgH_JGW7PVL0rXU'),
(15,'2025-07-20 11:59:50.748','2025-07-20 11:59:50.748',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1MzE5MTkwNywibmJmIjoxNzUyNTg3MTA3fQ.lD0oP0fJOAt9DWR8vPmc1MJgiPwIRJjrEXDWODBQRAg'),
(16,'2025-07-27 16:17:23.270','2025-07-27 16:17:23.270',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1Mzg3Nzg4NywibmJmIjoxNzUzMjczMDg3fQ.cXI8TfWg_i4lFW-16UU0u0bLTEkbxqTylYtPKVBq1Xo'),
(17,'2025-07-27 17:55:09.716','2025-07-27 17:55:09.716',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NDIwOTA2NCwibmJmIjoxNzUzNjA0MjY0fQ.0Fq5Q5kaZDTdEKohKJiLq8QR368VNiS59KGbB1MxbCs'),
(18,'2025-07-28 22:58:52.305','2025-07-28 22:58:52.305',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NDIzMTc0MywibmJmIjoxNzUzNjI2OTQzfQ.rtpRpNEL-w8f9omfHDWxeEeJ0IZdOTFZVnuduNgDM84'),
(19,'2025-07-31 13:27:16.449','2025-07-31 13:27:16.449',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NDU0NDQxNiwibmJmIjoxNzUzOTM5NjE2fQ.m7AFG4-AYE-IIJAflzeOTgPxejReTB1Y0ouumyuC1hI'),
(20,'2025-07-31 13:27:38.009','2025-07-31 13:27:38.009',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NDU0NDQ1MiwibmJmIjoxNzUzOTM5NjUyfQ.sz6scyYEUljJMpamUm0nKsSccGX1cAUZsHGRgnfbhvw'),
(21,'2025-07-31 16:18:54.460','2025-07-31 16:18:54.460',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NDU1NDcyOSwibmJmIjoxNzUzOTQ5OTI5fQ._073oN2iN5nPa315KG8TNHl9s1N4OSQvoWkdByVghAQ'),
(22,'2025-07-31 21:00:05.784','2025-07-31 21:00:05.784',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NDMxOTU0NCwibmJmIjoxNzUzNzE0NzQ0fQ.IEGqM31mWsEUGLD7hE9QGV2RHQiPypaB6EgejTdUsQs'),
(23,'2025-08-04 20:44:47.225','2025-08-04 20:44:47.225',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NDU3MTcwMiwibmJmIjoxNzUzOTY2OTAyfQ.gFzHACNYIaJltBdoPeQHinHeo1ZkRdVgMdGKuURsydc'),
(24,'2025-08-08 12:33:06.355','2025-08-08 12:33:06.355',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NTIyNzQ5OCwibmJmIjoxNzU0NjIyNjk4fQ.iE72l9DBegmzVge-I9_SW9Ro2bFz5TTMJG-QaQhZDeA'),
(25,'2025-08-11 21:18:59.474','2025-08-11 21:18:59.474',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NTMwMDY0OSwibmJmIjoxNzU0Njk1ODQ5fQ.I68NUwkCV2ULF8LFzO6KpKD_L2ZumKU2tPqsmDtqza4'),
(26,'2025-08-11 21:53:15.927','2025-08-11 21:53:15.927',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NTUyMzIzMiwibmJmIjoxNzU0OTE4NDMyfQ.L_ZoBbY4OXnvCqax2G7iaWuOFG3qyIcErrPno6IK6ow'),
(27,'2025-08-11 22:22:38.144','2025-08-11 22:22:38.144',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NTUyNjc4MSwibmJmIjoxNzU0OTIxOTgxfQ.727GDe49yRN-SxSuQO4wxSfzHwALeqQSoYfJvGW8Gkc'),
(28,'2025-08-12 21:35:39.791','2025-08-12 21:35:39.791',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NTYwNjA3NSwibmJmIjoxNzU1MDAxMjc1fQ.2BH2yw7AB48Xmo3ojorwc8zpqUVHFhiBKiAW5sCOyaU'),
(29,'2025-08-13 09:07:22.368','2025-08-13 09:07:22.368',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NTQ4ODgwNywibmJmIjoxNzU0ODg0MDA3fQ.l-p_5eqhxI-nGJVQ9-txydiG_OHBHyM_99Jz8B7mAtM'),
(30,'2025-08-15 21:51:01.027','2025-08-15 21:51:01.027',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NTYxMTQ2OSwibmJmIjoxNzU1MDA2NjY5fQ.7PJbR0AM0y5zYttRnfWMpediIu_zQemuKhXt7heUcN8'),
(31,'2025-08-18 20:51:40.668','2025-08-18 20:51:40.668',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NjA0MDYzMSwibmJmIjoxNzU1NDM1ODMxfQ.Va0paE31Qa4lhcvZyFrRzrMZJ1crxcEC6cAfsIuSiWs'),
(32,'2025-08-19 13:53:50.334','2025-08-19 13:53:50.334',NULL,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVVUlEIjoiZjllYzcxMWEtMTRiYy00ZjRjLWEwMGQtOGMyNGNmMDY2OWU5IiwiSUQiOjEsIlVzZXJuYW1lIjoiYWRtaW4iLCJOaWNrTmFtZSI6Iui2heeuoSIsIkF1dGhvcml0eUlkIjo4ODgsIkJ1ZmZlclRpbWUiOjg2NDAwLCJpc3MiOiJxbVBsdXMiLCJhdWQiOlsiR1ZBIl0sImV4cCI6MTc1NjE4NzYyMywibmJmIjoxNzU1MDU5MDYyfQ.Ftzi-D_-xh6Trfl-PR15ACa-MoC6ujFCsk2KlHrXsuo');

/*Table structure for table `sys_apis` */

DROP TABLE IF EXISTS `sys_apis`;

CREATE TABLE `sys_apis` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `path` varchar(191) DEFAULT NULL COMMENT 'api路径',
  `description` varchar(191) DEFAULT NULL COMMENT 'api中文描述',
  `api_group` varchar(191) DEFAULT NULL COMMENT 'api组',
  `method` varchar(191) DEFAULT 'POST' COMMENT '方法',
  PRIMARY KEY (`id`),
  KEY `idx_sys_apis_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_apis` */

insert  into `sys_apis`(`id`,`created_at`,`updated_at`,`deleted_at`,`path`,`description`,`api_group`,`method`) values 
(1,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/jwt/jsonInBlacklist','jwt加入黑名单(退出，必选)','jwt','POST'),
(2,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/deleteUser','删除用户','系统用户','DELETE'),
(3,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/admin_register','用户注册','系统用户','POST'),
(4,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/getUserList','获取用户列表','系统用户','POST'),
(5,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/setUserInfo','设置用户信息','系统用户','PUT'),
(6,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/setSelfInfo','设置自身信息(必选)','系统用户','PUT'),
(7,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/getUserInfo','获取自身信息(必选)','系统用户','GET'),
(8,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/setUserAuthorities','设置权限组','系统用户','POST'),
(9,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/changePassword','修改密码（建议选择)','系统用户','POST'),
(10,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/setUserAuthority','修改用户角色(必选)','系统用户','POST'),
(11,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/resetPassword','重置用户密码','系统用户','POST'),
(12,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/user/setSelfSetting','用户界面配置','系统用户','PUT'),
(13,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/createApi','创建api','api','POST'),
(14,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/deleteApi','删除Api','api','POST'),
(15,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/updateApi','更新Api','api','POST'),
(16,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/getApiList','获取api列表','api','POST'),
(17,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/getAllApis','获取所有api','api','POST'),
(18,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/getApiById','获取api详细信息','api','POST'),
(19,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/deleteApisByIds','批量删除api','api','DELETE'),
(20,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/syncApi','获取待同步API','api','GET'),
(21,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/getApiGroups','获取路由组','api','GET'),
(22,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/enterSyncApi','确认同步API','api','POST'),
(23,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/api/ignoreApi','忽略API','api','POST'),
(24,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authority/copyAuthority','拷贝角色','角色','POST'),
(25,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authority/createAuthority','创建角色','角色','POST'),
(26,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authority/deleteAuthority','删除角色','角色','POST'),
(27,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authority/updateAuthority','更新角色信息','角色','PUT'),
(28,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authority/getAuthorityList','获取角色列表','角色','POST'),
(29,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authority/setDataAuthority','设置角色资源权限','角色','POST'),
(30,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/casbin/updateCasbin','更改角色api权限','casbin','POST'),
(31,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/casbin/getPolicyPathByAuthorityId','获取权限列表','casbin','POST'),
(32,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/addBaseMenu','新增菜单','菜单','POST'),
(33,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/getMenu','获取菜单树(必选)','菜单','POST'),
(34,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/deleteBaseMenu','删除菜单','菜单','POST'),
(35,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/updateBaseMenu','更新菜单','菜单','POST'),
(36,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/getBaseMenuById','根据id获取菜单','菜单','POST'),
(37,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/getMenuList','分页获取基础menu列表','菜单','POST'),
(38,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/getBaseMenuTree','获取用户动态路由','菜单','POST'),
(39,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/getMenuAuthority','获取指定角色menu','菜单','POST'),
(40,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/menu/addMenuAuthority','增加menu和角色关联关系','菜单','POST'),
(41,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/findFile','寻找目标文件（秒传）','分片上传','GET'),
(42,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/breakpointContinue','断点续传','分片上传','POST'),
(43,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/breakpointContinueFinish','断点续传完成','分片上传','POST'),
(44,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/removeChunk','上传完成移除文件','分片上传','POST'),
(45,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/upload','文件上传（建议选择）','文件上传与下载','POST'),
(46,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/deleteFile','删除文件','文件上传与下载','POST'),
(47,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/editFileName','文件名或者备注编辑','文件上传与下载','POST'),
(48,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/getFileList','获取上传文件列表','文件上传与下载','POST'),
(49,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/fileUploadAndDownload/importURL','导入URL','文件上传与下载','POST'),
(50,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/system/getServerInfo','获取服务器信息','系统服务','POST'),
(51,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/system/getSystemConfig','获取配置文件内容','系统服务','POST'),
(52,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/system/setSystemConfig','设置配置文件内容','系统服务','POST'),
(53,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/customer/customer','更新客户','客户','PUT'),
(54,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/customer/customer','创建客户','客户','POST'),
(55,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/customer/customer','删除客户','客户','DELETE'),
(56,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/customer/customer','获取单一客户','客户','GET'),
(57,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/customer/customerList','获取客户列表','客户','GET'),
(58,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/getDB','获取所有数据库','代码生成器','GET'),
(59,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/getTables','获取数据库表','代码生成器','GET'),
(60,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/createTemp','自动化代码','代码生成器','POST'),
(61,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/preview','预览自动化代码','代码生成器','POST'),
(62,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/getColumn','获取所选table的所有字段','代码生成器','GET'),
(63,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/installPlugin','安装插件','代码生成器','POST'),
(64,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/pubPlug','打包插件','代码生成器','POST'),
(65,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/mcp','自动生成 MCP Tool 模板','代码生成器','POST'),
(66,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/mcpTest','MCP Tool 测试','代码生成器','POST'),
(67,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/mcpList','获取 MCP ToolList','代码生成器','POST'),
(68,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/createPackage','配置模板','模板配置','POST'),
(69,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/getTemplates','获取模板文件','模板配置','GET'),
(70,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/getPackage','获取所有模板','模板配置','POST'),
(71,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/delPackage','删除模板','模板配置','POST'),
(72,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/getMeta','获取meta信息','代码生成器历史','POST'),
(73,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/rollback','回滚自动生成代码','代码生成器历史','POST'),
(74,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/getSysHistory','查询回滚记录','代码生成器历史','POST'),
(75,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/delSysHistory','删除回滚记录','代码生成器历史','POST'),
(76,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/autoCode/addFunc','增加模板方法','代码生成器历史','POST'),
(77,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionaryDetail/updateSysDictionaryDetail','更新字典内容','系统字典详情','PUT'),
(78,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionaryDetail/createSysDictionaryDetail','新增字典内容','系统字典详情','POST'),
(79,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionaryDetail/deleteSysDictionaryDetail','删除字典内容','系统字典详情','DELETE'),
(80,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionaryDetail/findSysDictionaryDetail','根据ID获取字典内容','系统字典详情','GET'),
(81,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionaryDetail/getSysDictionaryDetailList','获取字典内容列表','系统字典详情','GET'),
(82,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionary/createSysDictionary','新增字典','系统字典','POST'),
(83,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionary/deleteSysDictionary','删除字典','系统字典','DELETE'),
(84,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionary/updateSysDictionary','更新字典','系统字典','PUT'),
(85,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionary/findSysDictionary','根据ID获取字典（建议选择）','系统字典','GET'),
(86,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysDictionary/getSysDictionaryList','获取字典列表','系统字典','GET'),
(87,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysOperationRecord/createSysOperationRecord','新增操作记录','操作记录','POST'),
(88,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysOperationRecord/findSysOperationRecord','根据ID获取操作记录','操作记录','GET'),
(89,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysOperationRecord/getSysOperationRecordList','获取操作记录列表','操作记录','GET'),
(90,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysOperationRecord/deleteSysOperationRecord','删除操作记录','操作记录','DELETE'),
(91,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysOperationRecord/deleteSysOperationRecordByIds','批量删除操作历史','操作记录','DELETE'),
(92,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/simpleUploader/upload','插件版分片上传','断点续传(插件版)','POST'),
(93,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/simpleUploader/checkFileMd5','文件完整度验证','断点续传(插件版)','GET'),
(94,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/simpleUploader/mergeFileMd5','上传完成合并文件','断点续传(插件版)','GET'),
(95,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/email/emailTest','发送测试邮件','email','POST'),
(96,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/email/sendEmail','发送邮件','email','POST'),
(97,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authorityBtn/setAuthorityBtn','设置按钮权限','按钮权限','POST'),
(98,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authorityBtn/getAuthorityBtn','获取已有按钮权限','按钮权限','POST'),
(99,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/authorityBtn/canRemoveAuthorityBtn','删除按钮','按钮权限','POST'),
(100,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/createSysExportTemplate','新增导出模板','导出模板','POST'),
(101,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/deleteSysExportTemplate','删除导出模板','导出模板','DELETE'),
(102,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/deleteSysExportTemplateByIds','批量删除导出模板','导出模板','DELETE'),
(103,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/updateSysExportTemplate','更新导出模板','导出模板','PUT'),
(104,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/findSysExportTemplate','根据ID获取导出模板','导出模板','GET'),
(105,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/getSysExportTemplateList','获取导出模板列表','导出模板','GET'),
(106,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/exportExcel','导出Excel','导出模板','GET'),
(107,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/exportTemplate','下载模板','导出模板','GET'),
(108,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysExportTemplate/importExcel','导入Excel','导出模板','POST'),
(109,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/info/createInfo','新建公告','公告','POST'),
(110,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/info/deleteInfo','删除公告','公告','DELETE'),
(111,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/info/deleteInfoByIds','批量删除公告','公告','DELETE'),
(112,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/info/updateInfo','更新公告','公告','PUT'),
(113,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/info/findInfo','根据ID获取公告','公告','GET'),
(114,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/info/getInfoList','获取公告列表','公告','GET'),
(115,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysParams/createSysParams','新建参数','参数管理','POST'),
(116,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysParams/deleteSysParams','删除参数','参数管理','DELETE'),
(117,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysParams/deleteSysParamsByIds','批量删除参数','参数管理','DELETE'),
(118,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysParams/updateSysParams','更新参数','参数管理','PUT'),
(119,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysParams/findSysParams','根据ID获取参数','参数管理','GET'),
(120,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysParams/getSysParamsList','获取参数列表','参数管理','GET'),
(121,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/sysParams/getSysParam','获取参数列表','参数管理','GET'),
(122,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/attachmentCategory/getCategoryList','分类列表','媒体库分类','GET'),
(123,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/attachmentCategory/addCategory','添加/编辑分类','媒体库分类','POST'),
(124,'2025-06-23 17:31:32.942','2025-06-23 17:31:32.942',NULL,'/attachmentCategory/deleteCategory','删除分类','媒体库分类','POST'),
(125,'2025-06-28 21:20:52.696','2025-06-28 21:20:52.696',NULL,'/demoRecord/create','测试create','api','POST'),
(126,'2025-06-28 21:21:09.014','2025-06-28 21:21:09.014',NULL,'/demoRecord/list','测试demo','api','GET'),
(127,'2025-07-02 22:03:02.686','2025-07-02 22:03:02.686',NULL,'/bszhengshu/create','证书创建','客户','POST'),
(128,'2025-07-05 11:33:23.688','2025-07-05 11:33:23.688',NULL,'/bszhengshu/getZhengshuList','证书页面查询','客户','POST'),
(129,'2025-07-05 13:29:16.731','2025-07-05 13:29:16.731',NULL,'/bszhengshu/delZhengshuById','删除证书byid','客户','DELETE'),
(130,'2025-07-05 20:32:18.749','2025-07-05 20:32:18.749',NULL,'/bszhengshu/setZhengshuInfo','更新单个证书的信息','客户','PUT'),
(131,'2025-07-06 08:35:08.174','2025-07-06 08:35:08.174',NULL,'/bszhengshu/getOneZhengshu','查询单个证书信息','客户','POST'),
(132,'2025-07-09 13:19:34.026','2025-07-09 13:19:34.026',NULL,'/bstraining/create','增加培训证书','客户','POST'),
(133,'2025-07-09 13:19:57.647','2025-07-09 13:19:57.647',NULL,'/bstraining/getTrainingList','获取培训证书列表','客户','POST'),
(134,'2025-07-09 13:20:27.236','2025-07-09 14:10:12.857',NULL,'/bstraining/delTrainingById','删除单个培训证书信息by ID','客户','DELETE'),
(135,'2025-07-09 13:20:52.866','2025-07-09 13:20:52.866',NULL,'/bstraining/setTrainingInfo','更新培训证书信息','客户','PUT'),
(136,'2025-07-09 15:16:03.066','2025-07-09 15:16:03.066',NULL,'/bstraining/getOneTraining','获取单个培训证书信息','客户','POST'),
(137,'2025-07-26 20:47:52.332','2025-07-26 21:56:38.343',NULL,'/student/sendEmailCode','用户注册给邮箱发送验证码','客户','POST'),
(138,'2025-07-26 21:51:51.419','2025-07-27 15:14:08.881',NULL,'/student/login','学生用户登录','客户','POST'),
(139,'2025-07-27 15:12:43.056','2025-07-27 15:12:43.056',NULL,'/student/register','学生用户注册','客户','POST'),
(140,'2025-07-27 15:13:27.329','2025-07-27 17:55:47.983',NULL,'/student/initPassword','学生用户忘记密码初始化密码','客户','POST'),
(141,'2025-07-27 19:28:40.528','2025-07-27 19:28:40.528',NULL,'/student/getInfo','学生获取学生信息','客户','GET'),
(142,'2025-08-01 10:01:50.571','2025-08-01 10:01:50.571',NULL,'/student/updateField','更新学生属性','客户','PUT'),
(143,'2025-08-01 10:02:16.101','2025-08-01 10:02:16.101',NULL,'/student/changePassword','学生修改密码','客户','POST'),
(144,'2025-08-05 20:50:50.660','2025-08-05 20:51:34.804',NULL,'/student/getCertificateList','获取学生证书列表信息','客户','GET'),
(145,'2025-08-09 17:08:26.529','2025-08-09 17:08:26.529',NULL,'student/order-my-pending','学生获取支付订单','客户','GET'),
(146,'2025-08-09 17:09:01.738','2025-08-09 17:09:01.738',NULL,'student/order-pay/:orderSn','支付订单','客户','POST'),
(147,'2025-08-09 17:09:35.835','2025-08-09 17:09:35.835',NULL,'student/order-status/:orderSn','获取订单状态','客户','GET'),
(148,'2025-08-09 17:10:14.197','2025-08-09 17:10:14.197',NULL,'student/order-refresh/:orderSn','二维码过期刷新','客户','POST'),
(149,'2025-08-09 17:10:46.666','2025-08-09 17:10:46.666',NULL,'student/order-wechat-notify','微信支付成功回调接口','客户','POST'),
(150,'2025-08-11 13:36:54.862','2025-08-11 13:36:54.862',NULL,'student/order-detail/:orderSn','学生获取订单详情','客户','GET'),
(151,'2025-08-11 22:21:15.955','2025-08-11 22:21:15.955',NULL,'student/certificate-create','学生端插入证书接口','客户','POST'),
(152,'2025-08-11 22:21:59.938','2025-08-11 22:21:59.938',NULL,'student/training-create','学生端培训证书插入接口','客户','POST'),
(153,'2025-08-12 12:05:02.156','2025-08-12 12:05:02.156',NULL,'/bszhengshu/getOrderList','获取学生订单列表','客户','POST'),
(154,'2025-08-17 21:04:39.377','2025-08-17 21:04:39.377',NULL,'/bszhengshu/delOrderById','管理平台删除订单接口','客户','DELETE');

/*Table structure for table `sys_authorities` */

DROP TABLE IF EXISTS `sys_authorities`;

CREATE TABLE `sys_authorities` (
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `authority_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `authority_name` varchar(191) DEFAULT NULL COMMENT '角色名',
  `parent_id` bigint(20) unsigned DEFAULT NULL COMMENT '父角色ID',
  `default_router` varchar(191) DEFAULT 'dashboard' COMMENT '默认菜单',
  PRIMARY KEY (`authority_id`),
  UNIQUE KEY `uni_sys_authorities_authority_id` (`authority_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9529 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_authorities` */

insert  into `sys_authorities`(`created_at`,`updated_at`,`deleted_at`,`authority_id`,`authority_name`,`parent_id`,`default_router`) values 
('2025-06-23 17:31:33.793','2025-08-13 13:07:44.575',NULL,888,'普通用户',0,'dashboard'),
('2025-06-23 17:31:33.793','2025-06-23 17:31:40.683',NULL,8881,'普通用户子角色',888,'dashboard'),
('2025-06-23 17:31:33.793','2025-06-23 17:31:40.203',NULL,9528,'测试角色',0,'dashboard');

/*Table structure for table `sys_authority_btns` */

DROP TABLE IF EXISTS `sys_authority_btns`;

CREATE TABLE `sys_authority_btns` (
  `authority_id` bigint(20) unsigned DEFAULT NULL COMMENT '角色ID',
  `sys_menu_id` bigint(20) unsigned DEFAULT NULL COMMENT '菜单ID',
  `sys_base_menu_btn_id` bigint(20) unsigned DEFAULT NULL COMMENT '菜单按钮ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_authority_btns` */

/*Table structure for table `sys_authority_menus` */

DROP TABLE IF EXISTS `sys_authority_menus`;

CREATE TABLE `sys_authority_menus` (
  `sys_base_menu_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `sys_authority_authority_id` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`sys_base_menu_id`,`sys_authority_authority_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_authority_menus` */

insert  into `sys_authority_menus`(`sys_base_menu_id`,`sys_authority_authority_id`) values 
(1,888),
(1,8881),
(1,9528),
(2,888),
(2,8881),
(2,9528),
(3,888),
(3,8881),
(4,888),
(4,8881),
(4,9528),
(5,888),
(5,8881),
(6,888),
(6,8881),
(8,888),
(8,8881),
(8,9528),
(9,888),
(9,8881),
(10,888),
(11,888),
(12,888),
(13,888),
(14,888),
(15,888),
(16,888),
(17,888),
(17,8881),
(18,888),
(18,8881),
(19,888),
(19,8881),
(20,888),
(20,8881),
(21,888),
(21,8881),
(22,888),
(22,8881),
(23,888),
(23,8881),
(24,888),
(24,8881),
(25,888),
(25,8881),
(26,888),
(26,8881),
(27,888),
(27,8881),
(28,888),
(28,8881),
(29,888),
(29,8881),
(30,888),
(31,888),
(32,888),
(33,888),
(34,888),
(35,888),
(36,888),
(37,888),
(38,888),
(39,888),
(40,888),
(41,888),
(44,888),
(45,888);

/*Table structure for table `sys_auto_code_histories` */

DROP TABLE IF EXISTS `sys_auto_code_histories`;

CREATE TABLE `sys_auto_code_histories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `table_name` varchar(191) DEFAULT NULL COMMENT '表名',
  `package` varchar(191) DEFAULT NULL COMMENT '模块名/插件名',
  `request` text COMMENT '前端传入的结构化信息',
  `struct_name` varchar(191) DEFAULT NULL COMMENT '结构体名称',
  `abbreviation` varchar(191) DEFAULT NULL COMMENT '结构体名称缩写',
  `business_db` varchar(191) DEFAULT NULL COMMENT '业务库',
  `description` varchar(191) DEFAULT NULL COMMENT 'Struct中文名称',
  `templates` text COMMENT '模板信息',
  `Injections` text COMMENT '注入路径',
  `flag` bigint(20) DEFAULT NULL COMMENT '[0:创建,1:回滚]',
  `api_ids` varchar(191) DEFAULT NULL COMMENT 'api表注册内容',
  `menu_id` bigint(20) unsigned DEFAULT NULL COMMENT '菜单ID',
  `export_template_id` bigint(20) unsigned DEFAULT NULL COMMENT '导出模板ID',
  `package_id` bigint(20) unsigned DEFAULT NULL COMMENT '包ID',
  PRIMARY KEY (`id`),
  KEY `idx_sys_auto_code_histories_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_auto_code_histories` */

/*Table structure for table `sys_auto_code_packages` */

DROP TABLE IF EXISTS `sys_auto_code_packages`;

CREATE TABLE `sys_auto_code_packages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `desc` varchar(191) DEFAULT NULL COMMENT '描述',
  `label` varchar(191) DEFAULT NULL COMMENT '展示名',
  `template` varchar(191) DEFAULT NULL COMMENT '模版',
  `package_name` varchar(191) DEFAULT NULL COMMENT '包名',
  `module` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sys_auto_code_packages_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_auto_code_packages` */

insert  into `sys_auto_code_packages`(`id`,`created_at`,`updated_at`,`deleted_at`,`desc`,`label`,`template`,`package_name`,`module`) values 
(1,'2025-06-23 20:58:10.965','2025-06-23 20:58:10.965',NULL,'系统自动读取example包','example包','package','example','github.com/flipped-aurora/gin-vue-admin/server'),
(2,'2025-06-23 20:58:10.965','2025-06-23 20:58:10.965',NULL,'系统自动读取system包','system包','package','system','github.com/flipped-aurora/gin-vue-admin/server'),
(3,'2025-06-23 20:58:10.965','2025-06-23 20:58:10.965',NULL,'系统自动读取announcement插件，使用前请确认是否为v2版本插件','announcement插件','plugin','announcement','github.com/flipped-aurora/gin-vue-admin/server'),
(4,'2025-06-30 19:41:25.601','2025-06-30 19:41:25.601',NULL,'系统自动读取business包','business包','package','business','github.com/flipped-aurora/gin-vue-admin/server');

/*Table structure for table `sys_base_menu_btns` */

DROP TABLE IF EXISTS `sys_base_menu_btns`;

CREATE TABLE `sys_base_menu_btns` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '按钮关键key',
  `desc` varchar(191) DEFAULT NULL,
  `sys_base_menu_id` bigint(20) unsigned DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`),
  KEY `idx_sys_base_menu_btns_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_base_menu_btns` */

/*Table structure for table `sys_base_menu_parameters` */

DROP TABLE IF EXISTS `sys_base_menu_parameters`;

CREATE TABLE `sys_base_menu_parameters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `sys_base_menu_id` bigint(20) unsigned DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL COMMENT '地址栏携带参数为params还是query',
  `key` varchar(191) DEFAULT NULL COMMENT '地址栏携带参数的key',
  `value` varchar(191) DEFAULT NULL COMMENT '地址栏携带参数的值',
  PRIMARY KEY (`id`),
  KEY `idx_sys_base_menu_parameters_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_base_menu_parameters` */

/*Table structure for table `sys_base_menus` */

DROP TABLE IF EXISTS `sys_base_menus`;

CREATE TABLE `sys_base_menus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `menu_level` bigint(20) unsigned DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL COMMENT '父菜单ID',
  `path` varchar(191) DEFAULT NULL COMMENT '路由path',
  `name` varchar(191) DEFAULT NULL COMMENT '路由name',
  `hidden` tinyint(1) DEFAULT NULL COMMENT '是否在列表隐藏',
  `component` varchar(191) DEFAULT NULL COMMENT '对应前端文件路径',
  `sort` bigint(20) DEFAULT NULL COMMENT '排序标记',
  `active_name` varchar(191) DEFAULT NULL COMMENT '附加属性',
  `keep_alive` tinyint(1) DEFAULT NULL COMMENT '附加属性',
  `default_menu` tinyint(1) DEFAULT NULL COMMENT '附加属性',
  `title` varchar(191) DEFAULT NULL COMMENT '附加属性',
  `icon` varchar(191) DEFAULT NULL COMMENT '附加属性',
  `close_tab` tinyint(1) DEFAULT NULL COMMENT '附加属性',
  `transition_type` varchar(191) DEFAULT NULL COMMENT '附加属性',
  PRIMARY KEY (`id`),
  KEY `idx_sys_base_menus_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_base_menus` */

insert  into `sys_base_menus`(`id`,`created_at`,`updated_at`,`deleted_at`,`menu_level`,`parent_id`,`path`,`name`,`hidden`,`component`,`sort`,`active_name`,`keep_alive`,`default_menu`,`title`,`icon`,`close_tab`,`transition_type`) values 
(1,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'dashboard','dashboard',0,'view/dashboard/index.vue',1,'',0,0,'仪表盘','odometer',0,''),
(2,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'about','about',0,'view/about/index.vue',9,'',0,0,'关于我们','info-filled',0,''),
(3,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'admin','superAdmin',0,'view/superAdmin/index.vue',3,'',0,0,'超级管理员','user',0,''),
(4,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'person','person',1,'view/person/person.vue',4,'',0,0,'个人信息','message',0,''),
(5,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'example','example',0,'view/example/index.vue',7,'',0,0,'示例文件','management',0,''),
(6,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'systemTools','systemTools',0,'view/systemTools/index.vue',5,'',0,0,'系统工具','tools',0,''),
(7,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743','2025-06-24 22:25:54.350',0,0,'https://www.gin-vue-admin.com','https://www.gin-vue-admin.com',0,'/',0,'',0,0,'官方网站','customer-gva',0,''),
(8,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'state','state',0,'view/system/state.vue',8,'',0,0,'服务器状态','cloudy',0,''),
(9,'2025-06-23 17:31:37.743','2025-06-23 17:31:37.743',NULL,0,0,'plugin','plugin',0,'view/routerHolder.vue',6,'',0,0,'插件系统','cherry',0,''),
(10,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,3,'authority','authority',0,'view/superAdmin/authority/authority.vue',1,'',0,0,'角色管理','avatar',0,''),
(11,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,3,'menu','menu',0,'view/superAdmin/menu/menu.vue',2,'',1,0,'菜单管理','tickets',0,''),
(12,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,3,'api','api',0,'view/superAdmin/api/api.vue',3,'',1,0,'api管理','platform',0,''),
(13,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,3,'user','user',0,'view/superAdmin/user/user.vue',4,'',0,0,'用户管理','coordinate',0,''),
(14,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,3,'dictionary','dictionary',0,'view/superAdmin/dictionary/sysDictionary.vue',5,'',0,0,'字典管理','notebook',0,''),
(15,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,3,'operation','operation',0,'view/superAdmin/operation/sysOperationRecord.vue',6,'',0,0,'操作历史','pie-chart',0,''),
(16,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,3,'sysParams','sysParams',0,'view/superAdmin/params/sysParams.vue',7,'',0,0,'参数管理','compass',0,''),
(17,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,5,'upload','upload',0,'view/example/upload/upload.vue',5,'',0,0,'媒体库（上传下载）','upload',0,''),
(18,'2025-06-23 17:31:37.903','2025-06-24 22:39:48.887',NULL,1,5,'breakpoint','breakpoint',0,'view/example/breakpoint/breakpoint.vue',6,'',0,0,'断点续传','upload-filled',0,''),
(19,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,5,'customer','customer',0,'view/example/customer/customer.vue',7,'',0,0,'客户列表（资源示例）','avatar',0,''),
(20,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'autoCode','autoCode',0,'view/systemTools/autoCode/index.vue',1,'',1,0,'代码生成器','cpu',0,''),
(21,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'formCreate','formCreate',0,'view/systemTools/formCreate/index.vue',3,'',1,0,'表单生成器','magic-stick',0,''),
(22,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'system','system',0,'view/systemTools/system/system.vue',4,'',0,0,'系统配置','operation',0,''),
(23,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'autoCodeAdmin','autoCodeAdmin',0,'view/systemTools/autoCodeAdmin/index.vue',2,'',0,0,'自动化代码管理','magic-stick',0,''),
(24,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'autoCodeEdit/:id','autoCodeEdit',1,'view/systemTools/autoCode/index.vue',0,'',0,0,'自动化代码-${id}','magic-stick',0,''),
(25,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'autoPkg','autoPkg',0,'view/systemTools/autoPkg/autoPkg.vue',0,'',0,0,'模板配置','folder',0,''),
(26,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'exportTemplate','exportTemplate',0,'view/systemTools/exportTemplate/exportTemplate.vue',5,'',0,0,'导出模板','reading',0,''),
(27,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'picture','picture',0,'view/systemTools/autoCode/picture.vue',6,'',0,0,'AI页面绘制','picture-filled',0,''),
(28,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'mcpTool','mcpTool',0,'view/systemTools/autoCode/mcp.vue',7,'',0,0,'Mcp Tools模板','magnet',0,''),
(29,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,6,'mcpTest','mcpTest',0,'view/systemTools/autoCode/mcpTest.vue',7,'',0,0,'Mcp Tools测试','partly-cloudy',0,''),
(30,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,9,'https://plugin.gin-vue-admin.com/','https://plugin.gin-vue-admin.com/',0,'https://plugin.gin-vue-admin.com/',0,'',0,0,'插件市场','shop',0,''),
(31,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,9,'installPlugin','installPlugin',0,'view/systemTools/installPlugin/index.vue',1,'',0,0,'插件安装','box',0,''),
(32,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,9,'pubPlug','pubPlug',0,'view/systemTools/pubPlug/pubPlug.vue',3,'',0,0,'打包插件','files',0,''),
(33,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,9,'plugin-email','plugin-email',0,'plugin/email/view/index.vue',4,'',0,0,'邮件插件','message',0,''),
(34,'2025-06-23 17:31:37.903','2025-06-23 17:31:37.903',NULL,1,9,'anInfo','anInfo',0,'plugin/announcement/view/info.vue',5,'',0,0,'公告管理[示例]','scaleToOriginal',0,''),
(35,'2025-06-24 22:27:04.205','2025-06-25 14:28:25.460',NULL,1,5,'demo','DemoRecord',0,'view/example/demo/record.vue',8,'',0,0,'测试demo','aim',0,''),
(36,'2025-06-30 20:58:18.841','2025-07-26 21:40:40.067',NULL,0,0,'business','business',0,'view/business/index.vue',2,'',0,0,'证书管理','circle-check',0,''),
(37,'2025-06-30 21:05:10.834','2025-06-30 21:29:40.121',NULL,0,36,'certificateAdd','certificateAdd',0,'view/business/certificate/certificateAdd.vue',0,'',0,0,'毕业证书添加','basketball',0,''),
(38,'2025-06-30 21:25:11.506','2025-06-30 21:25:37.345',NULL,0,36,'ertificateQuery','ertificateQuery',0,'view/business/certificate/certificateQuery.vue',0,'',0,0,'毕业证书查询','chicken',0,''),
(39,'2025-07-09 20:42:47.647','2025-07-26 21:42:13.510',NULL,0,0,'trainingBusiness','trainingBusiness',0,'view/trainingBusiness/index/vue',2,'',0,0,'培训证书管理','bicycle',0,''),
(40,'2025-07-09 20:47:08.405','2025-07-09 20:47:08.405',NULL,0,39,'trainingAdd','trainingAdd',0,'view/trainingBusiness/training/trainingAdd.vue',0,'',0,0,'培训证书增加','baseball',0,''),
(41,'2025-07-09 20:47:54.314','2025-07-09 20:47:54.314',NULL,0,39,'trainingQuery','trainingQuery',0,'view/trainingBusiness/training/trainingQuery.vue',0,'',0,0,'培训证书查询','basketball',0,''),
(44,'2025-08-13 13:06:53.034','2025-08-13 13:06:53.034',NULL,0,0,'order','order',0,'view/order/index.vue',3,'',0,0,'订单管理','dish',0,''),
(45,'2025-08-13 13:07:26.583','2025-08-13 13:07:26.583',NULL,0,44,'orderQuery','orderQuery',0,'view/order/orderManager/orderQuery.vue',1,'',0,0,'订单管理','house',0,'');

/*Table structure for table `sys_data_authority_id` */

DROP TABLE IF EXISTS `sys_data_authority_id`;

CREATE TABLE `sys_data_authority_id` (
  `sys_authority_authority_id` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  `data_authority_id_authority_id` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`sys_authority_authority_id`,`data_authority_id_authority_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_data_authority_id` */

insert  into `sys_data_authority_id`(`sys_authority_authority_id`,`data_authority_id_authority_id`) values 
(888,888),
(888,8881),
(888,9528),
(9528,8881),
(9528,9528);

/*Table structure for table `sys_dictionaries` */

DROP TABLE IF EXISTS `sys_dictionaries`;

CREATE TABLE `sys_dictionaries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '字典名（中）',
  `type` varchar(191) DEFAULT NULL COMMENT '字典名（英）',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态',
  `desc` varchar(191) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`),
  KEY `idx_sys_dictionaries_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_dictionaries` */

insert  into `sys_dictionaries`(`id`,`created_at`,`updated_at`,`deleted_at`,`name`,`type`,`status`,`desc`) values 
(1,'2025-06-23 17:31:34.993','2025-06-23 17:31:35.333',NULL,'性别','gender',1,'性别字典'),
(2,'2025-06-23 17:31:34.993','2025-06-23 17:31:35.713',NULL,'数据库int类型','int',1,'int类型对应的数据库类型'),
(3,'2025-06-23 17:31:34.993','2025-06-23 17:31:36.103',NULL,'数据库时间日期类型','time.Time',1,'数据库时间日期类型'),
(4,'2025-06-23 17:31:34.993','2025-06-23 17:31:36.482',NULL,'数据库浮点型','float64',1,'数据库浮点型'),
(5,'2025-06-23 17:31:34.993','2025-06-23 17:31:36.883',NULL,'数据库字符串','string',1,'数据库字符串'),
(6,'2025-06-23 17:31:34.993','2025-06-23 17:31:37.263',NULL,'数据库bool类型','bool',1,'数据库bool类型');

/*Table structure for table `sys_dictionary_details` */

DROP TABLE IF EXISTS `sys_dictionary_details`;

CREATE TABLE `sys_dictionary_details` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `label` varchar(191) DEFAULT NULL COMMENT '展示值',
  `value` varchar(191) DEFAULT NULL COMMENT '字典值',
  `extend` varchar(191) DEFAULT NULL COMMENT '扩展值',
  `status` tinyint(1) DEFAULT NULL COMMENT '启用状态',
  `sort` bigint(20) DEFAULT NULL COMMENT '排序标记',
  `sys_dictionary_id` bigint(20) unsigned DEFAULT NULL COMMENT '关联标记',
  PRIMARY KEY (`id`),
  KEY `idx_sys_dictionary_details_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_dictionary_details` */

insert  into `sys_dictionary_details`(`id`,`created_at`,`updated_at`,`deleted_at`,`label`,`value`,`extend`,`status`,`sort`,`sys_dictionary_id`) values 
(1,'2025-06-23 17:31:35.373','2025-06-23 17:31:35.373',NULL,'男','1','',1,1,1),
(2,'2025-06-23 17:31:35.373','2025-06-23 17:31:35.373',NULL,'女','2','',1,2,1),
(3,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'smallint','1','mysql',1,1,2),
(4,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'mediumint','2','mysql',1,2,2),
(5,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'int','3','mysql',1,3,2),
(6,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'bigint','4','mysql',1,4,2),
(7,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'int2','5','pgsql',1,5,2),
(8,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'int4','6','pgsql',1,6,2),
(9,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'int6','7','pgsql',1,7,2),
(10,'2025-06-23 17:31:35.753','2025-06-23 17:31:35.753',NULL,'int8','8','pgsql',1,8,2),
(11,'2025-06-23 17:31:36.143','2025-06-23 17:31:36.143',NULL,'date','','',1,0,3),
(12,'2025-06-23 17:31:36.143','2025-06-23 17:31:36.143',NULL,'time','1','mysql',1,1,3),
(13,'2025-06-23 17:31:36.143','2025-06-23 17:31:36.143',NULL,'year','2','mysql',1,2,3),
(14,'2025-06-23 17:31:36.143','2025-06-23 17:31:36.143',NULL,'datetime','3','mysql',1,3,3),
(15,'2025-06-23 17:31:36.143','2025-06-23 17:31:36.143',NULL,'timestamp','5','mysql',1,5,3),
(16,'2025-06-23 17:31:36.143','2025-06-23 17:31:36.143',NULL,'timestamptz','6','pgsql',1,5,3),
(17,'2025-06-23 17:31:36.523','2025-06-23 17:31:36.523',NULL,'float','','',1,0,4),
(18,'2025-06-23 17:31:36.523','2025-06-23 17:31:36.523',NULL,'double','1','mysql',1,1,4),
(19,'2025-06-23 17:31:36.523','2025-06-23 17:31:36.523',NULL,'decimal','2','mysql',1,2,4),
(20,'2025-06-23 17:31:36.523','2025-06-23 17:31:36.523',NULL,'numeric','3','pgsql',1,3,4),
(21,'2025-06-23 17:31:36.523','2025-06-23 17:31:36.523',NULL,'smallserial','4','pgsql',1,4,4),
(22,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'char','','',1,0,5),
(23,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'varchar','1','mysql',1,1,5),
(24,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'tinyblob','2','mysql',1,2,5),
(25,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'tinytext','3','mysql',1,3,5),
(26,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'text','4','mysql',1,4,5),
(27,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'blob','5','mysql',1,5,5),
(28,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'mediumblob','6','mysql',1,6,5),
(29,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'mediumtext','7','mysql',1,7,5),
(30,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'longblob','8','mysql',1,8,5),
(31,'2025-06-23 17:31:36.923','2025-06-23 17:31:36.923',NULL,'longtext','9','mysql',1,9,5),
(32,'2025-06-23 17:31:37.303','2025-06-23 17:31:37.303',NULL,'tinyint','1','mysql',1,0,6),
(33,'2025-06-23 17:31:37.303','2025-06-23 17:31:37.303',NULL,'bool','2','pgsql',1,0,6);

/*Table structure for table `sys_export_template_condition` */

DROP TABLE IF EXISTS `sys_export_template_condition`;

CREATE TABLE `sys_export_template_condition` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `template_id` varchar(191) DEFAULT NULL COMMENT '模板标识',
  `from` varchar(191) DEFAULT NULL COMMENT '条件取的key',
  `column` varchar(191) DEFAULT NULL COMMENT '作为查询条件的字段',
  `operator` varchar(191) DEFAULT NULL COMMENT '操作符',
  PRIMARY KEY (`id`),
  KEY `idx_sys_export_template_condition_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_export_template_condition` */

/*Table structure for table `sys_export_template_join` */

DROP TABLE IF EXISTS `sys_export_template_join`;

CREATE TABLE `sys_export_template_join` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `template_id` varchar(191) DEFAULT NULL COMMENT '模板标识',
  `joins` varchar(191) DEFAULT NULL COMMENT '关联',
  `table` varchar(191) DEFAULT NULL COMMENT '关联表',
  `on` varchar(191) DEFAULT NULL COMMENT '关联条件',
  PRIMARY KEY (`id`),
  KEY `idx_sys_export_template_join_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_export_template_join` */

/*Table structure for table `sys_export_templates` */

DROP TABLE IF EXISTS `sys_export_templates`;

CREATE TABLE `sys_export_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `db_name` varchar(191) DEFAULT NULL COMMENT '数据库名称',
  `name` varchar(191) DEFAULT NULL COMMENT '模板名称',
  `table_name` varchar(191) DEFAULT NULL COMMENT '表名称',
  `template_id` varchar(191) DEFAULT NULL COMMENT '模板标识',
  `template_info` text,
  `limit` bigint(20) DEFAULT NULL COMMENT '导出限制',
  `order` varchar(191) DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `idx_sys_export_templates_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_export_templates` */

insert  into `sys_export_templates`(`id`,`created_at`,`updated_at`,`deleted_at`,`db_name`,`name`,`table_name`,`template_id`,`template_info`,`limit`,`order`) values 
(1,'2025-06-23 17:31:39.403','2025-06-23 17:31:39.403',NULL,'','api','sys_apis','api','{\n\"path\":\"路径\",\n\"method\":\"方法（大写）\",\n\"description\":\"方法介绍\",\n\"api_group\":\"方法分组\"\n}',NULL,'');

/*Table structure for table `sys_ignore_apis` */

DROP TABLE IF EXISTS `sys_ignore_apis`;

CREATE TABLE `sys_ignore_apis` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `path` varchar(191) DEFAULT NULL COMMENT 'api路径',
  `method` varchar(191) DEFAULT 'POST' COMMENT '方法',
  PRIMARY KEY (`id`),
  KEY `idx_sys_ignore_apis_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_ignore_apis` */

insert  into `sys_ignore_apis`(`id`,`created_at`,`updated_at`,`deleted_at`,`path`,`method`) values 
(1,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/swagger/*any','GET'),
(2,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/api/freshCasbin','GET'),
(3,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/uploads/file/*filepath','GET'),
(4,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/health','GET'),
(5,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/uploads/file/*filepath','HEAD'),
(6,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/autoCode/llmAuto','POST'),
(7,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/system/reloadSystem','POST'),
(8,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/base/login','POST'),
(9,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/base/captcha','POST'),
(10,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/init/initdb','POST'),
(11,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/init/checkdb','POST'),
(12,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/info/getInfoDataSource','GET'),
(13,'2025-06-23 17:31:33.243','2025-06-23 17:31:33.243',NULL,'/info/getInfoPublic','GET');

/*Table structure for table `sys_operation_records` */

DROP TABLE IF EXISTS `sys_operation_records`;

CREATE TABLE `sys_operation_records` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `ip` varchar(191) DEFAULT NULL COMMENT '请求ip',
  `method` varchar(191) DEFAULT NULL COMMENT '请求方法',
  `path` varchar(191) DEFAULT NULL COMMENT '请求路径',
  `status` bigint(20) DEFAULT NULL COMMENT '请求状态',
  `latency` bigint(20) DEFAULT NULL COMMENT '延迟',
  `agent` text COMMENT '代理',
  `error_message` varchar(191) DEFAULT NULL COMMENT '错误信息',
  `body` text COMMENT '请求Body',
  `resp` text COMMENT '响应Body',
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`),
  KEY `idx_sys_operation_records_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_operation_records` */

insert  into `sys_operation_records`(`id`,`created_at`,`updated_at`,`deleted_at`,`ip`,`method`,`path`,`status`,`latency`,`agent`,`error_message`,`body`,`resp`,`user_id`) values 
(1,'2025-06-24 22:22:47.259','2025-06-24 22:22:47.259',NULL,'127.0.0.1','GET','/api/getApiGroups',200,71168583,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(2,'2025-06-24 22:25:54.630','2025-06-24 22:25:54.630',NULL,'127.0.0.1','POST','/menu/deleteBaseMenu',200,427155916,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":7}','{\"code\":0,\"data\":{},\"msg\":\"删除成功\"}',1),
(3,'2025-06-24 22:27:04.299','2025-06-24 22:27:04.299',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,138142084,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"parentId\":5,\"component\":\"view/example/demo/record.vue\",\"meta\":{\"activeName\":\"\",\"title\":\"demo-record\",\"icon\":\"\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(4,'2025-06-24 22:28:21.534','2025-06-24 22:28:21.534',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,181127375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"parentId\":5,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":0,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"demo-record\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(5,'2025-06-24 22:29:01.293','2025-06-24 22:29:01.293',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,184153375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:28:21.456+08:00\",\"parentId\":5,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"demo-record\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(6,'2025-06-24 22:30:38.359','2025-06-24 22:30:38.359',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,198053542,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:29:01.218+08:00\",\"parentId\":5,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"demo-record\",\"icon\":\"aim\",\"closeTab\":true,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(7,'2025-06-24 22:31:12.213','2025-06-24 22:31:12.213',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,191385750,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:30:38.283+08:00\",\"parentId\":5,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"demo-record\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(8,'2025-06-24 22:35:12.699','2025-06-24 22:35:12.699',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,238411417,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:31:12.139+08:00\",\"parentId\":5,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"component\":\"view/routerHolder.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"demoRecord\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(9,'2025-06-24 22:35:36.980','2025-06-24 22:35:36.980',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,231146334,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":18,\"CreatedAt\":\"2025-06-23T17:31:37.903+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:37.903+08:00\",\"parentId\":5,\"path\":\"breakpoint\",\"name\":\"breakpoint\",\"hidden\":true,\"component\":\"view/example/breakpoint/breakpoint.vue\",\"sort\":6,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"断点续传\",\"icon\":\"upload-filled\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(10,'2025-06-24 22:39:48.965','2025-06-24 22:39:48.965',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,186455000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":18,\"CreatedAt\":\"2025-06-23T17:31:37.903+08:00\",\"UpdatedAt\":\"2025-06-24T22:35:36.885+08:00\",\"parentId\":5,\"path\":\"breakpoint\",\"name\":\"breakpoint\",\"hidden\":false,\"component\":\"view/example/breakpoint/breakpoint.vue\",\"sort\":6,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"断点续传\",\"icon\":\"upload-filled\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(11,'2025-06-24 22:40:45.837','2025-06-24 22:40:45.837',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,188372709,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:35:12.601+08:00\",\"parentId\":5,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"demoRecord\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(12,'2025-06-24 22:41:59.747','2025-06-24 22:41:59.747',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,223926666,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:40:45.765+08:00\",\"parentId\":5,\"path\":\"demo\",\"name\":\"demo\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"demoRecord\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(13,'2025-06-24 22:43:57.235','2025-06-24 22:43:57.235',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,273249791,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:41:59.669+08:00\",\"parentId\":5,\"path\":\"demo\",\"name\":\"demo\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"测试demo\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(14,'2025-06-25 11:43:33.121','2025-06-25 11:43:33.121',NULL,'192.33.7.210','GET','/api/getApiGroups',200,39740409,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(15,'2025-06-25 11:45:05.411','2025-06-25 11:45:05.411',NULL,'192.33.7.210','PUT','/user/setUserInfo',200,617534237,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"设置成功\"}',1),
(16,'2025-06-25 14:13:40.537','2025-06-25 14:13:40.537',NULL,'192.33.7.210','POST','/menu/updateBaseMenu',200,548308522,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-24T22:43:57.118+08:00\",\"parentId\":5,\"path\":\"record\",\"name\":\"record\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"测试demo\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(17,'2025-06-25 14:28:25.664','2025-06-25 14:28:25.664',NULL,'192.33.7.210','POST','/menu/updateBaseMenu',200,564953836,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":35,\"CreatedAt\":\"2025-06-24T22:27:04.205+08:00\",\"UpdatedAt\":\"2025-06-25T14:13:40.327+08:00\",\"parentId\":5,\"path\":\"demo\",\"name\":\"demo\",\"hidden\":false,\"component\":\"view/example/demo/record.vue\",\"sort\":8,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"测试demo\",\"icon\":\"aim\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(18,'2025-06-25 21:12:06.766','2025-06-25 21:12:06.766',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,467952458,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(19,'2025-06-26 22:15:37.122','2025-06-26 22:15:37.122',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,421285625,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(20,'2025-06-26 22:16:38.828','2025-06-26 22:16:38.828',NULL,'127.0.0.1','POST','/authority/setDataAuthority',200,363423917,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"设置成功\"}',1),
(21,'2025-06-28 21:04:14.771','2025-06-28 21:04:14.771',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,435991667,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(22,'2025-06-28 21:04:33.629','2025-06-28 21:04:33.629',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,411505000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(23,'2025-06-28 21:04:47.407','2025-06-28 21:04:47.407',NULL,'127.0.0.1','GET','/api/getApiGroups',200,48059000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(24,'2025-06-28 21:11:58.492','2025-06-28 21:11:58.492',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,248210875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(25,'2025-06-28 21:16:01.162','2025-06-28 21:16:01.162',NULL,'127.0.0.1','GET','/api/getApiGroups',200,42204792,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(26,'2025-06-28 21:20:03.505','2025-06-28 21:20:03.505',NULL,'127.0.0.1','GET','/api/syncApi',200,69382541,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"deleteApis\":[{\"ID\":87,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/sysOperationRecord/createSysOperationRecord\",\"description\":\"新增操作记录\",\"apiGroup\":\"操作记录\",\"method\":\"POST\"},{\"ID\":92,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/upload\",\"description\":\"插件版分片上传\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"POST\"},{\"ID\":93,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/checkFileMd5\",\"description\":\"文件完整度验证\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"GET\"},{\"ID\":94,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/mergeFileMd5\",\"description\":\"上传完成合并文件\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"GET\"}],\"ignoreApis\":[{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/swagger/*any\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/api/freshCasbin\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/uploads/file/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/health\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/uploads/file/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"HEAD\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/llmAuto\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/system/reloadSystem\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/base/login\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/base/captcha\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/init/initdb\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/init/checkdb\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/info/getInfoDataSource\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/info/getInfoPublic\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"}],\"newApis\":[{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sysExportTemplate/exportExcelByToken\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sysExportTemplate/exportTemplateByToken\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sse\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/demoRecord/list\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/initMenu\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/initAPI\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/message\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/demoRecord/create\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"}]},\"msg\":\"成功\"}',1),
(27,'2025-06-28 21:20:52.784','2025-06-28 21:20:52.784',NULL,'127.0.0.1','POST','/api/createApi',200,134867333,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/demoRecord/create\",\"description\":\"测试create\",\"apiGroup\":\"api\",\"method\":\"POST\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(28,'2025-06-28 21:20:52.953','2025-06-28 21:20:52.953',NULL,'127.0.0.1','GET','/api/getApiGroups',200,40733292,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(29,'2025-06-28 21:21:09.096','2025-06-28 21:21:09.096',NULL,'127.0.0.1','POST','/api/createApi',200,123648750,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/demoRecord/list\",\"description\":\"测试demo\",\"apiGroup\":\"api\",\"method\":\"GET\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(30,'2025-06-28 21:21:09.271','2025-06-28 21:21:09.271',NULL,'127.0.0.1','GET','/api/getApiGroups',200,41659042,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(31,'2025-06-28 21:21:25.343','2025-06-28 21:21:25.343',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,263152000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(32,'2025-06-30 20:58:18.932','2025-06-30 20:58:18.932',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,134983833,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"business\",\"name\":\"business\",\"hidden\":false,\"parentId\":0,\"component\":\"view/business/index.vue\",\"meta\":{\"activeName\":\"\",\"title\":\"证书管理\",\"icon\":\"\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(33,'2025-06-30 20:58:47.172','2025-06-30 20:58:47.172',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,221163667,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":36,\"CreatedAt\":\"2025-06-30T20:58:18.841+08:00\",\"UpdatedAt\":\"2025-06-30T20:58:18.841+08:00\",\"parentId\":0,\"path\":\"business\",\"name\":\"business\",\"hidden\":false,\"component\":\"view/business/index.vue\",\"sort\":0,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"证书管理\",\"icon\":\"circle-check\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(34,'2025-06-30 21:05:10.915','2025-06-30 21:05:10.915',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,140037625,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"certificate\",\"name\":\"certificate\",\"hidden\":false,\"parentId\":36,\"component\":\"view/business/certificate/certificate.vue\",\"meta\":{\"activeName\":\"\",\"title\":\"毕业证书管理\",\"icon\":\"\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(35,'2025-06-30 21:05:30.453','2025-06-30 21:05:30.453',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,403879083,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(36,'2025-06-30 21:05:35.178','2025-06-30 21:05:35.178',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,417985000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(37,'2025-06-30 21:22:07.595','2025-06-30 21:22:07.595',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,241407916,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":37,\"CreatedAt\":\"2025-06-30T21:05:10.834+08:00\",\"UpdatedAt\":\"2025-06-30T21:05:10.834+08:00\",\"parentId\":36,\"path\":\"certificateAdd\",\"name\":\"certificateAdd\",\"hidden\":false,\"component\":\"view/business/certificate/certificateAdd.vue\",\"sort\":0,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"毕业证书添加\",\"icon\":\"\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(38,'2025-06-30 21:25:11.577','2025-06-30 21:25:11.577',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,113372334,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"ertificateQuery\",\"name\":\"ertificateQuery\",\"hidden\":false,\"parentId\":37,\"component\":\"view/business/certificate/certificateQuery.vue\",\"meta\":{\"title\":\"毕业证书查询\",\"icon\":\"chicken\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false}}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(39,'2025-06-30 21:25:37.414','2025-06-30 21:25:37.414',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,177556625,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":38,\"CreatedAt\":\"2025-06-30T21:25:11.506+08:00\",\"UpdatedAt\":\"2025-06-30T21:25:11.506+08:00\",\"parentId\":36,\"path\":\"ertificateQuery\",\"name\":\"ertificateQuery\",\"hidden\":false,\"component\":\"view/business/certificate/certificateQuery.vue\",\"sort\":0,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"毕业证书查询\",\"icon\":\"chicken\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(40,'2025-06-30 21:26:58.746','2025-06-30 21:26:58.746',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,370388167,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(41,'2025-06-30 21:29:40.207','2025-06-30 21:29:40.207',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,214766334,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":37,\"CreatedAt\":\"2025-06-30T21:05:10.834+08:00\",\"UpdatedAt\":\"2025-06-30T21:22:07.516+08:00\",\"parentId\":36,\"path\":\"certificateAdd\",\"name\":\"certificateAdd\",\"hidden\":false,\"component\":\"view/business/certificate/certificateAdd.vue\",\"sort\":0,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"毕业证书添加\",\"icon\":\"basketball\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(42,'2025-07-02 22:01:17.490','2025-07-02 22:01:17.490',NULL,'127.0.0.1','GET','/api/getApiGroups',200,62103083,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(43,'2025-07-02 22:03:02.773','2025-07-02 22:03:02.773',NULL,'127.0.0.1','POST','/api/createApi',200,130530875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"path\":\"/bszhengshu/create\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"证书创建\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(44,'2025-07-02 22:03:03.220','2025-07-02 22:03:03.220',NULL,'127.0.0.1','GET','/api/getApiGroups',200,346397125,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(45,'2025-07-02 22:03:23.739','2025-07-02 22:03:23.739',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,306414416,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(46,'2025-07-05 10:53:23.961','2025-07-05 10:53:23.961',NULL,'127.0.0.1','GET','/api/getApiGroups',200,45575792,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(47,'2025-07-05 11:32:21.479','2025-07-05 11:32:21.479',NULL,'127.0.0.1','GET','/api/getApiGroups',200,38507792,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(48,'2025-07-05 11:32:25.512','2025-07-05 11:32:25.512',NULL,'127.0.0.1','POST','/api/getApiById',200,36731708,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":126}','{\"code\":0,\"data\":{\"api\":{\"ID\":126,\"CreatedAt\":\"2025-06-28T21:21:09.014+08:00\",\"UpdatedAt\":\"2025-06-28T21:21:09.014+08:00\",\"path\":\"/demoRecord/list\",\"description\":\"测试demo\",\"apiGroup\":\"api\",\"method\":\"GET\"}},\"msg\":\"获取成功\"}',1),
(49,'2025-07-05 11:33:23.765','2025-07-05 11:33:23.765',NULL,'127.0.0.1','POST','/api/createApi',200,118844875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"path\":\"/bszhengshu/getZhengshuList\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"证书页面查询\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(50,'2025-07-05 11:33:23.912','2025-07-05 11:33:23.912',NULL,'127.0.0.1','GET','/api/getApiGroups',200,41214250,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(51,'2025-07-05 11:33:47.158','2025-07-05 11:33:47.158',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,183191458,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(52,'2025-07-05 13:28:24.745','2025-07-05 13:28:24.745',NULL,'127.0.0.1','GET','/api/getApiGroups',200,27916209,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(53,'2025-07-05 13:28:31.661','2025-07-05 13:28:31.661',NULL,'127.0.0.1','POST','/api/getApiById',200,42338333,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":128}','{\"code\":0,\"data\":{\"api\":{\"ID\":128,\"CreatedAt\":\"2025-07-05T11:33:23.688+08:00\",\"UpdatedAt\":\"2025-07-05T11:33:23.688+08:00\",\"path\":\"/bszhengshu/getZhengshuList\",\"description\":\"证书页面查询\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(54,'2025-07-05 13:29:16.818','2025-07-05 13:29:16.818',NULL,'127.0.0.1','POST','/api/createApi',200,129036875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"path\":\"/bszhengshu/delZhengshuById\",\"apiGroup\":\"客户\",\"method\":\"DELETE\",\"description\":\"删除证书byid\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(55,'2025-07-05 13:29:16.973','2025-07-05 13:29:16.973',NULL,'127.0.0.1','GET','/api/getApiGroups',200,39028958,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(56,'2025-07-05 13:29:32.075','2025-07-05 13:29:32.075',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,179479375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(57,'2025-07-05 16:24:32.922','2025-07-05 16:24:32.922',NULL,'127.0.0.1','DELETE','/user/deleteUser',200,154004458,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":12}','{\"code\":0,\"data\":{},\"msg\":\"删除成功\"}',1),
(58,'2025-07-05 16:25:05.921','2025-07-05 16:25:05.921',NULL,'127.0.0.1','DELETE','/user/deleteUser',200,1073292,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":1}','{\"code\":7,\"data\":{},\"msg\":\"删除失败, 无法删除自己。\"}',1),
(59,'2025-07-05 16:25:16.706','2025-07-05 16:25:16.706',NULL,'127.0.0.1','DELETE','/user/deleteUser',200,124811667,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":3}','{\"code\":0,\"data\":{},\"msg\":\"删除成功\"}',1),
(60,'2025-07-05 20:30:53.531','2025-07-05 20:30:53.531',NULL,'127.0.0.1','GET','/api/getApiGroups',200,82826792,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(61,'2025-07-05 20:31:00.624','2025-07-05 20:31:00.624',NULL,'127.0.0.1','POST','/api/getApiById',200,38881708,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":129}','{\"code\":0,\"data\":{\"api\":{\"ID\":129,\"CreatedAt\":\"2025-07-05T13:29:16.731+08:00\",\"UpdatedAt\":\"2025-07-05T13:29:16.731+08:00\",\"path\":\"/bszhengshu/delZhengshuById\",\"description\":\"删除证书byid\",\"apiGroup\":\"客户\",\"method\":\"DELETE\"}},\"msg\":\"获取成功\"}',1),
(62,'2025-07-05 20:32:18.834','2025-07-05 20:32:18.834',NULL,'127.0.0.1','POST','/api/createApi',200,128865625,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"path\":\"/bszhengshu/setZhengshuInfo\",\"apiGroup\":\"客户\",\"method\":\"PUT\",\"description\":\"更新单个证书的信息\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(63,'2025-07-05 20:32:19.028','2025-07-05 20:32:19.028',NULL,'127.0.0.1','GET','/api/getApiGroups',200,81478417,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(64,'2025-07-05 20:32:38.059','2025-07-05 20:32:38.059',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,225287917,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(65,'2025-07-05 21:27:43.877','2025-07-05 21:27:43.877',NULL,'127.0.0.1','GET','/api/getApiGroups',200,36662250,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(66,'2025-07-06 08:34:04.889','2025-07-06 08:34:04.889',NULL,'127.0.0.1','GET','/api/getApiGroups',200,44366542,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(67,'2025-07-06 08:35:08.250','2025-07-06 08:35:08.250',NULL,'127.0.0.1','POST','/api/createApi',200,114028709,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"path\":\"/bszhengshu/getOneZhengshu\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"查询单个证书信息\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(68,'2025-07-06 08:35:08.378','2025-07-06 08:35:08.378',NULL,'127.0.0.1','GET','/api/getApiGroups',200,38116709,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(69,'2025-07-06 08:35:25.123','2025-07-06 08:35:25.123',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,182870417,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(70,'2025-07-06 08:47:41.317','2025-07-06 08:47:41.317',NULL,'127.0.0.1','POST','/api/getApiById',200,42315625,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":131}','{\"code\":0,\"data\":{\"api\":{\"ID\":131,\"CreatedAt\":\"2025-07-06T08:35:08.174+08:00\",\"UpdatedAt\":\"2025-07-06T08:35:08.174+08:00\",\"path\":\"/bszhengshu/getOneZhengshu\",\"description\":\"查询单个证书信息\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(71,'2025-07-06 17:54:31.007','2025-07-06 17:54:31.007',NULL,'127.0.0.1','GET','/api/getApiGroups',200,48372833,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(72,'2025-07-06 17:54:39.334','2025-07-06 17:54:39.334',NULL,'127.0.0.1','POST','/api/getApiById',200,36213375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"id\":131}','{\"code\":0,\"data\":{\"api\":{\"ID\":131,\"CreatedAt\":\"2025-07-06T08:35:08.174+08:00\",\"UpdatedAt\":\"2025-07-06T08:35:08.174+08:00\",\"path\":\"/bszhengshu/getOneZhengshu\",\"description\":\"查询单个证书信息\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(73,'2025-07-09 12:32:28.820','2025-07-09 12:32:28.820',NULL,'192.33.7.210','POST','/menu/addBaseMenu',200,57177526,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"business\",\"name\":\"business\",\"hidden\":false,\"parentId\":0,\"component\":\"view/business/index.vue\",\"meta\":{\"title\":\"培训证书管理\",\"icon\":\"basketball\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false}}','{\"code\":7,\"data\":{},\"msg\":\"添加失败\"}',1),
(74,'2025-07-09 13:18:41.277','2025-07-09 13:18:41.277',NULL,'192.33.7.210','GET','/api/getApiGroups',200,45406351,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(75,'2025-07-09 13:19:34.167','2025-07-09 13:19:34.167',NULL,'192.33.7.210','POST','/api/createApi',200,261031670,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/bstraining/create\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"增加培训证书\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(76,'2025-07-09 13:19:34.376','2025-07-09 13:19:34.376',NULL,'192.33.7.210','GET','/api/getApiGroups',200,33785010,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(77,'2025-07-09 13:19:57.786','2025-07-09 13:19:57.786',NULL,'192.33.7.210','POST','/api/createApi',200,243170087,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/bstraining/getTrainingList\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"获取培训证书列表\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(78,'2025-07-09 13:19:57.987','2025-07-09 13:19:57.987',NULL,'192.33.7.210','GET','/api/getApiGroups',200,45207929,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(79,'2025-07-09 13:20:27.376','2025-07-09 13:20:27.376',NULL,'192.33.7.210','POST','/api/createApi',200,260499473,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/bstraining/delTrainingById\",\"apiGroup\":\"客户\",\"method\":\"PUT\",\"description\":\"删除单个培训证书信息by ID\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(80,'2025-07-09 13:20:27.586','2025-07-09 13:20:27.586',NULL,'192.33.7.210','GET','/api/getApiGroups',200,39302917,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(81,'2025-07-09 13:20:53.007','2025-07-09 13:20:53.007',NULL,'192.33.7.210','POST','/api/createApi',200,247278037,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/bstraining/setTrainingInfo\",\"apiGroup\":\"客户\",\"method\":\"PUT\",\"description\":\"更新培训证书信息\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(82,'2025-07-09 13:20:53.207','2025-07-09 13:20:53.207',NULL,'192.33.7.210','GET','/api/getApiGroups',200,47147353,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(83,'2025-07-09 13:21:09.225','2025-07-09 13:21:09.225',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,424737779,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(84,'2025-07-09 13:21:19.835','2025-07-09 13:21:19.835',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,369406048,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(85,'2025-07-09 14:09:58.246','2025-07-09 14:09:58.246',NULL,'192.33.7.210','GET','/api/getApiGroups',200,60795172,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(86,'2025-07-09 14:10:06.101','2025-07-09 14:10:06.101',NULL,'192.33.7.210','POST','/api/getApiById',200,71931935,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"id\":134}','{\"code\":0,\"data\":{\"api\":{\"ID\":134,\"CreatedAt\":\"2025-07-09T13:20:27.236+08:00\",\"UpdatedAt\":\"2025-07-09T13:20:27.236+08:00\",\"path\":\"/bstraining/delTrainingById\",\"description\":\"删除单个培训证书信息by ID\",\"apiGroup\":\"客户\",\"method\":\"PUT\"}},\"msg\":\"获取成功\"}',1),
(87,'2025-07-09 14:10:13.013','2025-07-09 14:10:13.013',NULL,'192.33.7.210','POST','/api/updateApi',200,643370354,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":134,\"CreatedAt\":\"2025-07-09T13:20:27.236+08:00\",\"UpdatedAt\":\"2025-07-09T13:20:27.236+08:00\",\"path\":\"/bstraining/delTrainingById\",\"description\":\"删除单个培训证书信息by ID\",\"apiGroup\":\"客户\",\"method\":\"DELETE\"}','{\"code\":0,\"data\":{},\"msg\":\"修改成功\"}',1),
(88,'2025-07-09 14:12:28.292','2025-07-09 14:12:28.292',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,493442345,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(89,'2025-07-09 14:12:33.530','2025-07-09 14:12:33.530',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,519420224,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(90,'2025-07-09 14:12:36.842','2025-07-09 14:12:36.842',NULL,'192.33.7.210','GET','/api/getApiGroups',200,57289642,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(91,'2025-07-09 14:12:43.263','2025-07-09 14:12:43.263',NULL,'192.33.7.210','POST','/api/getApiById',200,101177651,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"id\":134}','{\"code\":0,\"data\":{\"api\":{\"ID\":134,\"CreatedAt\":\"2025-07-09T13:20:27.236+08:00\",\"UpdatedAt\":\"2025-07-09T14:10:12.857+08:00\",\"path\":\"/bstraining/delTrainingById\",\"description\":\"删除单个培训证书信息by ID\",\"apiGroup\":\"客户\",\"method\":\"DELETE\"}},\"msg\":\"获取成功\"}',1),
(92,'2025-07-09 15:15:07.338','2025-07-09 15:15:07.338',NULL,'192.33.7.210','GET','/api/getApiGroups',200,244874026,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(93,'2025-07-09 15:16:03.216','2025-07-09 15:16:03.216',NULL,'192.33.7.210','POST','/api/createApi',200,277451173,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/bstraining/getOneTraining\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"获取单个培训证书信息\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(94,'2025-07-09 15:16:03.468','2025-07-09 15:16:03.468',NULL,'192.33.7.210','GET','/api/getApiGroups',200,74082548,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(95,'2025-07-09 15:16:12.177','2025-07-09 15:16:12.177',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,383291755,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(96,'2025-07-09 20:34:35.853','2025-07-09 20:34:35.853',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,38545375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"business\",\"name\":\"business\",\"hidden\":false,\"parentId\":0,\"component\":\"view/business/index.vue\",\"meta\":{\"title\":\"培训证书管理\",\"icon\":\"basketball\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false}}','{\"code\":7,\"data\":{},\"msg\":\"添加失败\"}',1),
(97,'2025-07-09 20:42:47.726','2025-07-09 20:42:47.726',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,117250834,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"trainingBusiness\",\"name\":\"trainingBusiness\",\"hidden\":false,\"parentId\":0,\"component\":\"view/trainingBusiness/index/vue\",\"meta\":{\"title\":\"培训证书管理\",\"icon\":\"bicycle\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false}}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(98,'2025-07-09 20:45:23.630','2025-07-09 20:45:23.630',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,36988917,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"certificateAdd\",\"name\":\"certificateAdd\",\"hidden\":false,\"parentId\":39,\"component\":\"view/trainingBusiness/training/trainingAdd.vue\",\"meta\":{\"title\":\"培训证书添加\",\"icon\":\"baseball\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false}}','{\"code\":7,\"data\":{},\"msg\":\"添加失败\"}',1),
(99,'2025-07-09 20:47:08.482','2025-07-09 20:47:08.482',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,114631458,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"trainingAdd\",\"name\":\"trainingAdd\",\"hidden\":false,\"parentId\":39,\"component\":\"view/trainingBusiness/training/trainingAdd.vue\",\"meta\":{\"activeName\":\"\",\"title\":\"培训证书增加\",\"icon\":\"baseball\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(100,'2025-07-09 20:47:54.394','2025-07-09 20:47:54.394',NULL,'127.0.0.1','POST','/menu/addBaseMenu',200,115982584,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"trainingQuery\",\"name\":\"trainingQuery\",\"hidden\":false,\"parentId\":39,\"component\":\"view/trainingBusiness/training/trainingQuery.vue\",\"meta\":{\"title\":\"培训证书查询\",\"icon\":\"basketball\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false}}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(101,'2025-07-09 20:48:38.841','2025-07-09 20:48:38.841',NULL,'127.0.0.1','POST','/menu/addMenuAuthority',200,405917917,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(102,'2025-07-26 20:37:43.031','2025-07-26 20:37:43.031',NULL,'127.0.0.1','GET','/api/getApiGroups',200,114076291,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(103,'2025-07-26 20:47:52.409','2025-07-26 20:47:52.409',NULL,'127.0.0.1','POST','/api/createApi',200,114013958,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"/student/sendCode\",\"apiGroup\":\"email\",\"method\":\"POST\",\"description\":\"用户注册给邮箱发送验证码\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(104,'2025-07-26 20:47:52.585','2025-07-26 20:47:52.585',NULL,'127.0.0.1','GET','/api/getApiGroups',200,77513125,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"email\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(105,'2025-07-26 20:48:19.461','2025-07-26 20:48:19.461',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,189004167,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(106,'2025-07-26 20:51:02.361','2025-07-26 20:51:02.361',NULL,'127.0.0.1','GET','/api/getApiGroups',200,40336875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"email\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(107,'2025-07-26 21:18:45.055','2025-07-26 21:18:45.055',NULL,'127.0.0.1','POST','/api/getApiById',200,38938167,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"id\":137}','{\"code\":0,\"data\":{\"api\":{\"ID\":137,\"CreatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"UpdatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"path\":\"/student/sendCode\",\"description\":\"用户注册给邮箱发送验证码\",\"apiGroup\":\"email\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(108,'2025-07-26 21:38:58.159','2025-07-26 21:38:58.159',NULL,'127.0.0.1','GET','/api/syncApi',200,92703333,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"deleteApis\":[{\"ID\":87,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/sysOperationRecord/createSysOperationRecord\",\"description\":\"新增操作记录\",\"apiGroup\":\"操作记录\",\"method\":\"POST\"},{\"ID\":92,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/upload\",\"description\":\"插件版分片上传\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"POST\"},{\"ID\":93,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/checkFileMd5\",\"description\":\"文件完整度验证\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"GET\"},{\"ID\":94,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/mergeFileMd5\",\"description\":\"上传完成合并文件\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"GET\"}],\"ignoreApis\":[{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/swagger/*any\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/api/freshCasbin\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/uploads/file/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/health\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/uploads/file/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"HEAD\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/llmAuto\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/system/reloadSystem\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/base/login\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/base/captcha\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/init/initdb\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/init/checkdb\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/info/getInfoDataSource\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/info/getInfoPublic\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"}],\"newApis\":[{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sysExportTemplate/exportExcelByToken\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sysExportTemplate/exportTemplateByToken\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sse\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/img_certificate/2018/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/initMenu\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/initAPI\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/create\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/message\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/img_certificate/2018/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"HEAD\"}]},\"msg\":\"成功\"}',1),
(109,'2025-07-26 21:40:40.150','2025-07-26 21:40:40.150',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,199702417,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":36,\"CreatedAt\":\"2025-06-30T20:58:18.841+08:00\",\"UpdatedAt\":\"2025-06-30T20:58:47.072+08:00\",\"parentId\":0,\"path\":\"business\",\"name\":\"business\",\"hidden\":false,\"component\":\"view/business/index.vue\",\"sort\":2,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"证书管理\",\"icon\":\"circle-check\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(110,'2025-07-26 21:40:50.661','2025-07-26 21:40:50.661',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,194730500,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":39,\"CreatedAt\":\"2025-07-09T20:42:47.647+08:00\",\"UpdatedAt\":\"2025-07-09T20:42:47.647+08:00\",\"parentId\":0,\"path\":\"trainingBusiness\",\"name\":\"trainingBusiness\",\"hidden\":false,\"component\":\"view/trainingBusiness/index/vue\",\"sort\":3,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"培训证书管理\",\"icon\":\"bicycle\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(111,'2025-07-26 21:41:18.422','2025-07-26 21:41:18.422',NULL,'127.0.0.1','GET','/api/getApiGroups',200,35873542,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"email\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(112,'2025-07-26 21:42:13.583','2025-07-26 21:42:13.583',NULL,'127.0.0.1','POST','/menu/updateBaseMenu',200,182168166,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":39,\"CreatedAt\":\"2025-07-09T20:42:47.647+08:00\",\"UpdatedAt\":\"2025-07-26T21:40:50.583+08:00\",\"parentId\":0,\"path\":\"trainingBusiness\",\"name\":\"trainingBusiness\",\"hidden\":false,\"component\":\"view/trainingBusiness/index/vue\",\"sort\":2,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"培训证书管理\",\"icon\":\"bicycle\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(113,'2025-07-26 21:46:28.059','2025-07-26 21:46:28.059',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,208451916,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(114,'2025-07-26 21:46:54.782','2025-07-26 21:46:54.782',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,194177250,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(115,'2025-07-26 21:47:13.323','2025-07-26 21:47:13.323',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,200522667,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(116,'2025-07-26 21:47:50.680','2025-07-26 21:47:50.680',NULL,'127.0.0.1','GET','/api/getApiGroups',200,40701208,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"email\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(117,'2025-07-26 21:47:54.114','2025-07-26 21:47:54.114',NULL,'127.0.0.1','POST','/api/getApiById',200,37511417,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"id\":137}','{\"code\":0,\"data\":{\"api\":{\"ID\":137,\"CreatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"UpdatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"path\":\"/student/sendCode\",\"description\":\"用户注册给邮箱发送验证码\",\"apiGroup\":\"email\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(118,'2025-07-26 21:48:04.222','2025-07-26 21:48:04.222',NULL,'127.0.0.1','POST','/api/updateApi',200,228244000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":137,\"CreatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"UpdatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"path\":\"/student/sendCode\",\"description\":\"用户注册给邮箱发送验证码\",\"apiGroup\":\"客户\",\"method\":\"POST\"}','{\"code\":0,\"data\":{},\"msg\":\"修改成功\"}',1),
(119,'2025-07-26 21:48:38.778','2025-07-26 21:48:38.778',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,199887125,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(120,'2025-07-26 21:51:51.502','2025-07-26 21:51:51.502',NULL,'127.0.0.1','POST','/api/createApi',200,125815333,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"/student/create\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"学生用户注册\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(121,'2025-07-26 21:51:51.646','2025-07-26 21:51:51.646',NULL,'127.0.0.1','GET','/api/getApiGroups',200,40102375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(122,'2025-07-26 21:52:13.796','2025-07-26 21:52:13.796',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,202428542,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(123,'2025-07-26 21:56:28.065','2025-07-26 21:56:28.065',NULL,'127.0.0.1','POST','/api/getApiById',200,42594667,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"id\":137}','{\"code\":0,\"data\":{\"api\":{\"ID\":137,\"CreatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"UpdatedAt\":\"2025-07-26T21:48:04.137+08:00\",\"path\":\"/student/sendCode\",\"description\":\"用户注册给邮箱发送验证码\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(124,'2025-07-26 21:56:38.424','2025-07-26 21:56:38.424',NULL,'127.0.0.1','POST','/api/updateApi',200,284184375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":137,\"CreatedAt\":\"2025-07-26T20:47:52.332+08:00\",\"UpdatedAt\":\"2025-07-26T21:48:04.137+08:00\",\"path\":\"/student/sendEmailCode\",\"description\":\"用户注册给邮箱发送验证码\",\"apiGroup\":\"客户\",\"method\":\"POST\"}','{\"code\":0,\"data\":{},\"msg\":\"修改成功\"}',1),
(125,'2025-07-26 21:57:03.178','2025-07-26 21:57:03.178',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,206572542,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(126,'2025-07-27 15:10:37.050','2025-07-27 15:10:37.050',NULL,'127.0.0.1','GET','/api/getApiGroups',200,113830000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(127,'2025-07-27 15:10:44.065','2025-07-27 15:10:44.065',NULL,'127.0.0.1','POST','/api/getApiById',200,37513041,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"id\":138}','{\"code\":0,\"data\":{\"api\":{\"ID\":138,\"CreatedAt\":\"2025-07-26T21:51:51.419+08:00\",\"UpdatedAt\":\"2025-07-26T21:51:51.419+08:00\",\"path\":\"/student/create\",\"description\":\"学生用户注册\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(128,'2025-07-27 15:10:52.828','2025-07-27 15:10:52.828',NULL,'127.0.0.1','POST','/api/updateApi',200,250748459,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":138,\"CreatedAt\":\"2025-07-26T21:51:51.419+08:00\",\"UpdatedAt\":\"2025-07-26T21:51:51.419+08:00\",\"path\":\"/student/login\",\"description\":\"学生用户注册\",\"apiGroup\":\"客户\",\"method\":\"POST\"}','{\"code\":0,\"data\":{},\"msg\":\"修改成功\"}',1),
(129,'2025-07-27 15:12:01.653','2025-07-27 15:12:01.653',NULL,'127.0.0.1','GET','/api/getApiGroups',200,39299125,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(130,'2025-07-27 15:12:43.133','2025-07-27 15:12:43.133',NULL,'127.0.0.1','POST','/api/createApi',200,112998792,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"/student/register\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"学生用户注册\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(131,'2025-07-27 15:12:43.280','2025-07-27 15:12:43.280',NULL,'127.0.0.1','GET','/api/getApiGroups',200,38377125,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(132,'2025-07-27 15:13:27.403','2025-07-27 15:13:27.403',NULL,'127.0.0.1','POST','/api/createApi',200,111864208,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"/sutduent/initPassword\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"学生用户忘记密码初始化密码\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(133,'2025-07-27 15:13:27.532','2025-07-27 15:13:27.532',NULL,'127.0.0.1','GET','/api/getApiGroups',200,36671250,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(134,'2025-07-27 15:13:53.494','2025-07-27 15:13:53.494',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,181198541,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(135,'2025-07-27 15:13:55.800','2025-07-27 15:13:55.800',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,178981584,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(136,'2025-07-27 15:14:02.437','2025-07-27 15:14:02.437',NULL,'127.0.0.1','POST','/api/getApiById',200,37094917,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"id\":138}','{\"code\":0,\"data\":{\"api\":{\"ID\":138,\"CreatedAt\":\"2025-07-26T21:51:51.419+08:00\",\"UpdatedAt\":\"2025-07-27T15:10:52.748+08:00\",\"path\":\"/student/login\",\"description\":\"学生用户注册\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(137,'2025-07-27 15:14:08.956','2025-07-27 15:14:08.956',NULL,'127.0.0.1','POST','/api/updateApi',200,208143916,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":138,\"CreatedAt\":\"2025-07-26T21:51:51.419+08:00\",\"UpdatedAt\":\"2025-07-27T15:10:52.748+08:00\",\"path\":\"/student/login\",\"description\":\"学生用户登录\",\"apiGroup\":\"客户\",\"method\":\"POST\"}','{\"code\":0,\"data\":{},\"msg\":\"修改成功\"}',1),
(138,'2025-07-27 15:40:21.832','2025-07-27 15:40:21.832',NULL,'127.0.0.1','GET','/api/getApiGroups',200,36692750,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(139,'2025-07-27 15:40:32.637','2025-07-27 15:40:32.637',NULL,'127.0.0.1','GET','/api/getApiGroups',200,37215750,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(140,'2025-07-27 15:40:34.565','2025-07-27 15:40:34.565',NULL,'127.0.0.1','GET','/api/getApiGroups',200,39578584,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(141,'2025-07-27 16:17:45.452','2025-07-27 16:17:45.452',NULL,'127.0.0.1','GET','/api/getApiGroups',200,54412416,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(142,'2025-07-27 16:28:48.406','2025-07-27 16:28:48.406',NULL,'127.0.0.1','GET','/api/getApiGroups',200,74508833,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(143,'2025-07-27 17:23:04.527','2025-07-27 17:23:04.527',NULL,'127.0.0.1','GET','/api/getApiGroups',200,44537000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(144,'2025-07-27 17:23:09.817','2025-07-27 17:23:09.817',NULL,'127.0.0.1','GET','/api/getApiGroups',200,67075708,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(145,'2025-07-27 17:32:04.908','2025-07-27 17:32:04.908',NULL,'127.0.0.1','GET','/api/getApiGroups',200,38542167,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(146,'2025-07-27 17:55:29.965','2025-07-27 17:55:29.965',NULL,'127.0.0.1','GET','/api/getApiGroups',200,44668958,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sutduent\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(147,'2025-07-27 17:55:43.082','2025-07-27 17:55:43.082',NULL,'127.0.0.1','POST','/api/getApiById',200,35804291,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"id\":140}','{\"code\":0,\"data\":{\"api\":{\"ID\":140,\"CreatedAt\":\"2025-07-27T15:13:27.329+08:00\",\"UpdatedAt\":\"2025-07-27T15:13:27.329+08:00\",\"path\":\"/sutduent/initPassword\",\"description\":\"学生用户忘记密码初始化密码\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(148,'2025-07-27 17:55:48.056','2025-07-27 17:55:48.056',NULL,'127.0.0.1','POST','/api/updateApi',200,239442917,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":140,\"CreatedAt\":\"2025-07-27T15:13:27.329+08:00\",\"UpdatedAt\":\"2025-07-27T15:13:27.329+08:00\",\"path\":\"/student/initPassword\",\"description\":\"学生用户忘记密码初始化密码\",\"apiGroup\":\"客户\",\"method\":\"POST\"}','{\"code\":0,\"data\":{},\"msg\":\"修改成功\"}',1),
(149,'2025-07-27 19:28:07.571','2025-07-27 19:28:07.571',NULL,'127.0.0.1','GET','/api/getApiGroups',200,59601333,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(150,'2025-07-27 19:28:40.599','2025-07-27 19:28:40.599',NULL,'127.0.0.1','POST','/api/createApi',200,104181166,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"/student/getInfo\",\"apiGroup\":\"客户\",\"method\":\"GET\",\"description\":\"学生获取学生信息\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(151,'2025-07-27 19:28:40.726','2025-07-27 19:28:40.726',NULL,'127.0.0.1','GET','/api/getApiGroups',200,38075375,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(152,'2025-07-27 19:28:51.515','2025-07-27 19:28:51.515',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,223900125,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(153,'2025-07-27 19:39:55.216','2025-07-27 19:39:55.216',NULL,'127.0.0.1','GET','/api/getApiGroups',200,37049250,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(154,'2025-07-27 20:41:20.571','2025-07-27 20:41:20.571',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,195892667,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(155,'2025-07-30 20:45:15.210','2025-07-30 20:45:15.210',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,175399542,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(156,'2025-08-01 10:00:47.550','2025-08-01 10:00:47.550',NULL,'192.33.7.210','GET','/api/getApiGroups',200,30857580,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(157,'2025-08-01 10:01:50.711','2025-08-01 10:01:50.711',NULL,'192.33.7.210','POST','/api/createApi',200,240566988,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/student/updateField\",\"apiGroup\":\"客户\",\"method\":\"PUT\",\"description\":\"更新学生属性\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(158,'2025-08-01 10:01:50.911','2025-08-01 10:01:50.911',NULL,'192.33.7.210','GET','/api/getApiGroups',200,36060230,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(159,'2025-08-01 10:02:16.251','2025-08-01 10:02:16.251',NULL,'192.33.7.210','POST','/api/createApi',200,255530166,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/student/changePassword\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"学生修改密码\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(160,'2025-08-01 10:02:16.454','2025-08-01 10:02:16.454',NULL,'192.33.7.210','GET','/api/getApiGroups',200,44771228,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(161,'2025-08-01 10:02:28.352','2025-08-01 10:02:28.352',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,399911054,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(162,'2025-08-05 20:48:50.483','2025-08-05 20:48:50.483',NULL,'127.0.0.1','GET','/api/getApiGroups',200,39863000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(163,'2025-08-05 20:50:05.897','2025-08-05 20:50:05.897',NULL,'127.0.0.1','GET','/api/getApiGroups',200,34761583,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(164,'2025-08-05 20:50:50.731','2025-08-05 20:50:50.731',NULL,'127.0.0.1','POST','/api/createApi',200,108245916,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"/student/getCertificateList\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"获取学生证书列表信息\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(165,'2025-08-05 20:50:50.858','2025-08-05 20:50:50.858',NULL,'127.0.0.1','GET','/api/getApiGroups',200,36542292,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(166,'2025-08-05 20:51:30.750','2025-08-05 20:51:30.750',NULL,'127.0.0.1','POST','/api/getApiById',200,34248834,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"id\":144}','{\"code\":0,\"data\":{\"api\":{\"ID\":144,\"CreatedAt\":\"2025-08-05T20:50:50.66+08:00\",\"UpdatedAt\":\"2025-08-05T20:50:50.66+08:00\",\"path\":\"/student/getCertificateList\",\"description\":\"获取学生证书列表信息\",\"apiGroup\":\"客户\",\"method\":\"POST\"}},\"msg\":\"获取成功\"}',1),
(167,'2025-08-05 20:51:34.878','2025-08-05 20:51:34.878',NULL,'127.0.0.1','POST','/api/updateApi',200,251689000,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"ID\":144,\"CreatedAt\":\"2025-08-05T20:50:50.66+08:00\",\"UpdatedAt\":\"2025-08-05T20:50:50.66+08:00\",\"path\":\"/student/getCertificateList\",\"description\":\"获取学生证书列表信息\",\"apiGroup\":\"客户\",\"method\":\"GET\"}','{\"code\":0,\"data\":{},\"msg\":\"修改成功\"}',1),
(168,'2025-08-05 20:51:49.262','2025-08-05 20:51:49.262',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,193478542,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(169,'2025-08-09 17:01:06.818','2025-08-09 17:01:06.818',NULL,'127.0.0.1','GET','/api/getApiGroups',200,131944708,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(170,'2025-08-09 17:08:26.620','2025-08-09 17:08:26.620',NULL,'127.0.0.1','POST','/api/createApi',200,152645458,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"student/order-my-pending\",\"apiGroup\":\"客户\",\"method\":\"GET\",\"description\":\"学生获取支付订单\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(171,'2025-08-09 17:08:26.785','2025-08-09 17:08:26.785',NULL,'127.0.0.1','GET','/api/getApiGroups',200,42198541,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-my-pending\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(172,'2025-08-09 17:09:01.826','2025-08-09 17:09:01.826',NULL,'127.0.0.1','POST','/api/createApi',200,131676208,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"student/order-pay/:orderSn\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"支付订单\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(173,'2025-08-09 17:09:02.000','2025-08-09 17:09:02.000',NULL,'127.0.0.1','GET','/api/getApiGroups',200,45997083,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(174,'2025-08-09 17:09:35.928','2025-08-09 17:09:35.928',NULL,'127.0.0.1','POST','/api/createApi',200,137902875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"student/order-status/:orderSn\",\"apiGroup\":\"客户\",\"method\":\"GET\",\"description\":\"获取订单状态\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(175,'2025-08-09 17:09:36.118','2025-08-09 17:09:36.118',NULL,'127.0.0.1','GET','/api/getApiGroups',200,45643291,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-status\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(176,'2025-08-09 17:10:14.281','2025-08-09 17:10:14.281',NULL,'127.0.0.1','POST','/api/createApi',200,127977958,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"student/order-refresh/:orderSn\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"二维码过期刷新\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(177,'2025-08-09 17:10:14.470','2025-08-09 17:10:14.470',NULL,'127.0.0.1','GET','/api/getApiGroups',200,47737333,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(178,'2025-08-09 17:10:46.759','2025-08-09 17:10:46.759',NULL,'127.0.0.1','POST','/api/createApi',200,136183750,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"student/order-wechat-notify\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"微信支付成功回调接口\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(179,'2025-08-09 17:10:46.951','2025-08-09 17:10:46.951',NULL,'127.0.0.1','GET','/api/getApiGroups',200,40736250,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(180,'2025-08-09 17:11:01.575','2025-08-09 17:11:01.575',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,206376875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(181,'2025-08-11 13:36:08.502','2025-08-11 13:36:08.502',NULL,'192.33.7.210','GET','/api/getApiGroups',200,43829103,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(182,'2025-08-11 13:36:55.024','2025-08-11 13:36:55.024',NULL,'192.33.7.210','POST','/api/createApi',200,271841872,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"student/order-detail/:orderSn\",\"apiGroup\":\"客户\",\"method\":\"GET\",\"description\":\"学生获取订单详情\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(183,'2025-08-11 13:36:55.237','2025-08-11 13:36:55.237',NULL,'192.33.7.210','GET','/api/getApiGroups',200,45886301,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(184,'2025-08-11 13:37:04.412','2025-08-11 13:37:04.412',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,427805375,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(185,'2025-08-11 22:19:52.229','2025-08-11 22:19:52.229',NULL,'127.0.0.1','GET','/api/getApiGroups',200,114345333,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(186,'2025-08-11 22:21:16.034','2025-08-11 22:21:16.034',NULL,'127.0.0.1','POST','/api/createApi',200,116471500,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"student/certificate-create\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"学生端插入证书接口\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(187,'2025-08-11 22:21:16.171','2025-08-11 22:21:16.171',NULL,'127.0.0.1','GET','/api/getApiGroups',200,37307958,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(188,'2025-08-11 22:22:00.016','2025-08-11 22:22:00.016',NULL,'127.0.0.1','POST','/api/createApi',200,115491875,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"student/training-create\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"学生端培训证书插入接口\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(189,'2025-08-11 22:22:00.183','2025-08-11 22:22:00.183',NULL,'127.0.0.1','GET','/api/getApiGroups',200,44099583,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"training-create\":\"客户\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(190,'2025-08-11 22:22:16.954','2025-08-11 22:22:16.954',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,209167917,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(191,'2025-08-12 10:15:59.891','2025-08-12 10:15:59.891',NULL,'192.33.7.210','POST','/menu/addBaseMenu',200,249791560,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"orderQuery\",\"name\":\"orderQuery\",\"hidden\":false,\"parentId\":0,\"component\":\"view/order/orderManager/orderQuery.vue\",\"meta\":{\"activeName\":\"\",\"title\":\"订单管理\",\"icon\":\"\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"parameters\":[],\"menuBtn\":[],\"sort\":2}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(192,'2025-08-12 10:17:07.623','2025-08-12 10:17:07.623',NULL,'192.33.7.210','POST','/menu/updateBaseMenu',200,578752075,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":42,\"CreatedAt\":\"2025-08-12T10:15:59.74+08:00\",\"UpdatedAt\":\"2025-08-12T10:15:59.74+08:00\",\"parentId\":0,\"path\":\"order\",\"name\":\"order\",\"hidden\":false,\"component\":\"view/order/index.vue\",\"sort\":2,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"订单管理\",\"icon\":\"\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(193,'2025-08-12 10:17:49.422','2025-08-12 10:17:49.422',NULL,'192.33.7.210','POST','/menu/addBaseMenu',200,274979338,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"orderQuery\",\"name\":\"orderQuery\",\"hidden\":false,\"parentId\":42,\"component\":\"view/order/orderManager/orderQuery.vue\",\"meta\":{\"title\":\"订单管理\",\"icon\":\"add-location\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"sort\":1}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(194,'2025-08-12 10:18:05.903','2025-08-12 10:18:05.903',NULL,'192.33.7.210','POST','/menu/updateBaseMenu',200,516413493,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":42,\"CreatedAt\":\"2025-08-12T10:15:59.74+08:00\",\"UpdatedAt\":\"2025-08-12T10:17:07.422+08:00\",\"parentId\":0,\"path\":\"order\",\"name\":\"order\",\"hidden\":false,\"component\":\"view/order/index.vue\",\"sort\":2,\"meta\":{\"activeName\":\"\",\"keepAlive\":false,\"defaultMenu\":false,\"title\":\"订单管理\",\"icon\":\"camera\",\"closeTab\":false,\"transitionType\":\"\"},\"authoritys\":null,\"children\":null,\"parameters\":[],\"menuBtn\":[]}','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(195,'2025-08-12 10:18:38.967','2025-08-12 10:18:38.967',NULL,'192.33.7.210','POST','/menu/addMenuAuthority',200,871484275,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(196,'2025-08-12 10:18:41.073','2025-08-12 10:18:41.073',NULL,'192.33.7.210','POST','/menu/addMenuAuthority',200,878827561,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(197,'2025-08-12 12:04:21.166','2025-08-12 12:04:21.166',NULL,'192.33.7.210','GET','/api/getApiGroups',200,24396357,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":7,\"data\":{},\"msg\":\"获取失败\"}',1),
(198,'2025-08-12 12:04:36.136','2025-08-12 12:04:36.136',NULL,'192.33.7.210','GET','/api/getApiGroups',200,53588775,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"training-create\":\"客户\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(199,'2025-08-12 12:05:02.336','2025-08-12 12:05:02.336',NULL,'192.33.7.210','POST','/api/createApi',200,284647514,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"path\":\"/bszhengshu/getOrderList\",\"apiGroup\":\"客户\",\"method\":\"POST\",\"description\":\"获取学生订单列表\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(200,'2025-08-12 12:05:02.567','2025-08-12 12:05:02.567',NULL,'192.33.7.210','GET','/api/getApiGroups',200,49364521,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"training-create\":\"客户\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(201,'2025-08-12 12:05:13.917','2025-08-12 12:05:13.917',NULL,'192.33.7.210','POST','/casbin/updateCasbin',200,361678356,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(202,'2025-08-13 10:02:23.950','2025-08-13 10:02:23.950',NULL,'192.33.7.210','GET','/api/getApiGroups',200,145464517,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"training-create\":\"客户\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(203,'2025-08-13 10:02:28.179','2025-08-13 10:02:28.179',NULL,'192.33.7.210','GET','/api/syncApi',200,63883035,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"deleteApis\":[{\"ID\":87,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/sysOperationRecord/createSysOperationRecord\",\"description\":\"新增操作记录\",\"apiGroup\":\"操作记录\",\"method\":\"POST\"},{\"ID\":92,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/upload\",\"description\":\"插件版分片上传\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"POST\"},{\"ID\":93,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/checkFileMd5\",\"description\":\"文件完整度验证\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"GET\"},{\"ID\":94,\"CreatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"UpdatedAt\":\"2025-06-23T17:31:32.942+08:00\",\"path\":\"/simpleUploader/mergeFileMd5\",\"description\":\"上传完成合并文件\",\"apiGroup\":\"断点续传(插件版)\",\"method\":\"GET\"},{\"ID\":145,\"CreatedAt\":\"2025-08-09T17:08:26.529+08:00\",\"UpdatedAt\":\"2025-08-09T17:08:26.529+08:00\",\"path\":\"student/order-my-pending\",\"description\":\"学生获取支付订单\",\"apiGroup\":\"客户\",\"method\":\"GET\"},{\"ID\":146,\"CreatedAt\":\"2025-08-09T17:09:01.738+08:00\",\"UpdatedAt\":\"2025-08-09T17:09:01.738+08:00\",\"path\":\"student/order-pay/:orderSn\",\"description\":\"支付订单\",\"apiGroup\":\"客户\",\"method\":\"POST\"},{\"ID\":147,\"CreatedAt\":\"2025-08-09T17:09:35.835+08:00\",\"UpdatedAt\":\"2025-08-09T17:09:35.835+08:00\",\"path\":\"student/order-status/:orderSn\",\"description\":\"获取订单状态\",\"apiGroup\":\"客户\",\"method\":\"GET\"},{\"ID\":148,\"CreatedAt\":\"2025-08-09T17:10:14.197+08:00\",\"UpdatedAt\":\"2025-08-09T17:10:14.197+08:00\",\"path\":\"student/order-refresh/:orderSn\",\"description\":\"二维码过期刷新\",\"apiGroup\":\"客户\",\"method\":\"POST\"},{\"ID\":149,\"CreatedAt\":\"2025-08-09T17:10:46.666+08:00\",\"UpdatedAt\":\"2025-08-09T17:10:46.666+08:00\",\"path\":\"student/order-wechat-notify\",\"description\":\"微信支付成功回调接口\",\"apiGroup\":\"客户\",\"method\":\"POST\"},{\"ID\":150,\"CreatedAt\":\"2025-08-11T13:36:54.862+08:00\",\"UpdatedAt\":\"2025-08-11T13:36:54.862+08:00\",\"path\":\"student/order-detail/:orderSn\",\"description\":\"学生获取订单详情\",\"apiGroup\":\"客户\",\"method\":\"GET\"},{\"ID\":151,\"CreatedAt\":\"2025-08-11T22:21:15.955+08:00\",\"UpdatedAt\":\"2025-08-11T22:21:15.955+08:00\",\"path\":\"student/certificate-create\",\"description\":\"学生端插入证书接口\",\"apiGroup\":\"客户\",\"method\":\"POST\"},{\"ID\":152,\"CreatedAt\":\"2025-08-11T22:21:59.938+08:00\",\"UpdatedAt\":\"2025-08-11T22:21:59.938+08:00\",\"path\":\"student/training-create\",\"description\":\"学生端培训证书插入接口\",\"apiGroup\":\"客户\",\"method\":\"POST\"}],\"ignoreApis\":[{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/swagger/*any\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/api/freshCasbin\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/uploads/file/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/health\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/uploads/file/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"HEAD\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/llmAuto\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/system/reloadSystem\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/base/login\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/base/captcha\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/init/initdb\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/init/checkdb\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/info/getInfoDataSource\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/info/getInfoPublic\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"}],\"newApis\":[{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sysExportTemplate/exportExcelByToken\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sysExportTemplate/exportTemplateByToken\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/order-my-pending\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/order-status/:orderSn\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/order-detail/:orderSn\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/sse\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/img_certificate/2018/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"GET\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/initMenu\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/autoCode/initAPI\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/order-wechat-notify\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/order-pay/:orderSn\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/order-refresh/:orderSn\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/certificate-create\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/student/training-create\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/message\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/fileUploadAndDownload/uploadEx\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"POST\"},{\"ID\":0,\"CreatedAt\":\"0001-01-01T00:00:00Z\",\"UpdatedAt\":\"0001-01-01T00:00:00Z\",\"path\":\"/img_certificate/2018/*filepath\",\"description\":\"\",\"apiGroup\":\"\",\"method\":\"HEAD\"}]},\"msg\":\"成功\"}',1),
(204,'2025-08-13 13:06:53.173','2025-08-13 13:06:53.173',NULL,'192.33.7.210','POST','/menu/addBaseMenu',200,239069840,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"order\",\"name\":\"order\",\"hidden\":false,\"parentId\":0,\"component\":\"view/order/index.vue\",\"meta\":{\"activeName\":\"\",\"title\":\"订单管理\",\"icon\":\"dish\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"parameters\":[],\"menuBtn\":[],\"sort\":3}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(205,'2025-08-13 13:07:26.763','2025-08-13 13:07:26.763',NULL,'192.33.7.210','POST','/menu/addBaseMenu',200,279091406,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','{\"ID\":0,\"path\":\"orderQuery\",\"name\":\"orderQuery\",\"hidden\":false,\"parentId\":44,\"component\":\"view/order/orderManager/orderQuery.vue\",\"meta\":{\"title\":\"订单管理\",\"icon\":\"house\",\"defaultMenu\":false,\"closeTab\":false,\"keepAlive\":false},\"sort\":1}','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(206,'2025-08-13 13:07:45.074','2025-08-13 13:07:45.074',NULL,'192.33.7.210','POST','/menu/addMenuAuthority',200,939978465,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"添加成功\"}',1),
(207,'2025-08-17 21:04:01.385','2025-08-17 21:04:01.385',NULL,'127.0.0.1','GET','/api/getApiGroups',200,37307250,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"training-create\":\"客户\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(208,'2025-08-17 21:04:39.452','2025-08-17 21:04:39.452',NULL,'127.0.0.1','POST','/api/createApi',200,111256125,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{\"path\":\"/bszhengshu/delOrderById\",\"apiGroup\":\"客户\",\"method\":\"DELETE\",\"description\":\"管理平台删除订单接口\"}','{\"code\":0,\"data\":{},\"msg\":\"创建成功\"}',1),
(209,'2025-08-17 21:04:39.603','2025-08-17 21:04:39.603',NULL,'127.0.0.1','GET','/api/getApiGroups',200,37079083,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"training-create\":\"客户\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1),
(210,'2025-08-17 21:04:49.325','2025-08-17 21:04:49.325',NULL,'127.0.0.1','POST','/casbin/updateCasbin',200,185302833,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','[超出记录长度]','{\"code\":0,\"data\":{},\"msg\":\"更新成功\"}',1),
(211,'2025-08-17 21:18:00.377','2025-08-17 21:18:00.377',NULL,'127.0.0.1','GET','/api/getApiGroups',200,36289791,'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36','','{}','{\"code\":0,\"data\":{\"apiGroupMap\":{\"api\":\"api\",\"attachmentCategory\":\"媒体库分类\",\"authority\":\"角色\",\"authorityBtn\":\"按钮权限\",\"autoCode\":\"代码生成器历史\",\"bstraining\":\"客户\",\"bszhengshu\":\"客户\",\"casbin\":\"casbin\",\"certificate-create\":\"客户\",\"customer\":\"客户\",\"demoRecord\":\"api\",\"email\":\"email\",\"fileUploadAndDownload\":\"文件上传与下载\",\"info\":\"公告\",\"jwt\":\"jwt\",\"menu\":\"菜单\",\"order-detail\":\"客户\",\"order-my-pending\":\"客户\",\"order-pay\":\"客户\",\"order-refresh\":\"客户\",\"order-status\":\"客户\",\"order-wechat-notify\":\"客户\",\"simpleUploader\":\"断点续传(插件版)\",\"student\":\"客户\",\"sysDictionary\":\"系统字典\",\"sysDictionaryDetail\":\"系统字典详情\",\"sysExportTemplate\":\"导出模板\",\"sysOperationRecord\":\"操作记录\",\"sysParams\":\"参数管理\",\"system\":\"系统服务\",\"training-create\":\"客户\",\"user\":\"系统用户\"},\"groups\":[\"jwt\",\"系统用户\",\"api\",\"角色\",\"casbin\",\"菜单\",\"分片上传\",\"文件上传与下载\",\"系统服务\",\"客户\",\"代码生成器\",\"模板配置\",\"代码生成器历史\",\"系统字典详情\",\"系统字典\",\"操作记录\",\"断点续传(插件版)\",\"email\",\"按钮权限\",\"导出模板\",\"公告\",\"参数管理\",\"媒体库分类\"]},\"msg\":\"成功\"}',1);

/*Table structure for table `sys_params` */

DROP TABLE IF EXISTS `sys_params`;

CREATE TABLE `sys_params` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL COMMENT '参数名称',
  `key` varchar(191) DEFAULT NULL COMMENT '参数键',
  `value` varchar(191) DEFAULT NULL COMMENT '参数值',
  `desc` varchar(191) DEFAULT NULL COMMENT '参数说明',
  PRIMARY KEY (`id`),
  KEY `idx_sys_params_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_params` */

/*Table structure for table `sys_user_authority` */

DROP TABLE IF EXISTS `sys_user_authority`;

CREATE TABLE `sys_user_authority` (
  `sys_user_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `sys_authority_authority_id` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`sys_user_id`,`sys_authority_authority_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_user_authority` */

insert  into `sys_user_authority`(`sys_user_id`,`sys_authority_authority_id`) values 
(1,888),
(1,8881),
(1,9528),
(2,888);

/*Table structure for table `sys_users` */

DROP TABLE IF EXISTS `sys_users`;

CREATE TABLE `sys_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `uuid` varchar(191) DEFAULT NULL COMMENT '用户UUID',
  `username` varchar(191) DEFAULT NULL COMMENT '用户登录名',
  `password` varchar(191) DEFAULT NULL COMMENT '用户登录密码',
  `nick_name` varchar(191) DEFAULT '系统用户' COMMENT '用户昵称',
  `header_img` varchar(191) DEFAULT 'https://qmplusimg.henrongyi.top/gva_header.jpg' COMMENT '用户头像',
  `authority_id` bigint(20) unsigned DEFAULT '888' COMMENT '用户角色ID',
  `phone` varchar(191) DEFAULT NULL COMMENT '用户手机号',
  `email` varchar(191) DEFAULT NULL COMMENT '用户邮箱',
  `enable` bigint(20) DEFAULT '1' COMMENT '用户是否被冻结 1正常 2冻结',
  `origin_setting` text COMMENT '配置',
  PRIMARY KEY (`id`),
  KEY `idx_sys_users_deleted_at` (`deleted_at`),
  KEY `idx_sys_users_uuid` (`uuid`),
  KEY `idx_sys_users_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

/*Data for the table `sys_users` */

insert  into `sys_users`(`id`,`created_at`,`updated_at`,`deleted_at`,`uuid`,`username`,`password`,`nick_name`,`header_img`,`authority_id`,`phone`,`email`,`enable`,`origin_setting`) values 
(1,'2025-06-23 17:31:38.202','2025-06-25 11:45:05.230',NULL,'f9ec711a-14bc-4f4c-a00d-8c24cf0669e9','admin','$2a$10$sbi/DzbSigvsdtYO8eHCxu7lcl0Ohbbnn41QreQyvgge84deWrKoe','超管','https://qmplusimg.henrongyi.top/gva_header.jpg',888,'17611111111','333333333@qq.com',1,NULL),
(2,'2025-06-23 17:31:38.202','2025-06-23 17:31:38.823',NULL,'0d817546-baa5-4c49-874e-47fec604c267','a303176530','$2a$10$gXXERRz0JImv9bsgMunvwO1rYwdvWjpnVHXuk4xVUG/Xm4f9i3SRi','用户1','https:///qmplusimg.henrongyi.top/1572075907logo.png',9528,'17611111111','333333333@qq.com',1,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
