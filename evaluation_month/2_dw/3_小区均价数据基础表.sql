--小区汇总
truncate table dw_evaluation.community_avg_price_cal;
drop table dw_evaluation.community_avg_price_cal;
create table dw_evaluation.community_avg_price_cal as
    insert overwrite table dw_evaluation.community_avg_price_cal
select
    city_cd,
    city_name,
    district_cd,
    district_name,
    community_id,
    community_name,
    coalesce(price_1,price_2,price_3,price_4,price_5,price_6) as current_price,
    coalesce(price_2,price_3,price_4,price_5,price_6,price_1) as last_month_price
from (
    select
        city_cd,
        city_name,
        district_cd,
        district_name,
        community_id,
        community_name,
        case when max(case when ranks = 1 then monthly_avg_price_desc end) = 0 then null else max(case when ranks = 1 then monthly_avg_price_desc end) end as price_1,
        case when max(case when ranks = 2 then monthly_avg_price_desc end) = 0 then null else max(case when ranks = 2 then monthly_avg_price_desc end) end as price_2,
        case when max(case when ranks = 3 then monthly_avg_price_desc end) = 0 then null else max(case when ranks = 3 then monthly_avg_price_desc end) end as price_3,
        case when max(case when ranks = 4 then monthly_avg_price_desc end) = 0 then null else max(case when ranks = 4 then monthly_avg_price_desc end) end as price_4,
        case when max(case when ranks = 5 then monthly_avg_price_desc end) = 0 then null else max(case when ranks = 5 then monthly_avg_price_desc end) end as price_5,
        case when max(case when ranks = 6 then monthly_avg_price_desc end) = 0 then null else max(case when ranks = 6 then monthly_avg_price_desc end) end as price_6
    from
        (
        select
        t2.city_cd,
        t2.city_name as city_name,
        t2.district_cd,
        t2.district_name,
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
        ) t2
    group by
        city_cd,
        city_name,
        district_cd,
        district_name,
        community_id,
        community_name
) t3

--区域汇总
truncate table dw_evaluation.community_avg_price_district_cal
drop table dw_evaluation.community_avg_price_district_cal
create table dw_evaluation.community_avg_price_district_cal
as
    insert overwrite table dw_evaluation.community_avg_price_district_cal
select
    city_cd,
    city_name,
    district_cd,
    cast(sum(case when current_price <> 0 then current_price else 0 end )/sum(case when current_price <> 0 then 1 else 0 end) as DECIMAL(13,2))  as current_price,
    cast(sum(case when last_month_price <> 0 then last_month_price else 0 end )/sum(case when last_month_price <> 0 then 1 else 0 end) as DECIMAL(13,2)) as last_month_price
from dw_evaluation.community_avg_price_cal
group by
    city_cd,
    city_name,
    district_cd

--房源明细
truncate table dw_evaluation.community_avg_price_detail;
drop table dw_evaluation.community_avg_price_detail;
create table dw_evaluation.community_avg_price_detail
    as
    insert overwrite table dw_evaluation.community_avg_price_detail
select
    t2.city_cd,
    t2.city_name as city_name,
    t2.district_cd,
    t2.district_name,
    t1.outer_id as community_id,
    t1.community_name,
    t1.biz_time,
    t1.monthly_avg_price_desc
from wrk_house.esf_price_6_mth t1
inner join ods_house.ods_house_asset_community t2
           on t1.outer_id = t2.community_id
left join (
    select
    community_id,
    case
        when cast((t1.current_price - t1.last_month_price) / t1.last_month_price as decimal(10, 6)) is not null
            then cast((t1.current_price - t1.last_month_price) / t1.last_month_price as decimal(10, 6))
        else null end as community_last_month_rate
    from dw_evaluation.community_avg_price_cal t1
    ) t3
on t1.outer_id = t3.community_id
where t2.del_ind <> 1
  and t2.upper_lower_ind = 1
  and t2.city_name  in  ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波','佛山','深圳','福州','南宁','长沙','南昌','银川','中山','兰州','长春','贵阳','徐州','石家庄','惠州')
and t1.biz_time >=substring(cast(add_months(current_timestamp(), -6) as string), 1, 7)
and t1.biz_time <=substring(cast(add_months(current_timestamp(), -1) as string), 1, 7)
and t3.community_last_month_rate>=-0.2 and t3.community_last_month_rate <=0.2
