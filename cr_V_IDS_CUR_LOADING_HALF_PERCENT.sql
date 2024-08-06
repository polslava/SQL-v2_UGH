
  CREATE OR REPLACE FORCE VIEW "UGH"."V_IDS_CUR_LOADING_HALF_PERCENT" ("STOP_TIME_HOUR", "HOUR", "SHIFTHOUR_HALF_T", "STOP_LOADING_NORM", "STOP_LOADING_PERCENT") AS 
  select sel1."STOP_TIME_HOUR",sel1."HOUR",sel1."SHIFTHOUR_HALF_T",sel1."STOP_LOADING_NORM"
, round(sel1.stop_time_hour/sel1.stop_loading_norm,2) as stop_loading_percent
from (
select ids_load.*
    , vtl.stop_loading as stop_loading_norm

    from ugh.v_ids_cur_loading_half ids_load
    left join ugh.v_vehtrips_loading_half vtl
        on vtl.shifthour_half_t = ids_load.shifthour_half_t
    ) sel1
;
