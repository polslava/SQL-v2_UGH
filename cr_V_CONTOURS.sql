
  CREATE OR REPLACE FORCE VIEW "UGH"."V_CONTOURS" ("CONTOURHISTORYGEOMETRY", "CONTOURHISTORYTIMEBEGIN", "CONTOURNAME", "CONTOURID", "CONTOURTYPENAME") AS 
  select ch.contourhistorygeometry, ch.contourhistorytimebegin
    ,c.contourname, c.contourid
    , ct.contourtypename
    from DISPATCHER.contours_history ch
    left join DISPATCHER.contours c on c.contourid=ch.contourid
    left join DISPATCHER.contours_types ct on ct.contourtypeid = c.contourtypeid

where contourhistorytimeend is null;
