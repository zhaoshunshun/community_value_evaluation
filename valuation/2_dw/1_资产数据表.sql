create table dw_evaluation.house_valuation_community_detail as
    insert overwrite table dw_evaluation.house_valuation_community_detail
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
       case when t1.build_max_year <> '' and t1.build_min_year <>'' and t1.build_max_year <> t1.build_min_year then concat(t1.build_min_year,'-',t1.build_max_year) end as building_year,
    gaode_fence as community_fence,
    concat(gaode_lng,',',gaode_lat) as community_coordinate,
    current_timestamp() as timestamp_v
from eju_ods.ods_house_asset_community t1
where t1.city_name in ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波','佛山','深圳','福州','南宁','长沙','南昌','银川','中山','兰州','长春','贵阳','徐州','石家庄','惠州')
  and t1.del_ind <> 1
  and t1.upper_lower_ind = 1

create table dw_evaluation.house_valuation_building_detail as
    insert overwrite table dw_evaluation.house_valuation_building_detail
    select
        city_cd,
        building_id,
        community_id,
        building_name,
        floor_num,
        case when t1.build_year <> '0' and t1.build_year <>'' then t1.build_year else null end as building_year,
        substring(current_timestamp(),1,4) - (case when t1.build_year<> '0' and t1.build_year <> '' then  t1.build_year else null end) as building_age,
        current_timestamp() as timestamp_v
from eju_ods.ods_house_asset_building t1
where t1.city_cd in ('1201','2101','3201','3203','3205','3302','3401','3502','3601','4101','4301','4406','4413','4420','4501','5001','5201','6101','1101','1301','2201','3101','3202','3301','3501','3701','4201','4401','4403','5101','5301','6201','6401')

