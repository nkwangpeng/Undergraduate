/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 80018
Source Host           : localhost:3306
Source Database       : ourteam

Target Server Type    : MYSQL
Target Server Version : 80018
File Encoding         : 65001

Date: 2020-06-13 21:18:02
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `admin`
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `auth_key` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password_reset_token` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `status` smallint(6) NOT NULL DEFAULT '10',
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  `verification_token` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `password_reset_token` (`password_reset_token`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('39', 'wp', 'IPp6ueA5GyLD-52C8Qy2C0rKt7UBPlOL', '$2y$13$YSNzk3/D61B56MuKsftk0uZ8WEcCOsqnQBqJRqehmah6vAYyadira', '', '1527974107@qq.com', '10', '1589258672', '1589258672', '');

-- ----------------------------
-- Table structure for `article`
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` varchar(1023) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('1', '测试文章2', '测试');
INSERT INTO `article` VALUES ('2', '截止至5月31日10时，国内疫情最新进展', '新冠病毒疫情在国内的发展趋势已经逐渐明朗，很多小伙伴都会关注每日的疫情统计更新数据，从最新数据可以看出，国内的疫情趋势进一步好转，在确诊患者当中，大部分都是境外输入患者，或者是无症状感染者。钟院士表示，新冠病毒疫情在国内发生二次爆发的概率几乎为零，虽然世界范围内的病毒疫情发展仍然非常迅猛，但是由于我国针对港口以及机场的防控和封锁措施都非常严格，所以普通民众有非常大的信心和把握，病毒疫情在接下来的一段时间内会逐渐从我国被根除。 ');
INSERT INTO `article` VALUES ('3', '武汉大学：6月8日起毕业生可分批次返校 ', '人民网武汉6月2日电 武汉大学1日晚间发布通报称，现居境内的毕业生和有科研任务的研究生，按照错时错峰、自愿申请原则，自6月8日起可分批次返校。 按照武汉大学新冠肺炎疫情防控指挥部的返校要求，武大毕业生在6月8日-11日、6月14日-17日两个时间段内分批返校，各学院、系（培养单位）会将返校须知、返校流程及相关要求提前告知毕业生。 有科研任务的研究生自6月8日起可以向所在学院、系（培养单位）提交申请，经批准后方可返校。 此外，其他非毕业年级的学生、尚在境外的学生暂不返校，具体返校时间另行通知。');

-- ----------------------------
-- Table structure for `auth_assignment`
-- ----------------------------
DROP TABLE IF EXISTS `auth_assignment`;
CREATE TABLE `auth_assignment` (
  `item_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`item_name`,`user_id`),
  KEY `auth_assignment_user_id_idx` (`user_id`),
  CONSTRAINT `auth_assignment_ibfk_1` FOREIGN KEY (`item_name`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auth_assignment
-- ----------------------------
INSERT INTO `auth_assignment` VALUES ('修改辟谣权限', '39', '1592032418');
INSERT INTO `auth_assignment` VALUES ('删除辟谣权限', '39', '1592032421');
INSERT INTO `auth_assignment` VALUES ('所有辟谣权限', '39', '1592032402');
INSERT INTO `auth_assignment` VALUES ('新增辟谣权限', '39', '1592032423');
INSERT INTO `auth_assignment` VALUES ('查看辟谣权限', '39', '1592032425');
INSERT INTO `auth_assignment` VALUES ('管理员', '39', '1589365421');
INSERT INTO `auth_assignment` VALUES ('管理员', '40', '1589365438');

-- ----------------------------
-- Table structure for `auth_item`
-- ----------------------------
DROP TABLE IF EXISTS `auth_item`;
CREATE TABLE `auth_item` (
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` smallint(6) NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `rule_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data` blob,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `rule_name` (`rule_name`),
  KEY `type` (`type`),
  CONSTRAINT `auth_item_ibfk_1` FOREIGN KEY (`rule_name`) REFERENCES `auth_rule` (`name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auth_item
-- ----------------------------
INSERT INTO `auth_item` VALUES ('/admin/*', '2', null, null, null, '1590585235', '1590585235');
INSERT INTO `auth_item` VALUES ('/article/*', '2', null, null, null, '1591262554', '1591262554');
INSERT INTO `auth_item` VALUES ('/article/create', '2', null, null, null, '1591262554', '1591262554');
INSERT INTO `auth_item` VALUES ('/article/delete', '2', null, null, null, '1591262554', '1591262554');
INSERT INTO `auth_item` VALUES ('/article/index', '2', null, null, null, '1591262554', '1591262554');
INSERT INTO `auth_item` VALUES ('/article/update', '2', null, null, null, '1591262554', '1591262554');
INSERT INTO `auth_item` VALUES ('/article/view', '2', null, null, null, '1591262554', '1591262554');
INSERT INTO `auth_item` VALUES ('/homework/*', '2', null, null, null, '1592044307', '1592044307');
INSERT INTO `auth_item` VALUES ('/knowledge/*', '2', null, null, null, '1592049964', '1592049964');
INSERT INTO `auth_item` VALUES ('/news/*', '2', null, null, null, '1592044315', '1592044315');
INSERT INTO `auth_item` VALUES ('/rumour/*', '2', null, null, null, '1592030923', '1592030923');
INSERT INTO `auth_item` VALUES ('/rumour/create', '2', null, null, null, '1592030931', '1592030931');
INSERT INTO `auth_item` VALUES ('/rumour/delete', '2', null, null, null, '1592030939', '1592030939');
INSERT INTO `auth_item` VALUES ('/rumour/index', '2', null, null, null, '1592030949', '1592030949');
INSERT INTO `auth_item` VALUES ('/rumour/update', '2', null, null, null, '1592030954', '1592030954');
INSERT INTO `auth_item` VALUES ('/rumour/view', '2', null, null, null, '1592030959', '1592030959');
INSERT INTO `auth_item` VALUES ('/wish/*', '2', null, null, null, '1589364939', '1589364939');
INSERT INTO `auth_item` VALUES ('/wish/create', '2', null, null, null, '1589364926', '1589364926');
INSERT INTO `auth_item` VALUES ('/wish/delete', '2', null, null, null, '1589364931', '1589364931');
INSERT INTO `auth_item` VALUES ('/wish/index', '2', null, null, null, '1589364918', '1589364918');
INSERT INTO `auth_item` VALUES ('/wish/update', '2', null, null, null, '1589364934', '1589364934');
INSERT INTO `auth_item` VALUES ('/wish/view', '2', null, null, null, '1589364921', '1589364921');
INSERT INTO `auth_item` VALUES ('一般用户', '1', '新增和查看权限', null, null, '1589365493', '1589365493');
INSERT INTO `auth_item` VALUES ('修改留言权限', '2', 'Wishes表数据的修改权限', null, null, '1589365026', '1589365078');
INSERT INTO `auth_item` VALUES ('修改辟谣权限', '2', 'Rumour表数据的修改权限', null, null, '1589365149', '1589365149');
INSERT INTO `auth_item` VALUES ('删除留言权限', '2', 'Wishes表数据的删除权限', null, null, '1589365238', '1589365238');
INSERT INTO `auth_item` VALUES ('删除辟谣权限', '2', 'Rumour表数据的删除权限', null, null, '1589365149', '1589365149');
INSERT INTO `auth_item` VALUES ('所有留言权限', '2', 'Wishes表数据的所有权限', null, null, '1589365351', '1589365351');
INSERT INTO `auth_item` VALUES ('所有辟谣权限', '2', 'Rumour表数据的所有权限', null, null, '1589365149', '1589365149');
INSERT INTO `auth_item` VALUES ('新增留言权限', '2', 'Wishes表数据的新增权限', null, null, '1589365218', '1589365218');
INSERT INTO `auth_item` VALUES ('新增辟谣权限', '2', 'Rumour表数据的所有权限', null, null, '1589365149', '1589365149');
INSERT INTO `auth_item` VALUES ('未登录用户', '1', null, null, null, '1589365522', '1589365522');
INSERT INTO `auth_item` VALUES ('查看留言权限', '2', 'Wishes表数据的查看权限', null, null, '1589365257', '1589365257');
INSERT INTO `auth_item` VALUES ('查看辟谣权限', '2', 'Rumour表数据的所有权限', null, null, '1589365149', '1589365149');
INSERT INTO `auth_item` VALUES ('管理员', '1', '系统管理员，拥有系统一切权限', null, null, '1589365149', '1589365149');

-- ----------------------------
-- Table structure for `auth_item_child`
-- ----------------------------
DROP TABLE IF EXISTS `auth_item_child`;
CREATE TABLE `auth_item_child` (
  `parent` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `child` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `child` (`child`),
  CONSTRAINT `auth_item_child_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `auth_item_child_ibfk_2` FOREIGN KEY (`child`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auth_item_child
-- ----------------------------
INSERT INTO `auth_item_child` VALUES ('管理员', '/admin/*');
INSERT INTO `auth_item_child` VALUES ('管理员', '/article/*');
INSERT INTO `auth_item_child` VALUES ('管理员', '/article/create');
INSERT INTO `auth_item_child` VALUES ('管理员', '/article/delete');
INSERT INTO `auth_item_child` VALUES ('管理员', '/article/index');
INSERT INTO `auth_item_child` VALUES ('管理员', '/article/update');
INSERT INTO `auth_item_child` VALUES ('管理员', '/article/view');
INSERT INTO `auth_item_child` VALUES ('管理员', '/homework/*');
INSERT INTO `auth_item_child` VALUES ('管理员', '/knowledge/*');
INSERT INTO `auth_item_child` VALUES ('管理员', '/news/*');
INSERT INTO `auth_item_child` VALUES ('所有辟谣权限', '/rumour/*');
INSERT INTO `auth_item_child` VALUES ('新增辟谣权限', '/rumour/create');
INSERT INTO `auth_item_child` VALUES ('删除辟谣权限', '/rumour/delete');
INSERT INTO `auth_item_child` VALUES ('修改辟谣权限', '/rumour/update');
INSERT INTO `auth_item_child` VALUES ('查看辟谣权限', '/rumour/view');
INSERT INTO `auth_item_child` VALUES ('所有留言权限', '/wish/*');
INSERT INTO `auth_item_child` VALUES ('所有留言权限', '/wish/create');
INSERT INTO `auth_item_child` VALUES ('新增留言权限', '/wish/create');
INSERT INTO `auth_item_child` VALUES ('删除留言权限', '/wish/delete');
INSERT INTO `auth_item_child` VALUES ('所有留言权限', '/wish/delete');
INSERT INTO `auth_item_child` VALUES ('所有留言权限', '/wish/index');
INSERT INTO `auth_item_child` VALUES ('未登录用户', '/wish/index');
INSERT INTO `auth_item_child` VALUES ('修改留言权限', '/wish/update');
INSERT INTO `auth_item_child` VALUES ('所有留言权限', '/wish/update');
INSERT INTO `auth_item_child` VALUES ('所有留言权限', '/wish/view');
INSERT INTO `auth_item_child` VALUES ('查看留言权限', '/wish/view');
INSERT INTO `auth_item_child` VALUES ('管理员', '修改留言权限');
INSERT INTO `auth_item_child` VALUES ('管理员', '删除留言权限');
INSERT INTO `auth_item_child` VALUES ('管理员', '所有留言权限');
INSERT INTO `auth_item_child` VALUES ('一般用户', '新增留言权限');
INSERT INTO `auth_item_child` VALUES ('管理员', '新增留言权限');
INSERT INTO `auth_item_child` VALUES ('一般用户', '查看留言权限');
INSERT INTO `auth_item_child` VALUES ('管理员', '查看留言权限');

-- ----------------------------
-- Table structure for `auth_rule`
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule`;
CREATE TABLE `auth_rule` (
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `data` blob,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of auth_rule
-- ----------------------------

-- ----------------------------
-- Table structure for `china`
-- ----------------------------
DROP TABLE IF EXISTS `china`;
CREATE TABLE `china` (
  `province` char(255) NOT NULL,
  `diagnosis` int(11) NOT NULL,
  `totaldiagnosis` int(11) NOT NULL,
  PRIMARY KEY (`province`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of china
-- ----------------------------
INSERT INTO `china` VALUES ('上海', '16', '689');
INSERT INTO `china` VALUES ('云南', '0', '185');
INSERT INTO `china` VALUES ('内蒙古', '5', '237');
INSERT INTO `china` VALUES ('北京', '4', '597');
INSERT INTO `china` VALUES ('南海诸岛', '0', '0');
INSERT INTO `china` VALUES ('台湾', '5', '443');
INSERT INTO `china` VALUES ('吉林', '0', '155');
INSERT INTO `china` VALUES ('四川', '18', '582');
INSERT INTO `china` VALUES ('天津', '4', '196');
INSERT INTO `china` VALUES ('宁夏', '0', '75');
INSERT INTO `china` VALUES ('安徽', '0', '991');
INSERT INTO `china` VALUES ('山东', '4', '792');
INSERT INTO `china` VALUES ('山西', '0', '198');
INSERT INTO `china` VALUES ('广东', '10', '1607');
INSERT INTO `china` VALUES ('广西', '0', '254');
INSERT INTO `china` VALUES ('新疆', '0', '76');
INSERT INTO `china` VALUES ('江苏', '0', '653');
INSERT INTO `china` VALUES ('江西', '0', '932');
INSERT INTO `china` VALUES ('河北', '0', '328');
INSERT INTO `china` VALUES ('河南', '0', '1276');
INSERT INTO `china` VALUES ('浙江', '0', '1268');
INSERT INTO `china` VALUES ('海南', '1', '169');
INSERT INTO `china` VALUES ('湖北', '0', '68135');
INSERT INTO `china` VALUES ('湖南', '0', '1019');
INSERT INTO `china` VALUES ('澳门', '0', '45');
INSERT INTO `china` VALUES ('甘肃', '0', '139');
INSERT INTO `china` VALUES ('福建', '4', '361');
INSERT INTO `china` VALUES ('西藏', '0', '1');
INSERT INTO `china` VALUES ('贵州', '0', '147');
INSERT INTO `china` VALUES ('辽宁', '0', '149');
INSERT INTO `china` VALUES ('重庆', '0', '579');
INSERT INTO `china` VALUES ('陕西', '2', '311');
INSERT INTO `china` VALUES ('青海', '0', '18');
INSERT INTO `china` VALUES ('香港', '49', '1108');
INSERT INTO `china` VALUES ('黑龙江', '0', '947');

-- ----------------------------
-- Table structure for `current`
-- ----------------------------
DROP TABLE IF EXISTS `current`;
CREATE TABLE `current` (
  `currentConfirmedCount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `seriousCount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `suspectedCount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `confirmedCount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `deadCount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `curedCount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of current
-- ----------------------------
INSERT INTO `current` VALUES ('123', '98', '1808', '84672', '4645', '79904', '1');

-- ----------------------------
-- Table structure for `knowledge`
-- ----------------------------
DROP TABLE IF EXISTS `knowledge`;
CREATE TABLE `knowledge` (
  `question` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  PRIMARY KEY (`question`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of knowledge
-- ----------------------------
INSERT INTO `knowledge` VALUES ('什么是新型冠状病毒？', '此次流行的冠状病毒为一种新发现的冠状病毒，国际病毒分类委员会命名为 SARS-Cov-2。因为人群缺少对新型病毒株的免疫力，所以人群普遍易感。');
INSERT INTO `knowledge` VALUES ('冠状病毒的致病性如何？', '冠状病毒主要感染成人或较大儿童，引起普通感冒和咽喉炎，某些毒株还可引起成人腹泻。病毒经飞沫传播，粪口途径亦可以传播。主要在冬春季流行。病毒的潜伏期平均 3～7 天。');
INSERT INTO `knowledge` VALUES ('哪些野生动物会携带冠状病毒？', '很多野生动物都可能携带病原体，进而成为传播源。果子狸、蝙蝠、竹鼠、獾等是冠状病毒的常见宿主。');
INSERT INTO `knowledge` VALUES ('新型冠状病毒与 SARS 病毒的区别是什么？', '新型冠状病毒与 SARS 病毒、MERS 病毒同属于冠状病毒这个大家族，是「兄弟姐妹」，基因序列有很多一样的地方，但不完全相同。传染性与 SARS 相比有待确定，致死率按照目前来看较 SARS 较低，但是不排除病毒变异的可能。');
INSERT INTO `knowledge` VALUES ('新型冠状病毒肺炎由什么引起的？', '由 SARS-Cov-2 冠状病毒引起，WHO 将 SARS-Cov-2 感染导致的疾病命名为 COVID-19，其中多数感染可以导致肺炎，就称之为新型冠状病毒肺炎/新冠肺炎。');

-- ----------------------------
-- Table structure for `menu`
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `parent` int(11) DEFAULT NULL,
  `route` varchar(256) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `parent` (`parent`),
  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `menu` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of menu
-- ----------------------------

-- ----------------------------
-- Table structure for `migration`
-- ----------------------------
DROP TABLE IF EXISTS `migration`;
CREATE TABLE `migration` (
  `version` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `apply_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of migration
-- ----------------------------
INSERT INTO `migration` VALUES ('m000000_000000_base', '1587195270');
INSERT INTO `migration` VALUES ('m130524_201442_init', '1587195273');
INSERT INTO `migration` VALUES ('m190124_110200_add_verification_token_column_to_user_table', '1587195273');

-- ----------------------------
-- Table structure for `news`
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `topic` varchar(255) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`topic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of news
-- ----------------------------
INSERT INTO `news` VALUES ('北京新增病例的两名家庭密接人员核酸检测阴性 体温正常', '12日从北京市西城区卫生健康委获悉，6月11日新增确诊病例唐某某的两名家庭密切接触者，现均已集中隔离进行医学观察。两人核酸检测均为阴性，血清学抗体均为阴性，目前体温正常，身体无其他不适。两名家庭密切接触者之一为西城区某小学四年级学生。\r\n\r\n　　据了解，该小学向该校家长发布了相关工作情况说明，并表示区教委与学校立即启动应急处置预案，安排唐某某孩子所在班级其他33名学生以及与该班有过接触的15名教职员工全部居家观察。班主任对学生进行心理安抚，教师开展线上教学，确保学生正常学习。同时，学校立即将与唐某某孩子所在班级同楼层的两个班学生转移到备用教室。对教室、卫生间等公共区域和转移路线所涉及区域进行全面消毒。');
INSERT INTO `news` VALUES ('墨西哥新增4790例新冠肺炎确诊病例 累计超13万例', '当地时间6月11日，墨西哥卫生部宣布，截至当日晚上7点，墨西哥全国确诊133974例新冠肺炎病例，较前一天新增了4790例。同时，墨西哥全国确诊死亡病例较前一天新增587例，总数已经上升到15944例');
INSERT INTO `news` VALUES ('天津12日通报：新增1例境外输入新冠肺炎确诊病例', '6月12日6时至11时30分，天津新增境外输入新冠肺炎确诊病例1例（中国籍），累计报告境外输入确诊病例60例（中国籍56例、美国籍2例、法国籍1例、菲律宾籍1例），治愈出院56例，在院4例（其中轻型3例、普通型1例）。\r\n\r\n第60例境外输入确诊病例，男，32岁，私营企业务工人员，中国籍，近期居住地塞尔维亚贝尔格莱德。自塞尔维亚贝尔格莱德乘坐航班（JU045），于6月11日抵达天津滨海国际机场。入境时体温36.5℃，申报有干咳、咽痛症状；经海关检疫排查采样后，即由120急救转送至空港医院发热门诊；12日，鼻、咽拭子核酸检测结果显示为阳性。经市专家组确诊为天津境外输入确诊病例，分型为轻型；现已转往海河医院，有关流行病学调查正在进行中。全程实施闭环管理。');
INSERT INTO `news` VALUES ('疫情恢复计划通过 古巴将逐步恢复生产和社会经济活动', '古共中央政治局本周召开特别会议讨论并通过了古巴疫情恢复计划，会议决定，古巴将分三个阶段逐步恢复生产和社会经济活动。当地时间6月11日，古巴国家主席迪亚斯-卡内尔和总理曼努埃尔•马雷罗在古巴国家电视台《圆桌》节目中介绍了各恢复阶段即将实施的相关措施。\r\n迪亚斯-卡内尔表示，古巴绝大部分城市近一个月以来未出现新冠肺炎确诊病例，全国新增确诊病例人数日益减少，因此决定进入疫情恢复阶段');

-- ----------------------------
-- Table structure for `rumour`
-- ----------------------------
DROP TABLE IF EXISTS `rumour`;
CREATE TABLE `rumour` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `info` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '简介',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '内容',
  `created_at` int(11) NOT NULL COMMENT '创建时间',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8 COMMENT='辟谣';

-- ----------------------------
-- Records of rumour
-- ----------------------------
INSERT INTO `rumour` VALUES ('49', '今天下午我发了一篇文章，《杀人放火金腰带，修桥补路无尸骸》，写了一个普通患者怎么看待杨文医生的死，并建议了怎么保全李文周文王文医生的生。', '是的，这是续集。我开始写连载了。\r\n\r\n\r\n（一）脑子是个好东西\r\n\r\n\r\n今天下午我发了一篇文章，《杀人放火金腰带，修桥补路无尸骸》，写了一个普通患者怎么看待杨文医生的死，并建议了怎么保全李文周文王文医生的生。\r\n\r\n\r\n写这篇文章的初衷，是因为我看到了《杀人者孙文斌是谁？》写到杀人者之母孙某氏已经享受了专家会诊和减免治疗费用的优待。出离愤怒。\r\n\r\n\r\n收到了很多医护人员的感谢，她们说，只看到医疗从业人员在奔走，患者的理解和支持，真的太珍贵。几乎所有医院都禁止医护人员在朋友圈、微博转发任何关于杨文被杀事件的相关报道和评论，并希望她们大爱无疆，正常上班。\r\n\r\n\r\n虽然出事之后，她们每天都像在上坟。\r\n\r\n\r\n下午17：53分，央视新闻发了一个59秒的视频，标题是《独家辟谣丨杀医者家属自行办理转院没有免费医疗》，然后迅速串上了热搜，舆论开始倒向严惩造谣者，甚至还有人给我发微信，质疑我传谣，质问我为什么没有调查清楚就写战斗檄文。\r\n\r\n\r\n对此我只想说，\r\n\r\n\r\n脑子是个好东西，但愿你也有！\r\n\r\n\r\n（二）视频的主角是谁？\r\n\r\n\r\n“长期关注医患关系的全国政协委员、著名神经外科专家凌峰”，视频所配的算上标点符号只有100多字的短讯，居然有长达25个字的title，真的吓坏我了。真的，一般越长，官越大。\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n为了怕有人说我又不调查就传谣，我还专门去查了这个凌医生的资料，她是宣武医院的专家，做过神经外科的主任，不知道现在还做不做了，因为有的资料写的是“前blablabla主任”。\r\n\r\n\r\n我还认真看了几遍视频，她带着党徽，白大褂干净笔挺，上面用英文印着自己的名字，没有中文。\r\n\r\n\r\n她在视频中的说的是，“实际上我也去了解了一下，我觉得，呃，后来我所得到的一些情况，呃，不是政府去组织的一个VVIP的会诊啊或者免费啊，完全不是，是老太太自己出院了，自己打了999，完了自己要求去的朝阳医院，是999把她送到朝阳医院急诊，朝阳医院接收病人，这是他们的天经地义的责任。所以他按照病情，交了押金，签了所有的字，然后去住院的。”\r\n\r\n\r\n我有一个疑问，这么大的事，既然要辟谣，既然是央视这个级别的官媒“独家辟谣”，辟朝阳医院内科的谣，为什么要从宣武医院神外抓个政协委员来？\r\n\r\n\r\n二手的消息香吗？\r\n\r\n\r\n还是专家太闲了？居然第一时间就去了朝阳医院。而且我观察了一下她的采访背景，这个背景在她其他的照片上出现过，应该是她自己的办公室。\r\n\r\n\r\n视频里没有说她是打电话还是亲自去的宣武医院，但是配的文字短讯写了明晃晃的四个大字“实地走访”。\r\n\r\n\r\n我想和大家说一下，我们所在地方叫北京，北京很大，很堵，从宣武医院到朝阳医院，即使走距离最近的长安街，也有13公里。\r\n\r\n\r\n就不要说还要找到“官方”，官方是谁？怎么着也得是个领导吧？还得回到宣武医院，还要接受央视的采访。那采访是谁主动联系谁的？我只想说效率好高啊。\r\n\r\n\r\n我的问题是不是太多了？反正，《杀人者孙文斌是谁？》是今天早上8:55才发出来的，中午才疯传起来的。\r\n\r\n\r\n另外我还想提醒央视新闻一下，新闻做的太仓促了，“凌峰”的峰字写错了，应该是锋。\r\n\r\n\r\n（三）到底有没有会诊？\r\n\r\n\r\n凌医生说，“不是政府去组织的一个VVIP的会诊啊或者免费啊”，是不是说，确实有会诊，但不是政府组织的。我理解的没错吧？大家可以反复看视频，看她说话的口吻。\r\n\r\n\r\n那么问题来了，不是政府组织的，是谁组织的？\r\n\r\n\r\n是患者家属吗？\r\n\r\n\r\n肯定不是了。患者家属要是有能量干这个，就不用杀人了。\r\n\r\n\r\n是被割头的杨文医生的同事自发的义诊吗？\r\n\r\n\r\n那肯定是他们看了这个比悲伤更悲伤的故事后，受了刺激，集体疯了。\r\n\r\n\r\n所以，到底是谁组织了会诊？\r\n\r\n\r\n我猜可能就是禁止医护人员接受采访，禁止医护人员转发朋友圈和微博，并且在杨文的追悼会上“对事件发生以来民航总医院全体医护人员坚守岗位、履职尽责、发扬人道主义精神的职业操守与作为表示充分肯定和深切敬意，希望全体医护人员继续维护医院正常工作秩序，坚守工作岗位，护佑人民健康”的那些人组织的吧。\r\n\r\n\r\n我猜的。不要告我传谣，我真的只是猜的。\r\n\r\n\r\n（四）到底有没有减免治疗费用？\r\n\r\n\r\n或者，我换个直白点的说法，孙文斌杀人，到底获利了没有？\r\n\r\n\r\n根据今天网上各种患者、媒体、医疗从业者的说法，可以互相印证的是，到了年底，卫健委分给每个医院的医保额度都会很紧张，所以医院不愿意收治像孙某氏这样的极大占用医保额度、治疗希望渺茫的高龄癌症晚期患者。\r\n\r\n', '1590041626', ' 朝阳医院央视辟谣，你真的看懂了吗……');
INSERT INTO `rumour` VALUES ('50', '今天央视315晚会在晚上8点准时开启，央视对“食物相克”理论进行了解释和辟谣。央视表示“食物相克”理论十分地热门，相关的书籍也是层出不穷，现在央视邀请食物专家对“食物相克”理论进行解释和辟谣', '\r\n今天央视315晚会在晚上8点准时开启，央视对“食物相克”理论进行了解释和辟谣。央视表示“食物相克”理论十分地热门，相关的书籍也是层出不穷，现在央视邀请食物专家对“食物相克”理论进行解释和辟谣。\r\n\r\n螃蟹跟西红柿一起吃真的会产生无机砷吗？关于西红柿与螃蟹的搭配，兰州大学做过相关实验，一百多组实验中无任何异常现象\r\n\r\n你怎么看呢？\r\n\r\n\r\n——————以下为直播内容——————\r\n\r\n\r\n很多人宁可信其有，也不可信其无，过于迷信食物相克会影响食物多样性。\r\n\r\n● 03-15 20:43\r\n\r\n图表的中国营养协会是非法机构，正确的机构是中国营养学会，所以图表根本没有公信力\r\n\r\n● 03-15 20:42\r\n\r\n关于西红柿与螃蟹的搭配，兰州大学做过相关实验，一百多组实验中无任何异常现象\r\n\r\n● 03-15 20:41\r\n\r\n实验产生的有毒的无机砷总量远远低于国家标准，并且跟西红柿无任何关系，纯属谣言\r\n\r\n\r\n\r\n● 03-15 20:38\r\n\r\n模拟胃肠环境进行实验\r\n\r\n查看可能涉及到敏感图片，点击后可查看\r\n\r\n● 03-15 20:37\r\n\r\n螃蟹跟西红柿一起吃真的会产生无机砷吗？\r\n\r\n● 03-15 20:37\r\n\r\n\r\n\r\n● 03-15 20:36\r\n\r\n请来教授现场答疑\r\n\r\n\r\n\r\n● 03-15 20:35\r\n\r\n这些传言有科学依据吗？\r\n\r\n查看可能涉及到敏感图片，点击后可查看\r\n\r\n● 03-15 20:35\r\n\r\n该类书籍销量非常好\r\n\r\n\r\n\r\n● 03-15 20:33\r\n\r\n食物相克被当作科学常识，但是真的靠谱吗？\r\n\r\n\r\n（一）脑子是个好东西\r\n\r\n\r\n今天下午我发了一篇文章，《杀人放火金腰带，修桥补路无尸骸》，写了一个普通患者怎么看待杨文医生的死，并建议了怎么保全李文周文王文医生的生。\r\n\r\n\r\n写这篇文章的初衷，是因为我看到了《杀人者孙文斌是谁？》写到杀人者之母孙某氏已经享受了专家会诊和减免治疗费用的优待。出离愤怒。\r\n\r\n\r\n收到了很多医护人员的感谢，她们说，只看到医疗从业人员在奔走，患者的理解和支持，真的太珍贵。几乎所有医院都禁止医护人员在朋友圈、微博转发任何关于杨文被杀事件的相关报道和评论，并希望她们大爱无疆，正常上班。\r\n\r\n\r\n虽然出事之后，她们每天都像在上坟。\r\n\r\n\r\n下午17：53分，央视新闻发了一个59秒的视频，标题是《独家辟谣丨杀医者家属自行办理转院没有免费医疗》，然后迅速串上了热搜，舆论开始倒向严惩造谣者，甚至还有人给我发微信，质疑我传谣，质问我为什么没有调查清楚就写战斗檄文。\r\n\r\n\r\n对此我只想说，\r\n\r\n\r\n脑子是个好东西，但愿你也有！\r\n\r\n\r\n（二）视频的主角是谁？\r\n\r\n\r\n“长期关注医患关系的全国政协委员、著名神经外科专家凌峰”，视频所配的算上标点符号只有100多字的短讯，居然有长达25个字的title，真的吓坏我了。真的，一般越长，官越大。\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n为了怕有人说我又不调查就传谣，我还专门去查了这个凌医生的资料，她是宣武医院的专家，做过神经外科的主任，不知道现在还做不做了，因为有的资料写的是“前blablabla主任”。\r\n\r\n\r\n我还认真看了几遍视频，她带着党徽，白大褂干净笔挺，上面用英文印着自己的名字，没有中文。\r\n\r\n\r\n她在视频中的说的是，“实际上我也去了解了一下，我觉得，呃，后来我所得到的一些情况，呃，不是政府去组织的一个VVIP的会诊啊或者免费啊，完全不是，是老太太自己出院了，自己打了999，完了自己要求去的朝阳医院，是999把她送到朝阳医院急诊，朝阳医院接收病人，这是他们的天经地义的责任。所以他按照病情，交了押金，签了所有的字，然后去住院的。”\r\n\r\n\r\n我有一个疑问，这么大的事，既然要辟谣，既然是央视这个级别的官媒“独家辟谣”，辟朝阳医院内科的谣，为什么要从宣武医院神外抓个政协委员来？\r\n\r\n\r\n二手的消息香吗？\r\n\r\n\r\n还是专家太闲了？居然第一时间就去了朝阳医院。而且我观察了一下她的采访背景，这个背景在她其他的照片上出现过，应该是她自己的办公室。\r\n\r\n\r\n视频里没有说她是打电话还是亲自去的宣武医院，但是配的文字短讯写了明晃晃的四个大字“实地走访”。\r\n\r\n\r\n我想和大家说一下，我们所在地方叫北京，北京很大，很堵，从宣武医院到朝阳医院，即使走距离最近的长安街，也有13公里。\r\n\r\n\r\n就不要说还要找到“官方”，官方是谁？怎么着也得是个领导吧？还得回到宣武医院，还要接受央视的采访。那采访是谁主动联系谁的？我只想说效率好高啊。\r\n\r\n\r\n我的问题是不是太多了？反正，《杀人者孙文斌是谁？》是今天早上8:55才发出来的，中午才疯传起来的。\r\n\r\n\r\n另外我还想提醒央视新闻一下，新闻做的太仓促了，“凌峰”的峰字写错了，应该是锋。\r\n\r\n\r\n（三）到底有没有会诊？\r\n\r\n\r\n凌医生说，“不是政府去组织的一个VVIP的会诊啊或者免费啊”，是不是说，确实有会诊，但不是政府组织的。我理解的没错吧？大家可以反复看视频，看她说话的口吻。\r\n\r\n\r\n那么问题来了，不是政府组织的，是谁组织的？\r\n\r\n\r\n是患者家属吗？\r\n\r\n\r\n肯定不是了。患者家属要是有能量干这个，就不用杀人了。\r\n\r\n\r\n是被割头的杨文医生的同事自发的义诊吗？\r\n\r\n\r\n那肯定是他们看了这个比悲伤更悲伤的故事后，受了刺激，集体疯了。\r\n\r\n\r\n所以，到底是谁组织了会诊？\r\n\r\n\r\n我猜可能就是禁止医护人员接受采访，禁止医护人员转发朋友圈和微博，并且在杨文的追悼会上“对事件发生以来民航总医院全体医护人员坚守岗位、履职尽责、发扬人道主义精神的职业操守与作为表示充分肯定和深切敬意，希望全体医护人员继续维护医院正常工作秩序，坚守工作岗位，护佑人民健康”的那些人组织的吧。\r\n\r\n\r\n我猜的。不要告我传谣，我真的只是猜的。\r\n\r\n\r\n（四）到底有没有减免治疗费用？\r\n\r\n\r\n或者，我换个直白点的说法，孙文斌杀人，到底获利了没有？\r\n\r\n\r\n根据今天网上各种患者、媒体、医疗从业者的说法，可以互相印证的是，到了年底，卫健委分给每个医院的医保额度都会很紧张，所以医院不愿意收治像孙某氏这样的极大占用医保额度、治疗希望渺茫的高龄癌症晚期患者。\r\n\r\n', '1590041626', '315 晚会在直播辟谣食物相克了，你怎么看？');
INSERT INTO `rumour` VALUES ('51', '钟南山院士团队辟谣：漱口没有办法清洁呼吸道钟南山院士团队公开辟谣：「盐水漱口有利于清洁口腔和咽喉，对于咽喉炎有帮助。但是新型冠状病毒侵犯的部位在呼吸道，漱口没有办法清洁呼吸道。其次，目前尚无任何研究', '以下内容来自「丁香医生」www.dxy.com\r\n钟南山院士团队辟谣：漱口没有办法清洁呼吸道\r\n\r\n钟南山院士团队公开辟谣：\r\n\r\n「盐水漱口有利于清洁口腔和咽喉，对于咽喉炎有帮助。但是新型冠状病毒侵犯的部位在呼吸道，漱口没有办法清洁呼吸道。其次，目前尚无任何研究结果提示盐水对新型冠状病毒有杀灭作用。」\r\n\r\n\r\n\r\n\r\n\r\n作者：丁香医生 ，未经许可请勿转载。查看原文：https://dxy.com/column/27304?keywords=%E8%BE%9F%E8%B0%A3', '1590041626', '辟谣︳盐水漱口能预防感染？');
INSERT INTO `rumour` VALUES ('52', '丁香医生团队辟谣：看情况，不是所有的家庭都需要每天消毒如果家中没有外人到访，也没有自我隔离的疑似症状者，无需每天消毒。常通风、勤洗手，做好清洁就行，消毒剂不要滥用。如果曾乘坐公交车、地铁、出租', '以下内容来自「丁香医生」www.dxy.com\r\n李兰娟院士辟谣：日常不用戴手套\r\n\r\n李兰娟院士表示：不在医院，只是日常外出，不用专门戴手套。关键是要勤洗手，养成洗手、在外面不用手抠鼻子、揉眼睛的好习惯。\r\n\r\n作者：丁香医生 ，未经许可请勿转载。查看原文：https://dxy.com/column/27464?keywords=%E8%BE%9F%E8%B0%A3', '1590041626', '辟谣︳居家每天都要消毒？');
INSERT INTO `rumour` VALUES ('53', '丁香医生团队辟谣：普通人出门没必要戴护目镜是针对一线临床医生的，普通人出门不需要佩戴护目镜。但大家都要注意，不要揉眼睛，因为手可能接触到病毒，再接触到眼睛会导致结膜感染。', '以下内容来自「丁香医生」www.dxy.com\r\n丁香医生团队辟谣：普通人出门没必要戴\r\n\r\n护目镜是针对一线临床医生的，普通人出门不需要佩戴护目镜。\r\n\r\n但大家都要注意，不要揉眼睛，因为手可能接触到病毒，再接触到眼睛会导致结膜感染。\r\n\r\n\r\n\r\n\r\n\r\n作者：丁香医生 ，未经许可请勿转载。查看原文：https://dxy.com/column/27324?keywords=%E8%BE%9F%E8%B0%A3', '1590041626', '辟谣︳出门要戴护目镜?');

-- ----------------------------
-- Table structure for `tendency`
-- ----------------------------
DROP TABLE IF EXISTS `tendency`;
CREATE TABLE `tendency` (
  `日期` date DEFAULT NULL,
  `累计确诊` int(11) DEFAULT NULL,
  `现有确诊(含重症)` int(11) DEFAULT NULL,
  `现有疑似` int(11) DEFAULT NULL,
  `现有重症` int(11) DEFAULT NULL,
  `累计死亡` int(11) DEFAULT NULL,
  `累计治愈` int(11) DEFAULT NULL,
  `累计确诊+现有疑似` int(11) DEFAULT NULL,
  `新增确诊` int(11) DEFAULT NULL,
  `新增疑似` int(11) DEFAULT NULL,
  `新增(疑似+确诊)` int(11) DEFAULT NULL,
  `死亡/确诊` float(11,0) DEFAULT NULL,
  `观察中` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tendency
-- ----------------------------
INSERT INTO `tendency` VALUES ('2020-01-20', '291', null, '54', null, '6', '25', '345', '77', '27', '104', '2', '922');
INSERT INTO `tendency` VALUES ('2020-01-21', '440', null, '37', '102', '9', '28', '477', '149', '26', '175', '2', '1394');
INSERT INTO `tendency` VALUES ('2020-01-22', '571', null, '393', '95', '17', '49', '964', '131', '257', '388', '3', '4928');
INSERT INTO `tendency` VALUES ('2020-01-23', '830', null, '1072', '177', '25', '34', '1902', '259', '680', '939', '3', '8420');
INSERT INTO `tendency` VALUES ('2020-01-24', '1287', null, '1965', '237', '41', '38', '3252', '444', '1118', '1562', '3', '13967');
INSERT INTO `tendency` VALUES ('2020-01-25', '1975', null, '2684', '324', '56', '49', '4659', '688', '1309', '1997', '3', '21556');
INSERT INTO `tendency` VALUES ('2020-01-26', '2744', null, '5794', '461', '80', '51', '8538', '769', '3806', '4575', '3', '30453');
INSERT INTO `tendency` VALUES ('2020-01-27', '4515', null, '6973', '976', '106', '60', '11488', '1771', '2077', '3848', '2', '44132');
INSERT INTO `tendency` VALUES ('2020-01-28', '5974', null, '9239', '1239', '132', '103', '15213', '1459', '3248', '4707', '2', '59990');
INSERT INTO `tendency` VALUES ('2020-01-29', '7711', null, '12167', '1370', '170', '124', '19878', '1737', '4148', '5885', '2', '81947');
INSERT INTO `tendency` VALUES ('2020-01-30', '9692', null, '15238', '1527', '213', '171', '24930', '1982', '4812', '6794', '2', '102427');
INSERT INTO `tendency` VALUES ('2020-01-31', '11791', null, '17988', '1795', '259', '243', '29779', '2102', '5019', '7121', '2', '118478');
INSERT INTO `tendency` VALUES ('2020-02-01', '14380', null, '19544', '2110', '304', '328', '33924', '2590', '4562', '7152', '2', '137594');
INSERT INTO `tendency` VALUES ('2020-02-02', '17205', null, '21558', '2296', '361', '475', '38763', '2829', '5173', '8002', '2', '152700');
INSERT INTO `tendency` VALUES ('2020-02-03', '20438', null, '23214', '2788', '425', '632', '43652', '3235', '5072', '8307', '2', '171329');
INSERT INTO `tendency` VALUES ('2020-02-04', '24324', null, '23260', '3219', '490', '892', '47584', '3887', '3971', '7858', '2', '185555');
INSERT INTO `tendency` VALUES ('2020-02-05', '28018', null, '24702', '3859', '563', '1153', '52720', '3694', '5328', '9022', '2', '186354');
INSERT INTO `tendency` VALUES ('2020-02-06', '31161', '28985', '26359', '4821', '636', '1540', '57520', '3143', '4833', '7976', '2', '186045');
INSERT INTO `tendency` VALUES ('2020-02-07', '34546', '31774', '27657', '6101', '722', '2050', '62203', '3399', '4214', '7613', '2', '189660');
INSERT INTO `tendency` VALUES ('2020-02-08', '37198', '33738', '28942', '6188', '811', '2649', '66140', '2656', '3916', '6572', '2', '188183');
INSERT INTO `tendency` VALUES ('2020-02-09', '40171', '35982', '23589', '6484', '908', '3281', '63760', '3062', '4008', '7070', '2', '187518');
INSERT INTO `tendency` VALUES ('2020-02-10', '42638', '37626', '21675', '7333', '1016', '3996', '64313', '2478', '3536', '6014', '2', '187728');
INSERT INTO `tendency` VALUES ('2020-02-11', '44653', '38800', '16067', '8204', '1113', '4740', '60720', '2015', '3342', '5357', '2', '185037');
INSERT INTO `tendency` VALUES ('2020-02-12', '59804', '52526', '13435', '8030', '1367', '5911', '73239', '15152', '2807', '17959', '2', '181386');
INSERT INTO `tendency` VALUES ('2020-02-13', '63851', '55748', '10109', '10204', '1380', '6723', '73960', '5090', '2450', '7540', '2', '177984');
INSERT INTO `tendency` VALUES ('2020-02-14', '66492', '56873', '8969', '11053', '1523', '8096', '75461', '2641', '2277', '4918', '2', '169039');
INSERT INTO `tendency` VALUES ('2020-02-15', '68500', '57416', '8228', '11272', '1665', '9419', '76728', '2009', '1918', '3927', '2', '158764');
INSERT INTO `tendency` VALUES ('2020-02-16', '70548', '57934', '7264', '10644', '1770', '10844', '77812', '2048', '1563', '3611', '3', '150539');
INSERT INTO `tendency` VALUES ('2020-02-17', '72436', '58016', '6242', '11741', '1868', '12552', '78678', '1886', '1432', '3318', '3', '141552');
INSERT INTO `tendency` VALUES ('2020-02-18', '74185', '57805', '5248', '11977', '2004', '14376', '79433', '1749', '1185', '2934', '3', '135881');
INSERT INTO `tendency` VALUES ('2020-02-19', '74576', '56303', '4922', '11864', '2118', '16155', '79498', '394', '1277', '1671', '3', '126363');
INSERT INTO `tendency` VALUES ('2020-02-20', '75465', '54965', '5206', '11633', '2236', '18264', '80671', '889', '1614', '2503', '3', '120302');
INSERT INTO `tendency` VALUES ('2020-02-21', '76288', '53284', '5365', '11477', '2345', '20659', '81653', '397', '1361', '1758', '3', '113564');
INSERT INTO `tendency` VALUES ('2020-02-22', '76936', '51606', '4148', '10968', '2442', '22888', '81084', '648', '882', '1530', '3', '106089');
INSERT INTO `tendency` VALUES ('2020-02-23', '77150', '49824', '3434', '9915', '2592', '24734', '80584', '409', '620', '1029', '3', '97481');
INSERT INTO `tendency` VALUES ('2020-02-24', '77658', '47672', '2824', '9126', '2663', '27323', '80482', '508', '530', '1038', '3', '87902');
INSERT INTO `tendency` VALUES ('2020-02-25', '78064', '45604', '2491', '8752', '2715', '29745', '80555', '406', '439', '845', '3', '79108');
INSERT INTO `tendency` VALUES ('2020-02-26', '78497', '43258', '2358', '8346', '2744', '32495', '80855', '433', '508', '941', '3', '71572');
INSERT INTO `tendency` VALUES ('2020-02-27', '78824', '39919', '2308', '7952', '2788', '36117', '81132', '327', '452', '779', '4', '65225');
INSERT INTO `tendency` VALUES ('2020-02-28', '79251', '37414', '1418', '7664', '2835', '39002', '80669', '427', '248', '675', '4', '58233');
INSERT INTO `tendency` VALUES ('2020-02-29', '79824', '35329', '851', '7365', '2870', '41625', '80675', '573', '132', '705', '4', '51856');
INSERT INTO `tendency` VALUES ('2020-03-01', '80026', '32652', '715', '7110', '2912', '44462', '80741', '202', '141', '343', '4', '46219');
INSERT INTO `tendency` VALUES ('2020-03-02', '80151', '30004', '587', '6806', '2943', '47204', '80738', '125', '129', '254', '4', '40651');
INSERT INTO `tendency` VALUES ('2020-03-03', '80270', '27433', '520', '6416', '2981', '49856', '80790', '119', '143', '262', '4', '36432');
INSERT INTO `tendency` VALUES ('2020-03-04', '80409', '25352', '522', '5952', '3012', '52045', '80931', '139', '143', '282', '4', '32870');
INSERT INTO `tendency` VALUES ('2020-03-05', '80552', '23784', '482', '5737', '3042', '53726', '81034', '143', '102', '245', '4', '29896');
INSERT INTO `tendency` VALUES ('2020-03-06', '80651', '22177', '502', '5489', '3070', '55404', '81153', '99', '99', '198', '4', '26730');
INSERT INTO `tendency` VALUES ('2020-03-07', '80695', '20533', '458', '5264', '3097', '57065', '81153', '44', '84', '128', '4', '23074');
INSERT INTO `tendency` VALUES ('2020-03-08', '80735', '19016', '421', '5111', '3119', '58600', '81156', '40', '60', '100', '4', '20146');
INSERT INTO `tendency` VALUES ('2020-03-09', '80754', '17721', '349', '4794', '3136', '59897', '81103', '19', '36', '55', '4', '16982');
INSERT INTO `tendency` VALUES ('2020-03-10', '80778', '16145', '285', '4492', '3158', '61475', '81063', '24', '31', '55', '4', '14607');
INSERT INTO `tendency` VALUES ('2020-03-11', '80793', '14831', '253', '4257', '3169', '62793', '81046', '15', '33', '48', '4', '13701');
INSERT INTO `tendency` VALUES ('2020-03-12', '80813', '13526', '147', '4020', '3176', '64111', '80960', '8', '33', '41', '4', '12161');
INSERT INTO `tendency` VALUES ('2020-03-13', '80824', '12094', '115', '3610', '3189', '65541', '80939', '11', '17', '28', '4', '10879');
INSERT INTO `tendency` VALUES ('2020-03-14', '80844', '10734', '113', '3226', '3199', '66911', '80957', '20', '39', '59', '4', '10189');
INSERT INTO `tendency` VALUES ('2020-03-15', '80860', '9898', '134', '3032', '3213', '67749', '80994', '16', '41', '57', '4', '9582');
INSERT INTO `tendency` VALUES ('2020-03-16', '80881', '8976', '128', '2830', '3226', '68679', '81009', '21', '45', '66', '4', '9351');
INSERT INTO `tendency` VALUES ('2020-03-17', '80894', '8056', '119', '2622', '3237', '69601', '81013', '13', '21', '34', '4', '9222');
INSERT INTO `tendency` VALUES ('2020-03-18', '80928', '7263', '105', '2314', '3245', '70420', '81033', '34', '23', '57', '4', '9144');
INSERT INTO `tendency` VALUES ('2020-03-19', '80967', '6569', '104', '2136', '3248', '71150', '81071', '39', '31', '70', '4', '8989');
INSERT INTO `tendency` VALUES ('2020-03-20', '81008', '6013', '106', '1963', '3255', '71740', '81114', '41', '36', '77', '4', '9371');
INSERT INTO `tendency` VALUES ('2020-03-21', '81054', '5549', '118', '1845', '3261', '72244', '81172', '46', '45', '91', '4', '10071');
INSERT INTO `tendency` VALUES ('2020-03-22', '81093', '5120', '136', '1749', '3270', '72703', '81229', '39', '47', '86', '4', '10701');
INSERT INTO `tendency` VALUES ('2020-03-23', '81171', '4735', '132', '1573', '3277', '73159', '81303', '78', '35', '113', '4', '12077');
INSERT INTO `tendency` VALUES ('2020-03-24', '81218', '4287', '134', '1399', '3281', '73650', '81352', '47', '33', '80', '4', '13356');
INSERT INTO `tendency` VALUES ('2020-03-25', '81285', '3947', '159', '1235', '3287', '74051', '81444', '67', '58', '125', '4', '14714');
INSERT INTO `tendency` VALUES ('2020-03-26', '81340', '3460', '189', '1034', '3292', '74588', '81529', '55', '49', '104', '4', '16005');
INSERT INTO `tendency` VALUES ('2020-03-27', '81394', '3128', '184', '921', '3295', '74971', '81578', '54', '29', '83', '4', '17198');
INSERT INTO `tendency` VALUES ('2020-03-28', '81439', '2691', '174', '742', '3300', '75448', '81613', '45', '28', '73', '4', '18581');
INSERT INTO `tendency` VALUES ('2020-03-29', '81470', '2396', '168', '633', '3304', '75770', '81638', '31', '17', '48', '4', '19235');
INSERT INTO `tendency` VALUES ('2020-03-30', '81518', '2161', '183', '528', '3305', '76052', '81701', '48', '44', '92', '4', '19853');
INSERT INTO `tendency` VALUES ('2020-03-31', '81554', '2004', '172', '466', '3312', '76238', '81726', '36', '26', '62', '4', '20314');
INSERT INTO `tendency` VALUES ('2020-04-01', '81589', '1863', '153', '429', '3318', '76408', '81742', '35', '20', '55', '4', '20072');
INSERT INTO `tendency` VALUES ('2020-04-02', '81620', '1727', '135', '379', '3322', '76571', '81755', '31', '12', '43', '4', '19533');
INSERT INTO `tendency` VALUES ('2020-04-03', '81639', '1562', '114', '331', '3326', '76751', '81753', '19', '11', '30', '4', '18286');
INSERT INTO `tendency` VALUES ('2020-04-04', '81669', '1376', '107', '295', '3329', '76964', '81776', '30', '11', '41', '4', '17436');
INSERT INTO `tendency` VALUES ('2020-04-05', '81708', '1299', '88', '265', '3331', '77078', '81796', '39', '10', '49', '4', '16154');
INSERT INTO `tendency` VALUES ('2020-04-06', '81740', '1242', '89', '211', '3331', '77167', '81829', '32', '12', '44', '4', '14499');
INSERT INTO `tendency` VALUES ('2020-04-07', '81802', '1190', '83', '189', '3333', '77279', '81885', '62', '12', '74', '4', '13334');
INSERT INTO `tendency` VALUES ('2020-04-08', '81865', '1160', '73', '176', '3335', '77370', '81938', '63', '17', '80', '4', '12510');
INSERT INTO `tendency` VALUES ('2020-04-09', '81907', '1116', '53', '144', '3336', '77455', '81960', '42', '3', '45', '4', '11176');
INSERT INTO `tendency` VALUES ('2020-04-10', '81953', '1089', '44', '141', '3339', '77525', '81997', '46', '8', '54', '4', '10435');
INSERT INTO `tendency` VALUES ('2020-04-11', '82052', '1138', '82', '139', '3339', '77575', '82134', '99', '49', '148', '4', '9722');
INSERT INTO `tendency` VALUES ('2020-04-12', '82160', '1156', '72', '121', '3341', '77663', '82232', '108', '6', '114', '4', '9655');
INSERT INTO `tendency` VALUES ('2020-04-13', '82249', '1170', '72', '116', '3341', '77738', '82321', '89', '3', '92', '4', '8612');
INSERT INTO `tendency` VALUES ('2020-04-14', '82295', '1137', '72', '113', '3342', '77816', '82367', '46', '11', '57', '4', '8309');
INSERT INTO `tendency` VALUES ('2020-04-15', '82341', '1107', '63', '95', '3342', '77892', '82404', '46', '4', '50', '4', '8484');
INSERT INTO `tendency` VALUES ('2020-04-16', '82367', '1081', '62', '89', '3342', '77944', '82429', '26', '3', '29', '4', '8970');
INSERT INTO `tendency` VALUES ('2020-04-17', '82719', '1058', '63', '85', '4632', '77029', '82782', '27', '5', '32', '6', '8893');
INSERT INTO `tendency` VALUES ('2020-04-18', '82735', '1041', '48', '85', '4632', '77062', '82783', '16', '2', '18', '6', '8632');
INSERT INTO `tendency` VALUES ('2020-04-19', '82747', '1031', '43', '81', '4632', '77084', '82790', '12', '2', '14', '6', '8694');
INSERT INTO `tendency` VALUES ('2020-04-20', '82758', '1003', '37', '82', '4632', '77123', '82795', '11', '3', '14', '6', '8791');
INSERT INTO `tendency` VALUES ('2020-04-21', '82788', '1005', '35', '78', '4632', '77151', '82823', '30', '3', '33', '6', '8796');
INSERT INTO `tendency` VALUES ('2020-04-22', '82798', '959', '20', '63', '4632', '77207', '82818', '10', '0', '10', '6', '8429');
INSERT INTO `tendency` VALUES ('2020-04-23', '82804', '915', '20', '57', '4632', '77257', '82824', '6', '2', '8', '6', '8362');
INSERT INTO `tendency` VALUES ('2020-04-24', '82816', '838', '17', '49', '4632', '77346', '82833', '12', '3', '15', '6', '8493');
INSERT INTO `tendency` VALUES ('2020-04-25', '82827', '801', '12', '51', '4632', '77394', '82839', '11', '0', '11', '6', '8308');
INSERT INTO `tendency` VALUES ('2020-04-26', '82830', '723', '10', '52', '4633', '77474', '82840', '3', '5', '8', '6', '8443');
INSERT INTO `tendency` VALUES ('2020-04-27', '82836', '648', '9', '50', '4633', '77555', '82845', '6', '1', '7', '6', '8014');
INSERT INTO `tendency` VALUES ('2020-04-28', '82858', '647', '10', '50', '4633', '77578', '82868', '22', '2', '24', '6', '8283');
INSERT INTO `tendency` VALUES ('2020-04-29', '82862', '619', '10', '41', '4633', '77610', '82872', '4', '3', '7', '6', '8032');
INSERT INTO `tendency` VALUES ('2020-04-30', '82874', '599', '9', '38', '4633', '77642', '82883', '12', '3', '15', '6', '7761');
INSERT INTO `tendency` VALUES ('2020-05-01', '82875', '557', '11', '37', '4633', '77685', '82886', '1', '2', '3', '6', '7873');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `auth_key` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password_reset_token` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `status` smallint(6) NOT NULL DEFAULT '10',
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  `verification_token` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `password_reset_token` (`password_reset_token`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('10', 'wo', 'NzxtCavZEMquZ3V3fDT3phUTOlbdeoMQ', '$2y$13$/H7MqfA1x/mh0AeC441DQe3UpF7f3Tpg/Xom14w0DD0IpkwQ.Wtvi', null, 'test001@test.com', '10', '1588991945', '1588991945', null);
INSERT INTO `user` VALUES ('11', 'test002', 'ST71-GQw5Y1fyBboJSxK4OF0bxtCZc3Y', '$2y$13$e4rSYV6vPgGILuImRfZbJe12v.OnFvltrtaqdfIaHodyjxhvQkjeS', null, 'test002@test.com', '10', '1589025429', '1589025429', 'AJj_46qFyOrSxA6ivPrD7ELnVHCEaRqt_1589025429');
INSERT INTO `user` VALUES ('12', 'test003', 'g_YeXynFtIqNipdJQDhRw5vswjf-fDL_', '$2y$13$HF7qDjyUhi47ibiv39jsROwMv.qPDfCjrt0iHJDeRt2ttPhFdz90m', null, 'test003@test.com', '10', '1589025558', '1589025558', '_t9BAHZPMsi-ZqDp3gyt2EEtLWhN7T_B_1589025558');
INSERT INTO `user` VALUES ('13', 'test004', 'spITXcHCSYDT9N1snmFjrHRA0rZgAUTc', '$2y$13$FuOVFY4GZl98LJfThffYReA96ULeZ/5YuRotievvr6oAo.b76OfaS', null, 'test004@test.com', '10', '1589025886', '1589025886', 'Sy8PnwtPQEhoD39w_acAz-POy8k6B5v5_1589025886');
INSERT INTO `user` VALUES ('14', 'test005', '24IZC_HQZP3ltg5Czveoi1lnT2W_hTvH', '$2y$13$Cd9hfk/kTQi42p/aPSNt4eA5AnUicN0RP2NcdhmOO66nmb6/9anO6', null, 'test005@test.com', '10', '1589026001', '1589026001', null);
INSERT INTO `user` VALUES ('15', 'test006', 'DupADBpgAQn4IQOitRD-DHDomsi2unIV', '$2y$13$OFNpy1o3PcPQ3TpjzeS8jONeOhCz.qbrXl.jJQdCCihOOq1Wlvsqq', null, 'test006@test.com', '10', '1589026204', '1589026204', '7VL4fgbxHlQmsUCesv7spTuP0MpaPpj4_1589026204');
INSERT INTO `user` VALUES ('16', 'test007', 'Y38FB47jTcx1fbo_PXEthgCDBCUXqfDd', '$2y$13$IeTZJXR7J4IbeflWuak/QuY.fgR2AjpjTFdzkn5qQlnwnPQFEoIlS', null, 'test007@test.com', '10', '1589027208', '1589027208', null);
INSERT INTO `user` VALUES ('17', 'test008', 'mBbGo7d8e4_MPf7CSpW56WICMte-P4Mg', '$2y$13$PCQtwrMtao/W5wZm6lYo6OdGSHEEDstIizvX5TS3bdwleMNixwayC', null, 'test008@test.com', '10', '1589028352', '1589028352', null);
INSERT INTO `user` VALUES ('18', 'test009', 'fNfDqyf14Xd81-KDtblDEZz2Z7Q0wq9_', '$2y$13$TtsgyouVjbWu7OxtOCMKUuIRnZp.81yWzVKNcS.rSXc9xnkE.emWy', null, 'test009@test.com', '10', '1589103959', '1589103959', null);
INSERT INTO `user` VALUES ('19', 'test010', '5EK0G7DHqvLtFLsYJxwT88RBRHvlQyED', '$2y$13$Sw6cxGDJOwgkNLc97otGyeaeKFfIYJUQgL8I9UdNzU1CqEqtu6zBC', null, 'test010@test.com', '10', '1589104127', '1589104127', null);
INSERT INTO `user` VALUES ('20', '123', 'qnvGsbvLPpcbJhfARxenqo7fqLD6Afy9', '$2y$13$k8BroWM8Qyj2k.ggm7F4Kufmw06vnNiLjI5ZCiKREud/XYcleD1bS', null, '123@123.com', '10', '1589104195', '1589104195', null);
INSERT INTO `user` VALUES ('21', 'test011', 'qO6aa5zAu4cn9ZT4Br8c1yzZNu9Ks-pk', '$2y$13$PSnw0a1pjtw1SmIaktKa2.jsJjD1HNJiQr6Ue9bDCVfiqTa4LtXIu', null, 'test011@test.com', '10', '1589105687', '1589105687', null);
INSERT INTO `user` VALUES ('22', 'test012', 'aMf3ti9yg2aXfLGumFd1MOpfvlppnl69', '$2y$13$EmjLbJvzvd8eh/Zdl/3bHOUTCVlDANYyoDOdxjnK7B7EUT40obIqq', null, 'test012@test.com', '10', '1589106195', '1589106195', null);
INSERT INTO `user` VALUES ('23', 'test013', 'K-jv2hnJQTDCBdjLteYWDZ2b208SyrJq', '$2y$13$unRCgO80s.NFM6.KDANGzemltAm63nrl1PPYkSv6PNPJdYXLe3nna', null, 'test013@test.com', '10', '1589106245', '1589106245', null);
INSERT INTO `user` VALUES ('24', 'test014', 'wQXHC5SFxDis6o-OKw2hC77pfHlPXD5w', '$2y$13$5ezjoX9FmFeBuROQUIHF1.g8tUoOOmU.AAsFgcv8SLRDiCOMgKSBS', null, 'test014@test.com', '10', '1589106333', '1589106333', null);
INSERT INTO `user` VALUES ('25', 'test015', 'U-qhTW2P9ilvwS7zYDl9lQekmKXkx2DT', '$2y$13$jyeiIE07iR.MuaCbN3ItxOsv5ZKVf8BX/lgZJIeccoiE2vqZd75p6', null, 'test015@test.com', '10', '1589106348', '1589106348', null);
INSERT INTO `user` VALUES ('26', 'test016', 'Mtb_iqqqEt9xcJdFSPUDlwLe95VRh97o', '$2y$13$kJO0Djf5AVjVG6vW.6rtjex0GXIQHGXroFKDXljF5V2SWAEK7Nq2i', null, 'test016@test.com', '10', '1589106501', '1589106501', null);
INSERT INTO `user` VALUES ('27', 'test017', 'rNkL1rkhbdVk2u-iYVYuRYj0CSQlc5G9', '$2y$13$XHCbD916qAOdJ8DWdZdSieVOUj9Tssq2SqrMPyj7oXTljnkah5WwS', null, 'test017@test.com', '10', '1589106621', '1589106621', null);
INSERT INTO `user` VALUES ('28', 'test018', 'CF7e7sLPC_gO9RCHkmgbpPEuFb5Clwxo', '$2y$13$RHcSDmvW8yuulT81d5x7n.fthvDIN9Y1jRkN1P1XUsENEzInaF5/.', null, 'test018@test.com', '10', '1589106783', '1589106783', null);
INSERT INTO `user` VALUES ('29', 'test019', 'okciS8hT4nC_l-I6dCc-IfA7I6eGt6G6', '$2y$13$yGB7DQedqvG.h39vlXfTeOiSSNMnd7FdaFaUtF43RelMWEwJeBR2.', null, 'test019@test.com', '10', '1589106839', '1589106839', null);
INSERT INTO `user` VALUES ('30', 'test020', 'I5sf650SuE8IjIYUrYUxldOKQgsWZcIa', '$2y$13$7/MVl0yfwV0OH2fkBrN97eBG9zwNDveBIhlYHRWV7dWT12yzHamja', null, 'test020@test.com', '10', '1589106932', '1589106932', null);
INSERT INTO `user` VALUES ('31', '21', 'Zk058Pm-ohmHpraj_SuwW19A790HB4af', '$2y$13$9WmZpy8H4mNWkwz.DdsvKuvgyr5VzlwQJbw2EtRVs3z2F9yUBkLX2', null, '21@21.com', '10', '1589107055', '1589107055', null);
INSERT INTO `user` VALUES ('32', '22', 'XH0oS7xubxaCtmiJ8IinO3cDzFAsfE2z', '$2y$13$KN5Kbg2zpR3UqEI55HIjQ.TC2HZSTkAwZzQMGeGpMwmJ51BgCa6zu', null, '22@21.com', '10', '1589107186', '1589107186', null);
INSERT INTO `user` VALUES ('33', '23', '_zEJ2QI2gIIp1KufOUWLoNk6DFw9OoJq', '$2y$13$JGQEZocAHXufC2FqMDs4MOvK4klL8uP9b44EdEiLoi65Nr5mq2t2y', null, '23@qq.com', '10', '1589107944', '1589107944', null);
INSERT INTO `user` VALUES ('34', '24', 'pPk4ja4AvO91OE31HbrV5vgMDsc2UxzO', '$2y$13$gF7oX9W/KDeGInnpfbmoTeXA.KeO3bCI.Gbswfb/T6qIykjjJ7DGG', null, '24@qq.com', '10', '1589109199', '1589109199', null);
INSERT INTO `user` VALUES ('35', '25', 'XIkHG3N1RLZ9eOlXUhUnLqPcTLym9Jxy', '$2y$13$wn9gonGuigJha05m8Mi1TuNNJNjGAddPhGbAiHNcZJSdHWmrl8xa.', null, '25@qq.com', '10', '1589109283', '1589109283', null);
INSERT INTO `user` VALUES ('36', '26', 'v_8CGnMuj0ZPx4bECT48W0ywxdlbOgBH', '$2y$13$H6y0hi8GrHw2RxoVXof1H.tNO80y2NFnfzKOmJKKvKMP8KjOcNt/.', null, '26@qq.com', '10', '1589109605', '1589109605', null);
INSERT INTO `user` VALUES ('37', '27', 'YESoJ-qePjivLtFpfL1Q5AL-0nlu16BU', '$2y$13$7nvE1ce5MbxCNm/ySTrlgOY7YJzYnNL.0FpL24jq2vzJK7u6WpUay', null, '27@qq.com', '10', '1589109858', '1589109858', null);
INSERT INTO `user` VALUES ('38', '28', 'F_rpOupPdfkJevouJqs8RMN1WgYxteCa', '$2y$13$RbtaZGOXUrRuFjvQnEmoVO7xNUPZ0jUz0lHHgU1aqdXHOQ0ypoaZ.', null, '28@qq.com', '10', '1589109967', '1589109967', null);
INSERT INTO `user` VALUES ('39', 'wp', 'IPp6ueA5GyLD-52C8Qy2C0rKt7UBPlOL', '$2y$13$YSNzk3/D61B56MuKsftk0uZ8WEcCOsqnQBqJRqehmah6vAYyadira', null, '1527974107@qq.com', '10', '1589258672', '1589258672', null);
INSERT INTO `user` VALUES ('40', 'wrz', 'xkoJ70roMeeaa7_8EfEc5tu9nUsgNvbV', '$2y$13$GRONyc5esndxNRiL4PGe7.nAXONR/K25a10.XatLDjYhR//dyPBDC', null, 'wrz@qq.com', '10', '1589275120', '1589275120', null);
INSERT INTO `user` VALUES ('41', 'wuhu', '8eyScPMBc2rwO46zZckTtv4tG-WTagdr', '$2y$13$T9iAb19M7urokJ8GEWhVBOLb44fWSt/vdM45Z/nXi5p2yFEa4g8uS', null, 'wuhu@wuhu.com', '10', '1589378874', '1589378874', null);

-- ----------------------------
-- Table structure for `wishes`
-- ----------------------------
DROP TABLE IF EXISTS `wishes`;
CREATE TABLE `wishes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `content` varchar(255) NOT NULL COMMENT '内容',
  `created_at` int(11) NOT NULL COMMENT '创建时间',
  `username` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of wishes
-- ----------------------------
INSERT INTO `wishes` VALUES ('10', '10', '我修改的', '1589113488', 'wo');
INSERT INTO `wishes` VALUES ('11', '10', '我修改的', '1589113488', 'he');
INSERT INTO `wishes` VALUES ('39', '13', '我修改的', '1589256663', 'test004');
INSERT INTO `wishes` VALUES ('40', '39', '润宝，永远滴神', '1589258918', 'wp');
INSERT INTO `wishes` VALUES ('41', '40', 'dsadas', '1589275135', 'wrz');
INSERT INTO `wishes` VALUES ('42', '40', 'sadasdasd萨达萨达是', '1589275304', 'wrz');
INSERT INTO `wishes` VALUES ('43', '11', 'success', '1589362443', 'test002');
INSERT INTO `wishes` VALUES ('44', '39', 'dwadawdawdwad', '1589378653', 'wp');
INSERT INTO `wishes` VALUES ('45', '39', 'ddd', '1589716175', 'wp');
INSERT INTO `wishes` VALUES ('46', '39', 'da\'s\'d', '1590041626', 'wp');
INSERT INTO `wishes` VALUES ('47', '39', 'wewerwe', '1592016197', 'wp');

-- ----------------------------
-- Table structure for `worldmap`
-- ----------------------------
DROP TABLE IF EXISTS `worldmap`;
CREATE TABLE `worldmap` (
  `name` varchar(255) NOT NULL,
  `currentConfirmedCount` varchar(255) DEFAULT NULL,
  `confirmedCount` varchar(255) DEFAULT NULL,
  `curedCount` varchar(255) DEFAULT NULL,
  `deadCount` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of worldmap
-- ----------------------------
INSERT INTO `worldmap` VALUES ('Afghanistan', '141', '145', '0', '4');
INSERT INTO `worldmap` VALUES ('Albania', '192', '212', '10', '10');
INSERT INTO `worldmap` VALUES ('Algeria', '451', '511', '29', '31');
INSERT INTO `worldmap` VALUES ('Andorra', '322', '334', '6', '6');
INSERT INTO `worldmap` VALUES ('Angola', '5', '7', '0', '2');
INSERT INTO `worldmap` VALUES ('Antigua and Barbuda', '7', '7', '0', '0');
INSERT INTO `worldmap` VALUES ('Argentina', '739', '820', '1', '80');
INSERT INTO `worldmap` VALUES ('Armenia', '391', '424', '30', '3');
INSERT INTO `worldmap` VALUES ('Australia', '3958', '4093', '119', '16');
INSERT INTO `worldmap` VALUES ('Austria', '8243', '8536', '225', '68');
INSERT INTO `worldmap` VALUES ('Azerbaijan', '190', '209', '15', '4');
INSERT INTO `worldmap` VALUES ('Bahamas', '10', '10', '0', '0');
INSERT INTO `worldmap` VALUES ('Bahrain', '223', '499', '272', '4');
INSERT INTO `worldmap` VALUES ('Bailiwick of Jersey', '60', '61', '0', '1');
INSERT INTO `worldmap` VALUES ('Bangladesh', '32', '48', '11', '5');
INSERT INTO `worldmap` VALUES ('Barbados', '24', '24', '0', '0');
INSERT INTO `worldmap` VALUES ('Belarus', '72', '94', '22', '0');
INSERT INTO `worldmap` VALUES ('Belgium', '10055', '10836', '350', '431');
INSERT INTO `worldmap` VALUES ('Belize', '2', '2', '0', '0');
INSERT INTO `worldmap` VALUES ('Benin', '6', '6', '0', '0');
INSERT INTO `worldmap` VALUES ('Bolivia', '74', '74', '0', '0');
INSERT INTO `worldmap` VALUES ('Bosnia and Herzegovina', '310', '324', '8', '6');
INSERT INTO `worldmap` VALUES ('Brazil', '4120', '4256', '0', '136');
INSERT INTO `worldmap` VALUES ('Brunei', '91', '126', '34', '1');
INSERT INTO `worldmap` VALUES ('Bulgaria', '328', '338', '3', '7');
INSERT INTO `worldmap` VALUES ('Burkina Faso', '187', '222', '23', '12');
INSERT INTO `worldmap` VALUES ('Burma', '10', '10', '0', '0');
INSERT INTO `worldmap` VALUES ('Cameroon', '134', '139', '3', '2');
INSERT INTO `worldmap` VALUES ('Canada', '5909', '6320', '345', '66');
INSERT INTO `worldmap` VALUES ('Cayman Is', '7', '8', '0', '1');
INSERT INTO `worldmap` VALUES ('Central African Republic', '6', '6', '0', '0');
INSERT INTO `worldmap` VALUES ('Chad', '5', '5', '0', '0');
INSERT INTO `worldmap` VALUES ('Chile', '2057', '2139', '75', '7');
INSERT INTO `worldmap` VALUES ('China', '3196', '82451', '75944', '3311');
INSERT INTO `worldmap` VALUES ('Colombia', '592', '608', '10', '6');
INSERT INTO `worldmap` VALUES ('Costa Rica', '293', '295', '0', '2');
INSERT INTO `worldmap` VALUES ('Croatia', '615', '657', '37', '5');
INSERT INTO `worldmap` VALUES ('Cuba', '116', '119', '0', '3');
INSERT INTO `worldmap` VALUES ('Cyprus', '208', '214', '0', '6');
INSERT INTO `worldmap` VALUES ('Czech Republic', '2778', '2805', '11', '16');
INSERT INTO `worldmap` VALUES ('Dem. Rep. Congo', '70', '81', '3', '8');
INSERT INTO `worldmap` VALUES ('Denmark', '2322', '2395', '1', '72');
INSERT INTO `worldmap` VALUES ('Diamond Princess Cruise Ship', '128', '712', '574', '10');
INSERT INTO `worldmap` VALUES ('Djibouti', '18', '18', '0', '0');
INSERT INTO `worldmap` VALUES ('Dominican Republic', '561', '581', '0', '20');
INSERT INTO `worldmap` VALUES ('Ecuador', '1775', '1823', '0', '48');
INSERT INTO `worldmap` VALUES ('Egypt', '437', '609', '132', '40');
INSERT INTO `worldmap` VALUES ('El Salvador', '19', '19', '0', '0');
INSERT INTO `worldmap` VALUES ('Estonia', '656', '679', '20', '3');
INSERT INTO `worldmap` VALUES ('Ethiopia', '18', '21', '3', '0');
INSERT INTO `worldmap` VALUES ('Faroe', '155', '155', '0', '0');
INSERT INTO `worldmap` VALUES ('Fiji', '5', '5', '0', '0');
INSERT INTO `worldmap` VALUES ('Finland', '1197', '1218', '10', '11');
INSERT INTO `worldmap` VALUES ('France', '30436', '40174', '7132', '2606');
INSERT INTO `worldmap` VALUES ('French Guiana', '31', '31', '0', '0');
INSERT INTO `worldmap` VALUES ('French Polynesia', '34', '34', '0', '0');
INSERT INTO `worldmap` VALUES ('Gabon', '6', '7', '0', '1');
INSERT INTO `worldmap` VALUES ('Gambia', '3', '4', '0', '1');
INSERT INTO `worldmap` VALUES ('Georgia', '72', '90', '18', '0');
INSERT INTO `worldmap` VALUES ('Germany', '49146', '58101', '8481', '474');
INSERT INTO `worldmap` VALUES ('Ghana', '145', '152', '2', '5');
INSERT INTO `worldmap` VALUES ('Gibraltar', '56', '56', '0', '0');
INSERT INTO `worldmap` VALUES ('Grand Princess', '21', '21', '0', '0');
INSERT INTO `worldmap` VALUES ('Greece', '1099', '1156', '19', '38');
INSERT INTO `worldmap` VALUES ('Guam', '55', '56', '0', '1');
INSERT INTO `worldmap` VALUES ('Guatemala', '31', '32', '0', '1');
INSERT INTO `worldmap` VALUES ('Guernsey', '39', '39', '0', '0');
INSERT INTO `worldmap` VALUES ('Guinea', '15', '16', '1', '0');
INSERT INTO `worldmap` VALUES ('Guyana', '4', '5', '0', '1');
INSERT INTO `worldmap` VALUES ('Haiti', '8', '8', '0', '0');
INSERT INTO `worldmap` VALUES ('Honduras', '67', '68', '0', '1');
INSERT INTO `worldmap` VALUES ('Hungary', '361', '408', '34', '13');
INSERT INTO `worldmap` VALUES ('Iceland', '894', '1020', '124', '2');
INSERT INTO `worldmap` VALUES ('India', '902', '1024', '95', '27');
INSERT INTO `worldmap` VALUES ('Indonesia', '1136', '1285', '35', '114');
INSERT INTO `worldmap` VALUES ('Iran', '23278', '38309', '12391', '2640');
INSERT INTO `worldmap` VALUES ('Iraq', '362', '547', '143', '42');
INSERT INTO `worldmap` VALUES ('Ireland', '2569', '2615', '0', '46');
INSERT INTO `worldmap` VALUES ('Israel', '4034', '4247', '132', '81');
INSERT INTO `worldmap` VALUES ('Italy', '73880', '97689', '13030', '10779');
INSERT INTO `worldmap` VALUES ('Ivory Coast', '160', '165', '4', '1');
INSERT INTO `worldmap` VALUES ('Jamaica', '29', '30', '0', '1');
INSERT INTO `worldmap` VALUES ('Japan', '1433', '1893', '404', '56');
INSERT INTO `worldmap` VALUES ('Jordan', '239', '259', '18', '2');
INSERT INTO `worldmap` VALUES ('Kampuchea (Cambodia )', '82', '103', '21', '0');
INSERT INTO `worldmap` VALUES ('Kazakhstan', '263', '284', '20', '1');
INSERT INTO `worldmap` VALUES ('Kenya', '40', '42', '1', '1');
INSERT INTO `worldmap` VALUES ('Kingdom of Bhutan', '3', '3', '0', '0');
INSERT INTO `worldmap` VALUES ('Korea', '4275', '9661', '5228', '158');
INSERT INTO `worldmap` VALUES ('Kuwait', '191', '255', '64', '0');
INSERT INTO `worldmap` VALUES ('Lao PDR', '6', '6', '0', '0');
INSERT INTO `worldmap` VALUES ('Latvia', '347', '347', '0', '0');
INSERT INTO `worldmap` VALUES ('Lebanon', '398', '438', '30', '10');
INSERT INTO `worldmap` VALUES ('Liberia', '3', '3', '0', '0');
INSERT INTO `worldmap` VALUES ('Libya', '3', '3', '0', '0');
INSERT INTO `worldmap` VALUES ('Liechtenstein', '61', '61', '0', '0');
INSERT INTO `worldmap` VALUES ('Lithuania', '429', '437', '1', '7');
INSERT INTO `worldmap` VALUES ('Luxembourg', '1929', '1950', '0', '21');
INSERT INTO `worldmap` VALUES ('Madagascar', '43', '43', '0', '0');
INSERT INTO `worldmap` VALUES ('Malaysia', '2048', '2470', '388', '34');
INSERT INTO `worldmap` VALUES ('Maldives', '6', '17', '11', '0');
INSERT INTO `worldmap` VALUES ('Mali', '19', '20', '0', '1');
INSERT INTO `worldmap` VALUES ('Malta', '139', '139', '0', '0');
INSERT INTO `worldmap` VALUES ('Martinique', '92', '93', '0', '1');
INSERT INTO `worldmap` VALUES ('Mauritius', '105', '107', '0', '2');
INSERT INTO `worldmap` VALUES ('Mexico', '972', '993', '1', '20');
INSERT INTO `worldmap` VALUES ('Moldova', '219', '231', '10', '2');
INSERT INTO `worldmap` VALUES ('Monaco', '45', '46', '1', '0');
INSERT INTO `worldmap` VALUES ('Mongolia', '12', '12', '0', '0');
INSERT INTO `worldmap` VALUES ('Morocco', '424', '463', '13', '26');
INSERT INTO `worldmap` VALUES ('Mozambique', '8', '8', '0', '0');
INSERT INTO `worldmap` VALUES ('Namibia', '11', '11', '0', '0');
INSERT INTO `worldmap` VALUES ('Nepal', '4', '5', '1', '0');
INSERT INTO `worldmap` VALUES ('Netherlands', '7141', '10866', '2954', '771');
INSERT INTO `worldmap` VALUES ('New Zealand', '538', '589', '50', '1');
INSERT INTO `worldmap` VALUES ('Nicaragua', '3', '4', '0', '1');
INSERT INTO `worldmap` VALUES ('Niger', '9', '10', '0', '1');
INSERT INTO `worldmap` VALUES ('Nigeria', '107', '111', '3', '1');
INSERT INTO `worldmap` VALUES ('North Macedonia', '250', '257', '1', '6');
INSERT INTO `worldmap` VALUES ('Northern Ireland', '1', '1', '0', '0');
INSERT INTO `worldmap` VALUES ('Norway', '4258', '4284', '0', '26');
INSERT INTO `worldmap` VALUES ('Oman', '138', '167', '29', '0');
INSERT INTO `worldmap` VALUES ('Pakistan', '1526', '1566', '25', '15');
INSERT INTO `worldmap` VALUES ('Palestine', '87', '106', '18', '1');
INSERT INTO `worldmap` VALUES ('Panama', '884', '901', '0', '17');
INSERT INTO `worldmap` VALUES ('Papua New Guinea', '1', '1', '0', '0');
INSERT INTO `worldmap` VALUES ('Paraguay', '61', '64', '0', '3');
INSERT INTO `worldmap` VALUES ('Peru', '820', '852', '14', '18');
INSERT INTO `worldmap` VALUES ('Philippines', '1305', '1418', '42', '71');
INSERT INTO `worldmap` VALUES ('Poland', '1827', '1862', '13', '22');
INSERT INTO `worldmap` VALUES ('Portugal', '5821', '5962', '22', '119');
INSERT INTO `worldmap` VALUES ('Puerto Rico', '62', '64', '0', '2');
INSERT INTO `worldmap` VALUES ('Qatar', '585', '634', '48', '1');
INSERT INTO `worldmap` VALUES ('Republic of Rwanda', '60', '60', '0', '0');
INSERT INTO `worldmap` VALUES ('Republic of Serbia', '737', '750', '0', '13');
INSERT INTO `worldmap` VALUES ('Reunion', '143', '143', '0', '0');
INSERT INTO `worldmap` VALUES ('Reunion Island', '6', '6', '0', '0');
INSERT INTO `worldmap` VALUES ('Romania', '1549', '1760', '169', '42');
INSERT INTO `worldmap` VALUES ('Russia', '1462', '1534', '64', '8');
INSERT INTO `worldmap` VALUES ('Saint Barthelemy', '3', '3', '0', '0');
INSERT INTO `worldmap` VALUES ('Saint Vincent and the Grenadines', '1', '1', '0', '0');
INSERT INTO `worldmap` VALUES ('San Marino', '218', '242', '2', '22');
INSERT INTO `worldmap` VALUES ('Saudi Arabia', '1225', '1299', '66', '8');
INSERT INTO `worldmap` VALUES ('Senegal', '115', '142', '27', '0');
INSERT INTO `worldmap` VALUES ('Seychelles', '7', '7', '0', '0');
INSERT INTO `worldmap` VALUES ('Singapore', '658', '844', '183', '3');
INSERT INTO `worldmap` VALUES ('Sint Maarten', '12', '12', '0', '0');
INSERT INTO `worldmap` VALUES ('Slovakia', '307', '314', '7', '0');
INSERT INTO `worldmap` VALUES ('Slovenia', '682', '691', '0', '9');
INSERT INTO `worldmap` VALUES ('Somali', '3', '3', '0', '0');
INSERT INTO `worldmap` VALUES ('South Africa', '1277', '1280', '1', '2');
INSERT INTO `worldmap` VALUES ('Spain', '58598', '80110', '14709', '6803');
INSERT INTO `worldmap` VALUES ('SriLanka', '110', '117', '6', '1');
INSERT INTO `worldmap` VALUES ('St.Lucia', '3', '3', '0', '0');
INSERT INTO `worldmap` VALUES ('Status Civitatis Vaticanae', '6', '6', '0', '0');
INSERT INTO `worldmap` VALUES ('Sudan', '4', '5', '0', '1');
INSERT INTO `worldmap` VALUES ('Suriname', '8', '8', '0', '0');
INSERT INTO `worldmap` VALUES ('Swaziland', '9', '9', '0', '0');
INSERT INTO `worldmap` VALUES ('Sweden', '3573', '3700', '17', '110');
INSERT INTO `worldmap` VALUES ('Switzerland', '12676', '14799', '1823', '300');
INSERT INTO `worldmap` VALUES ('Syria', '5', '6', '0', '1');
INSERT INTO `worldmap` VALUES ('Tanzania', '13', '14', '1', '0');
INSERT INTO `worldmap` VALUES ('Thailand', '1284', '1388', '97', '7');
INSERT INTO `worldmap` VALUES ('The Islamic Republic of Mauritania', '3', '5', '2', '0');
INSERT INTO `worldmap` VALUES ('The Republic of Equatorial Guinea', '14', '14', '0', '0');
INSERT INTO `worldmap` VALUES ('Togo', '22', '30', '7', '1');
INSERT INTO `worldmap` VALUES ('Trinidad and Tobago', '72', '74', '0', '2');
INSERT INTO `worldmap` VALUES ('Tunisia', '304', '312', '0', '8');
INSERT INTO `worldmap` VALUES ('Turkey', '8981', '9217', '105', '131');
INSERT INTO `worldmap` VALUES ('Uganda', '33', '33', '0', '0');
INSERT INTO `worldmap` VALUES ('Ukraine', '459', '475', '6', '10');
INSERT INTO `worldmap` VALUES ('United Arab Emirates', '509', '570', '58', '3');
INSERT INTO `worldmap` VALUES ('United Kingdom', '18159', '19522', '135', '1228');
INSERT INTO `worldmap` VALUES ('United Kingdom of Great Britain and Ireland', '12', '20', '8', '0');
INSERT INTO `worldmap` VALUES ('United States', '135699', '143072', '4856', '2517');
INSERT INTO `worldmap` VALUES ('Uruguay', '302', '309', '6', '1');
INSERT INTO `worldmap` VALUES ('Uzbekistan', '131', '133', '0', '2');
INSERT INTO `worldmap` VALUES ('Venezuela', '111', '113', '0', '2');
INSERT INTO `worldmap` VALUES ('Vietnam', '163', '188', '25', '0');
INSERT INTO `worldmap` VALUES ('Zimbabwe', '6', '7', '0', '1');
