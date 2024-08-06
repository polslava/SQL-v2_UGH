
  CREATE OR REPLACE FORCE VIEW "UGH"."V_IDS_CUR_LOADWAIT_HALF_PERC" ("STOP_TIME_HOUR", "HOUR", "SHIFTHOUR_HALF_T", "STOP_LOADWAIT_NORM", "STOP_LOADWAIT_PERCENT") AS 
  select sel1."STOP_TIME_HOUR",sel1."HOUR",sel1."SHIFTHOUR_HALF_T",sel1."STOP_LOADWAIT_NORM"
, round(sel1.stop_time_hour/sel1.stop_loadwait_norm,2) as stop_loadwait_percent
from (
select ids_load.*
    , vtl.stop_waitload as stop_loadwait_norm

    from ugh.v_ids_cur_loadwait_half ids_load
    left join ugh.v_vehtrips_loadwait_half vtl
        on vtl.shifthour_half_t = ids_load.shifthour_half_t
    ) sel1;
