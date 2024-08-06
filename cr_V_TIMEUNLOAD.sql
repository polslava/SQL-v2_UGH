
  CREATE OR REPLACE FORCE VIEW "UGH"."V_TIMEUNLOAD" ("ISFUNCTIONAL", "VEHTYPE", "VEHID", "CONTROLID", "MDATA", "REAL", "INTERVAL", "DT", "DT_1", "DESCR", "STATUS", "SPEED", "FUEL", "WEIGHT", "Z", "ZONE1", "UNLOADID1", "SHOVELID1", "TSNAME", "STOPPAGETYPE", "TIMESTOP", "TIMEGO", "DT_TIMESTOP", "DT_TIMEGO", "STATUS_ONLINE", "STATUS_ONLINE1", "FUEL_PERCENT", "X", "Y", "ENTERPRISENAME", "DIVISIONNAME", "AREA1") AS 
  select avt.isfunctional
,sel1.VEHTYPE,sel1.VEHID,sel1.CONTROLID,sel1.MDATA,sel1.REAL,sel1.INTERVAL,sel1.DT,sel1.DT_1
,sel1.DESCR,sel1.STATUS,sel1.SPEED,sel1.FUEL,sel1.WEIGHT,sel1.Z
,sel1.Zone1,sel1.UNLOADID1,sel1.SHOVELID1,sel1.TSNAME
, nvl(sel1.stoppagetype, ' на линии') as stoppagetype/*Моя  доработка: 20220625*/
, sel1.timestop, sel1.timego
, round(( sysdate-sel1.timestop)*24,1) as dt_timestop
, round((sel1.timego - sysdate)*24,1) as dt_timego

,(case when sel1.dt_1 < 1 then '0. онлайн' else 
(case when sel1.dt_1 between 1 and 10 then '1. онлайн <10мин' else 
(case when sel1.dt_1 between 10 and 60 then '2. онлайн <1ч' else 
(case when sel1.dt_1 between 60 and 1440 then '3. онлайн <24ч' else 
'4. вне сети' end)end)end)end) as status_online,
(case when sel1.dt_1 < 1 then '1' else 
(case when sel1.dt_1 between 1 and 10 then '10' else 
(case when sel1.dt_1 between 10 and 60 then '60' else 
(case when sel1.dt_1 between 60 and 1440 then '1440' else 
'0' end)end)end)end) as status_online1  /*Моя  доработка: 20220625*/
, fp.fuel_percent   /*Моя  доработка: 20230105*/
,x,y /*Моя  доработка: 20230108*/
, e.enterprisename /*Моя  доработка: 20230129*/
, d.divisionname /*Моя  доработка: 20230129*/
, Area1 /*Моя  доработка: 20230419*/
from ugh.ALLVEHICLES_ts avt
inner join (
select                
      decode(t.vehtype, 'Нетех.', 'Нетехнология', 'Вспомогат.', 'Бульдозер', t.vehtype) as                vehtype,            
      t.vehid as vehid,                 
      t.controlid as controlid,                  
      mdata, real,                   
      interval, dt,                  
      dt_1, /*Моя  доработка: 20220320*/                  
      DESCR                   
      , (case when speed > 0 and weight >0 then 'В движении, гружённый'                   
      else (case when speed > 0 and weight =0 then 'В движении,порожний'                     
      else (case when speed > 0 then 'В движении'                            
      else (case when speed /*&lt;*/< 1 and weight >0 then 'Стоянка, гружённый'                                
      else (case when speed /*&lt;*/< 1 and weight =0 then 'Стоянка, порожний'                                    
      else (case when speed /*&lt;*/< 1 then 'Стоянка'                                   
      else 'Неопределённый'                                    
      end)                                    
      end)                               
      end)                            
      end)                          
      end)                      
      end) as status  /*Моя  доработка: 20220321*/  , speed, fuel, weight, z /*Моя  доработка: 20220217*/ 
      ,Zone1 /*Моя  доработка: 20220615*/
      ,UnloadID1 /*Моя  доработка: 20220616*/
      ,ShovelID1 /*Моя  доработка: 20220616*/
      , tsname /*Моя  доработка: 20220617*/
      , stopsel.stoppagetype /*Моя  доработка: 20220625*/
      , stopsel.timestop, stopsel.timego
      ,x,y /*Моя  доработка: 20230108*/
      , Area1 /*Моя  доработка: 20230419*/
      from(            
      SELECT  sel1.vehid vehid, controlid, MData, Real, interval, round(dt*24*60) dt,round(dt_1*24*60) dt_1,
      /*Моя  доработка: 20220320*/sel1.vehtype vehtype            
      , speed, fuel, weight, z /*Моя  доработка: 20220217*/    
      ,Zone1 /*Моя  доработка: 20220615*/
      ,UnloadID1 /*Моя  доработка: 20220616*/
      ,ShovelID1 /*Моя  доработка: 20220616*/
      , av.tsname /*Моя  доработка: 20220617*/
      ,x,y /*Моя  доработка: 20230108*/
      , Area1 /*Моя  доработка: 20230419*/
      FROM ( SELECT VEHID,        
      EVENTTIME AS MDATA,        
      SYSTEMTIME AS REAL,        
      dispatcher.MINTOHOURMIN(GREATEST((EVENTTIME - SYSDATE) * (-24 * 60) - 0.5, 0)) AS INTERVAL,       
      GREATEST((SYSDATE - EVENTTIME), 0) AS DT,        
      GREATEST((SYSDATE - SYSTEMTIME), 0) AS DT_1,/*Моя  доработка: 20220320*/        
      VEHTYPE        
      , speed, fuel, weight, z /*Моя  доработка: 20220217*/
      , UGH.f_getgeozoneforpoint(x, y) as Zone1 /*Моя  доработка: 20220615*/
      , ugh.F_GETUNLOADIDFORPOINT(x, y) as UnloadID1 /*Моя  доработка: 20220616*/
      , ugh.F_GETShovelIDFORPOINT(x, y) as ShovelID1 /*Моя  доработка: 20220616*/
      ,x,y /*Моя  доработка: 20230108*/
      , UGH.f_getgeozoneforpoint_areas(x, y) as Area1 /*Моя  доработка: 20230419*/
      FROM dispatcher.EVENTOUT_ADVANCED  )sel1
          left join ugh.ALLVEHICLES_ts av on av.vehid = sel1.vehid and av.vehtype = sel1.vehtype     
          ) t  left join     
          (select vehtype, controlid, stt.name||' с '||replace(to_char(timestop,'dd.mm.yyyy hh24-mi')||' по '||to_char(timego,'dd.mm.yyyy hh24-mi'),'-',':') descr 
          , stt.stoppagetype /*Моя  доработка: 20220625*/
          , timestop, timego
          from (  
            select ust.name, 'Экскаватор' vehtype, sh.controlid, mstp.timestop, mstp.timego 
            ,ustc.name as stoppagetype /*Моя  доработка: 20220625*/
          from dispatcher.manualstoppages_shov mstp
          inner 
          join dispatcher.userstoppagetypes_shovels ust on ust.code=mstp.typeid
          inner 
          join dispatcher.shovels sh on sh.shovid=mstp.vehid 
          left join dispatcher.repairsheets_shov rss on rss.rscounter = mstp.repairsheetcounter /*Моя  доработка: 20220625*/
        left join dispatcher.userstoppagecategories_shovels ustc on ustc.id = ust.categoryid /*Моя  доработка: 20220625*/
          where sysdate between timestop and timego

          union
          select ust.name, 
          'Самосвал' vehtype,  dt.controlid, timestop, timego 
           ,ustc.name as stoppagetype /*Моя  доработка: 20220625*/
          from dispatcher.manualstoppages  mstp 
          inner 
          join dispatcher.userstoppagetypes ust on ust.code=mstp.typeid
          inner 
          join dispatcher.dumptrucks dt on dt.vehid=mstp.vehid 
                    left join dispatcher.repairsheets rss on rss.rscounter = mstp.repairsheetcounter /*Моя  доработка: 20220625*/
          left join dispatcher.userstoppagecategories ustc on ustc.id = ust.categoryid /*Моя  доработка: 20220625*/
          where sysdate between timestop and timego 
          
          union 
          select ust.name, 'Бульдозер' vehtype, 
          (select controlid 
          from dispatcher.auxtechnics where auxid=mstp.vehid) controlid, timestop, timego 
          ,ustc.name as stoppagetype /*Моя  доработка: 20220625*/
          from dispatcher.manualstoppages_aux mstp
          inner 
          join dispatcher.userstoppagetypes_aux ust on ust.code=mstp.typeid 
                      left join dispatcher.repairsheets_aux rss on rss.rscounter = mstp.repairsheetcounter /*Моя  доработка: 20220625*/
            left join dispatcher.userstoppagecategories_aux ustc on ustc.id = ust.categoryid /*Моя  доработка: 20220625*/
          where sysdate between timestop and timego 
    
          )stt 
          union  
          select 'Бульдозер', aux.controlid,   
          'Рядом с '||        
          (case when ape.near_shovel is null then null else ape.near_shovel||',' end)
          ||(case when ape.near_unload is null then null else ape.near_unload ||','end)       
          ||ape.near_staticobject    as descr    
        , '' as stoppagetype, null, null
          from dispatcher.auxstat_po_event ape    
          left join dispatcher.auxtechnics aux on aux.auxid = ape.auxid 
          where ape.near_shovel||ape.near_unload||ape.near_staticobject is not null ) stopsel 
          on stopsel.controlid=t.controlid) sel1
    on sel1.tsname=avt.tsname and sel1.vehid=avt.vehid
    left join v_fuel_percent fp /*Моя  доработка: 20230105*/
        on (fp.vehtype = sel1.VEHTYPE and fp.vehid = sel1.VEHID)
    left join ugh.enterprise_veh ev  /*Моя  доработка: 20230129*/
        on ev.vehid = avt.vehid and ev.vehtype = avt.vehtype
    left join DISPATCHER.enterprises e  /*Моя  доработка: 20230129*/
        on e.enterpriseid = ev.enterpriseid
    left join DISPATCHER.divisions d on d.divisionid = ev.divisionid  /*Моя  доработка: 20230129*/
order by controlid;
