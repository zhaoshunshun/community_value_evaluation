create table dw_evaluation.community_month_rent_info as
    insert overwrite table dw_evaluation.community_month_rent_info
select
       t1.city_cd as city_cd,
       t1.community_id as community_id,
       t1.rent_days as community_rent_days,
       t2.rent_days as city_rent_days,
       current_timestamp() as timestamp_v
       from
(select s_city_cd as city_cd
      , s_community_id as community_id
      , sum(datediff(s_off_date, s_rent_date)) / count(1) rent_days
 from eju_dwd.dwd_event_rent_detail
 where s_rent_date >= substr(cast(add_months(current_timestamp(), -4) as string), 1, 10)
   and s_off_date is not null
   and s_rent_date is not null
 group by s_city_cd, s_community_id) t1
    left join (
select
    s_city_cd as city_cd
     ,sum(datediff(s_off_date,s_rent_date))/count(1) rent_days
from eju_dwd.dwd_event_rent_detail
where s_rent_date >= substr(cast(add_months(current_timestamp(),-4) as string),1,10)
  and s_off_date is not null
  and s_rent_date is not null
group by s_city_cd
) t2
on t1.city_cd = t2.city_cd