insert overwrite table dw_evaluation.community_evaluation_month_layout
    select
        t3.community_id,
        t3.community_name,
        t3.city_cd,
        t3.city_name,
        max(t3.layout_1_cnt) as layout_1_cnt,
        max(t3.layout_2_cnt) as layout_2_cnt,
        max(t3.layout_3_cnt) as layout_3_cnt,
        max(t3.layout_4_cnt) as layout_4_cnt,
        max(t3.layout_other_cnt) as layout_other_cnt,
        sum(t3.community_house_cnt) as community_house_cnt,
        max(t3.build_area_min_1) as build_area_min_1,
        max(t3.build_area_max_1) as build_area_max_1,
        max(t3.build_area_min_2) as build_area_min_2,
        max(t3.build_area_max_2) as build_area_max_2,
        max(t3.build_area_min_3) as build_area_min_3,
        max(t3.build_area_max_3) as build_area_max_3,
        max(t3.build_area_min_4) as build_area_min_4,
        max(t3.build_area_max_4) as build_area_max_4,
        max(t3.build_area_min_other) as build_area_min_other,
        max(t3.build_area_max_other) as build_area_max_other,
        max(t3.main_layout) as main_layout,
        max(t3.main_area_min) as main_area_min,
        max(t3.main_area_max) as main_area_max,
        max(t3.second_layout) as second_layout,
        max(t3.second_area_min) as second_area_min,
        max(t3.second_area_max) as second_area_max,
        case when max(t3.second_layout) = max(t3.last_layout) or max(t3.main_layout) = max(t3.last_layout) then '' else max(t3.last_layout) end as last_layout,
        current_timestamp as timestamp_v
from (

    select t2.community_id,
           t2.community_name,
           t2.city_cd,
           t2.city_name,
           t2.house_cnt,
           t2.layout_1_cnt,
           t2.layout_2_cnt,
           t2.layout_3_cnt,
           t2.layout_4_cnt,
           t2.layout_other_cnt,
           t2.community_house_cnt,
           t2.build_area_min_1,
           t2.build_area_max_1,
           t2.build_area_min_2,
           t2.build_area_max_2,
           t2.build_area_min_3,
           t2.build_area_max_3,
           t2.build_area_min_4,
           t2.build_area_max_4,
           t2.build_area_min_other,
           t2.build_area_max_other,
           case when t2.house_cnt_rank_desc = 1 then t2.house_cnt else '' end as main_layout,
           case when t2.house_cnt_rank_desc = 1 then coalesce(t2.build_area_min_1,t2.build_area_min_2,t2.build_area_min_3,t2.build_area_min_4,t2.build_area_min_other) else null end as main_area_min,
           case when t2.house_cnt_rank_desc = 1 then coalesce(t2.build_area_max_1,t2.build_area_max_2,t2.build_area_max_3,t2.build_area_max_4,t2.build_area_max_other) else null end as main_area_max,
           case when t2.house_cnt_rank_desc = 2 then t2.house_cnt else '' end as second_layout,
           case when t2.house_cnt_rank_desc = 2 then coalesce(t2.build_area_min_1,t2.build_area_min_2,t2.build_area_min_3,t2.build_area_min_4,t2.build_area_min_other) else null end as second_area_min,
           case when t2.house_cnt_rank_desc = 2 then coalesce(t2.build_area_max_1,t2.build_area_max_2,t2.build_area_max_3,t2.build_area_max_4,t2.build_area_max_other) else null end as second_area_max,
           case when t2.house_cnt_rank_asc = 1 then t2.house_cnt else '' end as last_layout
    from (
                      select t2.community_id,
                             t2.community_name,
                             t1.city_cd,
                             t1.city_name,
                             case when t1.house_cnt not in ('1室', '2室', '3室', '4室') then '其他' else t1.house_cnt end as house_cnt,
                             sum(case when t1.house_cnt = '1室' then 1 else 0 end) as                                        layout_1_cnt,
                             sum(case when t1.house_cnt = '2室' then 1 else 0 end) as                                        layout_2_cnt,
                             sum(case when t1.house_cnt = '3室' then 1 else 0 end) as                                        layout_3_cnt,
                             sum(case when t1.house_cnt = '4室' then 1 else 0 end) as                                        layout_4_cnt,
                             sum(
                                    case when t1.house_cnt not in ('1室', '2室', '3室', '4室') then 1 else 0 end) as         layout_other_cnt,
                             count(t1.house_layout_no) as                                                                    community_house_cnt,
                             min(case when t1.house_cnt = '1室' then t1.build_area else null end) as                         build_area_min_1,
                             max(case when t1.house_cnt = '1室' then t1.build_area else null end) as                         build_area_max_1,
                             min(case when t1.house_cnt = '2室' then t1.build_area else null end) as                         build_area_min_2,
                             max(case when t1.house_cnt = '2室' then t1.build_area else null end) as                         build_area_max_2,
                             min(case when t1.house_cnt = '3室' then t1.build_area else null end) as                         build_area_min_3,
                             max(case when t1.house_cnt = '3室' then t1.build_area else null end) as                         build_area_max_3,
                             min(case when t1.house_cnt = '4室' then t1.build_area else null end) as                         build_area_min_4,
                             max(case when t1.house_cnt = '4室' then t1.build_area else null end) as                         build_area_max_4,
                             min(case
                                     when t1.house_cnt not in ('1室', '2室', '3室', '4室') then t1.build_area
                                     else null end) as                                                                      build_area_min_other,
                             max(case
                                     when t1.house_cnt not in ('1室', '2室', '3室', '4室') then t1.build_area
                                     else null end) as                                                                      build_area_max_other,
                             row_number()
                             over (partition by t2.community_id, t2.community_name, t1.city_cd, t1.city_name order by count(t1.house_layout_no) desc) as house_cnt_rank_desc,
                             row_number()
                             over (partition by t2.community_id, t2.community_name, t1.city_cd, t1.city_name order by count(t1.house_layout_no) asc) as house_cnt_rank_asc

                      from ods_evaluation.community_evaluation_layout t1
                               left join ods_house.ods_house_hub_community_map t4
                                         on t1.source_community_id = t4.source_community_id
                                             and t4.check_status = 1
                                             and t4.info_src in ('BK','BK_XF')
                      inner join ods_house.ods_house_asset_community t2
                      on t4.community_no = t2.community_no
                      and t1.city_name=t2.city_name
                      and t2.del_ind <> 1
                      and t2.upper_lower_ind = 1
                      group by t2.community_id, t2.community_name, t1.city_cd, t1.city_name,(case when t1.house_cnt not in ('1室', '2室', '3室', '4室') then '其他' else t1.house_cnt end)
                  ) t2
     ) t3
group by t3.community_id, t3.community_name, t3.city_cd, t3.city_name;
