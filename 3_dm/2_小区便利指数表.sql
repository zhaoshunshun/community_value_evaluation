truncate table wrk_evaluation.community_month_report_convenient_info_01;
drop table wrk_evaluation.community_month_report_convenient_info_01;
create table wrk_evaluation.community_month_report_convenient_info_01
as
    insert overwrite table wrk_evaluation.community_month_report_convenient_info_01
select
    t1.community_id,
    t1.subway_1km_cnt,
    t1.bus_1km_cnt,
    t3.bus_cnt,
    t3.sub_cnt,
    t1.subway_1km_name,
    t1.bus_1km_name,
    case when t1.bus_1km_ranks<0.2 then 0
         when t1.bus_1km_ranks >=0.2 and t1.bus_1km_ranks<0.4 then 1
         when t1.bus_1km_ranks >=0.4 and t1.bus_1km_ranks<0.6 then 2
         when t1.bus_1km_ranks >=0.6 and t1.bus_1km_ranks<0.8 then 3
         when t1.bus_1km_ranks >=0.8 and t1.bus_1km_ranks<0.9 then 4
         when t1.bus_1km_ranks >=0.9  then 5 end as bus_1km_score,
    case when t1.subway_1km_ranks<0.2 then 0
         when t1.subway_1km_ranks >=0.2 and t1.subway_1km_ranks<0.4 then 1
         when t1.subway_1km_ranks >=0.4 and t1.subway_1km_ranks<0.6 then 2
         when t1.subway_1km_ranks >=0.6 and t1.subway_1km_ranks<0.8 then 3
         when t1.subway_1km_ranks >=0.8 and t1.subway_1km_ranks<0.9 then 4
         when t1.subway_1km_ranks >=0.9  then 5 end as subway_1km_score,
    case when t3.bus_cnt_rank<0.2 then 0
         when t3.bus_cnt_rank >=0.2 and t3.bus_cnt_rank<0.4 then 1
         when t3.bus_cnt_rank >=0.4 and t3.bus_cnt_rank<0.6 then 2
         when t3.bus_cnt_rank >=0.6 and t3.bus_cnt_rank<0.8 then 3
         when t3.bus_cnt_rank >=0.8 and t3.bus_cnt_rank<0.9 then 4
         when t3.bus_cnt_rank >=0.9  then 5 end as bus_district_rank_score,
    case when t3.sub_cnt_rank<0.2 then 0
         when t3.sub_cnt_rank >=0.2 and t3.sub_cnt_rank<0.4 then 1
         when t3.sub_cnt_rank >=0.4 and t3.sub_cnt_rank<0.6 then 2
         when t3.sub_cnt_rank >=0.6 and t3.sub_cnt_rank<0.8 then 3
         when t3.sub_cnt_rank >=0.8 and t3.sub_cnt_rank<0.9 then 4
         when t3.sub_cnt_rank >=0.9  then 5 end as sub_district_rank_score,
    t1.subway_nearby_distince,
    t1.nursery_1km_cnt,
    t1.primary_1km_cnt,
    t1.middle_1km_cnt,
    t3.nursery_cnt,
    t3.primary_cnt,
    t3.middle_cnt,
    t1.nursery_1km_name,
    t1.primary_1km_name,
    t1.middle_1km_name,
    case when t1.nursery_1km_ranks<0.2 then 0
         when t1.nursery_1km_ranks >=0.2 and t1.nursery_1km_ranks<0.4 then 1
         when t1.nursery_1km_ranks >=0.4 and t1.nursery_1km_ranks<0.6 then 2
         when t1.nursery_1km_ranks >=0.6 and t1.nursery_1km_ranks<0.8 then 3
         when t1.nursery_1km_ranks >=0.8 and t1.nursery_1km_ranks<0.9 then 4
         when t1.nursery_1km_ranks >=0.9  then 5 end as nursery_1km_score,
    case when t1.primary_1km_ranks<0.2 then 0
         when t1.primary_1km_ranks >=0.2 and t1.primary_1km_ranks<0.4 then 1
         when t1.primary_1km_ranks >=0.4 and t1.primary_1km_ranks<0.6 then 2
         when t1.primary_1km_ranks >=0.6 and t1.primary_1km_ranks<0.8 then 3
         when t1.primary_1km_ranks >=0.8 and t1.primary_1km_ranks<0.9 then 4
         when t1.primary_1km_ranks >=0.9  then 5 end as primary_1km_score,
    case when t1.middle_1km_ranks<0.2 then 0
         when t1.middle_1km_ranks >=0.2 and t1.middle_1km_ranks<0.4 then 1
         when t1.middle_1km_ranks >=0.4 and t1.middle_1km_ranks<0.6 then 2
         when t1.middle_1km_ranks >=0.6 and t1.middle_1km_ranks<0.8 then 3
         when t1.middle_1km_ranks >=0.8 and t1.middle_1km_ranks<0.9 then 4
         when t1.middle_1km_ranks >=0.9  then 5 end as middle_1km_score,

    case when t3.nursery_cnt_rank<0.2 then 0
         when t3.nursery_cnt_rank >=0.2 and t3.nursery_cnt_rank<0.4 then 1
         when t3.nursery_cnt_rank >=0.4 and t3.nursery_cnt_rank<0.6 then 2
         when t3.nursery_cnt_rank >=0.6 and t3.nursery_cnt_rank<0.8 then 3
         when t3.nursery_cnt_rank >=0.8 and t3.nursery_cnt_rank<0.9 then 4
         when t3.nursery_cnt_rank >=0.9  then 5 end as nursery_district_rank_score,
    case when t3.primary_cnt_rank<0.2 then 0
         when t3.primary_cnt_rank >=0.2 and t3.primary_cnt_rank<0.4 then 1
         when t3.primary_cnt_rank >=0.4 and t3.primary_cnt_rank<0.6 then 2
         when t3.primary_cnt_rank >=0.6 and t3.primary_cnt_rank<0.8 then 3
         when t3.primary_cnt_rank >=0.8 and t3.primary_cnt_rank<0.9 then 4
         when t3.primary_cnt_rank >=0.9  then 5 end as primary_district_rank_score,
    case when t3.middle_cnt_rank<0.2 then 0
         when t3.middle_cnt_rank >=0.2 and t3.middle_cnt_rank<0.4 then 1
         when t3.middle_cnt_rank >=0.4 and t3.middle_cnt_rank<0.6 then 2
         when t3.middle_cnt_rank >=0.6 and t3.middle_cnt_rank<0.8 then 3
         when t3.middle_cnt_rank >=0.8 and t3.middle_cnt_rank<0.9 then 4
         when t3.middle_cnt_rank >=0.9  then 5 end as middle_district_rank_score,

    t1.hospital_1km_cnt,
    t1.three_hospital_1km_cnt,
    t3.hospital_cnt,
    t3.three_hospital_cnt,
    t1.hospital_1km_name,
    t1.three_hospital_1km_name,
    case when t1.hospital_1km_ranks<0.2 then 0
         when t1.hospital_1km_ranks >=0.2 and t1.hospital_1km_ranks<0.4 then 1
         when t1.hospital_1km_ranks >=0.4 and t1.hospital_1km_ranks<0.6 then 2
         when t1.hospital_1km_ranks >=0.6 and t1.hospital_1km_ranks<0.8 then 3
         when t1.hospital_1km_ranks >=0.8 and t1.hospital_1km_ranks<0.9 then 4
         when t1.hospital_1km_ranks >=0.9  then 5 end as hospital_1km_score,
    case when t1.three_hospital_1km_ranks<0.2 then 0
         when t1.three_hospital_1km_ranks >=0.2 and t1.three_hospital_1km_ranks<0.4 then 1
         when t1.three_hospital_1km_ranks >=0.4 and t1.three_hospital_1km_ranks<0.6 then 2
         when t1.three_hospital_1km_ranks >=0.6 and t1.three_hospital_1km_ranks<0.8 then 3
         when t1.three_hospital_1km_ranks >=0.8 and t1.three_hospital_1km_ranks<0.9 then 4
         when t1.three_hospital_1km_ranks >=0.9  then 5 end as three_hospital_1km_score,

    case when t3.hospital_cnt_rank<0.2 then 0
         when t3.hospital_cnt_rank >=0.2 and t3.hospital_cnt_rank<0.4 then 1
         when t3.hospital_cnt_rank >=0.4 and t3.hospital_cnt_rank<0.6 then 2
         when t3.hospital_cnt_rank >=0.6 and t3.hospital_cnt_rank<0.8 then 3
         when t3.hospital_cnt_rank >=0.8 and t3.hospital_cnt_rank<0.9 then 4
         when t3.hospital_cnt_rank >=0.9  then 5 end as hospital_district_rank_score,
    case when t3.three_hospital_cnt_rank<0.2 then 0
         when t3.three_hospital_cnt_rank >=0.2 and t3.three_hospital_cnt_rank<0.4 then 1
         when t3.three_hospital_cnt_rank >=0.4 and t3.three_hospital_cnt_rank<0.6 then 2
         when t3.three_hospital_cnt_rank >=0.6 and t3.three_hospital_cnt_rank<0.8 then 3
         when t3.three_hospital_cnt_rank >=0.8 and t3.three_hospital_cnt_rank<0.9 then 4
         when t3.three_hospital_cnt_rank >=0.9  then 5 end as three_hospital_distrcit_rank_score,
    t1.shopping_1km_cnt,
    t1.supermarket_1km_cnt,
    t3.shopping_cnt,
    t3.supermarket_cnt,
    t1.shopping_1km_name,
    t1.supermarket_1km_name,
    case when t1.shopping_1km_ranks<0.2 then 0
         when t1.shopping_1km_ranks >=0.2 and t1.shopping_1km_ranks<0.4 then 1
         when t1.shopping_1km_ranks >=0.4 and t1.shopping_1km_ranks<0.6 then 2
         when t1.shopping_1km_ranks >=0.6 and t1.shopping_1km_ranks<0.8 then 3
         when t1.shopping_1km_ranks >=0.8 and t1.shopping_1km_ranks<0.9 then 4
         when t1.shopping_1km_ranks >=0.9  then 5 end as shopping_1km_score,
    case when t1.supermarket_1km_ranks<0.2 then 0
         when t1.supermarket_1km_ranks >=0.2 and t1.supermarket_1km_ranks<0.4 then 1
         when t1.supermarket_1km_ranks >=0.4 and t1.supermarket_1km_ranks<0.6 then 2
         when t1.supermarket_1km_ranks >=0.6 and t1.supermarket_1km_ranks<0.8 then 3
         when t1.supermarket_1km_ranks >=0.8 and t1.supermarket_1km_ranks<0.9 then 4
         when t1.supermarket_1km_ranks >=0.9  then 5 end as supermarket_1km_score,

    case when t3.shopping_cnt_rank<0.2 then 0
         when t3.shopping_cnt_rank >=0.2 and t3.shopping_cnt_rank<0.4 then 1
         when t3.shopping_cnt_rank >=0.4 and t3.shopping_cnt_rank<0.6 then 2
         when t3.shopping_cnt_rank >=0.6 and t3.shopping_cnt_rank<0.8 then 3
         when t3.shopping_cnt_rank >=0.8 and t3.shopping_cnt_rank<0.9 then 4
         when t3.shopping_cnt_rank >=0.9  then 5 end as shopping_district_rank_score,
    case when t3.supermarket_cnt_rank<0.2 then 0
         when t3.supermarket_cnt_rank >=0.2 and t3.supermarket_cnt_rank<0.4 then 1
         when t3.supermarket_cnt_rank >=0.4 and t3.supermarket_cnt_rank<0.6 then 2
         when t3.supermarket_cnt_rank >=0.6 and t3.supermarket_cnt_rank<0.8 then 3
         when t3.supermarket_cnt_rank >=0.8 and t3.supermarket_cnt_rank<0.9 then 4
         when t3.supermarket_cnt_rank >=0.9  then 5 end as supermarket_district_rank_score,
    t1.greenland_1km_cnt,
    t1.movie_1km_cnt,
    t1.coffee_1km_cnt,
    t3.greenland_cnt,
    t3.coffee_cnt,
    t3.movie_cnt,
    t1.greenland_1km_name,
    t1.movie_1km_name,
    t1.coffee_1km_name,
    case when t1.greenland_1km_ranks<0.2 then 0
         when t1.greenland_1km_ranks >=0.2 and t1.greenland_1km_ranks<0.4 then 1
         when t1.greenland_1km_ranks >=0.4 and t1.greenland_1km_ranks<0.6 then 2
         when t1.greenland_1km_ranks >=0.6 and t1.greenland_1km_ranks<0.8 then 3
         when t1.greenland_1km_ranks >=0.8 and t1.greenland_1km_ranks<0.9 then 4
         when t1.greenland_1km_ranks >=0.9  then 5 end as greenland_1km_score,
    case when t1.movie_1km_ranks<0.2 then 0
         when t1.movie_1km_ranks >=0.2 and t1.movie_1km_ranks<0.4 then 1
         when t1.movie_1km_ranks >=0.4 and t1.movie_1km_ranks<0.6 then 2
         when t1.movie_1km_ranks >=0.6 and t1.movie_1km_ranks<0.8 then 3
         when t1.movie_1km_ranks >=0.8 and t1.movie_1km_ranks<0.9 then 4
         when t1.movie_1km_ranks >=0.9  then 5 end as movie_1km_score,
    case when t1.coffee_1km_ranks<0.2 then 0
         when t1.coffee_1km_ranks >=0.2 and t1.coffee_1km_ranks<0.4 then 1
         when t1.coffee_1km_ranks >=0.4 and t1.coffee_1km_ranks<0.6 then 2
         when t1.coffee_1km_ranks >=0.6 and t1.coffee_1km_ranks<0.8 then 3
         when t1.coffee_1km_ranks >=0.8 and t1.coffee_1km_ranks<0.9 then 4
         when t1.coffee_1km_ranks >=0.9  then 5 end as coffee_1km_score,

    case when t3.greenland_cnt_rank<0.2 then 0
         when t3.greenland_cnt_rank >=0.2 and t3.greenland_cnt_rank<0.4 then 1
         when t3.greenland_cnt_rank >=0.4 and t3.greenland_cnt_rank<0.6 then 2
         when t3.greenland_cnt_rank >=0.6 and t3.greenland_cnt_rank<0.8 then 3
         when t3.greenland_cnt_rank >=0.8 and t3.greenland_cnt_rank<0.9 then 4
         when t3.greenland_cnt_rank >=0.9  then 5 end as greenland_district_rank_score,
    case when t3.movie_cnt_rank<0.2 then 0
         when t3.movie_cnt_rank >=0.2 and t3.movie_cnt_rank<0.4 then 1
         when t3.movie_cnt_rank >=0.4 and t3.movie_cnt_rank<0.6 then 2
         when t3.movie_cnt_rank >=0.6 and t3.movie_cnt_rank<0.8 then 3
         when t3.movie_cnt_rank >=0.8 and t3.movie_cnt_rank<0.9 then 4
         when t3.movie_cnt_rank >=0.9  then 5 end as movie_district_rank_score,
    case when t3.coffee_cnt_rank<0.2 then 0
         when t3.coffee_cnt_rank >=0.2 and t3.coffee_cnt_rank<0.4 then 1
         when t3.coffee_cnt_rank >=0.4 and t3.coffee_cnt_rank<0.6 then 2
         when t3.coffee_cnt_rank >=0.6 and t3.coffee_cnt_rank<0.8 then 3
         when t3.coffee_cnt_rank >=0.8 and t3.coffee_cnt_rank<0.9 then 4
         when t3.coffee_cnt_rank >=0.9  then 5 end as coffee_district_rank_score

from dw_evaluation.community_month_report_convenient_info t1
         left join dw_evaluation.community_month_report_convenient_district_info t3
                   on t1.district_cd = t3.district_cd






create table  dm_evaluation.community_month_report_convenient_info
as
    insert overwrite table dm_evaluation.community_month_report_convenient_info
    select
        t1.community_id,
        t2.district_cd,
        t2.block_cd,
        null as convenient_score,
        null as convenient_hight,
        null as convenient_low,
        cast(t1.subway_1km_score*0.6 +  t1.bus_1km_score*0.4 as decimal(10,4)) as traffic_score,
        cast(t1.sub_district_rank_score*0.6 + t1.bus_district_rank_score*0.4 as decimal(10,4)) as district_traffic_score,
        t1.bus_1km_cnt as traffic_bus_cnt,
        t1.subway_1km_cnt as traffic_subway_cnt,
        t1.bus_cnt as district_traffic_bus_cnt,
        t1.sub_cnt as traffic_subway_list,
        regexp_replace(t1.bus_1km_name ,';|；',',') as bus_1km_name,
        regexp_replace(t1.subway_1km_name ,';|；',',') as subway_1km_name,
        t1.subway_nearby_distince,
        cast(t1.nursery_1km_score*0.4+  t1.primary_1km_score*0.4+    t1.middle_1km_score*0.2 as decimal(10,4)) as education_score,
        cast(t1.nursery_district_rank_score*0.4 +  t1.primary_district_rank_score*0.4 + t1.middle_district_rank_score*0.2 as decimal(10,4)) as district_education_score,
        t1.nursery_1km_cnt as education_nursery_cnt,
        t1.primary_1km_cnt as education_primary_cnt,
        t1.middle_1km_cnt as education_middle_cnt,
        t1.nursery_cnt as district_education_nursery_cnt,
        t1.primary_cnt as district_education_primary_cnt,
        t1.middle_cnt as district_education_middle_cnt,
        regexp_replace(t1.nursery_1km_name ,';|；',',') as education_nursery_list,
        regexp_replace(t1.primary_1km_name ,';|；',',') as education_primary_list,
        regexp_replace(t1.middle_1km_name ,';|；',',') as education_middle_list,
        cast(t1.hospital_1km_score *0.5+  t1.three_hospital_1km_score*0.5 as decimal(10,4)) as hospital_score,
        cast(t1.hospital_district_rank_score * 0.5+  t1.three_hospital_distrcit_rank_score*0.5 as decimal(10,4))  as district_hospital_score,
        t1.hospital_1km_cnt as hospital_cnt,
        t1.three_hospital_1km_cnt as three_hospital_cnt,
        t1.hospital_cnt as district_hospital_cnt,
        t1.three_hospital_cnt as district_three_hospital_cnt,
        regexp_replace(t1.hospital_1km_name ,';|；',',') as hospital_list,
        regexp_replace(t1.three_hospital_1km_name ,';|；',',') as three_hospital_list,
        cast(t1.shopping_1km_score * 0.5 + t1.supermarket_1km_score*0.5 as decimal(10,4)) as shopping_score,
        cast(t1.shopping_district_rank_score * 0.5 + t1.supermarket_district_rank_score*0.5 as decimal(10,4)) as district_shopping_score,
        t1.supermarket_1km_cnt as shopping_supermarket_cnt,
        t1.shopping_1km_cnt as shopping_mall_cnt,
        t1.supermarket_cnt as district_shopping_supermarket_cnt,
        t1.shopping_cnt as district_shopping_mall_cnt,
        regexp_replace(t1.supermarket_1km_name ,';|；',',') as shopping_supermarket_list,
        regexp_replace(t1.shopping_1km_name ,';|；',',') as shopping_mall_list,
        cast(t1.greenland_1km_score*0.35+ t1.movie_1km_score*0.3+ t1.coffee_1km_score*0.35 as decimal(10,4)) as arder_score,
        cast(t1.greenland_district_rank_score*0.35+ t1.movie_district_rank_score*0.3+  t1.coffee_district_rank_score *0.35 as decimal(10,4)) as district_arder_score,
        t1.coffee_1km_cnt as coffee_house_cnt,
        t1.greenland_1km_cnt as greenland_cnt,
        t1.movie_1km_cnt as movie_cnt,
        t1.coffee_cnt as district_coffee_house_cnt,
        t1.greenland_cnt as district_greenland_cnt,
        t1.movie_cnt as district_movie_cnt,
        regexp_replace(t1.coffee_1km_name ,';|；',',') as coffee_house_list,
        regexp_replace(t1.greenland_1km_name ,';|；',',') as greenland_list,
        regexp_replace(t1.movie_1km_name,';|；',',') as movie_list,
        substring(current_timestamp(),1,7) as batch_no,    --批次号
    current_timestamp() as timestamp_v          --数据处理时间
from  wrk_evaluation.community_month_report_convenient_info_01 t1
left join  dw_evaluation.community_month_report_base_info t2
on t1.community_id = t2.community_id
