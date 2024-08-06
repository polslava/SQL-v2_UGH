
  CREATE OR REPLACE FORCE VIEW "UGH"."V_UGH_REPORT_RIGS" ("RIGNAME", "PLAN_DAY", "WELLCOUNT1", "WELLDEPTHSUMFACT1", "WORKTIME1", "WELLCOUNT2", "WELLDEPTHSUMFACT2", "WORKTIME2", "WELLCOUNT3", "WELLDEPTHSUMFACT3", "WORKTIME3", "ETO", "ORGSTOP", "TECHNOLOGSTOP", "READYGTTSTOP", "TECHSTOP", "TO_PPR", "KTG", "KIO", "BLOCK_DRILLED1", "BLOCK_DRILLED2") AS 
  SELECT r1.rigname 
    , round(pdv.value_plan,2) as plan_day
    /*, nvl(sel1.wellcount,0) as wellcount1
    , nvl(sel1.wellDepthSumFact,0) as wellDepthSumFact1*/
    ,rvs_1.VALUE_FACT_HOLE as wellcount1 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    ,rvs_1.VALUE_FACT_M as wellDepthSumFact1 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    , nvl(sel1.WorkTime,0) as WorkTime1
    /*, nvl(sel2.wellcount,0) as wellcount2
    , nvl(sel2.wellDepthSumFact,0) as wellDepthSumFact2*/
    ,rvs_2.VALUE_FACT_HOLE as wellcount2 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    ,rvs_2.VALUE_FACT_M as wellDepthSumFact2 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    , nvl(sel2.WorkTime,0) as WorkTime2
    /*, nvl(sel3.wellcount,0) as wellcount3
    , nvl(sel3.wellDepthSumFact,0) as wellDepthSumFact3*/
    ,(nvl(rvs_1.VALUE_FACT_HOLE,0)+rvs_2.VALUE_FACT_HOLE) as wellcount3 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    ,(nvl(rvs_1.VALUE_FACT_M,0) +rvs_2.VALUE_FACT_M) as wellDepthSumFact3 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    , nvl(sel3.WorkTime,0) as WorkTime3
    , nvl(sel3.StopETO,0) as eto
    , nvl(sel3.OrgStop,0) as OrgStop
    , nvl(sel3.TechnologStop,0) as TechnologStop
    , nvl(sel3.ReadyGTTStop,0) as ReadyGTTStop  /*20221205 простои исправного √““*/
    , nvl(sel3.TechStop ,0) as TechStop
    , nvl(sel3.StopTO_PPR,0) as TO_PPR
    , nvl(sel3.KTG,0) as KTG
    , nvl(sel3.KIO,0) As KIO
    /*, sel1.block_drilled1
    , sel2.block_drilled2*/
    ,rvs_1.BLOCK_NAME as block_drilled1 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    ,rvs_2.BLOCK_NAME as block_drilled2 /*20221024 - ручные значени€ факта из назначени€ бурстанков на блока*/
    from rigs.rigs@rigs r1 /*список бурстанков дл€ отчЄта*/
    left join (
    
select
				
                s.regnumber,
				s.taskdate ,
				/*s.SHIFT ,*/
				sum(round(s.wellDepthSumFact,2)) as wellDepthSumFact,
				sum(round(s.WorkTime,2)) as WorkTime,
				/*sum(round(s.StopTotal,2)) as StopTotal,
				sum(round(s.TechStop,2)) as TechStop,
				sum(round(s.TechnologStop,2)) as TechnologStop,
				sum(round(s.OrgStop,2)) as OrgStop,
				sum(round(s.OtherStop,2)) as OtherStop,
				avg(round(s.KIO,2)) as KIO,
				avg(round(s.KTG,2)) as KTG,*/
                 s.reportorder_svodka
                , sum(round(s.wellDepthSumFact/s.wellDepthAvgFact,0)) as wellcount
                ,LISTAGG(blockname||
    (case when wellcountfact=0 then '' else
    ' '||round(wellcountfact)||'/'||round(welldepthsumfact,2)||'м' end), 
    '; ') WITHIN GROUP (ORDER BY blockname, wellcountfact, welldepthsumfact) as block_drilled1
    
				from(
				select * 
                    from Table(UGH.pac_views.get_RigReport_test(
                        to_date(to_char(sysdate-1,'dd.mm.yyyy')) /*:ParamDateBegin*/, 1 /*:ParamShiftBegin*/
                        , to_date(to_char(sysdate-1,'dd.mm.yyyy'))/*:ParamDateEnd*/, 1 /*:ParamShiftEnd*/)) t /*данные только за первую смену*/
				left join 
				 (SELECT * from rigs.rigs@rigs rig
				  left join rigs.models@rigs models on rig.modelid = models.modelid
                  where rig.isfunctional = 1) r
				  on t.RigName=r.MODELNAME || ' ' || r.REGNUMBER
                left join ugh.enterprise_veh ev on ev.vehid=r.regnumber
				where r.isfunctional=1) s
                group by s.regnumber, s.taskdate, s.SHIFT , s.reportorder_svodka
                --where s.blockname not like 'Ѕез проекта'
                --order by s.reportorder_svodka
                ) sel1 on sel1.regnumber = r1.REGNUMBER
        left join (
    
select
				
                s.regnumber,
				/*s.taskdate ,
				s.SHIFT ,*/
				sum(round(s.wellDepthSumFact,2)) as wellDepthSumFact,
				sum(round(s.WorkTime,2)) as WorkTime,
				/*sum(round(s.StopTotal,2)) as StopTotal,
				sum(round(s.TechStop,2)) as TechStop,
				sum(round(s.TechnologStop,2)) as TechnologStop,
				sum(round(s.OrgStop,2)) as OrgStop,
				sum(round(s.OtherStop,2)) as OtherStop,
				avg(round(s.KIO,2)) as KIO,
				avg(round(s.KTG,2)) as KTG,*/
                 s.reportorder_svodka
                , sum(round(s.wellDepthSumFact/s.wellDepthAvgFact,0)) as wellcount
                 ,LISTAGG(blockname||
    (case when wellcountfact=0 then '' else
    ' '||round(wellcountfact)||'/'||round(welldepthsumfact,2)||'м' end), 
    '; ') WITHIN GROUP (ORDER BY blockname, wellcountfact, welldepthsumfact) as block_drilled2
				from(
				select * 
                    from Table(UGH.pac_views.get_RigReport_test(
                        to_date(to_char(sysdate-1,'dd.mm.yyyy')) /*:ParamDateBegin*/, 2 /*:ParamShiftBegin*/
                        , to_date(to_char(sysdate-1,'dd.mm.yyyy'))/*:ParamDateEnd*/, 2 /*:ParamShiftEnd*/)) t /*данные только за вторую смену*/
				left join 
				 (SELECT * from rigs.rigs@rigs rig
				  left join rigs.models@rigs models on rig.modelid = models.modelid
                  where rig.isfunctional = 1) r
				  on t.RigName=r.MODELNAME || ' ' || r.REGNUMBER
                left join ugh.enterprise_veh ev on ev.vehid=r.regnumber
				where r.isfunctional=1) s
                group by s.regnumber, s.taskdate, s.SHIFT , s.reportorder_svodka
                --where s.blockname not like 'Ѕез проекта'
                --order by s.reportorder_svodka
                ) sel2 on sel2.regnumber = r1.REGNUMBER
 left join (
   
select
				
                s.regnumber,
				/*s.taskdate ,
				s.SHIFT ,*/
				sum(round(s.wellDepthSumFact,2)) as wellDepthSumFact,
				sum(round(s.WorkTime,2)) as WorkTime,
				sum(round(s.StopTotal,2)) as StopTotal,
                sel_Tech.StopTech as TechStop,
				/*sum(round(s.TechStop,2)) as TechStop,*/
				sum(round(s.TechnologStop,2)) as TechnologStop,
				sum(round(s.OrgStop,2)) as OrgStop,
				sum(round(s.OtherStop,2)) as OtherStop,
				sum(round(s.KIO,2))/2 as KIO,
				sum(round(s.KTG,2))/2 as KTG,
                 s.reportorder_svodka
                , sum(round(s.wellDepthSumFact/s.wellDepthAvgFact,0)) as wellcount
                --, sum(sel_ETO.StopETO) as StopETO
                ,sel_ETO.StopETO
                ,sel_TO_PPR.StopTO_PPR
                --, s.rigid
                , round(sum(ReadyGTTStop ),2) as ReadyGTTStop
				from(
				select * 
                    from Table(UGH.pac_views.get_RigReport_test(
                        to_date(to_char(sysdate-1,'dd.mm.yyyy')) /*:ParamDateBegin*/, 1 /*:ParamShiftBegin*/
                        , to_date(to_char(sysdate-1,'dd.mm.yyyy'))/*:ParamDateEnd*/, 2 /*:ParamShiftEnd*/)) t /*данные только за вторую смену*/
				left join 
				 (SELECT * from rigs.rigs@rigs rig
				  left join rigs.models@rigs models on rig.modelid = models.modelid
                  where rig.isfunctional = 1) r
				  on t.RigName=r.MODELNAME || ' ' || r.REGNUMBER
                left join ugh.enterprise_veh ev on ev.vehid=r.regnumber
               	where r.isfunctional=1) s
                 left join 
                ( select vehid, sum(round((timego-timestop)*24,2)) as StopETO
    from rigs.shiftstoppages@rigs st
    where shiftdate = to_date(to_char(sysdate-1,'dd.mm.yyyy')) 
        --and shiftnum = :ParamShift
        and userstopid = 17
        group by vehid) sel_ETO on sel_ETO.vehid = s.rigid
left join 
                ( select vehid, sum(round((timego-timestop)*24,2)) as StopTO_PPR
    from rigs.shiftstoppages@rigs st
    where shiftdate = to_date(to_char(sysdate-1,'dd.mm.yyyy')) 
        --and shiftnum = :ParamShift
        and userstopid = 18
        group by vehid) sel_TO_PPR on sel_TO_PPR.vehid = s.rigid                
			
left join  
        (select vehid, sum(round((timego-timestop)*24,2)) as StopTech
            /*, st.userstopid
            , ust.name*/
    from rigs.shiftstoppages@rigs st
        left join rigs.userstoppagetypes@rigs ust on st.userstopid = ust.code
    where shiftdate = to_date(to_char(sysdate-1,'dd.mm.yyyy')) 
        --and shiftnum = :ParamShift
        And ust.categoryid = 6
        and st.userstopid not in (17, 18) /* все технические кроме “ќ и ѕѕ–*/
        group by vehid) sel_Tech on sel_Tech.vehid = s.rigid  
                group by s.regnumber, /*s.taskdate, s.SHIFT ,*/ s.reportorder_svodka
                --where s.blockname not like 'Ѕез проекта'
                --order by s.reportorder_svodka
                ,sel_ETO.StopETO
                ,sel_TO_PPR.StopTO_PPR
                , sel_Tech.StopTech

                ) sel3 on sel3.regnumber = r1.REGNUMBER
    left join ugh.pite_day_veh pdv 
        on pdv.veh_id = r1.rigname and pdv.veh_type = 'Ѕурстанок'
            and pdv.plandate = sel1.taskdate
               
 left join (
    
select --rvs.* 
rvs.DATESHIFT                
/*,rvs.SHIFT */
/*,rvs.WORKTYPE  */
,nvl(round(sum(rvs.VALUE_FACT_M ),2),0) as VALUE_FACT_M
,nvl(round(sum(rvs.VALUE_FACT_HOLE ),2),0) as VALUE_FACT_HOLE
,rvs.RIGNAME                                            

,LISTAGG(
(case when rvs.WORKTYPE like '%перебур%' then 'ѕ-бур ' else '' end)
||
rvs.BLOCK_NAME||
    (case when VALUE_FACT_HOLE=0 then '' else
    ' '||round(VALUE_FACT_HOLE)||'/'||round(VALUE_FACT_M,2)||'м' end), 
    '; ') WITHIN GROUP (ORDER BY rvs.BLOCK_NAME, rvs.VALUE_FACT_HOLE, rvs.VALUE_FACT_M ) as BLOCK_NAME
    from v_rigs_value_shift rvs
    where rvs.dateshift = to_date(to_char(sysdate-1,'dd.mm.yyyy')) and rvs.shift = 1  /*данные за смену 1*/
    group by rvs.DATESHIFT ,rvs.RIGNAME
    ) rvs_1 on rvs_1.RIGNAME = sel1.regnumber and rvs_1.DATESHIFT =sel1.taskdate 
  left join (
    
select --rvs.* 
rvs.DATESHIFT                
/*,rvs.SHIFT */
/*,rvs.WORKTYPE  */
,nvl(round(sum(rvs.VALUE_FACT_M ),2),0) as VALUE_FACT_M
,nvl(round(sum(rvs.VALUE_FACT_HOLE ),2),0) as VALUE_FACT_HOLE
,rvs.RIGNAME                                            

,LISTAGG(
(case when rvs.WORKTYPE like '%перебур%' then 'ѕ-бур ' else '' end)
||
rvs.BLOCK_NAME||
    (case when VALUE_FACT_HOLE=0 then '' else
    ' '||round(VALUE_FACT_HOLE)||'/'||round(VALUE_FACT_M,2)||'м' end), 
    '; ') WITHIN GROUP (ORDER BY rvs.BLOCK_NAME, rvs.VALUE_FACT_HOLE, rvs.VALUE_FACT_M ) as BLOCK_NAME
    from v_rigs_value_shift rvs
    where rvs.dateshift = to_date(to_char(sysdate-1,'dd.mm.yyyy')) and rvs.shift = 2 /*данные за смену 2*/
    group by rvs.DATESHIFT ,rvs.RIGNAME
    ) rvs_2 on rvs_2.RIGNAME = sel1.regnumber and rvs_2.DATESHIFT =sel1.taskdate 
  
               where r1.isfunctional=1
                order by sel1.reportorder_svodka, r1.rigname;
