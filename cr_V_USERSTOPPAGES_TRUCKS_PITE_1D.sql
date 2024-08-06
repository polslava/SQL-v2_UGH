
  CREATE OR REPLACE FORCE VIEW "UGH"."V_USERSTOPPAGES_TRUCKS_PITE_1D" ("VEHID", "TIMESTOP", "TIMEGO", "STOPPAGESTIME", "TIMEWORKMOTOR", "STOP_REASON", "STOP_REASON_CATEGORY", "DATE_SHIFT", "SHIFT", "LONGEST", "STOPPAGESTIME_HOUR", "HOUR_STOP", "SHIFTHOUR", "SHIFTDATE", "DATESTOP", "DUMPTUCK") AS 
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
,Hour_Stop
,shifthour
,shiftdate
,datestop
, (case when (cast (SUBSTR(s.vehid,0,2) as number))<10 then '0'||SUBSTR(s.vehid,0,1) 
else SUBSTR(s.vehid,0,2) end)
as dumptuck
      from(
    Select  ss.VehID,
               
               
               TO_CHAR(ss.TIMESTOP,'hh24'||chr(58)||'mi'||chr(58)||'ss') as TIMESTOP,
               TO_CHAR(ss.TIMEGO,'hh24'||chr(58)||'mi'||chr(58)||'ss') as TIMEGO,
               
               round((ss.TIMEGO-ss.TIMESTOP)*24*60,1) As StoppagesTime,
               round(NVL(ss.ENGINEWORKTIME,0)*60,1) as TimeWorkMotor,
               ust.NAME as stop_reason
               ,usc.name as stop_reason_category
            ,
            
            (case 
            when cast(to_char(ss.TIMESTOP, 'hh24') as number) < /*&lt;*/ 8
            then to_char(ss.TIMESTOP-1, 'DD.mm.yyyy')
            else to_char(ss.TIMESTOP, 'DD.mm.yyyy') 
            end) as date_shift,
            ugh.f_get_shiftdate(ss.TIMESTOP) as shiftdate,
    (case 
            when cast(to_char(ss.TIMESTOP, 'hh24') as number)>7 and cast(to_char(ss.TIMESTOP, 'hh24') as number) < /*&lt;*/ 20
            then 1
            else 2
            end) as shift
            
            , to_char(ss.timestop, 'hh24') as Hour_Stop
, ugh.f_get_shifthour(ss.TIMESTOP) as shifthour
,ss.timestop as datestop
    from
     dispatcher.SHIFTSTOPPAGES ss
    /*left join dispatcher.ShiftTasks st on (st.VehID = ss.VehID
    AND st.Shift= ss.ShiftNum
    AND ss.SHIFTDATE=st.TaskDate)*/
    left join dispatcher.Dumptrucks d on d.VEHID = ss.VehID   
    left join dispatcher.UserStoppageTypes ust on ss.IDLESTOPTYPE=ust.CODE 
     /*join Constcodes cc on (cc.CODE = ust.STOPPAGESOWN
        AND cc.TABLENAME = 'StoppagesOwn')*/
	left join dispatcher.userstoppagecategories usc on ust.categoryid = usc.id
    
    Where timestop between 
    sysdate-10 and sysdate+1
    /*:ParamDateBegin
            and :ParamDateEnd*/
    and ss.vehid not like ('%САТ-725%')
    
    ) s
  
    ORDER BY s.Date_shift, s.shift, s.VehID, s.timestop;
