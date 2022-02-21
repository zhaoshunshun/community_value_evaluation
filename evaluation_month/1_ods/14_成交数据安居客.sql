insert overwrite table wrk_evaluation.community_evaluation_deal_ajk_pre
select *,row_number() over (partition by city,title_id,goods_id order by create_time desc) as ranks
from ods_house.community_deal_info
where info_src='AJK'
