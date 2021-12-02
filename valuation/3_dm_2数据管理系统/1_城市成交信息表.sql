
create table wrk_evaluation.deal_month_city_01 as
    insert overwrite table wrk_evaluation.deal_month_city_01
select
substring(t1.deal_date,1,7) as month,
t1.city_cd,
t1.city_name,
sum(case when t1.avg_price is not null  then t1.avg_price else 0 end) / count(case when t1.avg_price is not null  then 1 else 0 end) as avg_price,
count(1) as deal_cnt,
count(distinct t1.community_id) as deal_community_cnt,
count(distinct case when t1.agency_name ='' then null else t1.agency_name end ) as deal_agency_cnt,
row_number() over(partition by city_cd order by substring(t1.deal_date,1,7) desc) as ranks
from dw_evaluation.house_valuation_month_deal t1
where t1.deal_month >=substring(add_months(current_timestamp(),-7),1,7)
group by substring(t1.deal_date,1,7),
t1.city_cd,
t1.city_name

create table dm_evaluation.deal_month_city as
insert overwrite table dm_evaluation.deal_month_city
select
    t1.month,
    t1.city_cd,
    t1.city_name,
    t1.avg_price,
    cast((t1.avg_price - t2.avg_price) /t2.avg_price as decimal(10,2)) as deal_avg_price_month,
    t1.deal_cnt,
    t1.deal_community_cnt,
    t1.deal_agency_cnt,
    current_timestamp() as timestamp_v
from wrk_evaluation.deal_month_city_01 t1
left join wrk_evaluation.deal_month_city_01 t2
on t1.city_cd = t2.city_cd
and t1.ranks =t2.ranks-1
where t1.month >=substring(add_months(current_timestamp(),-6),1,7)

