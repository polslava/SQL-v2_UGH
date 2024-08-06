
  CREATE OR REPLACE FORCE VIEW "UGH"."V_REFUELS" ("REFUELERCOUNTER", "REFUELLERID", "REFUELLERNUMBERID", "TIMEBEGIN", "TIMEEND", "GMT_TIMEBEGIN", "GMT_TIMEEND", "VEHID", "RX", "RY", "VX", "VY", "FUEL", "TANKNUMBER", "FUELID", "VEHFUELREST", "WEIGHT", "TEMPERATURE", "VEHTYPE", "ZONE1") AS 
  select r."REFUELERCOUNTER",r."REFUELLERID",r."REFUELLERNUMBERID",r."TIMEBEGIN",r."TIMEEND",r."GMT_TIMEBEGIN",r."GMT_TIMEEND",r."VEHID",r."RX",r."RY",r."VX",r."VY",r."FUEL",r."TANKNUMBER",r."FUELID",r."VEHFUELREST",r."WEIGHT",r."TEMPERATURE",r."VEHTYPE", ugh.f_getgeozoneforpoint(rx, ry) as ZONE1
from 
dispatcher.REFUELLERDETECTEDREFUELITOG r
where r.timebegin
  BETWEEN dispatcher.GetPredefinedTimeFrom ( 'за текущую смену' , 1 , SYSDATE,  sysdate)                 
    AND dispatcher.GetPredefinedTimeTo (  'за текущую смену' , 1 , SYSDATE,  sysdate);
