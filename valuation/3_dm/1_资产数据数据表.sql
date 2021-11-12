create table dm_evaluation.house_valuation_floor
as
    select
        t1.city_cd,
        t1.city_name,
        t1.district_cd,
        t1.district_name,
        t1.block_cd,
        t1.block_name,
        t1.community_id,
        t1.community_name,
        t1.community_addr,
        t1.community_fence,
        t1.community_coordinate,
        t2.building_id,
        t2.building_name,
        t2.floor_num as highest_floor,
        t2.building_age,
        t3.monthly_avg_price_desc as avg_price,
        current_timestamp() timestamp_v
from dw_evaluation.house_valuation_community_detail t1
left join dw_evaluation.house_valuation_building_detail t2
on t1.community_id  = t2.community_id
left join dw_evaluation.house_valuation_community_month_price t3
on t.community_id = t2.community_id
and t3.ranks =1



