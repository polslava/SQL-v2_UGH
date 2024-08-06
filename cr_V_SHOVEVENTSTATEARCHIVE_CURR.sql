
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHOVEVENTSTATEARCHIVE_CURR" ("EVENTCOUNTER", "SHOVID", "EVENTTYPE", "TIME", "GMTTIME", "X", "Y", "SYSTEMTIME", "FUEL", "BUCKETS", "SPEED", "MOTOHOURS", "Z", "GPSQUAL") AS 
  select "EVENTCOUNTER","SHOVID","EVENTTYPE","TIME","GMTTIME","X","Y","SYSTEMTIME","FUEL","BUCKETS","SPEED","MOTOHOURS","Z","GPSQUAL" 
    from DISPATCHER.shoveventstatearchive
    where time  BETWEEN 
        getpredefinedtimefrom('за текущую смену', 1, sysDate)
               and getpredefinedtimeto('за текущую смену', 1, sysDate)
        and shovid in (select shovID from v_shovels_in_shift
                        )
        
    and SPEED=0;
