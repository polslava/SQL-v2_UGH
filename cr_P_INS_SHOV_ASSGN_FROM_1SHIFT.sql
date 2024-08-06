create or replace PROCEDURE P_INS_SHOV_ASSGN_FROM_1SHIFT 
(
  SHIFTBEGIN IN NUMBER 
, DATEBEGIN IN DATE 
) AS 
BEGIN

/*
копирование привязки экскаваторов Volvo к блокам из 1й смены во 2ю смену
*/
  insert into ugh.shov_assgn (shovid, area_id, taskdate, start_date, shift)

select sa.shovid, sa.area_id, sa.taskdate,
    /*to_char(sa.start_date,'hh24')
    ,*/
    (case when to_char(sa.start_date,'hh24')='08' and ShiftBegin=1 
        then 
            to_date(substr(to_char(sa.start_date,'dd.mm.yyyy hh24:mi:ss'),0,11)||'20'||substr(to_char(sa.start_date,'dd.mm.yyyy hh24:mi:ss'),14,6),'dd.mm.yyyy hh24:mi:ss')
        else 
            /*(case when to_char(sa.start_date,'hh24')='20' and :ShiftBegin=2 then 1 
            else 2 
            end)*/
            sysdate
        end) as start_date
    /*,substr(to_char(sa.start_date,'dd.mm.yyyy hh24:mi:ss'),0,11)
    ,substr(to_char(sa.start_date,'dd.mm.yyyy hh24:mi:ss'),14)*/
    --sa.* 
    , (case when ShiftBegin=1 then 2 else 1 end) as shift
    from ugh.shov_assgn sa
    where sa.taskdate = DateBegin
        and sa.shift = ShiftBegin
        and sa.shovid like 'Volvo%';
    commit;
END P_INS_SHOV_ASSGN_FROM_1SHIFT;