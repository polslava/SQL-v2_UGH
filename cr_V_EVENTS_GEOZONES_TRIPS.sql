
  CREATE OR REPLACE FORCE VIEW "UGH"."V_EVENTS_GEOZONES_TRIPS" ("VEHID", "TIMELOAD", "SHOVELID", "TIMEUNLOAD", "UNLOADID", "WEIGHT", "WORKTYPE") AS 
  select sel2.vehid, sel2.timeload_f as timeload, sel2.shovelid_f as shovelid, min(sel2.time) as timeunload, sel2.unloadid
,
dispatcher.NORMS.TRIP_WEIGHT(sel2.shovelid_f,sel2.vehid,
ugh.F_GETDEFAULTWORKTYPE(sel2.unloadid)
,null,null,
min(sel2.time)
) as weight
,ugh.F_GETDEFAULTWORKTYPE(sel2.unloadid) as worktype
from (

select sel1.vehid,  sel1.time, sel1.weight, sel1.eventdescr, sel1.vehtype
,sel1.geozone, sel1.shovelid, sel1.unloadid
--, ugh.F_GETUNLOADIDFORPOINT(sel1.time, '', sel1.vehid)
,ugh.F_GETSHOVELIDFORUNLOAD(to_date(sel1.time,'dd.mm.yyyy hh24:mi:ss'),null,sel1.vehid)
as shovelid_f
,ugh.F_GETtimeloadFORUNLOAD(to_date(sel1.time,'dd.mm.yyyy hh24:mi:ss'),null,sel1.vehid)
as timeload_f
from ugh.V_EVENTARCHIVE_CURR_GAL sel1
where sel1.status_dumptruck = 'Разгрузка'
    and sel1.eventdescr = 'Остановка' /*отдельно разобраться когда скорость 0, но нет события Остановка*/

) sel2
--where sel2.timeload_f is not null
group by sel2.vehid, sel2.timeload_f , sel2.shovelid_f , sel2.unloadid
order by sel2.vehid, sel2.timeload_f , sel2.shovelid_f , sel2.unloadid;
