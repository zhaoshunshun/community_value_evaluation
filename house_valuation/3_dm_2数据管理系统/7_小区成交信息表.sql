
insert overwrite table dm_evaluation.deal_month_community
select
substring(deal_date,1,7) as month,
community_id,
community_name,
community_addr as community_address,
city_cd,
city_name,
district_cd,
district_name,
block_cd,
block_name,
count(1) as deal_cnt,
cast(sum(case when avg_price is not null then avg_price else 0 end )/sum(case when avg_price is not null  then 1 else 0 end) as int)as deal_avg_price,
case when info_src ='cric' then '内部' else '外部' end as info_src,
row_number() over(partition by city_cd,substring(deal_date,1,7) order by substring(deal_date,1,7) desc,count(1) desc) as ranks,
current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_month_deal
group by
    substring(deal_date,1,7),
    community_id,
    community_name,
    community_addr,
    city_cd,
    city_name,
    district_cd,
    district_name,
    block_cd,
    block_name,
    info_src