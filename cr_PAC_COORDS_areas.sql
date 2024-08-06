create or replace PACKAGE PAC_COORDS_areas AS 

  
type r_Coords_areas is record(
order_num numeric (3,1),
coords varchar(10000)
);

type t_Coords_areas is table of r_Coords_areas;


function get_Coords_areas_1 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_areas pipelined;
function get_Coords_areas_2 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_areas pipelined;
function get_Coords_areas_10 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_areas pipelined;

END PAC_COORDS_areas;

create or replace PACKAGE BODY PAC_COORDS_AREAS AS

  
/*заголовок HTML*/
 function get_Coords_areas_1 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_areas pipelined AS
  BEGIN
 for r_UOGR_Rep in
        (
select 
1, '<body>
<canvas id="example">Обновите браузер</canvas>
<script>
var example = document.getElementById("example"),
ctx = example.getContext("2d");
example.width  = 1024;
example.height = 768;
ctx.font = "12px arial bold";
ctx.fillText("Угахан", 10, 70);
' from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_areas_1;
  
  /*окончание HTML*/
  function get_Coords_areas_10 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_areas pipelined AS
  BEGIN
 for r_UOGR_Rep in
        (   

select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_areas_10;
  
   /*тело HTML с Canvas'ом*/
  function get_Coords_areas_2 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_areas pipelined AS
  BEGIN

 for r_UOGR_Rep in
        (       
select 2 as order_num, ''  as coord_text
from dual
union
(SELECT 2.1,
'
ctx.fillStyle = "#A0A";
ctx.beginPath();'||
   F_GET_CANVAS_XY_FROM_POLYGON(wa.geometry,wa.WORKAREANAME)
FROM v_workareas wa
where wa.areaid is not null
/*
where 
and wa.WORKAREANAME in
(select AREa1 as WORKAREANAME
from v_timeunload tu
where tu.vehtype='Экскаватор' and tu.enterprisename like '%Угахан%'
    and tu.area1 is not null)
*/
)



/*V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Экскаватор'
    --and (tsname like 'PC%' or tsname like 'САТ%')
    and v_timeunload.divisionname='УОГР'

ctx.moveTo(40,189);
ctx.lineTo(96,211);
ctx.lineTo(237,266);
ctx.lineTo(344,305);
ctx.lineTo(385,319);
ctx.lineTo(463,349);
ctx.lineTo(489,363);
ctx.lineTo(484,398);
ctx.lineTo(507,405);
ctx.lineTo(533,396);
ctx.lineTo(703,512);
ctx.lineTo(682,551);
ctx.lineTo(688,553);
ctx.lineTo(688,573);
ctx.lineTo(736,649);
ctx.lineTo(686,701);
ctx.lineTo(620,712);
ctx.lineTo(556,610);
ctx.lineTo(466,536);
ctx.lineTo(404,490);
ctx.lineTo(361,427);
ctx.lineTo(222,362);
ctx.lineTo(22,255);
ctx.lineTo(8,212);
ctx.closePath();
ctx.fill();

ctx.fillStyle = "#000";
ctx.strokeText("Карьер", 230,430);
' from dual*/
union
SELECT 2.2,
/*'ctx.closePath();
ctx.fill();

ctx.fillStyle = "#000";'
ctx.strokeText("Карьер", 230,430);'*/
null
 from dual
/*
union
(
SELECT 2.3,
'
ctx.fillStyle = "#A0A";
ctx.beginPath();'||
   F_GET_CANVAS_XY_FROM_POLYGON(wa.geometry,wa.WORKAREANAME)
FROM v_workareas wa
where wa.areaid in
(select a.id
from DISPATCHER.areas a
inner join V_BUNKER_CURRENT_BLOCK bcb on a.name = bcb.name
)
)
*/
 )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_areas_2;


  

END PAC_COORDS_AREAS;