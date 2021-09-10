create table dm_evaluation.community_month_deal_report
(
    community_id STRING COMMENT '小区id',
    district_cd STRING COMMENT '区域id',
    district_name STRING COMMENT '区域名称',
    month STRING COMMENT '月份',
    community_deal_cnt STRING COMMENT '小区成交量',
    district_deal_cnt STRING COMMENT '区域成交量',
    batch_no STRING COMMENT '批次号',
    timestamp_v timestamp COMMENT '数据处理时间'
)COMMENT '小区成交走势表' STORED AS TEXTFILE;


