create or replace PACKAGE PAC_PITE_PLAN AS 

  
type r_Pite_Plan_Shovels is record(
shovid varchar (50),
WEIGHT number(10,2),
volume_plan number(10,2),
volume_sum number(10,2),
worktype varchar (100)
,shift_hour number(2)
,shift_hour_dd varchar (5)
);

type t_Pite_Plan_Shovels is table of r_Pite_Plan_Shovels;


function get_Shovels_volume_PlanFact /*(p_StartDate date , p_StartShift integer)*/ return t_Pite_Plan_Shovels pipelined;


type r_Shovel_STP_Report is record (
          MODEL varchar2(50),
          VEHID varchar(50), 
          KTG float, 
          KIO float, 
          PLANSTOP float,
          FONDRAB float,
          PlanKTG float, 
          WORKTIMEBALANCE float, 
          WorkTimeOnLine float, 
					STOPTECH float,  
					StopTechETO float,
					StopTechPPR float, 
          StopTechTO float,
					StopTechHydro float,
          StopTechTransmission float,
					StopTechEngine float,
					StopTechMounted float,
					StopTechHandle float,
					StopTechArrow float,
					StopTechGrease float,
					StopTechChasis float,
					StopTechFire float,
					StopTechTire float,
					StopTechElectric float,
					
					STOPORG float,
					StopOrgFrontMissing float,
					StopOrgCrewMissing float,
					StopOrgGeologWork float,
					StopOrgFuelMissing float,
					StopOrgWashing float,
					
					StopOther float,
					StopOtherClimat float,
					StopOtherDust float,
          StopUndefined float,
					
					STOPTECHNOLOG float,
					StopTechnologVist float,
					StopTechnologWAITING float,
					StopTechnologHEATING float,
					StopTechnologBVR float,
					StopTechnologREFUEL float,
					StopTechnologTRASFER float,
					StopTechnologDINNER float,
					StopTechnologWashingShov float,
					StopTechnologNeeds float,
					StopAll float
                    ,taskdate date
                    , shift number(1)
);

type t_Shovel_STP_Report is table of r_Shovel_STP_Report;

function get_Shovel_STP_Report_PlanFact (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_Shovel_STP_Report pipelined;


/*за основу взят тип из отчёта по самосвалам*/
type r_DumpTrucks_STP_KTG_planf is record(
          MODEL varchar2(50),
          VEHID varchar2(50),
          TimeFund float,
          WorkTime float,
          StopTotal float,
          TechStop float,
          TechnologStop float,
          PureTechnologStop float,
          PureNotTechnologStop float,
          OrgStop float,
          OtherStop float,
          MyPureTechnology float,
             -- Добавляем все простои из "родного" отчета ВГ
                            Tech_PPR_and_TO float,
									          Tech_ETO float,
								                --- Технические
									          Tech_Hydro float,
									          Tech_KPP float,
									          Tech_Engine float,
									          Tech_Break float,
									          Tech_Grease float,
									          Tech_Chasis float,
									          Tech_Fire float,
									          Tech_Tire float,
									          Tech_Electric float,
                            Tech_Other float,
                                -- Организационные
                            Org_DINNER float,
									          Org_FrontMissing float,
									          Org_CrewMissing float,
									          Org_GeologWork float,
									          Org_FuelMissing float,
									          Org_Washing float,
                            Org_PersonalNeeds float,
									              -- Прочие
									          Other_Climate float,
									          Other_Dust float,
									          Other_MissingIdleType float,
                                --Технологическе
                               
									          Technolog_Vist float,
									          Technolog_LOADWAITING float,
                            Technolog_UNLOADWAITING float,
									          Technolog_HEATING float,
									          Technolog_BVR float,
									          Technolog_REFUEL float,
									          Technolog_REEXCAVATION float,
									          Technolog_PREPAIRING float,
									          Technolog_TRANSFER float,
									          Technolog_WashingShov float,
          KTG float,
          KIO float
          ,taskdate date /*добавил для планового значения КТГ*/
          , shift number(1) /*добавил для планового значения КТГ*/
          , planKTG float /*добавил для планового значения КТГ*/
          
);

type t_DumpTrucks_STP_KTG_planf is table of r_DumpTrucks_STP_KTG_planf;

function get_DumpTrucks_STP_KTG_planf (p_StartDate date, p_StartShift integer, p_FinishDate date, p_FinishShift integer) return t_DumpTrucks_STP_KTG_planf pipelined;

END PAC_PITE_PLAN;



create or replace PACKAGE BODY PAC_GRAPH AS

  function get_Graph  
  (p_ShovID IN varchar2 DEFAULT ''   
 ) 
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["corechart"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
          '["Час", "Самосвалов", "Рейсов"],'
          
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'["'||shifthour_load||'",'||Sum(veh_count) || ','||sum(trips)||'],'
from v_vehtrips_shovels_hour vs
where shovid in (p_ShovID
/*'PC-2000 №1' ,'PC-2000 №2','PC-2000 №3', 'САТ-992K'*/
)
group by vs.shifthour_load, vs.shovid

union
select 
2, ' 
["",null,null]
]);

        var options = {
          title: "Рейсы в час",
          hAxis: {title: "Час",  titleTextStyle: {color: "#333"}},
          vAxis: {minValue: 0}
        };

        var chart = new google.visualization.AreaChart(document.getElementById("chart_div"));
        chart.draw(data, options);
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 100%; height: 500px;"></div>' from dual
union
select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph;

 function get_Graph_all_shovels  
  
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["corechart"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
         '["Час", "PC-2000 №1", "PC-2000 №2", "PC-2000 №3", "САТ-992K"],
          ["",0,0,0,0],
          '
          
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'["'||shifthour_load||'",'||Sum(trips_pc1) || ','||sum(trips_pc2)|| ','||sum(trips_pc3)|| ','||sum(trips_cat992)||'],'

from
(
select sel0.shifthour_load
, nvl(sel1.trips_pc1,0) as trips_pc1
, nvl(sel2.trips_pc2,0) as trips_pc2
, nvl(sel3.trips_pc3,0) as trips_pc3
, nvl(sel992.trips_cat992,0) as trips_cat992

from 
(select vs.shifthour_load
    from v_vehtrips_shovels_hour vs
  group by vs.shifthour_load ) sel0
    left join 
(select sel1.shifthour_load
, sum(sel1.trips) as trips_pc1
from v_vehtrips_shovels_hour sel1
where sel1.shovid in (
'PC-2000 №1' --,'PC-2000 №3', 'САТ-992K'
)
group by sel1.shifthour_load, sel1.shovid
) sel1 on sel1.shifthour_load=sel0.shifthour_load
 left join
(select vs2.shifthour_load
, sum(vs2.trips) as trips_pc2
from v_vehtrips_shovels_hour vs2
where vs2.shovid in (
'PC-2000 №2' --,'PC-2000 №3', 'САТ-992K'
)
group by vs2.shifthour_load, vs2.shovid
) sel2 on sel2.shifthour_load=sel0.shifthour_load
left join 
(select vs3.shifthour_load
, sum(vs3.trips) as trips_pc3
from v_vehtrips_shovels_hour vs3
where vs3.shovid in (
'PC-2000 №3'--, 'САТ-992K'
)
group by vs3.shifthour_load, vs3.shovid
) sel3 on sel3.shifthour_load=sel0.shifthour_load
left join 
(select vs992.shifthour_load
, sum(vs992.trips) as trips_cat992
from v_vehtrips_shovels_hour vs992
where vs992.shovid in (
'САТ-992K'
)
group by vs992.shifthour_load, vs992.shovid
) sel992 on sel992.shifthour_load=sel0.shifthour_load
 
)
group by shifthour_load

union
select 
2, ' 
["",null,null,null,null]
]);


        var options = {
          title: "Рейсы в час",
          hAxis: {title: "Час",  titleTextStyle: {color: "#333"}},
          vAxis: {minValue: 0}
        };

        var chart = new google.visualization.AreaChart(document.getElementById("chart_div"));
        chart.draw(data, options);
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 100%; height: 500px;"></div>' from dual
union
select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph_all_shovels;


 function get_Graph_all_shovels_column  
  
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["corechart"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
          '["Час", "PC-2000 №1", "PC-2000 №2", "PC-2000 №3", "САТ-992K"],
          
          '
          /*["",0,0,0,0],*/
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'["'||shifthour_load||'",'||Sum(trips_pc1) || ','||sum(trips_pc2)|| ','||sum(trips_pc3)|| ','||sum(trips_cat992)||'],'

from
(
select sel0.shifthour_load
, nvl(sel1.trips_pc1,0) as trips_pc1
, nvl(sel2.trips_pc2,0) as trips_pc2
, nvl(sel3.trips_pc3,0) as trips_pc3
, nvl(sel992.trips_cat992,0) as trips_cat992
from 
(select vs.shifthour_load
    from v_vehtrips_shovels_hour vs
  group by vs.shifthour_load ) sel0
    left join 
(select sel1.shifthour_load
, sum(sel1.trips) as trips_pc1
from v_vehtrips_shovels_hour sel1
where sel1.shovid in (
'PC-2000 №1' --,'PC-2000 №3', 'САТ-992K'
)
group by sel1.shifthour_load, sel1.shovid
) sel1 on sel1.shifthour_load=sel0.shifthour_load
 left join
(select vs2.shifthour_load
, sum(vs2.trips) as trips_pc2
from v_vehtrips_shovels_hour vs2
where vs2.shovid in (
'PC-2000 №2' --,'PC-2000 №3', 'САТ-992K'
)
group by vs2.shifthour_load, vs2.shovid
) sel2 on sel2.shifthour_load=sel0.shifthour_load
left join 
(select vs3.shifthour_load
, sum(vs3.trips) as trips_pc3
from v_vehtrips_shovels_hour vs3
where vs3.shovid in (
'PC-2000 №3'--, 'САТ-992K'
)
group by vs3.shifthour_load, vs3.shovid
) sel3 on sel3.shifthour_load=sel0.shifthour_load
left join 
(select vs992.shifthour_load
, sum(vs992.trips) as trips_cat992
from v_vehtrips_shovels_hour vs992
where vs992.shovid in (
'САТ-992K'
)
group by vs992.shifthour_load, vs992.shovid
) sel992 on sel992.shifthour_load=sel0.shifthour_load
 
)
group by shifthour_load

union
select 
2, ' 
["",0,0,0,0]
]);
    var options = {
          title: "Рейсы в час",
          hAxis: {title: "Час",  titleTextStyle: {color: "#333"}},
          vAxis: {minValue: 0},
legend: { position: "bottom" },

          isStacked: false};

        var chart = new google.visualization.SteppedAreaChart(document.getElementById("chart_div"));
        chart.draw(data, options);
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 100%; height: 500px;"></div>' from dual
union
select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph_all_shovels_column;

function get_Graph_all_shovels_hysto  
  
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["corechart"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
          '["Час", "PC-2000 №1", "PC-2000 №2", "PC-2000 №3", "САТ-992K"],
          
          '
          /*["",0,0,0,0],*/
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'["'||shifthour_load||'",'||Sum(trips_pc1) || ','||sum(trips_pc2)|| ','||sum(trips_pc3)|| ','||sum(trips_cat992)||'],'

from
(
select sel0.shifthour_load
, nvl(sel1.trips_pc1,0) as trips_pc1
, nvl(sel2.trips_pc2,0) as trips_pc2
, nvl(sel3.trips_pc3,0) as trips_pc3
, nvl(sel992.trips_cat992,0) as trips_cat992
from 
(select vs.shifthour_load
    from v_vehtrips_shovels_hour vs
  group by vs.shifthour_load ) sel0
    left join 
(select sel1.shifthour_load
, sum(sel1.trips) as trips_pc1
from v_vehtrips_shovels_hour sel1
where sel1.shovid in (
'PC-2000 №1' --,'PC-2000 №3', 'САТ-992K'
)
group by sel1.shifthour_load, sel1.shovid
) sel1 on sel1.shifthour_load=sel0.shifthour_load
 left join
(select vs2.shifthour_load
, sum(vs2.trips) as trips_pc2
from v_vehtrips_shovels_hour vs2
where vs2.shovid in (
'PC-2000 №2' --,'PC-2000 №3', 'САТ-992K'
)
group by vs2.shifthour_load, vs2.shovid
) sel2 on sel2.shifthour_load=sel0.shifthour_load
left join 
(select vs3.shifthour_load
, sum(vs3.trips) as trips_pc3
from v_vehtrips_shovels_hour vs3
where vs3.shovid in (
'PC-2000 №3'--, 'САТ-992K'
)
group by vs3.shifthour_load, vs3.shovid
) sel3 on sel3.shifthour_load=sel0.shifthour_load
left join 
(select vs992.shifthour_load
, sum(vs992.trips) as trips_cat992
from v_vehtrips_shovels_hour vs992
where vs992.shovid in (
'САТ-992K'
)
group by vs992.shifthour_load, vs992.shovid
) sel992 on sel992.shifthour_load=sel0.shifthour_load
 
)
group by shifthour_load

union
select 
2, ' 
["",0,0,0,0]
]);
    var options = {
          title: "Рейсы в час",
          vAxis: {title: "Час",  titleTextStyle: {color: "#333"}},
          vAxis: {minValue: 0},
legend: { position: "bottom" },
interpolateNulls: false
};

        var chart = new google.visualization.Histogram(document.getElementById("chart_div"));
        chart.draw(data, options);
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 100%; height: 500px;"></div>' from dual
union
select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph_all_shovels_hysto;

 function get_Graph_all_shovels_column2
  
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["bar"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
          '["Час", "PC-2000 №1", "PC-2000 №2", "PC-2000 №3", "САТ-992K"],
         ' /* ["",0,0,0,0],*/
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'["'||shifthour_load||'",'||Sum(trips_pc1) || ','||sum(trips_pc2)|| ','||sum(trips_pc3)|| ','||sum(trips_cat992)||'],'

from
(
select sel0.shifthour_load
, nvl(sel1.trips_pc1,0) as trips_pc1
, nvl(sel2.trips_pc2,0) as trips_pc2
, nvl(sel3.trips_pc3,0) as trips_pc3
, nvl(sel992.trips_cat992,0) as trips_cat992
from 
(select vs.shifthour_load
    from v_vehtrips_shovels_hour vs
  group by vs.shifthour_load ) sel0
    left join 
(select sel1.shifthour_load
, sum(sel1.trips) as trips_pc1
from v_vehtrips_shovels_hour sel1
where sel1.shovid in (
'PC-2000 №1' --,'PC-2000 №3', 'САТ-992K'
)
group by sel1.shifthour_load, sel1.shovid
) sel1 on sel1.shifthour_load=sel0.shifthour_load
 left join
(select vs2.shifthour_load
, sum(vs2.trips) as trips_pc2
from v_vehtrips_shovels_hour vs2
where vs2.shovid in (
'PC-2000 №2' --,'PC-2000 №3', 'САТ-992K'
)
group by vs2.shifthour_load, vs2.shovid
) sel2 on sel2.shifthour_load=sel0.shifthour_load
left join 
(select vs3.shifthour_load
, sum(vs3.trips) as trips_pc3
from v_vehtrips_shovels_hour vs3
where vs3.shovid in (
'PC-2000 №3'--, 'САТ-992K'
)
group by vs3.shifthour_load, vs3.shovid
) sel3 on sel3.shifthour_load=sel0.shifthour_load
left join 
(select vs992.shifthour_load
, sum(vs992.trips) as trips_cat992
from v_vehtrips_shovels_hour vs992
where vs992.shovid in (
'САТ-992K'
)
group by vs992.shifthour_load, vs992.shovid
) sel992 on sel992.shifthour_load=sel0.shifthour_load
 
)
group by shifthour_load

union
select 
2, 

'["",0,0,0,0]

        ]);

 
        var options = {
          chart: {
            title: "Рейсы в час"
            
          }
          , legend: { position: "bottom" }
        };

        var chart = new google.charts.Bar(document.getElementById("chart_div"));

        chart.draw(data, google.charts.Bar.convertOptions(options));
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 1600px; height: 300px;"></div>' from dual
union
select 10, '
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph_all_shovels_column2;


 function get_Graph_all_shovels_ComboCh  
  
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["corechart"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
          '["Час", "PC-2000 №1", "PC-2000 №2", "PC-2000 №3", "САТ-992K", "Среднее"],
          
          '
          /*["",0,0,0,0],*/
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'["'||shifthour_load||'",'||Sum(trips_pc1) || ','||sum(trips_pc2)|| ','||sum(trips_pc3)|| ','||sum(trips_cat992)||','||avg(avg_trips)||'],'

from
(
select sel0.shifthour_load
, nvl(sel1.trips_pc1,0) as trips_pc1
, nvl(sel2.trips_pc2,0) as trips_pc2
, nvl(sel3.trips_pc3,0) as trips_pc3
, nvl(sel992.trips_cat992,0) as trips_cat992
, 
(case when 
((case when nvl(sel1.trips_pc1,0)>0 then 1 else 0 end) + 
(case when nvl(sel2.trips_pc2,0)>0 then 1 else 0 end)+
(case when nvl(sel3.trips_pc3,0)>0 then 1 else 0 end) +
(case when nvl(sel992.trips_cat992,0)>0 then 1 else 0 end))
 >0 then 
round((nvl(sel1.trips_pc1,0)+nvl(sel2.trips_pc2,0)+nvl(sel3.trips_pc3,0)+nvl(sel992.trips_cat992,0))/
((case when nvl(sel1.trips_pc1,0)>0 then 1 else 0 end) + 
(case when nvl(sel2.trips_pc2,0)>0 then 1 else 0 end)+
(case when nvl(sel3.trips_pc3,0)>0 then 1 else 0 end) +
(case when nvl(sel992.trips_cat992,0)>0 then 1 else 0 end))
,0) else 0 end)
 as avg_trips

from 
(select vs.shifthour_load
    from v_vehtrips_shovels_hour vs
  group by vs.shifthour_load ) sel0
    left join 
(select sel1.shifthour_load
, sum(sel1.trips) as trips_pc1
from v_vehtrips_shovels_hour sel1
where sel1.shovid in (
'PC-2000 №1' --,'PC-2000 №3', 'САТ-992K'
)
group by sel1.shifthour_load, sel1.shovid
) sel1 on sel1.shifthour_load=sel0.shifthour_load
 left join
(select vs2.shifthour_load
, sum(vs2.trips) as trips_pc2
from v_vehtrips_shovels_hour vs2
where vs2.shovid in (
'PC-2000 №2' --,'PC-2000 №3', 'САТ-992K'
)
group by vs2.shifthour_load, vs2.shovid
) sel2 on sel2.shifthour_load=sel0.shifthour_load
left join 
(select vs3.shifthour_load
, sum(vs3.trips) as trips_pc3
from v_vehtrips_shovels_hour vs3
where vs3.shovid in (
'PC-2000 №3'--, 'САТ-992K'
)
group by vs3.shifthour_load, vs3.shovid
) sel3 on sel3.shifthour_load=sel0.shifthour_load
left join 
(select vs992.shifthour_load
, sum(vs992.trips) as trips_cat992
from v_vehtrips_shovels_hour vs992
where vs992.shovid in (
'САТ-992K'
)
group by vs992.shifthour_load, vs992.shovid
) sel992 on sel992.shifthour_load=sel0.shifthour_load
 
)
group by shifthour_load

union
select 
2, ' 
["",0,0,0,0,0]
]);
    var options = {
          title: "Рейсы в час",
          hAxis: {title: "Час",  titleTextStyle: {color: "#333"}},
          vAxis: {minValue: 0},
          
          seriesType: "bars",
          series: {4: {type: "line"}}
          
          };

        var chart = new google.visualization.ComboChart(document.getElementById("chart_div"));
        chart.draw(data, options);
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 100%; height: 500px;"></div>' from dual
union
select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph_all_shovels_ComboCh;


/*график план-факт КТГ по экскаваторам*/
 function get_Graph_STP_shovels_1  
  
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["corechart"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
          '["Сутки", "КТГ", "План КТГ", "Отклонение"],
         
          '
           /*[0,0,0,0],*/
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'['||taskday||','||sum(ktg) || ','||sum(planktg)|| ','||avg(diff_ktg)||'],'

from
(/*select 
taskday,replace(case when avg(ktg) between  0 and 1 then 
'0'||cast(avg(ktg) as varchar(4)) else cast(avg(ktg) as varchar(4)) end,',','.') as ktg,
 replace(case when avg(planktg) between  0 and 1  then 
 '0'||cast(avg(planktg) as varchar(4)) else cast(avg(planktg) as varchar(4)) end,',','.') as planktg,
  replace(case when avg(diff_ktg) between  0 and 1  then 
  '0'||cast(avg(diff_ktg) as varchar(4)) else cast(avg(diff_ktg) as varchar(4)) end,',','.') as diff_ktg
from (*/
select sel1.taskday, round(avg(sel1.ktg),0) as ktg, round(avg(sel1.planktg),0) as planktg,round(avg(sel1.diff_ktg),0) as diff_ktg
from(
select round(avg(ktg)*100,0) as ktg
, round(avg(planktg)*100,0) as planktg
, round(round(avg(planktg)-avg(ktg),2)*100,0) as diff_ktg 
, cast(to_char(stp.taskdate,'dd') as number) as taskday
from UGH.v_stp_shovel_planfact_1m stp
where vehid in ('PC-2000 №1', 'PC-2000 №2', 'PC-2000 №3', 'САТ-992K')
and planktg >0
group by stp.taskdate
/*)
group by taskday
order by taskday*/
) sel1
group by taskday
)
group by taskday
union
select 
2, 
/*[0,0,0,0]*/
' 

]);
    var options = {
          title: "План-факт КТГ за месяц по экскаваторам, '||
          (select round(avg(ktg)*100,0) as ktg
from UGH.v_stp_shovel_planfact_1m stp
where vehid in ('PC-2000 №1', 'PC-2000 №2', 'PC-2000 №3', 'САТ-992K')
and planktg >0)
          ||' %",
          hAxis: {title: "Сутки",  titleTextStyle: {color: "#333"}},
          vAxis: {minValue: 0},
          
          seriesType: "bars",
          series: {1: {type: "line"}}
          
          
          };

        var chart = new google.visualization.ComboChart(document.getElementById("chart_div"));
        chart.draw(data, options);
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 100%; height: 500px;"></div>' from dual
union
select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph_STP_shovels_1;



/*график план-факт КТГ по самосвалам*/
 function get_Graph_STP_DumpTrucks_1  
  
  return t_Graph pipelined AS
  BEGIN
    -- TODO: Implementation required for function PAC_GRAPH.get_Graph
    
    for r_UOGR_Rep in
        (       
select 
1, '<body>'
from dual
union
select 
1.1, '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {"packages":["corechart"]});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(['
from dual
union
select 
1.2, 
          '["Сутки", "КТГ", "План КТГ", "Отклонение"],
         
          '
           /*[0,0,0,0],*/
from dual
union
select 
1.3, 
/*'["2013",  1000,      400],
          ["2014",  1170,      460],
          ["2015",  660,       1120],
          ["2016",  1030,      540]'
from dual*/
'['||taskday||','||sum(ktg) || ','||sum(planktg)|| ','||avg(diff_ktg)||'],'

from
(/*select 
taskday,replace(case when avg(ktg) between  0 and 1 then 
'0'||cast(avg(ktg) as varchar(4)) else cast(avg(ktg) as varchar(4)) end,',','.') as ktg,
 replace(case when avg(planktg) between  0 and 1  then 
 '0'||cast(avg(planktg) as varchar(4)) else cast(avg(planktg) as varchar(4)) end,',','.') as planktg,
  replace(case when avg(diff_ktg) between  0 and 1  then 
  '0'||cast(avg(diff_ktg) as varchar(4)) else cast(avg(diff_ktg) as varchar(4)) end,',','.') as diff_ktg
from (*/
select sel1.taskday, round(avg(sel1.ktg),0) as ktg, round(avg(sel1.planktg),0) as planktg,round(avg(sel1.diff_ktg),0) as diff_ktg
from(
select round(avg(ktg)*100,0) as ktg
, round(avg(planktg)*100,0) as planktg
, round(round(avg(planktg)-avg(ktg),2)*100,0) as diff_ktg 
, cast(to_char(stp.taskdate,'dd') as number) as taskday
from UGH.t_STP_DumpTrucks_PLANFACT_1M stp
where /*vehid in ('PC-2000 №1', 'PC-2000 №2', 'PC-2000 №3', 'САТ-992K')*/
/*and */
planktg >0
group by stp.taskdate
/*)
group by taskday
order by taskday*/
) sel1
group by taskday
)
group by taskday
union
select 
2, 
/*[0,0,0,0]*/
' 

]);
    var options = {
          title: "План-факт КТГ за месяц по самосвалам, '||
          (select round(avg(ktg)*100,0) as ktg
from UGH.t_STP_DumpTrucks_PLANFACT_1M stp
where 
planktg >0)
          ||' %",
          hAxis: {title: "Сутки",  titleTextStyle: {color: "#333"}},
          vAxis: {minValue: 0},
          
          seriesType: "bars",
          series: {1: {type: "line"}}
          
          
          };

        var chart = new google.visualization.ComboChart(document.getElementById("chart_div"));
        chart.draw(data, options);
      }
    </script>'
    from dual

union
select 9, '<div id="chart_div" style="width: 100%; height: 500px;"></div>' from dual
union
select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
    --RETURN NULL;
  END get_Graph_STP_DumpTrucks_1;


END PAC_GRAPH;