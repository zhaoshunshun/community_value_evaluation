create table dw_evaluation.community_evaluation_month_pic
as
    insert overwrite tabble dw_evaluation.community_evaluation_month_pic
    select
           t1.outer_id as community_id,
           t1.outer_picture_id as community_picture_id,
           t1.outer_layout_id as community_layout_id,
           t1.order_tag as order_tag,
           t1.category_id as category_id,
           t1.category as category,
           t1.pic_data as pic_data,
           t1.pic_data_source as pic_data_source,
           t1.description as description,
           t1.pre_pic_md5 as pre_pic_md5,
           current_timestamp() as timestamp_v
from case_esf.caishen_photo_for_tmall t1
    where t1.outer_picture_id not like 'man%'