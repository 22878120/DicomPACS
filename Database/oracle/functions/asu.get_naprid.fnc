DROP FUNCTION ASU.GET_NAPRID
/

--
-- GET_NAPRID  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   TLABREG (Table)
--
CREATE OR REPLACE FUNCTION ASU."GET_NAPRID" 
  ( pFK_NAZID IN NUMBER)
  RETURN  NUMBER IS
CURSOR c(pID NUMBER) IS SELECT FK_NAPRID FROM TLABREG WHERE FK_NAZID=pID;
i NUMBER;
BEGIN
  OPEN c(pFK_NAZID);
  FETCH c INTO i;
  CLOSE c;
  RETURN i;
END; -- Function GET_NAPRID
/

SHOW ERRORS;

