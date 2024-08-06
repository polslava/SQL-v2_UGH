create or replace PROCEDURE P_UPD_STOPPAGES_TRIPS 
/*(
  P_STARTDATE IN DATE DEFAULT sysdate
, P_STARTSHIFT IN INTEGER default 0

)*/ AS 
P_STARTSHIFT_1 integer;
P_STARTDATE_1 date;
P_STARTDATE DATE ;
 P_STARTSHIFT INTEGER ;

BEGIN
    P_STARTSHIFT :=0;
    P_STARTDATE :=sysdate;
    if  P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 8 and 19
       then P_STARTSHIFT_1 := 1;
        else P_STARTSHIFT_1 := 2;
    end if;
    if  P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 8 and 19
       then P_STARTDATE_1 := sysdate;
        elsif P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 20 and 23
            then P_STARTDATE_1 := sysdate;
            else P_STARTDATE_1 := sysdate-1;
    end if;
   -- return P_STARTSHIFT_1;
   update DISPATCHER.idlestoppages s
        set drvstoptype=1661,
        note = 'ходка: начало'
    where s.timestop
        BETWEEN 
            ugh.getpredefinedtimefrom('за указанную смену', p_StartShift_1, p_StartDate_1)
               and ugh.getpredefinedtimeto('за указанную смену', p_StartShift_1, p_StartDate_1)
        and (s.drvstoptype != 1661
        or s.drvstoptype is null)
        and vehid like '%CAT 777'
        and s.vehid||to_char(s.timestop,'dd.mm.yyyy hh24:mi:ss') in 
        (select tve.vehid||to_char(tve.timeload,'dd.mm.yyyy hh24:mi:ss')
         from ugh.t_vehtrips_eventtrips 
           /* table (ugh.pac_trips.get_events_geozones_trips1(:p_StartDate,:p_StartShift)) */
            tve
            where tve.timeload
        BETWEEN 
            ugh.getpredefinedtimefrom('за указанную смену', p_StartShift_1, p_StartDate_1)
               and ugh.getpredefinedtimeto('за указанную смену', p_StartShift_1, p_StartDate_1)
        )
        ;
    commit;
    update DISPATCHER.idlestoppages s
        set drvstoptype=1662,
        note = 'ходка: окончание'
    
    where s.timestop
        BETWEEN 
            ugh.getpredefinedtimefrom('за указанную смену', p_StartShift_1, p_StartDate_1)
               and ugh.getpredefinedtimeto('за указанную смену', p_StartShift_1, p_StartDate_1)
       and (s.drvstoptype != 1662
        or s.drvstoptype is null)
        and vehid like '%CAT 777'
        and s.vehid||to_char(s.timestop,'dd.mm.yyyy hh24:mi:ss') in 
        (select tve.vehid||to_char(tve.timeunload,'dd.mm.yyyy hh24:mi:ss')
         from ugh.t_vehtrips_eventtrips 
           /* table (ugh.pac_trips.get_events_geozones_trips1(:p_StartDate,:p_StartShift)) */
            tve
            where tve.timeload
        BETWEEN 
            ugh.getpredefinedtimefrom('за указанную смену', p_StartShift_1, p_StartDate_1)
               and ugh.getpredefinedtimeto('за указанную смену', p_StartShift_1, p_StartDate_1)
        )

        ;
    commit;
END P_UPD_STOPPAGES_TRIPS;