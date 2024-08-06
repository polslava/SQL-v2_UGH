
  CREATE OR REPLACE FORCE VIEW "UGH"."V_DIVISIONS" ("DIVISIONID", "PARENTDIVISIONID", "DIVISIONTYPEID", "DIVISIONNAME", "DESCRIPTION", "ENTERPRISEID", "ISFUNCTIONAL", "ADDRESS", "PHONE", "ENTERPRISENAME", "DIVISIONTYPENAME") AS 
  select 
d.DIVISIONID
,d.PARENTDIVISIONID
,d.DIVISIONTYPEID
,d.DIVISIONNAME
,d.DESCRIPTION
--,d.HEADMANID
,d.ENTERPRISEID
,d.ISFUNCTIONAL
,d.ADDRESS
,d.PHONE
, e.enterprisename
, dt.divisiontypename
from
dispatcher.divisions d
left join dispatcher.enterprises e on e.enterpriseid = d.enterpriseid
left join dispatcher.divisiontypes dt on dt.divisiontypeid = d.divisiontypeid
order by e.enterprisename, dt.divisiontypename,d.DIVISIONNAME;
