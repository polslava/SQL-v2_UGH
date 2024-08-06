
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PLANFACT_HOURSUM_HALF_SHOV_1" ("SHIFTHOUR_HALF_T", "SHIFTHOUR_HALF", "SHIFTHOUR", "PLAN_HOUR_HALF", "SHOVID", "VOLUME", "PLANFACT_PERCENT", "PLANFACT_PERCENT100", "PLANFACT", "SHOV_TYPE") AS 
  SELECT
/*
27.01.2024
Ступин В.С.
использую свой расчёт для отдельной моей дашборды
*/
    sel2.shifthour_half_t, sel2.shifthour_half, sel2.shifthour, sel2.plan_hour_half, sel2.shovid
    
    , (case when sel2.volume > 0 then sel2.volume else 0 end) as volume
    , (case when sel2.volume > 0 then round(sel2.volume/(case when sel2.plan_hour_half=0 then sel2.volume else sel2.plan_hour_half end),2) else 0 end) as planfact_percent
    , (case when sel2.volume > 0 then round(sel2.volume/(case when sel2.plan_hour_half=0 then sel2.volume else sel2.plan_hour_half end),2)*100 else 0 end) as planfact_percent100
, (case when  f_get_shifthour_half(sysdate)>=sel2.shifthour_half then
    (case when sel2.volume > 0 then 
    round(sel2.volume-sel2.plan_hour_half,2) else 
    /*0*/
    round(0-sel2.plan_hour_half,2)
    end) 
    else 0 end) as planfact
, (case when sel2."SHOVID" like 'PC-2000%' or sel2."SHOVID" like '%992%' then 'big' else 'small' end) as shov_type

FROM

(select sel1.shifthour_half_t, sel1.shifthour_half, sel1.shifthour, sel1.plan_hour_half, sel1.shovid
    , sum(vt.volume) as volume
    from
   /* (select   sh.halfhour_t as shifthour_half_t,
              sh.halfhour as shifthour_half,
              sh.hour as shifthour,
              round((CASE WHEN sh.halfhour in (11,12,24) THEN 0 ELSE s.plan_volume/2/10.5 END) ,1) as plan_hour_half,
              s.shovid
     from v_shovels_in_shift_planfact s left join ugh.shifthours sh on 1=1  )sel1
*/
(select '01_1' as shifthour_half_t, 1  as shifthour_half, 1 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
     as plan_hour_half, s.shovid
from v_shovels_in_shift_planfact s
union
select '01_2' as shifthour_half_t, 2  as shifthour_half, 1 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '02_1' as shifthour_half_t, 3  as shifthour_half, 2 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '02_2' as shifthour_half_t, 4  as shifthour_half, 2 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '03_1' as shifthour_half_t, 5  as shifthour_half, 3 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '03_2' as shifthour_half_t, 6  as shifthour_half, 3 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '04_1' as shifthour_half_t, 7  as shifthour_half, 4 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '04_2' as shifthour_half_t, 8  as shifthour_half, 4 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '05_1' as shifthour_half_t, 9  as shifthour_half, 5 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '05_2' as shifthour_half_t, 10  as shifthour_half, 5 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '06_1' as shifthour_half_t, 11  as shifthour_half, 6 as shifthour
    , 0 as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '06_2' as shifthour_half_t, 12  as shifthour_half, 6 as shifthour
    , 0 as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '07_1' as shifthour_half_t, 13  as shifthour_half, 7 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '07_2' as shifthour_half_t, 14  as shifthour_half, 7 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '08_1' as shifthour_half_t, 15  as shifthour_half, 8 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '08_2' as shifthour_half_t, 16  as shifthour_half, 8 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '09_1' as shifthour_half_t, 17  as shifthour_half, 9 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '09_2' as shifthour_half_t, 18  as shifthour_half, 9 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '10_1' as shifthour_half_t, 19  as shifthour_half, 10 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '10_2' as shifthour_half_t, 20  as shifthour_half, 10 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '11_1' as shifthour_half_t, 21  as shifthour_half, 11 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '11_2' as shifthour_half_t, 22  as shifthour_half, 11 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '12_1' as shifthour_half_t, 23  as shifthour_half, 12 as shifthour
    , (case when s.SHOVID like 'PC-2000%' then 210 else 
        (case when s.SHOVID like '%992%' then 190 else round((s.plan_volume/2)/10.5,1)
            end) end)
            as plan_hour, s.shovid
from v_shovels_in_shift_planfact s
union
select '12_2' as shifthour_half_t, 24  as shifthour_half, 12 as shifthour
    , 0 as plan_hour, s.shovid
from v_shovels_in_shift_planfact s) sel1


    left join ugh.v_vehtrips vt
        on vt.shovid = sel1.shovid and vt.shifthour_half = sel1.shifthour_half
    GROUP BY sel1.shifthour_half_t, sel1.shifthour_half, sel1.shifthour, sel1.plan_hour_half, sel1.shovid) sel2
    order by sel2.shifthour_half, sel2.shovid
/*
для Куприянова не план, а технически запланированная производительность
*/;
