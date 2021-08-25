

truncate table dw_evaluation.community_evaluation_community_school_map;
drop table dw_evaluation.community_evaluation_community_school_map;
create table dw_evaluation.community_evaluation_community_school_map as
    insert overwrite table dw_evaluation.community_evaluation_community_school_map
select * from (
                  select
                        t1.community_id,
                        t1.community_name,
                        t2.school_id,
                        t2.school_name,
                        t2.school_fance,
                        t2.coordinate as school_coordinate,
                        t2.enrollment_nums,
                        t2.school_desc,
                        t2.school_addr,
                        t2.school_enrollment_target,
                        t2.school_fee,
                        t2.school_type,
                        t2.school_segment_grade,
                        t2.school_characteristics,
                        t2.school_scope_road,
                        udf.pointdistance(t1.coordinate, t2.coordinate)  as community_school_distince,
                      row_number()
                      over (partition by t1.community_id order by udf.pointdistance(t1.coordinate, t2.coordinate) asc)      as ranks
                  from dw_evaluation.community_month_report_base_info t1
                       left join ods_evaluation.community_evaluation_month_shangnaxue t2
                       on t1.city_name = t2.city_name

              ) t3 where t3.community_school_distince <=3000