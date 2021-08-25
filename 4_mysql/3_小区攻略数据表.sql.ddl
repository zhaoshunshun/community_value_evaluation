
drop table community_month_report_strategy
CREATE TABLE `community_month_report_strategy` (
`id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增',

`community_id` varchar(20) DEFAULT NULL COMMENT '小区id',
`community_desc` text DEFAULT NULL COMMENT '小区描述(数据来源贝壳攻略)',
`live_population` text DEFAULT NULL COMMENT '小区居住人群',
`atmosphere` text DEFAULT NULL COMMENT '小区氛围',
`property_services` text DEFAULT NULL COMMENT '小区物业服务',
`parking_conditions` text DEFAULT NULL COMMENT '小区停车情况',
`advantage` text DEFAULT NULL COMMENT '小区优点',
`shortcoming` text DEFAULT NULL COMMENT '小区缺点',
`proprietor_speak` text DEFAULT NULL COMMENT '业主说',
`facilities` varchar(255) DEFAULT NULL COMMENT '小区内部配套list',
`facilities_desc` varchar(500) DEFAULT NULL COMMENT '小区内部配套描述',
`timestamp_v` datetime DEFAULT NULL COMMENT '数据处理时间',
`batch_no` varchar(255) DEFAULT NULL COMMENT '批次号',
`is_del` tinyint(1) DEFAULT '0' COMMENT '删除标识',
`create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`version` int(11) DEFAULT '0' COMMENT '版本',
`remark` varchar(255) DEFAULT '' COMMENT '备注',
PRIMARY KEY (`id`) USING BTREE,
KEY `community_id` (`community_id`) USING BTREE,
KEY `batch_no` (`batch_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小区攻略数据表'