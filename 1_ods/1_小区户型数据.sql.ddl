
create table ods_evaluation.community_evaluation_month_layout
(
    source_community_id STRING COMMENT '源小区id',
    source_community_name STRING COMMENT '源小区名称',
    city_cd STRING COMMENT '城市编码',
    city_name STRING COMMENT '城市名称',
    district_cd STRING COMMENT '区域编码',
    district_name STRING COMMENT '区域名称',
    block_cd STRING COMMENT '板块编码',
    block_name STRING COMMENT '板块名称',
    house_layout_name STRING COMMENT '户型名称',
    house_layout_no STRING COMMENT '户型编号',
    house_cnt STRING COMMENT '室数',
    build_area STRING COMMENT '建筑面积',
    timestamp_v STRING COMMENT '数据处理时间'
) COMMENT '小区户型数据表'  STORED AS TEXTFILE;