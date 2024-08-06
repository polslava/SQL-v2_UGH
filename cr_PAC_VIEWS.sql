create or replace PACKAGE     PAC_VIEWS AS

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
type r_AuxReport is record(
          VehName varchar2(50),
          vehid varchar2(50),
          taskdate date,
          Shift integer,
          FIO varchar2(100),
          TransitionsTime float, 
          TransitionsLength float, 
          FuelConsumption float, 
          FuelRefuel float, 
          StartWorkTime date,
          FinishWorkTime date,
          DinnerStart date,
          DinnerEnd date,
          Dinner float,
          ETO float,
          PPR_and_TO float,
          TimeFund float, 
          TimeWork float, 
          stoptotal float, 
          techstop float, 
          technologstop float, 
          orgstop float,
          otherStop float,
          ktg float, 
          kio float,
          FuelStolen varchar2(1),
          ReasonsForDownTime varchar2(50)
          , ReadyGTTStop float
);

type t_AuxReport is table of r_AuxReport;
function get_AuxReport (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_AuxReport pipelined;

type r_ShovelReport is record(
          shovid varchar2(30), 
          taskdate date, 
          shift integer, 
          dumpmodel varchar2(50),
          fio varchar2(100),
          volumetotal float,
          weighttotal float,
          area varchar2(100), 
          worktype varchar2(100), 
          volume float, 
          weight float,
          tripcount integer,
          Rate float,  
          AvgTime float,  
          AvgBuckCount float, 
          AvgCycleTime float,
          StartWorkTime date,
          FinishWorkTime date,
          DinnerStart date, 
          DinnerEnd date,
          TimeFund float, 
          StopTotal float, 
          WorkTime float,  
          TechStop float, 
          TechnologStop float,  
          OrgStop float, 
          OtherStop float,
          KIO float,  
          KTG float,
          stoptypes varchar2(100)
          , ETO float, PPR_and_TO float
          , ReadyGTTStop float
          
);
type t_ShovelReport is table of r_ShovelReport;

function get_ShovelReport (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_ShovelReport pipelined;

type r_DumpTrucksReport is record(
          MODEL varchar2(50),
          VEHID varchar2(50),
          TASKDATE date,
          SHIFT integer,
          fio varchar2(100),
          SHOVID varchar2(50),
          AREA varchar2(255),
          WORKTYPE varchar2(50),
          UNLOADID varchar2(50),
          VolumeAutoReport float,
          VolumeFactReport float,
          VolumeDeltaReport float,
          WeightAutoReport float,
          WeightFactReport float,
          WeightDeltaReport float,
          TRIPNUMBERAUTO integer,
          TRIPNUMBERMANUAL integer,
          TripsNormPerRoute integer,
          TRIPNUMBERDELTA integer,
          ALLLENGTH float,
          ALLLENGTHMANUAL float,
          ALLLENGTHDELTA float,
          TechLength float,
          loadLengthAvg float,
          gruzooborot float,
          avgspeed float,
          timesum float,
          TimeFund float,
          WorkTime float,
          StopTotal float,
          TechStop float,
          TechnologStop float,
          PureTechnologStop float,
          PureNotTechnologStop float,
          OrgStop float,
          OtherStop float,
          ETO float,
          Dinner float,
          PPR_and_TO float,
          MyPureTechnology float,
          KTG float,
          KIO float,
          StartWorkTime date,
          EndWorkTime date,
          DinnerStart date,
          DinnerEnd date,
          StopPrich varchar2(100),
          fuelmanual float,
          fuelauto float,
          fueldelta float
          , ReadyGTTStop float
);

type t_DumpTrucksReport is table of r_DumpTrucksReport;

function get_DumpTrucksReport (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_DumpTrucksReport pipelined;


type r_RigReport is record(
                    RigName varchar2(50),
                    taskdate date,
                    SHIFT integer,
                    fio varchar2(100),
                    SHIFTSTARTTIME date,
                    SHIFTFINISHTIME date,
                    blockName varchar2(50),
                    wellDepthSumFact float,
                    wellCountFact float,
                    wellDepthAvgFact float,
                    drillDurationAvgFact float,
              --      wellDepthSumPlan float,
               --     WellsDepthAvgPlan float,
                    drillSpeed float,
                    drillproductivity float,
                    TimeFund float,
                    StopTotal float,
                    WorkTime float,
                    TechStop float,
                    TechnologStop float,
                    OrgStop float,
                    OtherStop float,
                    KTG float,
                    KIO float,
                    StopPrich varchar2(100)
                    , ReadyGTTStop float
);
type t_RigReport is table of r_RigReport;
function get_RigReport_test (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_RigReport pipelined;

type r_vPlanFactHourSumHalf is record (
                        halfvolume float,
                        volume float,
                        plan_hour_half float,
                        shitfhour_half int,
                        shitfhour int,
                        shitfhour_half_t varchar(255),
                        planfact_percent float
);
type t_vPlanFactHourSumHalf is table of r_vPlanFactHourSumHalf;
function get_vPlanFactHourSumHalf return t_vPlanFactHourSumHalf pipelined;

type r_vPlanFactHourSum is record (
                        volume float,
                        plan_hour float,
                        shitfhour int,
                        planfact_percent float
);
type t_vPlanFactHourSum is table of r_vPlanFactHourSum;
function get_vPlanFactHourSum return t_vPlanFactHourSum pipelined;
END PAC_VIEWS;


create or replace PACKAGE BODY     PAC_VIEWS AS

-- Функция формирования отчета по эксковаторам
function get_ShovelReport (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_ShovelReport pipelined is
   begin
       for r_ShovelReport in
        (
        select 
          MainInfo.shovid, taskdate, shift, dumpmodel,
            COALESCE(fio, 'Машинист не назначен')
          fio, 
          nvl( /*модификация под ручные объёмы в табеле экскаватора*/
          (case when MainInfo.shovid in (select ev.vehid from UGH.enterprise_veh ev where ev.report_count = 'manual' and ev.vehtype = 'Экскаватор')
            then
                volume_itog_manual
            else
                volumetotal
            end)
          ,0) as volumetotal
          , nvl(weighttotal,0) as weighttotal 
          
          , nvl( /*модификация под ручные объёмы в табеле экскаватора*/
          (case when MainInfo.shovid in (select ev.vehid from UGH.enterprise_veh ev where ev.report_count = 'manual' and ev.vehtype = 'Экскаватор')
            then
                area_manual
            else
                area
            end)
          ,0) as area
          
          , worktype, volume, weight, nvl(tripcount,0) tripcount,
          nvl(case when worktime>0 then VolumeTotal / WorkTime else 0 end,0) Rate,  
          AvgTime,  
          AvgBuckCount, 
            case when AvgBuckCount > 0 then AvgTime / AvgBuckCount else 0 end 
          AvgCycleTime,
          StartWorkTime,
          FinishWorkTime,
          DinnerStart, 
          DinnerEnd,
          TimeFund, 
          StopTotal, 
          WorkTime,  
          TechStop, 
          TechnologStop,  
          OrgStop, 
          OtherStop,
          KIO,  
          KTG,
         TO_CHAR(RowPos) as stoptypes
         , ETO, PPR_and_TO
         --, area_manual, worktype_manual, volume_itog_manual
     --'' stoptypes
     ,ReadyGTTStop
        from 
        (
          select
            st.shovid, st.taskdate, st.shift, 
            drv.FIO,
            volumesDetailed.dumpmodel,
            volumesTotal.VolumeTotal,
            volumesTotal.WeightTotal,
            volumesDetailed.Area, volumesDetailed.WorkType, 
            volumesDetailed.Volume,volumesDetailed.Weight,volumesDetailed.TripCount,
            BucketsInfo.AvgTime, BucketsInfo.AvgBuckCount,
            stopinfo.TimeFund, stopinfo.StopTotal, stopinfo.WorkTime, 
            stopinfo.TechStop, stopinfo.TechnologStop, stopinfo.OrgStop, stopinfo.OtherStop, stopinfo.KIO, stopinfo.KTG,
            stopinfo.DinnerStart, stopinfo.DinnerEnd,
            nvl(volumesDetailed.RowPos,1) as RowPos
            , ETO, PPR_and_TO
            ,ReadyGTTStop
          from
          -- Выбюираем все экскаваторы и к ним подцепляем перечень всех смен диапазона
          (
                   select vehid as shovid, shiftdate as taskdate, shift from Table(UGH.Idleutils.get_FullListOfShifts_Shov(p_StartDate, p_StartShift, p_FinishDate, p_FinishShift))
         ) st
         -- Завершение подцепки всех смен и экскаваторов
          left join -- подцепка  итогов смен по автосамсовалам
          
          -- запрос-оболочка для возможности проверить RowPos на null
          (select st_11.shovid, st_11.taskdate, st_11.shift, worktype, area, dumpmodel,
               volume, weight, tripcount, nvl(RowPos,1) as RowPos from
                    (
                   select vehid as shovid, shiftdate as taskdate, shift from Table(UGH.Idleutils.get_FullListOfShifts_Shov(p_StartDate, p_StartShift, p_FinishDate, p_FinishShift))
         ) st_11
         left join
          (
            select shovid, taskdate, shift, worktype, area, dt.model dumpmodel,
                sum
                (
                  case when weightrate > 0
                  then (decode(avweight, 0, weightrate, avweight) / weightrate) * volumerate * tripnumbermanual
                  else 0 end
                )
              volume,
              sum
                (
                  case when weightrate > 0
                  then decode(avweight, 0, weightrate, avweight)* tripnumbermanual
                  else 0 end
                ) as weight,
                sum(tripnumbermanual)
              tripcount,
              row_number() OVER(PARTITION BY shovid, taskdate, shift order by shovid, taskdate, shift, worktype, area, dt.model) as RowPos
            from 
              dispatcher.shiftreportsadv sra
            left join
            (
                            select vehid, substr(model, 1, 7) model from dispatcher.DumpTrucks  
            ) dt on sra.vehid = dt.vehid
            where 
              ((taskdate = p_StartDate and shift >= p_StartShift) or (taskdate > p_StartDate))
              and ((taskdate = p_FinishDate and p_FinishShift >= shift) or (p_FinishDate > taskdate))
            group by 
              shovid, taskdate, shift, area, worktype, dt.model
          ) volumesDetailed_1 on volumesDetailed_1.shovid = st_11.shovid and volumesDetailed_1.taskdate = st_11.taskdate and volumesDetailed_1.shift = st_11.shift
          ) volumesDetailed on volumesDetailed.shovid = st.shovid and volumesDetailed.taskdate = st.taskdate and volumesDetailed.shift = st.shift
          left join
          (
            select  
              shovid, taskdate, shift,
                sum
                (
                  case when weightrate > 0
                  then (decode(avweight, 0, weightrate, avweight) / weightrate) * volumerate * tripnumbermanual
                  else 0 end 
                ) as volumeTotal,
               sum
                (
                  case when weightrate > 0
                  then decode(avweight, 0, weightrate, avweight) * tripnumbermanual
                  else 0 end 
                ) as weightTotal
            from 
             dispatcher. shiftreportsadv
            where 
              ((taskdate = p_StartDate and shift >= p_StartShift) or (taskdate > p_StartDate))
              and ((taskdate = p_FinishDate and p_FinishShift >= shift) or (p_FinishDate > taskdate))
            group by 
              shovid, taskdate, shift
          ) volumesTotal on volumesTotal.shovid = st.shovid and volumesTotal.taskdate = st.taskdate and volumesTotal.shift = st.shift
          left join
          (
            select 
              nvl2(drv.famname, drv.famname || ' ' || substr(drv.firstname, 1, 1) || '. ' || substr(drv.secname, 1, 1) || '.', 'Машинист не назначен')
              fio,
              st.shov_id shovid,
              st.task_date,
              st.shift
            from dispatcher.shov_shift_tasks st
            left join dispatcher.shovdrivers drv on st.tabel_num = drv.tabelnum
            where  
              ((task_date = p_StartDate and shift >= p_StartShift)or(task_date > p_StartDate))
              and ((task_date = p_FinishDate and p_FinishShift >= shift)or(p_FinishDate > task_date))
          ) drv on st.shovid = drv.shovid and st.taskdate = drv.task_date and st.shift = drv.shift
          left join 
          (
            select
              1 as RowPos,
              vehid shovid,
              shiftdate,
              shiftnum,
              TimeFund, 
              (TechStop + TechnologStop + OrgStop + OtherStop) as StopTotal,
              (TimeFund - TechStop - TechnologStop - OrgStop - OtherStop) as WorkTime,
              (TechStop - ETO - PPR_and_TO) as TechStop,
              TechnologStop,
              OrgStop,
              OtherStop,
            --  dispatcher.kpi_shovels.getKTG(vehid, shiftdate, shiftnum, timefund) as KTG,
            --  dispatcher.kpi_shovels.getKI(vehid, shiftdate, shiftnum, timefund) as KIO,
              (TimeFund-TechStop)/TimeFund as KTG,
              (TimeFund - TechStop - TechnologStop - OrgStop - OtherStop)/TimeFund as KIO,
              DinnerStart,
              DinnerEnd
              , ETO, PPR_and_TO
              ,ReadyGTTStop
            from
            (
              select  
                stp.Vehid,
                stp.shiftdate,
                stp.shiftnum,
                dispatcher.params.getNumParameter('Продолжительность смены по умолчанию') as TimeFund,
                COALESCE(SUM(case when upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%' then (timego-timestop) else 0 end), 0) * 24 TechStop,
                COALESCE(SUM(case when upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' then (timego-timestop) else 0 end), 0) * 24 TechnologStop,
                COALESCE(SUM(case when upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%' then (timego-timestop) else 0 end), 0) * 24 OrgStop,
                COALESCE(SUM(case when upper(ustcat.name) like '%ПРОЧИЕ%' or idlestoptype is null then (timego-timestop) else 0 end), 0) * 24 OtherStop,
                min(case when upper(usttyp.name) like '%ОБЕД%' then timestop else null end) DinnerStart,
                max(case when upper(usttyp.name) like '%ОБЕД%' then timego else null end) DinnerEnd
                 ,nvl(SUM(case when upper(usttyp.name) like '%ЕТО%' then (timego-timestop) else 0 end),0) * 24 ETO,
                            nvl(SUM(case when upper(usttyp.name) like '%ППР%' or upper(usttyp.name) like 'ТО' then (timego-timestop) else 0 end),0) * 24 PPR_and_TO
                 ,
                COALESCE(SUM(case when (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%') and
                            
                          
        (  usttyp.code not in (1252 /*ЕТО*/, 1253 /*ТО*/)
        and usttyp.code not in (1764	/*Личные нужды*/)
        and usttyp.code not in (1761	/*Обед*/)
        --and usttyp.code not in (1237	/*Заправка*/)
        and ((timego - timestop) >= 3 / 24 / 60))
             then (timego - timestop)                   
                                else 0 end),0) * 24 as ReadyGTTStop
              from
              (
               select ds_8.vehid, 
                      idleStopType,
                      greatest(ttt1.timestop,UGH.getpredefinedtimeFrom('за указанную смену',ds_8.shift, ds_8.shiftdate)) as timestop,
                      least(ttt1.timego,UGH.getpredefinedtimeTo('за указанную смену',ds_8.shift, ds_8.shiftdate)) timego,
                      null fullshiftstatus,
                      ds_8.shiftdate, 
                      ds_8.shift as shiftnum
                      from (
                             select vehid, shiftdate, shift from Table(UGH.IDLEUTILS.get_TaskShiftDates_Shov(p_StartDate,p_StartShift,p_FinishDate,p_FinishShift))
                             MINUS
                             select vehid, shiftdate, shift from Table(UGH.IDLEUTILS.get_RepairShiftDates_Shov(p_StartDate,p_StartShift,p_FinishDate,p_FinishShift))
                             ) ds_8
                      left join (select * from dispatcher.ShiftStoppages_shov t2 where t2.shiftdate between p_StartDate-1 and p_FinishDate+1)ttt1
                      on ttt1.vehid=ds_8.vehid 
                         and ttt1.timestop<=UGH.getpredefinedtimeTo('за указанную смену', ds_8.shift, ds_8.shiftdate)
                         and ttt1.timego>UGH.getpredefinedtimeFrom('за указанную смену',ds_8.shift, ds_8.shiftdate)
               
                 
                          ------ Подключаем сами ремонтные листы ------------
                  union
                      
                  select vehid, stoptypecode idlestoptype,
                         UGH.getpredefinedtimefrom('за указанную смену',s_shifts.shift,s_shifts.taskdate) timestop,
                         UGH.getpredefinedtimeto('за указанную смену',s_shifts.shift,s_shifts.taskdate) timego,
                         'repair' fullshiftstatus,
                         s_shifts.taskdate as shiftdate, s_shifts.shift as shiftnum from dispatcher.repairsheets_Shov rps
                         left join
                         (SELECT distinct 
                 
                                 UGH.getcurshiftdate(0, UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate)+level*0.5-0.5) taskdate,
                                 UGH.getcurshiftnum(0, UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate)+level*0.5-0.5) shift
                          from  dual
                          CONNECT BY UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate) + level*.5
                                      <=UGH.GetPredefinedtimeTo('за указанную смену', p_FinishShift, p_FinishDate) ) s_shifts on 1=1
                   
                      where (rps.timebegin between UGH.GetPredefinedTimeFrom('за указанную смену', p_StartShift, p_StartDate)-720 and
                          UGH.GetPredefinedTimeTo('за указанную смену', p_FinishShift, p_FinishDate)-1/720 ) 
                             and (rps.timeend between UGH.GetPredefinedTimeFrom('за указанную смену', p_StartShift, p_StartDate)+1/720 and
                             UGH.GetPredefinedTimeTo('за указанную смену', p_FinishShift, p_FinishDate)+720)
                         
                         and UGH.GetPredefinedTimeFrom('за указанную смену', s_shifts.shift,s_shifts.taskdate)
                             >=rps.timebegin 
                         and UGH.GetPredefinedTimeFrom('за указанную смену', s_shifts.shift,s_shifts.taskdate)
                             <rps.timeend
               
                   --------- Завершение кода для ремонтных листов ------------
                        ) stp
              left join dispatcher.userstoppagetypes_shovels usttyp on usttyp.code = stp.idlestoptype
              left join dispatcher.userstoppagecategories_shovels ustcat on ustcat.id = usttyp.categoryid
              group by 
                stp.shiftdate, stp.shiftnum, stp.vehid
            ) stpinf
          ) stopinfo on VolumesDetailed.RowPos=stopinfo.RowPos and st.shovid = stopinfo.shovid and st.shift = stopinfo.shiftnum and st.taskdate = stopinfo.shiftdate
          
         left join
          (
            select 
              shovid, 
              shiftdate, 
              shiftnum,
              worktype,
              area,
              dumpmodel,
              avg(loadtime) as avgtime, 
              avg(bucketcount) as avgbuckcount
            from
            (
              select 
                stopcounter,
                shovid, 
                shiftdate, 
                shiftnum,
                vt.worktype,
                vt.area,
                dt.model dumpmodel,
           -----------Excluded due to my next code -------------------
           --  count(bucketNumber) bucketcount,
           -------------- My text --------------------
           avg(  (  select COALESCE(max(bucketNumber),0) as bucketcount from dispatcher.dumptrucksbucketsarchive dtba where dtba.vehid = sst.vehid and dtba.time >= sst.timestop and dtba.time <= sst.timego)) as bucketcount,
           ------------End of my text ----------------  
              avg(TIMEGO - TIMESTOP ) * 24 * 60 loadtime
              from dispatcher.shiftstoppages sst
              left join dispatcher.userstoppagetypes ust on ust.code = sst.idlestoptype
              left join dispatcher.vehtrips vt on sst.vehid = vt.vehid and vt.timeload between sst.timestop and sst.timego
           -------------- Excluded due to my earlear code -------- 
          --    left join dispatcher.dumptrucksbucketsarchive dtba on dtba.vehid = sst.vehid and dtba.time >= sst.timestop and dtba.time <= sst.timego
              left join 
              (
               select vehid, substr(model, 1, 7) model from dispatcher.DumpTrucks  
              ) dt on dt.vehid = sst.vehid
              where
                ((sst.shiftdate = p_StartDate and sst.shiftnum >= p_StartShift)or(sst.shiftdate > p_StartDate))
                and ((sst.shiftdate = p_FinishDate and p_FinishShift >= sst.shiftnum)or(p_FinishDate > sst.shiftdate))
                and upper(ust.name) = 'ПОГРУЗКА'
              group by
                stopcounter, shovid, shiftdate, shiftnum, vt.worktype, vt.area, dt.model
            )
            group by 
              shovid, shiftdate, shiftnum, worktype, area, dumpmodel
          ) BucketsInfo on 
            st.shovid = BucketsInfo.shovid and st.shift = BucketsInfo.shiftnum and st.taskdate = BucketsInfo.shiftdate
            and volumesDetailed.area = BucketsInfo.area and volumesDetailed.worktype = BucketsInfo.worktype and volumesDetailed.dumpmodel = BucketsInfo.dumpmodel
          where
                        ((st.taskdate = p_StartDate and st.shift >= p_StartShift) or (st.taskdate > p_StartDate))
                        and ((st.taskdate = p_FinishDate and p_FinishShift >= st.shift) or (p_FinishDate > st.taskdate))
            
        ) MainInfo
        left join
        (
                    select 
                        distinct
                        t0.shovid, shiftdate, shiftnum,                
                        COALESCE(first_value(ae.time) over (partition by t0.shovid, shiftdate, shiftnum order by abs(ae.time-(shiftdate+((shiftnum-1)*3+2)/6))),
                        (shiftdate+((shiftnum-1)*3+2)/6) ) StartWorkTime,
                        COALESCE(min(ae2.time) over (partition by t0.shovid, shiftdate, shiftnum order by ae.time-(shiftdate+((shiftnum-1)*3+2)/6)),
                        (shiftdate+((shiftnum-1)*3+5)/6)) FinishWorkTime
                        
                        , rep_man.area_manual, rep_man.worktype_manual, rep_man.volume_itog_manual /*модификация под ручные объёмы в табеле экскаватора*/
                    from dispatcher.shovels t0
                    left join
                    (
                        select p_StartDate + level - 1 shiftdate
                        from dual
                        connect by round(p_FinishDate - p_StartDate, 0) + 1 >= level
                    ) t1 on 1 = 1
                    left join
                    (
                        select level shiftnum
                        from dual
                        connect by  24 / dispatcher.params.getnumparameter('Продолжительность смены по умолчанию') >= level
                    ) t2 on 1 = 1
          left join dispatcher.shoveventstatearchive ae on ae.shovid =t0.shovid and ae.eventtype in (11,14) 
                        and ae.time between (shiftdate+((shiftnum-1)*3+2)/6)- 1/48 and
            (shiftdate+((shiftnum-1)*3+2)/6)+ 1/48
          left join dispatcher.shoveventstatearchive ae2 on ae2.shovid =t0.shovid  and   ae2.eventtype in (11,14) 
                        and ae2.time between (shiftdate+((shiftnum-1)*3+5)/6)- 1/48 and
            (shiftdate+((shiftnum-1)*3+5)/6 + 1/48)
            
            /*20221023 - моя доработка Ступин В.С. 
            использование объёмов из табеля экскаваторов при ручном вводе объёмов за смену*/
            left join --dispatcher.shov_shift_report
            
(select ssra.report_id /*,ssra.area as area_manual, ssra.worktype*/
    , LISTAGG(ssra.worktype, '; ') WITHIN GROUP (ORDER BY ssra.worktype) as worktype_manual
    , sum(ssra.volume_itog) as volume_itog_manual
    , sst.shov_id
    , LISTAGG(ssra.area, '; ') WITHIN GROUP (ORDER BY ssra.area) as area_manual
from dispatcher.shov_shift_reports_adv ssra
left join dispatcher.shov_shift_tasks sst on ssra.report_id = sst.id
where /*task_date = :p_StartDate and shift = :p_StartShift*/
((task_date = p_StartDate and shift >= p_StartShift)or(task_date > p_StartDate))
                        and ((task_date = p_FinishDate and p_FinishShift >= shift)or(p_FinishDate > task_date)) 
    and shov_id in (select vehid from UGH.enterprise_veh ev where ev.report_count = 'manual' and ev.vehtype = 'Экскаватор')
group by ssra.report_id,sst.shov_id) rep_man on rep_man.shov_id = t0.shovid
    
                    where
                        ((shiftdate = p_StartDate and shiftnum >= p_StartShift)or(shiftdate > p_StartDate))
                        and ((shiftdate = p_FinishDate and p_FinishShift >= shiftnum)or(p_FinishDate > shiftdate))                  
        ) TimeInfo on MainInfo.shovid = TimeInfo.shovid and MainInfo.shift = TimeInfo.shiftnum and MainInfo.taskdate = TimeInfo.shiftdate
        where MainInfo.shovid != 'Неопр.'
        order by lpad(MainInfo.shovid, 30), taskdate, shift, area, worktype, dumpmodel
        
 ) loop
          pipe row (r_ShovelReport);
   end loop;
end;  
-- Функция формирования отчета по бульдозерам
function get_AuxReport (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_AuxReport pipelined is
  begin
       for r_AuxReport in
        (
       select 
                    t9.model || ' №' || t0.vehid VehName,
                    t0.vehid,
                    t0.shiftdate taskdate,
                    t0.shift Shift,
                    nvl2(drv.FAMNAME, drv.FAMNAME || ' ' || SUBSTR(drv.FIRSTNAME, 1, 1) || '. ' || SUBSTR(drv.SECNAME, 1, 1) || '.', 'Водитель не назначен') 
                    FIO,
                    t5.MOVE_TIME - trunc(t5.MOVE_TIME) TransitionsTime, 
                    t5.lenght TransitionsLength, 
                    fuelrate FuelConsumption, 
                    refuel FuelRefuel, 
                    p_StartDate as StartWorkTime,
                    p_FinishDate as FinishWorkTime,
                    DinnerStart,
                    DinnerEnd,
                    Dinner,
                    ETO,
                    PPR_and_TO,
                    timefund TimeFund, 
                    worktime TimeWork, 
                    stoptotal, 
                    (techstop - eto - PPR_and_TO) as techstop, /*в сводке колонка аварийных простоев без учёта ЕТО и ППР*/
                    technologstop, 
                    orgstop,
                    otherStop,
                    (TimeFund-techstop)/TimeFund as ktg, 
                    WorkTime/TimeFund as kio,
                    '' FuelStolen, '' ReasonsForDownTime
                    ,ReadyGTTStop
                from 
                (
                    select * from Table(UGH.IDLEUTILS.get_FullListOfShifts_Aux (p_StartDate, p_StartShift, p_FinishDate, p_FinishShift))
                ) t0
                left join dispatcher.aux_shift_tasks t1 on t1.task_date=t0.shiftdate and t1.shift=t0.shift and t1.aux_id=t0.vehid
                inner join (select * from dispatcher.auxtechnics where xlsreportname is not null) t9 on t9.auxid=t0.vehid
                left join dispatcher.auxdrivers drv on drv.tabelnum = t1.tabel_num
                left join 
                (
                    select
                        vehid auxid,
                        shiftdate,
                        shiftnum,
                        TimeFund, 
                        (TechStop + TechnologStop + OrgStop + OtherStop) as StopTotal,
                        (TimeFund - TechStop - TechnologStop - OrgStop - OtherStop) as WorkTime,
                        (TechStop /*- ETO - PPR_and_TO*/) as TechStop,
                        TechnologStop,
                        OrgStop,
                        OtherStop,
                        DinnerStart,
                        DinnerEnd,
                        Dinner,
                        ETO,
                        PPR_and_TO
                        ,ReadyGTTStop
                    from
                    (
                        select  
                            stp.Vehid,
                            stp.shiftdate,
                            stp.shiftnum,
                            dispatcher.params.getNumParameter('Продолжительность смены по умолчанию') as TimeFund,
                            COALESCE(SUM(case when upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%' then (timego-timestop) else 0 end), 0) * 24 TechStop,
                            COALESCE(SUM(case when upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' then (timego-timestop) else 0 end), 0) * 24 TechnologStop,
                            COALESCE(SUM(case when upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%' then (timego-timestop) else 0 end), 0) * 24 OrgStop,
                            COALESCE(SUM(case when upper(ustcat.name) like '%ПРОЧИЕ%' or idlestoptype is null and (timego-timestop)<5/(24*3600) then (timego-timestop) else 0 end), 0) * 24 OtherStop,
                            min(case when upper(usttyp.name) like '%ОБЕД%' then timestop else null end) DinnerStart,
                            max(case when upper(usttyp.name) like '%ОБЕД%' then timego else null end) DinnerEnd,
                            nvl(SUM(case when upper(usttyp.name) like '%ОБЕД%' then (timego-timestop) else 0 end),0) * 24 Dinner,
                            nvl(SUM(case when upper(usttyp.name) like '%ЕТО%' then (timego-timestop) else 0 end),0) * 24 ETO,
                            nvl(SUM(case when upper(usttyp.name) like '%ППР%' or upper(usttyp.name) like 'ТО' then (timego-timestop) else 0 end),0) * 24 PPR_and_TO
                             ,
                COALESCE(SUM(case when (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%') and
                            
                          
        ( usttyp.code not in (840 /*ЕТО*/, 829 /*ТО*/)
        and usttyp.code not in (843	/*Личные нужды*/)
        and usttyp.code not in (848	/*Обед*/)
        --and usttyp.code not in (860	/*Заправка*/)
        and ((timego - timestop) >= 3 / 24 / 60))
             then (timego - timestop)                   
                                else 0 end),0) * 24 as ReadyGTTStop
                        from
                        (
                        select ds_8.vehid, 
                               idleStopType,
                               greatest(ttt1.timestop,UGH.getpredefinedtimeFrom('за указанную смену',ds_8.shift, ds_8.shiftdate)) as timestop,
                               least(ttt1.timego,UGH.getpredefinedtimeTo('за указанную смену',ds_8.shift, ds_8.shiftdate)) timego,
                               null fullshiftstatus,
                               ds_8.shiftdate, 
                               ds_8.shift as shiftnum
                        from (
                             select vehid, shiftdate, shift from Table(UGH.IDLEUTILS.get_TaskShiftDates_Aux(p_StartDate,p_StartShift,p_FinishDate,p_FinishShift))
                             MINUS
                             select vehid, shiftdate, shift from Table(UGH.IDLEUTILS.get_RepairShiftDates_Aux(p_StartDate,p_StartShift,p_FinishDate,p_FinishShift))
                             ) ds_8
                        left join (select * from dispatcher.ShiftStoppages_aux t2 where t2.shiftdate between p_StartDate-1 and p_FinishDate+1)ttt1
                        on ttt1.vehid=ds_8.vehid 
                           and ttt1.timestop<=UGH.getpredefinedtimeTo('за указанную смену', ds_8.shift, ds_8.shiftdate)
                           and ttt1.timego>UGH.getpredefinedtimeFrom('за указанную смену',ds_8.shift, ds_8.shiftdate)
               
                 
                          ------ Подключаем сами ремонтные листы ------------
                  union
                      
                  select vehid, stoptypecode idlestoptype,
                         UGH.getpredefinedtimefrom('за указанную смену',s_shifts.shift,s_shifts.taskdate) timestop,
                         UGH.getpredefinedtimeto('за указанную смену',s_shifts.shift,s_shifts.taskdate) timego,
                         'repair' fullshiftstatus,
                         s_shifts.taskdate as shiftdate, s_shifts.shift as shiftnum from dispatcher.repairsheets_aux rps
                         left join
                         (SELECT distinct 
                 
                                 UGH.getcurshiftdate(0, UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate)+level*0.5-0.5) taskdate,
                                 UGH.getcurshiftnum(0, UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate)+level*0.5-0.5) shift
                          from  dual
                          CONNECT BY UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate) + level*.5
                                      <=UGH.GetPredefinedtimeTo('за указанную смену', p_FinishShift, p_FinishDate) ) s_shifts on 1=1
                   
                      where (rps.timebegin between UGH.GetPredefinedTimeFrom('за указанную смену', p_StartShift, p_StartDate)-720 and
                          UGH.GetPredefinedTimeTo('за указанную смену', p_FinishShift, p_FinishDate)-1/720 ) 
                             and (rps.timeend between UGH.GetPredefinedTimeFrom('за указанную смену', p_StartShift, p_StartDate)+1/720 and
                             UGH.GetPredefinedTimeTo('за указанную смену', p_FinishShift, p_FinishDate)+720)
                         
                         and UGH.GetPredefinedTimeFrom('за указанную смену', s_shifts.shift,s_shifts.taskdate)
                             >=rps.timebegin 
                         and UGH.GetPredefinedTimeFrom('за указанную смену', s_shifts.shift,s_shifts.taskdate)
                             <rps.timeend
               
                   --------- Завершение кода для ремонтных листов ------------
                        ) stp
                        left join dispatcher.userstoppagetypes_aux usttyp on usttyp.code = stp.idlestoptype
                        left join dispatcher.userstoppagecategories_aux ustcat on ustcat.id = usttyp.categoryid
                        group by stp.shiftdate, stp.shiftnum, stp.vehid
                    ) stpinf
                ) t4 ON t4.auxid = t0.vehid AND t4.shiftnum = t0.shift and t4.shiftdate = t0.shiftdate
                left join
                (
                    select * from dispatcher.aux_shift_reports
                ) t5 on t5.task_id = t1.id
                /*left join
                (  select 
                        distinct
                        t0.auxid, shiftdate, shiftnum,                
                        COALESCE(first_value(ae.time) over (partition by t0.auxid, shiftdate, shiftnum order by abs(ae.time-UGH.getpredefinedtimefrom('за указанную смену', shiftnum, shiftdate))),
                        UGH.getpredefinedtimefrom('за указанную смену', shiftnum, shiftdate)) StartWorkTime,
                        COALESCE(min(ae2.time) over (partition by t0.auxid, shiftdate, shiftnum order by abs(ae.time-UGH.getpredefinedtimefrom('за указанную смену', shiftnum, shiftdate))),
                        UGH.getpredefinedtimeto('за указанную смену', shiftnum, shiftdate)) FinishWorkTime
                    from dispatcher.auxtechnics t0
                    left join
                    (
                        select p_StartDate + level - 1 shiftdate
                        from dual
                        connect by round(p_FinishDate - p_StartDate, 0) + 1 >= level
                    ) t1 on 1 = 1
                    left join
                    (
                        select level shiftnum
                        from dual
                        connect by  24 / dispatcher.params.getnumparameter('Продолжительность смены по умолчанию') >= level
                    ) t2 on 1 = 1
                    left join 
                        dispatcher.auxeventarchive ae on ae.auxid =t0.auxid and ae.eventtype in (11,14) 
                        and ae.time between UGH.getpredefinedtimefrom('за указанную смену', shiftnum, shiftdate)- 1/48 and
                        UGH.getpredefinedtimefrom('за указанную смену', shiftnum, shiftdate)+ 1/48
                    left join 
                        dispatcher.auxeventarchive ae2 on ae2.auxid =t0.auxid and   ae2.eventtype in (11,14) 
                        and ae2.time between UGH.getpredefinedtimeto('за указанную смену', shiftnum, shiftdate)- 1/48 and
                        UGH.getpredefinedtimeto('за указанную смену', shiftnum, shiftdate) + 1/48
                    where
                        ((shiftdate = p_StartDate and shiftnum >= p_StartShift)or(shiftdate > p_StartDate))
                        and ((shiftdate = p_FinishDate and p_FinishShift >= shiftnum)or(p_FinishDate > shiftdate))
                ) t6 ON t6.auxid = t1.aux_id and t6.shiftnum = t1.shift and t6.shiftdate = t1.task_date*/ /*отключил из-за длительности выполнения запроса и ненужности границ смены*/
                 
        order by lpad(t1.aux_id, 20), task_date, shift
        ) loop
          pipe row (r_AuxReport);
   end loop;
end;

function get_DumpTrucksReport (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_DumpTrucksReport pipelined is
begin
       for r_DumpTrucksReport in
        (
        ----------------------========================================
      select   
          MODEL,
          VEHID,
          
          TASKDATE,
          SHIFT,
          fio,
          SHOVID,
          AREA,
          WORKTYPE,
          UNLOADID,
          VolumeAutoReport,
          VolumeFactReport,  
          VolumeFactReport-VolumeAutoReport VolumeDeltaReport,        
          WeightAutoReport,
          WeightFactReport,
          WeightFactReport-WeightAutoReport WeightDeltaReport,
          TRIPNUMBERAUTO,
          TRIPNUMBERMANUAL,
          TripsNormPerRoute,
          TRIPNUMBERMANUAL-TRIPNUMBERAUTO TRIPNUMBERDELTA,
          ALLLENGTH,
          ALLLENGTHMANUAL,
          ALLLENGTHMANUAL-ALLLENGTH ALLLENGTHDELTA,
          TechLength,       
          loadLengthAvg, 
          gruzooborot,
          avgspeed,
          timesum,
          TimeFund,
          WorkTime,
          StopTotal,
          TechStop,
          TechnologStop,
          PureTechnologStop,
          PureNotTechnologStop,
          OrgStop,
          OtherStop,
          ETO,
          Dinner,
          PPR_and_TO,
          MyPureTechnology,
          KTG,
          KIO,   
          StartWorkTime,
          EndWorkTime,
          DinnerStart, 
          DinnerEnd,
          StopPrich,
          fuelmanual,fuelauto,fuelmanual-fuelauto fueldelta
          , ReadyGTTStop
                from
                (
                    select 
                        dt.MODEL,
                        st.VEHID,
                        st.TASKDATE,
                        st.SHIFT,
                        drFio.fio,
                        sra.SHOVID,
                        sra.area,
                        sra.UNLOADID,
                        sra.WORKTYPE,
                        CASE WHEN sra.WEIGHTRATE > 0 
                            THEN (DECODE(sra.AVWEIGHT, 0, sra.WEIGHTRATE, sra.AVWEIGHT) / sra.WEIGHTRATE) * sra.VOLUMERATE * sra.TRIPNUMBERAUTO 
                            ELSE null END 
                        VolumeAutoReport,
                            CASE WHEN sra.WEIGHTRATE > 0 
                            THEN (DECODE(sra.AVWEIGHT, 0, sra.WEIGHTRATE, sra.AVWEIGHT) / sra.WEIGHTRATE) * sra.VOLUMERATE * sra.TRIPNUMBERMANUAL 
                            ELSE null END 
                        VolumeFactReport,          
                            DECODE(sra.AVWEIGHT, 0, sra.WEIGHTRATE, sra.AVWEIGHT) * sra.TRIPNUMBERMANUAL 
                        WeightAutoReport,
                            DECODE(sra.AVWEIGHT, 0, sra.WEIGHTRATE, sra.AVWEIGHT) * sra.TRIPNUMBERMANUAL 
                        WeightFactReport,
                        sra.TRIPNUMBERAUTO,
                        sra.TRIPNUMBERMANUAL,
                       -- 0 as TripsNormPerRoute,
                       --UGH.GetTripsNormPerRoute(UGH.getpredefinedtimeFrom('за указанную смену',st.shift, st.taskdate), UGH.getpredefinedtimeTo('за указанную смену',st.shift, st.taskdate), sra.shovid, st.vehid, sra.Area,sra.unloadid) TripsNormPerRoute,
                        (select tnp.TripsNorm from UGH.TripsNormPerVeh tnp 
                                where tnp.shiftdate=st.taskdate 
                                      and tnp.shiftnum=st.shift 
                                      and tnp.shovid=sra.shovid
                                      and tnp.vehid=st.vehid
                                      and tnp.area=sra.Area
                                      and tnp.unloadid=sra.unloadid) as TripsNormPerRoute,
                        slat.MOVELOADLEN + slat.MOVEUNLOADLEN ALLLENGTH ,
                        slat.ALLLENGTHMANUAL,
                            lengthmanual * tripnumbermanual * 2
                        TechLength,          
                            sra.LENGTHMANUAL 
                        loadLengthAvg, 
                           CASE WHEN WorkTime>0            
                            THEN sum(DECODE(sra.AVWEIGHT, 0, sra.WEIGHTRATE, sra.AVWEIGHT) * sra.TRIPNUMBERMANUAL) over
                            (partition by dt.MODEL, sra.VEHID, sra.TASKDATE, sra.SHIFT) / WorkTime
                           ELSE null END gruzooborot,
                             CASE WHEN timesum>0
                             THEN lengthsum/timesum 
                             ELSE null END avgspeed,
                            timesum
                        timesum,
                        TimeFund,
                        WorkTime,
                        StopTotal,
                        TechStop,
                        TechnologStop,
                        PureTechnologStop,
                        PureNotTechnologStop,
                        OrgStop,
                        OtherStop,
                        ETO,
                        Dinner,
                        PPR_and_TO,
                        MyPureTechnology,
                        KTG,
                        KIO,      
                        shiftstarttime StartWorkTime,
                        shiftfinishtime EndWorkTime,
                        DinnerStart, 
                        DinnerEnd,
                        '' AS StopPrich,
                        vsf.startfuelmanual-vsf.finishfuelmanual+vsf.REFUELLINGVOLUMEMANUAL-vsf.BACKFUELVOLUME  fuelmanual,
                        vsf.startfuelauto-vsf.finishfuelauto+vsf.REFUELLINGVOLUMEAUTO fuelauto
                        , ReadyGTTStop
                    from
                    (
                    ---------------------------------- все смены периода ------------------------
               
                   select vehid, shiftdate as taskdate, shift from Table(UGH.Idleutils.get_FullListOfShifts(p_StartDate, p_StartShift, p_FinishDate, p_FinishShift))
                    -------------------------------------- завершение блока всех смен периода ----------------------------------------
                    ) st
                    left join ( select
                                 sra_12.vehid,
                                 sra_12.taskdate,
                                 sra_12.shift,
                                 sra_12.SHOVID,
                                 sra_12.area,
                                 sra_12.UNLOADID,
                                 sra_12.WORKTYPE,
                                 sra_12.TRIPNUMBERAUTO,
                                 sra_12.TRIPNUMBERMANUAL,
                                 sra_12.LENGTHMANUAL,
                                 sra_12.AVWEIGHT,
                                 sra_12.WEIGHTRATE,
                                 sra_12.VOLUMERATE,
                                 nvl(sra_12.RowPos, 1) as RowPos
                               from
                    ( select st_11.vehid, st_11.taskdate, st_11.shift,
                                 sra_11.SHOVID,
                                 sra_11.area,
                                 sra_11.UNLOADID,
                                 sra_11.WORKTYPE,
                                 sra_11.TRIPNUMBERAUTO,
                                 sra_11.TRIPNUMBERMANUAL,
                                 sra_11.LENGTHMANUAL,
                                 sra_11.AVWEIGHT,
                                 sra_11.WEIGHTRATE,
                                 sra_11.VOLUMERATE,
                                 row_number() OVER (PARTITION BY st_11.vehid, st_11.taskdate, st_11.shift ORDER BY st_11.vehid, st_11.taskdate, st_11.shift, sra_11.worktype) as RowPos
                                from
                                (
                                 select vehid, shiftdate as taskdate, shift from Table(UGH.Idleutils.get_FullListOfShifts(p_StartDate, p_StartShift, p_FinishDate, p_FinishShift))
                    -------------------------------------- завершение блока всех смен периода ----------------------------------------
                                  ) st_11
                        
                                   left join
                                    dispatcher.shiftreportsadv sra_11 on sra_11.vehid = st_11.vehid and sra_11.taskdate = st_11.taskdate and sra_11.shift = st_11.shift
                   ) sra_12
                   ) sra on sra.vehid = st.vehid and sra.taskdate = st.taskdate and sra.shift = st.shift
                    left join 
                    (
                        select vehid, substr(model, 1, 7) model from dispatcher.DumpTrucks  
                    ) dt on st.VEHID = dt.VEHID
                    
                    left join dispatcher.shiftlensandtimes slat on st.VEHID = slat.VEHID and st.TASKDATE = slat.TASKDATE and st.SHIFT = slat.SHIFT
                    left join dispatcher.vehshiftfuel vsf on st.VEHID = vsf.VEHID and st.TASKDATE = vsf.TASKDATE and st.SHIFT = vsf.SHIFT
                    left join 
                    (
                        select 
                            st.VEHID,
                            st.TASKDATE,
                            st.SHIFT,
                            nvl2(dr.FAMNAME, dr.FAMNAME || ' ' || SUBSTR(dr.FIRSTNAME, 1, 1) || '. ' || SUBSTR(dr.SECNAME, 1, 1) || '.', 'Водитель не назначен') AS FIO
                        from 
                            dispatcher.SHIFTTASKS ST
                        left join dispatcher.DRIVERS dr on st.TABELNUM = dr.TABELNUM
                    ) drFio on st.VEHID = drFio.VEHID and st.TASKDATE = drFio.TASKDATE and st.SHIFT = drFio.SHIFT
                    left join 
                    (                    
                        select
                            vehid,
                            shiftdate,
                            shiftnum,
                            TimeFund, 
                            (TechStop + PureNotTechnologStop + OrgStop + OtherStop) as StopTotal,
                            (TimeFund - TechStop - PureNotTechnologStop - OrgStop - OtherStop) as WorkTime,
                            TechStop,
                            TechnologStop,
                            PureTechnologStop,
                            PureNotTechnologStop,
                            OrgStop,
                            OtherStop,
                            ETO,
                            Dinner,
                            PPR_and_TO,
                            MyPureTechnology,
                          (TimeFund-TechStop)/TimeFund as KTG,
                          (TimeFund - TechStop - PureNotTechnologStop - OrgStop - OtherStop)/TimeFund as KIO,
                            DinnerStart,
                            DinnerEnd,
                            1 as RowPos
                            , ReadyGTTStop
                        from
                        (
                            select  
                                stp.Vehid,
                                stp.shiftdate,
                                stp.shiftnum,
                                dispatcher.params.getNumParameter('Продолжительность смены по умолчанию') as TimeFund,
                                nvl(SUM(case when upper(ustcat.name) like '%ТЕХНИЧЕСКИЕ%' then (timego-timestop) else 0 end), 0) * 24 TechStop,
                                nvl(SUM(case when upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' then (timego-timestop) else 0 end), 0) * 24 TechnologStop,
                                nvl(SUM(case when upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%' then (timego-timestop) else 0 end), 0) * 24 OrgStop,
                                nvl(SUM(case when upper(ustcat.name) like '%ПРОЧИЕ%' or idlestoptype is null then (timego-timestop) else 0 end), 0) * 24 OtherStop,
                                min(case when upper(usttyp.name) like '%ОБЕД%' then timestop else null end) DinnerStart,
                                max(case when upper(usttyp.name) like '%ОБЕД%' then timego else null end) DinnerEnd,
                                
                                nvl(SUM(case when upper(usttyp.name) like '%ОБЕД%' then (timego-timestop) else 0 end),0) * 24 Dinner,
                                nvl(SUM(case when upper(usttyp.name) like '%ЕТО%' then (timego-timestop) else 0 end),0) * 24 ETO,
                                nvl(SUM(case when upper(usttyp.name) like '%ППР%' or upper(usttyp.name) like 'ТО' then (timego-timestop) else 0 end),0) * 24 PPR_and_TO,
                                
                                nvl(SUM(case when upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' and usttyp.code not in (1661, 1662) then (timego-timestop) else 0 end), 0) * 24 PureNotTechnologStop,
                                nvl(SUM(case when upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' and usttyp.code in (1661, 1662) then (timego-timestop) else 0 end), 0) * 24 PureTechnologStop,
                                nvl(SUM(case when upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' and usttyp.code in (1661, 1662, 155, 156) then (timego-timestop) else 0 end), 0) * 24 MyPureTechnology
                                 ,
                COALESCE(SUM(case when (upper(ustcat.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' or upper(ustcat.name) like '%ОРГАНИЗАЦИОННЫЕ%') and
                            
                          
        ( usttyp.code not in (1661 /*погрузка*/, 1662 /*разгрузка*/)
        and usttyp.code not in (155	/*Ожидание_погрузки*/, 156 /*Ожидание_разгрузки*/)
        and usttyp.code not in (913 /*ЕТО*/, 910 /*ТО*/)
        and usttyp.code not in (917	/*Личные нужды*/)
        and usttyp.code not in (4	/*Обед*/)
        and usttyp.code not in (934	/*Заправка*/)
        and ((timego - timestop) >= 3 / 24 / 60))
             then (timego - timestop)                   
                                else 0 end),0) * 24 as ReadyGTTStop
                            from 
         
                             (-----------------------------------------------------
                 --- мой запрос
                   
                 select ds_8.vehid, 
                        idleStopType,
                        greatest(ttt1.timestop,UGH.getpredefinedtimeFrom('за указанную смену',ds_8.shift, ds_8.shiftdate)) as timestop,
                        least(ttt1.timego,UGH.getpredefinedtimeTo('за указанную смену',ds_8.shift, ds_8.shiftdate)) timego,
                        null fullshiftstatus,
                        ds_8.shiftdate, 
                        ds_8.shift as shiftnum
                 from (
                        select vehid, shiftdate, shift from Table(UGH.IDLEUTILS.get_TaskShiftDates(p_StartDate,p_StartShift,p_FinishDate,p_FinishShift))
                        MINUS
                        select vehid, shiftdate, shift from Table(UGH.IDLEUTILS.get_RepairShiftDates(p_StartDate,p_StartShift,p_FinishDate,p_FinishShift))
                        MINUS
                        select vehid, shiftdate, shift from Table(UGH.IDLEUTILS.get_FullShiftIdlesDate(p_StartDate,p_StartShift,p_FinishDate,p_FinishShift))
                 ) ds_8
                 left join (select * from dispatcher.ShiftStoppages t2 where t2.shiftdate between p_StartDate-1 and p_FinishDate+1)ttt1
                   on ttt1.vehid=ds_8.vehid 
                      and ttt1.timestop<=UGH.getpredefinedtimeTo('за указанную смену', ds_8.shift, ds_8.shiftdate)
                      and ttt1.timego>UGH.getpredefinedtimeFrom('за указанную смену',ds_8.shift, ds_8.shiftdate)
                   
                  --========= Подцепка ремонтных листов -----------------------------------
                  union
                  select vehid, stoptypecode idlestoptype,
                         UGH.getpredefinedtimefrom('за указанную смену',s_shifts.shift,s_shifts.taskdate) timestop,
                     UGH.getpredefinedtimeto('за указанную смену',s_shifts.shift,s_shifts.taskdate) timego,
                      'repair' fullshiftstatus,
                      s_shifts.taskdate as shiftdate, s_shifts.shift as shiftnum from dispatcher.repairsheets rps
                  left join
                   (SELECT distinct 
                 
                    UGH.getcurshiftdate(0, UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate)+level*0.5-0.5) taskdate,
                    UGH.getcurshiftnum(0, UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate)+level*0.5-0.5) shift
                   from  dual
                   CONNECT BY UGH.GetPredefinedtimeFrom('за указанную смену', p_StartShift, p_StartDate) + level*.5
                              <=UGH.GetPredefinedtimeTo('за указанную смену', p_FinishShift, p_FinishDate) ) s_shifts on 1=1
                   
                      where (rps.timebegin between UGH.GetPredefinedTimeFrom('за указанную смену', p_StartShift, p_StartDate)-720 and
                          UGH.GetPredefinedTimeTo('за указанную смену', p_FinishShift, p_FinishDate)-1/720 ) 
                             and (rps.timeend between UGH.GetPredefinedTimeFrom('за указанную смену', p_StartShift, p_StartDate)+1/720 and
                             UGH.GetPredefinedTimeTo('за указанную смену', p_FinishShift, p_FinishDate)+720)
                         
                         and UGH.GetPredefinedTimeFrom('за указанную смену', s_shifts.shift,s_shifts.taskdate)
                             >=rps.timebegin 
                         and UGH.GetPredefinedTimeFrom('за указанную смену', s_shifts.shift,s_shifts.taskdate)
                             <rps.timeend
                 
               ------- Завершение подцепки ремонтных листов -------------------------
               ------- Подцепка целосменных простоев --------------------------------
               union
               select vehid, FullShiftstopCode idlestoptype,
                             UGH.GetPredefinedTimeFrom('за указанную смену', shift, taskdate) timestop, 
                             UGH.GetPredefinedTimeTo('за указанную смену', shift, taskdate) timego,
                             'myfull' fullshiftstatus,
                             taskdate as shiftdate, 
                             shift as shiftnum
               from dispatcher.fullshiftstoppagesdetails
               where ((TaskDate = p_StartDate and Shift >= p_StartShift)or(TaskDate > p_StartDate))
                        and ((TaskDate = p_FinishDate and p_FinishShift >= Shift)or(p_FinishDate > TaskDate)) 
            
              ) stp
              
              
                           left join dispatcher.userstoppagetypes usttyp on usttyp.code = stp.idlestoptype
                            left join dispatcher.userstoppagecategories ustcat on ustcat.id = usttyp.categoryid 
               ---- мой код
                 --        where vehid ='15' 
                 --      order by ustcat.id, shiftdate, shiftnum, timestop
               --- конец моего кода
              where timego>timestop -- and vehid='15'
      ---        group by ustcat.name, usttyp.name
           --   order by timestop
                            group by stp.vehid, stp.shiftdate, stp.shiftnum
                        ) stpinf
                        -- Если не нужно выводить только одну строку на смену, то комментируем sra.RowPos=stopInfo.RowPos
                    ) stopinfo on sra.RowPos=stopInfo.RowPos and st.vehid = stopinfo.vehid and st.taskdate = stopinfo.shiftdate and st.shift = stopinfo.shiftnum
                    left join
                    (
                        select vehid, shiftdate, shiftnum, sum(movelength)/1000 lengthSum, sum(timemove) timeSum from
                        (    
                            select 
                                vehid,
                                UGH.getcurshiftdate(0, timego) shiftdate,
                                UGH.getcurshiftnum(0, timego) shiftnum,
                                movelength,
                                abs(timestop - timego) * 24 timemove
                            from
                                dispatcher.simpletransitions
                            where
                                ((movelength > dispatcher.params.getnumparameter('Максимальное расстояние до точки разгрузки') and weight = 0 and avgspeed > 10)
                                or (movelength > dispatcher.params.getnumparameter('Максимальное расстояние до экскаватора')  and weight > 0 and avgspeed > 10))
                                and timego between UGH.getpredefinedtimefrom('за указанную смену', p_StartShift, p_StartDate)
                                and UGH.getpredefinedtimeto('за указанную смену', p_FinishShift, p_FinishDate)
                            order by 
                                timego desc
                        ) group by vehid, shiftdate, shiftnum
                    ) speedinfo on st.vehid = speedinfo.vehid and st.taskdate = speedinfo.shiftdate and st.shift = speedinfo.shiftnum 
                    where 
                                (vsf.tasktype='ST' or vsf.tasktype is NULL) and --and timefund>0 and
                        ((st.taskdate = p_StartDate and st.shift >= p_StartShift)or(st.taskdate > p_StartDate))
                        and ((st.taskdate = p_FinishDate and p_FinishShift >= st.shift)or(p_FinishDate > st.taskdate)) --and st.vehid='15'
                    order by 
                        lpad(dt.vehid, 11), st.vehid, st.taskdate, st.shift/*, sra.loadheight*/, sra.worktype /*, sra.unloadid*/) 
                  
        --============================================================
        
        
        ) loop
          pipe row (r_DumpTrucksReport);
        end loop;
end; -- End of main loop


--=========================================================
-- тестовая функция формирования отчета по буровым станкам
--=========================================================
function get_RigReport_test (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_RigReport pipelined is
  begin
       for r_RigReport in
        (
                    select
                    MODELS.MODELNAME || ' ' || rig.REGNUMBER AS RigName,
                    sreport.taskdate taskdate,
                    sreport.SHIFT,
                    COALESCE(stask.FIO, 'Машинист не назначен') fio,

                    sreport.SHIFTSTARTTIME,
                    sreport.SHIFTFINISHTIME,

                    COALESCE(wellsInfFact.blockName, 'Без проекта') blockName,
                    wellsInfFact.wellDepthSumFact,
                    wellsInfFact.wellCountFact,
                    wellsInfFact.wellDepthAvgFact,
                    wellsInfFact.drillDurationAvgFact,
              --      wellsInfFact.wellDepthSumPlan,
              --      wellsInfFact.WellsDepthAvgPlan,
                        case
                        when wellsInfFact.drillDurationAvgFact > 0
                             then wellsInfFact.wellDepthAvgFact / wellsInfFact.drillDurationAvgFact
                        else null end
                    drillSpeed,
                        CASE when WorkTime>0 then
                        sum(wellsInfFact.wellDepthSumFact) 
                        over (partition by sreport.vehid, sreport.taskdate, sreport.shift) 
                        / WorkTime
                        else 0 END
                    drillproductivity,

                    stopppageinfo.TimeFund,
                    stopppageinfo.StopTotal,
                    stopppageinfo.WorkTime,
                    stopppageinfo.TechStop,
                    stopppageinfo.TechnologStop,
                    stopppageinfo.OrgStop,
                    stopppageinfo.OtherStop,
                    stopppageinfo.KTG,
                    stopppageinfo.KIO,
                    '' StopPrich
                , ReadyGTTStop
        from rigs.rigs@rigs rig
        left join rigs.models@rigs on rig.modelid = rigs.models.modelid
        right join 
        (
          select vehid, taskdate, shift, shiftstarttime, shiftfinishtime
          from rigs.rigsshiftreports@rigs
          where               
                        ((taskdate = p_StartDate and shift >= p_StartShift)or(taskdate > p_StartDate))
                        and ((taskdate = p_FinishDate and p_FinishShift >= shift)or(p_FinishDate > taskdate))
        ) sreport ON rig.RIGID =sreport.vehID 
        left join (
          SELECT dst.RIGID, dst.TASK_DATE, dst.SHIFT,
          nvl2(drv.famname, drv.famname || ' ' || substr(drv.firstname, 1, 1) || '. ' || substr(drv.secname, 1, 1) || '.', 'Машинист не назначен') fio
          FROM rigs.SHIFTTASKS_V2@rigs dst
          LEFT JOIN rigs.AUXDRIVERS@rigs drv  ON  dst.TABEL_NUM = drv.TABELNUM 
          WHERE               
                        ((task_date = p_StartDate and shift >= p_StartShift)or(task_date > p_StartDate))
                        and ((task_date = p_FinishDate and p_FinishShift >= shift)or(p_FinishDate > task_date))
        ) stask ON  stask.RIGID= sreport.VEHID
         AND stask.task_date = sreport.taskdate  AND stask.SHIFT = sreport.SHIFT
                left join (select  rigid, shiftdate, shiftnum, blockname, wellDepthSumFact, wellCountFact,wellDepthAvgFact,drillDurationAvgFact,
                          nvl(RowPos,1) as RowPos from
                 (
                          select vehid, taskdate, shift, shiftstarttime, shiftfinishtime
                                 from rigs.rigsshiftreports@rigs
                            where               
                        ((taskdate = p_StartDate and shift >= p_StartShift)or(taskdate > p_StartDate))
                        and ((taskdate = p_FinishDate and p_FinishShift >= shift)or(p_FinishDate > taskdate))
                 ) sreport_1
                left join
                (     select  
                        rigid, shiftdate, shiftnum, blockname,
                        sum(depth_fact)/100 as wellDepthSumFact, count(id) as wellCountFact, 
                    --    nvl(sum(depth_plan),0) as wellDepthSumPlan,
                        avg(depth_fact)/100 as wellDepthAvgFact, avg(drillingDuration) as drillDurationAvgFact,
                        row_number() over (partition by rigid, shiftdate, shiftnum order by rigid, shiftdate, shiftnum, blockname) as RowPos
                     --   nvl(avg(depth_plan),0) as wellsDepthAvgPlan
                    from
                    (
                        select
              shiftRep.vehid as RigID, shiftRep.shift as ShiftNum, shiftRep.taskdate as ShiftDate, blocks.block_name as BlockName,
              wellsFact.id, (case WHEN wellsFact.depth_fact=0 then wells.depth_plan*100 else wellsFact.depth_fact end) as depth_fact, wells.depth_plan,
              COALESCE((wellsFact.timeEndDrillingGmt - wellsFact.timeBeginDrillingGmt) * 24 * 60, 0) as drillingDuration
                        from
                        rigs.wellsbyfact@rigs wellsfact
                        left join
                            rigs.wells@rigs wells on wells.wellid = wellsfact.wellid_result
                        left join
                            rigs.blocks@rigs blocks on blocks.blockid = wells.blockid
                        right join
                            rigs.rigsshiftreports@rigs shiftRep on shiftRep.vehid = wellsfact.rigid and
                            wellsfact.timeBeginDrillingGmt > UGH.Datetime.local_to_gmt(shiftRep.shiftstarttime)
                            and UGH.Datetime.local_to_gmt(shiftRep.shiftfinishtime) >= wellsfact.timebegindrillinggmt
                        where 
              ((taskdate = p_StartDate and shift >= p_StartShift)or(taskdate > p_StartDate))
                            and ((taskdate = p_FinishDate and p_FinishShift >= shift)or(p_FinishDate > taskdate))
                    ) 
                    group by rigid, shiftdate, shiftnum, blockname
                ) wellsInfFact_1  ON sreport_1.vehID = wellsInfFact_1.rigid AND wellsInfFact_1.shiftdate= sreport_1.taskdate  AND wellsInfFact_1.shiftNum = sreport_1.SHIFT
                ) wellsInfFact ON sreport.vehID = wellsInfFact.rigid AND wellsInfFact.shiftdate= sreport.taskdate  AND wellsInfFact.shiftNum = sreport.SHIFT
                left join
                (
                    select  stopppageinfo.rigid,
                            stopppageinfo.shiftnum,
                            stopppageinfo.shiftDate,
                            stopppageinfo.TimeFund, 
                            (stopppageinfo.TechStop + stopppageinfo.TechnologStop + stopppageinfo.OrgStop + stopppageinfo.OtherStop) as StopTotal,
                            (stopppageinfo.TimeFund - stopppageinfo.TechStop - stopppageinfo.TechnologStop - stopppageinfo.OrgStop - stopppageinfo.OtherStop) as WorkTime,
                            stopppageinfo.TechStop,
                            stopppageinfo.TechnologStop,
                            stopppageinfo.OrgStop,
                            stopppageinfo.OtherStop,
                            (stopppageinfo.TimeFund - stopppageinfo.TechStop) / stopppageinfo.TimeFund as KTG,
                            (stopppageinfo.TimeFund - stopppageinfo.TechStop - stopppageinfo.TechnologStop - stopppageinfo.OrgStop-stopppageinfo.OtherStop) / stopppageinfo.TimeFund as KIO,
                            1 as RowPos
                             , ReadyGTTStop
                    from
                    (
                        select  st.rigId, 
                                st.shiftDate,
                                st.ShiftNum,
                                dispatcher.params.getnumparameter('Продолжительность смены по умолчанию') TimeFund,
                                COALESCE(SUM(case when upper(stopcats.name) like '%ТЕХНИЧЕСКИЕ%' then (timego-timestop) else 0 end) * 24, 0) TechStop,
                                COALESCE(SUM(case when upper(stopcats.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' then (timego-timestop) else 0 end) * 24, 0) TechnologStop,
                                COALESCE(SUM(case when upper(stopcats.name) like '%ОРГАНИЗАЦИОННЫЕ%' then (timego-timestop) else 0 end), 0) * 24 OrgStop,
                                COALESCE(SUM(case when  (upper(stopcats.name) like '%ПРОЧИЕ%' or idlestoptype is null) then (timego-timestop) else 0 end), 0) * 24 OtherStop
                                ,
                COALESCE(SUM(case when (upper(stopcats.name) like '%ТЕХНОЛОГИЧЕСКИЕ%' or upper(stopcats.name) like '%ОРГАНИЗАЦИОННЫЕ%') and
                            
                          
        (  stoptypes.code not in (401 /*ЕТО*/, 402 /*ТО*/) --они и так не входят в технологические и организационные
        and stoptypes.code not in (417	/*Личные нужды*/)
        and stoptypes.code not in (415	/*Обед*/)
        and stoptypes.code not in (418	/*Заправка*/)
        and ((timego - timestop) >= 3 / 24 / 60))
             then (timego - timestop)                   
                                else 0 end),0) * 24 as ReadyGTTStop
                        from
                        (
                            select  vehid as rigid,
                                    idleStopType,
                                    gmtTimestop+1/3 as timeStop,
                                    gmtTimego+1/3 as timeGo,
                                    shiftDate,
                                    shiftNum
                            from rigs.shiftstoppages@rigs st
                            where 
                            ((shiftdate = p_StartDate and shiftnum >= p_StartShift)or(shiftdate > p_StartDate))
                            and ((shiftdate = p_FinishDate and p_FinishShift >= shiftnum)or(p_FinishDate > shiftdate))
                        ) st 
                        left join
                        (
                            select  code,
                                    categoryid,
                                    isrepair
                            from rigs.UserStoppageTypes@rigs
                        ) stoptypes on st.IdleStopType = stoptypes.Code
                        left join rigs.userstoppagecategories@rigs stopcats on stoptypes.categoryid = stopcats.id
                        group by st.shiftDate, st.shiftnum, st.rigid
                    ) stopppageinfo
                ) stopppageinfo ON WellsInfFact.RowPos=stopppageinfo.RowPos and sreport.vehID = stopppageinfo.rigid AND sreport.taskdate = stopppageinfo.shiftdate  AND sreport.SHIFT = stopppageinfo.shiftNum 
                order by lpad(rigname, 30), taskdate, shift, blockname
        ) loop
          pipe row (r_RigReport);
   end loop;
end;

---============= Функции для страшных вьюшек ========
function get_vPlanFactHourSumHalf return t_vPlanFactHourSumHalf pipelined is
 v_prev_volume float;
 v_prev_plan_hour_half float;
 v_cur_half number;
 begin
   v_cur_half:=0;
   v_prev_volume:=0;
   v_prev_plan_hour_half:=0;
   for x in 1..24 loop
      v_cur_half:= v_cur_half+1;
      if v_cur_half=3 then
         v_cur_half:=1;
      end if;
       for r_vPlanFactHourSumHalf in
        (
           select sel1.volume as halfvolume, v_prev_volume+sel1.volume as volume,v_prev_plan_hour_half+sel1.plan_hour_half as plan_hour_half,sel1.shitfhour_half, sel1.shitfhour
                  ,sel1.shitfhour_half_t
                  , (CASE WHEN sel1.plan_hour_half>0 THEN round(sel1.volume/sel1.plan_hour_half,2) ELSE 0 END) as planfact_percent
                  from (

                  select sum(volume) as volume,
                     sum(plan_hour_half) as plan_hour_half,
                      x as shitfhour_half,
                       ceil(x/2) as shitfhour,
                         (CASE WHEN ceil(x/2)<10 then '0'||TO_CHAR(ceil(x/2)) ELSE TO_CHAR(ceil(x/2)) END)||'_'||to_char(v_cur_half) as shitfhour_half_t
                        from ugh.v_planfact_hoursum_half_shov
 -- from ugh.v_planfact_hour_volume_half
               where shifthour_half = x ) sel1
        ) loop
      
          v_prev_volume:=r_vPlanFactHourSumHalf.volume;
          v_prev_plan_hour_half:=r_vPlanFactHourSumHalf.plan_hour_half;
          pipe row (r_vPlanFactHourSumHalf);
     end loop;
   end loop;
end;

function get_vPlanFactHourSum return t_vPlanFactHourSum pipelined is
 v_prev_volume float;
 v_prev_plan_hour float;
 
 begin
  
   v_prev_volume:=0;
   v_prev_plan_hour:=0;
   for x in 1..12 loop
      
     
       for r_vPlanFactHourSum in
        (
           select  v_prev_volume+sel1.volume as volume,v_prev_plan_hour+sel1.plan_hour as plan_hour, sel1.shitfhour
                 
                  , (CASE WHEN sel1.plan_hour>0 THEN round(sel1.volume/sel1.plan_hour,2) ELSE 0 END) as planfact_percent
                  from (

                  select sum(volume) as volume,
                     sum(plan_hour_half) as plan_hour,
                     
                       ceil(x) as shitfhour
                      --   (CASE WHEN ceil(x/2)<10 then '0'||TO_CHAR(ceil(x/2)) ELSE TO_CHAR(ceil(x/2)) END)||'_'||to_char(v_cur_half) as shitfhour_half_t
                        from ugh.v_planfact_hoursum_half_shov
 -- from ugh.v_planfact_hour_volume_half
               where shifthour = x ) sel1
        ) loop
      
          v_prev_volume:=r_vPlanFactHourSum.volume;
          v_prev_plan_hour:=r_vPlanFactHourSum.plan_hour;
          pipe row (r_vPlanFactHourSum);
     end loop;
   end loop;
end;

END PAC_VIEWS;
