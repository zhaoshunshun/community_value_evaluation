insert overwrite table dm_evaluation.community_month_report_strategy
select
    t1.community_id,
    t1.community_desc,
    t1.live_population,
    t1.atmosphere,
    t1.property_services,
    t1.parking_conditions,
    t1.advantage,
    t1.shortcoming,
    t1.proprietor_speak,
    t1.facilities,
    t1.facilities_desc,
    substring(add_months(current_timestamp(),-1),1,7) as batch_no,    --批次号
    current_timestamp() as timestamp_v          --数据处理时间
from dw_evaluation.community_evaluation_bk_month_strategy  t1