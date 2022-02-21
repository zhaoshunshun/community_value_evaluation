
# truncate table wrk_evaluation.community_evaluation_list_rate;
# drop table wrk_evaluation.community_evaluation_list_rate;
# create table wrk_evaluation.community_evaluation_list_rate as
insert overwrite table wrk_evaluation.community_evaluation_list_rate
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
    udf.decryptudf(t1.gaode_fence)  as community_fence,
    t1.volume_rate,
    case when t1.build_min_year= t1.build_max_year then t1.build_min_year
         else concat(t1.build_min_year,'-',t1.build_max_year) end as building_year,
    udf.decryptudf(t1.developer_corp) as developer_corp,
    udf.decryptudf(t1.property_name) as property_name,
    udf.decryptudf(t1.property_fee) as property_fee,
    concat(cast(cast(t1.green_rate*100 as decimal(11,2)) as STRING),'%') as green_rate,
    t2.room_cnt,
    case when t3.list_cnt is null then '0%' else concat(cast(cast(t3.list_cnt/t2.room_cnt * 100 as decimal(11,1)) as STRING),'%') end as list_rate,
    case when t4.list_cnt is null and t5.deal_cnt is null then '0:0'
         when t4.list_cnt is null and t5.deal_cnt is not null then concat('0:',cast(t5.deal_cnt as STRING))
         when t4.list_cnt is not null and t5.deal_cnt is not null then concat('1:',cast(cast(t5.deal_cnt/t4.list_cnt as decimal(11,1)) as STRING))
         when t4.list_cnt is not null and t5.deal_cnt is null then concat(cast(t4.list_cnt as STRING),':0') end as demand_rate,
    t6.building_cnt,
    t6.floor_num_cnt
    --20201208,房源评测需求增加如下指标
    ,t1.parking_num   --车位数
    ,t1.parking_rate  --车位配比
    ,t1.building_type --建筑类型
    ,t1.act_area      --占地面积
    ,substr(current_date(),1,4) -(case when t1.build_max_year is not null and t1.build_min_year is not null then CEILING((t1.build_max_year + t1.build_min_year)/2)
                                       when nvl(t1.build_max_year,t1.build_min_year) is not null then nvl(t1.build_max_year,t1.build_min_year)
                                       else cast(null as int) end) house_years    --房龄(最大建筑年代与最小建筑年代的平均值向上取整)
 ,case when cast(split(regexp_replace(t1.parking_rate,'：',':'),':')[1] as decimal(10,2))/cast(split(regexp_replace(t1.parking_rate,'：',':'),':')[0] as decimal(10,2)) >= 1
                                                                                                 then 1 else 0 end high_parking_rate_flag --高车位比标志
 ,case when s.community_no is not null then 1 else 0 end school_house_flag --学区房标志
from ods_house.ods_house_asset_community  t1
         left join
     (
         select community_id,count(1) as room_cnt from ods_house.ods_house_asset_room where del_ind <> 1 group by community_id
     ) t2
     on t1.community_id=t2.community_id
         left join (
    select t1.community_id,count(distinct t1.goods_code) as list_cnt
    from dw_evaluation.community_evaluation_list_month_detail t1
    where substring(t1.batch_time,1,7) = substring(cast(add_months(current_timestamp(),-1) as STRING),1,7)
    group by t1.community_id
) t3
        on t1.community_id = t3.community_id
        inner join (
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
) t5
    on t1.community_id = t5.community_id
         left join (
    select community_id,count(1) as building_cnt,sum(floor_num) as floor_num_cnt from ods_house.ods_house_asset_building
    where del_ind <> 1 group by community_id
) t6
    on t1.community_id = t6.community_id
        --20201208,房源评测需求需要增加学区房标签
                                      left join
     (
         select
             distinct b.community_no
         from ods_evaluation.community_evaluation_school a
                  left join ods_house.ods_house_hub_community_map b
                            on a.title_id = b.source_community_id
                                and b.check_status = 1
         where a.school_tag like '%重点%'
           and a.school_tag like '%小学%'
           and b.source_community_id is not null
     ) s
     on t1.community_no = s.community_no
where t1.city_name in ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都','贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春','长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
  and t1.del_ind <> 1
  and t1.upper_lower_ind = 1;


--房源评测 小区是否临近绿地公园表
# truncate table wrk_evaluation.room_evaluation_near_green_park;
# drop table wrk_evaluation.room_evaluation_near_green_park;
# create table wrk_evaluation.room_evaluation_near_green_park as
insert overwrite table wrk_evaluation.room_evaluation_near_green_park
select
    distinct a.city_id,a.district_id,a.community_id
from
    (
        select t1.city_id,t1.district_id,t1.community_id
             ,6371* 1000 * 2
            * asin(sqrt(power(sin((radians(cast(split(t2.gd_location,',')[1] as double))
                - radians(cast(split(t1.community_coordinate,',')[1] as double)))/2),2)
                + cos(radians(cast(split(t2.gd_location,',')[1] as double)))
                            * cos(radians(cast(split(t1.community_coordinate,',')[1] as double)))
                            * power(sin((radians(cast(split(t2.gd_location,',')[0] as double))
                        - radians(cast(split(t1.community_coordinate,',')[0] as double)))/2),2)
                )
                  ) green_park_dist --小区与公园绿地之间的距离

        from wrk_evaluation.community_evaluation_list_rate t1
                 left join ods_house.ods_pyspider_db_poi_map  t2
                           on t2.type_code ='110101'
                               and regexp_replace(t2.city_name,'市','') = t1.city_name
    ) a
where green_park_dist <= 1000
;


--房源评测 投资潜力极值标注
# truncate table wrk_evaluation.room_evaluation_investment_potential_sub;
# drop table wrk_evaluation.room_evaluation_investment_potential_sub;
# create table wrk_evaluation.room_evaluation_investment_potential_sub as
insert overwrite table wrk_evaluation.room_evaluation_investment_potential_sub
select
    t1.city_id,t1.community_id
     ,nvl(cast(r3.comm_rent_price_avg as decimal(10,2)) * 12 / cast(p1.price_avg as decimal(10,2)),0.00) --近半年单位面积平均租金*12/最近一个月的小区均价
          + nvl(cast(p1.price_avg as decimal(10,2))/cast(p2.price_avg as decimal(10,2)) - 1,0.00) --小区均价同比涨幅
                                        as investment_potential_value
     ,percentile_approx(
                    nvl(cast(r3.comm_rent_price_avg as decimal(10,2)) * 12 / cast(p1.price_avg as decimal(10,2)),0.00) --近半年单位面积平均租金*12/最近一个月的小区均价
                + nvl(cast(p1.price_avg as decimal(10,2))/cast(p2.price_avg as decimal(10,2)) - 1,0.00) --小区均价同比涨幅

    ,0.4) over(partition by t1.city_id) as investment_potential_sub_40
     ,percentile_approx(
                    nvl(cast(r3.comm_rent_price_avg as decimal(10,2)) * 12 / cast(p1.price_avg as decimal(10,2)),0.00) --近半年单位面积平均租金*12/最近一个月的小区均价
                + nvl(cast(p1.price_avg as decimal(10,2))/cast(p2.price_avg as decimal(10,2)) - 1,0.00) --小区均价同比涨幅
    ,0.6) over(partition by t1.city_id) as investment_potential_sub_60
from wrk_evaluation.community_evaluation_list_rate t1
    --关联小区均价表
left join dw_house.dw_community_price_cal_new_adjust p1
on t1.community_id = p1.community_id
    and t1.city_id = p1.city_cd
    and p1.price_dt = concat(substr(cast(add_months(current_timestamp(),-1) as string),1,7),'-01')
left join dw_house.dw_community_price_cal_new_adjust p2
    on t1.city_id = p2.city_cd
    and t1.community_id = p2.community_id
    and p2.price_dt = concat(substr(cast(add_months(current_timestamp(),-13) as string),1,7),'-01')
    --关联近半年投资回报率
left join
    (  select
    s_city_cd
    ,s_community_id
    --,s_goods_id
    ,sum(d_rent_price) / sum(d_rent_area) comm_rent_price_avg
    from eju_dwd.dwd_event_rent_detail
    where s_rent_date >= substr(cast(add_months(current_timestamp(),-7) as string),1,10)
    and s_off_date is not null
    and s_rent_date is not null
    group by s_city_cd,s_community_id
    ) r3
    on r3.s_city_cd = t1.city_id
    and r3.s_community_id = t1.community_id
;

# truncate table wrk_evaluation.community_evaluation_label;
# insert overwrite table wrk_evaluation.community_evaluation_label;
# create table wrk_evaluation.community_evaluation_label as
insert overwrite table wrk_evaluation.community_evaluation_label
select
    t1.community_id,
    case when s.investment_potential_value > investment_potential_sub_60 then '高'
         when s.investment_potential_value <= investment_potential_sub_60
             and s.investment_potential_value >= investment_potential_sub_40 then '中'
         when s.investment_potential_value < investment_potential_sub_40 then '低'
        end as investment_potential,--投资潜力
    case when g.community_id is null and t1.high_parking_rate_flag = 0 and t1.school_house_flag = 0 then cast(null as string)
         else CONCAT(
                    case when g.community_id is not null then '临近绿地公园' else '' END,
                    case when t1.high_parking_rate_flag = 1 then ',停车位比高' else '' END,
                    case when cast(p1.community_avg_price as decimal(10,2))/p2.community_avg_price_ly > p3.city_avg_price/p4.city_avg_price_ly
                         then ',房价涨幅高' else '' END,
                    case when r1.rent_days < r2.rent_days then ',房源好租' else '' END,
                    case when t1.house_years <= 5 then ',房龄新' else '' END,
                    case when t1.school_house_flag = 1 then ',学区房' else '' END
                    ) end comm_tag

--关联临近绿地公园小区表
from wrk_evaluation.community_evaluation_list_rate t1
    left join wrk_evaluation.room_evaluation_near_green_park g
    on t1.community_id = g.community_id
    --关联小区均价表
    left join dm_evaluation.community_evaluation_comm_avg_price p1
    on p1.price_mth = substr(cast(add_months(current_timestamp(),-1) as string),1,7)
    and t1.community_id = p1.community_id
    and t1.city_id = p1.city_id
    left join
    (
    select
    city_id,community_id,cast(community_avg_price as decimal(10,2)) community_avg_price_ly
    from dm_evaluation.community_evaluation_comm_avg_price
    where price_mth = substr(cast(add_months(current_timestamp(),-13) as string),1,7)
    ) p2
    on t1.city_id = p2.city_id
    and t1.community_id = p2.community_id
    left join
    (
    select
    city_id,sum(cast(community_avg_price as decimal(10,2)))/count(1) city_avg_price
    from dm_evaluation.community_evaluation_comm_avg_price
    where price_mth = substr(cast(add_months(current_timestamp(),-1) as string),1,7)
    group by city_id
    ) p3
    on t1.city_id = p3.city_id
    left join
    (
    select
    city_id,sum(cast(community_avg_price as decimal(10,2)))/count(1) city_avg_price_ly
    from dm_evaluation.community_evaluation_comm_avg_price
    where price_mth = substr(cast(add_months(current_timestamp(),-13) as string),1,7)
    group by city_id
    ) p4
    on t1.city_id = p4.city_id
    --关联租房周期数据
    left join
    (  select
    s_city_cd
    ,s_community_id
    --,s_goods_id
    ,sum(datediff(s_off_date,s_rent_date))/count(1) rent_days
    ,sum(d_rent_price) / sum(d_rent_area) comm_rent_price_avg
    from eju_dwd.dwd_event_rent_detail
    where s_rent_date >= substr(cast(add_months(current_timestamp(),-4) as string),1,10)
    and s_off_date is not null
    and s_rent_date is not null
    group by s_city_cd,s_community_id
    ) r1
    on r1.s_city_cd = t1.city_id
    and r1.s_community_id = t1.community_id
    left join
    (  select
    s_city_cd
    ,sum(datediff(s_off_date,s_rent_date))/count(1) rent_days
    from eju_dwd.dwd_event_rent_detail
    where s_rent_date >= substr(cast(add_months(current_timestamp(),-4) as string),1,10)
    and s_off_date is not null
    and s_rent_date is not null
    group by s_city_cd
    ) r2
    on r2.s_city_cd = t1.city_id
    --关联投资回报临时表
    left join wrk_evaluation.room_evaluation_investment_potential_sub s
    on t1.city_id = s.city_id
    and t1.community_id = s.community_id;



--20201208,增加字段前备份表
create table dm_evaluation.community_evaluation_detail_20201211
as select * from dm_evaluation.community_evaluation_detail;--61347 row(s)

insert overwrite table dm_evaluation.community_evaluation_detail
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
    --20201208,新增小区标签字段
    t1.parking_num,
    t1.parking_rate,
    t1.building_type,
    t1.act_area,
    t1.house_years,
    t11.investment_potential,
    t11.comm_tag,
    current_timestamp as timestamp_v
from wrk_evaluation.community_evaluation_list_rate t1
    inner join (select community_no,price_avg,
    row_number() over (partition by community_no order by cal_dt desc) as ranks
    from dw_house.dw_community_price_cal_new_adjust
    ) t2
on t1.community_no=t2.community_no and t2.ranks=1
    left join
    (select community_id,community_facilities,size(split(community_facilities,',')) as facilities_cnt
    from dw_evaluation.community_evaluation_strategy
    ) t5
    on t1.community_id = t5.community_id
    inner join dw_evaluation.community_evaluation_layout t6
    on t1.community_id = t6.community_id
        and t1.city_cd = t6.city_cd
    inner join  dw_evaluation.community_evaluation_deal t7
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
            where del_ind <> 1 ) t3
            group by t3.community_id
    ) t9
        on t1.community_id=t9.community_id
    left join dw_evaluation.community_evaluation_building_density_by_city t10
        on t1.city_id = t10.city_cd
    left join wrk_evaluation.community_evaluation_label t11
        on t1.community_id=t11.community_id
where  t1.community_name <> ''
  and t1.community_addr <>''
  and t1.block_name <> ''
  and t1.district_name <> ''
  and t1.list_rate <> ''
  and t1.community_coordinate <>''
  and t1.list_rate <> '0%'
  and t1.demand_rate<>'0:0'
  and (t9.leveling_cnt<>0
   or t9.mult_level_cnt<>0
   or t9.small_high_level_cnt<>0
   or t9.high_level_cnt<>0)
;


