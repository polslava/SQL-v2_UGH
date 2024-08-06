
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHOV_MANUALSTOPPAGES_1M" ("VEHID", "TIMESTOP", "TIMEGO", "TYPEID", "SHIFTDATE", "SHIFTNUM", "H_STOP", "H_GO", "REASON_TYPE", "REASON_CATEGORY", "DURATION_H", "DURATION_MIN", "H_DURATION", "SHIFTHOUR_STOP", "SHIFTHOUR_GO") AS 
  select sel1."VEHID",sel1."TIMESTOP",sel1."TIMEGO",sel1."TYPEID",sel1."SHIFTDATE",sel1."SHIFTNUM",sel1."H_STOP",sel1."H_GO",sel1."REASON_TYPE",sel1."REASON_CATEGORY"
    , round((sel1.timego - sel1.timestop)*24,3) as duration_h
    , round((sel1.timego - sel1.timestop)*24*60,1) as duration_min
    , (sel1.h_go - sel1.h_stop) as h_duration
    , (case when sel1.h_stop between 8 and 19 then sel1.h_stop-7 
            else (case when sel1.h_stop between 20 and 23 then sel1.h_stop-19 else sel1.h_stop+5
            end) end) as shifthour_stop
    , (case when sel1.h_go between 8 and 19 then sel1.h_go-7 
            else (case when sel1.h_go between 20 and 23 then sel1.h_go-19 else sel1.h_go+5
            end) end) as shifthour_go
from(
select st.vehid, st.timestop, st.timego, st.typeid, st.shiftdate, st.shiftnum
    , cast(to_char(st.timestop, 'hh24') as numeric) as h_stop
    , cast(to_char(st.timego , 'hh24') as numeric) as h_go
    , ust.name as reason_type
    , usc.name as reason_category
    from DISPATCHER.MANUALSTOPPAGES_SHOV st
        left join DISPATCHER.USERSTOPPAGETYPES_SHOVELS ust
            on ust.code = st.typeid
        left join DISPATCHER.userstoppagecategories_shovels usc
            on ust.categoryid = usc.id
    where st.shiftdate >= sysdate -30
        ) sel1;
