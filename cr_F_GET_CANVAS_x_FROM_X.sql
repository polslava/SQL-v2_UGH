create or replace FUNCTION F_GET_CANVAS_x_FROM_X 
(
  X IN NUMBER DEFAULT 20390000 
--, Y IN NUMBER DEFAULT 6510000 
) RETURN VARCHAR2 AS 
BEGIN
    
  RETURN replace(to_char(round((x-20388000)/5,0)),',','.');
END F_GET_CANVAS_x_FROM_X;