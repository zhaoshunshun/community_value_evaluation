

    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_report_01
    select
t1.month_dt,
t1.community_id,
t1.community_name,
t1.block_cd,
t1.bk_interval,
count(1) as community_rack_cnt,
sum(case when t1.house_avg_price is not null then t1.house_avg_price else 0 end)/sum(case when t1.house_avg_price is not null then 1 else 0 end) as community_rack_price,
row_number() over(partition by t1.community_id order by t1.month_dt desc) as ranks
from dw_evaluation.house_valuation_rack_detail t1
    where t1.month_dt >= substring(add_months(current_timestamp(),-7),1,7)
group by
    t1.month_dt,
    t1.community_id,
    t1.community_name,
    t1.block_cd,
    t1.bk_interval

    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_report_0101
    select
        t1.month_dt,
        t1.community_id,
        t1.community_name,
        t1.block_cd,
        t1.bk_interval,
        t1.community_rack_cnt,
        t1.community_rack_price,
        cast((t2.community_rack_cnt - t1.community_rack_cnt)/t1.community_rack_cnt as decimal(10,4))  as community_rack_cnt_month,
        cast((t3.community_rack_cnt - t1.community_rack_cnt)/t1.community_rack_cnt as decimal(10,4))  as community_rack_cnt_year
from wrk_evaluation.house_valuation_analysis_same_community_report_01 t1
left join wrk_evaluation.house_valuation_analysis_same_community_report_01 t2
on t1.month_dt = substring(add_months(concat(t2.month_dt,'-01'),-1),1,7)
and t1.community_id = t2.community_id
and t1.bk_interval = t2.bk_interval
left join wrk_evaluation.house_valuation_analysis_same_community_report_01 t3
          on t1.month_dt = substring(add_months(concat(t3.month_dt,'-01'),-6),1,7)
              and t1.community_id = t3.community_id
              and t1.bk_interval = t3.bk_interval
where t1.month_dt >= substring(add_months(concat(t3.month_dt,'-01'),-6),1,7)




    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_report_02
select
    t1.month_dt,
    t1.block_cd,
    t1.bk_interval,
    cast(sum(case when t1.house_avg_price is not null then t1.house_avg_price else 0 end)/count(case when t1.house_avg_price is not null then 1 else 0 end) as decimal(10,4)) as block_community_rack_price
from dw_evaluation.house_valuation_rack_detail t1
group by
    t1.month_dt,
    t1.block_cd,
    t1.bk_interval




    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_report_03
    select
    t1.deal_month as month_dt,
    t1.community_id,
    t1.community_name,
    t1.block_cd,
    t1.bk_interval,
    count(1) as community_deal_cnt,
    sum(case when t1.avg_price is not null then t1.avg_price else 0 end)/sum(case when t1.avg_price is not null then 1 else 0 end) as community_deal_price
    from dw_evaluation.house_valuation_month_deal t1
where t1.deal_month >=substring(add_months(current_timestamp(),-7),1,7)
group by
    t1.deal_month,
    t1.community_id,
    t1.bk_interval,
    t1.community_name,
    t1.block_cd

    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_report_0301
select
    t1.month_dt,
    t1.community_id,
    t1.community_name,
    t1.block_cd,
    t1.bk_interval,
    t1.community_deal_cnt,
    t1.community_deal_price,
    cast((t2.community_deal_price - t1.community_deal_price)/t1.community_deal_price as decimal(10,4))  as community_deal_cnt_month,
    cast((t3.community_deal_price - t3.community_deal_price)/t1.community_deal_price as decimal(10,4))  as community_deal_cnt_year
from wrk_evaluation.house_valuation_analysis_same_community_report_03 t1
left join wrk_evaluation.house_valuation_analysis_same_community_report_03 t2
          on t1.month_dt = substring(add_months(concat(t2.month_dt,'-01'),-1),1,7)
              and t1.community_id = t2.community_id
              and t1.bk_interval = t2.bk_interval
left join wrk_evaluation.house_valuation_analysis_same_community_report_03 t3
          on t1.month_dt = substring(add_months(concat(t3.month_dt,'-01'),-6),1,7)
              and t1.community_id = t3.community_id
              and t1.bk_interval = t3.bk_interval
where t1.month_dt >=substring(add_months(current_timestamp(),-6),1,7)


insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_report_04
select
    t1.deal_month as month_dt,
    t1.block_cd,
    t1.bk_interval,
    count(1) as community_deal_cnt,
    sum(case when t1.avg_price is not null then t1.avg_price else 0 end)/sum(case when t1.avg_price is not null then 1 else 0 end) as block_community_deal_price
from dw_evaluation.house_valuation_month_deal t1
where t1.deal_month >=substring(add_months(current_timestamp(),-6),1,7)
group by
    t1.deal_month,
    t1.block_cd,
    t1.bk_interval



insert overwrite  table dm_evaluation.house_valuation_analysis_same_community_report
select
    coalesce(t1.month_dt,t3.month_dt) as month_dt,
    coalesce(t1.community_id,t3.community_id) as community_id,
    coalesce(t1.community_name,t3.community_name) as community_name,
    coalesce(t1.block_cd,t3.block_cd) as block_cd,
    coalesce(t1.bk_interval,t3.bk_interval) as bk_interval,
    t1.community_rack_cnt,
    t1.community_rack_cnt_month,
    t1.community_rack_cnt_year,
    t3.community_deal_cnt,
    t3.community_deal_cnt_month,
    t3.community_deal_cnt_year,
    t1.community_rack_price,
    t2.block_community_rack_price,
    t3.community_deal_price,
    t4.block_community_deal_price,
    current_timestamp() as timestamp_v,
    substring(current_timestamp(),1,7) as batch_no
from wrk_evaluation.house_valuation_analysis_same_community_report_0101 t1
left join wrk_evaluation.house_valuation_analysis_same_community_report_02 t2
on t1.block_cd = t2.block_cd
and t1.month_dt= t2.month_dt
and t1.bk_interval = t2.bk_interval
full join wrk_evaluation.house_valuation_analysis_same_community_report_0301 t3
on t1.community_id = t3.community_id
and t1.month_dt = t3.month_dt
and t1.bk_interval = t3.bk_interval
left join wrk_evaluation.house_valuation_analysis_same_community_report_04 t4
on t3.block_cd = t4.block_cd
and t3.month_dt= t4.month_dt
and t3.bk_interval = t4.bk_interval
where t1.month_dt >=substring(add_months(current_timestamp(),-6),1,7)
  and t1.month_dt <=substring(add_months(current_timestamp(),-1),1,7)
 or (t3.month_dt >=substring(add_months(current_timestamp(),-6),1,7)
  and t3.month_dt <=substring(add_months(current_timestamp(),-1),1,7))