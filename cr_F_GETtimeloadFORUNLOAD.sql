create or replace FUNCTION                             F_GETtimeloadFORUNLOAD 
(
  p_TIMEUNLOAD IN DATE DEFAULT SYSDATE
, p_UNLOADID IN VARCHAR2 DEFAULT null
, p_VEHID IN VARCHAR2 DEFAULT null
) RETURN DATE AS o_Timeload date;
BEGIN
begin
select max_time into o_Timeload
from (
select 
max(sel1.time) as max_time
from (
select ea.* 
/*, ugh.f_getgeozoneforpoint(ea.x,ea.y) as geozone
, ugh.f_getshovelidforpoint(ea.x,ea.y) as shovelid
, ugh.f_getunloadidforpoint(ea.x,ea.y) as unloadid
, (case when ugh.f_getshovelidforpoint(ea.x,ea.y) is not null then 'Погрузка'
    else (case when ugh.f_getunloadidforpoint(ea.x,ea.y) is not null then 'Разгрузка'
    else null end)
end) as status_dumptruck*/
from ugh.V_EVENTARCHIVE_CURR_GAL
/*eventarchive*/ ea
WHERE ea.vehid = p_VEHID
    and ea.eventtime BETWEEN 
    getpredefinedtimefrom('за текущую смену', 1, sysDate)
               and getpredefinedtimeto('за текущую смену', 1, sysDate)  
    and ea.eventdescr = 'Остановка'
) sel1
where sel1.status_dumptruck = 'Погрузка' --is not null 
    and sel1.time <= to_date(p_TIMEUNLOAD,'dd.mm.yyyy hh24:mi:ss') /*to_date('09.07.2022 20:44:17','dd.mm.yyyy hh24:mi:ss')*/
group by sel1.vehid, sel1.shovelid
order by max(sel1.time) desc
)
where rownum=1
;
end;
  RETURN (o_Timeload);
END F_GETtimeloadFORUNLOAD;