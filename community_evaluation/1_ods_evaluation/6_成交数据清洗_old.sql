
insert overwrite table ods_evaluation.community_evaluation_deal
select distinct info_src,
                cityname,
                region,
                plate,
                title,
                title_id,
                goods_id,
                goodes_name,
                deal_time,
                layout,
                area,
                deal_price,
                deal_average_price,
                property_type,
                frame_image,
                frame_image_mark_remove
from ods_house.lj_app_chengjiao_detail
union all
select distinct info_src,
                cityname,
                region,
                plate,
                title,
                title_id,
                goods_id,
                goodes_name,
                deal_time,
                layout,
                area,
                deal_price,
                deal_average_price,
                property_type,
                frame_image,
                frame_image_mark_remove
from ods_house.lianjia_app_chengjiao_detail;

--字段清洗
insert overwrite table wrk_evaluation.community_evaluation_deal_01
select t1.info_src
     , t1.cityname  as city_name
     , case when t1.region='不限' then '' else t1.region end   as district_name
     , case when t1.plate='不限' then '' else t1.plate end     as block_name
     , t1.title     as source_community_name
     , t1.title_id  as source_community_id
     , t1.goods_id  as goods_id
     , t1.goodes_name
     , case
           when length(t1.deal_time) = 10 then regexp_replace(t1.deal_time, '\\.', '-')
           when length(t1.deal_time) = 7 then concat(regexp_replace(t1.deal_time, '\\.', '-'), '-01')
           else '' end                                 as deal_time
     ,case when t1.layout like '%房%' then concat(regexp_extract(t1.layout,'([0-9]+)(.*)([0-9]+)(.*)',1),'室')
             when t1.layout in ('暂无数据','') then '0室'
             else regexp_extract(t1.layout,'(.*)([0-9]+室)(.*)',2) end as house_cnt
     ,case when t1.layout like '%房%' or t1.layout in ('暂无数据','') then '0厅'
           else regexp_extract(t1.layout,'(.*)([0-9]+厅)(.*)',2) end as hall_cnt
     ,case when t1.layout in ('暂无数据','') then '0卫'
           else regexp_extract(t1.layout,'(.*)([0-9]+卫)',2) end as bath_cnt
     , cast(t1.area as decimal(10, 2))      as area
     ,case when regexp_replace(t1.deal_price,'[^\\d.\\-]+','') like '%-%'
         then (cast(split(regexp_replace(t1.deal_price,'[^\\d.\\-]+',''),'-')[0] as decimal(11,2)) + cast(split(regexp_replace(t1.deal_price,'[^\\d.\\-]+',''),'-')[1] as decimal(11,2)))/2
         else cast(regexp_replace(t1.deal_price,'[^\\d.\\-]+','') as decimal(11,2)) end as deal_price
     , case when regexp_replace(t1.deal_average_price,'[^\\d.\\-]+','') like '%-%'
         then (cast(split(regexp_replace(t1.deal_average_price,'[^\\d.\\-]+',''),'-')[0] as decimal(11,2)) + cast(split(regexp_replace(t1.deal_average_price,'[^\\d.\\-]+',''),'-')[1] as decimal(11,2)))/2
         else cast(regexp_replace(t1.deal_average_price,'[^\\d.\\-]+','') as decimal(11,2)) end as deal_average_price
     , case
           when t1.property_type = '墅' then '别墅'
           when t1.property_type = '别' then '别墅'
           when t1.property_type = '公寓公寓' then '公寓'
           when t1.property_type = '普通宅' then '普通住宅'
           when t1.property_type = '普住宅' then '普通住宅'
           when t1.property_type = '通住宅' then '普通住宅'
           when t1.property_type = '普通住' then '普通住宅'
           when t1.property_type = '业办公类' then '商业办公类'
           when t1.property_type = '商办公类' then '商业办公类'
           when t1.property_type = '商业公类' then '商业办公类'
           when t1.property_type = '商业办公' then '商业办公类'
           when t1.property_type = '商住用' then '商住两用'
           when t1.property_type = '住两用' then '商住两用'
           when t1.property_type = '商两用' then '商住两用'
           when t1.property_type = '商住两' then '商住两用'
           else t1.property_type end as property_type
     , t1.frame_image as frame_image
     ,case
          when t1.frame_image is not null and t1.frame_image <> ''
              then split(regexp_extract(t1.frame_image, '(.*/)(.*)', 2), '\\.')[0]
          else '' end as frame_image_key
     , t1.frame_image_mark_remove as frame_image_mark_remove
from ods_evaluation.community_evaluation_deal t1
    where t1.title_id <> ''
and t1.property_type not in ('工业厂房','车库','商务公寓','单身公寓住宅');

--字段补充与映射
insert overwrite table wrk_evaluation.community_evaluation_deal_02
select
    t1.info_src
     ,coalesce(t3.city_cd,t4.city_cd) as city_cd
     ,t1.city_name
     ,t3.district_cd as district_cd
     ,coalesce(t3.district_name,t1.district_name) as district_name
     ,coalesce(t3.block_cd,t6.block_cd) as block_cd
     ,coalesce(t3.block_name,t1.block_name) as block_name
     ,t3.community_name as community_name
     ,t3.community_id
     ,t1.goods_id
     ,t1.goodes_name
     ,t1.deal_time
     ,concat(t1.house_cnt,t1.hall_cnt,t1.bath_cnt) as layout
     ,t1.area
     ,case when t1.deal_price is null then cast((t1.deal_average_price*t1.area)/10000 as int) else t1.deal_price end as  deal_price
     ,case when t1.deal_average_price is null then cast((t1.deal_price*10000)/t1.area as int) else t1.deal_average_price end as  deal_average_price
     ,t1.property_type
     ,t1.frame_image
     ,t1.frame_image_key
     ,t1.frame_image_mark_remove
     ,t2.jdj_url
from  wrk_evaluation.community_evaluation_deal_01 t1
          inner join ods_house.ods_house_asset_community t3
                     on t1.source_community_id = t3.source_community_id
                         and t1.city_name = t3.city_name
          left join wrk_evaluation.shitu_huitu_all_ww_key t2
                    on t1.frame_image_key = t2.frame_image_key
          left join dw_house.dw_city t4
                    on t1.city_name = t4.city_name
          left join dw_house.dw_block t6
                    on t1.block_name = t6.block_name
                        and t1.city_name=t6.city_name;

--去重
insert overwrite table wrk_evaluation.community_evaluation_deal_cleaned
select distinct city_name
              , city_cd
              , district_name
              , district_cd
              , block_name
              , block_cd
              , community_name
              , community_id
              , goods_id
              , deal_time
              , layout
              , area
              , deal_price
              , deal_average_price
              , property_type
              , jdj_url
              , frame_image
from (
         select a.*
              , row_number() over (partition by city_name,community_name,goods_id order by (case
                when jdj_url is not null and trim(jdj_url) <> '' then 0 else 1 end),(case when frame_image is not null and trim(frame_image) <> '' then 0 else 1 end)) as rn
         from wrk_evaluation.community_evaluation_deal_02 a  where deal_average_price<500000) t
WHERE rn = 1;


