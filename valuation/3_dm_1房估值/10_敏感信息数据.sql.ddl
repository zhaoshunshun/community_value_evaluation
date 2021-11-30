create table dm_evaluation.house_valuation_analysis_same_community_sensitive
(
    community_id String COMMENT '小区id',
    event_id     String COMMENT '事件id',
    event_type   String COMMENT '类型', --加油站、高压线、凶宅、高架、墓地、臭水河、污染源、不利因素、停车相关、卫生相关、气体污染、楼盘问题、居民素质、噪音污染、小区概况、其他、物业
    coordinate   String COMMENT '坐标',
    event_desc   String COMMENT '描述',
    event_time   String COMMENT '发生时间',
    timestamp_v  String COMMENT '数据处理时间'
)COMMENT '敏感信息数据' STORED AS TEXTFILE;
