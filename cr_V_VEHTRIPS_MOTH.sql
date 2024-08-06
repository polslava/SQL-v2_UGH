
  CREATE OR REPLACE FORCE VIEW "UGH"."V_VEHTRIPS_MOTH" ("TRIPCOUNTER", "VEHID", "TIMELOAD", "TIMEUNLOAD", "GMTTIMELOAD", "GMTTIMEUNLOAD", "FUELLOAD", "FUELUNLOAD", "WEIGHT", "LENGTH", "AVSPEED", "UNLOADLENGTH", "SHOVID", "UNLOADID", "LOADTYPE", "MOVETIME", "XLOAD", "YLOAD", "XUNLOAD", "YUNLOAD", "WORKTYPE", "AREA", "VEHCODE", "SHOV_ID", "UNLOAD_ID", "LOADTYPE_ID", "WORKTYPE_ID", "AREA_ID", "HYDROSYSTEMWEIGHT", "TIME_INSERTING", "UNLOADIDFORLOAD", "ZLOAD", "ZUNLOAD", "WRATE", "VRATE", "REDUCEDLENGTH", "ISAREAINTERSECT", "BUCKETCOUNT", "LOADHEIGHT", "UNLOADHEIGHT", "VOLUME", "nedogruz_tn", "nedogruz_percent", "NEDOGRUZ", "TIMELOAD_HOUR_T", "TIMELOAD_HOUR", "DATESHIFT_HOUR", "DATESHIFT_HOUR_T", "DUMPTUCK", "TRIP", "SHIFTDATE", "SHIFTNUM") AS 
  select v."TRIPCOUNTER",v."VEHID",v."TIMELOAD",v."TIMEUNLOAD",v."GMTTIMELOAD",v."GMTTIMEUNLOAD"
,v."FUELLOAD",v."FUELUNLOAD"
,(case when v.WEIGHT <1 then v.WRATE else v.WEIGHT end) as "WEIGHT"
,v."LENGTH",v."AVSPEED",v."UNLOADLENGTH",v."SHOVID",v."UNLOADID",v."LOADTYPE",v."MOVETIME",v."XLOAD",v."YLOAD",v."XUNLOAD",v."YUNLOAD",v."WORKTYPE",v."AREA",v."VEHCODE",v."SHOV_ID",v."UNLOAD_ID",v."LOADTYPE_ID",v."WORKTYPE_ID",v."AREA_ID",v."HYDROSYSTEMWEIGHT",v."TIME_INSERTING",v."UNLOADIDFORLOAD",v."ZLOAD",v."ZUNLOAD",v."WRATE",v."VRATE",v."REDUCEDLENGTH",v."ISAREAINTERSECT",v."BUCKETCOUNT",v."LOADHEIGHT",v."UNLOADHEIGHT" 
,(case when v.WEIGHT <1 then 31.5 else round(v.WEIGHT/2.74,1) end) as "VOLUME"
,(case when v.WEIGHT <1 then v.WRATE-v.WRATE else v.WRATE-v.WEIGHT end) as "nedogruz_tn"
,round((case when v.WEIGHT <1 then (v.WRATE-v.WRATE)/v.WRATE else (v.WRATE-v.WEIGHT)/v.WRATE end)*100,2) as "nedogruz_percent"
,(case when 
round((case when v.WEIGHT <1 then (v.WRATE-v.WRATE)/v.WRATE else (v.WRATE-v.WEIGHT)/v.WRATE end)*100,2) >5 then 'недогруз'
else (case when 
round((case when v.WEIGHT <1 then (v.WRATE-v.WRATE)/v.WRATE else (v.WRATE-v.WEIGHT)/v.WRATE end)*100,2) <-5 then 'перегруз'
else 'норма'
end)
end) as "NEDOGRUZ"
, F_GET_HOURFROMDATE_T(v.timeload) as timeload_hour_t
, F_GET_HOURFROMDATE(v.timeload) as timeload_hour
, F_GET_DATESHIFTHOUR(v.timeload) as dateshift_hour
, f_get_shifthour_t (v.timeload)||'_'||F_GET_HOURFROMDATE_T(v.timeload) as dateshift_hour_t
, (case when (cast (SUBSTR(v.vehid,0,2) as number))<10 then '0'||SUBSTR(v.vehid,0,1) else SUBSTR(v.vehid,0,2) end) as dumptuck
,1 as trip
,f_get_shiftdate(v.timeload) as shiftdate
,f_get_shiftnum(v.timeload) as shiftnum
from dispatcher.vehtrips v
where v.timeload 
BETWEEN dispatcher.GetPredefinedTimeFrom 
( /*:ParamDataFrom*/ 'за указанный интервал' , 1 , SYSDATE, /*:ParamBeginPeriod*/ to_date('01.'||to_char(SYSDATE,'mm')||'.'||to_char(SYSDATE,'yyyy')||' 08:00:00','dd.mm.yyyy hh24:mi:ss'))  
AND 
dispatcher.GetPredefinedTimeTo ( /*:ParamDataFrom*/ 'за указанный интервал' , 1 , SYSDATE, /*:ParamEndPeriod*/ sysdate);
