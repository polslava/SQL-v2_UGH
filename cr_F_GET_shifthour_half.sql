create or replace FUNCTION F_GET_shifthour_half
(
  INDATE IN DATE DEFAULT SYSDATE 
) RETURN number AS 
BEGIN
  RETURN 

  (case when f_get_shifthour(indate)=1 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 1 else
  (case when f_get_shifthour(indate)=1 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 2 else
  (case when f_get_shifthour(indate)=2 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 3 else
  (case when f_get_shifthour(indate)=2 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 4 else
  (case when f_get_shifthour(indate)=3 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 5 else
  (case when f_get_shifthour(indate)=3 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 6 else
  (case when f_get_shifthour(indate)=4 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 7 else
  (case when f_get_shifthour(indate)=4 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 8 else
  (case when f_get_shifthour(indate)=5 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 9 else
  (case when f_get_shifthour(indate)=5 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 10 else
  (case when f_get_shifthour(indate)=6 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 11 else
  (case when f_get_shifthour(indate)=6 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 12 else
  (case when f_get_shifthour(indate)=7 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 13 else
  (case when f_get_shifthour(indate)=7 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 14 else
  (case when f_get_shifthour(indate)=8 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 15 else
  (case when f_get_shifthour(indate)=8 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 16 else
  (case when f_get_shifthour(indate)=9 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 17 else
  (case when f_get_shifthour(indate)=9 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 18 else
  (case when f_get_shifthour(indate)=10 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 19 else
  (case when f_get_shifthour(indate)=10 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 20 else
  (case when f_get_shifthour(indate)=11 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 21 else
  (case when f_get_shifthour(indate)=11 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 22 else
  (case when f_get_shifthour(indate)=12 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=1 then 23 else
  (case when f_get_shifthour(indate)=12 and (case when cast(to_char(INDATE, 'mi') as number)<30 then 1 else 2 end)=2 then 24 
end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)end)

;
END F_GET_shifthour_half;