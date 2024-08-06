
  CREATE OR REPLACE FORCE VIEW "UGH"."V_PLANFACT_SHIFTHOUR_NOW" ("PLAN_HOUR_HALF", "VOLUME", "PLANFACT", "PLANFACT_PERCENT", "PLANFACT_PERCENT100", "SHIFTHOUR_HALF", "SHIFTHOUR_HALF_T") AS 
  select round(sum(PLAN_HOUR_HALF),2) as plan_hour_half, round(sum(volume),2) as volume
    , round(sum(volume)-sum(PLAN_HOUR_HALF),2) as planfact
    , round(sum(volume)/sum(PLAN_HOUR_HALF),2) as planfact_percent
    , round(sum(volume)/sum(PLAN_HOUR_HALF),2)*100 as planfact_percent100
    , ugh.f_get_shifthour_half(sysdate) as shifthour_half, ugh.f_get_shifthour_half_t(sysdate) as shifthour_half_t
    from ugh.V_PLANFACT_HOURSUM_HALF_SHOV
    where shifthour_half<=ugh.f_get_shifthour_half
;
