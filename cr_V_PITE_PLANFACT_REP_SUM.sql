
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PITE_PLANFACT_REP_SUM" ("ORDER1", "DIVISION", "SECTION", "PLAN_D", "FACT_D", "PLAN_FACT_D", "D_PLAN_FACT_D", "PLANDATE1_D", "FACT_M", "PLAN_M", "PLAN_FACT_M", "D_PLAN_FACT_M") AS 
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
group by "SECTION", PLANDATE1_D;
