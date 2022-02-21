CREATE TABLE ods_evaluation.ods_community_evaluation_community_mon_report_facilitate(
  `cre_ts` string COMMENT '数据仓库创建数据时间',
  `id` bigint COMMENT '主键自增',
  `is_del` string COMMENT '删除标识',
  `create_time` string COMMENT '创建时间',
  `update_time` string COMMENT '更新时间',
  `version` bigint COMMENT '版本',
  `remark` string COMMENT '备注',
  `community_id` string COMMENT '小区id',
  `community_coordinate` string COMMENT '小区坐标',
  `radius` string COMMENT '半径',
  `types` string COMMENT '类型',
  `count` string COMMENT '数量',
  `address` string COMMENT '地址',
  `distance` string COMMENT '距离',
  `name` string COMMENT '名称',
  `batch_no` string COMMENT '批次号'
)
COMMENT '小区月报-便利指数爬虫数据'
    STORED AS TEXTFILE;


create table if not exists ods_evaluation.ods_community_evaluation_community_mon_district_crawl_data(
     `cre_ts` string comment '数据仓库创建数据时间'
    ,`id` bigint comment '主键自增'
    ,`is_del` string comment '删除标识'
    ,`create_time` string comment '创建时间'
    ,`update_time` string comment '更新时间'
    ,`version` bigint comment '版本'
    ,`remark` string comment '备注'
    ,`count` string comment '数量'
    ,`district_cd` string comment '小区区域id'
    ,`types` string comment '类型'
    ,`gao_de_district_name` string comment '高德区域名称'
    ,`district_name` string comment '区域名称'
)
    COMMENT '区域高德数据数量'
STORED AS TEXTFILE


create table ods_evaluation.ods_community_evaluation_community_mon_report_facilitate_bak
    as select * from ods_evaluation.ods_community_evaluation_community_mon_report_facilitate

create table ods_evaluation.ods_community_evaluation_community_mon_district_crawl_data_bak
    as select * from ods_evaluation.ods_community_evaluation_community_mon_district_crawl_data

type-map:
  typeMaps:
    - types: 150500 #1km地铁
      radius: 1000
    - types: 090101 #1km三甲医院
      radius: 1000
    - types: 060100 #1km购物中心
      radius: 1000
    - types: 110101 #1km公园
      radius: 1000
    - types: 150500 #2km地铁
      radius: 2000
    - types: 150700 #2000m公交
      radius: 2000
    - types: 141204 #3km幼儿园
      radius: 3000
    - types: 141203 #3km小学
      radius: 3000
    - types: 141202 #3km中学
      radius: 3000
    - types: 综合医院|专科医院 #3km医院
      radius: 3000
    - types: 090101 #3km三甲医院
      radius: 3000
    - types: 060400 #3km超市
      radius: 3000
    - types: 060100 #3km购物中心
      radius: 3000
    - types: 110101 #3km公园
      radius: 3000
    - types: 电影院 #3km电影院
      radius: 3000
    - types: 咖啡厅 #3km咖啡馆
      radius: 3000
    - types: 150500 #2km地铁(相似小区)
      radius: 2000