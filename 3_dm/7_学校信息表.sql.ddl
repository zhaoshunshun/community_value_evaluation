
truncate table dm_evaluation.community_month_report_school;
drop table dm_evaluation.community_month_report_school;
create table dm_evaluation.community_month_report_school
(
    community_id STRING COMMENT '小区id',
    school_id STRING COMMENT '学校id',
    school_fance STRING COMMENT '学校围栏',
    school_coordinate STRING COMMENT '学校坐标',
    enrollment_nums STRING COMMENT '招生人数',
    community_school_distince STRING COMMENT '小区学校距离',
    school_desc STRING COMMENT '学校简介',
    school_addr STRING COMMENT '学校地址',
    school_name STRING COMMENT '学校名称',
    school_enrollment_target STRING COMMENT '招生对象',
    school_fee STRING COMMENT '学校学费',
    school_type STRING COMMENT '办学类型（公办/私半）',
    school_segment_grade STRING COMMENT '阶段等级（幼儿园、小学、中学）',
    school_characteristics STRING COMMENT '学校特色',
    school_scope_road STRING COMMENT '学校范围路段',
    batch_no STRING COMMENT '批次号',
    timestamp_v timestamp COMMENT '数据处理时间'
)COMMENT '小区学校信息表'  STORED AS TEXTFILE;