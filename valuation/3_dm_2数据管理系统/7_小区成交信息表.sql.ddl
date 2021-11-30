
truncate table dm_evaluation.deal_month_community;
drop table dm_evaluation.deal_month_community;
create table dm_evaluation.deal_month_community
(
    month             String COMMENT '月份',
    community_id      String COMMENT '小区id',
    community_name    String COMMENT '小区名称',
    community_address String COMMENT '小区地址',
    city_cd           String COMMENT '城市编码',
    city_name         String COMMENT '城市名称',
    district_cd       String COMMENT '区域id',
    district_name     String COMMENT '区域名称',
    block_cd          String COMMENT '板块id',
    block_name        String COMMENT '板块名称',
    deal_cnt          String COMMENT '成交量',
    deal_avg_price    String COMMENT '成交均价',
    info_src          String COMMENT '数据来源',
    ranks             String COMMENT '排序',
    timestamp_v       timestamp COMMENT '数据处理时间'
)COMMENT '小区成交信息表'  STORED AS TEXTFILE;


