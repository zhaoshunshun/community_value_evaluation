
drop table community_month_report_label
CREATE TABLE `community_month_report_label` (
`id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增',

`community_id` varchar(20) DEFAULT NULL COMMENT '小区id',
`label_traffic` varchar(50) DEFAULT NULL COMMENT '交通便利标签',
`label_facilities` varchar(50) DEFAULT NULL COMMENT '小区配套标签',
`label_parking` varchar(50) DEFAULT NULL COMMENT '小区车位比标签',
`label_elevator` varchar(50) DEFAULT NULL COMMENT '小区电梯标签',
`label_sub` varchar(50) DEFAULT NULL COMMENT '小区地铁标签',
`label_arround_facilities` varchar(50) DEFAULT NULL COMMENT '小区周边配套标签',
`label_park` varchar(50) DEFAULT NULL COMMENT '小区周边公园标签',
`label_school` varchar(50) DEFAULT NULL COMMENT '小区学校标签',
`label_price` varchar(50) DEFAULT NULL COMMENT '小区房价涨幅标签',
`label_green` varchar(50) DEFAULT NULL COMMENT '小区绿化率标签',
`label_age` varchar(50) DEFAULT NULL COMMENT '小区房龄标签',
`label_rent` varchar(50) DEFAULT NULL COMMENT '小区租房标签',
`batch_no` varchar(255) DEFAULT NULL COMMENT '批次号',
`timestamp_v` datetime DEFAULT NULL COMMENT '数据处理时间',
`is_del` tinyint(1) DEFAULT '0' COMMENT '删除标识',
`create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`version` int(11) DEFAULT '0' COMMENT '版本',
`remark` varchar(255) DEFAULT '' COMMENT '备注',
PRIMARY KEY (`id`) USING BTREE,
KEY `community_id` (`community_id`) USING BTREE,
KEY `batch_no` (`batch_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小区标签数据表'