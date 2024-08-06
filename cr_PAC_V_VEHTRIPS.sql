create or replace PACKAGE PAC_V_VEHTRIPS AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
type r_VehTrips is record(
ISAREAINTERSECT	NUMBER,
BUCKETCOUNT	NUMBER,
LOADHEIGHT	NUMBER,
UNLOADHEIGHT	NUMBER,
TRIPCOUNTER	NUMBER,
VEHID	VARCHAR2(12),
TIMELOAD	DATE,
TIMEUNLOAD	DATE,
GMTTIMELOAD	DATE,
GMTTIMEUNLOAD	DATE,
FUELLOAD	NUMBER,
FUELUNLOAD	NUMBER,
WEIGHT	NUMBER,
LENGTH	NUMBER,
AVSPEED	NUMBER,
UNLOADLENGTH	NUMBER,
SHOVID	VARCHAR2(112),
UNLOADID	VARCHAR2(150),
LOADTYPE	VARCHAR2(130),
MOVETIME	DATE,
XLOAD	NUMBER,
YLOAD	NUMBER,
XUNLOAD	NUMBER,
YUNLOAD	NUMBER,
WORKTYPE	VARCHAR2(135),
AREA	VARCHAR2(130),
VEHCODE	NUMBER,
SHOV_ID	NUMBER,
UNLOAD_ID	NUMBER,
LOADTYPE_ID	NUMBER,
WORKTYPE_ID	NUMBER,
AREA_ID	NUMBER,
HYDROSYSTEMWEIGHT	NUMBER,
TIME_INSERTING	DATE,
UNLOADIDFORLOAD	VARCHAR2(150),
ZLOAD	NUMBER,
ZUNLOAD	NUMBER,
WRATE	NUMBER,
VRATE	NUMBER,
REDUCEDLENGTH	NUMBER
, shift_hour_t VARCHAR2(2)
, shift_hour number
, shift_day_t VARCHAR2(2)
, shift number
);

type t_VehTrips is table of r_VehTrips;
function get_VehTrips_date (p_StartDate date /*, p_StartShift integer*/) return t_VehTrips pipelined;

END PAC_V_VEHTRIPS;


create or replace PACKAGE BODY PAC_V_VEHTRIPS AS

  function get_VehTrips_date (p_StartDate date/*, p_StartShift integer*/) return t_VehTrips pipelined AS
  BEGIN
     for r_VehTrips in
        (
    select 
    
ISAREAINTERSECT	,
BUCKETCOUNT	,
LOADHEIGHT	,
UNLOADHEIGHT	,
TRIPCOUNTER	,
VEHID	,
TIMELOAD	,
TIMEUNLOAD	,
GMTTIMELOAD	,
GMTTIMEUNLOAD	,
FUELLOAD	,
FUELUNLOAD	,
(case when WEIGHT <1 then WRATE else WEIGHT end) as WEIGHT	,
LENGTH	,
AVSPEED	,
UNLOADLENGTH	,
SHOVID	,
UNLOADID	,
LOADTYPE	,
MOVETIME	,
XLOAD	,
YLOAD	,
XUNLOAD	,
YUNLOAD	,
WORKTYPE	,
AREA	,
VEHCODE	,
SHOV_ID	,
UNLOAD_ID	,
LOADTYPE_ID	,
WORKTYPE_ID	,
AREA_ID	,
HYDROSYSTEMWEIGHT	,
TIME_INSERTING	,
UNLOADIDFORLOAD	,
ZLOAD	,
ZUNLOAD	,
WRATE	,
VRATE	,
REDUCEDLENGTH
, to_char(v.timeload, 'hh24') as shift_hour_t
, (case when to_number(to_char(v.timeload, 'hh24')) <20 then
    (case when to_number(to_char(v.timeload, 'hh24')) >=8 then
        to_number(to_char(v.timeload, 'hh24'))-7
    else
        to_number(to_char(v.timeload, 'hh24'))+5
        end)
    else
    to_number(to_char(v.timeload, 'hh24'))-19
end)
 as shift_hour
, (case when to_number(to_char(v.timeload, 'hh24')) <8 then
to_char(to_number(to_char(v.timeload, 'dd')-1)) 
else
to_char(v.timeload, 'dd') 
end) as shift_day_t
, /*(case when to_number(to_char(v.timeload, 'hh24')) <8 then
2
else
(case when to_number(to_char(v.timeload, 'hh24')) <20 then
1
else
2
end)
end)*/
ugh.getcurshiftnum(1,v.timeload)
as shift
    from dispatcher.vehtrips v
where v.timeload 
BETWEEN ugh.GetPredefinedTimeFrom ( /*:ParamDataFrom*/ 'за указанную смену' , 1 , p_StartDate, /*:ParamBeginPeriod*/ 
p_StartDate
/*to_date(to_char(p_StartDate,'dd.mm.yyyy')||' 00:00:00','dd.mm.yyyy hh24:mi:ss')*/
) 
AND ugh.GetPredefinedTimeTo ( /*:ParamDataFrom*/ 'за указанную смену' , 2 , p_StartDate, /*:ParamEndPeriod*/ p_StartDate)
)loop
          pipe row (r_VehTrips);
   end loop;
   
  END get_VehTrips_date;

END PAC_V_VEHTRIPS;