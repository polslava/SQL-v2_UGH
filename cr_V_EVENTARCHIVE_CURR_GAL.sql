
  CREATE OR REPLACE FORCE VIEW "UGH"."V_EVENTARCHIVE_CURR_GAL" ("MESCOUNTER", "VEHID", "EVENTTIME", "EVENTGMTTIME", "X", "Y", "EVENTGROUP", "EVENTCODE", "EVENTDESCR", "TIMESYSTEM", "VEHTYPE", "VEHCODE", "EVENTTYPE", "TIME", "MOTOHOURS", "WEIGHT", "FUEL", "SPEED", "MESNUMBER", "GEOZONE", "SHOVELID", "UNLOADID", "STATUS_DUMPTRUCK", "TIME1") AS 
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
        , (case when ugh.f_getshovelidforpoint(e.x,e.y) is not null then 'Погрузка'
    else (case when ugh.f_getunloadidforpoint(e.x,e.y) is not null then 'Разгрузка'
    else null end)
    
end) as status_dumptruck
, substr(cast(e.time as varchar(20)),0,16) as time1
      FROM DISPATCHER.EVENTSTATEARCHIVE  E
           LEFT JOIN DISPATCHER.eventarchaddinfo eai ON e.addinfoid = eai.id
           LEFT JOIN DISPATCHER.constcodes cc
               ON cc.TABLENAME = 'EVENTSTATEARCHIVE' AND cc.code = e.eventtype
    WHERE e.vehid like '%1-CAT 777' or e.vehid like 'БелАЗ-%'
    and e.time BETWEEN sysdate -12/24 and sysdate +1/24 /*моя доработка 20230322*/
    /*getpredefinedtimefrom('за текущую смену', 1, sysDate)
               and getpredefinedtimeto('за текущую смену', 1, sysDate)  */
    and (cc.VALUE = 'Остановка' /*or e.speed =0*/);
