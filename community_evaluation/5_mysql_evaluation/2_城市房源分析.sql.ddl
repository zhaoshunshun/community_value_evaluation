drop table if exists community_evaluation.community_evaluation_city_analysis;
create table community_evaluation.community_evaluation_city_analysis
(
    `id`                        bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `month`                     varchar(50) DEFAULT NULL COMMENT '月份',
    `city_id`                   varchar(50) DEFAULT NULL COMMENT '城市id',
    `city_name`                 varchar(50) DEFAULT NULL COMMENT '城市名称',
    `list_cnt`                  varchar(11) DEFAULT NULL COMMENT '挂牌套数',
    `list_year_rate`            varchar(50) DEFAULT NULL COMMENT '挂牌套数同比',
    `list_month_rate`           varchar(50) DEFAULT NULL COMMENT '挂牌套数环比',
    `deal_cnt`                  varchar(11) DEFAULT NULL COMMENT '成交套数',
    `deal_year_rate`            varchar(50) DEFAULT NULL COMMENT '成交套数同比',
    `deal_month_rate`           varchar(50) DEFAULT NULL COMMENT '成交套数环比',
    `demand_type`               varchar(50) DEFAULT NULL COMMENT '供求走势类型',
    `list_avg_price`            varchar(50) DEFAULT NULL COMMENT '挂牌均价',
    `list_avg_price_year_rate`  varchar(50) DEFAULT NULL COMMENT '挂牌均价同比',
    `list_avg_price_month_rate` varchar(50) DEFAULT NULL COMMENT '挂牌均价环比',
    `list_change_type`          varchar(50) DEFAULT NULL COMMENT '挂牌均价涨幅类型',
    `deal_avg_price`            varchar(50) DEFAULT NULL COMMENT '成交均价',
    `deal_avg_price_year_rate`  varchar(50) DEFAULT NULL COMMENT '成交均价同比',
    `deal_avg_price_month_rate` varchar(50) DEFAULT NULL COMMENT '成交均价环比',
    `deal_change_type`          varchar(50) DEFAULT NULL COMMENT '成交均价涨幅类型',
    `list_up_rate`              varchar(50) DEFAULT NULL COMMENT '挂牌涨价房源占比',
    `list_up_rate_year_rate`    varchar(50) DEFAULT NULL COMMENT '挂牌涨价房源同比',
    `list_up_rate_month_rate`   varchar(50) DEFAULT NULL COMMENT '挂牌涨价房源环比',
    `list_down_rate`            varchar(50) DEFAULT NULL COMMENT '挂牌降价房源占比',
    `list_down_rate_year_rate`  varchar(50) DEFAULT NULL COMMENT '挂牌降价房源同比',
    `list_down_rate_month_rate` varchar(50) DEFAULT NULL COMMENT '挂牌降价房源环比',
    `list_change_trend_type`    varchar(50) DEFAULT NULL COMMENT '挂牌调价走势类型',
    `timestamp_v`               datetime DEFAULT NULL COMMENT '数据处理时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT '城市房源分析';
