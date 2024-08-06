
  CREATE OR REPLACE FORCE VIEW "UGH"."V_WELLS" ("BLOCKID", "WELLID", "DEPTH_PLAN", "DEPTH_FACT", "DEPTH", "TIMEBEGIN", "TIMEEND", "RIGID", "BLOCK_NAME", "RIGNAME") AS 
  select "BLOCKID","WELLID","DEPTH_PLAN","DEPTH_FACT"
,(case when abs(DEPTH_FACT/DEPTH_PLAN)<0.85 then DEPTH_PLAN else DEPTH_FACT end) as depth
,"TIMEBEGIN","TIMEEND","RIGID","BLOCK_NAME","RIGNAME" 
from ugh.v_wells@rigs
where TIMEBEGIN between 
     getpredefinedtimefrom('за текущую смену', 1, sysDate)
               and getpredefinedtimeto('за текущую смену', 1, sysDate);
