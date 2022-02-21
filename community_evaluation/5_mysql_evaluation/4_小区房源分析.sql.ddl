drop table if exists community_evaluation.community_evaluation_analysis;
create table community_evaluation.community_evaluation_analysis
(
    `id`                        bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `month`                     varchar(50) DEFAULT NULL COMMENT '月份',
    `city_id`                   varchar(50) DEFAULT NULL COMMENT '城市id',
    `city_name`                 varchar(50) DEFAULT NULL COMMENT '城市名称',
    `community_id`              varchar(50) DEFAULT NULL COMMENT '小区id',
    `community_name`            varchar(50) DEFAULT NULL COMMENT '小区名称',
    `list_cnt`                  varchar(50) DEFAULT NULL COMMENT '挂牌套数',
    `list_year_rate`            varchar(50) DEFAULT NULL COMMENT '挂牌套数同比',
    `list_month_rate`           varchar(50) DEFAULT NULL COMMENT '挂牌套数环比',
    `deal_cnt`                  varchar(50) DEFAULT NULL COMMENT '成交套数',
    `deal_year_rate`            varchar(50) DEFAULT NULL COMMENT '成交套数同比',
    `deal_month_rate`           varchar(50) DEFAULT NULL COMMENT '成交套数环比',
    `demand_type`               varchar(50) DEFAULT NULL COMMENT '供求走势类型',
    `list_avg_price`            varchar(50) DEFAULT NULL COMMENT '挂牌均价',
    `list_avg_price_year_rate`  varchar(50) DEFAULT NULL COMMENT '挂牌均价同比',
    `list_avg_price_month_rate` varchar(50) DEFAULT NULL COMMENT '挂牌均价环比',
    `deal_avg_price`            varchar(50) DEFAULT NULL COMMENT '成交均价',
    `deal_avg_price_year_rate`  varchar(50) DEFAULT NULL COMMENT '成交均价同比',
    `deal_avg_price_month_rate` varchar(50) DEFAULT NULL COMMENT '成交均价环比',
    `deal_list_change_type`     varchar(50) DEFAULT NULL COMMENT '成交挂牌走势类型',
    `list_up_goods_id`          varchar(50) DEFAULT NULL COMMENT '本小区涨价房源id',
    `list_up_current_price`     varchar(20) DEFAULT NULL COMMENT '本小区涨价房源挂牌价格',
    `list_up_increment_price`   varchar(20) DEFAULT NULL COMMENT '本小区涨价房源涨价金额',
    `list_up_rate`              varchar(50) DEFAULT NULL COMMENT '本小区涨价房源涨价比例',
    `list_up_layout`            varchar(50) DEFAULT NULL COMMENT '本小区涨价房源户型',
    `list_up_area`              varchar(20) DEFAULT NULL COMMENT '本小区涨价房源面积',
    `list_up_url`               varchar(100) DEFAULT NULL COMMENT '本小区涨价房源户型图url',
    `list_down_goods_id`        varchar(50) DEFAULT NULL COMMENT '本小区降价房源id',
    `list_down_current_price`   varchar(20) DEFAULT NULL COMMENT '本小区降价房源挂牌价格',
    `list_down_increment_price` varchar(20) DEFAULT NULL COMMENT '本小区降价房源涨价金额',
    `list_down_rate`            varchar(50) DEFAULT NULL COMMENT '本小区降价房源涨价比例',
    `list_down_layout`          varchar(50) DEFAULT NULL COMMENT '本小区降价房源户型',
    `list_down_area`            varchar(20) DEFAULT NULL COMMENT '本小区降价房源面积',
    `list_down_url`             varchar(100) DEFAULT NULL COMMENT '本小区降价房源户型图url',
    `timestamp_v`               datetime DEFAULT NULL COMMENT '数据处理时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT '小区房源分析';
