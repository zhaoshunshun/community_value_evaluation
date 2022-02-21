
--------明细
create table community_evaluation.t_community_analysis_detail
as
select
    t1.create_time,
    t3.city_name,
    t3.city_id,
    t3.community_name,
    t3.community_id,
    t1.community_md5,
    case when t1.request_type =1 then t1.request_cnt else null end as request_cnt_all,
    case when t4.community_id  is null then '无' else '有' end as have_eval,
    case when t1.request_type =2 then  t1.request_cnt end as open_cnt_all
from community_evaluation.t_community_request t1
         inner join community_evaluation.community_evaluation_md5_map t2
                    on t1.community_md5 = t2.community_md5
         left join community_evaluation.community_evaluation_detail_all t3
                   on t2.community_id = t3.community_id
         left join community_evaluation.community_evaluation_url t4
                   on t3.community_id = t4.community_id
         left join (
    select t6.create_time,
           t6.community_md5,
           t6.request_cnt
    from community_evaluation.t_community_request  t6
    where t6.request_type =2
) t5 on t1.community_md5=t5.community_md5
    and t1.create_time=t5.create_time
where t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)


------总
create table community_evaluation.t_community_analysis_week_all as
select
    CURDATE() as timestamp_v,
    sum(t1.request_cnt) as request_cnt_all,
    count(distinct t1.community_md5) as request_community_cnt,
    count(distinct t2.community_md5) as return_community_cnt,
    max(t3.request_cnt) as opnet_cnt_all,
    concat(max(t3.request_cnt)/ sum(t1.request_cnt) *100,'%') as open_rate
from
    ( select CURDATE() as curr_date,
             t1.community_md5,
             SUM(t1.request_cnt) as request_cnt
      from
          community_evaluation.t_community_request t1
              inner join community_evaluation.community_evaluation_md5_map t2
                         on t1.community_md5 = t2.community_md5
      where t1.request_type=1
        and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
      group by t1.community_md5
    ) t1
        left join (
        select
            t1.community_md5,
            sum(t1.request_cnt) as request_cnt
        from community_evaluation.t_community_request t1
                 inner join community_evaluation.community_evaluation_md5_map t2
                            on t1.community_md5 = t2.community_md5
                 inner join community_evaluation.community_evaluation_url t3
                            on t2.community_id = t3.community_id
        where t1.request_type=2 and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        group by t1.community_md5

    ) t2
                  on t1.community_md5=t2.community_md5
        left join (
        select
            CURDATE() as curr_date,
            sum(t1.request_cnt) as request_cnt
        from community_evaluation.t_community_request t1
        where t1.request_type=2 and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)

    )t3 on t1.curr_date=t3.curr_date


--by_city
create table community_evaluation.t_community_analysis_week_all_by_city as
select CURDATE()                                                    as timestamp_v,
       t1.city_name,
       sum(t1.request_cnt)                                          as request_cnt_all,
       count(distinct t1.community_md5)                             as request_community_cnt,
       count(distinct t2.community_md5)                             as return_community_cnt,
       null                                                         as return_cnt_all,
       null                                                         as request_rate,
       max(t3.request_cnt)                                          as opnet_cnt_all,
       concat(max(t3.request_cnt) / sum(t1.request_cnt) * 100, '%') as open_rate
from (select CURDATE()           as curr_date,
             t3.city_name,
             t1.community_md5,
             SUM(t1.request_cnt) as request_cnt
      from community_evaluation.t_community_request t1
               inner join community_evaluation.community_evaluation_md5_map t2
                         on t1.community_md5 = t2.community_md5
               left join community_evaluation.community_evaluation_detail_all t3
                         on t2.community_id = t3.community_id
      where t1.request_type = 1
        and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
      group by t1.community_md5, t3.city_name
     ) t1
         left join (
    select t1.community_md5,
           t4.city_name,
           sum(t1.request_cnt) as request_cnt
    from community_evaluation.t_community_request t1
             inner join community_evaluation.community_evaluation_md5_map t2
                        on t1.community_md5 = t2.community_md5
             inner join community_evaluation.community_evaluation_url t3
                        on t2.community_id = t3.community_id
             left join community_evaluation.community_evaluation_detail_all t4
                       on t3.community_id = t4.community_id
    where t1.request_type = 2
      and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    group by t1.community_md5, t4.city_name
) t2
                   on t1.community_md5 = t2.community_md5
                       and t1.city_name = t2.city_name
         left join (
    select CURDATE()           as curr_date,
           t3.city_name,
           sum(t1.request_cnt) as request_cnt
    from community_evaluation.t_community_request t1
             inner join community_evaluation.community_evaluation_md5_map t2
                       on t1.community_md5 = t2.community_md5
             left join community_evaluation.community_evaluation_detail_all t3
                       on t2.community_id = t3.community_id
    where t1.request_type = 2
      and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    group by t3.city_name
) t3 on t1.curr_date = t3.curr_date and t1.city_name =t3.city_name
group by t1.city_name


--请求量排行

create table community_evaluation.t_community_analysis_week_top10 as
select
    CURDATE() as timestamp_v,
    t3.city_name,
    t3.city_id,
    t3.community_name,
    t3.community_id,
    t1.community_md5,
    sum(t1.request_cnt) as request_cnt

from community_evaluation.t_community_request t1
         inner join community_evaluation.community_evaluation_md5_map t2
                    on t1.community_md5 = t2.community_md5
         left join community_evaluation.community_evaluation_detail_all t3
                   on t2.community_id = t3.community_id
where t1.request_type =1
  and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
group by t3.city_name,
         t3.city_id,
         t3.community_name,
         t3.community_id,
         t1.community_md5
order by sum(t1.request_cnt) desc limit  10



--请求量排行by_city
drop table community_evaluation.t_community_analysis_week_top10_by_city;
create table community_evaluation.t_community_analysis_week_top10_by_city as
select t6.city_name,
       t6.city_id,
       t6.community_name,
       t6.community_id,
       t6.community_md5,
       t6.request_cnt
from (select t3.city_name,
             t3.city_id,
             t3.community_name,
             t3.community_id,
             t1.community_md5,
             sum(t1.request_cnt) as request_cnt
      from community_evaluation.t_community_request t1
               inner join community_evaluation.community_evaluation_md5_map t2
                          on t1.community_md5 = t2.community_md5
               left join community_evaluation.community_evaluation_detail_all t3
                         on t2.community_id = t3.community_id
      where t1.request_type = 1
        and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
      group by t3.city_name,
               t3.city_id,
               t3.community_name,
               t3.community_id,
               t1.community_md5) t6
where 10> (
    select count(*)
    from
        (select t3.city_name,
                t3.city_id,
                t3.community_name,
                t3.community_id,
                t1.community_md5,
                sum(t1.request_cnt) as request_cnt
         from community_evaluation.t_community_request t1
                  inner join community_evaluation.community_evaluation_md5_map t2
                             on t1.community_md5 = t2.community_md5
                  left join community_evaluation.community_evaluation_detail_all t3
                            on t2.community_id = t3.community_id
         where t1.request_type = 1
           and t1.create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
         group by t3.city_name,
                  t3.city_id,
                  t3.community_name,
                  t3.community_id,
                  t1.community_md5) t7
    where t7.city_name = t6.city_name and t7.request_cnt > t6.request_cnt  )
order by t6.city_name ,t6.request_cnt desc

