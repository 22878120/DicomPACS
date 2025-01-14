DROP FUNCTION ASU.GET_PAC_DOZA
/

--
-- GET_PAC_DOZA  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   TSMID (Table)
--   VRES (Table)
--   GET_DOZA (Function)
--   GET_VIPNAZ (Function)
--   PKG_HANT (Package)
--
CREATE OR REPLACE FUNCTION ASU."GET_PAC_DOZA" (PFK_PACID IN NUMBER) RETURN NUMBER IS
  NRES NUMBER;
  /*
   �REATED BY SPASSKIY S.N. 04.09.2008
  ��������� ��������� ���� ��������� �� ��������
  */

BEGIN
  SELECT NVL(SUM(NVL(ASU.GET_DOZA(VRES.FK_NAZID),
                     STAT.PKG_HANT.GET_DOZA(VRES.FK_NAZID, VRES.FK_SMID))),
             0) DOZ_SUM
    INTO NRES
    FROM VRES,
         (SELECT FK_ID
            FROM TSMID
          CONNECT BY PRIOR FK_ID = FK_OWNER
           START WITH FC_SYNONIM IN
                      ('ISL_RENTGN', 'RENTGENXIR_OPER', 'RENTGENXIR_ISSLED', 'ISL_ONKOLOG', 'KONS_PROTHOPER')) SM
   WHERE SM.FK_ID = VRES.FK_SMID
     AND FK_PACID = PFK_PACID
     AND FK_SOS = ASU.GET_VIPNAZ;
  RETURN NRES;

END;
/

SHOW ERRORS;


