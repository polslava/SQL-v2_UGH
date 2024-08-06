
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SIMPLETRANSITIONS" ("VEHID", "TIMEGO", "TIMESTOP", "XGO", "YGO", "XSTOP", "YSTOP", "MOVELENGTH", "WEIGHT", "FUELSTOP", "MAXSPEED", "AVGSPEED") AS 
  select 
vehid, timego, timestop, xgo, ygo, xstop, ystop, movelength,weight, fuelstop, maxspeed, avgspeed
 from DISPATCHER.simpletransitions
where timego between sysdate-2 and sysdate;
