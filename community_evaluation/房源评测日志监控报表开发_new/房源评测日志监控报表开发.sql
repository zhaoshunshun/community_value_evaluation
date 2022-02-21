
--房源评测的访问日志
truncate table wrk_evaluation.house_evaluation_log_src;
drop table wrk_evaluation.house_evaluation_log_src;
create table wrk_evaluation.house_evaluation_log_src as
    insert overwrite table wrk_evaluation.house_evaluation_log_src
select
    substring(`@timestamp`,1,10) as timestamp_v,
    get_json_object(message,'$.appName') as appname,
    get_json_object(message,'$.key') as status,
    get_json_object(get_json_object(message,'$.value'),'$.houseId') as house_id,
    get_json_object(get_json_object(message,'$.value'),'$.communityId') as community_md5,
    get_json_object(get_json_object(message,'$.value'),'$.url') as request_pdf
from ods_evaluation.community_evaluation_log
where get_json_object(message,'$.appName') ='source-evaluation-api'
  and substring(`@timestamp`,1,10) >= add_months(current_date(),-1);

--房源评测的打开日志
truncate table wrk_evaluation.house_evaluation_open_log_01;
drop table wrk_evaluation.house_evaluation_open_log_01;
create table wrk_evaluation.house_evaluation_open_log_01
    as
    insert overwrite table wrk_evaluation.house_evaluation_open_log_01
    select t1.timestamp_v,
           t1.community_md5,
           count(1) as open_cnt
from (
         SELECT substring(`@timestamp`, 1, 10)                                                               as timestamp_v,
                split(regexp_extract(message, '(.*/fang/house/evaluation/)(.*)(/[a-z0-9]+.pdf)', 2),
                      '/')[0]                                                                                as community_md5,
                split(regexp_extract(message, '(.*/fang/house/evaluation/)(.*)(/[a-z0-9]+.pdf)', 2), '/')[1] as house_id
         from ods_evaluation.community_evaluation_open_log
         where message like '%/fang/house/evaluation/%'
           and message like '%evaluation.ejudata.com%'
           and substring(`@timestamp`, 1, 10) >= add_months(current_date(), -1)
     ) t1 where  t1.house_id <> ''
    group by t1.timestamp_v,t1.community_md5;

truncate table wrk_evaluation.house_evaluation_log_md5_01;
drop table wrk_evaluation.house_evaluation_log_md5_01;
create table wrk_evaluation.house_evaluation_log_md5_01 as
    insert overwrite table wrk_evaluation.house_evaluation_log_md5_01
select
    t2.community_id,
    t2.community_name,
    t1.comm_md5 as community_md5,
    t1.rn,
    t1.channel,
    t2.city_cd,
    t2.city_name
from dm_house.dm_community_md5_map t1
inner join ods_house.ods_house_asset_community t2
     on t1.code = t2.community_id
         and t1.name='community_id'
         and t1.channel='fangyou';



----------------------------list1
truncate table dm_evaluation.house_evaluation_log_7_day;
drop table dm_evaluation.house_evaluation_log_7_day;
create table dm_evaluation.house_evaluation_log_7_day
    as
insert overwrite table dm_evaluation.house_evaluation_log_7_day
select
    cast(t3.timestamp_v as STRING) as timestamp_v,
    t3.request_city_cnt,
    t3.request_community_cnt,
    t3.response_community_cnt,
    t3.request_cnt,
    t4.response_cnt,
    case when t6.open_cnt is null then 0  else t6.open_cnt end as open_cnt
from
    (select current_date() as timestamp_v,
            count(distinct t2.city_cd)      as request_city_cnt,
            count(distinct t2.community_id) as request_community_cnt,
            count(distinct t5.community_md5) as response_community_cnt,
            count(1)                        as request_cnt
     from wrk_evaluation.house_evaluation_log_src t1
        inner join wrk_evaluation.house_evaluation_log_md5_01 t2
            on t1.community_md5 = t2.community_md5
        left join (
            select community_md5 from wrk_evaluation.house_evaluation_log_src
            where status = 'house.evaluation.response.success'
              and timestamp_v >= date_add(current_date(), -7)
            group by community_md5
         ) t5
            on t1.community_md5 = t5.community_md5
        where t1.status = 'house.evaluation.request.success'
            and t1.timestamp_v >= date_add(current_date(), -7)
    ) t3
        left join (
        select current_date() as timestamp_v,
               count(1)                        as response_cnt
        from wrk_evaluation.house_evaluation_log_src t1
                 inner join wrk_evaluation.house_evaluation_log_md5_01 t2
                            on t1.community_md5 = t2.community_md5 and t1.status = 'house.evaluation.response.success'
                                and t1.timestamp_v >= date_add(current_date(), -7)
    ) t4 on t3.timestamp_v = t4.timestamp_v
        left join (
           select current_date() as timestamp_v,
                  sum(open_cnt) as open_cnt
                  from wrk_evaluation.house_evaluation_open_log_01
           where timestamp_v >= date_add(current_date(), -7)
    ) t6 on t3.timestamp_v = t6.timestamp_v



--------------------------------------list2
truncate table dm_evaluation.house_evaluation_log_detail;
drop table dm_evaluation.house_evaluation_log_detail;
create table dm_evaluation.house_evaluation_log_detail
    as
    insert overwrite table dm_evaluation.house_evaluation_log_detail
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
             sum(case when t1.status = 'house.evaluation.request.success' then 1 else 0 end)     as request_cnt,
             sum(case when t1.status in ('house.evaluation.response.success') then 1 else 0 end) as response_cnt,
             null                                                                                      AS open_cnt
      from wrk_evaluation.house_evaluation_log_src t1
               inner join wrk_evaluation.house_evaluation_log_md5_01 t2
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
        from wrk_evaluation.house_evaluation_open_log_01 t1
                 inner join wrk_evaluation.house_evaluation_log_md5_01 t2
                            on t1.community_md5 = t2.community_md5
        where timestamp_v >= date_add(current_date(), -30)
    ) t4
on  t4.timestamp_v = t3.timestamp_v







