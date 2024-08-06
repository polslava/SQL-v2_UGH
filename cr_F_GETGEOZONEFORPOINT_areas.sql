create or replace FUNCTION                     F_GETGEOZONEFORPOINT_areas 
(
  p_POINT_X IN NUMBER  DEFAULT 0 
, p_POINT_Y IN NUMBER DEFAULT 0 
) RETURN VARCHAR2 AS o_Zone1 varchar2 (50);
BEGIN

/*
������� ����� ������ (�� ���������) ��� �����
*/
o_Zone1:='';
select sel1.name into o_Zone1
from (
 select wa.workareaname name, 
 dispatcher."V2_GEO"."IS_POINT_INSIDE"(dispatcher.point(p_POINT_X, p_POINT_Y), dispatcher."V2_GEO"."GET_GEOMETRY_POINTS"(wa.geometry)) as inPoint
 from ugh.v_workareas wa
 ) sel1
 where inpoint >0
 and rownum <2;
 if o_Zone1 = '' then o_Zone1:='��� ����';
    end if; 
if o_Zone1 is null then o_Zone1:='��� ����1';
    end if;
RETURN (o_Zone1);
END F_GETGEOZONEFORPOINT_areas;