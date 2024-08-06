
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PLANFACT_HOURSUM_HALF_SH_PR" ("SHIFTHOUR_HALF_T", "SHIFTHOUR_HALF", "SHIFTHOUR", "PLAN_HOUR_HALF", "SHOVID", "VOLUME", "PLANFACT_PERCENT", "FACT_VOLUME", "PROGNOZ_VOLUME", "PROGNOZ_PERCENT") AS 
  SELECT
    sel1."SHIFTHOUR_HALF_T",sel1."SHIFTHOUR_HALF",sel1."SHIFTHOUR",sel1."PLAN_HOUR_HALF",sel1."SHOVID",sel1."VOLUME",sel1."PLANFACT_PERCENT",sel1."FACT_VOLUME",sel1."PROGNOZ_VOLUME",
    round(sel1.fact_volume/sel1.prognoz_volume,2) as prognoz_percent
FROM (
select pf.*
    , pf1.fact_volume
    , pf.plan_hour_half as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    where pf.shifthour_half <=2
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 1 and 2 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =3
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 1 and 3 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =4
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 2 and 4 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =5
    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 3 and 5 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =6
    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 4 and 6 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =7

union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 5 and 7 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =8

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 6 and 8 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =9

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 7 and 9 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =10

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 8 and 10 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =11

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 9 and 11 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =12

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 10 and 12 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =13

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 11 and 13 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =14

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 12 and 14 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =15

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 13 and 15 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =16

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 14 and 16 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =17

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 15 and 17 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =18

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 16 and 18 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =19

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 17 and 19 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =20

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 18 and 20 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =21

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 19 and 21 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =22

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 20 and 22 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =23

    
union
select pf.*
    , pf1.fact_volume
    , (case when pf1.fact_volume is not null then pf3.prognoz_volume else
        (select avg(pf2.fact_volume) as prognoz_volume from v_planfact_hour_volume_half pf2 where pf2.shovid=pf.shovid)
        end)
    as prognoz_volume
    from V_PLANFACT_HOURSUM_HALF_SHOV pf
    left join /*(select fact_volume as volume, shovid, shifthour_half from*/ v_planfact_hour_volume_half pf1
        on --(pf.shifthour_half = pf.shifthour_half and pf.shovid = pf1.shovid)
            pf.shovid||','||pf.shifthour_half = pf1.shovid||','||pf1.shifthour_half
    left join (select sum(pf2.fact_volume)/2 as prognoz_volume, shovid from v_planfact_hour_volume_half pf2 where pf2.shifthour_half between 21 and 23 group by pf2.shovid) pf3
        on pf3.shovid = pf.shovid
    where pf.shifthour_half =24) sel1;
