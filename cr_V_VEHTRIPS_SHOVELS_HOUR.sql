
  CREATE OR REPLACE FORCE VIEW "UGH"."V_VEHTRIPS_SHOVELS_HOUR" ("SHOVID", "TRIPS", "SHIFTHOUR", "HOUR_LOAD", "SHIFTHOUR_LOAD", "VEH_COUNT", "SHIFTNUM") AS 
  select v.shovid, count(1) as trips
    
    , f_get_shifthour(v.timeload) as shifthour
    ,to_char(v.timeload, 'hh24') as hour_load
        , (case when f_get_shifthour(v.timeload)<10
    then
    '0'||cast(f_get_shifthour(v.timeload) as varchar(2))
    else
    cast(f_get_shifthour(v.timeload) as varchar(2)) end)
    ||'_'||to_char(v.timeload, 'hh24') as shifthour_load
    , sel2.veh_count
        , f_get_shiftnum as shiftnum
    from v_vehtrips v
    left join
(
select sel1.shovid, sel1.shifthour_load, count(vehid) as veh_count
from
(
select v.shovid
    , cast(f_get_shifthour(v.timeload) as varchar(2))||'_'||to_char(v.timeload, 'hh24') as shifthour_load
    , v.vehid
        from v_vehtrips v
    group by v.shovid,  cast(f_get_shifthour(v.timeload) as varchar(2))||'_'||to_char(v.timeload, 'hh24'), v.vehid

)    sel1
group by sel1.shovid, sel1.shifthour_load )sel2
    on sel2.shovid=v.shovid and sel2.shifthour_load=cast(f_get_shifthour(v.timeload) as varchar(2))||'_'||to_char(v.timeload, 'hh24')
   -- where v.shovid = 'PC-2000 ¹1'
    group by v.shovid, f_get_shifthour(v.timeload), to_char(v.timeload, 'hh24'), cast(f_get_shifthour(v.timeload) as varchar(2))||'_'||to_char(v.timeload, 'hh24'), sel2.veh_count
    order by v.shovid, f_get_shifthour(v.timeload), to_char(v.timeload, 'hh24');
