
insert overwrite table dm_evaluation.house_valuation_community_base
select
    city_cd,
    city_name,
    district_cd,
    district_name,
    block_cd,
    block_name,
    community_id,
    community_name,
    community_addr,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_community_detail