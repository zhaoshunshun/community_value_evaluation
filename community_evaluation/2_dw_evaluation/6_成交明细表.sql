
--成交数据
# truncate table dw_evaluation.community_evaluation_deal_detail;
# drop table dw_evaluation.community_evaluation_deal_detail;
# create table dw_evaluation.community_evaluation_deal_detail as
insert overwrite table dw_evaluation.community_evaluation_deal_detail
select
      t1.outer_deal_id as goods_id
     ,t1.s_source
     ,t1.city_cd as city_cd
     ,t1.city_name as city_name
     ,t1.community_id as community_id
     ,t1.community_name as community_name
     ,t1.deal_date as deal_time
     ,t1.unit_price as deal_average_price
     ,t1.total_price as deal_price
     ,t1.community_layout  as layout
     ,t1.area as area
     ,t3.s_layout_draw_url as jdj_url
from
     (
         select  t1.*,t3.city_cd,t2.community_id,'BK' as s_source,t2.city_name
         from ods_evaluation.bk_deal_detail t1
             inner join case_esf.community_source_map t2
             on t1.city = t2.city_name
             and t1.community_name = t2.community_name
             and t2.source_info_src = 'BK'
                  left join asset_common.ods_house_asset_city t3
                    on t2.city_name = t3.city_name
         where t3.del_ind =0
         ) t1
left join eju_dwd.dwd_house_layout_info t3
          on t1.city_cd= t3.s_city_cd
              and t1.outer_deal_id = t3.s_goods_id
where t1.city_name in  ('上海','郑州','重庆','南京','武汉','杭州','西安','合肥','天津','无锡','沈阳','济南','青岛','成都','贵阳','南宁','厦门','东莞','苏州','广州','深圳','昆明','哈尔滨','太原','福州','宁波','南昌','长春','长沙','兰州','扬州','盐城','石家庄','中山','银川','徐州','海口','惠州','北京','佛山')
;

# truncate table dw_evaluation.community_evaluation_deal;
# drop table dw_evaluation.community_evaluation_deal;
# create table dw_evaluation.community_evaluation_deal as
insert overwrite table dw_evaluation.community_evaluation_deal
select  t1.city_cd,
        t1.city_name,
        t1.community_id,
        t1.community_name,
        t1.layout,
        max(t1.area)       as max_area,
        min(t1.area)       as min_area,
        avg(t1.area)       as avg_area,
        max(t1.deal_price) as max_deal_price,
        min(t1.deal_price) as min_deal_price,
        avg(t1.deal_price) as avg_deal_price,
        max(t1.jdj_url)    as jdj_url,
        count(1)           as cnt,
        row_number() over (partition by t1.city_cd,t1.city_name,t1.community_id order by count(1) desc,max(t1.jdj_url) desc) as ranks
from dw_evaluation.community_evaluation_deal_detail t1
where t1.deal_time >= add_months(current_timestamp(),-6)
group by t1.city_cd,
         t1.city_name,
         t1.community_id,
         t1.community_name,
         t1.layout;
