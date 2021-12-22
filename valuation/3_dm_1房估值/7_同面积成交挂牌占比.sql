insert overwrite table dm_evaluation.house_valuation_analysis_same_community_rate
select
    coalesce (t1.community_id,t2.community_id) as community_id,
    coalesce (t1.area_interval,t2.bk_interval) as area_interval,
    t1.community_goods_cnt as community_rack_cnt,
    rank() over(partition by t1.community_id order by t1.community_goods_cnt desc) as community_rack_cnt_rank,
    t1.community_avg_price as rack_avg_price,
    t2.community_cnt as community_deal_cnt,
    rank() over(partition by t2.community_id order by t2.community_cnt desc ) as community_deal_cnt_rank,
    t2.avg_price as deal_avg_price,
    current_timestamp() as timestamp_v,
    substring(current_timestamp(),1,7) as batch_no
from dw_evaluation.house_valuation_rack_community_area_interval t1
full join dw_evaluation.house_valuation_deal_community_area_interval t2
          on t1.community_id=t2.community_id
              and t1.area_interval=t2.bk_interval
where t1.community_goods_cnt is not null