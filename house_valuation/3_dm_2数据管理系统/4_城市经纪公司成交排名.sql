

insert overwrite table dm_evaluation.deal_month_agency_rank_city
select
substring(t1.deal_date,1,7) as month,
city_cd,
city_name,
agency_name,
count(1) as deal_cnt,
row_number() over(partition by city_cd,substring(t1.deal_date,1,7) order by count(1) desc) as ranks,
current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_month_deal t1
where t1.agency_name  is not null and t1.agency_name <>''
and t1.deal_month >=substring(add_months(current_timestamp(),-6),1,7)
group by
    substring(t1.deal_date,1,7),
    t1.city_cd,
    t1.city_name,
    t1.agency_name