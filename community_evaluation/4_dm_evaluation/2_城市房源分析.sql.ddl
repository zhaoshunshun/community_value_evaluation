truncate table dm_evaluation.community_evaluation_city_analysis;
drop table if exists dm_evaluation.community_evaluation_city_analysis;
create table dm_evaluation.community_evaluation_city_analysis
(
    month                     STRING COMMENT '月份',
    city_id                   STRING COMMENT '城市id',
    city_name                 STRING COMMENT '城市名称',
    list_cnt                  STRING COMMENT '挂牌套数',
    list_year_rate            STRING COMMENT '挂牌套数同比',
    list_month_rate           STRING COMMENT '挂牌套数环比',
    deal_cnt                  STRING COMMENT '成交套数',
    deal_year_rate            STRING COMMENT '成交套数同比',
    deal_month_rate           STRING COMMENT '成交套数环比',
    demand_type               STRING COMMENT '供求走势类型',
    list_avg_price            STRING COMMENT '挂牌均价',
    list_avg_price_year_rate  STRING COMMENT '挂牌均价同比',
    list_avg_price_month_rate STRING COMMENT '挂牌均价环比',
    list_change_type          STRING COMMENT '挂牌均价涨幅类型',
    deal_avg_price            STRING COMMENT '成交均价',
    deal_avg_price_year_rate  STRING COMMENT '成交均价同比',
    deal_avg_price_month_rate STRING COMMENT '成交均价环比',
    deal_change_type          STRING COMMENT '成交均价涨幅类型',
    list_up_rate              STRING COMMENT '挂牌涨价房源占比',
    list_up_rate_year_rate    STRING COMMENT '挂牌涨价房源的同比',
    list_up_rate_month_rate   STRING COMMENT '挂牌涨价房源的环比',
    list_down_rate            STRING COMMENT '挂牌降价房源占比',
    list_down_rate_year_rate  STRING COMMENT '挂牌降价房源的同比',
    list_down_rate_month_rate STRING COMMENT '挂牌降价房源的环比',
    list_change_trend_type    STRING COMMENT '挂牌调价走势类型',
    timestamp_v               timestamp COMMENT '数据处理时间'
) COMMENT '城市房源分析'  STORED AS TEXTFILE;
