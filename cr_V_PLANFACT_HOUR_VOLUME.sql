
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PLANFACT_HOUR_VOLUME" ("SHIFTHOUR", "TIMELOAD_HOUR", "SHIFTHOUR_T", "TIMELOAD_HOUR_T", "HOUR_T", "FACT_VOLUME", "SHOVID", "PLAN_HOUR", "FACT_PERCENT", "SHOV_TYPE") AS 
  select s_1."SHIFTHOUR",
       sel_1."TIMELOAD_HOUR",
       nvl(sel_1."SHIFTHOUR_T", ugh.f_get_shifthour_t()) as "SHIFTHOUR_T",
       sel_1."TIMELOAD_HOUR_T",
       nvl(sel_1."HOUR_T", ugh.f_get_shifthour_t()||'_'||ugh.f_get_hourfromdate_t()) "HOUR_T",
       nvl(sel_1."FACT_VOLUME",0) as "FACT_VOLUME",
       s_1."SHOVID"

, (CASE WHEN s_1.shifthour<>6 THEN s_1.plan_hour else 0 end) as plan_hour
, nvl(case when s_1.plan_hour>0 then round(sel_1.fact_volume/s_1.plan_hour,2)*100 else 0 end,0) as fact_percent
, (case when s_1."SHOVID" like 'PC-2000%' or s_1."SHOVID" like '%992%' then 'big' else 'small' end) as shov_type
from (
select round((s.plan_volume)/10.5,1) as plan_hour, s.shovid, r as shifthour
from v_shovels_in_shift_planfact s
join (select level r from dual connect by level <= ugh.f_get_shifthour()) on 1=1

--group by s.shovid
)  s_1

left join

(SELECT ugh.f_get_shifthour(vt.timeload) as shifthour
,ugh.f_get_hourfromdate(vt.timeload) as timeload_hour
,ugh.f_get_shifthour_t(vt.timeload) as shifthour_t
,ugh.f_get_hourfromdate_t(vt.timeload) as timeload_hour_t
,ugh.f_get_shifthour_t(vt.timeload)||'_'||ugh.f_get_hourfromdate_t(vt.timeload) as hour_t
, round(sum((vt.weight)/2.74),1) As fact_volume
    , vt.shovid
from ugh.v_vehtrips vt
group by ugh.f_get_shifthour(vt.timeload),ugh.f_get_hourfromdate(vt.timeload), vt.shovid
,ugh.f_get_shifthour_t(vt.timeload)
,ugh.f_get_hourfromdate_t(vt.timeload)
,ugh.f_get_shifthour_t(vt.timeload)||'_'||ugh.f_get_hourfromdate_t(vt.timeload)
order by f_get_shifthour(vt.timeload)) sel_1  on (s_1.shovid = sel_1.shovid )and (s_1.shifthour=sel_1.shifthour);
