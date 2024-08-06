
  CREATE OR REPLACE FORCE VIEW "UGH"."V_IDS_CUR_LOADWAIT" ("STOP_TIME_HOUR", "HOUR", "PRIM") AS 
  select sel_1."STOP_TIME_HOUR",sel_1."HOUR",sel_1."PRIM" from (
select stop_time_hour, 1 as hour, 's1' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=1
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel1
union
select stop_time_hour, 2, 's2' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=2
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel2
union
select stop_time_hour, 3, 's3' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=3
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel3
union
select stop_time_hour, 4, 's4' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=4
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel4
union
select stop_time_hour, 5, 's5' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=5
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel5
union
select stop_time_hour, 6, 's6' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=6
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel6
union
select stop_time_hour, 7, 's7' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=7
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel7
union
select stop_time_hour, 8, 's8' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=8
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel8
union
select stop_time_hour, 9, 's9' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=9
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel9
union
select stop_time_hour, 10, 's10' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=10
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel10
union
select stop_time_hour, 11, 's11' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=11
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel11
union
select stop_time_hour, 12, 's12' as prim from 
(select /*ids.dateshift_hour_t, ids.dateshift_hour
    ,*/sum(ids.stop_time_hour) as stop_time_hour
from ugh.v_idlestoppages_cur ids
where stoppage_type = 'ќжидание_погрузки' and ids.dateshift_hour<=12
--group by ids.dateshift_hour_t, ids.dateshift_hour
) sel12
) sel_1
    where sel_1.hour <= ugh.f_get_shifthour(sysdate);
