ALTER TABLE ASU.TMDA_DBF_SAVE
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TMDA_DBF_SAVE CASCADE CONSTRAINTS
/

--
-- TMDA_DBF_SAVE  (Table) 
--
CREATE TABLE ASU.TMDA_DBF_SAVE
(
  FK_ID       NUMBER(15)                        NOT NULL,
  YEAR        NUMBER(4),
  MONTH       NUMBER(2),
  OWN         NUMBER(1),
  LPU_ID      NUMBER(10),
  PERSON_IDL  NUMBER(19),
  P_ID_ILL    NUMBER(2),
  ID_ILL      NUMBER(19),
  ID_ILL_U    NUMBER(19),
  POLICYSER   VARCHAR2(10 BYTE),
  POLICYNUM   VARCHAR2(20 BYTE),
  FAM         VARCHAR2(25 BYTE),
  IM          VARCHAR2(25 BYTE),
  OTCH        VARCHAR2(25 BYTE),
  DATE_B_DAY  DATE,
  DIA_E       VARCHAR2(8 BYTE),
  DATE_S      DATE,
  DATE_E      DATE,
  DATE_B_U    DATE,
  DATE_E_U    DATE,
  TYPE_USL    NUMBER(1),
  KOD_EO      VARCHAR2(20 BYTE),
  KOL_EO      NUMBER(5),
  TYPE_EO     NUMBER(2),
  IST_FIN     NUMBER(2),
  SBJ_MODERN  NUMBER(10,2),
  FED_MODERN  NUMBER(10,2),
  TRF_MODERN  NUMBER(10,2),
  SUM_MODERN  NUMBER(10,2),
  PRVSM_U     NUMBER(4),
  DOC_CD_U    VARCHAR2(20 BYTE),
  FK_SLUCHID  NUMBER(15),
  FK_USLID    NUMBER(15)
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE ASU.TMDA_DBF_SAVE IS '������ �� ��������� ����������� ������� �� ��������� ������������ (�������� � DBF, ������� MDA) Author:Efimov'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.FK_ID IS 'ASU.SEQ_TMDA_DBF'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.YEAR IS '��� ������ �������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.MONTH IS '����� ������ �������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.LPU_ID IS '��� ��� (���������� LPU)'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.PERSON_IDL IS '��������� ����� ��������������� � ���'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.ID_ILL IS '����������������� ����� ������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.POLICYSER IS '����� ������ ��������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.POLICYNUM IS '����� ������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.FAM IS '������� ��������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.IM IS '��� ��������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.OTCH IS '�������� ��������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.DATE_B_DAY IS '���� �������� ��������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.DIA_E IS '������� �������������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.DATE_S IS '���� ������ �����������'
/

COMMENT ON COLUMN ASU.TMDA_DBF_SAVE.DATE_E IS '���� ��������� �����������'
/


--
-- I_TMDA_DBF_SAVE_ID_ILL  (Index) 
--
--  Dependencies: 
--   TMDA_DBF_SAVE (Table)
--
CREATE INDEX ASU.I_TMDA_DBF_SAVE_ID_ILL ON ASU.TMDA_DBF_SAVE
(LPU_ID, P_ID_ILL)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- I_TMDA_DBF_SAVE_ID_ILL_U  (Index) 
--
--  Dependencies: 
--   TMDA_DBF_SAVE (Table)
--
CREATE INDEX ASU.I_TMDA_DBF_SAVE_ID_ILL_U ON ASU.TMDA_DBF_SAVE
(ID_ILL_U)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- K_TMDA_DBF_SAVE_ID  (Index) 
--
--  Dependencies: 
--   TMDA_DBF_SAVE (Table)
--
CREATE UNIQUE INDEX ASU.K_TMDA_DBF_SAVE_ID ON ASU.TMDA_DBF_SAVE
(FK_ID)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table TMDA_DBF_SAVE 
-- 
ALTER TABLE ASU.TMDA_DBF_SAVE ADD (
  CONSTRAINT K_TMDA_DBF_SAVE_ID
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
    TABLESPACE USR
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/

