
  CREATE OR REPLACE FORCE VIEW "UGH"."V_USERSTOPPAGES_SHOVELS" ("SHOVID", "MODEL", "TIMESTOP", "TIMEGO", "TIME", "USERST", "USERSTCAT", "AUTOST", "AUTOSTCAT", "SHIFTNUM", "SHIFTDATE") AS 
  SELECT s.shovid,  
               s.model,
               st.timestop,
               st.timego,
               ROUND ( (st.timego - st.timestop) * 1440) time,
               usts1.name userst,
               ustcs1.name userstcat,
               usts2.name autost,
               ustcs2.name autostcat,
               getcurshiftnum (0, st.timestop) shiftnum,
               getcurshiftdate (0, st.timestop) shiftdate
        FROM (SELECT vehid,
                     timestop,
                     timego,
                     idlestoptype,
                     autostopid
              FROM dispatcher.shiftstoppages_shov
              WHERE timestop BETWEEN 
                sysdate-93 and sysdate
              /*UGH.getpredefinedtimefrom ( 'за указанную смену',:ParamShiftBegin, :ParamDateBegin)
                    AND UGH.getpredefinedtimeto ( 'за указанную смену', :ParamShiftEnd, :ParamDateEnd)*/) st
              LEFT JOIN dispatcher.shovels s ON st.vehid = s.shovid
              LEFT JOIN dispatcher.userstoppagetypes_shovels usts1 ON st.idlestoptype = usts1.code
              LEFT JOIN dispatcher.userstoppagetypes_shovels usts2 ON st.autostopid = usts2.code
              LEFT JOIN dispatcher.userstoppagecategories_shovels ustcs1 ON usts1.categoryid = ustcs1.id
              LEFT JOIN dispatcher.userstoppagecategories_shovels ustcs2 ON usts2.categoryid = ustcs2.id
              ORDER BY st.timestop;
