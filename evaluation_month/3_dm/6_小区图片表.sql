insert overwrite table dm_evaluation.community_month_report_pic
select
    t1.community_id,
    t1.community_picture_id,
    t1.community_layout_id,
    t1.order_tag,
    t1.category_id,
    t1.category,
    t1.pic_data,
    t1.pic_data_source,
    t1.description,
    t1.pre_pic_md5,
    substring(add_months(current_timestamp(),-1),1,7) as batch_no,    --批次号
    current_timestamp() as timestamp_v          --数据处理时间
    from dw_evaluation.community_evaluation_month_pic t1