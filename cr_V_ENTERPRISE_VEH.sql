
  CREATE OR REPLACE FORCE VIEW "UGH"."V_ENTERPRISE_VEH" ("VEHID", "ENTERPRISEID", "DIVISIONID", "VEHTYPE", "ENTERPRISENAME", "DIVISIONNAME") AS 
  select "VEHID","ENTERPRISEID","DIVISIONID","VEHTYPE","ENTERPRISENAME","DIVISIONNAME" from (
select 
    ev.*
    , e.enterprisename
    , d.divisionname
    from ugh.enterprise_veh ev
    left join DISPATCHER.enterprises e on e.enterpriseid = ev.enterpriseid
    left join DISPATCHER.divisions d on d.divisionid = ev.divisionid
) sel1
where sel1.enterprisename is not null and sel1.divisionname is not null;
