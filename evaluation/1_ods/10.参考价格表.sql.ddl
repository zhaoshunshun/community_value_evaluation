CREATE TABLE ods_evaluation.ods_community_evaluation_community_month_reference_price(
  `cre_ts` string COMMENT '数据仓库创建数据时间',
  `id` bigint COMMENT '主键自增',
  `is_del` string COMMENT '删除标识',
  `create_time` string COMMENT '创建时间',
  `update_time` string COMMENT '更新时间',
  `version` bigint COMMENT '版本',
  `remark` string COMMENT '备注',
  `community_id` string COMMENT '小区id'
)
COMMENT '小区月报-参考价小区（不出报告）'
    STORED AS TEXTFILE;