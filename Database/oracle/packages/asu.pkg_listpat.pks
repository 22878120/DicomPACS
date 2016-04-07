DROP PACKAGE ASU.PKG_LISTPAT
/

--
-- PKG_LISTPAT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASU."PKG_LISTPAT" IS
  FUNCTION get_nazname(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_ispolnitelname(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_napravitname(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_datenaz(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_datevip(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_vipsos(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_pacdiags_spec(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_nazuet(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_mkb10_spec(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION get_vrachzakl(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION GET_PATHID(id IN NUMBER) RETURN NUMBER;
  FUNCTION GET_VIPDATE(pVNazID IN NUMBER) RETURN DATE;
  FUNCTION GET_NAZDATE(pVNazID IN NUMBER) RETURN DATE;
  FUNCTION GET_NAPRNAME(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION GET_ZAKL(pVNazID IN NUMBER) RETURN VARCHAR2;
  FUNCTION GET_COUNT_NAZ(pVNazID IN NUMBER) RETURN NUMBER;
  FUNCTION GET_COUNT_RES(pVNazID IN NUMBER) RETURN NUMBER;
  FUNCTION GET_NAZDOCNAME(pVNazID IN NUMBER) RETURN VARCHAR2;
END;
/

SHOW ERRORS;

