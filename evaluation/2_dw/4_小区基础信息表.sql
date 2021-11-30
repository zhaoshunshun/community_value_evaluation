
truncate table dw_evaluation.community_month_report_base_info;
drop table dw_evaluation.community_month_report_base_info;
create table dw_evaluation.community_month_report_base_info as

insert overwrite table dw_evaluation.community_month_report_base_info
select
    t1.community_id,
    t1.community_name,
    t1.city_cd,
    t1.city_name,
    t1.district_cd,
    t1.district_name,
    t1.block_cd,
    t1.block_name,
    t1.community_addr as addr,
    concat_ws(',',cast(cast(t1.gaode_lng as  decimal(10,6)) as String),cast(cast(t1.gaode_lat as  decimal(10,6)) as String)) as coordinate,
    t1.gaode_fence  as fence,
    case when t1.build_min_year= t1.build_max_year then t1.build_min_year
         else concat(t1.build_min_year,'-',t1.build_max_year) end as building_year,
    t1.building_num,
    t1.build_area as building_area,
    coalesce(t1.house_num,t5.cnt) as room_num,
    t1.property_type,
    concat(regexp_extract(t1.property_fee,'([0-9-.]+)(.*)',1),'元/月/㎡') as property_fee,
    t1.developer_corp as developers,
    t1.property_name as property_company,
    t1.volume_rate,
    t1.green_rate,
    concat(cast(regexp_replace(split(t1.parking_rate,':')[0],'1.00','1') as String),':',cast(cast(split(t1.parking_rate,':')[1] as DECIMAL(8,4)) as String))as parking_rate,
    t1.person_div_car_ind,
    substring(current_timestamp(),1,4) - t1.build_min_year as building_age,
    null as elevator_desc,
    null as block_elevator_desc,
       case when  t1.volume_rate is null then 0 else 1 end +
        case when t1.green_rate is null then 0 else 1 end +
        case when concat(regexp_replace(split(t1.parking_rate,':')[0],'1.00','1'),':',cast(split(t1.parking_rate,':')[1] as DECIMAL(8,4))) is null then 0 else 1 end +
        case when cast(substring(current_timestamp(),1,4) - round((t1.build_min_year+t1.build_max_year)/2) as STRING) is null then 0 else 1 end as score,
    current_timestamp() as timestamp_v
from eju_ods.ods_house_asset_community t1
    left join (
    select
    community_id,
    count(1) as cnt
    from
    eju_ods.ods_house_asset_room
    where del_ind <> 1
    group by community_id
    ) t5
    on t1.community_id = t5.community_id
where t1.city_name in  ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波','佛山','深圳','福州','南宁','长沙','南昌','银川','中山','兰州','长春','贵阳','徐州','石家庄','惠州')
  and t1.del_ind <> 1
  and t1.upper_lower_ind = 1
and t1.block_cd <> ''




