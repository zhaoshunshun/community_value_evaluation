
# truncate table dw_evaluation.community_evaluation_list_month_detail_01;
# drop table dw_evaluation.community_evaluation_list_month_detail_01;
# create table dw_evaluation.community_evaluation_list_month_detail_01 as
#
insert overwrite table dw_evaluation.community_evaluation_list_month_detail_01
    select *
           from (
                  select
                      *
                    ,row_number() over (partition by t1.s_city_cd,t1.i_community_id,t1.s_goods_id,substring(t1.s_batch_dt,1,7) order by t1.s_batch_dt desc)  as ranks
                  from eju_dwd.dwd_event_rack_detail t1
                  where t1.s_batch_dt >= add_months(current_timestamp(),-18)
                      ) t2  where t2.ranks =1;


create table eju_dwd.dwd_house_layout_info_tmp01 as
insert overwrite table eju_dwd.dwd_house_layout_info_tmp01
select s_info_src,
       s_goods_id,
       s_layout_draw_url,
       s_city_cd,
       row_number() over(partition by s_goods_id order by s_layout_draw_url desc) as ranks
from eju_dwd.dwd_house_layout_info;


# truncate table dw_evaluation.community_evaluation_list_month_detail;
# drop table dw_evaluation.community_evaluation_list_month_detail;
# create table dw_evaluation.community_evaluation_list_month_detail as
insert overwrite table dw_evaluation.community_evaluation_list_month_detail
select
    t1.s_goods_id as goods_code
    ,t1.s_source as info_src
    ,t1.s_city_cd as city_cd
    ,t4.city_name as city_name
    ,t1.i_community_id as community_id
    ,t4.community_name as community_name
    ,t1.d_rack_price as total_price
    ,t1.d_rack_average_price as avg_price
    ,regexp_replace(t5.s_house_structure,'\\d+[厨]','') as rack_rate_layout
    ,t5.d_floor_space as rack_rate_area
    ,t2.s_layout_draw_url as jdj_url
    ,t1.s_batch_dt as batch_time
from dw_evaluation.community_evaluation_list_month_detail_01 t1
left join eju_dwd.dwd_house_layout_info t2
    on t1.s_city_cd= t2.s_city_cd
    and t1.s_source=t2.s_info_src
    and t1.s_goods_id = t2.s_goods_id
    and t2.ranks=1
inner join ods_house.ods_house_asset_community t4
    on t1.i_community_id = t4.community_id
    and t1.s_city_cd = t4.city_cd
left join eju_dwd.dwd_house_base_info t5
    on t1.s_city_cd= t5.s_city_cd
    and t1.s_source=t5.s_info_src
    and t1.s_goods_id = t5.s_goods_id

where t1.s_batch_dt >= add_months(current_timestamp(),-18)
  and t4.del_ind <> 1
  and t4.upper_lower_ind = 1
  and t4.city_name in  ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都','贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春','长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
;



