

insert overwrite table wrk_evaluation.community_evaluation_list_city_cnt
select substring(batch_time, 1, 7)            as month,
       city_cd,
       city_name,
       count(goods_code)             as list_cnt,
       avg(cast(avg_price as DECIMAL(11, 2))) as list_avg_price,
       row_number()
       over (partition by city_cd,city_name order by substring(batch_time, 1, 7) desc) as ranks
from dw_evaluation.community_evaluation_list_month_detail
group by substring(batch_time, 1, 7),
         city_cd,
         city_name;



insert overwrite table wrk_evaluation.community_evaluation_list_city
select t1.month,
       t1.city_cd,
       t1.city_name,
       t1.list_cnt,
       (t1.list_cnt - t2.list_cnt) / t2.list_cnt as list_cnt_rate_month,
       (t1.list_cnt - t3.list_cnt) / t3.list_cnt as list_cnt_rate_year,
       t1.list_avg_price,
       (t1.list_avg_price -t2.list_avg_price) / t2.list_avg_price as list_price_rate_month,
       (t1.list_avg_price -t3.list_avg_price) / t3.list_avg_price as list_price_rate_year,
       case when abs((t1.list_avg_price - t2.list_avg_price) / t2.list_avg_price) <=0.005 then '持平'
            when (t1.list_avg_price - t2.list_avg_price) / t2.list_avg_price > 0.005 then '上涨'
            when (t1.list_avg_price - t2.list_avg_price) / t2.list_avg_price < -0.005 then '下跌'
            end as list_change_type
from wrk_evaluation.community_evaluation_list_city_cnt t1
         left join wrk_evaluation.community_evaluation_list_city_cnt t2
                   on t1.city_cd= t2.city_cd
                       and t1.month = substring(cast(add_months(concat(t2.month,'-01'),1) as STRING),1,7)
         left join wrk_evaluation.community_evaluation_list_city_cnt t3
                   on t1.city_cd= t3.city_cd
                       and t1.month = substring(cast(add_months(concat(t3.month,'-01'),12) as STRING),1,7)
;



--挂牌

insert overwrite table wrk_evaluation.community_evaluation_list_city_change_price_1
select
    t1.city_cd,
    t1.city_name,
    substring(t1.batch_time,1,7) as month,
    sum(case when cast(t1.total_price as decimal(11,2))-cast(t2.total_price as decimal(11,2))>0 then 1 else 0 end) as up_price,
    sum(case when cast(t1.total_price as decimal(11,2))-cast(t2.total_price as decimal(11,2))<0 then 1 else 0 end) as down_price,
    sum(case when abs((cast(t1.avg_price as DECIMAL(11,2)) - cast(t2.avg_price as DECIMAL(11,2))) / cast(t2.avg_price as DECIMAL(11,2))) <= 0.05 then 1 else 0 end) as po_price,
    count(1) as cnt,
    row_number() over (partition by t1.city_cd,t1.city_name order by substring(t1.batch_time,1,7) desc) as ranks,
    row_number() over (partition by t1.city_cd,t1.city_name order by substring(t1.batch_time,1,7) asc) as ranks_asc
from dw_evaluation.community_evaluation_list_month_detail t1
         left join dw_evaluation.community_evaluation_list_month_detail t2
                   on t1.city_cd=t2.city_cd
                       and t1.community_id=t2.community_id
                       and t1.goods_code = t2.goods_code
                       and substring(t1.batch_time,1,7) = substring(cast(add_months(t2.batch_time,1) as STRING),1,7)
group by
    t1.city_cd,
    t1.city_name,
    substring(t1.batch_time,1,7);

--挂牌
insert overwrite  table wrk_evaluation.community_evaluation_list_city_change_price_2

    select
        t1.city_cd,
        t1.city_name,
        t1.month,
        t1.up_price / t1.cnt as list_up_rate,
        (t1.up_price - t2.up_price) / t2.up_price as list_up_rate_month_rate,
        (t1.up_price - t3.up_price) / t3.up_price as list_up_rate_year_rate,
        t1.down_price/ t1.cnt as list_down_rate,
        (t1.down_price - t2.down_price) / t2.down_price as list_down_rate_month_rate,
        (t1.down_price - t3.down_price) / t3.down_price as list_down_rate_year_rate,
        case when t1.up_price / t1.cnt - t1.down_price/t1.cnt > 0.05 then '房价上调意愿强烈'
             when t1.up_price / t1.cnt - t1.down_price/t1.cnt <-0.05 then '房价下调意愿强烈'
            else '房价相对稳定' end as list_change_trend_type
from wrk_evaluation.community_evaluation_list_city_change_price_1 t1
left join wrk_evaluation.community_evaluation_list_city_change_price_1 t2
on t1.city_cd = t2.city_cd
and t1.month=substring(cast(add_months(concat(t2.month,'-01'),1) as STRING),1,7)
left join wrk_evaluation.community_evaluation_list_city_change_price_1 t3
          on t1.city_cd = t3.city_cd
              and t1.month=substring(cast(add_months(concat(t3.month,'-01'),12) as STRING),1,7);


insert overwrite table wrk_evaluation.community_evaluation_deal_city_cnt
select substring(deal_time,1,7) as month,
       city_cd,
       city_name,
       count(distinct goods_id) as deal_cnt,
       avg(cast(deal_average_price as DECIMAL(11,2))) as deal_avg_price,
       row_number() over (partition by city_cd,city_name order by substring(deal_time,1,7) desc) as ranks
from dw_evaluation.community_evaluation_deal_detail
group by substring(deal_time,1,7),
         city_cd,
         city_name;


--成交
insert overwrite table wrk_evaluation.community_evaluation_deal_city
select t1.month,
       t1.city_cd,
       t1.city_name,
       t1.deal_cnt,
       (t1.deal_cnt - t2.deal_cnt) / t2.deal_cnt as deal_cnt_rate_month,
       (t1.deal_cnt - t3.deal_cnt) / t3.deal_cnt as deal_cnt_rate_year,
       t1.deal_avg_price,
       (t1.deal_avg_price -t2.deal_avg_price) / t2.deal_avg_price as deal_avg_price_rate_month,
       (t1.deal_avg_price -t3.deal_avg_price) / t3.deal_avg_price as deal_avg_price_rate_year,
       case when abs((t1.deal_avg_price - t2.deal_avg_price) / t2.deal_avg_price) <=0.005 then '持平'
            when (t1.deal_avg_price - t2.deal_avg_price) / t2.deal_avg_price > 0.005 then '上涨'
            when (t1.deal_avg_price - t2.deal_avg_price) / t2.deal_avg_price < -0.005 then '下跌' end as deal_change_type
from wrk_evaluation.community_evaluation_deal_city_cnt t1
         left join wrk_evaluation.community_evaluation_deal_city_cnt t2
                   on t1.city_cd= t2.city_cd
                       and t1.month=substring(cast(add_months(concat(t2.month,'-01'),1) as STRING),1,7)
         left join wrk_evaluation.community_evaluation_deal_city_cnt t3
                   on t1.city_cd= t3.city_cd
                       and t1.month=substring(cast(add_months(concat(t3.month,'-01'),12) as STRING),1,7)
;



insert overwrite table dm_evaluation.community_evaluation_city_analysis
select * from (
    select
    coalesce(t1.month,t3.month) as month,
    coalesce(t1.city_cd,t3.city_cd) as city_id,
    coalesce(t1.city_name,t3.city_name) as city_name,
    cast(t1.list_cnt as STRING) as list_cnt,
    case when t1.list_cnt_rate_year <0 then concat('减少',regexp_replace(cast(cast(t1.list_cnt_rate_year*100 as decimal(11,2))as STRING),'-',''),'%')
        when t1.list_cnt_rate_year >0 then concat('增加',cast(cast(t1.list_cnt_rate_year*100 as decimal(11,2))as STRING),'%')
        else concat(cast(cast(t1.list_cnt_rate_year*100 as decimal(11,2))as STRING),'%') end as list_year_rate,
    case when t1.list_cnt_rate_month<0 then concat('减少',regexp_replace(cast(cast(t1.list_cnt_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t1.list_cnt_rate_month>0 then concat('增加',cast(cast(t1.list_cnt_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t1.list_cnt_rate_month*100 as decimal(11,2)) as STRING),'%') end as list_month_rate,
    cast(cast(t3.deal_cnt/t1.list_cnt as decimal(11,4)) as STRING) as deal_cnt,
    case when t3.deal_cnt_rate_year < 0 then concat('减少',regexp_replace(cast(cast(t3.deal_cnt_rate_year*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t3.deal_cnt_rate_year > 0 then concat('增加',cast(cast(t3.deal_cnt_rate_year*100 as decimal(11,2)) as STRING),'%')
          else concat(cast(cast(t3.deal_cnt_rate_year*100 as decimal(11,2)) as STRING),'%') end as deal_year_rate,
    case when t3.deal_cnt_rate_month <0 then concat('减少',regexp_replace(cast(cast(t3.deal_cnt_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t3.deal_cnt_rate_month >0 then concat('增加',cast(cast(t3.deal_cnt_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t3.deal_cnt_rate_month*100 as decimal(11,2)) as STRING),'%') end as deal_month_rate,
    case when t1.list_cnt_rate_month - t3.deal_cnt_rate_month >0.005 then '供过于求'
         when t1.list_cnt_rate_month - t3.deal_cnt_rate_month <0.005 then '供不应求'
        else '供求平衡' end as demand_type,
    concat(cast(cast(t1.list_avg_price as decimal(11,2)) as STRING),'元/m²') as list_avg_price,
    case when t1.list_price_rate_year<0 then concat('减少',regexp_replace(cast(cast(t1.list_price_rate_year*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t1.list_price_rate_year>0 then concat('增加',cast(cast(t1.list_price_rate_year*100 as decimal(11,2)) as STRING),'%')
        else concat(cast(cast(t1.list_price_rate_year*100 as decimal(11,2)) as STRING),'%') end as list_avg_price_year_rate,
    case when t1.list_price_rate_month<0 then concat('减少',regexp_replace(cast(cast(t1.list_price_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t1.list_price_rate_month>0 then concat('增加',cast(cast(t1.list_price_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t1.list_price_rate_month*100 as decimal(11,2)) as STRING),'%') end as list_avg_price_month_rate,
    t1.list_change_type as list_change_type,
    concat(cast(cast(t3.deal_avg_price as decimal(11,2)) as STRING),'元/m²') as deal_avg_price,
    case when t3.deal_avg_price_rate_year<0 then concat('减少',regexp_replace(cast(cast(t3.deal_avg_price_rate_year*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t3.deal_avg_price_rate_year>0 then concat('增加',cast(cast(t3.deal_avg_price_rate_year*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t3.deal_avg_price_rate_year*100 as decimal(11,2)) as STRING),'%') end as deal_avg_price_year_rate,
    case when t3.deal_avg_price_rate_month<0 then concat('减少',regexp_replace(cast(cast(t3.deal_avg_price_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t3.deal_avg_price_rate_month>0 then concat('增加',cast(cast(t3.deal_avg_price_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t3.deal_avg_price_rate_month*100 as decimal(11,2)) as STRING),'%') end as deal_avg_price_rate_month,
    t3.deal_change_type as deal_change_type,
    concat(cast(cast(t2.list_up_rate*100 as decimal(11,2)) as STRING),'%') as list_up_rate,
    case when t2.list_up_rate_year_rate<0 then concat('减少',regexp_replace(cast(cast(t2.list_up_rate_year_rate*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.list_up_rate_year_rate>0 then concat('增加',cast(cast(t2.list_up_rate_year_rate*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.list_up_rate_year_rate*100 as decimal(11,2)) as STRING),'%') end as list_up_rate_year_rate,
    case when t2.list_up_rate_month_rate<0 then concat('减少',regexp_replace(cast(cast(t2.list_up_rate_month_rate*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.list_up_rate_month_rate>0 then concat('增加',cast(cast(t2.list_up_rate_month_rate*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.list_up_rate_month_rate*100 as decimal(11,2)) as STRING),'%') end as list_up_rate_month_rate,
    concat(cast(cast(t2.list_down_rate*100 as decimal(11,2)) as STRING),'%') as list_down_rate,
    case when t2.list_down_rate_year_rate<0 then concat('减少',regexp_replace(cast(cast(t2.list_down_rate_year_rate*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.list_down_rate_year_rate>0 then concat('增加',cast(cast(t2.list_down_rate_year_rate*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.list_down_rate_year_rate*100 as decimal(11,2)) as STRING),'%') end as list_down_rate_year_rate,
    case when t2.list_down_rate_month_rate<0 then concat('减少',regexp_replace(cast(cast(t2.list_down_rate_month_rate*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.list_down_rate_month_rate>0 then concat('增加',cast(cast(t2.list_down_rate_month_rate*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.list_down_rate_month_rate*100 as decimal(11,2)) as STRING),'%') end as list_down_rate_month_rate,
    t2.list_change_trend_type as list_change_trend_type,
    current_timestamp() as timestamp_v
from wrk_evaluation.community_evaluation_list_city t1
left join wrk_evaluation.community_evaluation_list_city_change_price_2 t2
    on t1.month=t2.month
    and t1.city_cd=t2.city_cd
full join wrk_evaluation.community_evaluation_deal_city t3
    on t1.month=t3.month
    and t1.city_cd=t3.city_cd
) t4
where concat(t4.month,'-01') >= add_months(current_timestamp(),-7)
and t4.month< substring(current_timestamp(),1,7);



