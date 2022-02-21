drop table if exists community_evaluation.community_evaluation_md5_map;
create table community_evaluation.community_evaluation_md5_map
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `community_id`  varchar(50) DEFAULT NULL COMMENT '小区id',
    `community_md5` varchar(50) DEFAULT NULL COMMENT '小区idmd5加密',
    `rd`            varchar(50) DEFAULT NULL COMMENT 'rd',
    `channel`       varchar(50) DEFAULT NULL COMMENT '渠道',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4 COMMENT '小区id加密map';