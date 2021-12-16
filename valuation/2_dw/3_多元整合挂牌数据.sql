truncate table dw_evaluation.house_valuation_rack_detail;
drop table dw_evaluation.house_valuation_rack_detail

create table dw_evaluation.house_valuation_rack_detail
as
    insert overwrite table dw_evaluation.house_valuation_rack_detail
    select
        t1.city_cd,
        t1.city_name,
        t1.district_cd,
        t1.district_name,
        t1.block_cd,
        t1.block_name,
        t1.community_id,
        t1.community_name,
        t1.community_addr,
        t1.rack_info_src,
        t1.rack_house_id,
        t1.house_verification_code,
        t1.house_listed_time,
        t1.source_community_id,
        t1.source_community_name,
        t1.source_community_addr,
        t1.house_avg_price,
        t1.house_price,
        t1.house_room,
        t1.house_hall,
        t1.house_toilet,
        t1.house_layout,
        t1.house_property_area,
        t1.house_orient,
        t1.house_floor_level,
        t1.house_floor_str,
        t1.room_rack_type,
        t1.house_fitment_name,
        t1.elevator,
        t1.ladder_ratio,
        t1.dt,
        t1.month_dt,
        t2.bk_interval,
        t2.min_interval,
        t2.max_interval
from asset_esf.multi_room_rack_price_month_all t1
left join ods_evaluation.house_valuation_bk_interval t2
on t1.city_name = t2.city_name
where t1.house_property_area > t2.min_interval
  and t1.house_property_area < t2.max_interval
  and t1.block_cd <>''
and t1.city_name in ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波','佛山','深圳','福州','南宁','长沙','南昌','银川','中山','兰州','长春','贵阳','徐州','石家庄','惠州')


truncate table dw_evaluation.house_valuation_rack_community_area_interval;
drop table dw_evaluation.house_valuation_rack_community_area_interval;
create table dw_evaluation.house_valuation_rack_community_area_interval
as
insert overwrite table dw_evaluation.house_valuation_rack_community_area_interval
    select
        t1.city_cd,
        t1.district_cd,
        t1.block_cd,
        t1.community_id,
        t1.bk_interval as area_interval,
        sum(case when t1.house_avg_price is not null then t1.house_avg_price else 0 end )/sum(case when t1.house_avg_price is not null then 1 else 0 end) as community_avg_price,
        count(1) as community_goods_cnt
from dw_evaluation.house_valuation_rack_detail t1
    where t1.month_dt >=substring(add_months(current_timestamp(),-6),1,7)
group by
    t1.city_cd,
    t1.district_cd,
    t1.block_cd,
    t1.community_id,
    t1.bk_interval
