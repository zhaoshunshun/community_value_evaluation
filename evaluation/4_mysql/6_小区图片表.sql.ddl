CREATE TABLE `community_month_report_pic` (
`id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增',


`community_id` varchar(50) DEFAULT NULL COMMENT '二手房小区id',
`community_picture_id` varchar(50) DEFAULT NULL COMMENT '二手房图片id',
`community_layout_id` varchar(50) DEFAULT NULL COMMENT '二手房户型图id',
`order_tag` varchar(50) DEFAULT NULL COMMENT '排序字段',
`category_id` varchar(50) DEFAULT NULL COMMENT '图片类型id',
`category` varchar(50) DEFAULT NULL COMMENT '图片类型描述',
`pic_data` varchar(255) DEFAULT NULL COMMENT '图片url',
`pic_data_source` varchar(50) DEFAULT NULL COMMENT '图片来源',
`description` varchar(255) DEFAULT NULL COMMENT '图片描述',
`pre_pic_md5` varchar(50) DEFAULT NULL COMMENT '原图图片MD5',
`batch_no` varchar(255) DEFAULT NULL COMMENT '批次号',
`timestamp_v` datetime DEFAULT NULL COMMENT '数据处理时间',
`is_del` tinyint(1) DEFAULT '0' COMMENT '删除标识',
`create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
`version` int(11) DEFAULT '0' COMMENT '版本',
`remark` varchar(255) DEFAULT '' COMMENT '备注',
PRIMARY KEY (`id`) USING BTREE,
KEY `community_id` (`community_id`) USING BTREE,
KEY `batch_no` (`batch_no`) USING BTREE,
KEY `category` (`category`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='小区月报-小区图片表'