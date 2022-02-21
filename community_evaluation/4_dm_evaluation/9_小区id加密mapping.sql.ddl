truncate table dm_evaluation.community_evaluation_md5_map;
drop table if exists dm_evaluation.community_evaluation_md5_map;
create table dm_evaluation.community_evaluation_md5_map
(
    community_id                STRING COMMENT '小区id',
    community_md5               STRING COMMENT '小区idmd5加密',
    rd                          STRING COMMENT 'rd',
    channel                     STRING COMMENT '渠道'
) COMMENT '小区id加密map' STORED AS TEXTFILE;
