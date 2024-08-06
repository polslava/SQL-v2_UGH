
  CREATE OR REPLACE FORCE VIEW "UGH"."V_IDS_CUR_LOADWAIT_HALF" ("STOP_TIME_HOUR", "HOUR", "SHIFTHOUR_HALF_T") AS 
  select sum(ids.stop_time_hour) as stop_time_hour
    , 1 as hour
    , '01_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=1
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 1 as hour
    , '01_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=2
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 2 as hour
    , '02_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=3
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 2 as hour
    , '02_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=4
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 3 as hour
    , '03_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=5
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 3 as hour
    , '03_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=6
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 4 as hour
    , '04_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=7
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 4 as hour
    , '04_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=8
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 5 as hour
    , '05_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=9
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 5 as hour
    , '05_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=10
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 6 as hour
    , '06_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=11
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 6 as hour
    , '06_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=12
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 7 as hour
    , '07_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=13
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 7 as hour
    , '07_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=14
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 8 as hour
    , '08_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=15
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 8 as hour
    , '08_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=16
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 9 as hour
    , '09_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=17
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 9 as hour
    , '09_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=18
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 10 as hour
    , '10_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=19
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 10 as hour
    , '10_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=20
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 11 as hour
    , '11_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=21
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 11 as hour
    , '11_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=22
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 12 as hour
    , '12_1' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=23
union
select sum(ids.stop_time_hour) as stop_time_hour
    , 12 as hour
    , '12_2' shifthour_half_t
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.shifthour_half<=24;
