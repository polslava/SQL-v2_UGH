
  CREATE OR REPLACE FORCE VIEW "UGH"."V_EVENTS_GEOZONES_TRIPS1" ("VEHID", "MODEL1", "TIMELOAD", "TIMEUNLOAD", "SHOVELID", "UNLOADID", "WEIGHT", "WORKTYPE") AS 
  select sel4.vehid, sel4.model1, sel4.timeload , sel4.timeunload, sel4.shovelid, sel4.unloadid, sel4.weight, sel4.worktype
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
from ugh.V_EVENTARCHIVE_CURR_GAL sel1
    left join DISPATCHER.dumptrucks d on d.vehid = sel1.vehid
where sel1.status_dumptruck = 'Разгрузка'
    and (sel1.eventdescr = 'Остановка' 
    or sel1.speed =0)
    and (sel1.vehid like '%-CAT 777' 
        /* or (sel1.vehid = '17' and d.model like '%777%')*/
        )
union
select sel1.vehid,  substr(cast(sel1.time as varchar(20)),0,16) as time1, sel1.weight, sel1.eventdescr, sel1.vehtype
,sel1.geozone, sel1.shovelid, sel1.unloadid
, sel1.time
, d.model as model1
from ugh.V_EVENTARCHIVE_CURR_GAL_volvo sel1
    left join DISPATCHER.dumptrucks d on d.vehid = sel1.vehid
where sel1.status_dumptruck = 'Разгрузка'
    and (sel1.eventdescr = 'Остановка' 
    or sel1.speed =0)
    
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
left join ugh.V_EVENTARCHIVE_CURR_GAL sel2_1 
    on sel3.vehid = sel2_1.vehid and
    sel2_1.status_dumptruck ='Разгрузка'and
    sel3.timeunload = sel2_1.time
) sel4
group by sel4.vehid, sel4.model1, sel4.timeload , sel4.timeunload, sel4.shovelid, sel4.unloadid, sel4.weight, sel4.worktype
order by sel4.vehid, sel4.model1, sel4.timeload , sel4.timeunload, sel4.shovelid, sel4.unloadid, sel4.weight, sel4.worktype;
