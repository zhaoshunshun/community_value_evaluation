insert overwrite table ods_evaluation.community_evaluation_school
select t1.city,
       t1.school_name,
       t2.title_id,
       t1.school_tag,
       t1.further_studies,
       t1.school_gd_location,
       t2.title_school_distance
from (select city,
             school_name,
             school_tag,
             further_studies,
             school_gd_location,
             row_number() over (partition by city,school_name order by dt desc) as ranks
      from ods_house.ods_house_community_school_info
     ) t1
         left join
     (select city,
             school_name,
             title_id,
             title_school_distance,
             row_number() over (partition by city,title_id order by dt desc) as ranks
      from ods_house.ods_house_community_school_ref_info
     ) t2
     on t1.school_name = t2.school_name
         and t1.city = t2.city
where t1.ranks = 1
  and t2.ranks = 1;
