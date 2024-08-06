create or replace procedure     p_update_vehtrips_speed as 
begin
  update dispatcher.vehtrips vt
set avspeed =
    (select avg(speed) 
        from dispatcher.eventstatearchive esa
        where esa.vehid = vt.vehid and esa.time BETWEEN vt.timeload and vt.timeunload)
where vt.avspeed >= 50 or vt.avspeed < 0;       
end p_update_vehtrips_speed;