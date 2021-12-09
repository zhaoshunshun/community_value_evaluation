
create table dm_evaluation.house_valuation_analysis_goods_rank(
goods_id String COMMENT '房源id',
goods_price String COMMENT '房源挂单价牌价',
community_id String COMMENT '小区id',
block_cd String COMMENT '板块id',
community_avg_price String COMMENT '小区均价',
block_avg_price String COMMENT '板块均价',
block_avg_price_rank String COMMENT '板块内房源单价排名',
block_rack_cnt String COMMENT '板块内房源挂牌总量',
block_median_rack_price String COMMENT '板块挂牌价中位数',
block_community_cnt String COMMENT '板块内小区数量',
block_community_avg_price_rank String COMMENT '板块内小区均价排名',
block_med_community_avg_price String COMMENT '板块内小区均价中位数',
district_cd String COMMENT '区域id',
district_avg_price_rank String COMMENT '区域内房源均价排名',
timestamp_v String COMMENT '数据处理时间'
) COMMENT '价格排名表' STORED AS TEXTFILE;



--排名：价格是从小到大排，数量是从大到小排