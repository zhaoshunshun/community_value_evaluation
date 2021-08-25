



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

