--计算
insert overwrite table dw_evaluation.community_evaluation_building_density_by_city
select
    city_cd,
    city_name,
    percentile_approx(volume_rate,0.5) as volume_rate_percentile_approx
from ods_house.ods_house_asset_community t1
where t1.city_name in ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都','贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春','长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
  and del_ind <> 1 and upper_lower_ind = 1 group by t1.city_cd,t1.city_name;
