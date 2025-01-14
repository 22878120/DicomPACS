DROP PACKAGE ASU.PKG_SETUP_LAB_ISSL_REPORT
/

--
-- PKG_SETUP_LAB_ISSL_REPORT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE ASU."PKG_SETUP_LAB_ISSL_REPORT" 
  IS
--
-- Purpose: ������ �� ��������� ������ �� ����������� �� �������������
--
--
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
-- Philip A. Milovanov 10.01.2001
  PROCEDURE DO_SAVE_ROW(pFK_ID IN NUMBER,pFK_SMID IN NUMBER,pFC_NAME IN VARCHAR2,pFC_FORMULA IN VARCHAR2,pFC_TYPE IN VARCHAR2);
  PROCEDURE DO_DELETE_ROW(pFK_ID IN NUMBER);
  PROCEDURE DO_REARRANGE_ROWS(pFN_REQNUM IN NUMBER,pFL_RESERVE IN NUMBER);
  PROCEDURE DO_SET_ROW_NUM(pFN_ROW IN NUMBER,pFN_REQNUM IN NUMBER);
  PROCEDURE DO_ADD_COL;
  PROCEDURE DO_ADD_ROW;
  PROCEDURE DO_REARRANGE_COLS(pFN_REQNUM IN NUMBER,pFL_RESERVE IN NUMBER);
  PROCEDURE DO_SET_COL_NUM(pFN_COL IN NUMBER,pFN_REQNUM IN NUMBER);
  PROCEDURE DO_DELETE_COL(pFK_ID IN NUMBER);
END; -- Package Specification PKG_SETUP_LAB_ISSL_REPORT
/

SHOW ERRORS;


