select *
from ods_house.ods_house_asset_community --资产小区表
select *
from ods_house.ods_pyspider_db_community_ke_strategy
where version = '20210524' - -贝壳小区攻略数据
select *
from ods_house.ods_shangnaxue_school --上哪学
dw_house.dw_community_price_cal_new_adjust   --小区均价表


udf.pointdistance

create table wrk_evaluation.community_evaluation_month_analysis_08_01_tmp as
insert overwrite table wrk_evaluation.community_evaluation_month_analysis_08_01_tmp
select t1.community_id,
    t1.city_cd,
    t1.district_cd,
    case when t2.cnt is null then 0 else t2.cnt end as community_deal_rate,
    t3.community_cnt
from dw_evaluation.community_month_report_base_info t1
         left join
(
    select community_id,
        count(1) as cnt
    from dw_evaluation.community_evaluation_month_deal
    group by community_id
) t2
on t1.community_id = t2.community_id
         left join (
    select city_cd,
        count(1) as community_cnt
    from dw_evaluation.community_month_report_base_info
    group by city_cd
) t3
                   on t1.city_cd = t3.city_cd

create table wrk_evaluation.community_evaluation_month_analysis_08_02_tmp as
insert overwrite table wrk_evaluation.community_evaluation_month_analysis_08_02_tmp
select t1.city_cd,
    t1.district_cd,
    case when t2.cnt is null then 0 else t2.cnt end as deal_rate,
    t3.district_cnt
from (select city_cd, district_cd, count(1)
      from dw_evaluation.community_month_report_base_info
      group by city_cd, district_cd) t1
         left join
(
    select district_cd,
        count(1) as cnt
    from dw_evaluation.community_evaluation_month_deal
    group by district_cd
) t2
on t1.district_cd = t2.district_cd
         left join (
    select city_cd,
        count(distinct district_cd) as district_cnt
    from dw_evaluation.community_month_report_base_info
    group by city_cd
) t3
                   on t1.city_cd = t3.city_cd
    量：
select t1.community_id,
    t3.community_name,
    t1.city_cd,
    t3.city_name,
    t3.district_name,
    t1.district_cd,
    t1.community_deal_rate as community_deal_cnt,
    rank() over (partition by t1.city_cd order by t1.community_deal_rate asc ) as city_community_rank,
    t1.community_cnt as city_community_cnt,
    rank()
            over (partition by t1.city_cd,t1.district_cd order by t1.community_deal_rate asc ) as district_community_rank,
    t4.district_community_cnt,
    t2.deal_rate as district_deal_cnt,
    t2.district_rank as city_district_rank,
    t2.district_cnt as city_district_cnt
from wrk_evaluation.community_evaluation_month_analysis_08_01_tmp t1
         left join (
    select city_cd,
        district_cd,
        t1.deal_rate,
        t1.district_cnt,
        rank() over (partition by t1.city_cd order by t1.deal_rate asc ) as district_rank
    from wrk_evaluation.community_evaluation_month_analysis_08_02_tmp t1
) t2
                   on t1.district_cd = t2.district_cd
         left join dw_evaluation.community_month_report_base_info t3
                   on t1.community_id = t3.community_id
         left join (
    select city_cd,
        district_cd,
        count(1) as district_community_cnt
    from wrk_evaluation.community_evaluation_month_analysis_08_01_tmp
    group by city_cd,
        district_cd
) t4
                   on t1.city_cd = t4.city_cd
                       and t1.district_cd = t4.district_cd
where t1.city_cd = '3101'
order by community_deal_rate desc
    价：
truncate table wrk_evaluation.community_evaluation_month_analysis_02_01_tmp;
drop table wrk_evaluation.community_evaluation_month_analysis_02_01_tmp;
create table wrk_evaluation.community_evaluation_month_analysis_02_01_tmp
as
insert overwrite table wrk_evaluation.community_evaluation_month_analysis_02_01_tmp
select t2.community_id,
    t2.city_cd,
    t2.district_cd,
    t1.current_price,
    t1.last_6_month_price,
    case
        when cast((t1.current_price - t1.last_6_month_price) / t1.last_6_month_price as decimal(10, 6)) is not null
            then cast((t1.current_price - t1.last_6_month_price) / t1.last_6_month_price as decimal(10, 6))
        else null end as community_last_6_month_rate,
    t3.cnt            as community_cnt
from dw_evaluation.community_month_report_base_info t2
         left join dw_evaluation.community_avg_price_cal t1
                   on t1.community_id = t2.community_id
         left join (
    select city_cd,
        count(1) as cnt
    from dw_evaluation.community_month_report_base_info
    group by city_cd
) t3
                   on t2.city_cd = t3.city_cd

truncate table wrk_evaluation.community_evaluation_month_analysis_02_02_tmp;
drop table wrk_evaluation.community_evaluation_month_analysis_02_02_tmp;
create table wrk_evaluation.community_evaluation_month_analysis_02_02_tmp
as
insert overwrite table wrk_evaluation.community_evaluation_month_analysis_02_02_tmp
select t1.city_cd,
    t1.district_cd,
    t1.district_avg_current_price,
    t1.district_avg_last_six_price,
    case
        when cast((t1.district_avg_current_price - t1.district_avg_last_six_price) as decimal(10, 4)) /
             cast(t1.district_avg_last_six_price as decimal(10, 4)) is null then 0
        else
                cast((t1.district_avg_current_price - t1.district_avg_last_six_price) as decimal(10, 4)) /
                cast(t1.district_avg_last_six_price as decimal(10, 4)) end
           as community_last_6_month_rate,
    t2.cnt as district_cnt
from (
    select t2.city_cd,
        t2.district_cd,
            sum(case when t1.current_price <> 0 and t1.current_price is not null then t1.current_price else 0 end) /
            sum(case
                    when t1.current_price <> 0 and t1.current_price is not null then 1
                    else 0 end) as                       district_avg_current_price,
            sum(case
                    when t1.last_6_month_price <> 0 and t1.last_6_month_price is not null then t1.last_6_month_price
                    else 0 end) / sum(case
                                          when t1.last_6_month_price <> 0 and t1.last_6_month_price is not null then 1
                                          else 0 end) as district_avg_last_six_price
    from dw_evaluation.community_month_report_base_info t2
             left join dw_evaluation.community_avg_price_cal t1
                       on t1.community_id = t2.community_id
    group by t2.city_cd, t2.district_cd
) t1
         left join (
    select city_cd,
        count(distinct district_cd) as cnt
    from dw_evaluation.community_month_report_base_info
    group by city_cd
) t2
                   on t1.city_cd = t2.city_cd



select t3.community_id,
    t3.community_name,
    t3.city_cd,
    t3.city_name,
    t3.district_cd,
    t3.district_name,
    t1.current_price,
    t1.last_6_month_price,
    t1.community_last_6_month_rate,
    rank()
            over (partition by t3.city_cd order by t1.community_last_6_month_rate asc) as                city_community_rack_month_six_rank,
    t1.community_cnt as                                                                                  city_community_cnt,
    t2.district_avg_current_price,
    t2.district_avg_last_six_price,
    rank()
            over (partition by t3.city_cd,t3.district_cd order by t1.community_last_6_month_rate asc) as district_community_rack_month_six_rank,
    t4.district_community_cnt,
    t2.district_community_last_6_month_rate,
    t2.district_rack_month_six,
    t2.district_cnt,
    t5.price_1,
    t5.price_2,
    t5.price_3,
    t5.price_4,
    t5.price_5,
    t5.price_6,
    t6.district_price_1,
    t6.district_price_2,
    t6.district_price_3,
    t6.district_price_4,
    t6.district_price_5,
    t6.district_price_6

from dw_evaluation.community_month_report_base_info t3
         left join (
    select t1.city_cd,
        t1.district_cd,
        t1.district_cnt,
        t1.district_avg_current_price,
        t1.district_avg_last_six_price,
        t1.community_last_6_month_rate                                                    as district_community_last_6_month_rate,
        rank() over (partition by t1.city_cd order by t1.community_last_6_month_rate asc) as district_rack_month_six
    from wrk_evaluation.community_evaluation_month_analysis_02_02_tmp t1
    where t1.community_last_6_month_rate >= -0.3
      and t1.community_last_6_month_rate <= 0.3
) t2
                   on t3.district_cd = t2.district_cd
         left join wrk_evaluation.community_evaluation_month_analysis_02_01_tmp t1
                   on t1.community_id = t3.community_id
                       and t1.community_last_6_month_rate >= -0.3 and t1.community_last_6_month_rate <= 0.3
         left join (
    select city_cd,
        district_cd,
        count(1) as district_community_cnt
    from dw_evaluation.community_month_report_base_info
    group by city_cd, district_cd
) t4
                   on t3.city_cd = t4.city_cd
                       and t3.district_cd = t4.district_cd
left join
(
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
    )  t5 on  t1.community_id = t6.community_id
left join
    (
        select
            t4.district_cd,
            cast(sum(t4.price_1)/sum(case when t4.price_1 <> 0 then 1 else 0 end ) as decimal(10,4)) as district_price_1,
            cast(sum(t4.price_2)/sum(case when t4.price_2 <> 0 then 1 else 0 end ) as decimal(10,4)) as district_price_2,
            cast(sum(t4.price_3)/sum(case when t4.price_3 <> 0 then 1 else 0 end ) as decimal(10,4)) as district_price_3,
            cast(sum(t4.price_4)/sum(case when t4.price_4 <> 0 then 1 else 0 end ) as decimal(10,4)) as district_price_4,
            cast(sum(t4.price_5)/sum(case when t4.price_5 <> 0 then 1 else 0 end ) as decimal(10,4)) as district_price_5,
            cast(sum(t4.price_6)/sum(case when t4.price_6 <> 0 then 1 else 0 end ) as decimal(10,4)) as district_price_6
        from
            (
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
            ) t4
        group by t4.district_cd
        ) t6
on t1.district_cd =t6.district_cd
where t3.city_cd = '3101'