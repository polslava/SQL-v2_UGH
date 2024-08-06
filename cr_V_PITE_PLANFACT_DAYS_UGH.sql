
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PITE_PLANFACT_DAYS_UGH" ("ENTERPRISENAME", "VALUE_PLAN_DAY", "VALUE_FACT_DAY", "PLANDATE1", "WORKTYPE", "RESULT_AUTO_UGH", "VOLUME_FACT", "PLAN_FACT") AS 
  select "ENTERPRISENAME","VALUE_PLAN_DAY","VALUE_FACT_DAY","PLANDATE1","WORKTYPE"
, result_auto_ugh 
/*,sel1.volume
        ,sel2.length1*/
, (case when result_auto_ugh=1 then
round((case when sel1.volume > 0 
        then sel1.volume
        else sel2.length1 end),2)
        else 0
end) as volume_fact
, round((case when result_auto_ugh=1 then
    (case when ppd.VALUE_PLAN_DAY > 0 and ppd.VALUE_PLAN_DAY is not null
                then 
                    (case when sel1.volume > 0 
                        then sel1.volume/ppd.VALUE_PLAN_DAY
                        else sel2.length1/ppd.VALUE_PLAN_DAY end)
                    
                    
                else 0
            end)
        else (case when ppd.VALUE_PLAN_DAY > 0 and ppd.VALUE_PLAN_DAY is not null
                then ppd.VALUE_FACT_DAY/ppd.VALUE_PLAN_DAY
                else 0
            end)
end),2) as plan_fact

    from v_pite_planfact_days ppd
    left join 
        (select /*to_char(*/taskdate /*, 'dd.mm')*/ as taskdate1, sum(weight/2.7) as volume , worktype1
            from v_shiftreportsadv_month_works
            where taskDATE between to_date('01.'||to_char((case when to_char(sysdate,'dd')='01' then
            sysdate-1 
            else sysdate end),'mm.yyyy'),'dd.mm.yyyy') and sysdate
                --and worktype1 in ('Вскрыша' ,'Балансовая руда')
            group by taskdate, worktype1) sel1 
        on sel1.taskdate1 = ppd.plandate1 and sel1.worktype1 = ppd.worktype
    left join 
        (select /*to_char(*/taskdate /*, 'dd.mm')*/ as taskdate1, (sum(lengthmanual*tripnumbermanual)/sum(tripnumbermanual))*1000 as length1
            from v_shiftreportsadv_month_works
            where taskDATE between to_date('01.'||to_char((case when to_char(sysdate,'dd')='01' then
            sysdate-1 
            else sysdate end),'mm.yyyy'),'dd.mm.yyyy') and sysdate
                --and worktype1 in ('Вскрыша' ,'Балансовая руда')
            group by taskdate --, worktype1
            ) sel2 
        on sel2.taskdate1 = ppd.plandate1 and ppd.worktype='Откатка'
    where enterprisename='ГОК "Угахан"'
    and to_date(ppd.PLANDATE1,'dd.mm.yyyy') between to_date('01.'||to_char((case when to_char(sysdate,'dd')='01' then
            sysdate-1 
            else sysdate end),'mm.yyyy'),'dd.mm.yyyy') and sysdate;
