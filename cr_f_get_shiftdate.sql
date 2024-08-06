create or replace FUNCTION     f_get_shiftdate
(
    
    p_Date IN DATE DEFAULT SYSDATE
    
 ) 
    RETURN DATE 
AS

BEGIN


            if p_Date<=TO_date('31.03.2024 19:59:00','dd.mm.yyyy hh24:mi:ss') then

if (p_Date-TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy'))<1/3 then return TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy')-1;
    else return TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy');
    end if;
    
    else
    if cast(TO_CHAR(p_Date,'hh24') as number) between 8 and 19 
        then return TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy'); --смена 2 текущих суток
        else 
            if cast(TO_CHAR(p_Date,'hh24') as number) < 8
                then
                    return TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy'); -- смена 1 текущих суток
                else
                    if cast(TO_CHAR(p_Date,'hh24') as number) > 19
                then
                    return TO_DATE(TO_CHAR(p_Date,'dd.mm.yyyy'),'dd.mm.yyyy')+1; --смена 1 текущих суток
                end if;    
            end if;    
    end if;
    end if;   

END;

--select to_number(substr(to_char(sysdate,'dd.mm.yyyy hh24:mi:ss'),12,2)) from dual