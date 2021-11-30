create table wrk_evaluation.house_valuation_analysis_community_rank_01 as
    insert into table wrk_evaluation.house_valuation_analysis_community_rank_01
select
    community_id,
    district_cd,
    block_cd,
    count(1) as community_rack_cnt,
    rank() over(partition by block_cd order by count(1) desc) as block_community_rack_rank
from dw_evaluation.house_valuation_rack_detail t1
group by
    community_id,
    district_cd,
    block_cd

create table wrk_evaluation.house_valuation_analysis_community_rank_02 as
    insert into table wrk_evaluation.house_valuation_analysis_community_rank_02
select
    block_cd,
    district_cd,
    sum(community_rack_cnt) as block_rack_cnt,
    percentile_approx(community_rack_cnt,0.5) as block_med_community_rack_cnt,
    rank() over(partition by district_cd order by sum(community_rack_cnt) desc) as district_block_rack_cnt_rank
from wrk_evaluation.house_valuation_analysis_community_rank_01
group by
    block_cd,
    district_cd

    create table wrk_evaluation.house_valuation_analysis_community_rank_03 as
    insert into table wrk_evaluation.house_valuation_analysis_community_rank_03
select
    district_cd,
    sum(block_rack_cnt) as district_rack_cnt,
    min(block_rack_cnt) as district_min_block_rack_cnt,
    max(block_rack_cnt) as district_max_block_rack_cnt,
    percentile_approx(block_rack_cnt,0.5) as district_med_community_rack_cnt
from wrk_evaluation.house_valuation_analysis_community_rank_02
group by
    district_cd


insert overwrite table  dm_evaluation.house_valuation_analysis_community_rank
select
    t1.community_id,
    t1.district_cd,
    t1.block_cd,
    t1.community_rack_cnt,
    t1.block_community_rack_rank,
    t2.block_med_community_rack_cnt,
    t3.district_rack_cnt,
    t2.district_block_rack_cnt_rank,
    t3.district_min_block_rack_cnt,
    t3.district_med_community_rack_cnt,
    t3.district_max_block_rack_cnt,
    current_timestamp() as timestamp_v
from wrk_evaluation.house_valuation_analysis_community_rank_01 t1
left join wrk_evaluation.house_valuation_analysis_community_rank_02 t2
on t1.district_cd = t2.district_cd
and t1.block_cd = t2.block_cd
left join wrk_evaluation.house_valuation_analysis_community_rank_03 t3
on t1.district_cd = t3.district_cd


