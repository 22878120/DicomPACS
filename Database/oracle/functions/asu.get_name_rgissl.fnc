DROP FUNCTION ASU.GET_NAME_RGISSL
/

--
-- GET_NAME_RGISSL  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   TSMID (Table)
--   GET_FULLPATH_SHA (Function)
--   GET_SMIDNAME (Function)
--
CREATE OR REPLACE FUNCTION ASU."GET_NAME_RGISSL" (PFK_SMID IN NUMBER)
RETURN VARCHAR2 IS
CURSOR cCnt IS SELECT COUNT(*) FROM TSMID WHERE FK_OWNER = PFK_SMID AND FL_SHOWPRINT = 0;
CURSOR cFULLPATH IS SELECT GET_FULLPATH_SHA(PFK_SMID) FROM DUAL;
CURSOR cSMIDNAME IS SELECT GET_SMIDNAME(PFK_SMID) FROM DUAL;
--CURSOR cOWNER IS SELECT COUNT(*) FROM TSMID
--                         WHERE FK_OWNER IN (SELECT FK_ID FROM TSMID WHERE FK_ID = GET_RG_ISSL)
--                        START WITH FK_ID = PFK_SMID
--                        CONNECT BY PRIOR FK_OWNER = FK_ID;
Cnt NUMBER;
--CntOwner NUMBER;
sRes VARCHAR2(1000);

BEGIN 
  OPEN cCnt;
  FETCH cCnt INTO Cnt;
  CLOSE cCnt;
--  OPEN cOWNER;
--  FETCH cOWNER INTO CntOwner;
--  CLOSE cOWNER;
  IF Cnt > 0 then
  --OR (CntOwner > 0) THEN
    OPEN cFULLPATH;
    FETCH cFULLPATH INTO sRes;
    CLOSE cFULLPATH;
  ELSE
    OPEN cSMIDNAME;
    FETCH cSMIDNAME INTO sRes;
    CLOSE cSMIDNAME;
  END IF;

    RETURN sRes ;
END;
/

SHOW ERRORS;

