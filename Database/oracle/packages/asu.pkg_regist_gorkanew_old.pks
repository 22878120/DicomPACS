DROP PACKAGE ASU.PKG_REGIST_GORKANEW_OLD
/

--
-- PKG_REGIST_GORKANEW_OLD  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASU."PKG_REGIST_GORKANEW_OLD" 
  IS-- Created by TimurLan
  FUNCTION DO_MONTHIB_BY_ALL(pFD_DATA1 IN DATE,pFD_DATA2 IN DATE,pFK_VRACHID IN NUMBER) RETURN NUMBER;
  FUNCTION DO_MONTHIB_BY_KORP(pFD_DATA1 IN DATE,pFD_DATA2 IN DATE,pFK_VRACHID IN NUMBER,pFK_KORPID IN NUMBER) RETURN NUMBER;
END;
/

SHOW ERRORS;

