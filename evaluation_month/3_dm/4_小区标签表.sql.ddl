create table dm_evaluation.community_month_report_label
(
    community_id STRING COMMENT '小区id',
    label_traffic STRING COMMENT '交通便利标签',
    label_facilities STRING COMMENT '小区配套标签',
    label_parking STRING COMMENT '小区车位比标签',
    label_elevator STRING COMMENT '小区电梯标签',
    label_sub STRING COMMENT '小区地铁标签',
    label_arround_facilities STRING COMMENT '小区周边配套标签',
    label_park STRING COMMENT '小区周边公园标签',
    label_school STRING COMMENT '小区学校标签',
    label_price STRING COMMENT '小区房价涨幅标签',
    label_green STRING COMMENT '小区绿化率标签',
    label_age STRING COMMENT '小区房龄标签',
    label_rent STRING COMMENT '小区租房标签',
    batch_no STRING COMMENT '批次号',
    timestamp_v timestamp COMMENT '数据处理时间'
) COMMENT '小区攻略数据表'  STORED AS TEXTFILE;