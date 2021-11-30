



truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_01;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_01;
create table dw_evaluation.house_valuation_analysis_same_community_sensitive_01
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_01
select id,
       city,
       region,
       title,
       get_json_object(youqizhan1, '$.gps') as youqizhan,     --点
       get_json_object(youqizhan1, '$.title') as name
from (SELECT id,city,region,title,youqizhan1
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.youqizhan, '\\[|\\]',''),'\\}\\,\\{','\\}\\;\\{'),'\\;')) ss as youqizhan1
     ) test

truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_02;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_02;
create table dw_evaluation.house_valuation_analysis_same_community_sensitive_02
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_02
select id,
       city,
       region,
       title,
       get_json_object(gaoyaxian1, '$.gps') as gaoyaxian,     --线
       get_json_object(gaoyaxian1, '$.title') as name
from (SELECT id,city,region,title,gaoyaxian1,t1.gaoyaxian
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.gaoyaxian, '\\[|\\]',''),'\\}\\,\\{','\\}\\$\\{'),'\\$')) ss as gaoyaxian1
     ) test


truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_03;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_03;

create table dw_evaluation.house_valuation_analysis_same_community_sensitive_03
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_03
select id,city,region,title,
       get_json_object(xiongzhai1, '$.time') as xiongzhai,
       get_json_object(xiongzhai1, '$.desc') as name
       --无坐标
from (SELECT id,city,region,title,xiongzhai1
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.xiongzhai, '\\[|\\]',''),'\\}\\,\\{','\\}\\;\\{'),'\\;')) ss as xiongzhai1
     ) test

truncate table  dw_evaluation.house_valuation_analysis_same_community_sensitive_04;
drop table  dw_evaluation.house_valuation_analysis_same_community_sensitive_04;
create table dw_evaluation.house_valuation_analysis_same_community_sensitive_04
as
insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_04
select id,city,region,title,
       get_json_object(choushuihe1, '$.gps') as choushuihe,
       get_json_object(choushuihe1, '$.title') as name
       --围栏
from (SELECT id,city,region,title,choushuihe1
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.choushuihe, '\\[|\\]',''),'\\}\\,\\{','\\}\\$\\{'),'\\$')) ss as choushuihe1
     ) test

truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_05;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_05;
create table dw_evaluation.house_valuation_analysis_same_community_sensitive_05
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_05
select id,city,region,title,
       get_json_object(gaojia1, '$.gps') as gaojia,
       get_json_object(gaojia1, '$.title') as name
       --点
from (SELECT id,city,region,title,gaojia1
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.gaojia, '\\[|\\]',''),'\\}\\,\\{','\\}\\;\\{'),'\\;')) ss as gaojia1
     ) test

truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_06;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_06;
create table dw_evaluation.house_valuation_analysis_same_community_sensitive_06
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_06
select id,city,region,title,
       get_json_object(wuran1, '$.pgp') as wuran,
       get_json_object(wuran1, '$.title') as name
       --点
from (SELECT id,city,region,title,wuran1
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.wuran, '\\[|\\]',''),'\\}\\,\\{','\\}\\;\\{'),'\\;')) ss as wuran1
     ) test

truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_07;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_07;
create table dw_evaluation.house_valuation_analysis_same_community_sensitive_07
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_07
select id,city,region,title,
       get_json_object(mudi1, '$.point') as mudi,
       get_json_object(mudi1, '$.title') as name
       --点
from (SELECT id,city,region,title,mudi1
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.mudi, '\\[|\\]',''),'\\}\\,\\{','\\}\\$\\{'),'\\$')) ss as mudi1
     ) test

truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_08;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_08;
create table dw_evaluation.house_valuation_analysis_same_community_sensitive_08
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_08
select id,city,region,title,
       get_json_object(buli1, '$.point') as buli,
       get_json_object(buli1, '$.title') as name
       --点
from (SELECT id,city,region,title,buli1
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.buli, '\\[|\\]',''),'\\}\\,\\{','\\}\\$\\{'),'\\$')) ss as buli1
     ) test

truncate table dw_evaluation.house_valuation_analysis_same_community_sensitive_09;
drop table dw_evaluation.house_valuation_analysis_same_community_sensitive_09;
create table  dw_evaluation.house_valuation_analysis_same_community_sensitive_09
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive_09
SELECT id,city,region,title,
       get_json_object(comment1,'$.issue') as issue,
       get_json_object(comment1,'$.time') as time,
       get_json_object(comment1,'$.desc') as desc
      from ods_evaluation.ods_pyspider_db_xiaoqushuo_community_202102 t1
          LATERAL VIEW explode(split(regexp_replace(regexp_replace(t1.comment, '\\[|\\]',''),'\\}\\,\\{','\\}\\;\\{'),'\\;')) ss as comment1

create table dw_evaluation.house_valuation_analysis_same_community_sensitive
as
    insert overwrite table dw_evaluation.house_valuation_analysis_same_community_sensitive
    select
        id,
        city,
        region,
        title,
        '加油站' as event_type,
        youqizhan as coordinate,
        name as event_desc,
           '' as event_time,
        current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_01 where name <> ''

insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    '变电站' as event_type,
    gaoyaxian as coordinate,
    name as event_desc,
    '' as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_02 where name <> ''



    insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    '凶宅' as event_type,
    xiongzhai as coordinate,
    name as event_desc,
    '' as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_03 where name <> ''

    insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    '臭水沟' as event_type,
    choushuihe as coordinate,
    name as event_desc,
    '' as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_04 where name <> ''


    insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    '高架' as event_type,
    gaojia as coordinate,
    name as event_desc,
    '' as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_05 where name <> ''


    insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    '污染源' as event_type,
    wuran as coordinate,
    name as event_desc,
    '' as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_06 where name <> ''


    insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    '墓地' as event_type,
    mudi as coordinate,
    name as event_desc,
    '' as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_07 where name <> ''


    insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    '不利因素' as event_type,
    buli as coordinate,
    name as event_desc,
    '' as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_08 where name <> ''


insert into dw_evaluation.house_valuation_analysis_same_community_sensitive
select
    id,
    city,
    region,
    title,
    issue as event_type,
    '' as coordinate,
    desc as event_desc,
    time as event_time,
    current_timestamp() as timestamp_v
from dw_evaluation.house_valuation_analysis_same_community_sensitive_09 where issue is not null and issue <> '0'