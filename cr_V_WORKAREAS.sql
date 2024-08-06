
  CREATE OR REPLACE FORCE VIEW "UGH"."V_WORKAREAS" ("WORKAREAID", "WORKAREANAME", "GEOMETRY", "PARAMVALUE1", "AREAID") AS 
  select wa.workareaid, wa.workareaname
   /* ,regexp_count(wa.geometry,',')
    , INSTR(wa.geometry,'(')*/
    , wa.geometry,
    wa.paramvalue1
    ,wa.areaid
    
    from DISPATCHER.workareas wa
    where wa.isactual = 1
        and wa.geometry is not null
        and wa.areaid is not null;
