insert overwrite table dm_evaluation.community_month_report_school
select
    community_id,
    school_id,
    school_fance,
    school_coordinate,
    enrollment_nums,
    community_school_distince,
    school_desc,
    school_addr,
    school_name,
    school_enrollment_target,
    school_fee,
    school_type,
    school_segment_grade,
    school_characteristics,
    school_scope_road,
    substring(current_timestamp(),1,7) as batch_no,    --批次号
    current_timestamp() as timestamp_v          --数据处理时间
from dw_evaluation.community_evaluation_community_school_map