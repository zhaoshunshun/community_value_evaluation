create table dw_evaluation.house_valuation_community_month_price as
    insert overwrite table dw_evaluation.house_valuation_community_month_price
select
    t2.city_cd,
    t2.city_name,
    t2.district_cd,
    t2.district_name,
    t2.block_cd,
    t2.block_name,
    t1.outer_id as community_id,
    t1.community_name,
    t1.biz_time,
    t1.monthly_avg_price_desc,
    row_number() over(partition by t2.city_name,t1.outer_id order by t1.biz_time desc ) as ranks
from wrk_house.esf_price_6_mth t1
         inner join ods_house.ods_house_asset_community t2
                    on t1.outer_id = t2.community_id
where  t2.del_ind <> 1
  and t2.upper_lower_ind = 1
  and t2.city_name  in  ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波','佛山','深圳','福州','南宁','长沙','南昌','银川','中山','兰州','长春','贵阳','徐州','石家庄','惠州')

create table dw_evaluation.house_valuation_district_month_price as
    insert overwrite table dw_evaluation.house_valuation_district_month_price
select district_cd,
       biz_time,
       sum(case when monthly_avg_price_desc <> 0 then monthly_avg_price_desc else 0 end )/count(case when monthly_avg_price_desc <> 0 then 1 else 0 end) as district_avg_price,
       row_number() over(partition by district_cd order by biz_time desc) as ranks
from dw_evaluation.house_valuation_community_month_price
group by district_cd,biz_time


create table dw_evaluation.house_valuation_block_month_price as
    insert overwrite table dw_evaluation.house_valuation_block_month_price
select block_cd,
       biz_time,
       sum(case when monthly_avg_price_desc <> 0 then monthly_avg_price_desc else 0 end )/count(case when monthly_avg_price_desc <> 0 then 1 else 0 end) as block_avg_price,
       row_number() over(partition by block_cd order by biz_time desc) as ranks
from dw_evaluation.house_valuation_community_month_price
group by block_cd,biz_time