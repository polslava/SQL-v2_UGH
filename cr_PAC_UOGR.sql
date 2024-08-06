create or replace PACKAGE PAC_UOGR AS 

type r_UOGR_Rep is record(
shovid varchar(30)
    , volume_10 number
    , trips_10 number
    , volume_12 number
    , trips_12 number
    , volume_15 number
    , trips_15 number
    , volume_16 number
    , trips_16 number
    , volume_17 number
    , trips_17 number
    , volume_10d number
    , volume_12d number
    , volume_15d number
    , volume_16d number
    , volume_17d number
        , shift number
        ,shift_plan number
);

type t_UOGR_Rep is table of r_UOGR_Rep;
function get_UOGR_Rep (p_StartDate date /*, p_StartShift integer*/) return t_UOGR_Rep pipelined;

END PAC_UOGR;

create or replace PACKAGE BODY PAC_UOGR AS

  function get_UOGR_Rep (p_StartDate date /*, p_StartShift integer*/) return t_UOGR_Rep pipelined AS
  BEGIN
  /*выборка дл€ доклада начальника ”ќ√– на 16:00*/
for r_UOGR_Rep in
        (    
    select v.shovid
    , avg(sel_10.h_10) as volume_10
    , avg(sel_10.v_10) as trips_10
    , avg(sel_12.h_12) as volume_12
    , avg(sel_12.v_12) as trips_12
    , avg(sel_15.h_15) as volume_15
    , avg(sel_15.v_15) as trips_15
    , avg(sel_16.h_16) as volume_16
    , avg(sel_16.v_16) as trips_16
    , avg(sel_17.h_17) as volume_17
    , avg(sel_17.v_17) as trips_17
, avg(sel_10d.dh_10) as volume_10d
    , avg(sel_12d.dh_12) as volume_12d
    , avg(sel_15d.dh_15) as volume_15d
, avg(sel_16d.dh_16) as volume_16d
, avg(sel_17d.dh_17) as volume_17d
        , v.shift
        ,avg(pdv1.shift_plan) as shift_plan
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as h_10

    , count(v.shift) as v_10
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 1
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_10
    on sel_10.shovid=v.shovid  and sel_10.shift=v.shift
left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as dh_10
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 1
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_10d
    on sel_10d.shovid=v.shovid and sel_10d.shift=v.shift
 left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as h_12

    , count(v.shift) as v_12
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 3
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_12
    on sel_12.shovid=v.shovid and sel_12.shift=v.shift
 left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as dh_12
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 2 and 3
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_12d
    on sel_12d.shovid=v.shovid and sel_12d.shift=v.shift
 left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as h_15

    , count(v.shift) as v_15
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 6
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_15
    on sel_15.shovid=v.shovid   and sel_15.shift=v.shift
  left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as dh_15
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 4 and 6
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_15d
    on sel_15d.shovid=v.shovid   and sel_15d.shift=v.shift
left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as h_16

    , count(v.shift) as v_16
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 7
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_16
    on sel_16.shovid=v.shovid   and sel_16.shift=v.shift
left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as dh_16
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 7 and 7
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_16d
    on sel_16d.shovid=v.shovid   and sel_16d.shift=v.shift
left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as h_17

    , count(v.shift) as v_17
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 8
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_17
    on sel_17.shovid=v.shovid   and sel_17.shift=v.shift
left join 
(select v.shovid, v.shift
    , sum(round(v.weight/2.74,2)) as dh_17
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 8 and 8
        --and v.shift = 1
    group by v.shovid, v.shift
    ) sel_17d
    on sel_17d.shovid=v.shovid   and sel_17d.shift=v.shift

left join 
(select round(pdv.value_plan/2,2) as shift_plan
    ,pdv.veh_id from ugh.pite_day_veh pdv 
    where pdv.plandate = p_StartDate and pdv.veh_type='Ёкскаватор') pdv1
    on pdv1.veh_id = v.shovid 
group by v.shovid, v.shift
union

select 
    'итого' as shovid
    ,(select 
     sum(round(v.weight/2.74,2)) as h_10
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 1
        and v.shift = 1
    ) sel_10,null,
(select  sum(round(v.weight/2.74,2)) as h_12
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 3
        and v.shift = 1
    ) sel_12,null
    ,(select sum(round(v.weight/2.74,2)) as h_15
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 6
        and v.shift = 1
    ) sel_15
    ,null,
(select sum(round(v.weight/2.74,2)) as h_16
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 7
        and v.shift = 1
        ) sel_16,null,
(select sum(round(v.weight/2.74,2)) as h_17
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 8
        and v.shift = 1
        ) sel_17,null

        ,null,null,null,null
        ,null
        , 1 as shift
,(select sum(round(pdv.value_plan/2,2)) as shift_plan
    from ugh.pite_day_veh pdv 
    where pdv.plandate = p_StartDate and pdv.veh_type='Ёкскаватор') as shift_plan
    
    from dual
union

select 
    'итого' as shovid
    ,(select 
     sum(round(v.weight/2.74,2)) as h_10
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 1
        and v.shift = 2
    ) sel_10,null,
(select  sum(round(v.weight/2.74,2)) as h_12
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 3
        and v.shift = 2
    ) sel_12,null
    ,(select sum(round(v.weight/2.74,2)) as h_15
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 6
        and v.shift = 2
    ) sel_15
    ,null,
(select sum(round(v.weight/2.74,2)) as h_16
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 7
        and v.shift = 2
        ) sel_16,null
,(select sum(round(v.weight/2.74,2)) as h_17
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 8
        and v.shift = 2
        ) sel_17,null
        ,null,null,null,null
        ,null
        , 2 as shift
        ,(select sum(round(pdv.value_plan/2,2)) as shift_plan
    from ugh.pite_day_veh pdv 
    where pdv.plandate = p_StartDate and pdv.veh_type='Ёкскаватор') as shift_plan
    from dual
union

select 
    'за час' as shovid,
    (select 
    round(sum(v.weight/2.74)/2,2) as h_10
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 1
        and v.shift = 1
    ) sel_10,null,
(select round(sum(v.weight/2.74)/2,2) as h_12
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 2 and 3
        and v.shift = 1
    ) sel_12,null
    ,(select round(sum(v.weight/2.74)/2,2) as h_15
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 4 and 6
        and v.shift = 1
    ) sel_15
    ,null,
(select sum(round(v.weight/2.74,2)) as h_16
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 7 and 7
        and v.shift = 1
        ) sel_16,null
,(select sum(round(v.weight/2.74,2)) as h_17
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 8 and 8
        and v.shift = 1
        ) sel_17,null

        ,null,null,null,null
        ,null
        , 1 as shift
        ,(select round(sum(pdv.value_plan/2)/10.5,2) as shift_plan
    from ugh.pite_day_veh pdv 
    where pdv.plandate = p_StartDate and pdv.veh_type='Ёкскаватор') as shift_plan
    from dual
union

--8-0,9-1,10-2,11-3,12-4,13-5,14-6,15-7,16-8,17-9,18-10,19-11,20-12

select 
    'за час' as shovid,
    (select 
     round(sum(v.weight/2.74)/2,2) as h_10
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 0 and 1
        and v.shift = 2
    ) sel_10,null,
(select  round(sum(v.weight/2.74)/2,2) as h_12
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 2 and 3
        and v.shift = 2
    ) sel_12,null
    ,(select round(sum(v.weight/2.74)/2,2) as h_15
    from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 4 and 6
        and v.shift = 2
    ) sel_15
    ,null,
(select round(sum(v.weight/2.74),2) as h_16
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 7 and 7
        and v.shift = 2
        ) sel_16,null
,(select sum(round(v.weight/2.74,2)) as h_17
from table(ugh.PAC_V_VEHTRIPS.get_VehTrips_date(p_StartDate)) v
    where v.shift_hour between 8 and 8
        and v.shift = 2
        ) sel_17,null

        ,null,null,null,null
        ,null
        , 2 as shift
        ,(select round(sum(pdv.value_plan/2)/10.5,2) as shift_plan
    from ugh.pite_day_veh pdv 
    where pdv.plandate = p_StartDate and pdv.veh_type='Ёкскаватор') as shift_plan
    from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    
  END get_UOGR_Rep;

END PAC_UOGR;