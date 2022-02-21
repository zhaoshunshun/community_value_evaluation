insert overwrite table dw_evaluation.community_evaluation_school
select distinct cast(t4.community_id as STRING)   as community_id,
                t4.community_name                 as community_name,
                t4.city_cd                        as city_id,
                t4.city_name                      as city_name,
                t4.district_cd                    as district_id,
                t4.district_name                  as district_name,
                t4.block_cd                       as block_id,
                t4.block_name                     as block_name,
                t1.school_name                    as school_name,
                t1.further_studies                as counterpart_school,
                split(t1.school_tag, '|')[0] as school_stage,
                case
                    when t1.school_tag like '%重点%'
                        or t1.school_tag like '%市实验%'
                        or t1.school_tag like '%省实验%' then '重点小学'
                    else '非重点小学' end              as school_level,
                case
                    when t1.school_tag like '%公立%' then '公立'
                    when t1.school_tag like '%私立%' then '私立'
                    else '' end                   as school_type,
                t1.school_gd_location             as school_gd_location,
                t1.title_school_distance          as community_school_distince,
                current_timestamp()               as timestamp_v
from ods_evaluation.community_evaluation_school t1
         left join ods_house.ods_house_hub_community_map t2
         on t1.title_id = t2.source_community_id
                and t2.check_status = 1
                and t2.info_src='SF'
         inner join ods_house.ods_house_asset_community t4
                   on t2.community_no = t4.community_no
                       and t4.del_ind <> 1
                       and t4.upper_lower_ind = 1