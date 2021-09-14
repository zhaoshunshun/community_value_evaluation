
insert overwrite table dm_evaluation.community_month_deal_report
select t1.community_id,
    t1.district_cd,
    t1.district_name,
    t1.month,
    t2.cnt as community_deal_cnt,
    t3.cnt as district_deal_cnt,
    substring(cast(current_timestamp() as STRING), 1, 7)            as batch_no,
    current_timestamp()                             as timestamp_v --数据处理时间
from (
    select t1.community_id, t1.district_cd, t1.district_name, t2.month_short_desc as month
    from dw_evaluation.community_month_report_base_info t1
             inner join (select distinct month_short_desc
                         from asset_common.olap_date
                         where month_short_desc >= substring(cast(add_months(current_timestamp(), -6) as string), 1, 7)
                           and month_short_desc <= substring(cast(add_months(current_timestamp(), -1) as string), 1, 7)
    ) t2
                        on 1 = 1
) t1
         left join (
    select community_id,
        substring(deal_date, 1, 7) as month,
        count(1)                   as cnt
    from dw_evaluation.community_evaluation_month_deal
    where substring(deal_date, 1, 7) >= substring(cast(add_months(current_timestamp(), -6) as string), 1, 7)
    group by community_id, substring(deal_date, 1, 7)
) t2
                   on t1.community_id = t2.community_id
                       and t1.month = t2.month
         left join (
    select district_cd,
        substring(deal_date, 1, 7) as month,
        count(1)                   as cnt
    from dw_evaluation.community_evaluation_month_deal
    where substring(deal_date, 1, 7) >= substring(cast(add_months(current_timestamp(), -6) as string), 1, 7)
    group by district_cd, substring(deal_date, 1, 7)
) t3
                   on t1.district_cd = t3.district_cd
                       and t1.month = t3.month
