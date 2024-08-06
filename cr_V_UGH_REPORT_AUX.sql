
  CREATE OR REPLACE FORCE VIEW "UGH"."V_UGH_REPORT_AUX" ("VEHNAME", "VEHID", "TASKDATE", "REPORTORDER_SVODKA", "TRANSITIONSTIME_1", "TIMEWORK_1", "TRANSITIONSTIME_2", "TIMEWORK_2", "TRANSITIONSTIME_D", "TIMEWORK_D", "ETO", "ORGSTOP", "TECHNOLOGSTOP", "TECHSTOP", "TO_PPR", "KTG", "KIO", "AREA_1", "AREA_2", "READYGTTSTOP", "PLAN_DAY", "STOPPAGE_1", "STOPPAGE_2") AS 
  select sel2."VEHNAME",
       sel2."VEHID", 
       sel2."TASKDATE",
       sel2."REPORTORDER_SVODKA",
       sel2."TRANSITIONSTIME_1",
       sel2."TIMEWORK_1",
       sel2."TRANSITIONSTIME_2",
       sel2."TIMEWORK_2",
       sel2."TRANSITIONSTIME_D",
       sel2."TIMEWORK_D",
       sel2."ETO",
       sel2."ORGSTOP",
       sel2."TECHNOLOGSTOP",
       sel2."TECHSTOP",
       sel2."TO_PPR",
       sel2."KTG",
       sel2."KIO",
       sel2."AREA_1",
       sel2."AREA_2",
       sel2."READYGTTSTOP", 
       0 as plan_day 
       , sel4_s1.stoppage_name as stoppage_1 /*20221026 добавлены колонки простоев за смены*/

       , sel4_s2.stoppage_name as stoppage_2 /*20221026 добавлены колонки простоев за смены*/
from (
select * from (
select /*t.* , */
 
distinct t.vehname
, t.vehid, t.taskdate /*, t.shift,  t.transitiontime, t.timework*/
,ev.reportorder_svodka 
, t1.transitionstime_1, t1.timework_1
, t2.transitionstime_2, t2.timework_2
, t3.transitionstime_d, t3.timework_d
, t3.eto, t3.orgstop, 
t3.technologstop
, t3.techstop, t3.to_ppr, t3.ktg, t3.kio
, astd1.area as area_1
, astd2.area as area_2
, t3.ReadyGTTStop  /*20221030 простои исправного ГТТ*/
from Table(UGH.pac_views.get_AuxReport(/*:ParamDateBegin,:ParamShiftBegin,:ParamDateEnd,:ParamShiftEnd*/
        to_char(sysdate-1,'dd.mm.yyyy'),1,to_char(sysdate-1,'dd.mm.yyyy'),2
        )) t
left join 
(select t.vehid as vehid_1, round(t.transitionstime * 24,2) as transitionstime_1, t.timework as timework_1
    from Table(UGH.pac_views.get_AuxReport(/*:ParamDateBegin,:ParamShiftBegin,:ParamDateEnd,:ParamShiftEnd*/
        to_char(sysdate-1,'dd.mm.yyyy'),1,to_char(sysdate-1,'dd.mm.yyyy'),1
        ))t) t1 on t1.vehid_1 = t.vehid

left join 
(select t.vehid as vehid_2, round(t.transitionstime * 24,2) as transitionstime_2, t.timework as timework_2
    from Table(UGH.pac_views.get_AuxReport(/*:ParamDateBegin,:ParamShiftBegin,:ParamDateEnd,:ParamShiftEnd*/
        to_char(sysdate-1,'dd.mm.yyyy'),2,to_char(sysdate-1,'dd.mm.yyyy'),2
        ))t) t2 on t2.vehid_2 = t.vehid

left join 
(select t.vehid as vehid_d, sum(round(t.transitionstime * 24,2)) as transitionstime_d
    , round(sum(t.timework),2) as timework_d
    , round(sum(t.eto),2) as eto
    , round(sum(t.ppr_and_to),2) as to_ppr
    , round(sum(t.orgstop),2) as orgstop
    , round(sum(t.technologstop),2) as technologstop
    , round(sum(t.techstop),2) as techstop
    , round(avg(t.ktg),2) as ktg
    , round(avg(t.kio),2) as kio
    , round(sum(ReadyGTTStop ),2) as ReadyGTTStop
    from Table(UGH.pac_views.get_AuxReport(
        to_char(sysdate-1,'dd.mm.yyyy'),1,to_char(sysdate-1,'dd.mm.yyyy'),2
        ))t
    group by t.vehid
    ) t3 on t3.vehid_d = t.vehid
    
left  join ugh.enterprise_veh ev on ev.vehid = t.vehid 
    
left join dispatcher.aux_shift_tasks ast1 
        on ast1.aux_id = t.vehid and ast1.task_date = t.taskdate and ast1.shift = 1
left join dispatcher.aux_shift_task_details astd1
        on astd1.task_id = ast1.id
left join dispatcher.aux_shift_tasks ast2
        on ast2.aux_id = t.vehid and ast2.task_date = t.taskdate and ast2.shift = 2
left join dispatcher.aux_shift_task_details astd2
        on astd2.task_id = ast2.id
    
    where ev.reportorder_svodka is not null
        and ev.vehtype='Вспомогат.') sel1
--order by sel1.reportorder_svodka
    union
    select 'CAT-D10' as vehname
, null, null 
,'bull_1'
, null, null
, null, null
, null, null
, null
, null, null, null, null, null, null, null, null, null
from dual
    union
    select 'CAT-D9R' as vehname
, null, null 
,'bull_2'
, null, null
, null, null
, null, null
, null
, null, null, null, null, null, null, null, null, null
from dual
    union
    select 'CAT-D6R' as vehname
, null, null 
,'bull_3'
, null, null
, null, null
, null, null
, null
, null, null, null, null, null, null, null, null, null
from dual
) sel2
left join 
        (select stoppages_aux.vehid, 
listagg(
(case when stoppages_aux.timeidle <1 then '0' else '' end)||
stoppages_aux.timeidle||'ч '|| stoppages_aux.stoppage_name, '; ') WITHIN GROUP (ORDER BY stoppages_aux.timeidle,stoppages_aux.stoppage_name) as stoppage_name

from (
select ss.vehid, round(sum(ss.timego-ss.timestop)*24 /**60*/,1) as timeidle, ss.idlestoptype
    , ust.name as stoppage_name,ustcat.name as stoppagecategory_name
    from dispatcher.SHIFTSTOPPAGES_AUX ss
    left join DISPATCHER.userstoppagetypes_aux ust on ust.code = ss.idlestoptype
    left join dispatcher.userstoppagecategories_aux ustcat on ustcat.id = ust.categoryid 
    where ss.SHIFTDATE = --to_date(:Date,'dd.mm.yyyy') 
        to_date(to_char(sysdate-1,'dd.mm.yyyy'),'dd.mm.yyyy')  and  ss.SHIFTNUM =1 
        /*and (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%')*/
        and ust.code not in (840 /*ЕТО*/, 829 /*ТО*/)
        and ust.code not in (843	/*Личные нужды*/)
        and ust.code not in (848	/*Обед*/)
        --and ust.code not in (934	/*Заправка*/)
        and ((ss.timego - ss.timestop) >= 3 / 24 / 60)
    group by ss.vehid, ss.idlestoptype, ust.name, ustcat.name
    ) stoppages_aux
    where stoppages_aux.timeidle>0.25
    group by stoppages_aux.vehid
) sel4_s1 on sel4_s1.vehid = sel2.vehid  /*20221026 добавлены колонки простоев за смены*/
            left join 
        (select stoppages_aux.vehid, 
listagg(
(case when stoppages_aux.timeidle <1 then '0' else '' end)||
stoppages_aux.timeidle||'ч '|| stoppages_aux.stoppage_name, '; ') WITHIN GROUP (ORDER BY stoppages_aux.timeidle,stoppages_aux.stoppage_name) as stoppage_name

from (
select ss.vehid, round(sum(ss.timego-ss.timestop)*24 /**60*/,1) as timeidle, ss.idlestoptype
    , ust.name as stoppage_name,ustcat.name as stoppagecategory_name
    from dispatcher.SHIFTSTOPPAGES_AUX ss
    left join DISPATCHER.userstoppagetypes_aux ust on ust.code = ss.idlestoptype
    left join dispatcher.userstoppagecategories_aux ustcat on ustcat.id = ust.categoryid 
    where ss.SHIFTDATE = --to_date(:Date,'dd.mm.yyyy') 
        to_date(to_char(sysdate-1,'dd.mm.yyyy'),'dd.mm.yyyy')  and  ss.SHIFTNUM =2
        /*and (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%')*/
        and ust.code not in (840 /*ЕТО*/, 829 /*ТО*/)
        and ust.code not in (843	/*Личные нужды*/)
        and ust.code not in (848	/*Обед*/)
        --and ust.code not in (934	/*Заправка*/)
        and ((ss.timego - ss.timestop) >= 3 / 24 / 60)
    group by ss.vehid, ss.idlestoptype, ust.name, ustcat.name
    ) stoppages_aux
    where stoppages_aux.timeidle>0.25
    group by stoppages_aux.vehid
) sel4_s2 on sel4_s2.vehid =  sel2.vehid   /*20221026 добавлены колонки простоев за смены*/
    order by sel2.reportorder_svodka;
