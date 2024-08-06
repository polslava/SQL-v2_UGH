
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHOVELS_IN_SHIFT_PLANFACT" ("SHOVID", "SHIFTDATE", "SHIFTNUM", "PLAN_VOLUME", "FACT_VOLUME", "PLAN_FACT_VOLUME") AS 
  select sel3."SHOVID",sel3."SHIFTDATE",sel3."SHIFTNUM",sel3."PLAN_VOLUME",sel3."FACT_VOLUME"
    , case when plan_volume>0 then round((fact_volume/plan_volume)*100,0) else 0 end As plan_fact_volume
from (
SELECT sel2.*
, sum(vt.vrate) As fact_volume

from (
  select sel1."SHOVID",sel1."SHIFTDATE",sel1."SHIFTNUM"
    , sum(ssp.volume) As plan_volume

    from (
select std.shovid, getcurshiftdate(1,sysdate,12) as shiftdate, getcurshiftnum(1) as shiftnum
from dispatcher.shifttaskdetails std
left join dispatcher.shifttasks st on st.taskcounter = std.taskcounter
--left join dispatcher.shovels s on s.controlid = std.shovid
where st.taskdate = ugh.getcurshiftdate(0) --(to_date('31.01.2023','dd.mm.yyyy'))
    and st.shift = ugh.getcurshiftnum(0) --1

group by std.shovid) sel1
left join DISPATCHER.shovshiftplans ssp
    on ssp.shovid = sel1.shovid
        and ssp.taskdate = sel1.shiftdate and ssp.shift = sel1.shiftnum
group by sel1.shovid, sel1.shiftdate, sel1.shiftnum
) sel2
left join ugh.v_vehtrips vt
    on vt.shovid = sel2.shovid
group by
sel2.SHOVID,sel2.SHIFTDATE,sel2.SHIFTNUM,sel2.plan_volume
) sel3
where sel3."PLAN_VOLUME">0;
