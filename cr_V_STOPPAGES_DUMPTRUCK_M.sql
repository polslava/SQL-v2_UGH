
  CREATE OR REPLACE FORCE VIEW "UGH"."V_STOPPAGES_DUMPTRUCK_M" ("VEHID", "TIMESTOP", "TIMEGO", "STOPPAGESTIME", "TIMEWORKMOTOR", "STOP_REASON", "STOP_REASON_CATEGORY", "DATE_SHIFT", "SHIFT", "LONGEST", "STOPPAGESTIME_HOUR") AS 
  select s.VehID, s.TIMESTOP, s.TIMEGO, s.StoppagesTime, s.TimeWorkMotor
 , (case when s.stop_reason = 'Ожидание_разгрузки' 

  or (s.stop_reason = 'Ожидание_погрузки' and s.StoppagesTime < /*&lt;*/ 3) /*моя доработка 20230422*/
then null else s.stop_reason end) as stop_reason                     /*моя доработка 20230420*/
 , (case when s.stop_reason = 'Ожидание_разгрузки' 
  or (s.stop_reason = 'Ожидание_погрузки' and s.StoppagesTime < /*&lt;*/ 3) /*моя доработка 20230422*/
then null else s.stop_reason_category end) as stop_reason_category   /*моя доработка 20230420*/
 , s.date_shift, s.shift
      , (case when s.StoppagesTime < /*&lt;*/ 3 then 'менее 3мин' else 'более 3мин' end) as longest
, round(s.StoppagesTime/60,7) as StoppagesTime_hour
      from(
    Select  st.VehID,


               /*TO_CHAR(ss.TIMESTOP,'hh24'||chr(58)||'mi'||chr(58)||'ss') as*/ TIMESTOP,
               /*TO_CHAR(ss.TIMEGO,'hh24'||chr(58)||'mi'||chr(58)||'ss') as*/ TIMEGO,

               round((ss.TIMEGO-ss.TIMESTOP)*24*60,1) As StoppagesTime,
               round(NVL(ss.ENGINEWORKTIME,0)*60,1) as TimeWorkMotor,
               ust.NAME as stop_reason
               ,usc.name as stop_reason_category
            ,
getcurshiftdate(1,ss.TIMESTOP)			as date_shift, /*моя доработка Ступин В.С. 20240421*/

getcurshiftnum(1, ss.TIMESTOP)			as shift /*моя доработка Ступин В.С. 20240421*/
    from
     dispatcher.SHIFTSTOPPAGES ss
    left join dispatcher.ShiftTasks st on (st.VehID = ss.VehID
    AND st.Shift= ss.ShiftNum
    AND ss.SHIFTDATE=st.TaskDate)
    left join dispatcher.Dumptrucks d on d.VEHID = ss.VehID   
    left join dispatcher.UserStoppageTypes ust on ss.IDLESTOPTYPE=ust.CODE 
     /*join Constcodes cc on (cc.CODE = ust.STOPPAGESOWN
        AND cc.TABLENAME = 'StoppagesOwn')*/
	left join dispatcher.userstoppagecategories usc on ust.categoryid = usc.id

    Where timestop between sysdate -30 /*:ParamDateBegin*/

            and sysdate +1 /*:ParamDateEnd*/


    ) s

    ORDER BY s.Date_shift, s.shift, s.VehID, s.timestop;
