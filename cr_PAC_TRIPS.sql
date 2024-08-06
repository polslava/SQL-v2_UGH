create or replace PACKAGE PAC_TRIPS AS 

  type r_EVENTARCHIVE_CURR_GAL is record(
  
MESCOUNTER	NUMBER(10),
VEHID	VARCHAR2(12),
EVENTTIME	DATE,
EVENTGMTTIME	DATE,
X1	NUMBER,
Y1	NUMBER,
EVENTGROUP	NUMBER,
EVENTCODE	NUMBER,
EVENTDESCR	VARCHAR2(200),
TIMESYSTEM	DATE,
VEHTYPE	VARCHAR2(12),
VEHCODE	NUMBER,
EVENTTYPE	NUMBER,
TIME	DATE,
MOTOHOURS	NUMBER,
WEIGHT	NUMBER,
FUEL	NUMBER,
SPEED	NUMBER,
MESNUMBER	NUMBER,
GEOZONE	VARCHAR2(4000),
SHOVELID	VARCHAR2(4000),
UNLOADID	VARCHAR2(4000),
STATUS_DUMPTRUCK	VARCHAR2(9),
TIME1	VARCHAR2(16)
);

type t_EVENTARCHIVE_CURR_GAL is table of r_EVENTARCHIVE_CURR_GAL;
function get_EVENTARCHIVE_CURR_GAL (p_StartDate date , p_StartShift integer) return t_EVENTARCHIVE_CURR_GAL pipelined;

type r_EVENTS_GEOZONES_TRIPS0 is record(
VEHID	VARCHAR2(12),
MODEL1	VARCHAR2(3),
TIMELOAD	DATE,
SHOVELID	VARCHAR2(4000),
TIMEUNLOAD	DATE,
UNLOADID	VARCHAR2(4000),
WEIGHT	NUMBER,
WORKTYPE	VARCHAR2(4000)
);

type t_EVENTS_GEOZONES_TRIPS0 is table of r_EVENTS_GEOZONES_TRIPS0;
function get_EVENTS_GEOZONES_TRIPS0 (p_StartDate date , p_StartShift integer) return t_EVENTS_GEOZONES_TRIPS0 pipelined;
function get_EVENTS_GEOZONES_TRIPS1 (p_StartDate date , p_StartShift integer) return t_EVENTS_GEOZONES_TRIPS0 pipelined;

END PAC_TRIPS;

create or replace PACKAGE BODY PAC_TRIPS AS

  function get_EVENTARCHIVE_CURR_GAL (p_StartDate date , p_StartShift integer) return t_EVENTARCHIVE_CURR_GAL pipelined AS
  BEGIN
      /*выборка событий "остановка" EVENTARCHIVE_CURR_GAL*/
for r_EVENTARCHIVE_CURR_GAL in
        (  
     SELECT E.MESCOUNTER,
           E.VEHID,
           E.TIME as EVENTTIME,
           E.GMTTIME as EVENTGMTTIME,
           E.X,
           E.Y,
           E.EVENTGROUP,
           E.EVENTCODE,
           NVL (Eai.EVENTDESCR, cc.VALUE) as EVENTDESCR,
           E.TIMESYSTEM,
           E.VEHTYPE,
           E.VEHCODE,
           e.eventtype,
           E.TIME as time,
           E.MOTOHOURS,
           e.weight,
           e.fuel,
           e.speed,
           E.MESNUMBER
        , ugh.f_getgeozoneforpoint(e.x,e.y) as geozone
        , ugh.f_getshovelidforpoint(e.x,e.y,e.time) as shovelid
        , ugh.f_getunloadidforpoint(e.x,e.y) as unloadid
        , (case when ugh.f_getshovelidforpoint(e.x,e.y,e.time) is not null then 'Погрузка'
    else (case when ugh.f_getunloadidforpoint(e.x,e.y) is not null then 'Разгрузка'
    else null end)
    
end) as status_dumptruck
, substr(cast(e.time as varchar(20)),0,16) as time1
      FROM DISPATCHER.EVENTSTATEARCHIVE  E
           LEFT JOIN DISPATCHER.eventarchaddinfo eai ON e.addinfoid = eai.id
           LEFT JOIN DISPATCHER.constcodes cc
               ON cc.TABLENAME = 'EVENTSTATEARCHIVE' AND cc.code = e.eventtype
    WHERE e.vehid like '%-CAT 777'
        --or (e.vehid = '17' )
    and e.time BETWEEN 
    ugh.getpredefinedtimefrom('за указанную смену', p_StartShift, p_StartDate)
               and ugh.getpredefinedtimeto('за указанную смену', p_StartShift, p_StartDate)  
    and (cc.VALUE = 'Остановка' /*or e.speed =0*/)

    
         ) loop
          pipe row (r_EVENTARCHIVE_CURR_GAL);
   end loop;
   
  END get_EVENTARCHIVE_CURR_GAL;

  function get_EVENTS_GEOZONES_TRIPS0 (p_StartDate date , p_StartShift integer) return t_EVENTS_GEOZONES_TRIPS0 pipelined AS
  BEGIN
      /*выборка ходок из событий "остановка" EVENTARCHIVE_CURR_GAL*/
for r_EVENTS_GEOZONES_TRIPS0 in
        (  
 select sel3."VEHID",sel3."MODEL1",sel3."TIMELOAD",sel3."SHOVELID",sel3."TIMEUNLOAD" 
    , sel2_1.unloadid
,
(case when sel3.shovelid is null then
(case when sel3.model1='777' then 90 
    else (case when sel3.model1='773' then 55
        else 25
    end)
end)
else
dispatcher.NORMS.TRIP_WEIGHT(sel3.shovelid,sel3.vehid,
ugh.F_GETDEFAULTWORKTYPE(sel2_1.unloadid)
,null,null,
sel3.timeunload
)
end) as weight
,ugh.F_GETDEFAULTWORKTYPE(sel2_1.unloadid) as worktype

 from(
 select sel2.vehid
, sel2.model1
, sel2.timeload_f as timeload, sel2.shovelid_f as shovelid, min(sel2.time) as timeunload --, sel2.unloadid

from (
select sel1_2.*
,ugh.F_GETSHOVELIDFORUNLOAD(to_date(sel1_2.time,'dd.mm.yyyy hh24:mi:ss'),null,sel1_2.vehid)
as shovelid_f
,ugh.F_GETtimeloadFORUNLOAD(to_date(sel1_2.time,'dd.mm.yyyy hh24:mi:ss'),null,sel1_2.vehid)
as timeload_f
from(
select 
 sel1_1.vehid,  sel1_1.time1, sel1_1.weight, sel1_1.eventdescr, sel1_1.vehtype
,sel1_1.geozone, sel1_1.shovelid, sel1_1.unloadid
, sel1_1.model1

, min(sel1_1.time) as time
from (
select sel1.vehid,  substr(cast(sel1.time as varchar(20)),0,16) as time1, sel1.weight, sel1.eventdescr, sel1.vehtype
,sel1.geozone, sel1.shovelid, sel1.unloadid
, sel1.time
, substr(d.model,5,3) as model1
from /*ugh.V_EVENTARCHIVE_CURR_GAL*/
(Select * 
from table (ugh.pac_trips.get_eventarchive_curr_gal(p_StartDate,p_StartShift)))
sel1
    left join DISPATCHER.dumptrucks d on d.vehid = sel1.vehid
where sel1.status_dumptruck = 'Разгрузка'
    and (sel1.eventdescr = 'Остановка' 
    or sel1.speed =0)
    and sel1.vehid like '%-CAT 777'

) sel1_1
GROUP by sel1_1.vehid,  sel1_1.time1, sel1_1.weight, sel1_1.eventdescr, sel1_1.vehtype
,sel1_1.geozone, sel1_1.shovelid, sel1_1.unloadid
, sel1_1.model1
) sel1_2

) sel2

--where sel2.timeload_f is not null
group by sel2.vehid, sel2.timeload_f , sel2.shovelid_f --, sel2_1.unloadid
, sel2.model1
order by sel2.vehid, sel2.timeload_f , sel2.shovelid_f --, sel2_1.unloadid;
) sel3
left join /*ugh.V_EVENTARCHIVE_CURR_GAL*/
(Select * 
from table (ugh.pac_trips.get_eventarchive_curr_gal(p_StartDate,p_StartShift))) sel2_1 
    on sel3.vehid = sel2_1.vehid and
    sel2_1.status_dumptruck ='Разгрузка'and
    sel3.timeunload = sel2_1.time
  ) loop
          pipe row (r_EVENTS_GEOZONES_TRIPS0);
   end loop;
   
  END get_EVENTS_GEOZONES_TRIPS0;
  
    function get_EVENTS_GEOZONES_TRIPS1 (p_StartDate date , p_StartShift integer) return t_EVENTS_GEOZONES_TRIPS0 pipelined AS
  BEGIN
      /*выборка ходок из событий "остановка" EVENTARCHIVE_CURR_GAL*/
for r_EVENTS_GEOZONES_TRIPS0 in
        ( 
    select sel4.vehid, sel4.model1, sel4.timeload , sel4.shovelid,sel4.timeunload,  sel4.unloadid, sel4.weight, sel4.worktype
from (
 select sel3.* 
    , sel2_1.unloadid
,
/*(case when sel3.shovelid is null then
(case when sel3.model1='777' then 90 
    else (case when sel3.model1='773' then 55
        else (case when sel3.model1='Volvo A40G' then 40
        else 25
    end)
    end)
end)
else*/
dispatcher.NORMS.TRIP_WEIGHT(sel3.shovelid,sel3.vehid,
ugh.F_GETDEFAULTWORKTYPE(sel2_1.unloadid)
,null,null,
sel3.timeunload
)
/*end)*/ as weight
,ugh.F_GETDEFAULTWORKTYPE(sel2_1.unloadid) as worktype

 from(
 select sel2.vehid
, sel2.model1
, sel2.timeload_f as timeload, sel2.shovelid_f as shovelid, min(sel2.time) as timeunload --, sel2.unloadid

from (
select sel1_2.*
,ugh.F_GETSHOVELIDFORUNLOAD(to_date(sel1_2.time,'dd.mm.yyyy hh24:mi:ss'),null,sel1_2.vehid)
as shovelid_f
,ugh.F_GETtimeloadFORUNLOAD(to_date(sel1_2.time,'dd.mm.yyyy hh24:mi:ss'),null,sel1_2.vehid)
as timeload_f
from(
select 
 sel1_1.vehid,  sel1_1.time1, sel1_1.weight, sel1_1.eventdescr, sel1_1.vehtype
,sel1_1.geozone, sel1_1.shovelid, sel1_1.unloadid
, sel1_1.model1

, min(sel1_1.time) as time
from (
select sel1.vehid,  substr(cast(sel1.time as varchar(20)),0,16) as time1, sel1.weight, sel1.eventdescr, sel1.vehtype
,sel1.geozone, sel1.shovelid, sel1.unloadid
, sel1.time
, substr(d.model,5,3) as model1
from /*ugh.V_EVENTARCHIVE_CURR_GAL*/
(Select * 
from table (ugh.pac_trips.get_eventarchive_curr_gal(p_StartDate,p_StartShift)))
sel1
    left join DISPATCHER.dumptrucks d on d.vehid = sel1.vehid
where sel1.status_dumptruck = 'Разгрузка'
    and (sel1.eventdescr = 'Остановка' 
    or sel1.speed =0)
    and (sel1.vehid like '%-CAT 777' /*or
        (sel1.vehid = '17' and d.model like '%777%')*/
        )
/*union
select sel1.vehid,  substr(cast(sel1.time as varchar(20)),0,16) as time1, sel1.weight, sel1.eventdescr, sel1.vehtype
,sel1.geozone, sel1.shovelid, sel1.unloadid
, sel1.time
, d.model as model1
from --ugh.V_EVENTARCHIVE_CURR_GAL_volvo
(Select * 
from table (ugh.pac_trips.get_eventarchive_curr_gal(p_StartDate,p_StartShift))) sel1
    left join DISPATCHER.dumptrucks d on d.vehid = sel1.vehid
where sel1.status_dumptruck = 'Разгрузка'
    and (sel1.eventdescr = 'Остановка' 
    or sel1.speed =0)
    */
) sel1_1
GROUP by sel1_1.vehid,  sel1_1.time1, sel1_1.weight, sel1_1.eventdescr, sel1_1.vehtype
,sel1_1.geozone, sel1_1.shovelid, sel1_1.unloadid
, sel1_1.model1
) sel1_2

) sel2

--where sel2.timeload_f is not null
group by sel2.vehid, sel2.timeload_f , sel2.shovelid_f --, sel2_1.unloadid
, sel2.model1
order by sel2.vehid, sel2.timeload_f , sel2.shovelid_f --, sel2_1.unloadid;
) sel3
left join --ugh.V_EVENTARCHIVE_CURR_GAL
(Select * 
from table (ugh.pac_trips.get_eventarchive_curr_gal(p_StartDate,p_StartShift))) sel2_1 
    on sel3.vehid = sel2_1.vehid and
    sel2_1.status_dumptruck ='Разгрузка'and
    sel3.timeunload = sel2_1.time
) sel4
group by sel4.vehid, sel4.model1, sel4.timeload , sel4.timeunload, sel4.shovelid, sel4.unloadid, sel4.weight, sel4.worktype
order by sel4.vehid, sel4.model1, sel4.timeload , sel4.timeunload, sel4.shovelid, sel4.unloadid, sel4.weight, sel4.worktype
 ) loop
          pipe row (r_EVENTS_GEOZONES_TRIPS0);
   end loop;
   
  END get_EVENTS_GEOZONES_TRIPS1;
  
END PAC_TRIPS;