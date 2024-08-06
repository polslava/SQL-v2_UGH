
  CREATE OR REPLACE FORCE VIEW "UGH"."V_AREAS_FUNC" ("AREAID", "ISFUNCTIONAL", "CHANGEDATE", "NAME", "AREA_NAME") AS 
  select af.areaid, af.isfunctional, af.changedate
    ,a.name
    , afs.area_name
    from areas_func af 
    left join DISPATCHER.areas a on a.id = af.areaid
    --inner 
    left join ugh.areas_functional afs on afs.area_name=a.name /*данные от маркшейдеров на определённую дату*/
    order by a.name, afs.area_name;
