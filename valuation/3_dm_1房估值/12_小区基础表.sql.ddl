CREATE TABLE  dm_evaluation.house_valuation_community_base
(
    city_cd        String COMMENT '城市id',
    city_name      String COMMENT '城市名称',
    district_cd    String COMMENT '小区区域id',
    district_name  String COMMENT '小区区域',
    block_cd       String COMMENT '小区板块id',
    block_name     String COMMENT '小区板块',
    community_id   String COMMENT '小区id',
    community_name String COMMENT '小区名称',
    community_addr String COMMENT '小区地址',
    timestamp_v    String COMMENT '数据更新时间'
) COMMENT '小区基础信息表' STORED AS TEXTFILE;