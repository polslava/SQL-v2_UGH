
  CREATE OR REPLACE FORCE VIEW "UGH"."V_RIGS_PF_HH" ("RIGNAME", "HALFHOUR", "HALFHOUR_T", "HOUR", "HOUR_T", "PLANFACT", "DEPTH_FACT", "NORM", "SHIFTNORM", "MAXPERC", "DRILLINLASTHOUR") AS 
  select rigname, halfhour, halfhour_t, hour, hour_t,
depth_fact-Norm as planfact,
depth_fact, Norm,
ShiftNorm,
--round(depth_fact*100/Norm,2) as perc,
--round(depth_fact*100/ShiftNorm,2) as ShiftPerc,
100 as MaxPerc,
(CASE WHEN DrillInLastHour>0 THEN 0.5 ELSE 0 END) as
DrillInLastHour
 from (
select rgt.rigid, rgt.halfhour, rgt.halfhour_t, rgt.hour, rgt.hour_t,
       round(nvl(depth_fact,0)/100,0) depth_fact,
       (CASE WHEN rgt.HOUR=6 or rgt.Hour=12 or rgt.hour>ugh.getcurhour then 0 ELSE round(((select nrm.value from ugh.v_rigs_norms@rigs nrm where id=1)/21),2) END) as Norm,
       (select nrm.value from ugh.v_rigs_norms@rigs nrm where id=1) as ShiftNorm, DrillInLastHour
from (
select * from ugh.v_rigs_in_shift_task
left join ugh.shifthours sh on 1=1) rgt
left join (select t.rigid, nvl(sum(
     CASE WHEN UGH.GetDepthSensorState@rigs(t.rigid, t.timebegindrillinggmt)=0 THEN t.depth_fact
       ELSE (wls.DEPTH_PLAN*100 ) END),0) as depth_fact, ugh.f_get_shifthour_half(ugh.datetime.gmt_to_local(t.TIMEBEGINDRILLINGGMT)) halfhour from UGH.V_WELLSBYFACT@rigs t
     left join RIGS.WELLS@rigs wls on wls.wellid=t.wellid
 where t.TIMEBEGINDRILLINGGMT between ugh.datetime.Local_To_Gmt(UGH.GetCurShiftFrom)
    and ugh.datetime.Local_To_Gmt(UGH.GetCurShiftTo) group by t.rigid, ugh.f_get_shifthour_half(ugh.datetime.gmt_to_local(t.TIMEBEGINDRILLINGGMT))) sel_1 on sel_1.rigid=rgt.rigid and sel_1.halfhour=rgt.halfhour

left join (
select t.rigid, nvl(sum(CASE WHEN UGH.GetDepthSensorState@rigs(t.rigid, t.timebegindrillinggmt)=0 THEN t.depth_fact
       ELSE (wls_2.DEPTH_PLAN*100 ) END),0) as DrillInLastHour, ugh.f_get_shifthour(ugh.datetime.gmt_to_local(t.TIMEBEGINDRILLINGGMT)) hour from UGH.V_WELLSBYFACT@rigs t
       left join RIGS.WELLS@rigs wls_2 on wls_2.wellid=t.wellid
where t.TIMEBEGINDRILLINGGMT between ugh.datetime.Local_To_Gmt(UGH.GetCurShiftFrom)
    and ugh.datetime.Local_To_Gmt(UGH.GetCurShiftTo) group by t.rigid, ugh.f_get_shifthour(ugh.datetime.gmt_to_local(t.TIMEBEGINDRILLINGGMT))) sel_4 on sel_4.rigid=rgt.rigid and sel_4.hour=rgt.hour
) sel_2
        inner join ugh.v_rigs@rigs rg on rg.RIGID=sel_2.rigid
;
