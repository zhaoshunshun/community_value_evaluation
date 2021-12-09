create table dm_evaluation.house_valuation_area_interval(
id String COMMENT 'id',
city_name String COMMENT '城市名称',
bk_interval String COMMENT '面积区间',
min_area String COMMENT '面积最小值',
max_area String COMMENT '面积最大值',
timestamp_v String COMMENT '数据处理时间'
)COMMENT '面积区间表' STORED AS TEXTFILE;