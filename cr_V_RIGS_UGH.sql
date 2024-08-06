
  CREATE OR REPLACE FORCE VIEW "UGH"."V_RIGS_UGH" ("VEHID", "ENTERPRISEID", "DIVISIONID", "VEHTYPE", "ENTERPRISENAME", "DIVISIONNAME") AS 
  select sel1."VEHID",sel1."ENTERPRISEID",sel1."DIVISIONID",sel1."VEHTYPE",sel1."ENTERPRISENAME",sel1."DIVISIONNAME" from (
select 
    ev.*
    
    , e.enterprisename
    , d.divisionname
    from ugh.enterprise_veh ev
    left join DISPATCHER.enterprises e on e.enterpriseid = ev.enterpriseid
    left join DISPATCHER.divisions d on d.divisionid = ev.divisionid
    
) sel1
    left join rigs.rigs@rigs r on r.rigname = sel1.vehid
where sel1.enterprisename = 'ГОК "Угахан"' and sel1.divisionname is not null
    and vehtype = 'Бурстанок'
    and r.isfunctional = 1;
