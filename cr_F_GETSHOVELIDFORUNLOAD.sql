create or replace FUNCTION                                 F_GETSHOVELIDFORUNLOAD 
(
  p_TIMEUNLOAD IN DATE DEFAULT SYSDATE
, p_UNLOADID IN VARCHAR2 DEFAULT null
, p_VEHID IN VARCHAR2 DEFAULT null
) RETURN VARCHAR2 AS o_ShovelID VARCHAR2(50);
/*time1 date;*/
BEGIN

begin
select sel2.shovelid into o_shovelid
from (
select ea.* 
/*, ugh.f_getgeozoneforpoint(ea.x,ea.y) as geozone*/
/*, ugh.f_getshovelidforpoint(ea.x,ea.y) as shovelid_1
, ugh.f_getunloadidforpoint(ea.x,ea.y) as unloadid_1*/
/*, (case when ugh.f_getshovelidforpoint(ea.x,ea.y) is not null then 'Погрузка'
  
    else null end)
 as status_dumptruck*/
from /*eventarchive*/
    ugh.V_EVENTARCHIVE_CURR_GAL ea
WHERE ea.vehid = p_VEHID
    and ea.eventtime BETWEEN 
    getpredefinedtimefrom('за текущую смену', 1, sysDate)
               and getpredefinedtimeto('за текущую смену', 1, sysDate)  
    and ea.eventdescr = 'Остановка'
) sel2
where sel2.status_dumptruck = 'Погрузка' --is not null 
    and sel2.time = --:time1
    
    (select max_time --into :time1
from (
select max(sel1.time) as max_time
from (
select ea.* 
/*, ugh.f_getgeozoneforpoint(ea.x,ea.y) as geozone*/
/*, ugh.f_getshovelidforpoint(ea.x,ea.y) as shovelid_1
, ugh.f_getunloadidforpoint(ea.x,ea.y) as unloadid_1*/
/*, (case when ugh.f_getshovelidforpoint(ea.x,ea.y) is not null then 'Погрузка'
    
    else null end)
 as status_dumptruck*/
from /*eventarchive*/
ugh.V_EVENTARCHIVE_CURR_GAL ea
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
where ROWNUM=1) 
    
group by sel2.vehid, sel2.shovelid;
end;
  RETURN (o_ShovelID);
  
END F_GETSHOVELIDFORUNLOAD;