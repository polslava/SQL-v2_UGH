create or replace FUNCTION     F_GETDEFAULTWORKTYPE 
(
  P_UNLOADID IN VARCHAR2 DEFAULT null 
) RETURN VARCHAR2 AS o_WorkType VARCHAR2(50);
BEGIN
begin
select worktype into o_WorkType
from dispatcher.unloadsandworktypes
where predefinateindex= 
(select min(predefinateindex) as pre_index 
from dispatcher.unloadsandworktypes
where unloadid = P_UNLOADID
group by unloadid)
and unloadid = P_UNLOADID;
end;
  RETURN nvl(o_WorkType,'');
END F_GETDEFAULTWORKTYPE;