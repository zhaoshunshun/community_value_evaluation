
insert overwrite table dm_evaluation.house_valuation_area_interval
select
t1.id,
t1.city_name,
t1.bk_interval as bk_interval,
t1.min_interval as min_area,
t1.max_interval as max_area,
current_timestamp() as timestamp_v
from ods_evaluation.house_valuation_bk_interval t1
