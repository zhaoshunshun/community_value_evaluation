



truncate table dw_evaluation.community_evaluation_month_deal;
drop table dw_evaluation.community_evaluation_month_deal;
create table dw_evaluation.community_evaluation_month_deal as
insert overwrite table  dw_evaluation.community_evaluation_month_deal
select
    t3.community_id,
    t3.community_name,
    t3.community_addr,
    t3.city_cd,
    t3.city_name,
    t3.district_cd,
    t3.district_name,
    t3.block_cd,
    t3.block_name,
    t3.property_type,
    t2.trademoney deal_price,
    t2.tradearea as deal_area,
    t2.new_tradedate as deal_date,
    current_timestamp() as timestamp_v
    from ods_evaluation.cric_deal_detail t2
         left join ods_house.ods_house_asset_community t3
        on t2.citycaption = t3.city_name
        and case when t2.community_name = '控江' then t2.projectcaption else t2.community_name end = t3.community_name
            and t3.del_ind <> 1
            and t3.upper_lower_ind = 1
where t3.community_id is not null and t2.new_tradedate >= add_months(current_timestamp(),-13)

--excel上传
create table wrk_evaluation.community_evaluation_month_asset_cric_map
(
    citycaption STRING COMMENT '城市',
    region STRING COMMENT '区域',
    projectcaption STRING COMMENT '项目名称',
    community_name STRING COMMENT '小区名称',
    community_addr STRING COMMENT '小区地址',
    asset_community_id STRING COMMENT '资产小区id',
    asset_community_name STRING COMMENT '资产小区名称'
) COMMENT '小区月报-克而瑞与资产mapping表'
    STORED AS TEXTFILE;


--克而瑞小区
truncate table  wrk_evaluation.cric_deal_community;
drop table  wrk_evaluation.cric_deal_community;
create table wrk_evaluation.cric_deal_community
as
    insert overwrite table wrk_evaluation.cric_deal_community
    select * from (
        select itemid,
            citycaption,
            projectcaption,
            region,
            community_name,
            community_addr,
            row_number() over (partition by itemid order by citycaption,region,community_name desc, community_addr desc) as ranks
        from ods_evaluation.cric_deal_detail
    ) t1
where t1.ranks = 1

--规则匹配
create table wrk_evaluation.community_evaluation_month_asset_cric_map_result
as
    insert overwrite table wrk_evaluation.community_evaluation_month_asset_cric_map_result
    select
        t1.itemid,
        t1.citycaption,
        t1.region,
        t1.community_name,
        t1.community_addr,
        t2.community_id as asset_community_id,
        t2.city_name as asset_city_name,
        t2.district_name as asset_district_name,
        t2.community_name as asset_community_name,
        t2.community_addr as asset_community_addr
from wrk_evaluation.cric_deal_community t1
left join ods_house.ods_house_asset_community t2
    on t1.citycaption = t2.city_name
    and case when t1.community_name = '控江' then t1.projectcaption else t1.community_name end = t2.community_name
    and t2.del_ind <> 1
    and t2.upper_lower_ind = 1
where t2.community_id is not null


--人工mapping结果补充
insert into  wrk_evaluation.community_evaluation_month_asset_cric_map_result
select
t3.itemid,
t3.citycaption,
t3.region,
t3.community_name,
t3.community_addr,
t2.community_id as asset_community_id,
t2.city_name as asset_city_name,
t2.district_name as asset_district_name,
t2.community_name as asset_community_name,
t2.community_addr as asset_community_addr
from  wrk_evaluation.community_evaluation_month_asset_cric_map t1
    inner join wrk_evaluation.cric_deal_community t3
    on t1.citycaption = t3.citycaption
    and t1.region = t3.region
    and t1.community_name = t3.community_name
inner join  ods_house.ods_house_asset_community t2
on t1.asset_community_id = t2.community_id
where  t1.asset_community_id is not null




48754
4719



select * from (
    select
        *,row_number() over(partition by community_name order by developer desc) as ranks
    from
        (
            select
                distinct
                t2.citycaption,
                t2.region,
                t2.projectcaption,
                t2.developer,
                case when t2.community_name = '控江' then t2.projectcaption else t2.community_name end as community_name,
                t2.community_addr
            from ods_evaluation.cric_deal_detail  t2
                     inner join(
                select distinct
                    t2.citycaption,
                    case when t2.community_name = '控江' then t2.projectcaption else t2.community_name end as community_name
                from ods_evaluation.cric_deal_detail t2
                         left join ods_house.ods_house_asset_community t3
                                   on t2.citycaption = t3.city_name
                                       and case when t2.community_name = '控江' then t2.projectcaption else t2.community_name end = t3.community_name
                                       and t3.del_ind <> 1
                                       and t3.upper_lower_ind = 1
                where t3.community_id is null
            ) t3
                               on t2.citycaption = t3.citycaption
                                   and  case when t2.community_name = '控江' then t2.projectcaption else t2.community_name end = t3.community_name
        ) t4
) t5 where t5.ranks = 1

