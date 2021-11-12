create table dw_evaluation.house_valuation_community_detail as
select
    city_cd,
    city_name,
    district_cd,
    district_name,
    block_cd,
    block_name,
    community_id,
    community_name,
    community_addr,
    gaode_fence as community_fence,
    concat(gaode_lng,',',gaode_lat) as community_coordinate,
    current_timestamp() as timestamp_v
from eju_ods.ods_house_asset_community t1
where t1.city_name in ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波','佛山')
  and t1.del_ind <> 1
  and t1.upper_lower_ind = 1

create table dw_evaluation.house_valuation_building_detail as
    select
        city_cd,
        building_id,
        community_id,
        building_name,
        floor_num,
        substring(current_timestamp(),1,4) - case when t1.build_year<> '0' and t1.build_year <> '' then null else build_year then building_age,
        current_timestamp() as timestamp_v
from eju_ods.ods_house_asset_building t1

