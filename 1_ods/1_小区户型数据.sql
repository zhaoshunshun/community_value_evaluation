insert overwrite table ods_evaluation.community_evaluation_month_layout
select t1.source_community_id,
    t1.source_community_name,
    t1.city_cd,
    t1.city_name,
    t1.district_cd,
    t1.district_name,
    t1.block_cd,
    t1.block_name,
    t1.house_layout_name,
    t1.house_layout_no,
    regexp_extract(t1.house_layout_name,'([0-9]+室)(.*)',1) as house_cnt,
    cast(t1.build_area as decimal(11,2)) as build_area,
            current_timestamp() as timestamp_v
from dm_house.dm_community_layout_all t1
where house_layout_name like '%室%'
  and info_src in ('BK', 'BK_XF')
and cast(t1.build_area as decimal(11,2)) <10000
;