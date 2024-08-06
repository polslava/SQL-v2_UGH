
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHOV_MANUALSTOPPAGES" ("VEHID", "TIMESTOP", "TIMEGO", "TYPEID", "SHIFTDATE", "SHIFTNUM", "H_STOP", "H_GO", "REASON_TYPE", "REASON_CATEGORY", "DURATION_H", "DURATION_MIN", "H_DURATION", "SHIFTHOUR_STOP", "SHIFTHOUR_GO") AS 
  select "VEHID","TIMESTOP","TIMEGO","TYPEID","SHIFTDATE","SHIFTNUM","H_STOP","H_GO","REASON_TYPE","REASON_CATEGORY","DURATION_H","DURATION_MIN","H_DURATION","SHIFTHOUR_STOP","SHIFTHOUR_GO" from v_shov_manualstoppages_1m
    where shiftdate = getcurshiftdate(0,sysdate)
        and shiftnum = getcurshiftnum(0,sysdate);
