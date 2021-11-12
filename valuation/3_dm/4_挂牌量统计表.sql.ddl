

create table dm_evaluation.house_valuation_analysis_community_rank(
community_id String COMMENT '小区id',
district_cd String COMMENT '区域id',
block_cd String COMMENT '板块id',
community_rack_cnt String COMMENT '小区挂牌量',
block_community_rack_rank String COMMENT '板块内小区挂牌排名',
block_med_community_rack_cnt String COMMENT '板块内小区挂牌量中位数',
district_rack_cnt String COMMENT '区域内挂牌总量',
district_block_rack_cnt_rank String COMMENT '板块在区域内的挂牌量排名',
district_min_block_rack_cnt String COMMENT '板块在区域内的挂牌量最少',
district_med_block_rack_cnt String COMMENT '板块在区域内的挂牌量中位数',
district_max_block_rack_cnt String COMMENT '板块在区域内的挂牌量最高',
timestamp_v String COMMENT '数据处理时间'
) COMMENT '挂牌量统计表' STORED AS TEXTFILE;




