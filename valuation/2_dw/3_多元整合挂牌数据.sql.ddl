create table dw_evaluation.house_valuation_rack_detail
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
        t1.rack_info_src,
        t1.rack_house_id,
        t1.house_verification_code,
        t1.house_listed_time,
        t1.source_community_id,
        t1.source_community_name,
        t1.source_community_addr,
        t1.house_avg_price,
        t1.house_price,
        t1.house_room,
        t1.house_hall,
        t1.house_toilet,
        t1.house_layout,
        t1.house_property_area,
        t1.house_orient,
        t1.house_floor_level,
        t1.house_floor_str,
        t1.room_rack_type,
        t1.month_dt,
        t2.bk_interval,
        t2.min_interval,
        t2.max_interval
from asset_esf.multi_room_rack_price_month_all t1
left join ods_evaluation.house_valuation_bk_interval t2
on t1.city_name = t2.city_name
where t1.house_property_area > t2.min_interval
  and t1.house_property_area < t2.max_interval
