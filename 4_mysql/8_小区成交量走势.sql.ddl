
CREATE TABLE `community_month_deal_report` (
`id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键自增',
`is_del` tinyint(1) DEFAULT '0' COMMENT '删除标识',
`create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`version` int(11) DEFAULT '0' COMMENT '版本',
`remark` varchar(255) DEFAULT '' COMMENT '备注',
`community_id` varchar(20) DEFAULT NULL COMMENT '小区id',
`district_cd` varchar(50) DEFAULT NULL COMMENT '小区区域id',
`district_name` varchar(50) DEFAULT NULL COMMENT '小区区域',
`month` varchar(50) DEFAULT NULL COMMENT '年月',
`community_deal_cnt` varchar(10) DEFAULT NULL COMMENT '小区成交量',
`district_deal_cnt` varchar(10) DEFAULT NULL COMMENT '区域成交量',
`batch_no` varchar(255) DEFAULT NULL COMMENT '批次号',
`timestamp_v` datetime DEFAULT NULL COMMENT '数据更新时间',
PRIMARY KEY (`id`) USING BTREE,
KEY `community_id_2` (`community_id`,`batch_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='小区成交走势表'