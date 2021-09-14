
truncate table wrk_evaluation.evaluation_community_mon_report_facilitate_01;
drop table wrk_evaluation.evaluation_community_mon_report_facilitate_01;
create table wrk_evaluation.evaluation_community_mon_report_facilitate_01
as
    insert overwrite table wrk_evaluation.evaluation_community_mon_report_facilitate_01
    select t1.* from (
        select community_id,
            community_coordinate,
            case when types = '150500' then '1km地铁'
                 when types = '090101' then '1km三甲医院'
                 when types = '综合医院|专科医院' then '1km医院'
                 when types = '060100' then '1km购物中心'
                 when types = '110101' then '1km公园'
                 when types = '150700' then '1km公交'
                 when types = '141204' then '1km幼儿园'
                 when types = '141203' then '1km小学'
                 when types = '141202' then '1km中学'
                 when types = '060400' then '1km超市'
                 when types = '电影院' then '1km电影院'
                 when types = '咖啡厅' then '1km咖啡馆'
                end as types,
            count,
            case when types= '150700' then address
                when types = '150500'  then concat(address,name)
                else name end as name,
               distance,
            row_number() over (partition by community_id,types,name order by create_time desc) as ranks
        from ods_evaluation.ods_community_evaluation_community_mon_report_facilitate
    ) t1
where t1.ranks = 1
and t1.name is not null
and t1.name <> ''


truncate table wrk_evaluation.evaluation_community_mon_report_facilitate_02;
drop table wrk_evaluation.evaluation_community_mon_report_facilitate_02;
create table wrk_evaluation.evaluation_community_mon_report_facilitate_02
as
    insert overwrite table wrk_evaluation.evaluation_community_mon_report_facilitate_02
select
    community_id,
    community_coordinate,
    types,
    count,
    concat_ws(';',collect_set(name)) as name,
    min(cast(distance as int)) as distance,
    current_timestamp() as timestamp_v
from  wrk_evaluation.evaluation_community_mon_report_facilitate_01 t1
group by
    community_id,
    community_coordinate,
    types,
    count

truncate table wrk_evaluation.evaluation_community_mon_report_facilitate_03;
drop table wrk_evaluation.evaluation_community_mon_report_facilitate_03;
create table wrk_evaluation.evaluation_community_mon_report_facilitate_03
as
    insert overwrite table wrk_evaluation.evaluation_community_mon_report_facilitate_03
select
    community_id,
    max(case when types ='1km地铁' then count end ) as subway_1km_cnt,
    max(case when types ='1km地铁' then name end ) as subway_1km_name,
    max(case when types ='1km三甲医院' then count end ) as three_hospital_1km_cnt,
    max(case when types ='1km三甲医院' then name end ) as three_hospital_1km_name,
    max(case when types ='1km医院' then count end ) as hospital_1km_cnt,
    max(case when types ='1km医院' then name end ) as hospital_1km_name,
    max(case when types ='1km购物中心' then count end ) as shopping_1km_cnt,
    max(case when types ='1km购物中心' then name end ) as shopping_1km_name,
    max(case when types ='1km公园' then count end ) as greenland_1km_cnt,
    max(case when types ='1km公园' then name end ) as greenland_1km_name,
    max(case when types ='1km公交' then count end ) as bus_1km_cnt,
    max(case when types ='1km公交' then name end ) as bus_1km_name,
    max(case when types ='1km幼儿园' then count end ) as nursery_1km_cnt,
    max(case when types ='1km幼儿园' then name end ) as nursery_1km_name,
    max(case when types ='1km小学' then count end ) as primary_1km_cnt,
    max(case when types ='1km小学' then name end ) as primary_1km_name,
    max(case when types ='1km中学' then count end ) as middle_1km_cnt,
    max(case when types ='1km中学' then name end ) as middle_1km_name,
    max(case when types ='1km超市' then count end ) as supermarket_1km_cnt,
    max(case when types ='1km超市' then name end ) as supermarket_1km_name,
    max(case when types ='1km电影院' then count end ) as movie_1km_cnt,
    max(case when types ='1km电影院' then name end ) as movie_1km_name,
    max(case when types ='1km咖啡馆' then count end ) as coffee_1km_cnt,
    max(case when types ='1km咖啡馆' then name end ) as coffee_1km_name,
    min(case when types ='1km地铁' then distance end) as subway_nearby_distince
from wrk_evaluation.evaluation_community_mon_report_facilitate_02
group by community_id



truncate table dw_evaluation.community_month_report_convenient_info;
drop table dw_evaluation.community_month_report_convenient_info;
create table dw_evaluation.community_month_report_convenient_info as
    insert overwrite table dw_evaluation.community_month_report_convenient_info
select
    t1.community_id,
    t1.city_cd,
    t1.city_name,
    t1.district_cd,
    t1.district_name,
    t2.subway_1km_cnt,
    t2.subway_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.subway_1km_cnt is null then 0 else t2.subway_1km_cnt end asc)/cnt as subway_1km_ranks,
    t2.three_hospital_1km_cnt,
    t2.three_hospital_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.three_hospital_1km_cnt is null then 0 else t2.three_hospital_1km_cnt end asc)/cnt as three_hospital_1km_ranks,
    t2.hospital_1km_cnt,
    t2.hospital_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.hospital_1km_cnt is null then 0 else t2.hospital_1km_cnt end asc)/cnt as hospital_1km_ranks,
    t2.shopping_1km_cnt,
    t2.shopping_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.shopping_1km_cnt is null then 0 else t2.shopping_1km_cnt end asc)/cnt as shopping_1km_ranks,
    t2.greenland_1km_cnt,
    t2.greenland_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.greenland_1km_cnt is null then 0 else t2.greenland_1km_cnt end asc)/cnt as greenland_1km_ranks,
    t2.bus_1km_cnt,
    case when t2.bus_1km_name like '%;%' then concat(split(t2.bus_1km_name,';')[0],';',split(t2.bus_1km_name,';')[1])
        else t2.bus_1km_name end as bus_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.bus_1km_cnt is null then 0 else t2.bus_1km_cnt end asc)/cnt as bus_1km_ranks,
    t2.nursery_1km_cnt,
    t2.nursery_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.nursery_1km_cnt is null then 0 else t2.nursery_1km_cnt end asc)/cnt as nursery_1km_ranks,
    t2.primary_1km_cnt,
    t2.primary_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.primary_1km_cnt is null then 0 else t2.primary_1km_cnt end asc)/cnt as primary_1km_ranks,
    t2.middle_1km_cnt,
    t2.middle_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.middle_1km_cnt is null then 0 else t2.middle_1km_cnt end asc)/cnt as middle_1km_ranks,
    t2.supermarket_1km_cnt,
    t2.supermarket_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.supermarket_1km_cnt is null then 0 else t2.supermarket_1km_cnt end asc)/cnt as supermarket_1km_ranks,
    t2.movie_1km_cnt,
    t2.movie_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.movie_1km_cnt is null then 0 else t2.movie_1km_cnt end asc)/cnt as movie_1km_ranks,
    t2.coffee_1km_cnt,
    t2.coffee_1km_name,
    rank() over (partition by t1.city_cd,t1.district_cd order by case when t2.coffee_1km_cnt is null then 0 else t2.coffee_1km_cnt end asc)/cnt as coffee_1km_ranks,
    t2.subway_nearby_distince
from dw_evaluation.community_month_report_base_info t1
     left join wrk_evaluation.evaluation_community_mon_report_facilitate_03  t2
     on t1.community_id = t2.community_id
left join (
    select district_cd ,count(1) as cnt from dw_evaluation.community_month_report_base_info group by district_cd
    ) t3
on t1.district_cd = t3.district_cd



truncate table wrk_evaluation.community_month_report_convenient_district_info_01;
drop table wrk_evaluation.community_month_report_convenient_district_info_01;
create table wrk_evaluation.community_month_report_convenient_district_info_01 as
    insert overwrite table wrk_evaluation.community_month_report_convenient_district_info_01
select
t2.city_cd,
t1.district_cd,
max(case when t1.types ='150500' then count end) as  sub_cnt,
max(case when t1.types ='090101' then count end) as  three_hospital_cnt,
max(case when t1.types ='综合医院|专科医院' then count end) as  hospital_cnt,
max(case when t1.types ='060100' then count end) as  shopping_cnt,
max(case when t1.types ='110101' then count end) as  greenland_cnt,
max(case when t1.types ='150700' then count end) as  bus_cnt,
max(case when t1.types ='141204' then count end) as  nursery_cnt,
max(case when t1.types ='141203' then count end) as  primary_cnt,
max(case when t1.types ='141202' then count end) as  middle_cnt,
max(case when t1.types ='060400' then count end) as  supermarket_cnt,
max(case when t1.types ='电影院' then count end) as  movie_cnt,
max(case when t1.types ='咖啡厅' then count end) as  coffee_cnt
from ods_evaluation.ods_community_evaluation_community_mon_district_crawl_data t1
         left join asset_common.ods_house_asset_district t2
                    on t1.district_cd = t2.district_cd
group by
    t2.city_cd,
    t1.district_cd

create table dw_evaluation.community_month_report_convenient_district_info as

    insert overwrite table dw_evaluation.community_month_report_convenient_district_info
    select
t1.city_cd,
t1.district_cd,
t1.sub_cnt,
rank() over (partition by t1.city_cd order by t1.sub_cnt)/district_cnt as sub_cnt_rank,
t1.three_hospital_cnt,
rank() over (partition by t1.city_cd order by t1.three_hospital_cnt)/district_cnt as three_hospital_cnt_rank,
t1.hospital_cnt,
rank() over (partition by t1.city_cd order by t1.hospital_cnt)/district_cnt as hospital_cnt_rank,
t1.shopping_cnt,
rank() over (partition by t1.city_cd order by t1.shopping_cnt)/district_cnt as shopping_cnt_rank,
t1.greenland_cnt,
rank() over (partition by t1.city_cd order by t1.greenland_cnt)/district_cnt as greenland_cnt_rank,
t1.bus_cnt,
rank() over (partition by t1.city_cd order by t1.bus_cnt)/district_cnt as bus_cnt_rank,
t1.nursery_cnt,
rank() over (partition by t1.city_cd order by t1.nursery_cnt)/district_cnt as nursery_cnt_rank,
t1.primary_cnt,
rank() over (partition by t1.city_cd order by t1.primary_cnt)/district_cnt as primary_cnt_rank,
t1.middle_cnt,
rank() over (partition by t1.city_cd order by t1.middle_cnt)/district_cnt as middle_cnt_rank,
t1.supermarket_cnt,
rank() over (partition by t1.city_cd order by t1.supermarket_cnt)/district_cnt as supermarket_cnt_rank,
t1.movie_cnt,
rank() over (partition by t1.city_cd order by t1.movie_cnt)/district_cnt as movie_cnt_rank,
t1.coffee_cnt,
rank() over (partition by t1.city_cd order by t1.coffee_cnt)/district_cnt as coffee_cnt_rank
from wrk_evaluation.community_month_report_convenient_district_info_01 t1
left join (
    select city_cd,count(distinct district_cd) as district_cnt from wrk_evaluation.community_month_report_convenient_district_info_01 group by city_cd
) t2
    on t1.city_cd = t2.city_cd













