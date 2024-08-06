create or replace PROCEDURE P_STP_DUMPTRUCKS_PLANFACT_1M AS 
BEGIN
    execute immediate ('truncate table ugh.t_STP_DUMPTRUCKS_PLANFACT_1M');
    insert into ugh.t_STP_DUMPTRUCKS_PLANFACT_1M

  select 
    model, vehid, round(ktg,2) as ktg, round(kio,2) as kio, taskdate, shift, round(planktg,2) as planktg
    from
    v_stp_dumptrucks_planfact_1m;
    commit;
END P_STP_DUMPTRUCKS_PLANFACT_1M;