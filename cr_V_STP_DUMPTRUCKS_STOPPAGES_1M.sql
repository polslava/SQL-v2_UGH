
  CREATE OR REPLACE FORCE VIEW "UGH"."V_STP_DUMPTRUCKS_STOPPAGES_1M" ("VEHID", "TIMESTOP", "DURATION", "TIMEGO", "STOPTYPE", "STOPCATEGORY", "STOPDATE", "STOPSHIFT") AS 
  select 
    stp.vehid,
    stp.timestop,
    round((stp.timego - stp.timestop)*24, 2) as duration,
    stp.timego,
    nvl(t.name, 'Неопр.') as stoptype,
    nvl(C.NAME, 'Неопр.') as stopcategory
     , to_char(stp.timestop,'dd') as stopdate
            , ugh.f_get_shiftnum(stp.timestop) as stopshift
from dispatcher.shiftstoppages stp
left join 
(
select vehid, timestop, timego, max(fuelstop) as fuelstop, max(fuelgo) as fuelgo 
from dispatcher.idlestoppages
where 
        TIMEstop between
            to_date('01'||to_char(sysdate, 'mm.yyyy'),'dd.mm.yyyy')
            and sysdate+1
group by vehid, timestop, timego)
idl on IDL.TIMESTOP = stp.timestop and idl.timego = stp.timego and idl.vehid = stp.vehid
left join dispatcher.userstoppagetypes t on T.CODE = STP.IDLESTOPTYPE
left join dispatcher.USERSTOPPAGECATEGORIES c on C.ID = T.CATEGORYID
where 
        
        stp.TIMEstop between
            to_date('01'||to_char(sysdate, 'mm.yyyy'),'dd.mm.yyyy')
            and sysdate+1
order by timestop, length(vehid), vehid;
