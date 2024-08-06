create or replace FUNCTION     f_get_shifthour
(
    
    p_Date IN DATE DEFAULT SYSDATE
    
 ) 
    RETURN INT 
AS

BEGIN

           if p_Date<=TO_date('31.03.2024 19:59:00','dd.mm.yyyy hh24:mi:ss') then
    if f_get_shiftnum(p_Date) =1
        then 
            return cast (to_char(p_Date, 'hh24') as number)-7;
        elsif cast (to_char(p_Date, 'hh24') as number)<8 
            then 
           return cast (to_char(p_Date, 'hh24') as number)+5;
            else
            return cast (to_char(p_Date, 'hh24') as number)-19;
        end if;
    else
    if cast(TO_CHAR(p_Date,'hh24') as number) between 8 and 19 
        then  
        
        --2 --||' от '||TO_CHAR(p_Date,'dd.mm.yyyy')
            return cast (to_char(p_Date, 'hh24') as number)-7;
        
        else  
        
        --1 -- ||' от '||TO_CHAR(p_Date,'dd.mm.yyyy')
        if cast (to_char(p_Date, 'hh24') as number)<8 
            then 
           return cast (to_char(p_Date, 'hh24') as number)+5;
            else
            return cast (to_char(p_Date, 'hh24') as number)-19;
        end if;
        
    end if;
    end if;  
       

END;

/*select 
(case when f_get_shiftnum(v.timeload) =1 then
        cast (to_char(:p_time, 'hh24') as number)-7
        --to_char(:p_time, 'hh24')
        else
            (case when cast (to_char(:p_time, 'hh24') as number)>=0
                then
                cast (to_char(:p_time, 'hh24') as number)+4
                else
                cast (to_char(:p_time, 'hh24') as number)-19
            end)
        end) as hour_shiftdate
        from dual;*/