
--------明细
select
    t1.create_time,
    t3.city_name,
    t3.city_id,
    t3.community_name,
    t3.community_id,
    t1.community_md5,
    t1.request_cnt as request_cnt_all,
    '',
    case when t4.community_id  is null then '无' else '有' end as have_eval,
    t5.request_cnt as open_cnt_all
from (select * from community_evaluation.t_community_request where request_type =1) t1
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





------总

select
    CURDATE() as timestamp_v,
    sum(t1.request_cnt) as request_cnt_all,
    count(distinct t1.community_md5) as request_community_cnt,
    count(distinct t2.community_md5) as return_community_cnt,
    null as return_cnt_all,
    null as request_rate,
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

select CURDATE()                                                    as timestamp_v,
       t1.city_name,
       sum(t1.request_cnt)                                          as request_cnt_all,
       count(distinct t1.community_md5)                             as request_community_cnt,
       count(distinct t2.community_md5)                             as return_community_cnt,
       null                                                         as return_cnt_all,
       null                                                         as request_rate,
       sum(t3.request_cnt)                                          as opnet_cnt_all,
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

select *
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
               t1.community_md5) a
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
                  t1.community_md5) b
    where b.city_name = a.city_name and b.request_cnt > a.request_cnt  )
order by a.city_name ,a.request_cnt desc

