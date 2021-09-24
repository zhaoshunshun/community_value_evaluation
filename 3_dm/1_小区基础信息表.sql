
insert overwrite table dm_evaluation.community_month_report_base_info
select
    t1.community_id,          --小区id
    t1.community_name,          --小区名称
    t1.city_cd,          --城市编码
    t1.city_name,          --城市名称
    t1.district_cd,          --区域编码
    t1.district_name,          --区域名称
    t1.block_cd,          --板块编码
    t1.block_name,          --板块名称
    t1.addr,          --小区地址
    t1.coordinate,          --小区坐标
    t1.fence,          --小区围栏
    t2.current_price,          --小区均价
    cast((t2.current_price - t2.last_month_price) /t2.last_month_price as decimal(10,4)) as ratio_month,          --小区均价环比
    cast((t2.current_price -  t2.last_month_price) /t2.last_month_price as decimal(10,4)) as rack_month_six,          --小区均价环比
    cast((t3.current_price- t3.last_month_price)/ t3.last_month_price  as decimal(10,4)) as district_rack_month_six,   --区域均价环比
    t1.building_year,          --小区建筑年代
    t1.building_num,          --小区楼栋数量
    t1.building_area,          --小区占地面积
    t1.room_num,          --小区户数
    t1.property_type,          --小区物业类型
    t1.property_fee,          --小区物业费
    t1.developers,          --小区开发商
    t1.property_company,          --小区物业公司
    t1.volume_rate,          --小区容积率
    t1.green_rate,          --小区绿化率
    t1.parking_rate,          --小区车户比
    t1.person_div_car_ind,          --是否人车分流
    t1.building_age,          --小区楼龄
    t1.elevator_desc,          --是否有电梯描述
    case when t1.score>2 then  1 else 0 end as is_living_quility,
    case when t3.last_month_price is not null then 1 else 0 end as is_rack,
    case when t4.community_id  is not null then 1 else 0  end as is_deal,
    substring(current_timestamp(),1,7) as batch_no,    --批次号
    current_timestamp() as timestamp_v          --数据处理时间
from dw_evaluation.community_month_report_base_info t1
left join dw_evaluation.community_avg_price_cal t2
on t1.community_id = t2.community_id
    and  (t2.last_month_price - t2.current_price) / t2.current_price >=-0.2
    and (t2.last_month_price - t2.current_price) / t2.current_price <=0.2
left join dw_evaluation.community_avg_price_district_cal t3
on t1.city_cd = t3.city_cd
    and t1.district_cd = t3.district_cd
left join
    (select community_id from
    dw_evaluation.community_evaluation_month_deal
     group by community_id)t4
on t1.community_id = t4.community_id
