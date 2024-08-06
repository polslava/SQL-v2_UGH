
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHOVELS_IN_SHIFT" ("SHOVID", "SHIFTDATE", "SHIFTNUM", "VOLUME") AS 
  select sel1."SHOVID",sel1."SHIFTDATE",sel1."SHIFTNUM"
    , sum(ssp.volume) As volume
    from (
select std.shovid, getcurshiftdate(1,sysdate,12) as shiftdate, getcurshiftnum(1) as shiftnum
from dispatcher.shifttaskdetails std
left join dispatcher.shifttasks st on st.taskcounter = std.taskcounter
--left join dispatcher.shovels s on s.controlid = std.shovid
where st.taskdate = ugh.getcurshiftdate(0) --(to_date('31.01.2023','dd.mm.yyyy'))
    and st.shift = ugh.getcurshiftnum(0) --1
 
group by std.shovid) sel1
left join DISPATCHER.shovshiftplans ssp 
    on ssp.shovid = sel1.shovid 
        and ssp.taskdate = sel1.shiftdate and ssp.shift = sel1.shiftnum
group by sel1.shovid, sel1.shiftdate, sel1.shiftnum;
