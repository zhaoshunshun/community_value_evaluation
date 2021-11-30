create table dm_evaluation.house_valuation_area_interval(
id String COMMENT 'id',
city_name String '城市名称',
bk_interval String '面积区间',
min_area String '面积最小值',
max_area String '面积最大值',
timestamp_v String COMMENT '数据处理时间'
)COMMENT '面积区间表' STORED AS TEXTFILE;


insert overwrite table dm_evaluation.house_valuation_area_interval
select
t1.id,
t1.city_name,
t1.bk_interval as bk_interval,
t1.min_interval as min_area,
t1.max_interval as max_area,
current_timestamp() as timestamp_v
from ods_evaluation.house_valuation_bk_interval t1
