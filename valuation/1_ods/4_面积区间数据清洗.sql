create table ods_evaluation.house_valuation_bk_interval
as
select
    id,
    city_name,
    bk_interval,
    case when bk_interval like '%下%' then 0
         when bk_interval like '%上%' then regexp_replace(regexp_replace(bk_interval, '[\\u4e00-\\u9fa5]', ''),'㎡','')
         else split(bk_interval,'-')[0] end as min_interval,
    case when bk_interval like '%下%' then regexp_replace(regexp_replace(bk_interval, '[\\u4e00-\\u9fa5]', ''),'㎡','')
         when bk_interval like '%上%' then 100000
         else regexp_replace(split(bk_interval,'-')[1],'㎡','') end as max_interval
from ods_evaluation.ods_pyspider_db_beike_interval