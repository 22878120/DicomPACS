DROP TABLE ASU.TPAC_NAZ_TMP CASCADE CONSTRAINTS
/

--
-- TPAC_NAZ_TMP  (Table) 
--
CREATE GLOBAL TEMPORARY TABLE ASU.TPAC_NAZ_TMP
(
  FN_CONNECT     NUMBER,
  IS_REFUSE      NUMBER,
  FD_CALC        DATE,
  FD_CLOSED      DATE,
  FD_NAZ         DATE,
  FD_RUN         DATE,
  NAZ_ID         NUMBER(15),
  FK_SMID        NUMBER(15),
  FK_ISPOLID     NUMBER(15),
  FK_VRACHID     NUMBER(15),
  FK_TALONID     NUMBER,
  AMB_PR         NUMBER,
  FK_PACID       NUMBER(15),
  FK_PEPLID      NUMBER(15),
  FK_INSURDOCS   NUMBER,
  FK_COMPANYID   NUMBER,
  FK_TYPEDOCID   NUMBER,
  FK_TARIF_TYPE  NUMBER(2),
  FK_USLVIDID    NUMBER(15),
  FC_NAZNAME     VARCHAR2(500 BYTE)
)
ON COMMIT PRESERVE ROWS
NOCACHE
/

COMMENT ON TABLE ASU.TPAC_NAZ_TMP IS '��������� ���. �����. ��������� ������� ��� �������. Author:Efimov'
/

COMMENT ON COLUMN ASU.TPAC_NAZ_TMP.FK_TARIF_TYPE IS '0 - ������� ������, 1 - ���������������, 2 - ����������� �����, 3 - ������ ������'
/

COMMENT ON COLUMN ASU.TPAC_NAZ_TMP.FK_USLVIDID IS 'asu.tuslvid.fk_id - ��� ��������� ������������'
/

COMMENT ON COLUMN ASU.TPAC_NAZ_TMP.FC_NAZNAME IS '�������� ����������'
/


--
-- I_PAC_NAZ_TMP_CM  (Index) 
--
--  Dependencies: 
--   TPAC_NAZ_TMP (Table)
--
CREATE INDEX ASU.I_PAC_NAZ_TMP_CM ON ASU.TPAC_NAZ_TMP
(FK_COMPANYID)
/


--
-- I_PAC_NAZ_TMP_NAZ  (Index) 
--
--  Dependencies: 
--   TPAC_NAZ_TMP (Table)
--
CREATE INDEX ASU.I_PAC_NAZ_TMP_NAZ ON ASU.TPAC_NAZ_TMP
(NAZ_ID)
/


--
-- I_PAC_NAZ_TMP_PEPL  (Index) 
--
--  Dependencies: 
--   TPAC_NAZ_TMP (Table)
--
CREATE INDEX ASU.I_PAC_NAZ_TMP_PEPL ON ASU.TPAC_NAZ_TMP
(FK_PEPLID)
/


--
-- I_PAC_NAZ_TMP_TARIF_TYPE  (Index) 
--
--  Dependencies: 
--   TPAC_NAZ_TMP (Table)
--
CREATE INDEX ASU.I_PAC_NAZ_TMP_TARIF_TYPE ON ASU.TPAC_NAZ_TMP
(FK_TARIF_TYPE)
/


--
-- I_PAC_NAZ_TMP_TD  (Index) 
--
--  Dependencies: 
--   TPAC_NAZ_TMP (Table)
--
CREATE INDEX ASU.I_PAC_NAZ_TMP_TD ON ASU.TPAC_NAZ_TMP
(FK_TYPEDOCID)
/


