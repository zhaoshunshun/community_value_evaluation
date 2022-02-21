truncate table dm_evaluation.community_evaluation_city_analysis_report;
drop table if exists dm_evaluation.community_evaluation_city_analysis_report;
create table dm_evaluation.community_evaluation_city_analysis_report
(
    month          STRING COMMENT '月份',
    city_id        STRING COMMENT '城市id',
    city_name      STRING COMMENT '城市名称',
    list_cnt       STRING COMMENT '挂牌套数',
    deal_cnt       STRING COMMENT '成交套数',
    list_avg_price STRING COMMENT '挂牌均价',
    deal_avg_price STRING COMMENT '成交均价',
    list_up_rate   STRING COMMENT '挂牌涨价房源占比',
    list_down_rate STRING COMMENT '挂牌降价房源占比',
    timestamp_v    TIMESTAMP COMMENT '数据处理时间'
) COMMENT '城市房源分析报表'  STORED AS TEXTFILE;
