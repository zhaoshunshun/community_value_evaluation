create table ods_evaluation.community_evaluation_month_shangnaxue
(
    school_id STRING COMMENT '学校id',
    city_name STRING COMMENT '城市名称',
    district_name STRING COMMENT '区域名称',
    coordinate STRING COMMENT '坐标',
    school_desc STRING COMMENT '学校简介',
    school_scope_road STRING COMMENT '学校范围路段',
    school_enrollment_target STRING COMMENT '招生对象',
    school_addr STRING COMMENT '学校地址',
    school_name STRING COMMENT '学校名称',
    school_type STRING COMMENT '办学类型（公办/私半）',
    school_segment_grade STRING COMMENT '阶段等级（幼儿园、小学、中学）',
    school_fee STRING COMMENT '学校费用',
    school_characteristics STRING COMMENT '学校特色',
    timestamp_v timestamp COMMENT '数据处理时间'
)COMMENT '上哪学数据清洗表'
    STORED AS TEXTFILE;