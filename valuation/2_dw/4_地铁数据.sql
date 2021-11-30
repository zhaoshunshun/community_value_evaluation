create table dw_evaluation.house_valuation_community_subway_distance
as
    insert overwrite table dw_evaluation.house_valuation_community_subway_distance
select community_id,
       distance
from (
select community_id,
       address,
       name,
       distance,
       row_number() over(partition by community_id order by distance desc) as ranks
from ods_evaluation.ods_community_evaluation_community_mon_report_facilitate
where types = '150500'
) t1 where t1.ranks = 1