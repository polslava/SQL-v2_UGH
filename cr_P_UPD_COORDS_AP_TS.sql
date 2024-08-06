create or replace PROCEDURE P_UPD_COORDS_AP_TS AS 
BEGIN
  
        
update dispatcher.routers r
    set (x , y) = (select eoa.x , eoa.y+5
                    from v_eventout_advanced eoa
                        inner join ap_ts_assign ata
                            on ata.vehid = eoa.vehid and ata.vehtype= eoa.vehtype
                    where ata.ap_name  = r.name
                        and ata.date_end is null) 
    where exists (select 1 from ap_ts_assign ata where ata.ap_name = r.name and ata.date_end is null);
commit;
END P_UPD_COORDS_AP_TS;