
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PLANFACT_HOUR_VOLUME_HALF" ("SHIFTHOUR", "TIMELOAD_HOUR", "SHIFTHOUR_T", "TIMELOAD_HOUR_T", "HOUR_T", "FACT_VOLUME", "SHOVID", "PLAN_HOUR", "FACT_PERCENT", "PLAN_HOUR_HALF", "FACT_PERCENT_HALF", "SHIFTHOUR_HALF_T", "SHIFTHOUR_HALF") AS 
  select sel1."SHIFTHOUR",sel1."TIMELOAD_HOUR",sel1."SHIFTHOUR_T",sel1."TIMELOAD_HOUR_T",sel1."HOUR_T",sel1."FACT_VOLUME",sel1."SHOVID"

, s1.plan_hour
, round(sel1.fact_volume/s1.plan_hour,2)*100 as fact_percent
, s1.plan_hour/2 as plan_hour_half
, round(sel1.fact_volume/(s1.plan_hour/2),2)*100 as fact_percent_half
, sel1.shifthour_half_t
, sel1.shifthour_half
from (
SELECT f_get_shifthour(vt.timeload) as shifthour
,f_get_hourfromdate(vt.timeload) as timeload_hour
,f_get_shifthour_t(vt.timeload) as shifthour_t
,f_get_hourfromdate_t(vt.timeload) as timeload_hour_t
,f_get_shifthour_t(vt.timeload)||'_'||f_get_hourfromdate_t(vt.timeload) as hour_t
, round(sum((vt.weight)/2.74),1) As fact_volume
    , vt.shovid
    , vt.shifthour_half_t
    , vt.shifthour_half
from ugh.v_vehtrips vt
group by f_get_shifthour(vt.timeload),f_get_hourfromdate(vt.timeload), vt.shovid
,f_get_shifthour_t(vt.timeload) 
,f_get_hourfromdate_t(vt.timeload)
,f_get_shifthour_t(vt.timeload)||'_'||f_get_hourfromdate_t(vt.timeload)
, vt.shifthour_half_t
, vt.shifthour_half
order by f_get_shifthour(vt.timeload)) sel1
left join (select round((s.plan_volume)/10.5,1) as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
--group by s.shovid
)  s1
    on s1.shovid = sel1.shovid;
