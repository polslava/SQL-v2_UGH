
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHIFTREPORTSADV_MONTH_DATE" ("TASKDATE", "VOLUME") AS 
  select taskdate, round(sum((case when avweight = 0 then weightrate else avweight end) * TRIPNUMBERMANUAL)/2.7,0) as volume
from ugh.V_SHIFTREPORTSADV_month
group by taskdate;
