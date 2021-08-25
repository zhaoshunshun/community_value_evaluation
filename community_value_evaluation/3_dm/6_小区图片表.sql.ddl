

create  table dm_evaluation.community_month_report_pic
(
    community_id STRING COMMENT '二手房小区id',
    community_picture_id STRING COMMENT '二手房图片id',
    community_layout_id STRING COMMENT '二手房户型图id',
    order_tag   BIGINT COMMENT '排序字段',
    category_id BIGINT COMMENT '图片类型id',
    category STRING COMMENT '图片类型描述',
    pic_data STRING COMMENT '图片url',
    pic_data_source STRING COMMENT '图片来源',
    description STRING COMMENT '图片描述',
    pre_pic_md5 STRING COMMENT '原图图片MD5',
    batch_no STRING COMMENT '批次号',
    timestamp_v STRING COMMENT '数据处理时间'
)COMMENT '小区图片表'  STORED AS TEXTFILE;