


--克而瑞
truncate table dw_evaluation.community_evaluation_month_deal;
drop table dw_evaluation.community_evaluation_month_deal;
create table dw_evaluation.community_evaluation_month_deal as
insert overwrite table  dw_evaluation.community_evaluation_month_deal
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
    t3.property_type,
    t2.trademoney as deal_price,
    t2.tradearea as deal_area,
    t2.new_tradedate as deal_date,
    'cric' as info_src,
    t2.create_time,
    current_timestamp() as timestamp_v
    from ods_evaluation.cric_deal_detail t2
         inner join ods_house.ods_house_asset_community t3
        on t2.citycaption = t3.city_name
        and case when t2.community_name = '控江' then t2.projectcaption else t2.community_name end = t3.community_name
            and t3.del_ind <> 1
            and t3.upper_lower_ind = 1
where t3.community_id is not null and t2.new_tradedate >= add_months(current_timestamp(),-13)
and t3.city_name in ('苏州','天津','广州','郑州','上海','北京','合肥','杭州','西安','重庆','南京','武汉')

--贝壳
insert into table dw_evaluation.community_evaluation_month_deal
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
    t3.property_type,
    t1.total_price as deal_price,
    t1.area as deal_area,
    t1.deal_date as deal_date,
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
and t1.deal_date >= add_months(current_timestamp(),-13)


--安居客
    insert into table dw_evaluation.community_evaluation_month_deal
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
    t3.property_type,
    cast(regexp_replace(t1.deal_total_price,'万','') as decimal(11,2)) as deal_price,
    regexp_replace(t1.area,'m²','') as deal_area,
    t1.deal_time as deal_date,
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
  and t1.deal_time >= add_months(current_timestamp(),-13)


