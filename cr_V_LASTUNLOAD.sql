
  CREATE OR REPLACE FORCE VIEW "UGH"."V_LASTUNLOAD" ("VEHID", "LAST_TIMEUNLOAD", "SHOVID", "UNLOADID", "MOVETIME", "WEIGHT") AS 
  select sel1."VEHID",sel1."LAST_TIMEUNLOAD",
    v2.shovid, v2.unloadid, v2.movetime, v2.weight
from (
select vehid, max(timeunload) as last_timeunload
    from UGH.v_vehtrips
    where timeunload>=sysdate-2/24
    group by vehid) sel1
    left join UGH.v_vehtrips v2 on v2.timeunload = sel1.last_timeunload and v2.vehid = sel1.vehid;
