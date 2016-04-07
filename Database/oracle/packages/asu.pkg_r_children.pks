DROP PACKAGE ASU.PKG_R_CHILDREN
/

--
-- PKG_R_CHILDREN  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASU."PKG_R_CHILDREN" 
 IS
 FUNCTION DO_CALC_REPORT (pFD_DATA1 IN DATE,pFD_DATA2 IN DATE,pFK_VRACHID IN NUMBER) RETURN NUMBER;
END;
/

SHOW ERRORS;

