
insert overwrite table dm_evaluation.community_evaluation_analysis_report
select
    t1.month,
    t1.city_cd as city_id,
    t1.city_name,
    cast(t1.community_id as STRING) as community_id,
    t1.community_name as community_name,
    cast(cast(t1.list_cnt as decimal(11,2)) as STRING) as list_cnt,
    cast(cast(t2.deal_cnt/t1.list_cnt as decimal(11,4)) as STRING) as deal_cnt,
    cast(cast(t1.list_avg_price as decimal(11,2)) as STRING) as list_avg_price,
    cast(cast(t2.deal_avg_price as decimal(11,2)) as STRING) as deal_avg_price,
    current_timestamp() as timestamp_v
from wrk_evaluation.community_evaluation_list_community t1
         full join wrk_evaluation.community_evaluation_deal_community t2
        on t1.city_cd=t2.city_cd
            and t1.community_id =t2.community_id
            and t1.month=t2.month
where concat(t1.month,'-01') > add_months(current_timestamp(),-7) and t1.month< substring(current_timestamp(),1,7);
