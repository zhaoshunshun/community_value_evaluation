

---容积率、车位比、绿化率、楼龄
truncate table wrk_evaluation.community_evaluation_month_analysis_01;
drop table wrk_evaluation.community_evaluation_month_analysis_01;
create table wrk_evaluation.community_evaluation_month_analysis_01
as
    insert overwrite table wrk_evaluation.community_evaluation_month_analysis_01
    select
    t1.community_id,
    t1.city_name,
    t1.district_name,
    row_number() over (partition by t1.block_cd order by t1.volume_rate desc)/t4.block_cnt as block_volume_rate,
    row_number() over (partition by t1.block_cd order by t1.green_rate asc)/t4.block_cnt as block_green_rate,
    concat('1:',cast(cast(t2.block_parking_rate as decimal (10,6)) as STRING)) as block_parking_rate_value,
    row_number() over (partition by t1.block_cd order by split(t1.parking_rate,':')[1] asc)/t4.block_cnt as block_parking_rate,
    cast(t2.block_building_age as decimal(10,6)) as block_building_age_value,
    row_number() over (partition by t1.block_cd order by t1.building_age desc)/t4.block_cnt as block_building_age,
    t2.city_volume_rate /t3.city_cnt as city_volume_rate,
    t2.city_green_rate / t3.city_cnt as city_green_rate,
    t2.city_parking_rate / t3.city_cnt as city_parking_rate,
    t2.city_building_age / t3.city_cnt as city_building_age_rate,
    t5.is_elevator_type as elevator_desc,
    t6.is_elevator_type as block_elevator_desc
    from dw_evaluation.community_month_report_base_info t1
    left join (
        select city_cd,block_cd,
            avg(volume_rate) as block_volume_rate,
            avg(green_rate) as block_green_rate,
            avg(split(parking_rate,':')[1]) as block_parking_rate,
            avg(building_age) as block_building_age,
            row_number() over (partition by city_cd order by avg(volume_rate) desc ) as city_volume_rate,
            row_number() over (partition by city_cd order by avg(green_rate) asc ) as city_green_rate,
            row_number() over (partition by city_cd order by avg(split(parking_rate,':')[1]) asc ) as city_parking_rate,
            row_number() over (partition by city_cd order by avg(building_age) desc ) as city_building_age
        from dw_evaluation.community_month_report_base_info
        where volume_rate <> '' and green_rate <> '' and parking_rate <> '' and building_age <> ''
        group by city_cd,block_cd
    ) t2
    on t1.city_cd = t2.city_cd
    and t1.block_cd = t2.block_cd
    left join(
        select city_cd,
            count(distinct block_cd) as city_cnt
        from dw_evaluation.community_month_report_base_info
        group by city_cd
        ) t3
    on t2.city_cd = t3.city_cd
    left join(
    select city_cd,
           block_cd,
        count(1) as block_cnt
    from dw_evaluation.community_month_report_base_info
        group by city_cd,block_cd
        ) t4
    on t1.city_cd = t4.city_cd
    and t1.block_cd = t4.block_cd
             left join wrk_evaluation.community_month_building_elevator t5
                       on t1.community_id = t5.community_id
             left join  wrk_evaluation.community_month_building_block_elevator t6
                        on t1.block_cd = t6.block_cd

--小区价格
truncate table wrk_evaluation.community_evaluation_month_analysis_02;
drop table wrk_evaluation.community_evaluation_month_analysis_02;
create table wrk_evaluation.community_evaluation_month_analysis_02
    as
    insert overwrite table wrk_evaluation.community_evaluation_month_analysis_02
    select
        t1.community_id,
        t1.city_name,
        t1.district_name,
        row_number() over (partition by t1.district_cd order by t1.district_rack_month_six asc)/t2.cnt as district_rack_month_six,
        t3.city_rack_month_six/t4.cnt as city_rack_month_six
        from dw_evaluation.community_rack_avg_price t1
    left join (
        select t1.city_cd,
               t1.district_cd,
               count(1) as cnt
        from dw_evaluation.community_rack_avg_price t1
        group by t1.city_cd,t1.district_cd
        ) t2
    on t1.city_cd = t2.city_cd
    and t1.district_cd = t2.district_cd
    left join (
        select
            t1.city_cd,
            t1.district_cd,
            avg(t1.district_rack_month_six),
            row_number() over (partition by t1.city_cd order by avg(t1.district_rack_month_six) asc)  as city_rack_month_six
        from  dw_evaluation.community_rack_avg_price t1
        group by t1.city_cd,t1.district_cd
    ) t3
            on t1.district_cd = t3.district_cd
    left join (
            select city_cd,
                count(distinct district_cd) as cnt
            from dw_evaluation.community_rack_avg_price
        group by city_cd
            ) t4
    on t3.city_cd = t4.city_cd







--近一年成交
create table wrk_evaluation.community_evaluation_month_analysis_03
    as
    insert overwrite table wrk_evaluation.community_evaluation_month_analysis_03
select community_id,count(1) as deal_cnt
from dw_evaluation.community_evaluation_month_deal group by community_id


--周边1KM小区

create table wrk_evaluation.community_evaluation_month_analysis_04 as
    insert overwrite table wrk_evaluation.community_evaluation_month_analysis_04
select t1.community_id,
       concat_ws(',',collect_set(cast(t1.community_id_tag as STRING))) as community_id_list
from (
    select t1.community_id,
        t2.community_id as community_id_tag,
        row_number() over (partition by t1.community_id order by udf.pointdistance(t1.coordinate, t2.coordinate)) as ranks
    from dw_evaluation.community_month_report_base_info t1
             left join dw_evaluation.community_month_report_base_info t2
                       on t1.district_cd = t2.district_cd
    where udf.pointdistance(t1.coordinate, t2.coordinate) <= 1000 and t1.community_id <>t2.community_id
) t1
group by t1.community_id

create table wrk_evaluation.community_similar_price as
    insert overwrite table wrk_evaluation.community_similar_price
    select
           t1.community_id,
           t1.district_cd,
           t1.city_cd,
           t1.building_age,
           t2.avg_price
    from dw_evaluation.community_month_report_base_info t1
    inner join dw_evaluation.community_avg_price_cal t2
    on t1.community_id = t2.community_id


# --板块内相似小区
# create table wrk_evaluation.community_evaluation_month_analysis_05 as
# select t4.community_id,
#        t4.community_id_tag
#     from (
#     select t3.community_id,
#         t3.community_id_tag,
#         row_number() over (partition by t3.community_id order by building_age_score + avg_price_score desc) as ranks
#     from (
#         select t1.community_id,
#             t2.community_id as community_id_tag,
#             case
#                 when t2.building_age > t1.building_age - 5 and t2.building_age < t1.building_age + 5 then 4
#                 when (t2.building_age <= t1.building_age - 5 and t2.building_age > t1.building_age - 10) or
#                      (t2.building_age >= t1.building_age + 5 and t2.building_age < t1.building_age + 10) then 3
#                 else 0 end  as building_age_score,
#             case
#                 when t2.avg_price > t1.avg_price * 0.9 and t2.avg_price < t1.avg_price * 1.1 then 2
#                 when (t2.avg_price <= t1.avg_price * 0.9 and t2.avg_price > t1.avg_price * 0.8) or
#                      (t2.avg_price >= t1.avg_price * 1.1 and t2.avg_price < t1.avg_price * 1.2) then 1
#                 else 0 end  as avg_price_score
#         from wrk_evaluation.community_similar_price t1
#                  left join wrk_evaluation.community_similar_price t2
#                            on t1.district_cd = t2.district_cd
#         where t1.community_id <> t2.community_id
#     ) t3
# ) t4 where t4.ranks = 1
#
# --城市内相似小区
# create table wrk_evaluation.community_evaluation_month_analysis_06 as
# select t4.community_id,
#     t4.community_id_tag
# from (
#     select t3.community_id,
#         t3.community_id_tag,
#         row_number() over (partition by t3.community_id order by building_age_score + avg_price_score desc) as ranks
#     from (
#         select t1.community_id,
#             t2.community_id as community_id_tag,
#             case
#                 when t2.building_age > t1.building_age - 5 and t2.building_age < t1.building_age + 5 then 4
#                 when (t2.building_age <= t1.building_age - 5 and t2.building_age > t1.building_age - 10) or
#                      (t2.building_age >= t1.building_age + 5 and t2.building_age < t1.building_age + 10) then 3
#                 else 0 end  as building_age_score,
#             case
#                 when t2.avg_price > t1.avg_price * 0.9 and t2.avg_price < t1.avg_price * 1.1 then 2
#                 when (t2.avg_price <= t1.avg_price * 0.9 and t2.avg_price > t1.avg_price * 0.8) or
#                      (t2.avg_price >= t1.avg_price * 1.1 and t2.avg_price < t1.avg_price * 1.2) then 1
#                 else 0 end  as avg_price_score
#         from wrk_evaluation.community_similar_price t1
#                  left join wrk_evaluation.community_similar_price t2
#                            on t1.city_cd = t2.city_cd
#         where t1.community_id <> t2.community_id
#     ) t3
# ) t4 where t4.ranks = 1

create table wrk_evaluation.community_evaluation_month_analysis_10 as
    insert overwrite table wrk_evaluation.community_evaluation_month_analysis_10
select t3.community_id,
    sum(case when t3.floor_type='平层' then 1 else 0 end) as leveling_cnt,
    sum(case when t3.floor_type='多层' then 1 else 0 end) as mult_level_cnt,
    sum(case when t3.floor_type='小高层' then 1 else 0 end) as small_high_level_cnt,
    sum(case when t3.floor_type='高层' then 1 else 0 end) as high_level_cnt,
    max(floor_num) as highest_floor
from (
    select community_id,
        building_id,
        case when floor_num <=3 then '平层'
             when floor_num >=4 and floor_num<=6 then '多层'
             when floor_num >=7 and floor_num<=18 then '小高层'
             when floor_num >18 then '高层'
             else '' end as floor_type,
        floor_num
    from ods_house.ods_house_asset_building
    where del_ind <> 1 ) t3
group by t3.community_id



--小区价值变动分值
create table wrk_evaluation.community_evaluation_month_analysis_07 as
    insert overwrite table wrk_evaluation.community_evaluation_month_analysis_07
    select
    community_id,
    case when district_rack_month_six <0.05 then 0
    when district_rack_month_six>=0.05 and district_rack_month_six<0.1 then 1
    when district_rack_month_six>=0.1 and district_rack_month_six<0.2 then 2
    when district_rack_month_six>=0.2 and district_rack_month_six<0.3 then 3
    when district_rack_month_six>=0.3 and district_rack_month_six<0.4 then 4
    when district_rack_month_six>=0.4 and district_rack_month_six<0.5 then 5
    when district_rack_month_six>=0.5 and district_rack_month_six<0.6 then 6
    when district_rack_month_six>=0.6 and district_rack_month_six<0.7 then 7
    when district_rack_month_six>=0.7 and district_rack_month_six<0.8 then 8
    when district_rack_month_six>=0.8 and district_rack_month_six<0.9 then 9
    when district_rack_month_six>=0.9 then 10 end as district_rack_month_six_score,
    case when city_rack_month_six <0.05 then 0
    when city_rack_month_six>=0.05 and city_rack_month_six<0.1 then 1
    when city_rack_month_six>=0.1 and city_rack_month_six<0.2 then 2
    when city_rack_month_six>=0.2 and city_rack_month_six<0.3 then 3
    when city_rack_month_six>=0.3 and city_rack_month_six<0.4 then 4
    when city_rack_month_six>=0.4 and city_rack_month_six<0.5 then 5
    when city_rack_month_six>=0.5 and city_rack_month_six<0.6 then 6
    when city_rack_month_six>=0.6 and city_rack_month_six<0.7 then 7
    when city_rack_month_six>=0.7 and city_rack_month_six<0.8 then 8
    when city_rack_month_six>=0.8 and city_rack_month_six<0.9 then 9
    when city_rack_month_six>=0.9 then 10 end as city_rack_month_six_score
    from wrk_evaluation.community_evaluation_month_analysis_02

--小区成交量分值
create table wrk_evaluation.community_evaluation_month_analysis_08 as
    insert overwrite table wrk_evaluation.community_evaluation_month_analysis_08
select
t1.community_id,
       t1.district_cd,
       case when t2.cnt/t1.room_num<0.02 then 0
            when t2.cnt/t1.room_num>=0.02 and t2.cnt/t1.room_num<0.05 then 2
            when t2.cnt/t1.room_num>=0.05 and t2.cnt/t1.room_num<0.08 then 4
            when t2.cnt/t1.room_num>=0.08 and t2.cnt/t1.room_num<0.10 then 6
            when t2.cnt/t1.room_num>=0.10 and t2.cnt/t1.room_num<0.15 then 8
            when t2.cnt/t1.room_num>=0.15 then 10 end as community_deal_rate,
    case when t3.deal_rate<0.02 then 0
         when t3.deal_rate>=0.02 and t3.deal_rate<0.05 then 2
         when t3.deal_rate>=0.05 and t3.deal_rate<0.08 then 4
         when t3.deal_rate>=0.08 and t3.deal_rate<0.10 then 6
         when t3.deal_rate>=0.10 and t3.deal_rate<0.15 then 8
         when t3.deal_rate>=0.15 then 10 end as district_deal_rate
from dw_evaluation.community_month_report_base_info t1
left join
    (
    select
    community_id,count(1) as cnt
    from dw_evaluation.community_evaluation_month_deal
    group by community_id
    ) t2
on t1.community_id = t2.community_id
                         left join (
    select
        t1.district_cd,
        t2.cnt/t1.cnt as deal_rate
    from
        (select district_cd,sum(room_num) as cnt from dw_evaluation.community_month_report_base_info group by district_cd) t1
            left join
        (
            select
                district_cd,count(1) as cnt
            from dw_evaluation.community_evaluation_month_deal
            group by district_cd
        ) t2
        on t1.district_cd = t2.district_cd
    ) t3 on t1.district_cd = t3.district_cd


--绿化率，容积率分值



create table  wrk_evaluation.community_evaluation_month_analysis_09 as
    insert overwrite table  wrk_evaluation.community_evaluation_month_analysis_09
select
    t1.community_id,
    t1.block_parking_rate_value,
    t1.block_building_age_value,
    case when t1.block_volume_rate <0.05 then 0
         when t1.block_volume_rate>=0.05 and t1.block_volume_rate<0.1 then 1
         when t1.block_volume_rate>=0.1 and t1.block_volume_rate<0.2 then 2
         when t1.block_volume_rate>=0.2 and t1.block_volume_rate<0.3 then 3
         when t1.block_volume_rate>=0.3 and t1.block_volume_rate<0.4 then 4
         when t1.block_volume_rate>=0.4 and t1.block_volume_rate<0.5 then 5
         when t1.block_volume_rate>=0.5 and t1.block_volume_rate<0.6 then 6
         when t1.block_volume_rate>=0.6 and t1.block_volume_rate<0.7 then 7
         when t1.block_volume_rate>=0.7 and t1.block_volume_rate<0.8 then 8
         when t1.block_volume_rate>=0.8 and t1.block_volume_rate<0.9 then 9
         when t1.block_volume_rate>=0.9 then 10 end as block_volume_rate,
    case when t1.block_green_rate <0.05 then 0
         when t1.block_green_rate>=0.05 and t1.block_green_rate<0.1 then 1
         when t1.block_green_rate>=0.1 and t1.block_green_rate<0.2 then 2
         when t1.block_green_rate>=0.2 and t1.block_green_rate<0.3 then 3
         when t1.block_green_rate>=0.3 and t1.block_green_rate<0.4 then 4
         when t1.block_green_rate>=0.4 and t1.block_green_rate<0.5 then 5
         when t1.block_green_rate>=0.5 and t1.block_green_rate<0.6 then 6
         when t1.block_green_rate>=0.6 and t1.block_green_rate<0.7 then 7
         when t1.block_green_rate>=0.7 and t1.block_green_rate<0.8 then 8
         when t1.block_green_rate>=0.8 and t1.block_green_rate<0.9 then 9
         when t1.block_green_rate>=0.9 then 10 end as block_green_rate,
    case when t1.block_parking_rate <0.05 then 0
         when t1.block_parking_rate>=0.05 and t1.block_parking_rate<0.1 then 1
         when t1.block_parking_rate>=0.1 and t1.block_parking_rate<0.2 then 2
         when t1.block_parking_rate>=0.2 and t1.block_parking_rate<0.3 then 3
         when t1.block_parking_rate>=0.3 and t1.block_parking_rate<0.4 then 4
         when t1.block_parking_rate>=0.4 and t1.block_parking_rate<0.5 then 5
         when t1.block_parking_rate>=0.5 and t1.block_parking_rate<0.6 then 6
         when t1.block_parking_rate>=0.6 and t1.block_parking_rate<0.7 then 7
         when t1.block_parking_rate>=0.7 and t1.block_parking_rate<0.8 then 8
         when t1.block_parking_rate>=0.8 and t1.block_parking_rate<0.9 then 9
         when t1.block_parking_rate>=0.9 then 10 end as block_parking_rate,
    case when t1.block_building_age <0.05 then 0
         when t1.block_building_age>=0.05 and t1.block_building_age<0.1 then 1
         when t1.block_building_age>=0.1 and t1.block_building_age<0.2 then 2
         when t1.block_building_age>=0.2 and t1.block_building_age<0.3 then 3
         when t1.block_building_age>=0.3 and t1.block_building_age<0.4 then 4
         when t1.block_building_age>=0.4 and t1.block_building_age<0.5 then 5
         when t1.block_building_age>=0.5 and t1.block_building_age<0.6 then 6
         when t1.block_building_age>=0.6 and t1.block_building_age<0.7 then 7
         when t1.block_building_age>=0.7 and t1.block_building_age<0.8 then 8
         when t1.block_building_age>=0.8 and t1.block_building_age<0.9 then 9
         when t1.block_building_age>=0.9 then 10 end as block_building_age,
    case when t1.city_volume_rate <0.05 then 0
         when t1.city_volume_rate>=0.05 and t1.city_volume_rate<0.1 then 1
         when t1.city_volume_rate>=0.1 and t1.city_volume_rate<0.2 then 2
         when t1.city_volume_rate>=0.2 and t1.city_volume_rate<0.3 then 3
         when t1.city_volume_rate>=0.3 and t1.city_volume_rate<0.4 then 4
         when t1.city_volume_rate>=0.4 and t1.city_volume_rate<0.5 then 5
         when t1.city_volume_rate>=0.5 and t1.city_volume_rate<0.6 then 6
         when t1.city_volume_rate>=0.6 and t1.city_volume_rate<0.7 then 7
         when t1.city_volume_rate>=0.7 and t1.city_volume_rate<0.8 then 8
         when t1.city_volume_rate>=0.8 and t1.city_volume_rate<0.9 then 9
         when t1.city_volume_rate>=0.9 then 10 end as city_volume_rate,
    case when t1.city_green_rate <0.05 then 0
         when t1.city_green_rate>=0.05 and t1.city_green_rate<0.1 then 1
         when t1.city_green_rate>=0.1 and t1.city_green_rate<0.2 then 2
         when t1.city_green_rate>=0.2 and t1.city_green_rate<0.3 then 3
         when t1.city_green_rate>=0.3 and t1.city_green_rate<0.4 then 4
         when t1.city_green_rate>=0.4 and t1.city_green_rate<0.5 then 5
         when t1.city_green_rate>=0.5 and t1.city_green_rate<0.6 then 6
         when t1.city_green_rate>=0.6 and t1.city_green_rate<0.7 then 7
         when t1.city_green_rate>=0.7 and t1.city_green_rate<0.8 then 8
         when t1.city_green_rate>=0.8 and t1.city_green_rate<0.9 then 9
         when t1.city_green_rate>=0.9 then 10 end as city_green_rate,
    case when t1.city_parking_rate <0.05 then 0
         when t1.city_parking_rate>=0.05 and t1.city_parking_rate<0.1 then 1
         when t1.city_parking_rate>=0.1 and t1.city_parking_rate<0.2 then 2
         when t1.city_parking_rate>=0.2 and t1.city_parking_rate<0.3 then 3
         when t1.city_parking_rate>=0.3 and t1.city_parking_rate<0.4 then 4
         when t1.city_parking_rate>=0.4 and t1.city_parking_rate<0.5 then 5
         when t1.city_parking_rate>=0.5 and t1.city_parking_rate<0.6 then 6
         when t1.city_parking_rate>=0.6 and t1.city_parking_rate<0.7 then 7
         when t1.city_parking_rate>=0.7 and t1.city_parking_rate<0.8 then 8
         when t1.city_parking_rate>=0.8 and t1.city_parking_rate<0.9 then 9
         when t1.city_parking_rate>=0.9 then 10 end as city_parking_rate,
    case when t1.city_building_age_rate <0.05 then 0
         when t1.city_building_age_rate>=0.05 and t1.city_building_age_rate<0.1 then 1
         when t1.city_building_age_rate>=0.1 and t1.city_building_age_rate<0.2 then 2
         when t1.city_building_age_rate>=0.2 and t1.city_building_age_rate<0.3 then 3
         when t1.city_building_age_rate>=0.3 and t1.city_building_age_rate<0.4 then 4
         when t1.city_building_age_rate>=0.4 and t1.city_building_age_rate<0.5 then 5
         when t1.city_building_age_rate>=0.5 and t1.city_building_age_rate<0.6 then 6
         when t1.city_building_age_rate>=0.6 and t1.city_building_age_rate<0.7 then 7
         when t1.city_building_age_rate>=0.7 and t1.city_building_age_rate<0.8 then 8
         when t1.city_building_age_rate>=0.8 and t1.city_building_age_rate<0.9 then 9
         when t1.city_building_age_rate>=0.9 then 10 end as city_building_age_rate,
    case when t3.is_elevator_type in ( 1,4) then '0' --没有
         when t3.is_elevator_type = 5 then '10'   --有
         when t3.is_elevator_type in (3,6,8) then '5' --部分有
         when t3.is_elevator_type = 9 then null end --暂无数据
        as elevator_desc,
    case when t4.is_elevator_type in ( 1,4) then '0' --没有
         when t4.is_elevator_type = 5 then '10'   --有
         when t4.is_elevator_type in (3,6,8)  then '5' --部分有
         when t4.is_elevator_type = 9 then null end --暂无数据
        as block_elevator_desc

from wrk_evaluation.community_evaluation_month_analysis_01 t1




    insert overwrite table dm_evaluation.community_month_report_analysis
    select
    t1.community_id,
    t1.district_cd,
    t1.block_cd,
    cast((t2.community_deal_rate+t3.district_rack_month_six_score)/2 as decimal(10,2)) as trans_value_score,
    t2.community_deal_rate as mobility_score,
    t2.district_deal_rate as district_mobility_score,
    t3.district_rack_month_six_score as price_score,
    t3.city_rack_month_six_score as district_price_score,
    t4.deal_cnt as deal_cnt,
    '' as living_score,
    case when t1.volume_rate in ('',null) then null else  t5.block_volume_rate end as volume_rate_score,
    t5.city_volume_rate as block_volume_rate_score,
    case when t1.green_rate in ('',null) then null else  t5.block_green_rate end as green_rate_score,
    t5.city_green_rate as block_green_rate_score,
    case when t1.parking_rate in ('',null) then null else  t5.block_parking_rate  end as parking_rate_score,
    t5.block_parking_rate_value as block_parking_rate,
    t5.city_parking_rate as block_parking_rate_score,
    case when t1.building_age in ('',null) then null else  t5.block_building_age end as building_age_score,
    t5.block_building_age_value as block_building_rate,
    t5.city_building_age_rate as block_building_score,
    case when t5.elevator_desc is not null then t5.elevator_desc
        else null end as elevator_score,
    case when t5.block_elevator_desc is not null then t5.block_elevator_desc
        else null end as block_elevator_score,
    t6.community_id_list as around_community_id_list,
    '' as block_same_community_id,
    '' as city_smme_community_id,
    t9.highest_floor as highest_floor,
    t9.leveling_cnt as leveling_cnt,
    t9.mult_level_cnt as mult_level_cnt,
    t9.small_high_level_cnt as small_high_level_cnt,
    t9.high_level_cnt as high_level_cnt,
    cast(t10.layout_1_cnt/t10.community_house_cnt as decimal (10,6))as layout_1_rate,
    cast(t10.layout_2_cnt/t10.community_house_cnt as decimal (10,6))as layout_2_rate,
    cast(t10.layout_3_cnt/t10.community_house_cnt as decimal (10,6))as layout_3_rate,
    cast(t10.layout_4_cnt/t10.community_house_cnt as decimal (10,6))as layout_4_rate,
    cast(t10.layout_other_cnt/t10.community_house_cnt as decimal (10,6))as layout_other_rate,
    concat(t10.build_area_min_1,'-',t10.build_area_max_1) as layout_1_area,
    concat(t10.build_area_min_2,'-',t10.build_area_max_2) as layout_2_area,
    concat(t10.build_area_min_3,'-',t10.build_area_max_3) as layout_3_area,
    concat(t10.build_area_min_4,'-',t10.build_area_max_4) as layout_4_area,
    concat(t10.build_area_min_other,'-',t10.build_area_max_other) as layout_other_area,
    t10.main_layout as layout_main,
    concat(t10.main_area_min,'-',t10.main_area_max)  as layout_main_area,
    coalesce(t10.second_layout,'其他') as layout_secondary,
    coalesce(t10.last_layout,'其他') as layout_least,
    substring(current_timestamp(),1,7) as batch_no,    --批次号
    current_timestamp() as timestamp_v          --数据处理时间
from dw_evaluation.community_month_report_base_info t1
left join wrk_evaluation.community_evaluation_month_analysis_08 t2
on t1.community_id = t2.community_id
left join wrk_evaluation.community_evaluation_month_analysis_07 t3
on t1.community_id = t3.community_id
left join wrk_evaluation.community_evaluation_month_analysis_03 t4
on t1.community_id = t4.community_id
left join wrk_evaluation.community_evaluation_month_analysis_09 t5
on t1.community_id = t5.community_id
left join wrk_evaluation.community_evaluation_month_analysis_04 t6
on t1.community_id = t6.community_id
left join wrk_evaluation.community_evaluation_month_analysis_10 t9
on t1.community_id = t9.community_id
left join dw_evaluation.community_evaluation_month_layout t10
on t1.community_id = t10.community_id
