
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PLANFACT_HOURSUM_HALF" ("HALFVOLUME", "VOLUME", "PLAN_HOUR_HALF", "SHITFHOUR_HALF", "SHITFHOUR", "SHITFHOUR_HALF_T", "PLANFACT_PERCENT") AS 
  select "HALFVOLUME","VOLUME","PLAN_HOUR_HALF","SHITFHOUR_HALF","SHITFHOUR","SHITFHOUR_HALF_T","PLANFACT_PERCENT" from Table(ugh.pac_views.get_vPlanFactHourSumHalf) order by shitfhour_half

/*select sel1.volume,sel1.plan_hour_half,sel1.shitfhour_half, sel1.shitfhour
 ,sel1.shitfhour_half_t
, round(sel1.volume/sel1.plan_hour_half,2) as planfact_percent
from (

select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    1 as shitfhour_half,
    1 as shitfhour
    ,'01_1' as shitfhour_half_t
   from ugh.v_planfact_hoursum_half_shov
 -- from ugh.v_planfact_hour_volume_half
    where shifthour_half<=1

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 2 as shifthour_half
    ,
    1 as shitfhour
    ,'01_2' as shitfhour_half_t
   -- from ugh.v_planfact_hour_volume_half
   from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=2

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 3 as shifthour_half
,
    2 as shitfhour
    ,'02_1' as shitfhour_half_t
   -- from ugh.v_planfact_hour_volume_half
   from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=3

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    4 as shitfhour_half
    ,
    2 as shitfhour
    ,'02_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=4

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 5 as shifthour_half
    ,
    3 as shitfhour
    ,'03_1' as shitfhour_half_t
 --   from ugh.v_planfact_hour_volume_half
 from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=5

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 6 as shifthour_half
,
    3 as shitfhour
    ,'03_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=6

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    7 as shitfhour_half,
    4 as shitfhour
    ,'04_1' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=7

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 8 as shifthour_half
    ,
    4 as shitfhour
    ,'04_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=8

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 9 as shifthour_half
,
    5 as shitfhour
    ,'05_1' as shitfhour_half_t
   -- from ugh.v_planfact_hour_volume_half
   from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=9

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    10 as shitfhour_half,
    5 as shitfhour
    ,'05_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=10

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 11 as shifthour_half
    ,
    6 as shitfhour
    ,'06_1' as shitfhour_half_t
 --   from ugh.v_planfact_hour_volume_half
 from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=11

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 12 as shifthour_half
,
    6 as shitfhour
    ,'06_2' as shitfhour_half_t
   -- from ugh.v_planfact_hour_volume_half
   from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=12

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    13 as shitfhour_half,
    7 as shitfhour
    ,'07_1' as shitfhour_half_t
   -- from ugh.v_planfact_hour_volume_half
   from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=13

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 14 as shifthour_half
    ,
    7 as shitfhour
    ,'07_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=14

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 15 as shifthour_half
,
    8 as shitfhour
    ,'08_1' as shitfhour_half_t
 --   from ugh.v_planfact_hour_volume_half
 from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=15

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    16 as shitfhour_half,
    8 as shitfhour
    ,'08_2' as shitfhour_half_t
   -- from ugh.v_planfact_hour_volume_half
   from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=16

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 17 as shifthour_half
    ,
    9 as shitfhour
    ,'09_1' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=17

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 18 as shifthour_half
,
    9 as shitfhour
    ,'09_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=18

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    19 as shitfhour_half,
    10 as shitfhour
    ,'10_1' as shitfhour_half_t
   -- from ugh.v_planfact_hour_volume_half
   from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=19

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half
    , 20 as shifthour_half
    ,
    10 as shitfhour
    ,'10_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=20

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 21 as shifthour_half
,
    11 as shitfhour
    ,'11_1' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=21

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half,
    22 as shitfhour_half,
    11 as shitfhour
    ,'11_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=22

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 23 as shifthour_half
    ,
    12 as shitfhour
    ,'12_1' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=23

union
select sum(volume) as volume,
    sum(plan_hour_half) as plan_hour_half, 24 as shifthour_half
,
    12 as shitfhour
    ,'12_2' as shitfhour_half_t
  --  from ugh.v_planfact_hour_volume_half
  from ugh.v_planfact_hoursum_half_shov
    where shifthour_half<=24

) sel1 */
;
