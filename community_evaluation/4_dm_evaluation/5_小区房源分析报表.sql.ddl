truncate table dm_evaluation.community_evaluation_analysis_report;
drop table if exists dm_evaluation.community_evaluation_analysis_report;
create table dm_evaluation.community_evaluation_analysis_report
    (
        month          STRING COMMENT '月份',
        city_id        STRING COMMENT '城市id',
        city_name      STRING COMMENT '城市名称',
        community_id   STRING COMMENT '小区id',
        community_name STRING COMMENT '小区名称',
        list_cnt       STRING COMMENT '挂牌套数',
        deal_cnt       STRING COMMENT '成交套数',
        list_avg_price STRING COMMENT '挂牌均价',
        deal_avg_price STRING COMMENT '成交均价',
        timestamp_v    timestamp COMMENT '数据处理时间'
    ) COMMENT '小区房源分析报表'  STORED AS TEXTFILE;