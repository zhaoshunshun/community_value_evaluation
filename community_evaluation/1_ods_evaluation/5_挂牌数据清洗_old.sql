--挂牌数据只取链家的数据
insert overwrite table ods_evaluation.community_evaluation_list_01
select distinct t1.city
              , t1.rack_rate_region
              , t1.rack_rate_plate
              , t1.title
              , t1.title_id
              , t1.goods_code
              , t1.goods_name
              , t1.housing_pictures
              , t1.goods_pubtime
              , t1.rack_rate_layout
              , t1.rack_rate_area
              , t1.total_price
              , t1.avg_price
              , t1.rack_rate_property_type
              , t1.rack_rate_build_form
              , t1.rack_rate_trading_rights
              , t1.info_src
              , t1.batch_no
              , t1.total_floor
              , t1.floor_height
from ods_house.ods_community_rack_rate t1
where t1.info_src in ('LJ')
and  t1.dt >= add_months(current_timestamp(),-18);

--户型图处理逻辑
------------------------------------------------------------------
--获取户型图url,解析json
insert overwrite table wrk_evaluation.community_evaluation_list_02
select distinct t1.housing_pictures,
       udf.getLayoutPicture(t1.housing_pictures) as housing_pictures1
from ods_evaluation.community_evaluation_list_01 t1
where housing_pictures like '%户型图%';

--提取户型图
insert overwrite table wrk_evaluation.community_evaluation_list_03
select distinct t1.city
              , t1.rack_rate_region
              , t1.rack_rate_plate
              , t1.title
              , t1.title_id
              , t1.goods_code
              , t1.goods_name
              , t1.housing_pictures
              , t1.goods_pubtime
              , t1.rack_rate_layout
              , t1.rack_rate_area
              , t1.total_price
              , t1.avg_price
              , t1.rack_rate_property_type
              , t1.rack_rate_build_form
              , t1.rack_rate_trading_rights
              , t1.info_src
              , t1.batch_no
              , t1.total_floor
              , t1.floor_height
              , t2.pic
              , t2.pic_local
from ods_evaluation.community_evaluation_list_01 t1
         left join (select t1.housing_pictures,
                           t1.housing_pictures1,
                           regexp_replace(split(split(t1.housing_pictures1, ';')[0], '":"')[1], '"', '') as pic,
                           regexp_replace(split(split(t1.housing_pictures1, ';')[1], '":"')[1], '"', '') as pic_local
                    from wrk_evaluation.community_evaluation_list_02 t1
             ) t2
                   on t1.housing_pictures = t2.housing_pictures
;
--户型图处理结束
---------------------------------------------------------------------------------

--数据清洗
------------------------------------------------------------
insert overwrite table wrk_evaluation.community_evaluation_list_04
select distinct regexp_replace(t1.city, '[^\\u4e00-\\u9fa5]', '')                                     city,
                regexp_replace(t1.rack_rate_region, '[^\\u4e00-\\u9fa5]', '')                         rack_rate_region,
                regexp_replace(t1.rack_rate_plate, '[^\\u4e00-\\u9fa5]', '')                          rack_rate_plate,
                regexp_replace(t1.title, '[^\\u4e00-\\u9fa5]', '')                                    title,
                regexp_replace(t1.title_id, '[^\\w\\%\\/\\-\\(\\)]', '')                              title_id,
                regexp_replace(t1.goods_code, '[^\\w]', '')                                           goods_code,
                t1.goods_pubtime                                                                      goods_pubtime,
                case when t1.rack_rate_layout rlike '(.*)\\d+室(.*)' then regexp_extract(t1.rack_rate_layout,'([0-9]+室)(.*)',1)
                     when t1.rack_rate_layout rlike '(.*)[房间|间|房]+(.*)' then concat(regexp_extract(rack_rate_layout,'([0-9]+)(.*)([0-9]+)(.*)',1),'室')
                     when t1.rack_rate_layout in ('室厅厨卫','') then '0室'
                     else concat(regexp_extract(rack_rate_layout,'(.*)([0-9]+)(.*)([0-9]+)(.*)([0-9]+)(.*)([0-9]+)(.*)',2),'室') end as house_cnt,
                case when t1.rack_rate_layout rlike '\\d+室\\d+厅\\d+厨\\d+卫' then regexp_extract(t1.rack_rate_layout,'(\\d+室)(\\d+厅)(\\d+厨)(\\d+卫)',2)
                     when t1.rack_rate_layout rlike '(.*)\\d+厅(.*)' then regexp_extract(t1.rack_rate_layout,'(.*[室]?)([0-9]+厅)(.*)',2)
                     when t1.rack_rate_layout rlike '(.*)[房间|间|房]+(.*)' or t1.rack_rate_layout in ('室厅厨卫','') then '0厅'
                     else concat(regexp_extract(t1.rack_rate_layout,'(.*)([0-9]+)(.*)([0-9]+)(.*)([0-9]+)(.*)([0-9]+)(.*)',4),'厅') end as hall_cnt,
                case when t1.rack_rate_layout rlike '\\d+室\\d+厅\\d+厨\\d+卫' then regexp_extract(t1.rack_rate_layout,'(\\d+室)(\\d+厅)(\\d+厨)(\\d+卫)',4)
                     when t1.rack_rate_layout rlike '(.*)\\d+卫(.*)' then regexp_extract(t1.rack_rate_layout,'(.*[厨]?)([0-9]+卫)(.*)',2)
                     when t1.rack_rate_layout rlike '(.*)[房间|间|房]+(.*)' then concat(regexp_extract(t1.rack_rate_layout,'(.*)([0-9]+)(.*)([0-9]+)(.*)',4),'卫')
                     when t1.rack_rate_layout in ('室厅厨卫','') then '0卫'
                     else concat(regexp_extract(t1.rack_rate_layout,'(.*)([0-9]+)(.*)([0-9]+)(.*)([0-9]+)(.*)([0-9]+)(.*)',8),'卫') end as bath_cnt,
                cast(regexp_replace(t1.rack_rate_area, '[^\\d.]', '') as decimal(10, 2))              rack_rate_area,
                regexp_replace(t1.total_price, '[^\\d.(万)(亿)]', '')                                 total_price,
                regexp_replace(t1.avg_price, '[^\\d]', '')                                            avg_price,
                regexp_replace(t1.rack_rate_property_type, '[^\\u4e00-\\u9fa5]', '')                  rack_rate_property_type,
                regexp_replace(t1.rack_rate_build_form, '[^\\u4e00-\\u9fa5]', '')                     rack_rate_build_form,
                regexp_replace(t1.rack_rate_trading_rights, '[^\\u4e00-\\u9fa5]', '')                 rack_rate_trading_rights,
                case t1.info_src when 'LJ' then 'BK' else t1.info_src end as                          info_src,
                t1.batch_no                                                                           batch_no,
                from_unixtime(unix_timestamp(substring(t1.batch_no, 9, 8), 'yyyymmdd'), 'yyyy-mm-dd') batch_time,
                regexp_replace(t1.total_floor, '[^\\d]', '')                                          total_floor,
                regexp_replace(t1.floor_height, '[^\\u4e00-\\u9fa5]', '')                             floor_height,
                t1.pic                                                                                pic,
                t1.pic_local                                                                          pic_local
from wrk_evaluation.community_evaluation_list_03 t1;

-- step1.2 total_price, floor_height二次清洗
insert overwrite table wrk_evaluation.community_evaluation_list_05
select distinct t1.city                                                                                  city,
                t1.rack_rate_region                                                                      rack_rate_region,
                t1.rack_rate_plate                                                                       rack_rate_plate,
                t1.title                                                                                 title,
                t1.title_id                                                                              title_id,
                t1.goods_code                                                                            goods_code,
                t1.goods_pubtime                                                                         goods_pubtime,
                concat(t1.house_cnt,t1.hall_cnt,t1.bath_cnt)                                             rack_rate_layout,
                t1.rack_rate_area                                                                        rack_rate_area,
                case when t1.total_price like '%万%' then regexp_replace(t1.total_price, '万', '')
                     when t1.total_price like '%亿%' then cast(cast(regexp_replace(t1.total_price, '亿', '') as float ) * 10000 as String)
                     else t1.total_price end                                                              as total_price,
                t1.avg_price                                                                             avg_price,
                case when t1.rack_rate_property_type in ('墅','别') then '别墅'
                     when t1.rack_rate_property_type in ('公寓公寓') then '公寓'
                     when t1.rack_rate_property_type in ('普通宅','普住宅','通住宅','普通住') then '普通住宅'
                     when t1.rack_rate_property_type in ('业办公类','商办公类','商业公类','商业办公') then '商业办公类'
                     when t1.rack_rate_property_type in ('商住用','住两用','商两用','商住两') then '商住两用'
                     else t1.rack_rate_property_type end as                                               rack_rate_property_type,
                t1.rack_rate_build_form                                                                  rack_rate_build_form,
                t1.rack_rate_trading_rights                                                              rack_rate_trading_rights,
                t1.info_src                                                                              info_src,
                t1.batch_no                                                                              batch_no,
                t1.batch_time                                                                            batch_time,
                t1.total_floor                                                                           total_floor,
                case
                    when t1.floor_height in ('高层','顶','高楼','顶层','高楼层') then '高楼层'
                    when t1.floor_height in ('中楼','中层','中楼层') then '中楼层'
                    when t1.floor_height in ('低楼','底','低楼层','底层','低层') then '低楼层'
                    when t1.floor_height in ('地下室','地下','地室','下室') then '地下室'
                    else '' end as                                                                       floor_height,
                t1.pic                                                                                   pic,
                t1.pic_local                                                                             pic_local
from wrk_evaluation.community_evaluation_list_04 t1
where t1.title_id <>''
and t1.rack_rate_property_type not in ('车库','商务公寓','库','车','工业厂房','单身公寓住宅')
;

--数据清洗结束
----------------------------------------------------------------------

--补充区域板块 映射
----------------------------------------------------------------
insert overwrite table wrk_evaluation.community_evaluation_list_06
select
     t2.city_cd
    ,t1.city as city_name
    ,t2.district_cd
    ,coalesce(t2.district_name,t1.rack_rate_region) as district_name
    ,t2.block_cd
    ,coalesce(t2.block_name,t1.rack_rate_plate) as block_name
    ,t2.community_name as community_name
    ,t2.community_id as community_id
    ,t1.goods_code
    ,t1.goods_pubtime
    ,t1.rack_rate_layout
    ,t1.rack_rate_area
    ,t1.total_price
    ,t1.avg_price
    ,t1.rack_rate_property_type
    ,t1.rack_rate_build_form
    ,t1.rack_rate_trading_rights
    ,t1.info_src
    ,t1.batch_no
    ,t1.batch_time
    ,t1.total_floor
    ,t1.floor_height
    ,t1.pic
    ,t1.pic_local
    from wrk_evaluation.community_evaluation_list_05 t1
    inner join ods_house.ods_house_asset_community t2
        on t1.info_src = t2.info_src
    and t1.city = t2.city_name
    and t1.title_id = t2.source_community_id;

insert overwrite table wrk_evaluation.community_evaluation_list_07
select
     coalesce(t1.city_cd, cast (t2.city_cd as string)) as city_cd
    ,t1.city_name
    ,coalesce(t1.district_cd,cast(t3.district_cd as string),cast(t5.district_cd as string)) as district_cd
    ,t1.district_name
    ,coalesce(t1.block_cd,cast(t4.block_cd as string)) as block_cd
    ,t1.block_name
    ,t1.community_name
    ,t1.community_id
    ,t1.goods_code
    ,t1.goods_pubtime
    ,t1.rack_rate_layout
    ,t1.rack_rate_area
    ,t1.total_price
    ,t1.avg_price
    ,t1.rack_rate_property_type
    ,t1.rack_rate_build_form
    ,t1.rack_rate_trading_rights
    ,t1.info_src
    ,t1.batch_no
    ,t1.batch_time
    ,t1.total_floor
    ,t1.floor_height
    ,t1.pic
    ,t1.pic_local
from wrk_evaluation.community_evaluation_list_06 t1
left join dw_house.dw_city t2
    on t1.city_name = t2.city_name
left join dw_house.dw_district t3
    on t2.city_cd = t3.city_cd
    and t1.district_name = t3.district_name
left join dw_house.dw_district t5
    on t2.city_cd = t5.city_cd
    and t1.district_name = t5.short_district_name
left join dw_house.dw_block t4
    on t2.city_cd = t4.city_cd
    and t3.district_cd = t4.district_cd
    and t1.block_name = t4.block_name;

--区域板块补充结束
---------------------------

--调价时间计算,下架时间计算
-----------------------------------

--按日期排序
insert overwrite table wrk_evaluation.community_evaluation_list_08
select
      t1.city_cd
     ,t1.city_name
     ,t1.district_cd
     ,t1.district_name
     ,t1.block_cd
     ,t1.block_name
     ,t1.community_name
     ,t1.community_id
     ,t1.goods_code
     ,t1.goods_pubtime
     ,t1.rack_rate_layout
     ,t1.rack_rate_area
     ,t1.total_price
     ,t1.avg_price
     ,t1.rack_rate_property_type
     ,t1.rack_rate_build_form
     ,t1.rack_rate_trading_rights
     ,t1.info_src
     ,t1.batch_no
     ,t1.batch_time
     ,t1.total_floor
     ,t1.floor_height
     ,t1.pic
     ,t1.pic_local
     ,row_number() over (partition by t1.city_cd,t1.community_id,t1.goods_code order by t1.batch_time desc) as rn_desc
from wrk_evaluation.community_evaluation_list_07 t1;

--hive
insert overwrite table wrk_evaluation.community_evaluation_list_cleaned
SELECT  t1.city_cd
       ,t1.city_name
       ,t1.district_cd
       ,t1.district_name
       ,t1.block_cd
       ,t1.block_name
       ,t1.community_name
       ,t1.community_id
       ,t1.goods_code
       ,t1.goods_pubtime
       ,t1.rack_rate_layout
       ,t1.rack_rate_area
       ,t1.total_price
       ,t1.avg_price
       ,t1.rack_rate_property_type
       ,t1.rack_rate_build_form
       ,t1.rack_rate_trading_rights
       ,t1.info_src
       ,t1.batch_no
       ,t1.batch_time
       ,t1.total_floor
       ,t1.floor_height
       ,t1.pic
       ,t1.pic_local
       ,case when t1.pic is not null and t1.pic<>'' then split(regexp_extract(t1.pic,'(.*/)(.*)',2),'\\.')[0]
           else '' end as pic_key
       ,t1.rn_desc
       ,case when t1.rn_desc =1 and datediff(concat(from_unixtime(unix_timestamp(),'yyyy-MM'),'-01'),t1.batch_time)>30 then date_add(t1.batch_time,2)  --下架时间
           else '' end as goods_offtime
       ,t2.total_price as last_total_price    --上一次价格
       ,cast(cast(t1.total_price as decimal(10, 2)) -
             cast(t2.total_price as decimal(10, 2)) as string) as update_total_price
       ,case when cast(t1.total_price as decimal(10, 2)) - cast(t2.total_price as decimal(10, 2))>0 then t1.batch_time
           else '' end as update_batch_dt
FROM wrk_evaluation.community_evaluation_list_08 t1
left join wrk_evaluation.community_evaluation_list_08 t2
on t1.city_cd=t2.city_cd
    and t1.community_id=t2.community_id
    and t1.goods_code =t2.goods_code
    and t1.rn_desc = t2.rn_desc-1
;

insert overwrite table wrk_evaluation.shitu_huitu_all_ww_key
    select distinct  t3.frame_image_key,t3.jdj_url
    from (
        select t2.frame_image_key,t2.jdj_url,
               row_number()over(partition by frame_image_key order by jdj_url desc ) as rn
               from (
                        select case
                                   when t1.frame_image is not null and t1.frame_image <> ''
                                       then split(regexp_extract(t1.frame_image, '(.*/)(.*)', 2), '\\.')[0]
                                   else '' end as frame_image_key,
                               t1.jdj_url

                        from dm_house.dm_layout_draw_all t1
                    ) t2
    )t3
where t3.rn=1;







