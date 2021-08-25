
truncate table ods_evaluation.community_room_rack_detail
drop table ods_evaluation.community_room_rack_detail
create table ods_evaluation.community_room_rack_detail
    as
    insert overwrite table ods_evaluation.community_room_rack_detail
select
    t1.s_goods_id,
    t1.s_batch_dt,
    t1.i_community_id as community_id,
    t1.d_rack_average_price,
    current_timestamp() as timestamp_v
from eju_dwd.dwd_event_rack_detail t1
where t1.s_batch_dt >= add_months(current_timestamp(),-24)
and t1.i_community_id is not null
and t1.d_rack_average_price is not null