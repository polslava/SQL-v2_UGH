create or replace FUNCTION     f_get_shiftnum
(
    
    p_Date IN DATE DEFAULT SYSDATE
    
 ) 
    RETURN INT 
AS

BEGIN

       if p_Date<=TO_date('31.03.2024 19:59:00','dd.mm.yyyy hh24:mi:ss') then
    if (p_Date-TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy'))>=1/3 and (p_Date-TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy'))<5/6 
        then return 1-- ||' от '||TO_CHAR(p_Date,'dd.mm.yyyy')
        ;
        else return 2 -- ||' от '||TO_CHAR(p_Date,'dd.mm.yyyy')
        ;
    end if;
    else
    if cast(TO_CHAR(p_Date,'hh24') as number) between 8 and 19 
        then return 2 --||' от '||TO_CHAR(p_Date,'dd.mm.yyyy')
        ;
        else return 1 -- ||' от '||TO_CHAR(p_Date,'dd.mm.yyyy')
        ;
    end if;
    end if;       

END;

--select to_number(substr(to_char(sysdate,'dd.mm.yyyy hh24:mi:ss'),12,2)) from dual