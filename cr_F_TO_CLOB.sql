create or replace FUNCTION F_TO_CLOB 
(
  TEXT IN VARCHAR2 DEFAULT '' 
) RETURN CLOB AS 
BEGIN
 
  RETURN to_clob(text);
END F_TO_CLOB;