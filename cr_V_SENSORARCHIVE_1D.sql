
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SENSORARCHIVE_1D" ("ID", "VEHID", "VEHTYPE", "GMTTIME", "SENSORID", "MINSENSORVALUE", "AVGSENSORVALUE", "MAXSENSORVALUE", "PERIODSECONDS", "DESCR_RU", "TIME", "SHIFTNUM", "SHIFTDATE") AS 
  select sa."ID",sa."VEHID",sa."VEHTYPE",sa."GMTTIME",sa."SENSORID",sa."MINSENSORVALUE",sa."AVGSENSORVALUE",sa."MAXSENSORVALUE",sa."PERIODSECONDS" 
    , st.descr_ru
    , gmt_to_local(sa.gmttime) as time
    , getcurshiftnum(1,gmt_to_local(sa.gmttime) ) as shiftnum
    , getcurshiftdate(1, gmt_to_local(sa.gmttime)) as shiftdate
    from DISPATCHER.sensorarchive sa
        left join DISPATCHER.sensortypes st
            on st.id = sa.sensorid
    where sa.gmttime between sysdate-1 and sysdate+1;
