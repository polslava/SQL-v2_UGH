create or replace FUNCTION     F_DUMPTRUCKISREPEARID 
(
  VEH_ID IN VARCHAR2 
, SHIFTDATE IN DATE 
, SHIFTNUM IN NUMBER 
) RETURN NUMBER AS IsRepair NUMBER; 
BEGIN
 begin
  select COUNT(rs.VehID) into isrepair from dispatcher.repairsheets rs
  where rs.vehid=Veh_id and rs.timebegin<=GetPredefinedTimeFrom('�� ��������� �����', SHIFTNUM, SHIFTDATE) and timeend>=getpredefinedtimeto('�� ��������� �����', SHIFTNUM, SHIFTDATE);
  return isrepair;
 end; 
  
END F_DUMPTRUCKISREPEARID;