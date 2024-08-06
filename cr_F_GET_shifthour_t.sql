create or replace FUNCTION F_GET_shifthour_t
(
  INDATE IN DATE DEFAULT SYSDATE 
) RETURN VARCHAR AS 
BEGIN
  RETURN 
/*   (case when F_GET_DATESHIFTHOUR(v.timeload)<10 then '0'||F_GET_DATESHIFTHOUR(v.timeload) else F_GET_DATESHIFTHOUR(v.timeload) end)||'_'||F_GET_HOURFROMDATE_T(v.timeload) as dateshift_hour_t
, (case when (cast (SUBSTR(v.vehid,0,2) as number))<10 then '0'||SUBSTR(v.vehid,0,1) 
*/
  (case when
  cast(to_char(INDATE,'hh24') as number)-
(case when cast(to_char(INDATE,'hh24') as number) between 8 and 19 then 7 else
(case when cast(to_char(INDATE,'hh24') as number) between 20 and 23 then 7+12 else -5 end)
end)<10 
then '0'||to_char(cast(to_char(INDATE,'hh24') as number)-
(case when cast(to_char(INDATE,'hh24') as number) between 8 and 19 then 7 else
(case when cast(to_char(INDATE,'hh24') as number) between 20 and 23 then 7+12 else -5 end)
end)) 
else
to_char(cast(to_char(INDATE,'hh24') as number)-
(case when cast(to_char(INDATE,'hh24') as number) between 8 and 19 then 7 else
(case when cast(to_char(INDATE,'hh24') as number) between 20 and 23 then 7+12 else -5 end)
end))

end)
;
END F_GET_shifthour_t;