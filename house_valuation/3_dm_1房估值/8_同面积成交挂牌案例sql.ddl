truncate table dm_evaluation.house_valuation_analysis_same_community_deal;
drop table dm_evaluation.house_valuation_analysis_same_community_deal;
create table dm_evaluation.house_valuation_analysis_same_community_deal
(
    community_id  String COMMENT '小区id',
    area_interval String COMMENT '面积区间',
    type          String COMMENT '类型、成交/挂牌',
    date          String COMMENT '日期',
    layout        String COMMENT '户型',
    area          String COMMENT '面积',
    total_price   String COMMENT '总价',
    avg_price     String COMMENT '单价',
    timestamp_v   String COMMENT '数据处理时间',
    batch_no      String COMMENT '批次号'
)COMMENT '同面积成交挂牌案例' STORED AS TEXTFILE;
