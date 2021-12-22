truncate table dm_evaluation.house_valuation_analysis_same_community_rate;
drop table dm_evaluation.house_valuation_analysis_same_community_rate;
create table dm_evaluation.house_valuation_analysis_same_community_rate
(
    community_id            String COMMENT '小区id',
    area_interval           String COMMENT '面积区间',
    community_rack_cnt      String COMMENT '小区挂牌量',
    community_rack_cnt_rank String COMMENT '小区挂牌量排名',
    rack_avg_price          String COMMENT '小区挂牌均价',
    community_deal_cnt      String COMMENT '小区成交量',
    community_deal_cnt_rank String COMMENT '小区成交量排名',
    deal_avg_price          String COMMENT '小区成交均价',
    timestamp_v             String COMMENT '数据处理时间',
    batch_no                String COMMENT '批次号'
)COMMENT '同面积成交挂牌占比' STORED AS TEXTFILE;
