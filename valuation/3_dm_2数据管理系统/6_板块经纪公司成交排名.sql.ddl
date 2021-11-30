create table dm_evaluation.deal_month_agency_rank_block
(
    month       String COMMENT '月份',
    city_cd     String COMMENT '城市编码',
    district_cd String COMMENT '区域编码',
    block_cd    String COMMENT '板块编码',
    block_name  String COMMENT '板块名称',
    agency_name String COMMENT '经纪公司',
    deal_cnt    String COMMENT '成交量',
    ranks       String COMMENT '排名',
    timestamp_v timestamp COMMENT '数据处理时间'
)COMMENT '板块经纪公司成交排名表'  STORED AS TEXTFILE;

