
  CREATE OR REPLACE FORCE VIEW "UGH"."V_VEHTRIPS_EVENTTRIPS" ("VEHID", "TIMELOAD", "SHOVID", "TIMEUNLOAD", "UNLOADID", "WEIGHT", "AVSPEED", "WORKTYPE") AS 
  select sel1."VEHID",sel1."TIMELOAD",sel1."SHOVID",sel1."TIMEUNLOAD",sel1."UNLOADID",sel1."WEIGHT",sel1."AVSPEED",sel1."WORKTYPE" from (
select egt.VEHID
, egt.TIMELOAD
, egt.SHOVELID as shovid
, egt.TIMEUNLOAD 
, egt.UNLOADID
, egt.WEIGHT
, 0 as avspeed
, egt.worktype
from UGH.v_events_geozones_trips1 egt
union
select v.VEHID
, v.TIMELOAD
, v.SHOVID
, v.TIMEUNLOAD 
, v.UNLOADID
, v.WEIGHT
, v.avspeed
, v.worktype
from UGH.v_vehtrips v
) sel1
where sel1.timeload 
BETWEEN ugh.GetPredefinedTimeFrom ( /*:ParamDataFrom*/ 'за текущую смену' , 1 , SYSDATE, /*:ParamBeginPeriod*/ to_date(to_char(sysdate,'dd.mm.yyyy')||' 00:00:00','dd.mm.yyyy hh24:mi:ss')) 
AND ugh.GetPredefinedTimeTo ( /*:ParamDataFrom*/ 'за текущую смену' , 1 , SYSDATE, /*:ParamEndPeriod*/ sysdate)
order by sel1.timeload;
