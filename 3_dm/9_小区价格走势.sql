
insert overwrite table dm_evaluation.community_month_price_report
    select
    t1.community_id,
    t1.district_cd,
    t1.district_name,
    t1.month,
    t2.monthly_avg_price_desc as community_avg_price,
    t3.monthly_avg_price_desc as district_avg_price,
    substring(cast(current_timestamp() as STRING), 1, 7)            as batch_no,
    current_timestamp()                             as timestamp_v --数据处理时间
from (select t1.community_id, t1.district_cd, t1.district_name, t2.month_short_desc as month
    from dw_evaluation.community_month_report_base_info t1
    inner join (
    select distinct month_short_desc
    from asset_common.olap_date
    where month_short_desc >= substring(cast(add_months(current_timestamp (), -6) as string), 1, 7)
    and month_short_desc <= substring(cast(add_months(current_timestamp (), -1) as string), 1, 7)
    ) t2
    on 1 = 1
    ) t1
left join dw_evaluation.community_avg_price_detail t2
on t1.community_id = t2.community_id
and t1.month =t2.biz_time
left join (
    select
    district_cd,
    biz_time as month,
    cast(sum(case when monthly_avg_price_desc <> 0 then monthly_avg_price_desc else 0 end )/sum(case when monthly_avg_price_desc <> 0 then 1 else 0 end) as DECIMAL(13,2)) as monthly_avg_price_desc
    from dw_evaluation.community_avg_price_detail
    group by district_cd,biz_time
    ) t3
on t1.district_cd  = t3.district_cd
and t1.month = t3.month