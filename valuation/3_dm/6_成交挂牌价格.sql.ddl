
create table dm_evaluation.house_valuation_analysis_same_community_price(
goods_id String COMMENT '房源id',
type String COMMENT '成交/挂牌',
community_id String COMMENT '小区id',
area_interval String COMMENT '面积段',
rack_price String COMMENT '挂牌价/成交价',
community_rack_cnt String COMMENT '小区挂牌量',
community_goods_rank String COMMENT '小区房源挂牌价格排名',
community_deal_cnt String COMMENT '小区成交量',
community_deal_rank String COMMENT '小区成交价格排名',
community_deal_med String COMMENT '小区成交价格中位数',
timestamp_v String COMMENT '数据处理时间'
)COMMENT '成交挂牌价格' STORED AS TEXTFILE;

