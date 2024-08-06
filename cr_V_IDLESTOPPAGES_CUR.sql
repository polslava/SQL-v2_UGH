
  CREATE OR REPLACE FORCE VIEW "UGH"."V_IDLESTOPPAGES_CUR" ("ID", "VEHID", "TIMESTOP", "TIMEGO", "TYPEID", "TYPEAUTO", "EQUIPMENTID", "DRIVERSTOPID", "DESCRIPTION", "PLANNED", "STOP_TIME_MIN", "STOP_TIME_HOUR", "STOPPAGE_TYPE", "STOPPAGE_CATEGORY", "TIMESTOP_HOUR_T", "TIMESTOP_HOUR", "DATESHIFT_HOUR", "DATESHIFT_HOUR_T", "SHIFTNUM", "SHIFTDATE", "SHIFTHOUR_HALF_T", "SHIFTHOUR_HALF", "SHOVEL_NAME") AS 
  select sel1."ID",sel1."VEHID",sel1."TIMESTOP",sel1."TIMEGO",sel1."TYPEID",sel1."TYPEAUTO",sel1."EQUIPMENTID",sel1."DRIVERSTOPID",sel1."DESCRIPTION",sel1."PLANNED",sel1."STOP_TIME_MIN",sel1."STOP_TIME_HOUR" 
, ust.name as stoppage_type
, usc.name as stoppage_category

, F_GET_HOURFROMDATE_T(sel1.timestop) as timestop_hour_t
, F_GET_HOURFROMDATE(sel1.timestop) as timestop_hour
, F_GET_DATESHIFTHOUR(sel1.timestop) as dateshift_hour
, f_get_shifthour_t (sel1.timestop)||'_'||F_GET_HOURFROMDATE_T(sel1.timestop) as dateshift_hour_t
, f_get_shiftnum(sel1.timestop) as shiftnum
, f_get_shiftdate(sel1.timestop) as shiftdate
, f_get_shifthour_half_t(sel1.timestop) as shifthour_half_t
, F_GET_shifthour_half(sel1.timestop) as shifthour_half
--, F_GETSHOVELIDFORPOINT(sel1.XBEGIN,sel1.YBEGIN,sel1.timestop) as shovel
, (case when sel1.shovel_name = ' ' 
    then 'Неопр.' 
    else  substr(sel1.shovel_name,2)
    end) as shovel_name
from
(
        select distinct 
		isp.stopcounter as ID,  
		at.vehid as VehID, 
		isp.timestop as TimeStop, 
		nvl(isp.timego,sysdate) as TimeGo, 
		nvl2(isp.timego,isp.idlestoptype ,
		nvl(isp.idlestoptype,-1)) as TypeID, 
		nvl2(isp.timego,isp.idlestoptypeauto,-1) as TypeAuto, 
		isp.Equipmentid ,
		nvl2(isp.timego,nvl(isp.drvstoptype,isp.idlestoptypeauto),-1) as DriverStopID
        , isp.note as Description, 
		isp.Planned 
        ,round((isp.timego - isp.timestop)*60*24,1) as stop_time_min
    ,round((isp.timego - isp.timestop)*24,5) as stop_time_hour
     ,isp.XBEGIN,isp.YBEGIN
     ,(case when substr(isp.note,0,6)='Экск. ' 
            then substr(isp.note,6)
            else '' end) as shovel_name
		from dispatcher.idlestoppages isp 
	  inner JOIN 
        (select vehid as vehname,
           tsname as vehid
         from ugh.ALLVEHICLES_TS )at
         on at.vehname=isp.vehid
	 where     
	 ( isp.timestop between 
     /*:TimeFrom+(1/(24*60*60)) and :TimeTo */
     sysdate-1 and sysdate
   /*  or isp.timego between 
     sysdate-1 and sysdate
     or isp.timego is null */) 
     and 
     ((isp.idlestoptype is null and (isp.timego - isp.timestop) >= 3 * 24 * 60)
     or 
     (isp.idlestoptype is not null and (isp.timego - isp.timestop) >= 0)/*3 / 24 / 60*/ /*or isp.idlestoptype is not null or isp.timego is null*/
     )
) sel1
left join dispatcher.USERSTOPPAGETYPES ust on ust.code = sel1.typeid
left join dispatcher.USERSTOPPAGECATEGORIES usc on usc.id = ust.categoryid
where (sel1.timestop between
ugh.GetPredefinedTimeFrom ( /*:ParamDataFrom*/ 'за текущую смену' , 1 , SYSDATE, /*:ParamBeginPeriod*/ to_date(to_char(sysdate,'dd.mm.yyyy')||' 00:00:00','dd.mm.yyyy hh24:mi:ss')) 
AND ugh.GetPredefinedTimeTo ( /*:ParamDataFrom*/ 'за текущую смену' , 1 , SYSDATE, /*:ParamEndPeriod*/ sysdate))
and sel1.vehid in (select tsname from ugh.allvehicles_ts where vehtype = 'Самосвал');
