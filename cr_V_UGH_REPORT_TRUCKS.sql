
  CREATE OR REPLACE FORCE VIEW "UGH"."V_UGH_REPORT_TRUCKS" ("REPORTORDER_SVODKA", "NAMETS", "TASKDATE", "VOLUMEFACTREPORT_1", "WORKTIME_1", "VOLUMEFACTREPORT_2", "WORKTIME_2", "VOLUMEFACTREPORT_D", "WORKTIME_D", "ETO", "ORGSTOP", "PURENOTTECHNOLOGSTOP", "READYGTTSTOP", "TECHSTOP", "PPR_AND_TO", "KTG", "KIO", "PLAN_DAY", "WORKTYPE_1", "WORKTYPE_2", "STOPPAGE_1", "STOPPAGE_2") AS 
  select sel1.reportorder_svodka
    , sel1.namets
    , sel1.TASKDATE
    , sel1.VolumeFactReport_1
    , sel1.WorkTime_1
    , sel2.VolumeFactReport_2
    , sel2.WorkTime_2
     , sel3.VolumeFactReport_d
    , sel3.WorkTime_d
   , sel3.ETO
        ,sel3.OrgStop /*исключить из формы отчёта*/
        ,sel3.PureNotTechnologStop /*как простои исправной ГТТ - убрать */
        ,sel3.ReadyGTTStop /*20221030 простои исправной ГТТ*/
        ,sel3.TechStop
        ,sel3.PPR_and_TO
         ,sel3.KTG
         ,sel3.KIO
         ,0 as plan_day
         , sel1.worktype_1
         , sel2.worktype_2
         , sel4_s1.stoppage_name as stoppage_1 /*20221026 добавлены колонки простоев за смены*/

         , sel4_s2.stoppage_name as stoppage_2 /*20221026 добавлены колонки простоев за смены*/
    from (
    select sel_1.reportorder_svodka,  sel_1.NameTS,   sel_1.VehID,  sel_1.TaskDate,  sel_1.VolumeFactReport as VolumeFactReport_1,  sel_1.WorkTime as WorkTime_1
,LISTAGG(sel_1.worktype, ', ') WITHIN GROUP (ORDER BY sel_1.worktype)  as worktype_1
from (
select
ev.reportorder_svodka,
			t.MODEL ||' №'||
			 (case when t.MODEL like ('%725%')
                then cast(substr(t.vehid,length(t.vehid),1) as number)
                else 
                    (case when t.MODEL like ('%Volvo%') then
                        cast(substr(t.vehid,length(t.vehid)-1,2) as number)
                        else cast(substr(t.vehid,0, 2) as number) end)
            end) as NameTS , /*моя доработка Ступин В.С. 20220928*/
          t.VEHID,
          t.TASKDATE,
          
          round(sum(t.VolumeFactReport),2) as VolumeFactReport,  
          
          round(sum(t.WorkTime),2) as WorkTime
       --,LISTAGG(w.worktype, ', ') WITHIN GROUP (ORDER BY w.worktype, w.vehid, w.taskdate, w.shift)  as worktype_1
       ,w.worktype
				from table (UGH.Pac_views.get_DumpTrucksReport (
                /*:ParamDateBegin, :ParamShiftBegin, :ParamDateEnd, :ParamShiftEnd*/
                to_char(sysdate-1,'dd.mm.yyyy'), 1, to_char(sysdate-1,'dd.mm.yyyy'), 1
                )) t
             inner join ugh.enterprise_veh ev on ev.vehid = t.vehid and ev.vehtype='Самосвал' and ev.reportorder_svodka is not null
             left join 
            ( select  
            (case when worktype like 'Балансовая руда%' then 'Балансовая руда' else worktype end) as worktype /*отсечение граммости руды*/
            , vehid, taskdate, shift
             from table (UGH.Pac_views.get_DumpTrucksReport (
                to_char(sysdate-1,'dd.mm.yyyy'), 1, to_char(sysdate-1,'dd.mm.yyyy'), 1 
                )) t
                group by 
                (case when worktype like 'Балансовая руда%' then 'Балансовая руда' else worktype end) /* worktype*/
                , vehid, taskdate, shift
                --order  by vehid, taskdate, shift /*выборка уникальных видов работ самосвалов за смену*/
                ) w on w.vehid = t.vehid and w.taskdate=t.taskdate and w.shift=1
            group by  ev.reportorder_svodka, t.model, t.VEHID, t.TASKDATE
                 ,w.worktype
          --  order by  ev.reportorder_svodka
          ) sel_1
            group by sel_1.reportorder_svodka,  sel_1.NameTS,   sel_1.VehID,  sel_1.TaskDate,  sel_1.VolumeFactReport,  sel_1.WorkTime
             order by  sel_1.reportorder_svodka) sel1
            left join 
            (
    select   sel_1.VehID,  sel_1.TaskDate,  sel_1.VolumeFactReport as VolumeFactReport_2,  sel_1.WorkTime as WorkTime_2
,LISTAGG(sel_1.worktype, ', ') WITHIN GROUP (ORDER BY sel_1.worktype)  as worktype_2
from (
select
          t.VEHID,
          t.TASKDATE,
        
          round(sum(t.VolumeFactReport),2) as VolumeFactReport,  
          
          round(sum(t.WorkTime),2) as WorkTime

       ,w.worktype
				from table (UGH.Pac_views.get_DumpTrucksReport (
            
                to_char(sysdate-1,'dd.mm.yyyy'),2, to_char(sysdate-1,'dd.mm.yyyy'), 2
                )) t
             inner join ugh.enterprise_veh ev on ev.vehid = t.vehid and ev.vehtype='Самосвал' and ev.reportorder_svodka is not null
             left join 
            (  select  
            (case when worktype like 'Балансовая руда%' then 'Балансовая руда' else worktype end) as worktype /*отсечение граммости руды*/
            , vehid, taskdate, shift
             from table (UGH.Pac_views.get_DumpTrucksReport (
                to_char(sysdate-1,'dd.mm.yyyy'), 2, to_char(sysdate-1,'dd.mm.yyyy'), 2
                )) t
                group by 
                (case when worktype like 'Балансовая руда%' then 'Балансовая руда' else worktype end) /* worktype*/
                , vehid, taskdate, shift
                --order  by vehid, taskdate, shift /*выборка уникальных видов работ самосвалов за смену*/
                ) w on w.vehid = t.vehid and w.taskdate=t.taskdate and w.shift=2
            group by  ev.reportorder_svodka, t.model, t.VEHID, t.TASKDATE
                 ,w.worktype
          --  order by  ev.reportorder_svodka
          ) sel_1
            group by   sel_1.VehID,  sel_1.TaskDate,  sel_1.VolumeFactReport,  sel_1.WorkTime
     
                ) sel2
                on sel2.vehid = sel1.vehid
    left join 
            (
          select
            VEHID,
          TASKDATE,
          
          round(sum(VolumeFactReport),2) as VolumeFactReport_d,  
          
          round(sum(WorkTime),2) as WorkTime_d
        , round(sum(ETO),2) as ETO
        ,round(sum(OrgStop),2) as OrgStop
        ,round(sum(PureNotTechnologStop),2) as PureNotTechnologStop
        ,round(sum(TechStop - PPR_and_TO - ETO),2) as TechStop
        ,round(sum(PPR_and_TO),2) as PPR_and_TO
         ,round(avg(KTG),2) as KTG
         ,round(avg(KIO),2) as KIO
         , round(sum(ReadyGTTStop),2) as  ReadyGTTStop
				from table (UGH.Pac_views.get_DumpTrucksReport (
                
                to_char(sysdate-1,'dd.mm.yyyy'), 1, to_char(sysdate-1,'dd.mm.yyyy'), 2
                )) t
                group by  VEHID, TASKDATE) sel3
                on sel3.vehid = sel1.vehid        
                
        left join 
        (select stoppages_dumptrucks.vehid, 
listagg(
(case when stoppages_dumptrucks.timeidle <1 then '0' else '' end)||
stoppages_dumptrucks.timeidle||'ч '|| stoppages_dumptrucks.stoppage_name, '; ') WITHIN GROUP (ORDER BY stoppages_dumptrucks.timeidle,stoppages_dumptrucks.stoppage_name) as stoppage_name

from (
select ss.vehid, round(sum(ss.timego-ss.timestop)*24 /**60*/,1) as timeidle, ss.idlestoptype
    , ust.name as stoppage_name,ustcat.name as stoppagecategory_name
    from dispatcher.SHIFTSTOPPAGES ss
    left join DISPATCHER.userstoppagetypes ust on ust.code = ss.idlestoptype
    left join dispatcher.userstoppagecategories ustcat on ustcat.id = ust.categoryid 
    where ss.SHIFTDATE = --to_date(:Date,'dd.mm.yyyy') 
        to_date(to_char(sysdate-1,'dd.mm.yyyy'),'dd.mm.yyyy')  and  ss.SHIFTNUM =1 
        /*and (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%')*/
        and ust.code not in (1661 /*погрузка*/, 1662 /*разгрузка*/)
        and ust.code not in (155	/*Ожидание_погрузки*/, 156 /*Ожидание_разгрузки*/)
        and ust.code not in (913 /*ЕТО*/, 910 /*ТО*/)
        and ust.code not in (917	/*Личные нужды*/)
        and ust.code not in (4	/*Обед*/)
        --and ust.code not in (934	/*Заправка*/)
        and ((ss.timego - ss.timestop) >= 3 / 24 / 60)
    group by ss.vehid, ss.idlestoptype, ust.name, ustcat.name
    ) stoppages_dumptrucks
    where stoppages_dumptrucks.timeidle>0.25
    group by stoppages_dumptrucks.vehid
) sel4_s1 on sel4_s1.vehid =  sel1.vehid  /*20221026 добавлены колонки простоев за смены*/
            left join 
        (select stoppages_dumptrucks.vehid, 
listagg(
(case when stoppages_dumptrucks.timeidle <1 then '0' else '' end)||
stoppages_dumptrucks.timeidle||'ч '|| stoppages_dumptrucks.stoppage_name, '; ') WITHIN GROUP (ORDER BY stoppages_dumptrucks.timeidle,stoppages_dumptrucks.stoppage_name) as stoppage_name

from (
select ss.vehid, round(sum(ss.timego-ss.timestop)*24 /**60*/,1) as timeidle, ss.idlestoptype
    , ust.name as stoppage_name,ustcat.name as stoppagecategory_name
    from dispatcher.SHIFTSTOPPAGES ss
    left join DISPATCHER.userstoppagetypes ust on ust.code = ss.idlestoptype
    left join dispatcher.userstoppagecategories ustcat on ustcat.id = ust.categoryid 
    where ss.SHIFTDATE = --to_date(:Date,'dd.mm.yyyy') 
        to_date(to_char(sysdate-1,'dd.mm.yyyy'),'dd.mm.yyyy')  and  ss.SHIFTNUM =2
        /*and (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%'
         or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%')*/
        and ust.code not in (1661 /*погрузка*/, 1662 /*разгрузка*/)
        and ust.code not in (155	/*Ожидание_погрузки*/, 156 /*Ожидание_разгрузки*/)
        and ust.code not in (913 /*ЕТО*/, 910 /*ТО*/)
        and ust.code not in (917	/*Личные нужды*/)
        and ust.code not in (4	/*Обед*/)
        --and ust.code not in (934	/*Заправка*/)
        and ((ss.timego - ss.timestop) >= 3 / 24 / 60)
    group by ss.vehid, ss.idlestoptype, ust.name, ustcat.name
    ) stoppages_dumptrucks
    where stoppages_dumptrucks.timeidle>0.25
    group by stoppages_dumptrucks.vehid
) sel4_s2 on sel4_s2.vehid =  sel1.vehid   /*20221026 добавлены колонки простоев за смены*/
            order by  sel1.reportorder_svodka;
