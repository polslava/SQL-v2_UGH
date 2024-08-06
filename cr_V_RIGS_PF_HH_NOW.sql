
  CREATE OR REPLACE FORCE VIEW "UGH"."V_RIGS_PF_HH_NOW" ("RIGNAME", "PLANFACT", "DEPTH_FACT", "NORM", "SHIFTNORM", "PERC", "SHIFTPERC", "MAXPERC", "DRILLINLASTHOUR") AS 
  select rigname,
depth_fact-Norm as planfact,
depth_fact, Norm,
ShiftNorm,
round(depth_fact*100/Norm,2) as perc,
round(depth_fact*100/ShiftNorm,2) as ShiftPerc,
100 as MaxPerc,
(CASE WHEN DrillInLastHour>0 THEN 1 ELSE 0 END) as DrillInLastHour
 from (
select rgt.rigid,
       round(nvl(depth_fact,0)/100,0) depth_fact,
       round(((select nrm.value from ugh.v_rigs_norms@rigs nrm where id=1)/21)*ugh.GetCurWorkHalfHour,0) as Norm,
       (select nrm.value from ugh.v_rigs_norms@rigs nrm where id=1) as ShiftNorm , DrillInLastHour
from ugh.v_rigs_in_shift_task rgt
left join (select t.rigid, nvl(sum(
     CASE WHEN UGH.GetDepthSensorState@rigs(t.rigid, t.timebegindrillinggmt)=0 THEN t.depth_fact
       ELSE (wls.DEPTH_PLAN*100 ) END),0) as depth_fact from UGH.V_WELLSBYFACT@rigs t
     left join RIGS.WELLS@rigs wls on wls.wellid=t.wellid
 where t.TIMEBEGINDRILLINGGMT between ugh.datetime.Local_To_Gmt(UGH.GetCurShiftFrom)
    and ugh.datetime.Local_To_Gmt(UGH.GetCurShiftTo) group by t.rigid) sel_1 on sel_1.rigid=rgt.rigid
--left join (select rigid, sum(nvl(depth_fact,0)) as depth_fact from UGH.V_WELLSBYFACT@rigs t where t.TIMEBEGINDRILLINGGMT between sysdate-1/24/2
--    and sysdate group by rigid) sel_3 on sel_3.rigid=rgt.rigid
left join (
select t.rigid, nvl(sum(decode(t.depth_fact,0,wls_2.depth_plan*100,t.depth_fact)),0) as DrillInLastHour from UGH.V_WELLSBYFACT@rigs t
       left join RIGS.WELLS@rigs wls_2 on wls_2.wellid=t.wellid
where t.TIMEBEGINDRILLINGGMT between ugh.datetime.Local_To_Gmt(UGH.GetCurShiftFrom)+(ugh.getcurhalfhour-1)/48
    and ugh.datetime.Local_To_Gmt(UGH.GetCurShiftTo)+(ugh.getcurhalfhour)/48 group by t.rigid
) sel_4 on sel_4.rigid=rgt.rigid ) sel_2
        inner join ugh.v_rigs@rigs rg on rg.RIGID=sel_2.rigid
;
