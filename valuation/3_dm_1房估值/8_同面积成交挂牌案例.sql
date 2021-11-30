

create table wrk_evaluation.house_valuation_analysis_same_community_case_01 as
select
    community_id,
    bk_interval,
    dt,
    house_layout,
    house_property_area,
    house_price,
    house_avg_price,
    row_number() over(partition by community_id order by dt desc) as ranks
from dw_evaluation.house_valuation_rack_detail

truncate table wrk_evaluation.house_valuation_analysis_same_community_case_02;
drop table wrk_evaluation.house_valuation_analysis_same_community_case_02;
create table wrk_evaluation.house_valuation_analysis_same_community_case_02 as
select
    community_id,
    bk_interval,
    deal_date,
    deal_area,
    layout,
    deal_price,
    avg_price,
    row_number() over(partition by community_id order by deal_date desc) as ranks
from dw_evaluation.house_valuation_month_deal
    where t1.deal_month >=substring(add_months(current_timestamp(),-6),1,7)

insert overwrite table dm_evaluation.house_valuation_analysis_same_community_case
select
t1.community_id,
t1.bk_interval as area_interval,
'挂牌' as type,
dt as date,
t1.house_layout as layout,
t1.house_property_area as area,
t1.house_price as total_price,
t1.house_avg_price as avg_price,
current_timestamp() as timestamp_v
from wrk_evaluation.house_valuation_analysis_same_community_case_01 t1
where t1.ranks <=5



insert into table  dm_evaluation.house_valuation_analysis_same_community_case
select
t1.community_id,
t1.bk_interval as area_interval,
'成交' as type,
t1.deal_date as date,
t1.layout as layout,
t1.deal_area as area,
t1.deal_price as total_price,
t1.avg_price as avg_price,
current_timestamp() as timestamp_v
from wrk_evaluation.house_valuation_analysis_same_community_case_02 t1
where t1.ranks <=5



