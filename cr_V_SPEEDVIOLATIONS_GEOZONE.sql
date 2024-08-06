
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SPEEDVIOLATIONS_GEOZONE" ("VEHID", "VIOLTIME", "MAXSPEED", "MAXRAZRESHSPEED", "WEIGHT", "GEOZONE_NAME") AS 
  select VehID, ViolTime, MaxSpeed, MAXRAZRESHSPEED, weight --, x, y
, ugh.F_GETGEOZONEFORPOINT(x,y) as Geozone_name  /*моя доработка 20231003*/
   from (
   SELECT sd.VehID, sd.ViolTime, sd.Mins, sd.MaxSpeed, round(sd.mins*(sd.MaxSpeed + 35)/120, 2) as Length,  sd.Incline as Incline, sd.MAXRAZRESHSPEED
    , (case when v.weight is null then 0 else v.weight end) as weight --<!--Моя  доработка: 20220219-->
   , x, y
    FROM dispatcher.SpeedViolations sd
     left join dispatcher.vehtrips v --<!--Моя  доработка: 20220219-->
                on sd.vehid = v.vehid and
                    sd.VIOLTIME between v.timeload and v.timeunload
        WHERE
        /*sd.vehid like decode(:ParamVehID, 'Все', '%', :ParamVehID)
        and*/ 
        sd.VIOLTIME between
            SYSDATE - 10 and sysdate /*моя доработка 20231003*/
            /*getpredefinedtimefrom(:ParamDataFrom, :ParamShift, :ParamDate, :ParamDateBegin)
            and getpredefinedtimeto(:ParamDataFrom, :ParamShift, :ParamDate, :ParamDateEnd)*/
            
            and sd.vehid not like '%Volvo%' /*моя доработка 20231003*/
        ORDER BY LENGTH(sd.VehID), sd.VehID, sd.ViolTime
        ) sel1
        GROUP by VehID, ViolTime, MaxSpeed, MAXRAZRESHSPEED, weight, x, y;
