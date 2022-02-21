--利用挂牌url表wrk_evaluation.stg_rack_20201013_step36_zxy补成交的url
--使用挂牌的户型图补充成交
--房源粒度的成交数据
insert overwrite table dw_evaluation.community_evaluation_deal_detail
SELECT t3.city_name,
       t3.city_cd,
       t3.district_name,
       t3.district_cd,
       t3.block_name,
       t3.block_cd,
       t3.community_name,
       t3.community_id,
       t3.goods_id,
       t3.deal_time,
       t3.layout,
       t3.area,
       t3.deal_price,
       t3.deal_average_price,
       t3.property_type,
       coalesce(t3.jdj_url,t4.jdj_url) as jdj_url,
       t3.frame_image
FROM wrk_evaluation.community_evaluation_deal_cleaned t3
         LEFT JOIN (select t2.city_cd, t2.community_id, t2.goods_code, t2.jdj_url
                    from (select t1.*,
                                 row_number()
                                 over (partition by t1.city_cd,t1.community_id,t1.goods_code order by t1.jdj_url asc) as rn
                          from dw_evaluation.community_evaluation_list_month_detail t1
                          where t1.jdj_url is not null
                            and trim(t1.jdj_url) <> '') t2
                    where t2.rn = 1
                    ) t4
                   ON t3.city_cd = t4.city_cd
                       AND t3.community_id = t4.community_id
                       AND t3.goods_id = t4.goods_code;

--小区户型粒度的成交数据
insert overwrite table dw_evaluation.community_evaluation_deal
    select  t1.city_name,
            t1.city_cd,
            t1.district_name,
            t1.district_cd,
            t1.block_name,
            t1.block_cd,
            t1.community_name,
            t1.community_id,
            t1.layout,
            max(t1.area)       as max_area,
            min(t1.area)       as min_area,
            avg(t1.area)       as avg_area,
            max(t1.deal_price) as max_deal_price,
            min(t1.deal_price) as min_deal_price,
            avg(t1.deal_price) as avg_deal_price,
            max(t1.jdj_url)    as jdj_url,
            count(1)           as cnt,
            row_number() over (partition by t1.city_name,t1.community_name,t1.community_id order by count(1) desc,max(t1.jdj_url) desc) as ranks
     from dw_evaluation.community_evaluation_deal_detail t1
     where t1.deal_time >= add_months(current_timestamp(),-6)
     group by t1.city_name,
              t1.city_cd,
              t1.district_name,
              t1.district_cd,
              t1.block_name,
              t1.block_cd,
              t1.community_name,
              t1.community_id,
              t1.layout;


