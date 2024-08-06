
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SYSDATE" ("SYS_DATE", "SYS_TIME_T", "SYS_DATE_T", "SHIFTHOUR", "SHIFTHOUR_HALF", "SHIFTHOUR_HALF_T", "SHIFTHOUR_HALF_FULL", "SHIFTHOUR_HALF_EMPTY", "SHIFTNUM") AS 
  select sysdate as sys_date, to_char(sysdate,'hh24:mi:ss') as sys_time_t
    , to_char(sysdate,'dd.mm.yyyy') as sys_date_t
    ,ugh.f_get_shifthour(sysdate) as shifthour
    , ugh.f_get_shifthour_half(sysdate) as shifthour_half
    ,ugh.f_get_shifthour_half_t(sysdate) as shifthour_half_t
    , 24 as shifthour_half_full
    , 24 - ugh.f_get_shifthour_half(sysdate) as shifthour_half_empty
    ,f_get_shiftnum(sysdate) as shiftnum
from dual;
