
  CREATE OR REPLACE FORCE VIEW "UGH"."ALLVEHICLES_TS" ("VEHID", "MODEL", "POST", "VEHTYPE", "TSNAME", "GOSNUMBER", "VEHCODE", "IPAN", "OVEN", "GALILEOSKY", "ISFUNCTIONAL", "CONTROLID") AS 
  select dt.vehid, dt.model, post, 'Самосвал' as vehtype, ugh.get_veh_tsname(dt.vehid,'Самосвал') as tsname, dt.gosnumber, id as vehcode
    ,iPan, Oven, GalileoSky, ISFUNCTIONAL, controlid
    from dispatcher.dumptrucks dt

  union
  select sh.shovid,sh.model, post, 'Экскаватор' as vehtype, ugh.get_veh_tsname(sh.shovid,'Экскаватор') as tsname, sh.gosnumber, id as vehcode
    ,iPan, Oven, GalileoSky, ISFUNCTIONAL, controlid
    from dispatcher.shovels sh
  union
  select bull.auxid as vehid, bull.model, post, 'Вспомогат.' as vehtype, ugh.get_veh_tsname(bull.auxid,'Вспомогат.') as tsname, bull.gosnum as gosnumber, 0 as vehcode
    ,0,0,galileosky,1, controlid
    from dispatcher.auxtechnics bull
  union
  select nt.nontechid as vehid, nt.model, post, 'Нетех.' as vehtype, ugh.get_veh_tsname(nt.nontechid,'Нетех.') as tsname, nt.gosnumber, 0 as vehcode
    ,iPan, Oven, GalileoSky, ISFUNCTIONAL, controlid
    from dispatcher.nontechvehicles nt
  union
  select rf.refuellerid as vehid, rf.modelid as model, post, 'Заправщик' as vehtype, ugh.get_veh_tsname(rf.refuellerid,'Заправщик') as tsname, rf.gosnumber, 0 as vehcode
    ,0,0,galileosky,1, controlid
    from dispatcher.refuellers rf
  union
  select rg.rigname, (select t.modelname from rigs.models@rigs t where t.modelid=rg.modelid), post, 'Бурстанок' as vehtype, ugh.get_veh_tsname(rg.rigname,'Бурстанок') as tsname, '' as gosnumber, rg.rigid as vehcode
    ,iPan, Oven, GalileoSky, ISFUNCTIONAL,  to_number(controlid)
    from rigs.rigs@rigs rg
;
