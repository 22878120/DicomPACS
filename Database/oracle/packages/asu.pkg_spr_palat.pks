DROP PACKAGE ASU.PKG_SPR_PALAT
/

--
-- PKG_SPR_PALAT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASU."PKG_SPR_PALAT" 
  IS
-- Purpose: ������ �� ������������ �����
  Procedure DO_WRITE_TIPROOM(pFK_ID IN OUT NUMBER,pFK_PALATAID IN NUMBER,pFN_MESTA IN NUMBER,pFK_VIDID IN NUMBER,pFD_DATA1 IN DATE);
  Procedure DO_DELETE_TIPROOM(pFK_ID IN NUMBER);
  Procedure DO_WRITE_PALATA( pFK_ID IN NUMBER,pFK_KORPID IN NUMBER,pFC_PALATA IN VARCHAR2,pFN_FLOOR IN NUMBER,pFC_OPIS IN VARCHAR2,pFK_VRACHID IN NUMBER);
  Procedure GET_PALATA_INFO(pFK_ID IN OUT NUMBER,pFC_PALATA OUT VARCHAR2,pFN_FLOOR OUT NUMBER,pFC_OPIS OUT VARCHAR2,pFK_VRACHID OUT NUMBER);
  Procedure DO_DELETE(pFC_FIELD in VARCHAR2,pFC_TABLE in VARCHAR2,pFK_VALUE IN NUMBER);
  Procedure DO_UPDATE(pFC_TABLE in VARCHAR2,pFC_FIELD in VARCHAR2,pFC_VALUE IN VARCHAR2,pFK_ID IN VARCHAR2,pFK_VALUE IN NUMBER);
  Procedure DO_INSERT(pFC_TABLE in VARCHAR2,pFC_FIELD in VARCHAR2,pFC_VALUE IN VARCHAR2,pFK_ID IN VARCHAR2,pFK_VALUE IN NUMBER);
  PROCEDURE DO_WRITE_KORP(pFK_ID IN OUT NUMBER, pFC_NAME IN VARCHAR2, pFN_FLOOR IN NUMBER);

END; -- Package Specification PKG_SPR_PALAT
/

SHOW ERRORS;


