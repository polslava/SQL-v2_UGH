
  CREATE OR REPLACE FORCE VIEW "UGH"."V_UGH_REPORT_SHOVELS" ("REPORTORDER_SVODKA", "PLAN", "SHOVID", "TASKDATE", "WORKTIME_1", "VOLUMETOTAL_1", "AREA_1", "WORKTIME_2", "VOLUMETOTAL_2", "AREA_2", "VOLUMETOTAL_D", "WORKTIME_D", "TECHSTOP", "TECHNOLOGSTOP", "ORGSTOP", "READYGTTSTOP", "OTHERSTOP", "ETO", "PPR_AND_TO", "KTG", "KIO", "STOPPAGE_1", "STOPPAGE_2") AS 
  select sel1_1.reportorder_svodka
 ,round(pdv.value_plan,2) as plan
, sel1_1.shovid
, sel1_1.taskdate
, sel1_1.worktime_1, sel1_1.volumetotal_1
, sel1_1.area_1
, sel1_2.worktime_2, sel1_2.volumetotal_2
, sel1_2.area_2
, (sel1_1.volumetotal_1 + sel1_2.volumetotal_2) as volumetotal_d
, sel3.worktime_d
, sel3.techstop
, sel3.technologstop
, sel3.orgstop
, sel3.ReadyGTTStop
, sel3.otherstop
, sel3.eto
, sel3.ppr_and_TO
, sel3.ktg
, sel3.kio
, sel4_s1.stoppage_name as stoppage_1 /*20221026 добавлены колонки простоев за смены*/

, sel4_s2.stoppage_name as stoppage_2 /*20221026 добавлены колонки простоев за смены*/
from (
select 
    sel1.reportorder_svodka,
   
    sel1.shovid, sel1.taskdate, 
    sel1.worktime_1, sel1.volumetotal_1
    , LISTAGG(sel1.area, '; ') WITHIN GROUP (ORDER BY sel1.area) as area_1
                
from(
select 
ev.reportorder_svodka,
				t.shovid, t.taskdate, /*shift, dumpmodel, fio,*/ 
                round(max(volumetotal),2) as volumetotal_1,
               sum(worktime ) as worktime_1 
				,ar_1.area
			from Table(ugh.pac_views.get_ShovelReport(
            /*:ParamDateBegin, :ParamShiftBegin, :ParamDateEnd, :ParamShiftEnd*/
             to_char(sysdate-1,'dd.mm.yyyy'), 1, to_char(sysdate-1,'dd.mm.yyyy'), 1
            )) t
            inner join ugh.enterprise_veh ev on ev.vehid = shovid and ev.vehtype = 'Экскаватор' and ev.reportorder_svodka is not null
            
            left join 
            ( select  
                    area
                    , shovid, taskdate, shift
             from table (UGH.pac_views.get_ShovelReport (
                to_char(sysdate-1,'dd.mm.yyyy'), 1, to_char(sysdate-1,'dd.mm.yyyy'), 1 
                )) t
                group by 
                area
                , shovid, taskdate, shift
            ) ar_1 on ar_1.shovid = t.shovid
           group by ev.reportorder_svodka,t.shovid, t.taskdate,ar_1.area
           ) sel1 
                     group by sel1.reportorder_svodka,sel1.shovid, sel1.taskdate, 
                sel1.worktime_1, sel1.volumetotal_1) sel1_1
     
            left join
            (select sel1.shovid, sel1.taskdate, 
                sel1.worktime_2, sel1.volumetotal_2
                , LISTAGG(sel1.area, '; ') WITHIN GROUP (ORDER BY sel1.area) as area_2
                
from(
select 
        ev.reportorder_svodka,
				t.shovid, t.taskdate, 
                round(max(volumetotal),2) as volumetotal_2,
         sum(worktime ) as worktime_2
				,ar_1.area
			from Table(ugh.pac_views.get_ShovelReport(
            
             to_char(sysdate-1,'dd.mm.yyyy'), 2, to_char(sysdate-1,'dd.mm.yyyy'), 2
            )) t
            inner join ugh.enterprise_veh ev on ev.vehid = shovid and ev.vehtype = 'Экскаватор' and ev.reportorder_svodka is not null
            
            left join 
            ( select  
            area
            , shovid, taskdate, shift
             from table (UGH.pac_views.get_ShovelReport (
                to_char(sysdate-1,'dd.mm.yyyy'), 2, to_char(sysdate-1,'dd.mm.yyyy'), 2
                )) t
                group by 
                area
                , shovid, taskdate, shift
            ) ar_1 on ar_1.shovid = t.shovid
           group by ev.reportorder_svodka,t.shovid, t.taskdate,ar_1.area
           ) sel1 --, --volumetotal, 
            --worktime
                     group by sel1.shovid, sel1.taskdate, 
                sel1.worktime_2, sel1.volumetotal_2) sel1_2 on sel1_2.shovid = sel1_1.shovid
          left join
            (
select 

				t.shovid, t.taskdate, 
                --round(max(volumetotal),2) as volumetotal_d,
         sum(worktime ) as worktime_d
        ,round(sum(techstop),2) as techstop
        ,round(sum(technologstop),2) as technologstop
        , round(sum(orgstop),2) as orgstop
        , round(sum(otherstop),2) as otherstop
        ,round(avg( kio),2) as kio
        , round(avg(ktg),2) as ktg
        , round(sum(ETO),2) as ETO
        , round(sum(PPR_and_TO),2) as PPR_and_TO
        , round(sum(ReadyGTTStop),2) as ReadyGTTStop
			from Table(ugh.pac_views.get_ShovelReport(
     
             to_char(sysdate-1,'dd.mm.yyyy'), 1, to_char(sysdate-1,'dd.mm.yyyy'), 2
            )) t
          group by t.shovid, t.taskdate
           )  sel3 on sel3.shovid = sel1_1.shovid
            left join ugh.pite_day_veh pdv 
        on pdv.veh_id = sel1_1.shovid and pdv.veh_type = 'Экскаватор'
            and to_date(to_char(pdv.plandate,'dd.mm.yy')) =to_date(to_char(sysdate-1,'dd.mm.yy')) --sel1_1.taskdate
      left join 
        (select stoppages_shov.vehid, 
listagg(
(case when stoppages_shov.timeidle <1 then '0' else '' end)||
stoppages_shov.timeidle||'ч '|| stoppages_shov.stoppage_name, '; ') WITHIN GROUP (ORDER BY stoppages_shov.timeidle,stoppages_shov.stoppage_name) as stoppage_name

from (
select ss.vehid, round(sum(ss.timego-ss.timestop)*24 /**60*/,1) as timeidle, ss.idlestoptype
    , ust.name as stoppage_name,ustcat.name as stoppagecategory_name
    from dispatcher.SHIFTSTOPPAGES_shov ss
    left join DISPATCHER.userstoppagetypes_shovels ust on ust.code = ss.idlestoptype
    left join dispatcher.userstoppagecategories_shovels ustcat on ustcat.id = ust.categoryid 
    where ss.SHIFTDATE = --to_date(:Date,'dd.mm.yyyy') 
        to_date(to_char(sysdate-1,'dd.mm.yyyy'),'dd.mm.yyyy')  and  ss.SHIFTNUM =1 
        /*and (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%')*/
        and ust.code not in (1252 /*ЕТО*/, 1253 /*ТО*/)
        and ust.code not in (1764	/*Личные нужды*/)
        and ust.code not in (1761	/*Обед*/)
        --and ust.code not in (1237	/*Заправка*/)
        and ((ss.timego - ss.timestop) >= 3 / 24 / 60)
    group by ss.vehid, ss.idlestoptype, ust.name, ustcat.name
    ) stoppages_shov
    where stoppages_shov.timeidle>0.25
    group by stoppages_shov.vehid
) sel4_s1 on sel4_s1.vehid =  sel1_1.shovid  /*20221026 добавлены колонки простоев за смены*/
            left join 
        (select stoppages_shov.vehid, 
listagg(
(case when stoppages_shov.timeidle <1 then '0' else '' end)||
stoppages_shov.timeidle||'ч '|| stoppages_shov.stoppage_name, '; ') WITHIN GROUP (ORDER BY stoppages_shov.timeidle,stoppages_shov.stoppage_name) as stoppage_name

from (
select ss.vehid, round(sum(ss.timego-ss.timestop)*24 /**60*/,1) as timeidle, ss.idlestoptype
    , ust.name as stoppage_name,ustcat.name as stoppagecategory_name
    from dispatcher.SHIFTSTOPPAGES_shov ss
    left join DISPATCHER.userstoppagetypes_shovels ust on ust.code = ss.idlestoptype
    left join dispatcher.userstoppagecategories_shovels ustcat on ustcat.id = ust.categoryid 
    where ss.SHIFTDATE = --to_date(:Date,'dd.mm.yyyy') 
        to_date(to_char(sysdate-1,'dd.mm.yyyy'),'dd.mm.yyyy')  and  ss.SHIFTNUM =2
        /*and (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%')*/
        and ust.code not in (1252 /*ЕТО*/, 1253 /*ТО*/)
        and ust.code not in (1764	/*Личные нужды*/)
        and ust.code not in (1761	/*Обед*/)
        --and ust.code not in (1237	/*Заправка*/)
        and ((ss.timego - ss.timestop) >= 3 / 24 / 60)
    group by ss.vehid, ss.idlestoptype, ust.name, ustcat.name
    ) stoppages_shov
    where stoppages_shov.timeidle>0.25
    group by stoppages_shov.vehid
) sel4_s2 on sel4_s2.vehid =  sel1_1.shovid   /*20221026 добавлены колонки простоев за смены*/       
    order by sel1_1.reportorder_svodka;
