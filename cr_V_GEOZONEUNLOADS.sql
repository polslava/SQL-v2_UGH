
  CREATE OR REPLACE FORCE VIEW "UGH"."V_GEOZONEUNLOADS" ("CONTOURNAME") AS 
  select c.contourname from dispatcher.contours c left join dispatcher.contours_history  ch     on c.contourid = ch.contourhistoryid left join dispatcher.contours_types ct     on ct.contourtypeid = c.contourtypeid where ch.contourhistorytimeend is null     and ct.contourtypename = 'Пункт разгрузки' GROUP BY c.contourname order BY c.contourname;
