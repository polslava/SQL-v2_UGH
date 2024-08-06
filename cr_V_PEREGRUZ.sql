
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PEREGRUZ" ("OCOUNTER", "VTVEHID", "TIMELOAD", "GMTTIMELOAD", "XLOAD", "YLOAD", "SHOVID", "VTWEIGHT", "STANDARDWEIGHT", "COLOR", "PEREGRUZ_PERCENT") AS 
  select sel1."OCOUNTER",sel1."VTVEHID",sel1."TIMELOAD",sel1."GMTTIMELOAD",sel1."XLOAD",sel1."YLOAD",sel1."SHOVID",sel1."VTWEIGHT",sel1."STANDARDWEIGHT"           
, (case when sel1.VTWeight/sel1.STANDARDWEIGHT between 1.05 and 1.1 then 'yellow'    else (case when sel1.VTWeight/sel1.STANDARDWEIGHT >=1.10 then 'red' else         
'white' end) end) as color      ,round((sel1.VTWeight/sel1.STANDARDWEIGHT-1)*100,0) as peregruz_percent       
from  (select null as ocounter, vs.vehid VTVehID,vs.timeload,vs.gmttimeload, VS.XLOAD,VS.YLOAD,vs.shovid, VS.WEIGHT VTWeight,    
dispatcher.NORMS.TRIP_WEIGHT(vs.shovid,vs.vehid,VS.WORKTYPE,VS.UNLOADID,VS.LENGTH,VS.TIMEUNLOAD) as STANDARDWEIGHT      
from dispatcher.vehtrips vs     
where VehID LIKE DECODE ( 'Все' , 'Все', '%' , 'Все' )                
AND                 
TimeLoad BETWEEN                  
dispatcher.GetPredefinedTimeFrom ( /*:ParamDataFrom*/ 'за текущую смену' , 1 , SYSDATE, /*:ParamBeginPeriod*/ to_date(to_char(sysdate,'dd.mm.yyyy')||' 00:00:00','dd.mm.yyyy hh24:mi:ss'))                 
AND dispatcher.GetPredefinedTimeTo ( /*:ParamDataFrom*/ 'за текущую смену' , 1 , SYSDATE, /*:ParamEndPeriod*/ sysdate)                
) sel1                 
where sel1.VTWeight > standardweight*1.05              
order by sel1.timeload desc;
