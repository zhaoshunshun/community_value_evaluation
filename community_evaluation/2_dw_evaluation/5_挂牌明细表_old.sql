
--所有房源明细
insert overwrite table  dw_evaluation.community_evaluation_list_detail
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
     ,t1.pic_key
     ,t1.rn_desc
     ,t1.goods_offtime
     ,t1.last_total_price
     ,t1.update_total_price
     ,t1.update_batch_dt
     ,t2.jdj_url
from wrk_evaluation.community_evaluation_list_cleaned t1
         left join wrk_evaluation.shitu_huitu_all_ww_key t2
                   on t1.pic_key = t2.frame_image_key
;




--每个房源每月保留一条数据
insert overwrite table dw_evaluation.community_evaluation_list_month_detail
select *,row_number() over (partition by city_cd,city_name,community_id,community_name,goods_code order by substring(batch_time,1,7) desc) as ranks_1
from (
         select *,
                row_number() over (partition by city_cd,city_name,community_id,community_name,goods_code,substring(batch_time,1,7) order by batch_time desc)  as ranks
         from dw_evaluation.community_evaluation_list_detail t1 where batch_time >= add_months(current_timestamp(),-18)
     ) t2 where ranks =1;
