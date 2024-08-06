create or replace FUNCTION         F_VEHNAME_VEHNUMBER 
(
  VEHNAME IN VARCHAR2 
) RETURN VARCHAR2 AS 
BEGIN
  if instr(vehname,'CAT')=0 then return vehname;
  else return substr(vehname,1,2);
  end if;
  RETURN NULL;
END F_VEHNAME_VEHNUMBER;