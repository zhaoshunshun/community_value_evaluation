
insert overwrite table wrk_evaluation.community_evaluation_list_rate_all
select
    cast(t1.community_id as STRING)  as community_id,
    t1.community_no,
    t1.community_name as community_name,
    t1.city_cd as city_id,
    t1.city_name as city_name,
    t1.community_addr as community_addr,
    t1.district_cd as district_id,
    t1.district_name as district_name,
    t1.block_cd as block_id,
    t1.block_name as block_name,
    concat_ws(',',udf.decryptudf(t1.gaode_lng),udf.decryptudf(t1.gaode_lat)) as community_coordinate,
    t1.community_fence,
    t1.volume_rate,
    case when t1.build_min_year= t1.build_max_year then t1.build_min_year
         else concat(t1.build_min_year,'-',t1.build_max_year) end as building_year,
    udf.decryptudf(t1.developer_corp) as developer_corp,
    udf.decryptudf(t1.property_name) as property_name,
    udf.decryptudf(t1.property_fee) as property_fee,
    concat(cast(cast(t1.green_rate*100 as int) as STRING),'%') as green_rate,
    t2.room_cnt,
    case when t3.list_cnt is null then '0%' else concat(cast(cast(t3.list_cnt/t2.room_cnt * 100 as decimal(11,1)) as STRING),'%') end as list_rate,
    case when t4.list_cnt is null and t5.deal_cnt is null then '0:0'
         when t4.list_cnt is null and t5.deal_cnt is not null then concat('0:',cast(t5.deal_cnt as STRING))
         when t4.list_cnt is not null and t5.deal_cnt is not null then concat('1:',cast(cast(t5.deal_cnt/t4.list_cnt as decimal(11,1)) as STRING))
         when t4.list_cnt is not null and t5.deal_cnt is null then concat(cast(t4.list_cnt as STRING),':0') end as demand_rate,
    t6.building_cnt,
    t6.floor_num_cnt
from ods_house.ods_house_asset_community  t1
         left join
     (
         select community_id,count(1) as room_cnt from ods_house.ods_house_asset_room where del_ind <> 1 group by community_id
     ) t2
     on t1.community_id=t2.community_id
         left join (
    select t1.community_id,count(1) as list_cnt from dw_evaluation.community_evaluation_list_month_detail t1
    where substring(t1.batch_time,1,7) = substring(cast(add_months(current_timestamp(),-1) as STRING),1,7)
    group by t1.community_id
) t3
                   on t1.community_id = t3.community_id
         left join (
    select t1.community_id,count(distinct t1.goods_code) as list_cnt
    from dw_evaluation.community_evaluation_list_month_detail t1
    where substring(t1.batch_time,1,7) >= substring(cast(add_months(current_timestamp(),-3) as STRING),1,7)
    group by t1.community_id
) t4
                    on t1.community_id = t4.community_id
         left join (
    select t1.community_id,count(distinct t1.goods_id) as deal_cnt
    from dw_evaluation.community_evaluation_deal_detail t1
    where substring(t1.deal_time,1,7) >= substring(cast(add_months(current_timestamp(),-3) as STRING),1,7)
    group by t1.community_id
) t5 on t1.community_id = t5.community_id
         left join (
    select community_id,count(1) as building_cnt,sum(floor_num) as floor_num_cnt from ods_house.ods_house_asset_building where del_ind <> 1 group by community_id
) t6
                   on t1.community_id = t6.community_id
where t1.city_name in ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都','贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春','长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
  and t1.del_ind <> 1
  and t1.upper_lower_ind = 1;



insert overwrite table dm_evaluation.community_evaluation_detail_all
select
    t1.community_id,
    t1.community_name,
    t1.city_id,
    t1.city_name,
    t1.community_addr,
    t1.district_id,
    t1.district_name,
    t1.block_id,
    t1.block_name,
    t1.community_coordinate,
    t1.community_fence,
    concat(cast(t2.price_avg as STRING),'元/m²') as community_avg_price,
    concat(cast(t1.building_cnt as STRING),'栋') as building_cnt,
    concat(cast(t1.room_cnt as STRING),'户') as room_cnt,
    t1.building_year,
    t1.developer_corp,
    t1.property_name,
    t1.property_fee,
    t1.volume_rate,
    t1.green_rate,
    t1.list_rate,
    t1.demand_rate,
    t5.community_facilities,
    cast(t5.facilities_cnt as STRING) as facilities_cnt,
    case when t5.facilities_cnt>5 then '齐全'
         else '一般' end as facilities_level,
    case when t5.facilities_cnt>=9 then '5'
         when t5.facilities_cnt>=7 and t5.facilities_cnt<=8 then '4'
         when t5.facilities_cnt>=5 and t5.facilities_cnt<=6 then '3'
         when t5.facilities_cnt>=3 and t5.facilities_cnt<=4 then '2'
         when t5.facilities_cnt>=1 and t5.facilities_cnt<=2 then '1'
         else '3' end as quality_stars,
    case when t5.facilities_cnt>5 then '好'
         else '一般' end as quality_grade,
    concat(cast(round(t6.layout_1_cnt/t6.community_house_cnt * 100) as STRING),'%') as layout_1_rate,
    concat(cast(round(t6.layout_2_cnt/t6.community_house_cnt * 100) as STRING),'%') as layout_2_rate,
    concat(cast(round(t6.layout_3_cnt/t6.community_house_cnt * 100) as STRING),'%') as layout_3_rate,
    concat(cast(round(t6.layout_4_cnt/t6.community_house_cnt * 100) as STRING),'%') as layout_4_rate,
    concat(cast(round(t6.layout_other_cnt/t6.community_house_cnt * 100) as STRING),'%') as layout_other_rate,
    concat(t6.build_area_min_1,'-',t6.build_area_max_1,'m²') as layout_1_area,
    concat(t6.build_area_min_2,'-',t6.build_area_max_2,'m²') as layout_2_area,
    concat(t6.build_area_min_3,'-',t6.build_area_max_3,'m²') as layout_3_area,
    concat(t6.build_area_min_4,'-',t6.build_area_max_4,'m²') as layout_4_area,
    concat(t6.build_area_min_other,'-',t6.build_area_max_other,'m²') as layout_other_area,
    concat(t6.main_layout,'为主') as layout_main,
    concat(t6.main_area_min,'-',t6.main_area_max,'m²')  as layout_main_area,
    coalesce(t6.second_layout,'其他') as layout_secondary,
    coalesce(t6.last_layout,'其他') as layout_least,
    t7.layout as layout_deal_1,
    case when t7.max_area= t7.min_area then concat(t7.max_area,'m²')
         else concat(t7.min_area,'-',t7.max_area,'m²') end as layout_deal_1_area,
    case when t7.max_deal_price = t7.min_deal_price then concat(t7.max_deal_price,'万')
         else concat(t7.min_deal_price,'-',t7.max_deal_price,'万') end as layout_deal_1_total_price,
    t7.cnt as layout_deal_1_cnt,
    cast(cast(t7.avg_area as decimal(11,2)) as STRING) as layout_deal_1_avg_area,
    cast(cast(t7.avg_deal_price as decimal(11,2)) as STRING) as layout_deal_1_avg_price,
    t7.jdj_url as layout_deal_1_url,
    t8.layout as layout_deal_2,
    case when t8.max_area= t8.min_area then concat(t8.max_area,'m²')
         else concat(t8.min_area,'-',t8.max_area,'m²') end as layout_deal_2_area,
    case when t8.max_deal_price = t8.min_deal_price then concat(t8.max_deal_price,'万')
         else concat(t8.min_deal_price,'-',t8.max_deal_price,'万') end as layout_deal_2_total_price,
    t8.cnt as layout_deal_2_cnt,
    cast(cast(t8.avg_area as decimal(11,2)) as STRING) as layout_deal_2_avg_area,
    cast(cast(t8.avg_deal_price as decimal(11,2)) as STRING) as layout_deal_2_avg_price,
    t8.jdj_url as layout_deal_2_url,
    cast(t9.leveling_cnt as STRING) as leveling_cnt,
    cast(t9.mult_level_cnt as STRING) as mult_level_cnt,
    cast(t9.small_high_level_cnt as STRING) as small_high_level_cnt,
    cast(t9.high_level_cnt as STRING) as high_level_cnt,
    case when t1.volume_rate >= t10.volume_rate_percentile_approx then concat('高于',t1.city_name,'平均水平')
         when t1.volume_rate < t10.volume_rate_percentile_approx then concat('低于',t1.city_name,'平均水平')  end as volume_rate_type,
    case when t1.volume_rate >= t10.volume_rate_percentile_approx then '居住舒适度一般'
         when t1.volume_rate < t10.volume_rate_percentile_approx then '居住舒适度较高' end as comfort_level,
    current_timestamp as timestamp_v
from wrk_evaluation.community_evaluation_list_rate_all t1
         left join (select community_no,price_avg,
                            row_number() over (partition by community_no order by cal_dt desc) as ranks
                     from dm_house.dm_community_price_cal
) t2
                    on t1.community_no=t2.community_no and t2.ranks=1
         left join
     (select community_id,community_facilities,size(split(community_facilities,',')) as facilities_cnt
      from dw_evaluation.community_evaluation_strategy
     ) t5
     on t1.community_id = t5.community_id
         left join dw_evaluation.community_evaluation_layout t6
                   on t1.community_id = t6.community_id
         left join  dw_evaluation.community_evaluation_deal t7
                     on t1.community_id = t7.community_id
                         and t7.ranks=1
         left join  dw_evaluation.community_evaluation_deal t8
                    on t1.community_id = t8.community_id
                        and t8.ranks=2
         left join (
    select t3.community_id,
           sum(case when t3.floor_type='平层' then 1 else 0 end) as leveling_cnt,
           sum(case when t3.floor_type='多层' then 1 else 0 end) as mult_level_cnt,
           sum(case when t3.floor_type='小高层' then 1 else 0 end) as small_high_level_cnt,
           sum(case when t3.floor_type='高层' then 1 else 0 end) as high_level_cnt
    from (
             select community_id,
                    building_id,
                    case when floor_num <=3 then '平层'
                         when floor_num >=4 and floor_num<=6 then '多层'
                         when floor_num >=7 and floor_num<=18 then '小高层'
                         when floor_num >18 then '高层'
                         else '' end as floor_type
             from ods_house.ods_house_asset_building
             where del_ind <> 1) t3
    group by t3.community_id
) t9
                   on t1.community_id=t9.community_id
         left join dw_evaluation.community_evaluation_building_density_by_city t10
                   on t1.city_id = t10.city_cd
;





