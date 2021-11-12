--克而瑞
truncate table wrk_evaluation.house_valuation_month_deal;
drop table wrk_evaluation.house_valuation_month_deal;
create table wrk_evaluation.house_valuation_month_deal as
insert overwrite table  wrk_evaluation.house_valuation_month_deal
select
    t3.community_id,
    t3.community_name,
    t3.community_addr,
    t3.city_cd,
    t3.city_name,
    t3.district_cd,
    t3.district_name,
    t3.block_cd,
    t3.block_name,
    cast(t2.trademoney/t2.tradearea as int) as avg_price ,
    t2.trademoney as deal_price,
    t2.tradearea as deal_area,
    t2.new_tradedate as deal_date,
    substring(t2.new_tradedate,1,7) as deal_month,
    'cric' as info_src,
    t2.create_time,
    current_timestamp() as timestamp_v
    from ods_evaluation.cric_deal_detail t2
         inner join ods_house.ods_house_asset_community t3
        on t2.citycaption = t3.city_name
        and case when t2.community_name = '控江' then t2.projectcaption else t2.community_name end = t3.community_name
            and t3.del_ind <> 1
            and t3.upper_lower_ind = 1
where t3.community_id is not null and t2.new_tradedate >= add_months(current_timestamp(),-6)
and t3.city_name in ('苏州','天津','广州','郑州','上海','北京','合肥','杭州','西安','重庆','南京','武汉')

--贝壳
insert into table wrk_evaluation.house_valuation_month_deal
select
    t3.community_id,
    t3.community_name,
    t3.community_addr,
    t3.city_cd,
    t3.city_name,
    t3.district_cd,
    t3.district_name,
    t3.block_cd,
    t3.block_name,
    t1.unit_price as avg_price,
    t1.total_price as deal_price,
    t1.area as deal_area,
    t1.deal_date as deal_date,
    substring(t1.deal_date,1,7) as deal_month,
    'bk' as info_src,
    '' as create_time,
    current_timestamp() as timestamp_v
from ods_evaluation.bk_deal_detail t1
         inner join case_esf.community_source_map t2
                    on t1.city = t2.city_name
                        and t1.community_name = t2.community_name
                        and t2.source_info_src = 'BK'
         left join ods_house.ods_house_asset_community t3
                   on t2.community_id= t3.community_id
where t3.city_name in ('沈阳','济南','厦门','昆明','宁波','佛山','无锡','成都','深圳','福州','南宁','长沙','南昌','银川','中山','兰州','长春','贵阳','徐州','石家庄','惠州')
  and t3.del_ind <> 1
  and t3.upper_lower_ind = 1
and t1.deal_date >= add_months(current_timestamp(),-6)


--安居客
insert into table wrk_evaluation.house_valuation_month_deal
select
    t3.community_id,
    t3.community_name,
    t3.community_addr,
    t3.city_cd,
    t3.city_name,
    t3.district_cd,
    t3.district_name,
    t3.block_cd,
    t3.block_name,
    regexp_replace(t1.deal_average_price,'元/m²','') as avg_price,
    cast(regexp_replace(t1.deal_total_price,'万','') as decimal(11,2)) as deal_price,
    regexp_replace(t1.area,'m²','') as deal_area,
    t1.deal_time as deal_date,
    substring(t1.deal_time,1,7) as deal_month,
    'ajk' as info_src,
    '' as create_time,
    current_timestamp() as timestamp_v
from wrk_evaluation.community_evaluation_deal_ajk_pre t1
         inner join case_esf.community_source_map t2
                    on t1.city = t2.city_name
                        and t1.title_id = t2.source_community_id
                        and t2.source_info_src = 'AJK'
         left join ods_house.ods_house_asset_community t3
                   on t2.community_id= t3.community_id
where t3.city_name in ('沈阳','济南','厦门','昆明','宁波','佛山','无锡','成都','深圳','福州','南宁','长沙','南昌','银川','中山','兰州','长春','贵阳','徐州','石家庄','惠州')
  and t3.del_ind <> 1
  and t3.upper_lower_ind = 1
  and t1.ranks=1
  and t1.deal_time >= add_months(current_timestamp(),-6)



create table dw_evaluation.house_valuation_month_deal
as
    select
        t1.community_id,
        t1.community_name,
        t1.community_addr,
        t1.city_cd,
        t1.city_name,
        t1.district_cd,
        t1.district_name,
        t1.block_cd,
        t1.block_name,
        t1.avg_price,
        t1.deal_price,
        t1.deal_area,
        t1.deal_date,
        t1.deal_month,
        t1.info_src,
        t1.create_time,
        t2.bk_interval,
        t2.min_interval,
        t2.max_interval,
        current_timestamp() as timestamp_v
from wrk_evaluation.house_valuation_month_deal t1
left join ods_evaluation.house_valuation_bk_interval t2
          on t1.city_name = t2.city_name
where t1.house_property_area > t2.min_interval
  and t1.house_property_area < t2.max_interval
