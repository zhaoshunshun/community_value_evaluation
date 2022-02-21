drop table if exists community_evaluation.community_evaluation_city_analysis_report;
create table community_evaluation.community_evaluation_city_analysis_report
(
    `id`             bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `month`          varchar(50) DEFAULT NULL COMMENT '月份',
    `city_id`        varchar(50) DEFAULT NULL COMMENT '城市id',
    `city_name`      varchar(50) DEFAULT NULL COMMENT '城市名称',
    `list_cnt`       varchar(11) DEFAULT NULL COMMENT '挂牌套数',
    `deal_cnt`       varchar(11) DEFAULT NULL COMMENT '成交套数',
    `list_avg_price` varchar(11) DEFAULT NULL COMMENT '挂牌均价',
    `deal_avg_price` varchar(11) DEFAULT NULL COMMENT '成交均价',
    `list_up_rate`   varchar(11) DEFAULT NULL COMMENT '挂牌涨价房源占比',
    `list_down_rate` varchar(11) DEFAULT NULL COMMENT '挂牌降价房源占比',
    `timestamp_v`    datetime DEFAULT NULL COMMENT '数据处理时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT '城市房源分析报表';
