insert overwrite table ods_evaluation.community_evaluation_strategy
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
    case when split(t1.community_facilities,',')[9] like '%1%' then regexp_extract(split(t1.community_facilities,',')[9],'"(.*)":.*',1) else '' end as comm10
from ods_house.ods_pyspider_db_community_ke_strategy t1
where length(t1.head_strategy_resume) > 2
   or length(t1.head_strategy_title) > 2
   or length(t1.head_strategy_address) > 2
   or length(t1.head_average_price) > 2 ;







