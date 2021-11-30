

insert overwrite table dm_evaluation.house_valuation_analysis_same_community_detail
select
t1.rack_house_id,
t1.community_id,
t1.city_name,
t1.district_name,
t1.house_layout as layout,
t1.house_avg_price as avg_price,
t1.house_price as total_price,
t1.house_property_area as area,
t1.house_orient as toward,
t1.house_floor_str as  floor,
case when t1.house_listed_time is null or t1.house_listed_time='' then t1.dt else t1.house_listed_time end as rack_date,
t2.building_year as building_year,
t1.house_fitment_name as fitment,
t1.elevator as elevator,
t1.ladder_ratio as elevator_desc,
current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_rack_detail t1
left join dw_evaluation.house_valuation_community_detail t2
on t1.community_id = t2.community_id
