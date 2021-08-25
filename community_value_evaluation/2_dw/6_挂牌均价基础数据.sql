create table wrk_evaluation.city_rack_avg_price_01 as
    insert overwrite table wrk_evaluation.city_rack_avg_price_01
select
    t2.city_cd,
    t2.city_name,
    substring(t1.s_batch_dt,1,7) as dt,
    avg(t1.d_rack_average_price) as avg_price,
    row_number() over (partition by t2.city_cd order by substring(t1.s_batch_dt,1,7) desc) as ranks,
    current_timestamp() as timestamp_v
from ods_evaluation.community_room_rack_detail t1
     inner join dw_evaluation.community_month_report_base_info t2
     on t1.community_id = t2.community_id
group by substring(t1.s_batch_dt,1,7),
         t2.city_cd,
         t2.city_name

truncate table wrk_evaluation.city_rack_avg_price_02;
drop table wrk_evaluation.city_rack_avg_price_02;
create table wrk_evaluation.city_rack_avg_price_02 as
insert overwrite table wrk_evaluation.city_rack_avg_price_02
select
    t1.city_cd,
    t1.city_name,
    t1.dt,
    t1.avg_price,
    cast((t1.avg_price - t2.avg_price)/t2.avg_price as decimal(10,6)) as city_rack_month_12,
    current_timestamp() as timestamp_v
from wrk_evaluation.city_rack_avg_price_01 t1
     left join wrk_evaluation.city_rack_avg_price_01 t2
     on t1.city_cd = t2.city_cd
             and t1.ranks =1 and t2.ranks = 13
where t1.ranks =1




create table wrk_evaluation.district_rack_avg_price_01 as
insert overwrite table wrk_evaluation.district_rack_avg_price_01
select
    t2.city_cd,
    t2.city_name,
    t2.district_cd,
    t2.district_name,
    substring(t1.s_batch_dt,1,7) as dt,
    avg(t1.d_rack_average_price) as avg_price,
    row_number() over (partition by t2.city_cd,t2.district_cd order by substring(t1.s_batch_dt,1,7) desc) as ranks,
    current_timestamp() as timestamp_v
from ods_evaluation.community_room_rack_detail t1
         inner join dw_evaluation.community_month_report_base_info t2
                    on t1.community_id = t2.community_id
group by substring(t1.s_batch_dt,1,7),
    t2.city_cd,
    t2.city_name,
    t2.district_cd,
    t2.district_name

truncate table wrk_evaluation.district_rack_avg_price_02;
drop table wrk_evaluation.district_rack_avg_price_02;
create table wrk_evaluation.district_rack_avg_price_02 as
    insert overwrite table wrk_evaluation.district_rack_avg_price_02
select
    t1.city_cd,
    t1.city_name,
    t1.district_cd,
    t1.district_name,
    t1.dt,
    t1.avg_price,
    cast((t1.avg_price - t2.avg_price)/t2.avg_price as decimal(10,6)) as district_rack_month_six,
    current_timestamp() as timestamp_v
from wrk_evaluation.district_rack_avg_price_01 t1
         left join wrk_evaluation.district_rack_avg_price_01 t2
                   on t1.city_cd = t2.city_cd
                       and t1.district_cd = t2.district_cd
                       and t1.ranks =1 and t2.ranks = 7
where t1.ranks =1





create table wrk_evaluation.community_rack_avg_price_01 as
    insert overwrite table wrk_evaluation.community_rack_avg_price_01
select
    t1.community_id,
    t2.city_cd,
    t2.city_name,
    t2.district_cd,
    t2.district_name,
    t2.block_cd,
    t2.block_name,
    substring(t1.s_batch_dt,1,7) as dt,
    avg(t1.d_rack_average_price) as avg_price,
    row_number() over (partition by t2.city_cd,t2.district_cd,t2.block_cd,t1.community_id order by substring(t1.s_batch_dt,1,7) desc) as ranks,
    current_timestamp() as timestamp_v
from ods_evaluation.community_room_rack_detail t1
         inner join dw_evaluation.community_month_report_base_info t2
                    on t1.community_id = t2.community_id
group by t1.community_id,
    substring(t1.s_batch_dt,1,7),
    t2.city_cd,
    t2.city_name,
    t2.district_cd,
    t2.district_name,
    t2.block_cd,
    t2.block_name


--近6个月没有的，就继续往前推6个月，当月没有的，就取上个月，上个月也没有的，就取最近一个月的 如果全部没有，且数据不满6个月的，就不出报告 --朱骊

truncate table dw_evaluation.community_rack_avg_price
drop table dw_evaluation.community_rack_avg_price
create table dw_evaluation.community_rack_avg_price as
    insert overwrite table dw_evaluation.community_rack_avg_price
select
    t3.community_id,
    t3.city_cd,
    t3.city_name,
    t3.district_cd,
    t3.district_name,
    t3.dt,
    t3.avg_price,
    t3.rack_month_six,
    t4.district_rack_month_six,
    t3.rack_month_12,
    t5.city_rack_month_12,
    current_timestamp() as timestamp_v
from (
    select t1.community_id,
        t1.city_cd,
        t1.city_name,
        t1.district_cd,
        t1.district_name,
        t1.dt,
        t1.avg_price,
        cast((t1.avg_price - t2.avg_price) / t2.avg_price as decimal(10, 6)) as rack_month_six,
        cast((t1.avg_price - t3.avg_price) / t3.avg_price as decimal(10, 6)) as rack_month_12

    from wrk_evaluation.community_rack_avg_price_01 t1
             left join wrk_evaluation.community_rack_avg_price_01 t2
                       on t1.community_id = t2.community_id
                           and t1.ranks = 1 and t2.ranks = 7
             left join wrk_evaluation.community_rack_avg_price_01 t3
                       on t1.community_id = t3.community_id
                       and t1.ranks = 1 and t3.ranks = 13
    where t1.ranks = 1
) t3
         left join wrk_evaluation.district_rack_avg_price_02 t4
                   on t3.district_cd = t4.district_cd
left join wrk_evaluation.city_rack_avg_price_02 t5
on t3.city_cd = t5.city_cd
where t3.rack_month_six is not null
