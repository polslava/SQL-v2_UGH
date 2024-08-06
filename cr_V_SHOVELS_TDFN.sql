
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHOVELS_TDFN" ("VEHID", "ENTERPRISEID", "DIVISIONID", "VEHTYPE", "ENTERPRISENAME", "DIVISIONNAME") AS 
  select sel1."VEHID",sel1."ENTERPRISEID",sel1."DIVISIONID",sel1."VEHTYPE",sel1."ENTERPRISENAME",sel1."DIVISIONNAME" from (
select 
    ev.*
    
    , e.enterprisename
    , d.divisionname
    from ugh.enterprise_veh ev
    left join DISPATCHER.enterprises e on e.enterpriseid = ev.enterpriseid
    left join DISPATCHER.divisions d on d.divisionid = ev.divisionid
    
) sel1
    left join dispatcher.shovels s on s.shovid = sel1.vehid
where sel1.enterprisename = 'ТД "ФерроНордик"' and sel1.divisionname is not null
    and vehtype = 'Экскаватор'
    and s.isfunctional = 1;
