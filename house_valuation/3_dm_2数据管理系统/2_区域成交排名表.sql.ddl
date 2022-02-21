create table dm_evaluation.deal_month_rank_district
(
    month             String COMMENT '月份',
    city_cd           String COMMENT '城市编码',
    district_cd       String COMMENT '区域编码',
    district_name     String COMMENT '区域名称',
    district_deal_cnt String COMMENT '区域成交量',
    ranks             String COMMENT '排名',
    timestamp_v       timestamp COMMENT '数据处理时间'
)COMMENT '区域成交排名表'  STORED AS TEXTFILE;