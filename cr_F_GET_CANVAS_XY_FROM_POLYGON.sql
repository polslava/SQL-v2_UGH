create or replace FUNCTION F_GET_CANVAS_XY_FROM_POLYGON 
(
  P_POLYGON0 IN VARCHAR2 ,
  WORKAREANAME IN VARCHAR2 
) RETURN VARCHAR2 AS 
BEGIN
declare
 P_POLYGON VARCHAR2 (4000);
 P_POLYGON1 VARCHAR2 (4000);
 
     p_polygon1_x VARCHAR2 (15);
     p_polygon1_x1 number(20);
     p_polygon1_y VARCHAR2 (15);
    p_polygon1_y1 number(20);
    
   
    WORKAREANAME1 VARCHAR2 (50);
    P_POLYGON_out VARCHAR2 (4000);
BEGIN

  p_polygon:=substr(p_polygon0,INSTR(p_polygon0,'((')+3); --,INSTR(p_polygon,'))')-INSTR(p_polygon,'((')
   p_polygon:=replace(p_polygon,' ))',',');
    
    p_polygon1:=substr(p_polygon,0,INSTR(p_polygon,',')-1);
    p_polygon1_x :=substr(p_polygon1,0,INSTR(p_polygon1,' ')-1);
    p_polygon1_x1 :=cast(replace(p_polygon1_x,'.',',') as number);
    p_polygon1_x :=F_GET_CANVAS_x_FROM_x(p_polygon1_x1);
    p_polygon1_y :=substr(p_polygon1,INSTR(p_polygon,' ')+0);
    p_polygon1_y1 :=cast(replace(p_polygon1_y,'.',',') as number);
    p_polygon1_y :=F_GET_CANVAS_y_FROM_y(p_polygon1_y1);
    
    
    WORKAREANAME1:=WORKAREANAME;
    --ctx.strokeText("Карьер", 230,430)
    p_polygon1:='ctx.strokeText("'||WORKAREANAME1||'",'||p_polygon1_x||','||p_polygon1_y||');';
    p_polygon1:=p_polygon1||'ctx.moveTo('||p_polygon1_x||','||p_polygon1_y||');';
    
    P_POLYGON_out := p_polygon1
      ;
        --return p_polygon1;
        p_polygon:=substr(p_polygon,INSTR(p_polygon,',')+1);
    for i IN 1..regexp_count(p_polygon,',') 
    LOOP
        p_polygon1:=substr(p_polygon,0,INSTR(p_polygon,',')-1);
 
        p_polygon1_x :=substr(p_polygon1,0,INSTR(p_polygon1,' ')-1);

         p_polygon1_x1 :=cast(replace(p_polygon1_x,'.',',') as number);

         p_polygon1_x :=F_GET_CANVAS_x_FROM_x(p_polygon1_x1);

        p_polygon1_y :=substr(p_polygon1,INSTR(p_polygon,' ')+0);

        p_polygon1_y1 :=cast(replace(p_polygon1_y,'.',',') as number);

        p_polygon1_y :=F_GET_CANVAS_y_FROM_y(p_polygon1_y1);
    
    
        p_polygon1:='ctx.lineTo('||p_polygon1_x||','||p_polygon1_y||');';
       --return p_polygon1;
       P_POLYGON_out :=P_POLYGON_out ||p_polygon1;
        p_polygon:=substr(p_polygon,INSTR(p_polygon,',')+1);
        
    END LOOP;
    P_POLYGON_out :=P_POLYGON_out ||
        'ctx.closePath();
        '||
        'ctx.fill();
        ctx.fillStyle = "#000";'
        ;
    return p_polygon_out;
end;
END F_GET_CANVAS_XY_FROM_POLYGON;