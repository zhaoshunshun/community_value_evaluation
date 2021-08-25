truncate table ods_evaluation.community_evaluation_month_strategy;
drop table if exists ods_evaluation.community_evaluation_month_strategy;
create table ods_evaluation.community_evaluation_month_strategy
(
    title_id STRING COMMENT '小区id',
    title STRING COMMENT '小区名称',
    city STRING COMMENT '城市名称',
    comm1  STRING COMMENT 'comm1',
    comm2  STRING COMMENT 'comm2',
    comm3  STRING COMMENT 'comm3',
    comm4  STRING COMMENT 'comm4',
    comm5  STRING COMMENT 'comm5',
    comm6  STRING COMMENT 'comm6',
    comm7  STRING COMMENT 'comm7',
    comm8  STRING COMMENT 'comm8',
    comm9  STRING COMMENT 'comm9',
    comm10 STRING COMMENT 'comm10',
    community_desc STRING COMMENT '小区描述',
    live_population STRING COMMENT '居住人群',
    atmosphere STRING COMMENT '小区氛围',
    property_services STRING COMMENT '小区物业服务',
    parking_conditions STRING COMMENT '小区停车情况',
    advantage STRING COMMENT '小区优点',
    shortcoming STRING COMMENT '小区缺点',
    proprietor_speak STRING COMMENT '业主说',
    facilities_desc STRING COMMENT '内部配套描述',
    timestamp_v timestamp COMMENT '数据处理时间'
) COMMENT '小区攻略表'  STORED AS TEXTFILE;



