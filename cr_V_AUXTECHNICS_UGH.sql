
  CREATE OR REPLACE FORCE VIEW "UGH"."V_AUXTECHNICS_UGH" ("VEHID", "ENTERPRISEID", "DIVISIONID", "VEHTYPE", "ENTERPRISENAME", "DIVISIONNAME") AS 
  select sel1."VEHID",sel1."ENTERPRISEID",sel1."DIVISIONID",sel1."VEHTYPE",sel1."ENTERPRISENAME",sel1."DIVISIONNAME" from (
select 
    ev.*
    
    , e.enterprisename
    , d.divisionname
    from ugh.enterprise_veh ev
    left join DISPATCHER.enterprises e on e.enterpriseid = ev.enterpriseid
    left join DISPATCHER.divisions d on d.divisionid = ev.divisionid
    
) sel1
    left join DISPATCHER.auxtechnics a on a.auxid = sel1.vehid
where sel1.enterprisename = '��� "������"' and sel1.divisionname is not null
    and vehtype = '���������.'
    and a.isfunctional = 1;
