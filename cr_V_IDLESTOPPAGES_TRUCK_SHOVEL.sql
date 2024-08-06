
  CREATE OR REPLACE FORCE VIEW "UGH"."V_IDLESTOPPAGES_TRUCK_SHOVEL" ("VEHID", "DATESHIFT_HOUR_T", "SHIFTDATE", "SHIFTNUM", "SHOVEL_NAME", "DURATION_WAITLOAD_SUM", "DURATION_LOADING_SUM", "DURATION_WAITLOAD_AVG", "DURATION_LOADING_AVG", "SHOV_TYPE") AS 
  select sel1.vehid, sel1.dateshift_hour_t, sel1.shiftdate, sel1.shiftnum, sel1.shovel_name 
    , sum(sel1.stop_time_min) as duration_waitload_sum
    , sum(sel2.duration_loading) as duration_loading_sum
    , round(avg(sel1.stop_time_min),1) as duration_waitload_avg
    , round(avg(sel2.duration_loading),1) as duration_loading_avg
    , (case when sel1.shovel_name like 'PC-2000%' or sel1.shovel_name like '%992%' then 'big' else 'small' end) as shov_type
    from v_idlestoppages_cur sel1
    
left join (
select sel1.vehid, sel1.dateshift_hour_t, sel1.shiftdate, sel1.shiftnum, sel1.shovel_name 
    , sel1.stop_time_min as duration_loading
    from v_idlestoppages_cur sel1
    where lower(stoppage_type) = 'погрузка'
) sel2 
    on sel1.vehid= sel2.vehid and sel1.dateshift_hour_t = sel2.dateshift_hour_t and sel1.shiftdate = sel2.shiftdate and sel1.shiftnum = sel2.shiftnum and sel1.shovel_name = sel2.shovel_name 
    where lower(stoppage_type) = 'ожидание_погрузки'
    group by sel1.vehid, sel1.dateshift_hour_t, sel1.shiftdate, sel1.shiftnum, sel1.shovel_name;
