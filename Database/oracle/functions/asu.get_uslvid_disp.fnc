DROP FUNCTION ASU.GET_USLVID_DISP
/

--
-- GET_USLVID_DISP  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE FUNCTION ASU.GET_USLVID_DISP
  RETURN NUMBER DETERMINISTIC
  IS -- Created by -= aAdmin.exe =- 
     -- ATTENTION! DO NOT MODIFY THIS FUNCTION MANUALLY!!!
BEGIN
  Return 1221;
END;
/

SHOW ERRORS;


DROP PUBLIC SYNONYM GET_USLVID_DISP
/

--
-- GET_USLVID_DISP  (Synonym) 
--
--  Dependencies: 
--   GET_USLVID_DISP (Function)
--
CREATE PUBLIC SYNONYM GET_USLVID_DISP FOR ASU.GET_USLVID_DISP
/


GRANT EXECUTE ON ASU.GET_USLVID_DISP TO PUBLIC
/
