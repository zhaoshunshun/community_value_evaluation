
truncate table dm_evaluation.community_evaluation_md5_map;
drop table dm_evaluation.community_evaluation_md5_map;
create table dm_evaluation.community_evaluation_md5_map as
select
    cast(t2.community_id as STRING) as community_id,
    t1.code_md5 as community_md5,
    t1.rd,
    t1.channel
from dm_house.dm_md5_map t1
inner join ods_house.ods_house_asset_community t2
    on t1.code = community_no
    and t1.name='community_no'
    and t1.channel='LEJU';