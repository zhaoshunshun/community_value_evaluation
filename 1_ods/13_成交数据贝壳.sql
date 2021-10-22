
truncate  table ods_evaluation.bk_deal_detail;
drop table  ods_evaluation.bk_deal_detail;
create table ods_evaluation.bk_deal_detail as

    insert overwrite table ods_evaluation.bk_deal_detail
select
    regexp_extract(t1.detail_url,'(.*/)([0-9A-Z]+)(.html)',2) as outer_deal_id,
    split(t1.title,' ')[0] as community_name,
    split(t1.title,' ')[1] as community_layout,
    regexp_replace(split(t1.title,' ')[2],'平米','') as area,
    regexp_replace(t1.total_price,'万','') as total_price,
    regexp_replace(t1.unit_price,'元/平','') as unit_price,
    t2.city_name as city,
    t1.qy_name,
    t1.bk_name,
    regexp_extract(t1.house_info,'([东西南北暂无数据  ]*)(.*)',1) as orientations,
    regexp_extract(t1.house_info,'([东西南北暂无数据 | ]*)(.*)',2) as fit,
    from_unixtime(unix_timestamp(t1.deal_date,'yyyy.MM.dd'),'yyyy-MM-dd') as deal_date,
    case when t1.position_info like '%车位%' then '车位' else concat(regexp_extract(regexp_replace(t1.position_info,' ',''),'(.*层)',0),')') end as floor,
    regexp_extract(regexp_replace(t1.position_info,' ',''),'(.*)([0-9]{4}年建)',2) as building_year,
    case when t1.position_info like '%板楼%' then '板楼'
         when t1.position_info like '%板塔结合%' then '板塔结合'
         when t1.position_info like '%塔楼%' then '塔楼'
         when t1.position_info like '%平房%' then '平房'
         else '暂无数据'
    end as building_type,
    split(t1.listed_price,' ')[0] as rack_price,
    split(t1.listed_price,' ')[1] as deal_cycle,
    t1.detail_url,
    t1.layout_img,
    t1.dt
from case_esf.bk_deal_detail t1
left join case_esf.beike_spider_task t2
on t1.city = t2.city_tag







