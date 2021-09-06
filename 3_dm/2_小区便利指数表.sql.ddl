create table dm_evaluation.community_month_report_convenient_info
(
    community_id STRING COMMENT '小区id',
    district_cd STRING  COMMENT '小区区域id',
    block_cd STRING  COMMENT '小区板块id',
    convenient_score STRING COMMENT '小区便利分数',
    convenient_hight STRING   COMMENT '小区便利分数高于区域均值的项',
    convenient_low STRING   COMMENT '小区便利分数低于区域均值的项',
    traffic_score STRING COMMENT '交通分数',
    district_traffic_score STRING COMMENT '区域交通分数',
    traffic_bus_cnt STRING COMMENT '小区公交站数量1KM',
    traffic_subway_cnt STRING COMMENT '小区地铁站数量1KM',
    district_traffic_bus_cnt STRING COMMENT '区域公交站数量1KM',
    district_traffic_subway_cnt STRING COMMENT '区域地铁站数量1KM',
    traffic_bus_list STRING COMMENT '小区周边1KM的公交车站的数量1KM',
    traffic_subway_list STRING COMMENT '小区周边1KM的地铁站数量1KM',
    subway_nearby_distince STRING COMMENT '最近地铁距离',
    education_score STRING COMMENT '教育分数',
    district_education_score STRING COMMENT '区域教育分数',
    education_nursery_cnt STRING COMMENT '小区幼儿园数量1KM',
    education_primary_cnt STRING COMMENT '小区小学数量1KM',
    education_middle_cnt STRING COMMENT '小区中学数量1KM',
    district_education_nursery_cnt STRING COMMENT '区域幼儿园数据量1KM',
    district_education_primary_cnt STRING COMMENT '区域小学数量1KM',
    district_education_middle_cnt STRING COMMENT '区域中学数量1KM',
    education_nursery_list STRING COMMENT '小区幼儿园list1KM',
    education_primary_list STRING COMMENT '小区小学list1KM',
    education_middle_list STRING COMMENT '小区中学list1KM',
    hospital_score STRING COMMENT '医疗分数',
    district_hospital_score STRING COMMENT '区域医疗分数',
    hospital_cnt STRING COMMENT '小区医院数量1KM',
    three_hospital_cnt STRING COMMENT '小区三甲医院数量1KM',
    district_hospital_cnt STRING COMMENT '区域医院数量1KM',
    district_three_hospital_cnt STRING COMMENT '区域三甲医院数量1KM',
    hospital_list STRING COMMENT '小区医院list1KM',
    three_hospital_list STRING COMMENT '小区三甲医院list1KM',
    shopping_score STRING COMMENT '购物分数',
    district_shopping_score STRING COMMENT '区域购物分数',
    shopping_supermarket_cnt STRING COMMENT '小区周围超市数量1KM',
    shopping_mall_cnt STRING COMMENT '小区周围购物中心数量1KM',
    district_shopping_supermarket_cnt STRING COMMENT '区域周围超市数量1KM',
    district_shopping_mall_cnt STRING COMMENT '区域周围购物中心数量1KM',
    shopping_supermarket_list STRING COMMENT '小区周围超市list1KM',
    shopping_mall_list STRING COMMENT '小区周围购物中心list1KM',
    arder_score STRING COMMENT '休闲分数',
    district_arder_score STRING COMMENT '区域休闲分数',
    coffee_house_cnt STRING COMMENT '小区咖啡馆数量1KM',
    greenland_cnt STRING COMMENT '小区绿地公园数量1KM',
    movie_cnt STRING COMMENT '小区电影院数量1KM',
    district_coffee_house_cnt STRING COMMENT '区域咖啡馆数量1KM',
    district_greenland_cnt STRING COMMENT '区域绿地公园数量1KM',
    district_movie_cnt STRING COMMENT '区域电影院数量1KM',
    coffee_house_list STRING COMMENT '小区咖啡馆数量1KM',
    greenland_list STRING COMMENT '小区绿地公园数量1KM',
    movie_list STRING COMMENT '小区电影院数量1KM',
    batch_no STRING COMMENT '批次号',
    timestamp_v timestamp COMMENT '数据处理时间'
) COMMENT '小区便利指数表'  STORED AS TEXTFILE;