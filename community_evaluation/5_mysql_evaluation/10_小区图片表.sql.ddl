drop table if exists community_evaluation.community_evaluation_pic;
create table community_evaluation.community_evaluation_pic
(
    `cre_ts`                    varchar(20) DEFAULT NULL COMMENT '创建时间',
    `id`                        bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `community_id`              bigint(20) DEFAULT NULL COMMENT '小区id',
    `community_pic_type`        bigint(20) DEFAULT NULL COMMENT '图片类型',
    `community_pic_name`        varchar(500) DEFAULT NULL COMMENT '图片名称',
    `community_pic_name_dtl`    varchar(500) DEFAULT NULL COMMENT '图片详细名称',
    `community_pic_path`        varchar(500) DEFAULT NULL COMMENT '图片路径',
    `community_pic_path_vr`     varchar(500) DEFAULT NULL COMMENT '',
    `city_cd`                   varchar(20) DEFAULT NULL COMMENT '城市编码'
) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4 COMMENT '小区图片表';
