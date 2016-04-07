DROP FUNCTION ASU.GET_PAC_SUB_VID_KODE
/

--
-- GET_PAC_SUB_VID_KODE  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   TKARTA (Table)
--
CREATE OR REPLACE FUNCTION ASU."GET_PAC_SUB_VID_KODE" 
  ( pFK_ID IN NUMBER)
  RETURN  NUMBER IS
CURSOR c(pID NUMBER) IS SELECT FK_KOD FROM TKARTA WHERE FK_ID=pID;
i NUMBER;
BEGIN
  OPEN c(pFK_ID);
  FETCH C INTO i;
  CLOSE c;
  RETURN i;
END; -- Function GET_PAC_SUB_VID_KODE
/

SHOW ERRORS;

