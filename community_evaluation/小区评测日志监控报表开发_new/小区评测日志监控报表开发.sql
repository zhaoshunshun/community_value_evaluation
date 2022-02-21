

--小区评测的日志
truncate table wrk_evaluation.community_evaluation_log_src;
drop table wrk_evaluation.community_evaluation_log_src;
create table wrk_evaluation.community_evaluation_log_src as
    insert overwrite table wrk_evaluation.community_evaluation_log_src
select
    substring(`@timestamp`,1,10) as timestamp_v,
    get_json_object(message,'$.appName') as appname,
    get_json_object(message,'$.key') as status,
    get_json_object(get_json_object(message,'$.value'),'$.communityId') as community_md5,
    get_json_object(get_json_object(message,'$.value'),'$.url') as request_pdf
from ods_evaluation.community_evaluation_log
where get_json_object(message,'$.appName') ='house-evaluation-api'
  and substring(`@timestamp`,1,10) >= add_months(current_date(),-1);


truncate table wrk_evaluation.community_evaluation_log_md5_01;
drop table wrk_evaluation.community_evaluation_log_md5_01;
create table wrk_evaluation.community_evaluation_log_md5_01 as
    insert overwrite table wrk_evaluation.community_evaluation_log_md5_01
select
    t2.community_id,
    t2.community_name,
    t1.code_md5 as community_md5,
    t1.rd,
    t1.channel,
    t2.city_cd,
    t2.city_name
from dm_house.dm_md5_map t1
         inner join ods_house.ods_house_asset_community t2
                    on t1.code = community_no
                        and t1.name='community_no'
                        and t1.channel='LEJU';



--小区评测的打开日志
truncate table wrk_evaluation.community_evaluation_open_log_01;
drop table wrk_evaluation.community_evaluation_open_log_01;
create table wrk_evaluation.community_evaluation_open_log_01
as
    insert overwrite table wrk_evaluation.community_evaluation_open_log_01
select t1.timestamp_v,
       t1.community_md5,
       count(1) as open_cnt
from (
         SELECT substring(`@timestamp`, 1, 10)                                                               as timestamp_v,
                regexp_extract(message, '(.*/fang/community/evaluation/)(.*)(/[a-z0-9]+.pdf)', 2)            as community_md5
         from ods_evaluation.community_evaluation_open_log
         where message like '%/fang/community/evaluation/%'
           and substring(`@timestamp`, 1, 10) >= add_months(current_date(), -1)
     ) t1
group by t1.timestamp_v,t1.community_md5;

--list1
----------------------------list1
truncate table dm_evaluation.community_evaluation_log_7_day;
drop table dm_evaluation.community_evaluation_log_7_day;
create table dm_evaluation.community_evaluation_log_7_day
as
insert overwrite table dm_evaluation.community_evaluation_log_7_day
select
    cast(t3.timestamp_v as STRING) as timestamp_v,
    t3.request_city_cnt,
    t3.request_community_cnt,
    t3.response_community_cnt,
    t3.request_cnt,
    t4.response_cnt,
    case when t6.open_cnt is null then 0 else t6.open_cnt end as open_cnt
from
    (select current_date() as timestamp_v,
            count(distinct t2.city_cd)      as request_city_cnt,
            count(distinct t2.community_id) as request_community_cnt,
            count(distinct t5.community_md5) as response_community_cnt,
            count(1)                        as request_cnt
     from wrk_evaluation.community_evaluation_log_src t1
              inner join wrk_evaluation.community_evaluation_log_md5_01 t2
                         on t1.community_md5 = t2.community_md5
              left join (
         select community_md5 from wrk_evaluation.community_evaluation_log_src
         where status = 'community.evaluation.response.success'
           and timestamp_v >= date_add(current_date(), -7)
         group by community_md5
     ) t5
                        on t1.community_md5 = t5.community_md5
     where t1.status = 'community.evaluation.request.success'
       and t1.timestamp_v >= date_add(current_date(), -7)
    ) t3
        left join (
        select
            current_date() as timestamp_v,
            count(1) as response_cnt
        from wrk_evaluation.community_evaluation_log_src t1
                 inner join wrk_evaluation.community_evaluation_log_md5_01 t2
                            on t1.community_md5 = t2.community_md5 and t1.status = 'community.evaluation.response.success'
                                and t1.timestamp_v >= date_add(current_date(), -7)
    ) t4 on t3.timestamp_v = t4.timestamp_v
        left join (
        select current_date() as timestamp_v,
               sum(open_cnt) as open_cnt
        from wrk_evaluation.community_evaluation_open_log_01
        where timestamp_v >= date_add(current_date(), -7)
    ) t6 on t3.timestamp_v = t6.timestamp_v



        --------------------------------------list2
truncate table dm_evaluation.community_evaluation_log_detail;
drop table dm_evaluation.community_evaluation_log_detail;
create table dm_evaluation.community_evaluation_log_detail
as
    insert overwrite table dm_evaluation.community_evaluation_log_detail
select
    cast(coalesce(t3.timestamp_v,t4.timestamp_v) as STRING) as timestamp_v,
    coalesce(t3.city_cd,t4.city_cd) as city_cd,
    coalesce(t3.city_name,t4.city_name) as city_name,
    coalesce(t3.community_id,t4.community_id) as community_id,
    coalesce(t3.community_name,t4.community_name) as community_name,
    coalesce(t3.community_md5,t4.community_md5) as community_md5,
    case when coalesce(t3.request_cnt,t4.request_cnt) is null then 0 else coalesce(t3.request_cnt,t4.request_cnt) end as request_cnt,
    case when coalesce(t3.response_cnt,t4.response_cnt) is null then 0 else coalesce(t3.response_cnt,t4.response_cnt) end as response_cnt,
    case when coalesce(t3.open_cnt,t4.open_cnt) is null then 0 else coalesce(t3.open_cnt,t4.open_cnt) end as open_cnt
from (select t1.timestamp_v,
             t2.city_cd,
             t2.city_name,
             t2.community_id,
             t2.community_name,
             t1.community_md5,
             sum(case when t1.status = 'community.evaluation.request.success' then 1 else 0 end)     as request_cnt,
             sum(case when t1.status in ('community.evaluation.response.success') then 1 else 0 end) as response_cnt,
             null                                                                                      AS open_cnt
      from wrk_evaluation.community_evaluation_log_src t1
               inner join wrk_evaluation.community_evaluation_log_md5_01 t2
                          on t1.community_md5 = t2.community_md5
      where t1.timestamp_v >= date_add(current_date(), -30)
      group by t1.timestamp_v,
               t2.city_cd,
               t2.city_name,
               t2.community_id,
               t2.community_name,
               t1.community_md5
     ) t3
    FULL join
    (
        select  t1.timestamp_v,
                t2.city_cd,
                t2.city_name,
                t2.community_id,
                t2.community_name,
                t1.community_md5,
                null AS request_cnt,
                null AS response_cnt,
                open_cnt as open_cnt
        from wrk_evaluation.community_evaluation_open_log_01 t1
                 inner join wrk_evaluation.community_evaluation_log_md5_01 t2
                            on t1.community_md5 = t2.community_md5
        where timestamp_v >= date_add(current_date(), -30)
    ) t4
on  t4.timestamp_v = t3.timestamp_v


-----------------------------------list3 请求量top10
truncate table dm_evaluation.community_evaluation_log_request_top10;
drop table dm_evaluation.community_evaluation_log_request_top10;
create table dm_evaluation.community_evaluation_log_request_top10
as
    insert overwrite table dm_evaluation.community_evaluation_log_request_top10
    select * from (
    select
    cast(current_date() as STRING)as timestamp_v,
    t2.city_name,
    t2.city_cd,
    t2.community_name,
    t2.community_id,
    t1.community_md5,
    count(1) as request_cnt
    from wrk_evaluation.community_evaluation_log_src t1
             inner join wrk_evaluation.community_evaluation_log_md5_01 t2
                        on t1.community_md5 = t2.community_md5
where t1.timestamp_v >=date_add(current_date(), -7)
group by t2.city_name,
         t2.city_cd,
         t2.community_name,
         t2.community_id,
         t1.community_md5) t3 order by request_cnt desc limit 10
