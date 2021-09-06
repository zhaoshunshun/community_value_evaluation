
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
    coalesce(price_2,price_3,price_4,price_5,price_6) as last_month_price,
    coalesce(price_6,price_5,price_4,price_3,price_2) as last_6_month_price
from (
    select
        city_cd,
        city_name,
        district_cd,
        district_name,
        community_id,
        community_name,
        max(case when ranks = 1 then monthly_avg_price_desc end) as price_1,
        max(case when ranks = 2 then monthly_avg_price_desc end) as price_2,
        max(case when ranks = 3 then monthly_avg_price_desc end) as price_3,
        max(case when ranks = 4 then monthly_avg_price_desc end) as price_4,
        max(case when ranks = 5 then monthly_avg_price_desc end) as price_5,
        max(case when ranks = 6 then monthly_avg_price_desc end) as price_6
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
        and t2.city_name  in  ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波')
        ) t2
    group by
        city_cd,
        city_name,
        district_cd,
        district_name,
        community_id,
        community_name
) t3


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
    cast(sum(case when last_6_month_price <> 0 then last_6_month_price else 0 end )/sum(case when last_6_month_price <> 0 then 1 else 0 end) as DECIMAL(13,2)) as last_6_month_price
from dw_evaluation.community_avg_price_cal
group by
    city_cd,
    city_name,
    district_cd
