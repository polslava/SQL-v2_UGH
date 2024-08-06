
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PITE_PLANFACT" ("ID", "ENTERPRISEID", "DIVISIONID", "WORKTYPE", "MEASUREID", "VALUE_FACT", "VALUE_PLAN", "PLANDATE", "CHANGEDATE", "ENTERPRISENAME", "DIVISIONNAME", "MEASURENAME", "MEASURENAME_INCH") AS 
  select pd.ID, pd.ENTERPRISEID, pd.DIVISIONID, pd.WORKTYPE, pd.MEASUREID , pd.VALUE_FACT , pd.VALUE_PLAN , pd.PLANDATE, pd.CHANGEDATE
/*ID, ENTERPRISEID, DIVISIONID, WORKTYPE,MEASUREID ,VALUE_FACT ,VALUE_PLAN ,PLANDATE,CHANGEDATE*/
, e.enterprisename
, d.divisionname
, m.measurename
, m.measurename_inch
from UGH.pite_day pd
join dispatcher.enterprises e on e.enterpriseid = pd.enterpriseid
join dispatcher.divisions d on d.divisionid = pd.divisionid
/*join 
(select wt.id, wt.internalcode, wt.name, wt.worktypecategory, wt.defaultshovworktypeid 
    --,wtc.id
    , wtc.name as worktypecategory_name
    from DISPATCHER.worktypes wt
    left join DISPATCHER.worktype_category wtc on wtc.id= wt.worktypecategory
    where (wtc.id in (675, 671) and wt.internalcode is not null)
        or (wtc.id in (673))
    
    order by worktypecategory_name) wt1 on wt1.name = pd.worktype*/
join UGH.measures m on m.id = pd.measureid;
