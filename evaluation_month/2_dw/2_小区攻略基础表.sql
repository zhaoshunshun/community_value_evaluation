
truncate table dw_evaluation.community_evaluation_bk_month_strategy;
drop table dw_evaluation.community_evaluation_bk_month_strategy;
create table dw_evaluation.community_evaluation_bk_month_strategy as

insert overwrite table dw_evaluation.community_evaluation_bk_month_strategy
select
    distinct
    t3.community_id as community_id,
    t3.community_name as community_name,
    t3.city_cd as city_id,
    t3.city_name as city_name,
    t3.district_cd as district_id,
    t3.district_name as district_name,
    t3.block_cd as block_id,
    t3.block_name as block_name,
    case when
                 regexp_extract(regexp_replace(concat_ws(',',t2.comm1,t2.comm2,t2.comm3,t2.comm4,t2.comm5,t2.comm6,t2.comm7,t2.comm8,t2.comm9,t2.comm10),'[,]+',','),'(,)?(.*)',2) like '%,'
             then
             regexp_extract(regexp_replace(concat_ws(',',t2.comm1,t2.comm2,t2.comm3,t2.comm4,t2.comm5,t2.comm6,t2.comm7,t2.comm8,t2.comm9,t2.comm10),'[,]+',','),'(,)?(.*),',2)
         else
             regexp_extract(regexp_replace(concat_ws(',',t2.comm1,t2.comm2,t2.comm3,t2.comm4,t2.comm5,t2.comm6,t2.comm7,t2.comm8,t2.comm9,t2.comm10),'[,]+',','),'(,)?(.*)',2)
        end as facilities,
    t2.community_desc,
    t2.live_population,
    t2.atmosphere,
    t2.property_services,
    t2.parking_conditions,
    t2.advantage,
    t2.shortcoming,
    t2.proprietor_speak,
    t2.facilities_desc,
    current_timestamp() as timestamp_v
from ods_evaluation.community_evaluation_month_strategy  t2
         left join ods_house.ods_house_hub_community_map t4
                   on t2.title_id = t4.source_community_id
                       and t4.check_status = 1
                       and t4.info_src='BK'
         inner join ods_house.ods_house_asset_community t3
                   on t4.community_no = t3.community_no
                       and t3.del_ind <> 1
                       and t3.upper_lower_ind = 1


