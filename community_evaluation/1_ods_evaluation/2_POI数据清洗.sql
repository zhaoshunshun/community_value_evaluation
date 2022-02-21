truncate table ods_evaluation.community_hospital_info;
drop table ods_evaluation.community_hospital_info;
create table ods_evaluation.community_hospital_info as
--insert overwrite table ods_evaluation.community_hospital_info
select
    a.city_name_new as city
     ,a.title_id
     ,a.title
     ,count(1) hospital_station_num
     ,'2000' hospital_station_radius
from
    (
        select
            a.*
             ,row_number() over(partition by a.title_id,a.city_code,a.adcode,a.business_area,a.name_new order by a.name asc) rn_2
        from
            (
                select
                    a.*
                     ,nvl(b.city_cd,a.city_code)   city_cd_new
                     ,nvl(b.city_name,regexp_replace(a.city_name,'市','')) city_name_new
                     ,case when name like '%医院%' then substr(name,1,instr(name,'医院')+5) else name end name_new
                     ,row_number() over(partition by a.title_id,a.grid_code
                    order by length(case when name like '%医院%' then substr(name,1,instr(name,'医院')+5) else name end) asc
                        ,length(a.address) asc
                        ,name asc
                    ) rn --按照grid_code去重,优先取截断'医院'文本后内容的 name_new 最短,且地址最短,原始医院名称最短
                from ods_house.ods_pyspider_db_poi_map_community a
                         left join dw_house.dw_city b
                                   on substr(a.adcode,1,4) = b.city_cd
                                       and b.city_name in ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都'
                                           ,'贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春'
                                           ,'长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
                where type_code = '090101'
                  and (b.city_name is not null or a.uid in ('B0017819L5','B001709XZ7') ) --这2个uid区域code
            ) a
        where a.rn = 1
    ) a
where a.rn_2 = 1
group by a.city_name_new
       ,a.title_id
       ,a.title
;


