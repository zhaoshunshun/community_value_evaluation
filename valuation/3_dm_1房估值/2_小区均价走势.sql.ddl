create table dm_evaluation.house_valuation_analysis_report(
month String COMMENT '月份',
community_id String COMMENT '小区id',
community_avg_price String COMMENT '小区均价',
block_avg_price String COMMENT '板块均价',
district_avg_price String COMMENT '区域均价',
community_current_avg_price String COMMENT '小区当前价格',
community_price_month String COMMENT '小区均价环比',
community_price_half_year String COMMENT '小区均价半年环比',
timestamp_v String COMMENT '数据处理时间'
)COMMENT '小区均价走势' STORED AS TEXTFILE;

