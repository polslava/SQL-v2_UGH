
  CREATE OR REPLACE FORCE VIEW "UGH"."V_IDLESTOPPAGES" ("VEHID", "TIMESTOP", "TIMEGO", "IDLESTOPTYPE", "IDLESTOPTYPEAUTO", "STOPPAGE_NAME", "STOPPAGE_TIME", "COLOR") AS 
  select sel1.vehid, sel1.timestop, sel1.timego, sel1.idlestoptype, sel1.idlestoptypeauto , nvl(sel1.stoppage_name, 
  (case when sel1.timego = sysdate then '������� �������' else '�� ������� �������' end)) as stoppage_name , sel1.stoppage_time, 
  (case when stoppage_time >= 10      then 'red'    
  else          
  (case when stoppage_time between 5 and 10 then  'yellow' else              
  (case when stoppage_time between 1 and 3 then 'cyan' else 'white' end)        
  end)        
  end) as color 
  from  
  (select s.vehid, s.timestop     
  , nvl(s.timego,sysdate) as timego     
  , s.userstopid, s.idlestoptype, s.idlestoptypeauto    
  , ust.name as stoppage_name     
  , round((nvl(s.timego,sysdate) - s.timestop)*24*60,1) as stoppage_time     
  from dispatcher.idlestoppages s     
  left join dispatcher.userstoppagetypes ust  
  on ust.code = nvl(s.idlestoptype,(case when s.idlestoptype != s.idlestoptypeauto then s.idlestoptype else s.idlestoptypeauto end)) 
  where s.timestop 
  /*>=current_date-1  */
  BETWEEN                  dispatcher.GetPredefinedTimeFrom ( /*:ParamDataFrom*/ '�� ������� �����' , 1 , SYSDATE, /*:ParamBeginPeriod*/ to_date(to_char(current_date,'dd.mm.yyyy')||' 00:00:00','dd.mm.yyyy hh24:mi:ss'))                 AND dispatcher.GetPredefinedTimeTo ( /*:ParamDataFrom*/ '�� ������� �����' , 1 , SYSDATE, /*:ParamEndPeriod*/ current_date)
  ) sel1 where sel1.stoppage_time>1 
  order by sel1.timestop desc;
