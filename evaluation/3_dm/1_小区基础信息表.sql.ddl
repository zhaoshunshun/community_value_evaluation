truncate table dm_evaluation.community_month_report_base_info
drop table  dm_evaluation.community_month_report_base_info
create table dm_evaluation.community_month_report_base_info(
    community_id STRING COMMENT '小区id',
    community_name STRING COMMENT '小区名称',
    city_cd STRING COMMENT '城市编码',
    city_name STRING COMMENT '城市名称',
    district_cd STRING COMMENT '区域编码',
    district_name STRING COMMENT '区域名称',
    block_cd STRING COMMENT '板块编码',
    block_name STRING COMMENT '板块名称',
    addr STRING COMMENT '小区地址',
    coordinate STRING COMMENT '小区坐标',
    fence STRING COMMENT '小区围栏',
    avg_price STRING COMMENT '小区均价',
    ratio_month STRING COMMENT '小区均价环比',
    rack_month_six STRING COMMENT '小区均价半年涨幅',   --置空
    district_rack_month_six STRING COMMENT '区域小区均价半年涨幅',   --置空
    building_year STRING COMMENT '小区建筑年代',
    building_num STRING COMMENT '小区楼栋数量',
    building_area STRING COMMENT '小区占地面积',
    room_num STRING COMMENT '小区户数',
    property_type STRING COMMENT '小区物业类型',
    property_fee STRING COMMENT '小区物业费',
    developers STRING COMMENT '小区开发商',
    property_company STRING COMMENT '小区物业公司',
    volume_rate STRING COMMENT '小区容积率',
    green_rate STRING COMMENT '小区绿化率',
    parking_rate STRING COMMENT '小区车户比',
    person_div_car_ind STRING COMMENT '是否人车分流',
    building_age STRING COMMENT '小区楼龄',
    elevator_desc STRING COMMENT '是否有电梯描述',
    is_living_quility STRING COMMENT '品质',
    is_rack STRING COMMENT '是否有挂牌',
    is_deal STRING COMMENT '是否有成交',
    batch_no STRING COMMENT '批次号',
    timestamp_v timestamp COMMENT '数据处理时间'
)COMMENT '小区基础信息表'  STORED AS TEXTFILE;