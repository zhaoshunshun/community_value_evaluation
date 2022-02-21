

insert overwrite table wrk_evaluation.community_evaluation_list_community_change_price
    select
    substring(t1.batch_time,1,7) as month,
    t1.city_cd,
    t1.city_name,
    t1.community_id,
    t1.community_name,
    t1.goods_code,
    t1.total_price,
    t1.rack_rate_layout,
    t1.rack_rate_area,
    t1.jdj_url,
    (cast(t1.total_price as DECIMAL(11,2)) - cast(t2.total_price as DECIMAL(11,2))) as list_up_increment_price,
    (cast(t1.total_price as DECIMAL(11,2)) - cast(t2.total_price as DECIMAL(11,2))) / cast(t1.total_price as DECIMAL(11,2)) as list_up_rate
from dw_evaluation.community_evaluation_list_month_detail t1
left join dw_evaluation.community_evaluation_list_month_detail t2
    on substring(t1.batch_time,1,7) =substring(cast(add_months(t2.batch_time,1) as STRING),1,7)
    and t1.city_cd =t2.city_cd
    and t1.community_id =t2.community_id
    and t1.goods_code =t2.goods_code
;


insert overwrite table wrk_evaluation.community_evaluation_list_community_cnt
select substring(batch_time, 1, 7)            as month,
       city_cd,
       city_name,
       community_id,
       community_name,
       count(goods_code)             as list_cnt,
       avg(cast(avg_price as DECIMAL(11, 2))) as list_avg_price,
       row_number()
       over (partition by city_cd,city_name,community_id,community_name order by substring(batch_time, 1, 7) desc) as ranks
from dw_evaluation.community_evaluation_list_month_detail
group by substring(batch_time, 1, 7),
         city_cd,
         city_name,
         community_id,
         community_name;



insert overwrite table wrk_evaluation.community_evaluation_list_community
select t1.month,
       t1.city_cd,
       t1.city_name,
       t1.community_id,
       t1.community_name,
       t1.list_cnt,
       (t1.list_cnt - t2.list_cnt) / t2.list_cnt as list_cnt_rate_month,
       (t1.list_cnt - t3.list_cnt) / t3.list_cnt as list_cnt_rate_year,
       t1.list_avg_price,
       (t1.list_avg_price -t2.list_avg_price) / t2.list_avg_price as list_price_rate_month,
           (t1.list_avg_price -t3.list_avg_price) / t3.list_avg_price as list_price_rate_year
from wrk_evaluation.community_evaluation_list_community_cnt t1
         left join wrk_evaluation.community_evaluation_list_community_cnt t2
                   on t1.city_cd= t2.city_cd
                        and t1.community_id = t2.community_id
                       and t1.month=substring(cast(add_months(concat(t2.month,'-01'),1) as STRING),1,7)
         left join wrk_evaluation.community_evaluation_list_community_cnt t3
                   on t1.city_cd= t3.city_cd
                    and t1.community_id= t3.community_id
                       and t1.month=substring(cast(add_months(concat(t2.month,'-01'),12) as STRING),1,7)
;



insert overwrite table wrk_evaluation.community_evaluation_deal_community_cnt
select substring(deal_time,1,7) as month,
       city_cd,
       city_name,
       community_id,
       community_name,
       count(distinct goods_id) as deal_cnt,
       avg(cast(deal_average_price as DECIMAL(11,2))) as deal_avg_price,
       row_number() over (partition by city_cd,city_name,community_id,community_name order by substring(deal_time,1,7) desc) as ranks
from dw_evaluation.community_evaluation_deal_detail
group by substring(deal_time,1,7),
         city_cd,
         city_name,
         community_id,
         community_name;



insert overwrite table wrk_evaluation.community_evaluation_deal_community
select t1.month,
       t1.city_cd,
       t1.city_name,
       t1.deal_cnt,
       t1.community_id,
       t1.community_name,
       (t1.deal_cnt - t2.deal_cnt) / t2.deal_cnt as deal_cnt_rate_month,
       (t1.deal_cnt - t3.deal_cnt) / t3.deal_cnt as deal_cnt_rate_year,
       t1.deal_avg_price,
       (t1.deal_avg_price -t2.deal_avg_price) / t2.deal_avg_price as deal_avg_price_rate_month,
       (t1.deal_avg_price -t3.deal_avg_price) / t3.deal_avg_price as deal_avg_price_rate_year
from wrk_evaluation.community_evaluation_deal_community_cnt t1
         left join wrk_evaluation.community_evaluation_deal_community_cnt t2
                   on t1.city_cd= t2.city_cd
                    and t1.community_id=t2.community_id
                    and t1.month=substring(cast(add_months(concat(t2.month,'-01'),1) as STRING),1,7)
         left join wrk_evaluation.community_evaluation_deal_community_cnt t3
                   on t1.city_cd= t3.city_cd
                    and t1.community_id = t3.community_id
                    and t1.month=substring(cast(add_months(concat(t3.month,'-01'),12) as STRING),1,7)
;


insert overwrite table dm_evaluation.community_evaluation_analysis
select
    t1.month,
    t1.city_cd as city_id,
    t1.city_name,
    cast(t1.community_id as STRING) as community_id,
    t1.community_name as community_name,
    cast(t1.list_cnt as STRING) as list_cnt,
    case when t1.list_cnt_rate_year<0 then concat('减少',regexp_replace(cast(cast(t1.list_cnt_rate_year*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t1.list_cnt_rate_year>0 then concat('增加',cast(cast(t1.list_cnt_rate_year*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t1.list_cnt_rate_year*100 as decimal(11,2)) as STRING),'%') end as list_year_rate,
    case when t1.list_cnt_rate_month<0 then concat('减少',regexp_replace(cast(cast(t1.list_cnt_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t1.list_cnt_rate_month>0 then concat('增加',cast(cast(t1.list_cnt_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t1.list_cnt_rate_month*100 as decimal(11,2)) as STRING),'%') end as list_month_rate,
    cast(cast(t2.deal_cnt/t1.list_cnt as decimal(11,4)) as STRING) as deal_cnt,
    case when t2.deal_cnt_rate_year<0 then concat('减少',regexp_replace(cast(cast(t2.deal_cnt_rate_year*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.deal_cnt_rate_year>0 then concat('增加',cast(cast(t2.deal_cnt_rate_year*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.deal_cnt_rate_year*100 as decimal(11,2)) as STRING),'%') end as deal_year_rate,
    case when t2.deal_cnt_rate_month<0 then concat('减少',regexp_replace(cast(cast(t2.deal_cnt_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.deal_cnt_rate_month>0 then concat('增加',cast(cast(t2.deal_cnt_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.deal_cnt_rate_month*100 as decimal(11,2)) as STRING),'%') end as deal_month_rate,
    case when t1.list_cnt_rate_month-t2.deal_cnt_rate_month < -0.005 then '供不应求'
         when t1.list_cnt_rate_month-t2.deal_cnt_rate_month > 0.005 then '供过于求'
         else '供求平衡' end as demand_type,
    cast(t1.list_avg_price as STRING) as list_avg_price,
    case when t1.list_price_rate_year<0 then concat('减少',regexp_replace(cast(cast(t1.list_price_rate_year*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t1.list_price_rate_year>0 then concat('增加',cast(cast(t1.list_price_rate_year*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t1.list_price_rate_year*100 as decimal(11,2)) as STRING),'%') end as list_avg_price_year_rate,
    case when t1.list_price_rate_month<0 then concat('减少',regexp_replace(cast(cast(t1.list_price_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t1.list_price_rate_month>0 then concat('增加',cast(cast(t1.list_price_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t1.list_price_rate_month*100 as decimal(11,2)) as STRING),'%') end as list_avg_price_month_rate,
    cast(t2.deal_avg_price as STRING) as deal_avg_price,
    case when t2.deal_avg_price_rate_year<0 then concat('减少',regexp_replace(cast(cast(t2.deal_avg_price_rate_year*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.deal_avg_price_rate_year>0 then concat('增加',cast(cast(t2.deal_avg_price_rate_year*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.deal_avg_price_rate_year*100 as decimal(11,2)) as STRING),'%') end as deal_avg_price_year_rate,
    case when t2.deal_avg_price_rate_month<0 then concat('减少',regexp_replace(cast(cast(t2.deal_avg_price_rate_month*100 as decimal(11,2)) as STRING),'-',''),'%')
         when t2.deal_avg_price_rate_month>0 then concat('增加',cast(cast(t2.deal_avg_price_rate_month*100 as decimal(11,2)) as STRING),'%')
         else concat(cast(cast(t2.deal_avg_price_rate_month*100 as decimal(11,2)) as STRING),'%') end as deal_avg_price_month_rate,
    case when (t2.deal_avg_price - t1.list_avg_price)/t1.list_avg_price <-0.01 then '成交价低于挂牌价'
         when (t2.deal_avg_price - t1.list_avg_price)/t1.list_avg_price >0.01 then '成交价高于挂牌价'
         else '成交价与挂牌价相当' end as deal_list_change_type,
    t3.goods_code as list_up_goods_id,
    concat(cast(cast(t3.total_price as decimal(11,2)) as STRING),'万') as list_up_current_price,
    concat(cast(cast(t3.list_up_increment_price as decimal(11,2)) as STRING),'万') as list_up_increment_price,
    concat('涨幅',cast(cast(t3.list_up_rate*100 as decimal(11,2)) as STRING),'%') as list_up_rate,
    t3.rack_rate_layout as list_up_layout,
    concat(cast(t3.rack_rate_area as STRING),'m²') as list_up_area,
    t3.jdj_url as list_up_url,
    t4.goods_code as list_down_goods_id,
    concat(cast(cast(t4.total_price as decimal(11,2)) as STRING),'万') as list_down_current_price,
    concat(regexp_replace(cast(cast(t4.list_up_increment_price as decimal(11,2)) as STRING),'-',''),'万') as list_down_increment_price,
    concat('降幅',regexp_replace(cast(cast(t4.list_up_rate*100 as decimal(11,2)) as STRING),'-',''),'%') as list_down_rate,
    t4.rack_rate_layout as list_down_layout,
    concat(cast(cast(t4.rack_rate_area as decimal(11,2)) as STRING),'m²') as list_down_area,
    t4.jdj_url as list_down_url,
    current_timestamp() as timestamp_v
from  wrk_evaluation.community_evaluation_list_community t1
    left join wrk_evaluation.community_evaluation_deal_community t2
    on t1.city_cd=t2.city_cd
        and t1.community_id =t2.community_id
        and t1.month=t2.month
    left join (
    select *,
           row_number() over(partition by city_cd,community_id order by list_up_rate asc) as ranks
    from wrk_evaluation.community_evaluation_list_community_change_price
    where list_up_rate >0
      and list_up_increment_price !=0
    ) t3
    on t1.city_cd = t3.city_cd
        and t1.community_id =t3.community_id
        and t1.month=t3.month
        and t3.ranks=1
    left join (
    select *,
           row_number() over(partition by city_cd,community_id order by list_up_rate desc) as ranks
    from wrk_evaluation.community_evaluation_list_community_change_price
    where list_up_rate <0
      and list_up_increment_price !=0
) t4
    on t1.city_cd = t4.city_cd
        and t1.community_id =t4.community_id
        and t1.month=t4.month
        and t4.ranks=1
where t1.month< substring(current_timestamp(),1,7);
