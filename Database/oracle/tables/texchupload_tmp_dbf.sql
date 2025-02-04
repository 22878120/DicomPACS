DROP TABLE ASU.TEXCHUPLOAD_TMP_DBF CASCADE CONSTRAINTS
/

--
-- TEXCHUPLOAD_TMP_DBF  (Table) 
--
CREATE GLOBAL TEMPORARY TABLE ASU.TEXCHUPLOAD_TMP_DBF
(
  FK_PACID      NUMBER,
  FK_REGIONID   NUMBER,
  FK_TALONID    NUMBER,
  FK_PEPLID     NUMBER,
  FP_POLY       NUMBER,
  FN_YEAR       NUMBER(4),
  FN_MONTH      NUMBER(2),
  P_ID_ILL      NUMBER(2),
  OWN           NUMBER(1),
  POLICYSER     VARCHAR2(10 BYTE),
  POLICYNUM     VARCHAR2(20 BYTE),
  TFOMS_ID      NUMBER(15),
  SMK_NAME      VARCHAR2(50 BYTE),
  Q_OGRN        VARCHAR2(15 BYTE),
  VID_P         NUMBER(15),
  DATE_NPOL     DATE,
  DATE_EPOL     DATE,
  DATE_S        DATE,
  DATE_E        DATE,
  SMK_ID        NUMBER(15),
  FK_INSURDOCS  NUMBER(15),
  FK_USLVIDID   NUMBER(15)
)
ON COMMIT PRESERVE ROWS
NOCACHE
/

COMMENT ON TABLE ASU.TEXCHUPLOAD_TMP_DBF IS '��������� ������� �1 ��� �������� ��������� ������ Author:Linnikov 20080401 '
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FK_REGIONID IS 'TREGION.FK_ID'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FK_TALONID IS 'TAMBTALON.FK_ID'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FK_PEPLID IS 'TPEOPLES.FK_ID'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FP_POLY IS '0 - ���������, 1 - �����������'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FN_YEAR IS '��� ��������'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FN_MONTH IS '����� ��������'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.P_ID_ILL IS '���� ����������� ������ ��� �������� ����������� �������, ��� ���� ����� ��� ��������� �������� ��� �� �������� (����������� �� ������ SYSDATE)'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.OWN IS '������� ����� ����������� (1- ����������� �� ���������� ����-���� 2- ����������� �� ���� ���������� ��'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.SMK_ID IS '��������� �������� ASU.TCOMPANY.FK_ID'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FK_INSURDOCS IS '��������� ��������'
/

COMMENT ON COLUMN ASU.TEXCHUPLOAD_TMP_DBF.FK_PACID IS 'TKARTA.FK_ID'
/


--
-- I_TEXCHUPLOAD_TMP_DBF_DATE_E  (Index) 
--
--  Dependencies: 
--   TEXCHUPLOAD_TMP_DBF (Table)
--
CREATE INDEX ASU.I_TEXCHUPLOAD_TMP_DBF_DATE_E ON ASU.TEXCHUPLOAD_TMP_DBF
(DATE_E)
/


--
-- I_TEXCHUPLOAD_TMP_DBF_OWN  (Index) 
--
--  Dependencies: 
--   TEXCHUPLOAD_TMP_DBF (Table)
--
CREATE INDEX ASU.I_TEXCHUPLOAD_TMP_DBF_OWN ON ASU.TEXCHUPLOAD_TMP_DBF
(OWN)
/


--
-- I_TEXCHUPLOAD_TMP_DBF_PACID  (Index) 
--
--  Dependencies: 
--   TEXCHUPLOAD_TMP_DBF (Table)
--
CREATE INDEX ASU.I_TEXCHUPLOAD_TMP_DBF_PACID ON ASU.TEXCHUPLOAD_TMP_DBF
(DECODE("FP_POLY",1,"FK_TALONID","FK_PACID"))
/


--
-- I_TEXCHUPLOAD_TMP_DBF_POLY_OWN  (Index) 
--
--  Dependencies: 
--   TEXCHUPLOAD_TMP_DBF (Table)
--
CREATE INDEX ASU.I_TEXCHUPLOAD_TMP_DBF_POLY_OWN ON ASU.TEXCHUPLOAD_TMP_DBF
(FP_POLY, OWN)
/


