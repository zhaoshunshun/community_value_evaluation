
truncate table ods_evaluation.community_evaluation_month_shangnaxue;
drop table ods_evaluation.community_evaluation_month_shangnaxue;
create table ods_evaluation.community_evaluation_month_shangnaxue
as
insert overwrite table ods_evaluation.community_evaluation_month_shangnaxue
select
    t2.school_id,
    t2.city_name,
    t2.district_name,
    t2.coordinate,
    t2.school_desc,
    t2.school_scope_road,
    t2.school_enrollment_target,
    t2.school_addr,
    t2.school_name,
    t2.school_type,
    t2.enrollment_nums,
    t2.school_fance,
    t2.school_segment_grade,
    t2.school_fee,
    t2.school_characteristics,
    current_timestamp() as timestamp_v
from (
    select
        t1.school_id,
        t1.city as city_name,
        t1.area_name as district_name,
        concat(t1.longitude,',',t1.latitude) as coordinate,
        t1.characteristic as school_desc,
        t1.enrollment_area as school_scope_road,
        t1.enrollment_target as school_enrollment_target,
        t1.address as school_addr,
        t1.name as school_name,
        t1.nature_name as school_type,
        t1.enrollment_planning as enrollment_nums,
        t1.border_gd as school_fance,
        t1.segment_grade_name as school_segment_grade,
        t1.tuition_content as school_fee,
        t1.characteristics as school_characteristics,
            row_number() over (partition by t1.school_id order by t1.dt asc)  as ranks
        from ods_house.ods_shangnaxue_school  t1
    where t1.segment_grade_name <> '托育园'
    )  t2
where t2.ranks =1



