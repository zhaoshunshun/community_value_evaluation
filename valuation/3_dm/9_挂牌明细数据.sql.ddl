
create table dm_evaluation.house_valuation_analysis_same_community_detail(
goods_id String COMMENT '房源id',
community_id String COMMENT '小区id',
building_id String COMMENT '楼栋id',
city_name String COMMENT '城市名称',
district_name String COMMENT '区域名称',
layout String COMMENT '户型',
avg_price String COMMENT '均价',
total_price String COMMENT '总价',
area String COMMENT '面积',
toward String COMMENT '朝向',
floor String COMMENT '楼层',
rack_date String COMMENT '挂牌时间',
building_year String COMMENT '建筑年代',
fitment String COMMENT '装修程度',
elevator String COMMENT '电梯有无',
elevator_desc String COMMENT '梯户情况',
subway_dis String COMMENT '距离地铁',
timestamp_v String COMMENT '数据处理时间'
)COMMENT '挂牌明细数据' STORED AS TEXTFILE;
