create table ods_evaluation.gaode_district_mapping
                       (
                           city_cd STRING,
                           city_name STRING,
                           district_cd STRING,
                           district_name STRING,
                           gaode_district_cd STRING,
                           gaode_district_name STRING
                       )COMMENT '资产高德区域mapping'
    STORED AS TEXTFILE;



select t1.*,concat(t2.gaode_lng,',',t2.gaode_lat) as  zichan_point
from ods_evaluation.gaode_district_mapping t1 left join

     asset_common.ods_house_asset_district t2
                                              on t1.district_cd = t2.district_cd
                                                      and t1.city_cd = t2.city_cd


select * from (
    select city_cd,
        disrict_cd,
        coordinate,
        row_number() over (partition by disrict_cd order by timestamp_v) as ranks
    from dw_evaluation.community_month_report_base_info
    where coordinate is not null
) t2 where t2.ranks = 1



select t1.*,
    case when concat(cast(t2.gaode_lng as STRING),',',cast(t2.gaode_lat as STRING)) is null then t3.coordinate else concat(cast(t2.gaode_lng as STRING),',',cast(t2.gaode_lat as STRING)) end as point,
    t2.gaode_fence
from ods_evaluation.gaode_district_mapping t1
         left join asset_common.ods_house_asset_district t2
                   on t1.district_cd = t2.district_cd
         left join
(
    select * from (
        select city_cd,
            district_cd,
            coordinate,
            row_number() over (partition by district_cd order by timestamp_v) as ranks
        from dw_evaluation.community_month_report_base_info
        where coordinate is not null
    ) t2 where t2.ranks = 1

) t3
on t1.district_cd = t3.district_cd