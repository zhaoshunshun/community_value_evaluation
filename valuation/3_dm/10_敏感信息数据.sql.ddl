
create table dm_evaluation.house_valuation_analysis_same_community_sensitive(
community_id String COMMENT '小区id',
community_name String COMMENT '小区名称',
gas_station_list String COMMENT '加油站',
transformer_list String COMMENT '变电站',
haunt_house_list String COMMENT '凶宅',
sewage_list String COMMENT '臭水沟',
trestle_list String COMMENT '高架',
polluter_list String COMMENT '污染源',
cemetery_list String COMMENT '墓地',
adverse_list String COMMENT '不利因素',
community_comment String COMMENT '小区描述',
timestamp_v String COMMENT '数据处理时间'
)COMMENT '敏感信息数据' STORED AS TEXTFILE;

