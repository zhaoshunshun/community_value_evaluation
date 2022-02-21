truncate table ods_evaluation.community_school_info;
drop table if exists ods_evaluation.community_school_info;
create table ods_evaluation.community_school_info
(
    community_id STRING COMMENT '小区id',
    community_name STRING COMMENT '小区名称',
    city_id STRING COMMENT '城市id',
    city_name STRING COMMENT '城市名称',
    district_id STRING COMMENT '区域id',
    district_name STRING COMMENT '区域名称',
    block_id STRING COMMENT '板块id',
    block_name STRING COMMENT '板块名称',
    school_name STRING COMMENT '学校名称',
    counterpart_school STRING COMMENT '对口学校',
    school_stage STRING COMMENT '学校阶段',
    school_level STRING COMMENT '学校等级',
    school_type STRING COMMENT '学校类型',
    community_school_distince STRING COMMENT '小区学校距离',
    timestamp_v timestamp COMMENT '数据处理时间'
) COMMENT '学区房数据表'  STORED AS TEXTFILE;
