create or replace FUNCTION             F_GETUNLOADIDFORPOINT 
(
  p_POINT_X IN NUMBER DEFAULT 0 
, p_POINT_Y IN NUMBER DEFAULT 0 
) RETURN VARCHAR2 AS o_UnloadId1 VARCHAR2(50);
BEGIN
--select u.unloadid into o_UnloadId1
--
/*,
    SQRT( POWER( u.unloadx-POINT_X , 2 ) + POWER( u.unloady-POINT_Y , 2 ) ) currad*/--
  /*from DISPATCHER.Unloads u
  where u.radius  > 0 and u.unloadx > 0 and u.unloady > 0
  and SQRT( POWER( u.unloadx-p_POINT_X , 2 ) + POWER( u.unloady-p_POINT_Y , 2 ) ) < u.radius*/
  --/*order by currad asc*/--
  /*and rownum=1
  ;
  RETURN nvl(o_UnloadId1,'вне пункта разгрузки');*/
  
  
/*
выборка имени пункта (из полигонов) для точки
*/
o_UnloadId1:='';
select sel1.name into o_UnloadId1
from (
 select contourname NAME, 
 dispatcher."V2_GEO"."IS_POINT_INSIDE"(dispatcher.point(p_POINT_X, p_POINT_Y), dispatcher."V2_GEO"."GET_GEOMETRY_POINTS"(contourhistorygeometry)) as inPoint
 from dispatcher.contours
 left join dispatcher.contours_history on contours_history.contourid = contours.contourid
where contourhistorytimeend is null 
    and contourtypeid=61) sel1
 where inpoint >0
    and rownum <2
    ;
 
RETURN nvl(o_UnloadId1,'вне пункта разгрузки');

END F_GETUNLOADIDFORPOINT;