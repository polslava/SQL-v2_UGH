create or replace FUNCTION     F_VEHISREPAIRED 
(
  VEH_ID IN VARCHAR2 
, VEH_TYPE IN VARCHAR2 
, SHIFT_DATE IN VARCHAR2 
, SHIFT_NUM IN Number 
) RETURN NUMBER AS IsRepair number;
BEGIN
begin  
  
  select COUNT(rs.VehID) into isrepair from dispatcher.repairsheets rs
    where rs.vehid=Veh_id and rs.timebegin<=GetPredefinedTimeFrom('за указанную смену', SHIFT_NUM, SHIFT_DATE) and timeend>=getpredefinedtimeto('за указанную смену', SHIFT_NUM, SHIFT_DATE);  
  if veh_type<>'Самосвал' then IsRepair := null; 
                          else return isrepair; end if;
  
  select COUNT(rs.VehID) into isrepair from dispatcher.repairsheets_shov rs
    where rs.vehid=Veh_id and rs.timebegin<=GetPredefinedTimeFrom('за указанную смену', SHIFT_NUM, SHIFT_DATE) and timeend>=getpredefinedtimeto('за указанную смену', SHIFT_NUM, SHIFT_DATE);
  if veh_type<>'Экскаватор' then IsRepair := null; 
                            else return isrepair; end if;
  
  select COUNT(rs.VehID) into isrepair from dispatcher.repairsheets_aux rs
     where rs.vehid=Veh_id and rs.timebegin<=GetPredefinedTimeFrom('за указанную смену', SHIFT_NUM, SHIFT_DATE) and timeend>=getpredefinedtimeto('за указанную смену', SHIFT_NUM, SHIFT_DATE);
  if veh_type<>'Вспомогат.' then IsRepair := null; 
                           else return isrepair; end if;
     
end; 
END F_VEHISREPAIRED;