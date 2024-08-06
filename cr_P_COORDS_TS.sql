create or replace PROCEDURE     P_COORDS_TS AS 

coords_map varchar(10000);
   coords_map1 varchar(4000);
   coords_map2 varchar(4000);
   coords_map3 varchar(4000);
   coords_map4 varchar(4000);
   coords_map10 varchar(4000);
BEGIN
  coords_map1:=(select 1, LISTAGG(coords, ' ')  WITHIN GROUP (ORDER BY order_num) 
        from table (ugh.pac_coords.get_coords_ts_1()))
        ;
END P_COORDS_TS;