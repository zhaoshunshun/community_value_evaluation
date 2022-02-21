
insert overwrite table ods_evaluation.community_evaluation_dianping
select city_id,
       city as city_name,
       market_region,
       shop_id,
       shop_name,
       shop_tag,
       shop_per_capita_consumption,
       shop_address,
       market_id,
       market_name,
       market_gd_location,
       row_number() over (partition by shop_id order by create_time desc) as ranks
from ods_house.ods_client_base_info
where batch_no = '1000028120201016_093438'
  and shop_tag like '%美食%'
;

insert overwrite table wrk_evaluation.community_evaluation_dianping_01
select city_name,
       city_id,
       market_region,
       market_id,
       market_name,
       avg(cast(shop_per_capita_consumption as decimal(11,2))) as avg_per_capita_consumption
from ods_evaluation.community_evaluation_dianping
where ranks = 1
group by city_name, city_id, market_region, market_id, market_name;

