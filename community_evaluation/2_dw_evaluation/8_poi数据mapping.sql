
--由于爬虫直接爬取到的三甲医院数虚高,这里取去重后的三甲医院数
insert overwrite table wrk_evaluation.community_poi_info
select
    a.city
     ,a.title_id
     ,a.title
     ,a.gd_location
     ,a.gd_lng
     ,a.gd_lat
     ,a.subway_station_num
     ,a.subway_station_radius
     ,a.bus_stop_num
     ,a.bus_stop_radius
     ,a.shop_station_num
     ,a.shop_station_radius
     ,cast(b.hospital_station_num as string) hospital_station_num
     ,b.hospital_station_radius
from ods_house.ods_pyspider_db_poi_source_community a
         left join ods_evaluation.community_hospital_info b
                   on a.title_id = b.title_id
where a.city in ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都'
    ,'贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春'
    ,'长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
;


insert overwrite table dw_evaluation.community_evaluation_poi_info
select
    distinct
    t2.city_name,
    t2.district_name,
    t2.block_name,
    cast(t2.community_id as STRING) as community_id,
    t2.community_name,
    t1.subway_station_num,
    t1.subway_station_radius,
    t1.bus_stop_num,
    t1.bus_stop_radius,
    t1.shop_station_num,
    t1.shop_station_radius,
    t1.hospital_station_num,
    t1.hospital_station_radius
from wrk_evaluation.community_poi_info t1
         inner join ods_house.ods_house_asset_community t2
                    on t1.city=t2.city_name
                        and t1.title_id = cast(t2.community_id as STRING )
where t1.city in ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都','贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春','长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
