create table dm_evaluation.house_valuation_floor(
city_cd String COMMENT '城市编码',
city_name String COMMENT '城市名称',
district_cd String COMMENT '区域编码',
district_name String COMMENT '区域名称',
block_cd String COMMENT '板块编码',
block_name String COMMENT '板块名称',
community_id String COMMENT '小区id',
community_name String COMMENT '小区名称',
community_addr String COMMENT '小区地址',
community_fence String COMMENT '小区围栏',
community_coordinate String COMMENT '小区坐标',
building_id String COMMENT '楼栋id',
building_name String COMMENT '楼栋名称',
highest_floor String COMMENT '楼层',
building_age String COMMENT '楼龄',
avg_price String COMMENT '小区均价',
timestamp_v String COMMENT '数据处理时间'
)COMMENT '前端录入表'  STORED AS TEXTFILE;



