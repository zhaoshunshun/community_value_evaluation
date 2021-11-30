
create table dm_evaluation.house_valuation_analysis_report
as
    insert overwrite table dm_evaluation.house_valuation_analysis_report
select
    t1.biz_time as month,
    t1.community_id,
    t1.monthly_avg_price_desc as community_avg_price,
    t2.block_avg_price,
    t3.district_avg_price,
    t4.monthly_avg_price_desc as community_current_avg_price,
    (t1.monthly_avg_price_desc - t5.monthly_avg_price_desc)/t5.monthly_avg_price_desc as community_price_month,
    (t1.monthly_avg_price_desc - t6.monthly_avg_price_desc)/t6.monthly_avg_price_desc as community_price_half_year,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_community_month_price t1
left join  dw_evaluation.house_valuation_block_month_price t2
on t1.block_cd = t2.block_cd and t2.biz_time = t1.biz_time
left join dw_evaluation.house_valuation_district_month_price t3
on t1.district_cd = t3.district_cd and  t3.biz_time = t1.biz_time
left join (
    select community_id,
    monthly_avg_price_desc
    from dw_evaluation.house_valuation_community_month_price
    where ranks = 1
) t4
on t1.community_id = t4.community_id
left join dw_evaluation.house_valuation_community_month_price t5
on t1.community_id = t5.community_id
and t1.ranks = t5.ranks - 1
left join dw_evaluation.house_valuation_community_month_price t6
on t1.community_id = t6.community_id
and t1.ranks = t6.ranks - 6


