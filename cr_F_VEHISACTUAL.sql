create or replace FUNCTION                         F_VEHISACTUAL 
(
  VEH_ID IN VARCHAR2 
, VEH_TYPE IN VARCHAR2 
, VDATE IN DATE 
)  return number as is_actual BOOLEAN; 
BEGIN
 DECLARE 
  BDate Date := null;
  EDate DATE := null;
begin  
 select distinct first_value(startdate) over (order by startdate DESC)into BDate from ugh.vehperiods vp WHERE vp.vehid=veh_id and vp.vehtype=veh_type;
 select distinct first_value(finishdate) over (order by finishdate DESC) into EDate from ugh.vehperiods vp WHERE vp.vehid=veh_id and vp.vehtype=veh_type;
 if (vdate>BDate or BDate is null) and (vdate<EDate or EDate is null) then
  return (1);
 else return (0); 
 end if; 
 end; 
END F_VEHISACTUAL;