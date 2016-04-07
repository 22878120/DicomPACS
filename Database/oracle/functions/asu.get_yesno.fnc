DROP FUNCTION ASU.GET_YESNO
/

--
-- GET_YESNO  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE FUNCTION ASU."GET_YESNO" (BoolVal IN NUMBER)
  RETURN VARCHAR2
IS
BEGIN
  IF BoolVal <> 0 THEN
    RETURN '��';
  ELSE
    RETURN '���';
  END IF;
END;
/

SHOW ERRORS;


