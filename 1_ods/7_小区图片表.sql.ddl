CREATE TABLE case_esf.caishen_photo_for_tmall
(
    outer_id STRING COMMENT '二手房小区id',
    outer_picture_id STRING COMMENT '二手房图片id',
    outer_layout_id STRING COMMENT '二手房户型图id',
    order_tag   BIGINT COMMENT '排序字段',
    category_id BIGINT COMMENT '图片类型id',
    category STRING COMMENT '图片类型描述',
    pic_data STRING COMMENT '图片url',
    pic_data_source STRING COMMENT '图片来源',
    description STRING COMMENT '图片描述',
    pre_pic_md5 STRING COMMENT '原图图片MD5',
    is_test     INT COMMENT '是否测试数据',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间',
    ori_pic_data STRING COMMENT '图片url_org'
) COMMENT '小区图片数据'
    STORED AS TEXTFILE;