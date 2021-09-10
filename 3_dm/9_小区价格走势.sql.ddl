truncate table dm_evaluation.community_month_price_report;
drop table dm_evaluation.community_month_price_report;
create table dm_evaluation.community_month_price_report
(
    community_id STRING COMMENT '小区id',
    district_cd STRING COMMENT '区域id',
    district_name STRING COMMENT '区域名称',
    month STRING COMMENT '月份',
    community_avg_price STRING COMMENT '小区均价',
    district_avg_price STRING COMMENT '区域均价',
    batch_no STRING COMMENT '批次号',
    timestamp_v timestamp COMMENT '数据处理时间'
)COMMENT '小区价格走势表' STORED AS TEXTFILE;