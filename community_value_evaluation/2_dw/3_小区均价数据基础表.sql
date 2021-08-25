truncate table wrk_evaluation.community_avg_price_cal_result
drop table wrk_evaluation.community_avg_price_cal_result
create table wrk_evaluation.community_avg_price_cal_result as
    insert overwrite table wrk_evaluation.community_avg_price_cal_result
select
    city_name,
    city_cd,
    district_name,
    block_name,
    community_id,
    community_name,
    community_no,
    mth,
    price,
    row_number() over(partition by city_name,community_id order by mth desc) as ranks,
    current_timestamp() as timestamp_v
from dm_house.dm_community_price_cal_result_cover_all_new_2
where city_name in  ('北京','天津','上海','成都','重庆','苏州','无锡','杭州','南京','郑州','合肥','沈阳','昆明','西安','厦门','济南','武汉','广州','宁波')

truncate table dw_evaluation.community_avg_price_cal;
drop table dw_evaluation.community_avg_price_cal;
create table dw_evaluation.community_avg_price_cal as
    insert overwrite table dw_evaluation.community_avg_price_cal
select
    t1.city_name,
    t1.city_cd,
    t1.district_name,
    t1.block_name,
    t1.community_id,
    t1.community_name,
    t1.community_no,
    t1.mth,
    t1.price as avg_price,
    cast((t2.price - t1.price)/t1.price as decimal(10,6)) as ratio_month, --小区均价涨幅
    current_timestamp() as timestamp_v
    from wrk_evaluation.community_avg_price_cal_result t1
left join wrk_evaluation.community_avg_price_cal_result t2
on t1.city_cd =t2.city_cd
and t1.community_id = t2.community_id
and t1.ranks = 1
and t2.ranks = 2
where t1.ranks =1
