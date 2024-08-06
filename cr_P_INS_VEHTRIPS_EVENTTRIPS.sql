create or replace PROCEDURE         P_INS_VEHTRIPS_EVENTTRIPS AS 
P_STARTSHIFT integer;
P_STARTDATE date;
P_STARTSHIFT_1 integer;
P_STARTDATE_1 date;
BEGIN
    /*TRUNCATE TABLE ugh.t_VEHTRIPS_EVENTTRIPS;*/
    /*execute immediate ('truncate table ugh.t_VEHTRIPS_EVENTTRIPS');
   insert into ugh.t_VEHTRIPS_EVENTTRIPS
       select ve.*, sysdate as ins_date 
            from ugh.V_VEHTRIPS_EVENTTRIPS ve;*/
            p_StartDate:=sysdate;
            p_StartShift:=0;
            /*if  P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 8 and 19
       then P_STARTSHIFT_1 := 1;
        else P_STARTSHIFT_1 := 2;
    end if;*/
    if  P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 8 and 19
       then P_STARTSHIFT_1 := 2;
        else P_STARTSHIFT_1 := 1;
    end if;
    /*if  P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 8 and 19
       then P_STARTDATE_1 := sysdate;
        elsif P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 20 and 23
            then P_STARTDATE_1 := sysdate;
            else P_STARTDATE_1 := sysdate-1;
    end if;*/
    if  P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 8 and 19
       then P_STARTDATE_1 := sysdate;
        elsif P_STARTSHIFT =0 and to_number(to_char(P_STARTDATE,'hh24')) between 20 and 23
            then P_STARTDATE_1 := sysdate+1;
            else P_STARTDATE_1 := sysdate;
             end if;
     insert into ugh.t_VEHTRIPS_EVENTTRIPS
 select --ve.*
 ve.VEHID,
ve.TIMELOAD,
ve.shovelid as shovid,
ve.TIMEUNLOAD,
ve.UNLOADID,
ve.WEIGHT,
0 as AVSPEED,
ve.WORKTYPE
 , sysdate as ins_date 
    from  table (ugh.pac_trips.get_events_geozones_trips1(p_StartDate_1,p_StartShift_1)) ve
    where ve.vehid||to_char(ve.timeload,'dd.mm.yyyy hh24:mi:ss') not in (select ve1.vehid||to_char(ve1.timeload,'dd.mm.yyyy hh24:mi:ss') from ugh.t_VEHTRIPS_EVENTTRIPS ve1 where timeload>sysdate-1);
        commit;
END P_INS_VEHTRIPS_EVENTTRIPS;