
  CREATE OR REPLACE FORCE VIEW "UGH"."V_RIGS_VALUE_SHIFT" ("DATESHIFT", "SHIFT", "WORKTYPE", "VALUE_FACT_M", "VALUE_FACT_HOLE", "RIGNAME", "BLOCK_NAME", "ENTERPRISENAME", "DIVISIONNAME") AS 
  select rv.DATESHIFT ,SHIFT 
    , rv.WORKTYPE /*,VALUE_PLAN_M*/
    , sum(rv.VALUE_FACT_M) as VALUE_FACT_M
    /*,  MEASUREID*/
    , sum(rv.VALUE_FACT_HOLE) as VALUE_FACT_HOLE
    ,rv.RIGNAME  
    , rv.BLOCK_NAME
    , ev.enterprisename, ev.divisionname
    from ugh.V_RIGS_VALUE@rigs rv
        left join v_enterprise_veh ev 
            on ev.vehid = rv.rigname and ev.vehtype = 'Бурстанок'
            
    group by rv.DATESHIFT,SHIFT,rv.WORKTYPE , rv.RIGNAME  ,   rv.BLOCK_NAME, ev.enterprisename, ev.divisionname;
