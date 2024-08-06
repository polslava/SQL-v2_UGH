
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PITE_PLANFACT_DAYS_TDFN" ("ENTERPRISENAME", "VALUE_PLAN_DAY", "VALUE_FACT_DAY", "PLANDATE1", "WORKTYPE", "RESULT_AUTO_TDFN", "PLAN_FACT") AS 
  select "ENTERPRISENAME","VALUE_PLAN_DAY","VALUE_FACT_DAY","PLANDATE1","WORKTYPE"
 , result_auto_tdfn
 , round(
 (case when ppd.VALUE_PLAN_DAY > 0 and ppd.VALUE_PLAN_DAY is not null
                then ppd.VALUE_FACT_DAY/ppd.VALUE_PLAN_DAY
                else 0
            end)
,2) as plan_fact

    from v_pite_planfact_days ppd
   
    where ppd.enterprisename like '%ФерроНордик%'
        and to_date(ppd.PLANDATE1,'dd.mm.yyyy') between to_date('01.'||to_char( 
        (case when to_char(sysdate,'dd')='01' then
            sysdate-1 
            else sysdate end),'mm.yyyy'),'dd.mm.yyyy') and sysdate;
