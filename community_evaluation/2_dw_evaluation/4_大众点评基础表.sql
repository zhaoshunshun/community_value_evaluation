
insert overwrite table dw_evaluation.community_evaluation_dianping
select distinct t1.city_id,
                t1.city_name,
                t1.market_region,
                t1.shop_id,
                t1.shop_name,
                t1.shop_tag,
                t1.shop_per_capita_consumption,
                t1.shop_address,
                t1.market_id,
                t1.market_name,
                t1.market_gd_location,
                t2.avg_per_capita_consumption,
                current_timestamp() as timestamp_v
from ods_evaluation.community_evaluation_dianping t1
         left join wrk_evaluation.community_evaluation_dianping_01 t2
                   on t1.city_name = t2.city_name
                       and t1.city_id = t2.city_id
                       and t1.market_region = t2.market_region
                       and t1.market_id = t2.market_id
                       and t1.market_name = t2.market_name;