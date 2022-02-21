insert overwrite table dm_evaluation.community_month_report_school
select
    '' as community_id,
    t1.school_id,
    t1.school_fance,
    t1.school_coordinate,
    t1.enrollment_nums,
    t1.community_school_distince,
    t1.school_desc,
    t1.school_addr,
    t1.school_name,
    t1.school_enrollment_target,
    t1.school_fee,
    t1.school_type,
    t1.school_segment_grade,
    t1.school_characteristics,
    case when t1.school_scope_road like '%460弄栖山家园%' then '' else t1.school_scope_road end as school_scope_road,
    substring(add_months(current_timestamp(),-1),1,7) as batch_no,    --批次号
    current_timestamp() as timestamp_v          --数据处理时间
from
    (
        select *,row_number() over(partition by school_id order by school_id ) as ranks2 from dw_evaluation.community_evaluation_community_school_map
    ) t1
where ranks2 =1