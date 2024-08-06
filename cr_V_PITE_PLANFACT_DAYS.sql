
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PITE_PLANFACT_DAYS" ("ENTERPRISENAME", "VALUE_PLAN_DAY", "VALUE_FACT_DAY", "PLANDATE1", "WORKTYPE", "MEASUREID", "RESULT_AUTO_TDFN", "RESULT_AUTO_KVP", "RESULT_AUTO_UGH", "RESULT_AUTO_SK") AS 
  select sel1."ENTERPRISENAME",sel1."VALUE_PLAN_DAY",sel1."VALUE_FACT_DAY",sel1."PLANDATE1",sel1."WORKTYPE",sel1."MEASUREID"
        , m.result_auto_tdfn, m.result_auto_kvp, m.result_auto_ugh
        , m.result_auto_sk
from (
select enterprisename, sum(value_plan) as value_plan_day, sum(value_fact) as value_fact_day, to_char(plandate, 'dd.mm.yyyy') as plandate1, worktype
, pp.MEASUREID
    from v_pite_planfact pp
    where /*enterprisename like '%ФерроНордик%'*/
        
        plandate BETWEEN to_date('01'||'.'||to_char(
        (case when to_char(sysdate,'dd')='01' then
            sysdate-1 
            else sysdate end)
        
        ,'mm.yyyy'), 'dd.mm.yyyy')
            and to_date(TO_CHAR(LAST_DAY(sysdate ), 'DD')||'.'||to_char(
            sysdate ,'mm.yyyy'), 'dd.mm.yyyy')
    
    group by enterprisename, to_char(plandate, 'dd.mm.yyyy')
        , worktype
        , pp.MEASUREID) sel1
    left join ugh.measures m on m.id = sel1.measureid    
        
    order by enterprisename, plandate1;
