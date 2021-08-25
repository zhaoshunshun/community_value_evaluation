
truncate table ods_evaluation.cric_deal_detail;
drop table ods_evaluation.cric_deal_detail;
create table  ods_evaluation.cric_deal_detail
(
    citycaption STRING comment '城市名称',
    region STRING comment '区域名称',
    projectcaption STRING comment '项目名称',
    tradearea STRING comment '成交面积',
    roomusage STRING comment '物业类型',
    trademoney STRING comment '成交总价',
    developer STRING comment '开发商',
    community_name STRING comment '小区名称',
    community_addr STRING comment '小区地址',
    community_no STRING comment '小区mapping码',
    new_tradedate STRING comment '成交时间',
    create_time STRING comment '创建时间',
    itemid STRING comment '小区id'
) COMMENT '克而瑞成交数据'
    STORED AS TEXTFILE;