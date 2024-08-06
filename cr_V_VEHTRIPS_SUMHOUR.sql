
  CREATE OR REPLACE FORCE VIEW "UGH"."V_VEHTRIPS_SUMHOUR" ("VOLUME", "DATESHIFT_HOUR") AS 
  SELECT
    sum(vt.volume) as volume, 1 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=1
union
SELECT
    sum(vt.volume) as volume, 2 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=2
union
SELECT
    sum(vt.volume) as volume, 3 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=3
union
SELECT
    sum(vt.volume) as volume, 4 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=4
union
SELECT
    sum(vt.volume) as volume, 5 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=5
union
SELECT
    sum(vt.volume) as volume, 6 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=6
union
SELECT
    sum(vt.volume) as volume, 7 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=7
union
SELECT
    sum(vt.volume) as volume, 8 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=8
union
SELECT
    sum(vt.volume) as volume, 9 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=9
union
SELECT
    sum(vt.volume) as volume, 10 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=10
union
SELECT
    sum(vt.volume) as volume, 11 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=11
union
SELECT
    sum(vt.volume) as volume, 12 as dateshift_hour
FROM ugh.v_vehtrips vt
where vt.dateshift_hour <=12;
