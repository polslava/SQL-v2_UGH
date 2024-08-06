create or replace FUNCTION                     F_GETSHOVELIDFORPOINT 
(
  p_POINT_X IN NUMBER DEFAULT 0 
, p_POINT_Y IN NUMBER DEFAULT 0 
, p_Time in date DEFAULT sysdate
) RETURN VARCHAR2 AS o_ShovelID varchar2(50);
BEGIN

select sel1.shovid into o_ShovelID
from (
select se.shovid,
    SQRT( POWER( se.x-p_POINT_X , 2 ) + POWER( se.y-p_POINT_Y , 2 ) ) currad
  from --DISPATCHER.shovels s
    ugh.v_shoveventstatearchive_curr se
    left join dispatcher.shovels s on s.shovid = se.shovid
  where 50 /*u.radius*/  > 0 and se.x > 0 and se.y > 0
      and SQRT( POWER( se.x-p_POINT_X , 2 ) + POWER( se.y-p_POINT_Y , 2 ) ) < 50 /*u.radius*/
      and s.isfunctional=1
      and se.time between to_date(p_Time,'dd.mm.yyyy hh24:mi:ss')-(4/(24*60)) and  to_date(p_Time,'dd.mm.yyyy hh24:mi:ss')+(5/(24*60))
  
  
  
   union
 /*доработка для экскаваторов без свежих координат, отключенных GPS в справочнике*/
 select * from 
 (select 
 se.shovid,
    SQRT( POWER( se.x-p_POINT_X , 2 ) + POWER( se.y-p_POINT_Y , 2 ) ) currad
    --se.*
  from --DISPATCHER.shovels s
    ugh.v_shoveventstatearchive_curr se
    left join dispatcher.shovels s on s.shovid = se.shovid
  where 50 /*u.radius*/  > 0 and se.x > 0 and se.y > 0
      and SQRT( POWER( se.x-p_POINT_X , 2 ) + POWER( se.y-p_POINT_Y , 2 ) ) < 50 /*u.radius*/
      and s.isfunctional=1 and s.use_gps_xy = 0
      and se.time between to_date(p_Time,'dd.mm.yyyy hh24:mi:ss')-(40/(24*60)) and  to_date(p_Time,'dd.mm.yyyy hh24:mi:ss')+(5/(24*60))
     order by time desc
      ) sel3
      --fetch FIRST 1 ROWs ONLY
      where rownum =1
 
  ) sel1
  where rownum<2;
  RETURN nvl(o_ShovelID,'нет рядом экскаватора');
END F_GETSHOVELIDFORPOINT;