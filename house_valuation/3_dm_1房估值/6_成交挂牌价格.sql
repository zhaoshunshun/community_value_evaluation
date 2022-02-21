
create table wrk_evaluation.house_valuation_analysis_same_community_price_01 as

    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_price_01
    select
        t1.rack_house_id as goods_id,
        '1' as type,
        t1.community_id,
        t1.bk_interval as area_interval,
        t1.house_avg_price as rack_price,
        t2.community_rack_cnt,
        rank() over(partition by t1.community_id,t1.bk_interval order by t1.house_avg_price desc) as community_goods_rank
from dw_evaluation.house_valuation_rack_detail t1
left join (
    select community_id,bk_interval,count(1) as community_rack_cnt
           from dw_evaluation.house_valuation_rack_detail
    where  month_dt = substring(add_months(current_timestamp(),-1),1,7)
    group by community_id,bk_interval
    ) t2
on t1.community_id  = t2.community_id
    and t1.bk_interval = t2.bk_interval
 where t1.month_dt = substring(add_months(current_timestamp(),-1),1,7)


create table wrk_evaluation.house_valuation_analysis_same_community_price_03 as
    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_price_03
select community_id,
       block_cd,
       bk_interval as area_interval,
       sum(case when t1.avg_price is not null then t1.avg_price else 0 end)/count(case when t1.avg_price is not null then t1.avg_price else 0 end ) as avg_price
from dw_evaluation.house_valuation_month_deal t1
where t1.deal_month = substring(add_months(current_timestamp(),-1),1,7)
group by community_id,block_cd,bk_interval


create table wrk_evaluation.house_valuation_analysis_same_community_price_02 as

    insert overwrite table wrk_evaluation.house_valuation_analysis_same_community_price_02
    select
'' as goods_id,
'2' as type,
t1.community_id,
t1.bk_interval as area_interval,
t1.avg_price as deal_price,
t2.community_deal_cnt,
t3.community_deal_rank,
t4.community_deal_med
from dw_evaluation.house_valuation_month_deal t1
left join (
    select community_id,
           bk_interval,
           count(1) as community_deal_cnt
    from dw_evaluation.house_valuation_month_deal t1
    where  t1.deal_month = substring(add_months(current_timestamp(),-1),1,7)
    group by community_id,bk_interval
    ) t2
on t1.community_id = t2.community_id
    and t1.bk_interval = t2.bk_interval
left join (
    select
        community_id,
        area_interval,
        rank() over(partition by community_id,area_interval order by avg_price desc) as community_deal_rank
    from wrk_evaluation.house_valuation_analysis_same_community_price_03
    )  t3
on t1.community_id = t3.community_id
       and t1.bk_interval = t3.area_interval
left join (
    select
    community_id,
    area_interval,
    percentile_approx(avg_price,0.5) as community_deal_med
    from wrk_evaluation.house_valuation_analysis_same_community_price_03
    group by community_id,area_interval
    ) t4
on t1.community_id = t4.community_id
    and t1.bk_interval = t4.area_interval
where t1.deal_month = substring(add_months(current_timestamp(),-1),1,7)




insert overwrite table  dm_evaluation.house_valuation_analysis_same_community_price
select
    t1.goods_id,
    t1.type,
    t1.community_id,
    t1.area_interval,
    t1.rack_price,
    t1.community_rack_cnt,
    t1.community_goods_rank,
    null as deal_price,
    null as community_deal_cnt,
    null as community_deal_rank,
    null as community_deal_med,
    current_timestamp() as timestamp_v,
    substring(current_timestamp(),1,7) as batch_no
from  wrk_evaluation.house_valuation_analysis_same_community_price_01 t1


insert into table  dm_evaluation.house_valuation_analysis_same_community_price
select
    t1.goods_id,
    t1.type,
    t1.community_id,
    t1.area_interval,
    null as rack_price,
    null as community_rack_cnt,
    null as community_goods_rank,
    t1.deal_price,
    t1.community_deal_cnt,
    t1.community_deal_rank,
    t1.community_deal_med,
    current_timestamp() as timestamp_v,
    substring(current_timestamp(),1,7) as batch_no
from wrk_evaluation.house_valuation_analysis_same_community_price_02 t1




