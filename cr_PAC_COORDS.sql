create or replace PACKAGE PAC_COORDS AS 

  
type r_Coords_TS is record(
order_num numeric (3,1),
coords varchar(10000)
);

type t_Coords_TS is table of r_Coords_TS;
function get_Coords_TS /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;

function get_Coords_TS_1 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;
function get_Coords_TS_2 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;
function get_Coords_TS_2_1 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;
function get_Coords_TS_2_2 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;
function get_Coords_TS_3 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;
function get_Coords_TS_4 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;
function get_Coords_TS_5 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;
function get_Coords_TS_10 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined;

END PAC_COORDS;

create or replace PACKAGE BODY PAC_COORDS AS

  function get_Coords_TS /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
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
union
select 2, '
ctx.fillStyle = "#AAA";
ctx.beginPath();
ctx.moveTo(150,230);
ctx.lineTo(653,417);
ctx.lineTo(700,528);	
ctx.lineTo(700,628);	
ctx.lineTo(550,628);
ctx.lineTo(151,406);
ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Карьер", 230,430);
' from dual

/*ctx.strokeText("CAT-140M №1", 389.894345730171,82.7632620899938);
ctx.strokeText("CAT-16М", -49.9046194400638,349.283386630006);
ctx.strokeText("Gal_358004090811936", 385.533334349841,82.7224764499813);
ctx.strokeText("R13-G", 12.7129452701658,331.942089429963);*/
union
select 3.0,'ctx.fillStyle = "#00F";' from dual
union
SELECT 3.1,
    'ctx.fillStyle = "#'||
    (case when speed = 0 then 'F00' else '00F' end)
    ||'";'
    ||
    'ctx.fillText("'||to_char(vehid)
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)),',','.')
    F_GET_CANVAS_y_FROM_y(y)
    ||');' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Самосвал'
    /*and tsname like 'CAT%'*/
    and v_timeunload.divisionname='УОГР'
union
SELECT 4,
    'ctx.fillStyle = "#'||
    (case when speed = 0 then 'F00' else '00F' end)
    ||'";'
    ||'ctx.fillText("'||to_char(speed||'км/ч,'||weight||'т,'||fuel||'л')
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)+10),',','.')
    F_GET_CANVAS_y_FROM_y10(y)
    ||');' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Самосвал'
    --and tsname like 'CAT%'
    and v_timeunload.divisionname='УОГР'
union
select 5.0,'ctx.fillStyle = "#0F0";' from dual
union
SELECT 5.1,
    'ctx.fillRect('||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)),',','.')
    F_GET_CANVAS_y_FROM_y(y)
    ||',15,15);' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Экскаватор'
    --and (tsname like 'PC%' or tsname like 'САТ%')
    and v_timeunload.divisionname='УОГР'
/*union
SELECT 5.2,
    'ctx.fillStyle = "#'||
    (case when speed = 0 then 'F00' else '00F' end)
    ||'";'
    ||'ctx.fillText("'||tsname
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)+10),',','.')
    F_GET_CANVAS_y_FROM_y10(y)
    ||');' as coords
    
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Экскаватор'
    and v_timeunload.divisionname='УОГР'
*/
union
select 2.2,
'
ctx.fillStyle = "#ff0";
ctx.beginPath();
ctx.moveTo(194,18);
ctx.lineTo(387,0);
ctx.lineTo(326,228);
ctx.lineTo(190,188);
ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Отвал №1", 190,30);
ctx.fillStyle = "#f54";
ctx.beginPath();
ctx.moveTo(388,26);
ctx.lineTo(725,79);
ctx.lineTo(531,306);
ctx.lineTo(326,228);
ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Отвал №2", 390,130);
ctx.fillStyle = "#4ff";
ctx.beginPath();
ctx.moveTo(725,79);
ctx.lineTo(846,248);	
ctx.lineTo(653,357);
ctx.lineTo(531,306);
ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Отвал №3", 730,230);

'
from dual
union

select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS;

/*заголовок HTML*/
 function get_Coords_TS_1 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
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
  END get_Coords_TS_1;
  
  /*окончание HTML*/
  function get_Coords_TS_10 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
  BEGIN
 for r_UOGR_Rep in
        (   

select 10, '</script>
    </body>' as tt from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS_10;
  
  /*геозона карьер*/
   function get_Coords_TS_2 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
  BEGIN
 for r_UOGR_Rep in
        (       

select 2, '
ctx.fillStyle = "#AAA";
ctx.beginPath();
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
' from dual
 )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS_2;
  
  /*геозона отвалы*/
function get_Coords_TS_2_1 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
  BEGIN
 for r_UOGR_Rep in
        (    
select 2.1,
'
ctx.fillStyle = "#0F8";
ctx.beginPath();
ctx.moveTo(216,-7);
ctx.lineTo(194,18);
ctx.lineTo(175,65);
ctx.lineTo(178,94);
ctx.lineTo(180,126);
ctx.lineTo(181,150);
ctx.lineTo(215,172);
ctx.lineTo(248,185);
ctx.lineTo(270,202);
ctx.lineTo(296,220);
ctx.lineTo(326,228);
ctx.lineTo(322,185);
ctx.lineTo(318,147);
ctx.lineTo(327,116);
ctx.lineTo(344,118);
ctx.lineTo(346,93);
ctx.lineTo(387,-5);
ctx.lineTo(350,-41);
ctx.lineTo(307,-51);
ctx.lineTo(265,-50);

ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Отвал №1", 190,30);
ctx.fillStyle = "#4af";
ctx.beginPath();
ctx.moveTo(344,94);
ctx.lineTo(344,118);
ctx.lineTo(328,116);
ctx.lineTo(318,148);
ctx.lineTo(323,193);
ctx.lineTo(324,208);
ctx.lineTo(326,224);
ctx.lineTo(420,266);
ctx.lineTo(501,292);
ctx.lineTo(531,306);
ctx.lineTo(560,269);
ctx.lineTo(572,241);
ctx.lineTo(518,184);
ctx.lineTo(508,147);
ctx.lineTo(524,135);
ctx.lineTo(593,86);
ctx.lineTo(725,79);
ctx.lineTo(576,17);
ctx.lineTo(479,-13);
ctx.lineTo(388,-8);

ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Отвал №2", 390,130);
ctx.fillStyle = "#4ff";
ctx.beginPath();
ctx.moveTo(532,306);
ctx.lineTo(600,359);
ctx.lineTo(653,357);
ctx.lineTo(710,356);
ctx.lineTo(772,328);
ctx.lineTo(846,248);
ctx.lineTo(850,162);
ctx.lineTo(809,108);
ctx.lineTo(727,79);
ctx.lineTo(719,92);
ctx.lineTo(594,86);
ctx.lineTo(508,147);
ctx.lineTo(517,184);
ctx.lineTo(573,240);
ctx.lineTo(560,268);

ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Отвал №3", 730,230);

'
from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS_2_1;
  
   /*геозона штабеля*/
function get_Coords_TS_2_2 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
  BEGIN
 for r_UOGR_Rep in
        (    
select 2.2,
'
ctx.fillStyle = "#4af";
ctx.beginPath();
ctx.moveTo(704,512);
ctx.lineTo(684,551);
ctx.lineTo(688,552);
ctx.lineTo(689,574);
ctx.lineTo(759,578);
ctx.lineTo(775,532);
ctx.lineTo(776,528);
ctx.lineTo(781,508);
ctx.lineTo(724,512);
ctx.lineTo(718,512);
ctx.lineTo(716,516);
ctx.closePath();
ctx.fill();

ctx.fillStyle = "#000";
ctx.strokeText("Штабель №3", 704,550);

ctx.fillStyle = "#4ff";
ctx.beginPath();
ctx.moveTo(852,504);
ctx.lineTo(782,508);
ctx.lineTo(775,532);
ctx.lineTo(790,534);
ctx.lineTo(822,533);
ctx.lineTo(865,528);
ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Штабель №4", 790,520);

ctx.fillStyle = "#0F8";
ctx.beginPath();
ctx.moveTo(873,531);
ctx.lineTo(868,527);
ctx.lineTo(835,532);
ctx.lineTo(808,534);
ctx.lineTo(778,533);
ctx.lineTo(775,532);
ctx.lineTo(763,565);
ctx.lineTo(780,584);
ctx.lineTo(808,582);
ctx.lineTo(819,582);
ctx.lineTo(832,582);
ctx.lineTo(847,582);
ctx.lineTo(858,579);
ctx.lineTo(865,574);
ctx.lineTo(867,570);
ctx.lineTo(864,562);
ctx.closePath();
ctx.fill();
ctx.fillStyle = "#000";
ctx.strokeText("Штабель №5", 770,550);

'
from dual

    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS_2_2;
  /*самосвалы УОГР*/
   function get_Coords_TS_3 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
  BEGIN
 for r_UOGR_Rep in
        (       

select 3.0,'ctx.fillStyle = "#00F";' from dual
union
SELECT 3.1,
    'ctx.fillStyle = "#'||
    (case when speed = 0 then 'F00' else '00F' end)
    ||'";'
    ||
    'ctx.fillText("'||to_char(vehid)
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)),',','.')
    F_GET_CANVAS_y_FROM_y(y)
    ||');' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Самосвал'
    /*and tsname like 'CAT%'*/
    and v_timeunload.divisionname='УОГР'
union
SELECT 3.2,
    'ctx.fillStyle = "#'||
    (case when speed = 0 then 'F00' else '00F' end)
    ||'";'
    ||'ctx.fillText("'||to_char(speed||'км/ч,'||weight||'т,'||fuel||'л')
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)+10),',','.')
    F_GET_CANVAS_y_FROM_y10(y)
    ||');' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Самосвал'
    --and tsname like 'CAT%'
    and v_timeunload.divisionname='УОГР'
    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS_3;
  
  /*экскаваторы УОГР*/
   function get_Coords_TS_4 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
  BEGIN
 for r_UOGR_Rep in
        ( 
        
select 4.0,'ctx.fillStyle = "#0F0";' from dual
union
SELECT 4.1,
    'ctx.fillRect('||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)),',','.')
    F_GET_CANVAS_y_FROM_y(y)
    ||',15,15);' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Экскаватор'
    --and (tsname like 'PC%' or tsname like 'САТ%')
    and v_timeunload.divisionname='УОГР'
union
SELECT 4.2,
    'ctx.fillStyle = "#'||
    /*(case when speed = 0 then 'F00' else '00F' end)*/'0F0'
    ||'";'
    ||'ctx.fillText("Экс.'||vehid
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)+10),',','.')
    F_GET_CANVAS_y_FROM_y10(y)
    ||');' as coords
    
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Экскаватор'
    and v_timeunload.divisionname='УОГР'
    
    
    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS_4;
  
   /*Бульдозеры УОГР*/
   function get_Coords_TS_5 /*(p_StartDate date , p_StartShift integer)*/ return t_Coords_TS pipelined AS
  BEGIN
 for r_UOGR_Rep in
        ( 
        
select 5.0,'ctx.fillStyle = "#FF0";' from dual
union
SELECT 5.1,
    'ctx.fillRect('||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)),',','.')
    F_GET_CANVAS_y_FROM_y(y)
    ||',5,5);' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Бульдозер'
    --and (tsname like 'PC%' or tsname like 'САТ%')
    and v_timeunload.divisionname='УОГР'
union
SELECT 5.2,
    'ctx.fillStyle = "#'||
    (case when speed = 0 then 'F00' else '00F' end)
    ||'";'
    ||'ctx.fillText("Бул.'||vehid
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)+10),',','.')
    F_GET_CANVAS_y_FROM_y10(y)
    ||');' as coords
    
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Бульдозер'
    and v_timeunload.divisionname='УОГР'
union
SELECT 5.3,
    'ctx.fillStyle = "#FF0";'
    ||'ctx.fillText("'||to_char(speed||'км/ч,'||fuel||'л')
    ||'",'||
    --replace(to_char(round((x-20388000)/5,0)),',','.')
    F_GET_CANVAS_x_FROM_x(x)
    ||','||
    --replace(to_char(768-round((y-6510000)/5,0)+10),',','.')
    F_GET_CANVAS_y_FROM_y10(y-50)
    ||');' as coords
    --, mdata, stoppagetype
FROM
V_TIMEUNLOAD
where status_online1!=0
    and vehtype = 'Бульдозер'
    --and tsname like 'CAT%'
    and v_timeunload.divisionname='УОГР'

    
    )loop
          pipe row (r_UOGR_Rep);
   end loop;
  END get_Coords_TS_5;
END PAC_COORDS;