truncate table ods_evaluation.community_evaluation_strategy;
drop table if exists ods_evaluation.community_evaluation_strategy;
create table ods_evaluation.community_evaluation_strategy
(
    community_id STRING COMMENT '小区id',
    community_name STRING COMMENT '小区名称',
    city_id STRING COMMENT '城市id',
    city_name STRING COMMENT '城市名称',
    district_id STRING COMMENT '城市id',
    district_name STRING COMMENT '城市名称',
    block_id STRING COMMENT '城市id',
    block_name STRING COMMENT '城市名称',
    community_facilities STRING COMMENT '攻略',
    timestamp_v timestamp COMMENT '数据处理时间'
) COMMENT '小区攻略表'  STORED AS TEXTFILE;
