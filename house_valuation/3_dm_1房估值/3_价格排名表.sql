insert overwrite table  dm_evaluation.house_valuation_analysis_goods_rank
select
    t1.rack_house_id as goods_id,
    t1.house_avg_price as goods_price,
    t1.community_id,
    t1.block_cd,
    t2.monthly_avg_price_desc as community_avg_price,
    t3.block_avg_price as block_avg_price,
    rank() over(partition by t1.block_cd order by t1.house_avg_price desc) as block_avg_price_rank,
    t5.block_rack_cnt,
    t5.block_median_rack_price,
    t6.block_community_cnt,
    t7.block_community_avg_price_rank,
    t6.block_med_community_avg_price,
    t1.district_cd,
    rank() over(partition by t1.district_cd order by t1.house_avg_price desc) as district_avg_price_rank,
    current_timestamp() as timestamp_v,
    substring(current_timestamp(),1,7) as batch_no
from  dw_evaluation.house_valuation_rack_detail t1
left join dw_evaluation.house_valuation_community_month_price t2
on t1.community_id = t2.community_id and t2.ranks = 1
left join dw_evaluation.house_valuation_block_month_price t3
on t1.block_cd = t3.block_cd and t3.ranks =1
left join dw_evaluation.house_valuation_district_month_price t4
on t1.district_cd = t4.district_cd and t4.ranks =1
left join (
    select block_cd,
           count(1) as block_rack_cnt,
           percentile_approx(house_avg_price,0.5) as block_median_rack_price
        from dw_evaluation.house_valuation_rack_detail where month_dt = substring(add_months(current_date,-1),1,7) group by block_cd
    ) t5 on t1.block_cd = t5.block_cd
left join (
select block_cd,
        count(1) as block_community_cnt,
        percentile_approx(monthly_avg_price_desc,0.5) as block_med_community_avg_price
from dw_evaluation.house_valuation_community_month_price where biz_time =substring(add_months(current_date,-1),1,7)  group by block_cd
) t6 on t1.block_cd = t6.block_cd
left join (
    select community_id,
    rank() over(partition by block_cd order by monthly_avg_price_desc desc) as block_community_avg_price_rank
    from dw_evaluation.house_valuation_community_month_price where biz_time =substring(add_months(current_date,-1),1,7)
) t7 on t1.community_id = t7.community_id
where t1.month_dt = substring(add_months(current_date,-1),1,7)