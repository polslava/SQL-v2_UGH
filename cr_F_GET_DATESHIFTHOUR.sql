create or replace FUNCTION F_GET_DATESHIFTHOUR 
(
  INDATE IN DATE DEFAULT SYSDATE 
) RETURN VARCHAR AS 
BEGIN
  RETURN 
  cast(to_char(INDATE,'hh24') as number)-
(case when cast(to_char(INDATE,'hh24') as number) between 8 and 19 then 7 else
(case when cast(to_char(INDATE,'hh24') as number) between 20 and 23 then 7+12 else -5 end)
end);
END F_GET_DATESHIFTHOUR;