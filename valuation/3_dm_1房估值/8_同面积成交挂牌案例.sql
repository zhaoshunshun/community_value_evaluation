

create table wrk_evaluation.house_valuation_analysis_same_community_case_01 as
    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_case_01
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
    where month_dt >= substring(add_months(current_timestamp(),-6),1,7)

truncate table wrk_evaluation.house_valuation_analysis_same_community_case_02;
drop table wrk_evaluation.house_valuation_analysis_same_community_case_02;
create table wrk_evaluation.house_valuation_analysis_same_community_case_02 as
    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_case_02
select
    community_id,
    bk_interval,
    deal_date,
    deal_area,
    layout,
    deal_price,
    avg_price,
    row_number() over(partition by community_id order by deal_date desc) as ranks
from dw_evaluation.house_valuation_month_deal t1
    where t1.deal_month >=substring(add_months(current_timestamp(),-6),1,7)

insert overwrite table dm_evaluation.house_valuation_analysis_same_community_deal
select
t1.community_id,
t1.bk_interval as area_interval,
'1' as type, --挂牌
dt as date,
t1.house_layout as layout,
t1.house_property_area as area,
t1.house_price as total_price,
t1.house_avg_price as avg_price,
current_timestamp() as timestamp_v,
substring(current_timestamp(),1,7) as batch_no
from wrk_evaluation.house_valuation_analysis_same_community_case_01 t1
where t1.ranks <=5



insert into table  dm_evaluation.house_valuation_analysis_same_community_deal
select
t1.community_id,
t1.bk_interval as area_interval,
'2' as type,   -- 成交
t1.deal_date as date,
t1.layout as layout,
t1.deal_area as area,
t1.deal_price as total_price,
t1.avg_price as avg_price,
current_timestamp() as timestamp_v,
substring(current_timestamp(),1,7) as batch_no
from wrk_evaluation.house_valuation_analysis_same_community_case_02 t1
where t1.ranks <=5



