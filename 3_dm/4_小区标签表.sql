create table wrk_evaluation.community_month_building_elevator
as
insert overwrite table wrk_evaluation.community_month_building_elevator
select t2.community_id,
    sum(distinct t2.is_elevator) as is_elevator_type   --1: 无 2: 有 3:部分有
from (
    select t1.community_id,
        case
            when t1.elevator_num = '0'  then 1
            when t1.elevator_num is null then 3
            else 5 end as is_elevator
    from eju_ods.ods_house_asset_building t1
    where del_ind <> 1
) t2 group by t2.community_id

truncate table dm_evaluation.community_month_report_label;
drop table dm_evaluation.community_month_report_label;
insert overwrite table dm_evaluation.community_month_report_label
select
t1.community_id,
case when t2.subway_1km_cnt > 0 and t2.bus_1km_cnt >10 then '交通便捷' else '' end as label_traffic,
case when size(split(t3.facilities,','))>5 then '小区配套全' else '' end as label_facilities,
case when split(t1.parking_rate,':')[1]/split(t1.parking_rate,':')[0] >1 then '车位配比高' else '' end as label_parking,
case when t9.is_elevator_type in ('5','10') then '电梯房' else '' end as label_elevator,
case when t2.subway_1km_name is not null then t2.subway_1km_name else '' end as label_sub,
case when t2.subway_1km_cnt>0 and t2.three_hospital_1km_cnt >0 and t2.shopping_1km_cnt>0 then '周边配套全' else '' end as label_arround_facilities,
case when t2.greenland_1km_cnt >0 then '临近绿地公园' else '' end as label_park,
case when t4.school_name is not null or t4.school_name <> '' then t4.school_name else '' end as label_school,
case when (t5.last_month_price - t5.current_price) / t5.current_price > (t8.last_month_price - t8.current_price) / t8.current_price  then '房价涨幅高' else '' end as label_price,
case when t1.green_rate >= t6.city_green_rate then '绿化率高' else '' end as label_green,
case when t1.building_age <=5 then '房龄新' else '' end as label_age,
case when t7.community_rent_days < t7.city_rent_days  then '房源好租' else '' end as label_rent,
substring(current_timestamp(),1,7) as batch_no,    --批次号
current_timestamp() as timestamp_v          --数据处理时间
from dw_evaluation.community_month_report_base_info t1
left join dw_evaluation.community_month_report_convenient_info t2
on t1.community_id = t2.community_id
left join dw_evaluation.community_evaluation_bk_month_strategy t3
on t1.community_id = t3.community_id
left join dw_evaluation.community_evaluation_community_school_map t4
on t1.community_id = t4.community_id and t4.ranks = 1
left join dw_evaluation.community_avg_price_cal t5
on t1.community_id = t5.community_id
and  (t5.last_month_price - t5.current_price) / t5.current_price >=-0.2
and (t5.last_month_price - t5.current_price) / t5.current_price <=0.2
left join dw_evaluation.community_avg_price_district_cal t8
on t1.district_cd = t8.district_cd
left join
    (
        select city_cd,city_name,avg(green_rate) as city_green_rate from dw_evaluation.community_month_report_base_info group by city_cd,city_name
        ) t6
on t1.city_cd = t6.city_cd
left join dw_evaluation.community_month_rent_info t7
on t1.community_id =t7.community_id
left join wrk_evaluation.community_month_building_elevator t9
on t1.community_id = t9.community_id
