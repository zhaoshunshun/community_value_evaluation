

insert overwrite table dm_evaluation.community_evaluation_city_analysis_report
select * from
    (
select
    coalesce(t3.month,t1.month) as month,
    coalesce(t3.city_cd,t1.city_cd) as city_id,
    coalesce(t3.city_name,t1.city_name) as city_name,
    cast(t1.list_cnt as STRING) as list_cnt,
    cast(cast(t3.deal_cnt/t1.list_cnt as decimal(11,4)) as STRING) as deal_cnt,
    cast(t1.list_avg_price as STRING) as list_avg_price,
    cast(t3.deal_avg_price as STRING) as deal_avg_price,
    cast(cast(t2.list_up_rate*100 as decimal(11,2)) as STRING) as list_up_rate,
    cast(cast(t2.list_down_rate*100 as decimal(11,2)) as STRING) as list_down_rate,
    current_timestamp() as timestamp_v
from wrk_evaluation.community_evaluation_list_city t1
left join wrk_evaluation.community_evaluation_list_city_change_price_2 t2
       on t1.month=t2.month
       and t1.city_cd=t2.city_cd
full join wrk_evaluation.community_evaluation_deal_city t3
       on t1.month=t3.month
       and t1.city_cd=t3.city_cd
) t4
where concat(t4.month,'-01') > add_months(current_timestamp(),-7)
  and t4.month< substring(current_timestamp(),1,7);








