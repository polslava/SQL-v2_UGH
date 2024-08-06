
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PITE_PLANFACT_REP" ("ORDER1", "DIVISION", "SECTION", "PLAN_D", "FACT_D", "PLAN_FACT_D", "D_PLAN_FACT_D", "PLANDATE1_D", "FACT_M", "PLAN_M", "PLAN_FACT_M", "D_PLAN_FACT_M") AS 
  select 
'1.1' as order1
,'Угахан' as division
,'Горная масса' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select 
--sum(value_fact_day) , 
sum(value_plan_day) as plan_d 
, sum(volume_fact) as fact_d
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(volume_fact)/ sum(value_plan_day),2)*100 as plan_fact_d
, round( sum(volume_fact)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_d
,max(plandate1) as plandate1_d
from V_PITE_PLANFACT_DAYS_ugh ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Вскрыша', 'Балансовая руда', 'Перевалка балансовой руды', 'Кап. строительство') --Горная масса
        ) sel2
left join (
select sum(volume_fact) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(volume_fact)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(volume_fact)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_ugh
      where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Вскрыша', 'Балансовая руда', 'Перевалка балансовой руды', 'Кап. строительство') --Горная масса
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
union

select 
'1.2' as order1
,'ФерроНордик' as division
,'Горная масса' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select sum(value_fact_day) as fact_d, sum(value_plan_day) as plan_d 
--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(value_fact_day)/ sum(value_plan_day),2)*100 as plan_fact_d
, round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_d
,max(plandate1) as plandate1_d
from V_PITE_PLANFACT_DAYS_tdfn ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Вскрыша', 'Балансовая руда', 'Перевалка балансовой руды', 'Кап. строительство') --Горная масса
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(value_fact_day)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_tdfn
     where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Вскрыша', 'Балансовая руда', 'Перевалка балансовой руды', 'Кап. строительство') --Горная масса
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
union

select 
'1.4' as order1
,'СтройКом' as division
,'Руда на ГОК "Высочайший"' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select sum(value_fact_day) as fact_d, sum(value_plan_day) as plan_d 
--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, (case when sum(value_plan_day) > 0 then round(sum(value_fact_day)/ sum(value_plan_day),2)*100 else 0 end) as plan_fact_d
, (case when sum(value_plan_day)>0 then round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 else 0 end) as d_plan_fact_d
,max(plandate1) as plandate1_d
from V_PITE_PLANFACT_DAYS_sk ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Перевалка балансовой руды на ГОК "Высочайший"') --Горная масса
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
,(case when sum(value_plan_day)>0 then  round(sum(value_fact_day)/ sum(value_plan_day),2)*100 else 0 end) as plan_fact_m
, (case when sum(value_plan_day)>0 then round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 else 0 end) as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_sk
     where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Перевалка балансовой руды на ГОК "Высочайший"') --Горная масса
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
union

select 
'1.5' as order1
,'ФерроНордик' as division
,'Руда на ГОК "Высочайший"' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select sum(value_fact_day) as fact_d, sum(value_plan_day) as plan_d 
--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, (case when sum(value_plan_day) > 0 then round(sum(value_fact_day)/ sum(value_plan_day),2)*100 else 0 end) as plan_fact_d
, (case when sum(value_plan_day)>0 then round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 else 0 end) as d_plan_fact_d
,max(plandate1) as plandate1_d
from V_PITE_PLANFACT_DAYS_tdfn ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Перевалка балансовой руды на ГОК "Высочайший"') --Горная масса
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
,(case when sum(value_plan_day)>0 then  round(sum(value_fact_day)/ sum(value_plan_day),2)*100 else 0 end) as plan_fact_m
, (case when sum(value_plan_day)>0 then round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 else 0 end) as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_tdfn
     where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Перевалка балансовой руды на ГОК "Высочайший"') --Горная масса
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
union
select 
'2.1' as order1
,'Угахан' as division
,'Бурение' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select 
sum(value_plan_day) as plan_d 
, sum(value_fact_day) as fact_d
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(value_fact_day)/ sum(value_plan_day),2)*100 as plan_fact_d
, round( sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_d
,max(plandate1) as plandate1_d
from V_PITE_PLANFACT_DAYS_ugh ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (бурение скважин)') --Бурение
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(value_fact_day)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_ugh
     where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (бурение скважин)') --Бурение
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
union
select 
'2.3' as order1
,'КолымаВзрывПром' as division
,'Бурение' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select 
sum(value_plan_day) as plan_d 
, sum(volume_fact) as fact_d
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(volume_fact)/ sum(value_plan_day),2)*100 as plan_fact_d
, round( sum(volume_fact)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_d
,max(plandate1) as plandate1_d
from V_PITE_PLANFACT_DAYS_kvp ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (бурение скважин)') --Бурение
        ) sel2
left join (
select sum(volume_fact) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(volume_fact)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(volume_fact)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_kvp
        where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (бурение скважин)') --Бурение
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
union
select 
'2.2' as order1
,'Угахан' as division
,'Перебуры' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select 
sum(value_plan_day) as plan_d 
, sum(value_fact_day) as fact_d
--, sum(volume_fact)/sum(value_plan_day)
, 0 /*round(sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as plan_fact_d
, 0 /*round(1- sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as d_plan_fact_d
,(case when 
max(plandate1) is null 
then to_char(sysdate-1,'dd.mm.yyyy')
else max(plandate1) end)

as plandate1_d
from V_PITE_PLANFACT_DAYS_ugh ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (перебур)') --Перебуры
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, 0 /* round(sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as plan_fact_m
, 0 /*round(1- sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as d_plan_fact_m
,(case when 
max(plandate1) is null or substr(max(plandate1),0,2)<substr(to_char(sysdate-1,'dd.mm.yyyy'),0,2)
then to_char(sysdate-1,'dd.mm.yyyy')
else max(plandate1) end) as plandate1_m
from V_PITE_PLANFACT_DAYS_ugh
     where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (перебур)') --Перебуры
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
union
select 
'2.4' as order1
,'КолымаВзрывПром' as division
,'Перебуры' as section
, sel2."PLAN_D",sel2."FACT_D",sel2."PLAN_FACT_D",sel2."D_PLAN_FACT_D",sel2."PLANDATE1_D"
, sel1.fact_m, sel1.plan_m, sel1.plan_fact_m, sel1.d_plan_fact_m
from (
select 
sum(value_plan_day) as plan_d 
, sum(volume_fact) as fact_d
--, sum(volume_fact)/sum(value_plan_day)
, 0 /*round(sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as plan_fact_d
, 0 /*round(1- sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as d_plan_fact_d
,
(case when 
max(plandate1) is null 
then to_char(sysdate-1,'dd.mm.yyyy')
else max(plandate1) end)

as plandate1_d
from V_PITE_PLANFACT_DAYS_kvp ppdu
      where PLANDATE1=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (перебур)') --Перебуры
        ) sel2
left join (
select sum(volume_fact) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, 0 /*round(sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as plan_fact_m
, 0 /*round(1- sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as d_plan_fact_m
,(case when 
max(plandate1) is null or substr(max(plandate1),0,2)<substr(to_char(sysdate-1,'dd.mm.yyyy'),0,2)
then to_char(sysdate-1,'dd.mm.yyyy')
else max(plandate1) end) as plandate1_m
from V_PITE_PLANFACT_DAYS_kvp
      where PLANDATE1<=to_char(sysdate-1,'dd.mm.yyyy')
        and worktype in ('Буровые работы (перебур)') --Перебуры
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m;
