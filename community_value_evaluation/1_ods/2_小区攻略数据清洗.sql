insert overwrite table ods_evaluation.community_evaluation_month_strategy
select
    t1.title_id,
    t1.title,
    t1.city,
    case when split(t1.community_facilities,',')[0] like '%1%' then regexp_extract(split(t1.community_facilities,',')[0],'"(.*)":.*',1) else '' end as comm1,
    case when split(t1.community_facilities,',')[1] like '%1%' then regexp_extract(split(t1.community_facilities,',')[1],'"(.*)":.*',1) else '' end as comm2,
    case when split(t1.community_facilities,',')[2] like '%1%' then regexp_extract(split(t1.community_facilities,',')[2],'"(.*)":.*',1) else '' end as comm3,
    case when split(t1.community_facilities,',')[3] like '%1%' then regexp_extract(split(t1.community_facilities,',')[3],'"(.*)":.*',1) else '' end as comm4,
    case when split(t1.community_facilities,',')[4] like '%1%' then regexp_extract(split(t1.community_facilities,',')[4],'"(.*)":.*',1) else '' end as comm5,
    case when split(t1.community_facilities,',')[5] like '%1%' then regexp_extract(split(t1.community_facilities,',')[5],'"(.*)":.*',1) else '' end as comm6,
    case when split(t1.community_facilities,',')[6] like '%1%' then regexp_extract(split(t1.community_facilities,',')[6],'"(.*)":.*',1) else '' end as comm7,
    case when split(t1.community_facilities,',')[7] like '%1%' then regexp_extract(split(t1.community_facilities,',')[7],'"(.*)":.*',1) else '' end as comm8,
    case when split(t1.community_facilities,',')[8] like '%1%' then regexp_extract(split(t1.community_facilities,',')[8],'"(.*)":.*',1) else '' end as comm9,
    case when split(t1.community_facilities,',')[9] like '%1%' then regexp_extract(split(t1.community_facilities,',')[9],'"(.*)":.*',1) else '' end as comm10,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.head_strategy_desc,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as community_desc,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.resident_population,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as live_population,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.community_atmosphere,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as atmosphere,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.property_service,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as property_services,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.park,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as parking_conditions,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.beike_score_merit,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as advantage,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.beike_score_weakness,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as shortcoming,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.proprietor_speak,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as proprietor_speak,
    regexp_replace(regexp_replace(regexp_replace(regexp_replace(t1.internal_matching,'<[^>]*>',''),'&nbsp;',''),'[a-z0-9]+.(jpg|PNG|png|JPG)',''),'（[^）]*）','') as facilities_desc,
    current_timestamp() as timestamp_v
from (
    select *, row_number() over (partition by title_id order by create_time desc) as ranks
    from ods_house.ods_pyspider_db_community_ke_strategy
) t1
where (length(t1.head_strategy_resume) > 2
   or length(t1.head_strategy_title) > 2
   or length(t1.head_strategy_address) > 2
   or length(t1.head_average_price) > 2 )
and t1.ranks = 1
;



