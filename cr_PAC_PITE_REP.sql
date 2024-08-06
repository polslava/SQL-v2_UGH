create or replace PACKAGE PAC_PITE_REP AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
  type r_Pite_PlanFact_Rep is record(
  ORDER1	CHAR(3),
DIVISION	VARCHAR2(15),
SECTION	VARCHAR2(24),
PLAN_D	NUMBER,
FACT_D	NUMBER,
PLAN_FACT_D	NUMBER,
D_PLAN_FACT_D	NUMBER,
PLANDATE1_D	VARCHAR2(10),
FACT_M	NUMBER,
PLAN_M	NUMBER,
PLAN_FACT_M	NUMBER,
D_PLAN_FACT_M	NUMBER);

type t_Pite_PlanFact_Rep is table of r_Pite_PlanFact_Rep;
function get_Pite_PlanFact_Rep (p_ReportDate date) return t_Pite_PlanFact_Rep pipelined;

END PAC_PITE_REP;

create or replace PACKAGE BODY PAC_PITE_REP AS

  function get_Pite_PlanFact_ReS (p_ReportDate date) return t_Pite_PlanFact_Rep pipelined AS
  BEGIN
    -- замена представления V_PITE_PLANFACT_REP_Sum для работы с разными датами
     for r_Pite_PlanFact_Rep in
        (
select 
'1.3' as "ORDER1", 'Всего' as "DIVISION", "SECTION", sum("PLAN_D") as PLAN_D
, sum("FACT_D") as FACT_D, 
round((sum("FACT_D")/ sum("PLAN_D"))*100,2) as PLAN_FACT_D
,round(( sum("FACT_D")/ sum("PLAN_D")-1)*100,2) as D_PLAN_FACT_D
,PLANDATE1_D
, sum("FACT_M") as FACT_M, sum("PLAN_M") as PLAN_M, 
round((sum(FACT_m)/ sum(PLAN_m))*100,2) as PLAN_FACT_m
,round(( sum(FACT_m)/ sum(PLAN_m)-1)*100,2) as D_PLAN_FACT_m
from V_PITE_PLANFACT_REP
where section = 'Горная масса' and division not like '%СтройКом%'
    and PLANDATE1_D<=to_char(p_ReportDate,'dd.mm.yyyy')
group by "SECTION", PLANDATE1_D
union
select 
'1.6' as "ORDER1", 'Всего' as "DIVISION", "SECTION", sum("PLAN_D") as PLAN_D
, sum("FACT_D") as FACT_D, 
round((sum("FACT_D")/ sum("PLAN_D"))*100,2) as PLAN_FACT_D
,round(( sum("FACT_D")/ sum("PLAN_D")-1)*100,2) as D_PLAN_FACT_D
,PLANDATE1_D
, sum("FACT_M") as FACT_M, sum("PLAN_M") as PLAN_M, 
round((sum(FACT_m)/ sum(PLAN_m))*100,2) as PLAN_FACT_m
,round(( sum(FACT_m)/ sum(PLAN_m)-1)*100,2) as D_PLAN_FACT_m
from V_PITE_PLANFACT_REP
where section = 'Руда на ГОК "Высочайший"'
    and PLANDATE1_D<=to_char(p_ReportDate,'dd.mm.yyyy')
group by "SECTION", PLANDATE1_D
union
select 
'2.5' as "ORDER1", 'Всего' as "DIVISION", "SECTION", sum("PLAN_D") as PLAN_D
, sum("FACT_D") as FACT_D, 
round((sum("FACT_D")/ sum("PLAN_D"))*100,2) as PLAN_FACT_D
,round(( sum("FACT_D")/ sum("PLAN_D")-1)*100,2) as D_PLAN_FACT_D
,PLANDATE1_D
, sum("FACT_M") as FACT_M, sum("PLAN_M") as PLAN_M, 
round((sum(FACT_m)/ sum(PLAN_m))*100,2) as PLAN_FACT_m
,round((sum(FACT_m)/ sum(PLAN_m)-1)*100,2) as D_PLAN_FACT_m
from V_PITE_PLANFACT_REP
where section = 'Бурение'
    and PLANDATE1_D<=to_char(p_ReportDate,'dd.mm.yyyy')

group by "SECTION", PLANDATE1_D
union
select 
'2.6' as "ORDER1", 'Всего' as "DIVISION", "SECTION", sum("PLAN_D") as PLAN_D
, sum("FACT_D") as FACT_D, 
0 as PLAN_FACT_D
,0 as D_PLAN_FACT_D
,PLANDATE1_D
, sum("FACT_M") as FACT_M, sum("PLAN_M") as PLAN_M, 
0 as PLAN_FACT_m
,0 as D_PLAN_FACT_m
from V_PITE_PLANFACT_REP
where section = 'Перебуры'
    and PLANDATE1_D<=to_char(p_ReportDate,'dd.mm.yyyy')

group by "SECTION", PLANDATE1_D
) loop
          pipe row (r_Pite_PlanFact_Rep);
   end loop;
   
  END get_Pite_PlanFact_ReS;

  function get_Pite_PlanFact_Rep (p_ReportDate date) return t_Pite_PlanFact_Rep pipelined AS
  BEGIN
    -- замена представления V_PITE_PLANFACT_REP для работы с разными датами
     for r_Pite_PlanFact_Rep in
        (
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
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Вскрыша', 'Балансовая руда', 'Перевалка балансовой руды', 'Кап. строительство') --Горная масса
        ) sel2
left join (
select sum(volume_fact) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(volume_fact)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(volume_fact)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_ugh
      where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
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
from V_PITE_PLANFACT_DAYS_tdfn ppdt
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Вскрыша', 'Балансовая руда', 'Перевалка балансовой руды', 'Кап. строительство') --Горная масса
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(value_fact_day)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_tdfn
     where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
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
from V_PITE_PLANFACT_DAYS_sk ppds
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Перевалка балансовой руды на ГОК "Высочайший"') --Горная масса
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
,(case when sum(value_plan_day)>0 then  round(sum(value_fact_day)/ sum(value_plan_day),2)*100 else 0 end) as plan_fact_m
, (case when sum(value_plan_day)>0 then round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 else 0 end) as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_sk
     where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
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
from V_PITE_PLANFACT_DAYS_tdfn ppdt
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Перевалка балансовой руды на ГОК "Высочайший"') --Горная масса
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
,(case when sum(value_plan_day)>0 then  round(sum(value_fact_day)/ sum(value_plan_day),2)*100 else 0 end) as plan_fact_m
, (case when sum(value_plan_day)>0 then round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 else 0 end) as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_tdfn
     where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
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
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Буровые работы (бурение скважин)') --Бурение
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(value_fact_day)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(value_fact_day)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_ugh
     where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
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
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Буровые работы (бурение скважин)') --Бурение
        ) sel2
left join (
select sum(volume_fact) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, round(sum(volume_fact)/ sum(value_plan_day),2)*100 as plan_fact_m
, round(sum(volume_fact)/ sum(value_plan_day)-1,2)*100 as d_plan_fact_m
,max(plandate1) as plandate1_m
from V_PITE_PLANFACT_DAYS_kvp
        where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
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
then to_char(p_ReportDate,'dd.mm.yyyy')
else max(plandate1) end)

as plandate1_d
from V_PITE_PLANFACT_DAYS_ugh ppdu
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Буровые работы (перебур)') --Перебуры
        ) sel2
left join (
select sum(value_fact_day) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, 0 /* round(sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as plan_fact_m
, 0 /*round(1- sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as d_plan_fact_m
,(case when 
max(plandate1) is null or substr(max(plandate1),0,2)<substr(to_char(p_ReportDate,'dd.mm.yyyy'),0,2)
then to_char(p_ReportDate,'dd.mm.yyyy')
else max(plandate1) end) as plandate1_m
from V_PITE_PLANFACT_DAYS_ugh
     where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
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
then to_char(p_ReportDate,'dd.mm.yyyy')
else max(plandate1) end)

as plandate1_d
from V_PITE_PLANFACT_DAYS_kvp ppdu
      where PLANDATE1=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Буровые работы (перебур)') --Перебуры
        ) sel2
left join (
select sum(volume_fact) as fact_m, sum(value_plan_day) as plan_m--, sum(volume_fact)
--, sum(volume_fact)/sum(value_plan_day)
, 0 /*round(sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as plan_fact_m
, 0 /*round(1- sum(value_fact_day)/ sum(value_plan_day),2)*100*/ as d_plan_fact_m
,(case when 
max(plandate1) is null or substr(max(plandate1),0,2)<substr(to_char(p_ReportDate,'dd.mm.yyyy'),0,2)
then to_char(p_ReportDate,'dd.mm.yyyy')
else max(plandate1) end) as plandate1_m
from V_PITE_PLANFACT_DAYS_kvp
      where PLANDATE1<=to_char(p_ReportDate,'dd.mm.yyyy')
        and worktype in ('Буровые работы (перебур)') --Перебуры
        ) sel1 on sel2.plandate1_d = sel1.plandate1_m
         ) loop
          pipe row (r_Pite_PlanFact_Rep);
   end loop;
   
  END get_Pite_PlanFact_Rep;

END PAC_PITE_REP;