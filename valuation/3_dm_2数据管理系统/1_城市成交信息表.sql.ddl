create table dm_evaluation.deal_month_city
(
    month                String COMMENT '月份',
    city_cd              String COMMENT '城市编码',
    city_name            String COMMENT '城市名称',
    deal_avg_price       String COMMENT '成交均价',
    deal_avg_price_month String COMMENT '成交均价环比',
    deal_cnt             String COMMENT '成交量',
    deal_community_cnt   String COMMENT '成交小区数',
    deal_agency_cnt      String COMMENT '成交经纪公司数',
    timestamp_v          timestamp COMMENT '数据处理时间'
)COMMENT '城市成交信息表'  STORED AS TEXTFILE;