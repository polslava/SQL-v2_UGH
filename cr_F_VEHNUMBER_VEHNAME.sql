create or replace FUNCTION     F_VEHNUMBER_VEHNAME 
(
  VEHNUMBER IN VARCHAR2 
) RETURN VARCHAR2 AS 
BEGIN
  if vehnumber in ('18','19','20','21','22') then return vehnumber||'-CAT 777';
  else return vehnumber;
  end if;
END F_VEHNUMBER_VEHNAME;