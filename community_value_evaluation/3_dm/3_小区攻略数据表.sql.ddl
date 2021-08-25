
create table dm_evaluation.community_month_report_strategy
(
    community_id STRING COMMENT '小区id',
    community_desc STRING COMMENT '小区描述(数据来源贝壳攻略)',
    live_population STRING COMMENT '小区居住人群',
    atmosphere STRING COMMENT '小区氛围',
    property_services STRING COMMENT '小区物业服务',
    parking_conditions STRING COMMENT '小区停车情况',
    advantage STRING COMMENT '小区优点',
    shortcoming STRING COMMENT '小区缺点',
    proprietor_speak STRING COMMENT '业主说',
    facilities STRING COMMENT '小区内部配套list',
    facilities_desc STRING COMMENT '小区内部配套描述',
    batch_no STRING COMMENT '批次号',
    timestamp_v timestamp COMMENT '数据处理时间'
) COMMENT '小区攻略数据表'  STORED AS TEXTFILE;


