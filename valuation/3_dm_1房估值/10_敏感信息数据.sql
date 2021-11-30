

insert overwrite table  dm_evaluation.house_valuation_analysis_same_community_sensitive
select
t1.community_id,
t2.id as event_id,
t2.event_type,
t2.coordinate,
t2.event_desc,
t2.event_time,
current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_community_detail t1
inner join dw_evaluation.house_valuation_analysis_same_community_sensitive t2
on t1.city_name= t2.city
and t1.community_name = t2.title