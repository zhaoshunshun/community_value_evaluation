truncate table ods_evaluation.public_dianping_info;
drop table if exists ods_evaluation.public_dianping_info;
create table ods_evaluation.public_dianping_info
(
    city_id STRING COMMENT '城市id',
    city_name STRING COMMENT '城市名称',
    market_region STRING COMMENT '商场区域',
    shop_id STRING COMMENT '店铺id',
    shop_name STRING COMMENT '店铺名称',
    shop_tag STRING COMMENT '店铺标签',
    shop_per_capita_consumption STRING COMMENT '人均消费',
    shop_address STRING COMMENT '店铺地址',
    market_id STRING COMMENT '商场id',
    market_name STRING COMMENT '商场名称',
    avg_per_capita_consumption decimal(11,2) COMMENT '商场人均消费',
    timestamp_v timestamp COMMENT '数据处理时间'
) COMMENT '大众点评'  STORED AS TEXTFILE;
