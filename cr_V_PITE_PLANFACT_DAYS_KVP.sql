
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PITE_PLANFACT_DAYS_KVP" ("ENTERPRISENAME", "VALUE_PLAN_DAY", "VALUE_FACT_DAY", "PLANDATE1", "WORKTYPE", "RESULT_AUTO_KVP", "PLAN_FACT", "VOLUME_FACT") AS 
  select "ENTERPRISENAME","VALUE_PLAN_DAY","VALUE_FACT_DAY","PLANDATE1",ppd."WORKTYPE"
 , result_auto_kvp
, round((case when result_auto_kvp=1 then
    (case when ppd.VALUE_PLAN_DAY > 0 and ppd.VALUE_PLAN_DAY is not null
                then 
                    (case when sel1.volume > 0 
                        then sel1.volume/ppd.VALUE_PLAN_DAY
                        else 0 /*sel2.length1/ppd.VALUE_PLAN_DAY*/ end)
               else 0
            end)
        else (case when ppd.VALUE_PLAN_DAY > 0 and ppd.VALUE_PLAN_DAY is not null
                then ppd.VALUE_FACT_DAY/ppd.VALUE_PLAN_DAY
                else 0
            end)
end),2) as plan_fact
 , round((case when sel1.volume > 0 
        then sel1.volume
        else 0 /*sel2.length1*/ end),2)
 as volume_fact
 
    from v_pite_planfact_days ppd
    left join 
        (select to_char(dateshift,'dd.mm.yyyy') as dateshift
            , sum(value_fact_m) as volume, worktype
            from v_rigs_value_kvp
            group by dateshift, worktype) sel1 
        on sel1.dateshift = ppd.plandate1 and sel1.worktype = ppd.worktype
   
   
    where ppd.enterprisename='КолымаВзрывПром'
        and to_date(ppd.PLANDATE1,'dd.mm.yyyy') between to_date('01.'||to_char((case when to_char(sysdate,'dd')='01' then
            sysdate-1 
            else sysdate end),'mm.yyyy'),'dd.mm.yyyy') and sysdate 
        and ppd.worktype in ('Буровые работы (бурение скважин)','Буровые работы (перебур)');
