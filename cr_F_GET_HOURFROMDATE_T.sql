create or replace FUNCTION F_GET_HOURFROMDATE_T 
(
  INDATE IN DATE DEFAULT SYSDATE 
) RETURN VARCHAR AS 
BEGIN
  RETURN to_char(INDATE,'hh24');
END F_GET_HOURFROMDATE_T;