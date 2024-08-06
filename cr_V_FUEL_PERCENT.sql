
  CREATE OR REPLACE FORCE VIEW "UGH"."V_FUEL_PERCENT" ("VEHTYPE", "VEHID", "VEHMODEL", "FUEL", "MINFUEL", "FUEL_PERCENT") AS 
  SELECT fueltanks.vehtype,dispatcher.eventout.vehid,fueltanks.vehmodel, dispatcher.eventout.fuel, (fueltanks.Fuelcapacity/100*fueltanks.minimum_percent)as MINFUEL
 
 ,round((dispatcher.eventout.fuel/fueltanks.Fuelcapacity)*100,0) as fuel_percent

FROM dispatcher.EVENTOUT JOIN dispatcher.SHOVELS  on dispatcher.Eventout.vehid=dispatcher.shovels.shovid
              join fueltanks on fueltanks.vehmodel=dispatcher.shovels.model
UNION
SELECT fueltanks.vehtype,dispatcher.eventout.vehid, fueltanks.vehmodel,dispatcher.eventout.fuel, (fueltanks.Fuelcapacity/100*fueltanks.minimum_percent)as MINFUEL
,round((dispatcher.eventout.fuel/fueltanks.Fuelcapacity)*100,0) as fuel_percent

FROM dispatcher.EVENTOUT JOIN dispatcher.DUMPTRUCKS on dispatcher.Eventout.vehid=dispatcher.dumptrucks.vehid and dispatcher.eventout.vehtype='Самосвал'
              join fueltanks on fueltanks.vehmodel=dispatcher.dumptrucks.model
UNION
SELECT fueltanks.vehtype,dispatcher.eventout.vehid, fueltanks.vehmodel,dispatcher.eventout.fuel, (fueltanks.Fuelcapacity/100*fueltanks.minimum_percent)as MINFUEL
,round((dispatcher.eventout.fuel/fueltanks.Fuelcapacity)*100,0) as fuel_percent

FROM dispatcher.EVENTOUT JOIN dispatcher.AUXTECHNICS on dispatcher.Eventout.vehid=dispatcher.AUXTECHNICS.auxid and dispatcher.Eventout.vehtype='Вспомогат.'
              join fueltanks on fueltanks.vehmodel=dispatcher.AUXTECHNICS.model
UNION
SELECT fueltanks.vehtype,dispatcher.eventout.vehid, fueltanks.vehmodel,dispatcher.eventout.fuel, (fueltanks.Fuelcapacity/100*fueltanks.minimum_percent)as MINFUEL
,round((dispatcher.eventout.fuel/fueltanks.Fuelcapacity)*100,0) as fuel_percent

FROM dispatcher.EVENTOUT JOIN dispatcher.NONTECHVEHICLES on dispatcher.Eventout.vehid=dispatcher.NONTECHVEHICLES.nontechid
              join fueltanks on fueltanks.vehmodel=dispatcher.NONTECHVEHICLES.model
union 
SELECT fueltanks.vehtype,dispatcher.eventout.vehid, fueltanks.vehmodel,dispatcher.eventout.fuel, (fueltanks.Fuelcapacity/100*fueltanks.minimum_percent)as MINFUEL
,round((dispatcher.eventout.fuel/fueltanks.Fuelcapacity)*100,0) as fuel_percent

FROM dispatcher.EVENTOUT join 
(select rg.rigname, (select t.modelname from rigs.models@rigs t where t.modelid=rg.modelid) model from rigs.rigs@rigs rg)r  
on dispatcher.Eventout.vehid=r.rigname
join fueltanks on fueltanks.vehmodel=r.model;
