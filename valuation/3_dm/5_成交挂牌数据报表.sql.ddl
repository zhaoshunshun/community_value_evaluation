
create table dm_evaluation.house_valuation_analysis_same_community_report
(
    month                      String COMMENT '月份',
    community_id               String COMMENT '小区id',
    community_name             String COMMENT '小区名称',
    block_cd                   String COMMENT '板块id',
    area_interval              String COMMENT '面积区域',
    community_rack_cnt         String COMMENT '小区挂牌量',
    community_rack_cnt_month   String COMMENT '小区挂牌量环比',
    community_rack_cnt_year   String COMMENT  '小区挂牌量同比',
    community_deal_cnt         String COMMENT '小区成交量',
    community_deal_cnt_month   String COMMENT '小区成交量环比',
    community_deal_cnt_year   String COMMENT  '小区成交量同比',
    community_rack_price       String COMMENT '小区挂牌价格',
    block_community_rack_price String COMMENT '板块挂牌价格',
    community_deal_price       String COMMENT '小区成交价格',
    block_community_deal_price String COMMENT '板块成交价格',
    timestamp_v                String COMMENT '数据处理时间'
) COMMENT '成交挂牌数据报表' STORED AS TEXTFILE;

