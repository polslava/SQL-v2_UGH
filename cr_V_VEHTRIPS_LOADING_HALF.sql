
  CREATE OR REPLACE FORCE VIEW "UGH"."V_VEHTRIPS_LOADING_HALF" ("STOP_LOADING", "SHIFTHOUR_HALF", "SHIFTHOUR_HALF_T") AS 
  select sum(stop_loading) as stop_loading, 1 as shifthour_half, '01_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=1
union
select sum(stop_loading) as stop_loading, 2 as shifthour_half, '01_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=2
union
select sum(stop_loading) as stop_loading, 3 as shifthour_half, '02_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=3
union
select sum(stop_loading) as stop_loading, 4 as shifthour_half, '02_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=4
union
select sum(stop_loading) as stop_loading, 5 as shifthour_half, '03_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=5
union
select sum(stop_loading) as stop_loading, 6 as shifthour_half, '03_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=6
union
select sum(stop_loading) as stop_loading, 7 as shifthour_half, '04_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=7
union
select sum(stop_loading) as stop_loading, 8 as shifthour_half, '04_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=8
union
select sum(stop_loading) as stop_loading, 9 as shifthour_half, '05_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=9
union
select sum(stop_loading) as stop_loading, 10 as shifthour_half, '05_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=10
union
select sum(stop_loading) as stop_loading, 11 as shifthour_half, '06_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=11
union
select sum(stop_loading) as stop_loading, 12 as shifthour_half, '06_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=12
union
select sum(stop_loading) as stop_loading, 13 as shifthour_half, '07_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=13
union
select sum(stop_loading) as stop_loading, 14 as shifthour_half, '07_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=14
union
select sum(stop_loading) as stop_loading, 15 as shifthour_half, '08_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=15
union
select sum(stop_loading) as stop_loading, 16 as shifthour_half, '08_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=16
union
select sum(stop_loading) as stop_loading, 17 as shifthour_half, '09_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=17
union
select sum(stop_loading) as stop_loading, 18 as shifthour_half, '09_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=18
union
select sum(stop_loading) as stop_loading, 1 as shifthour_half, '10_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=19
union
select sum(stop_loading) as stop_loading, 1 as shifthour_half, '10_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=20
union
select sum(stop_loading) as stop_loading, 1 as shifthour_half, '11_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=21
union
select sum(stop_loading) as stop_loading, 1 as shifthour_half, '11_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=22
union
select sum(stop_loading) as stop_loading, 1 as shifthour_half, '12_1' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=23
union
select sum(stop_loading) as stop_loading, 1 as shifthour_half, '12_2' as shifthour_half_t
    from ugh.v_vehtrips_cyclenorms
    where shifthour_half <=24;
