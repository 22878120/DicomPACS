ALTER TABLE ASU.TRSD_DBF_TEMP
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TRSD_DBF_TEMP CASCADE CONSTRAINTS
/

--
-- TRSD_DBF_TEMP  (Table) 
--
CREATE TABLE ASU.TRSD_DBF_TEMP
(
  FK_ID       NUMBER                            NOT NULL,
  YEAR        NUMBER(4),
  MONTH       NUMBER(2),
  SMK_ID_P    NUMBER(10),
  LPU_ID      NUMBER(10),
  PERSON_IDL  NUMBER(19),
  ID_ILL      NUMBER(19),
  P_ID_ILL    NUMBER(2),
  TOTAL_SMO   NUMBER(10,2),
  SANK_KOD    NUMBER(5),
  UDR_MEK     NUMBER(10,2),
  UDR_MEE     NUMBER(10,2),
  UDR_EKMP    NUMBER(10,2),
  SHTR_MEK    NUMBER(10,2),
  SHTR_MEE    NUMBER(10,2),
  SHTR_EKMP   NUMBER(10,2),
  MSG_DEF     VARCHAR2(120 BYTE),
  LPU_INTR    NUMBER(10)
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
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

COMMENT ON TABLE ASU.TRSD_DBF_TEMP IS '����������� �� RSD ������ �������� (������� ��� ������� ������ �������� ������ ���������� �� ��������� ��������) Author:Efimov'
/

COMMENT ON COLUMN ASU.TRSD_DBF_TEMP.FK_ID IS 'ASU.SEQ_TRSD_DBF_TEMP'
/


--
-- I_RSD_DBF_TEMP_BY_KEY  (Index) 
--
--  Dependencies: 
--   TRSD_DBF_TEMP (Table)
--
CREATE UNIQUE INDEX ASU.I_RSD_DBF_TEMP_BY_KEY ON ASU.TRSD_DBF_TEMP
(YEAR, MONTH, LPU_ID, ID_ILL, NVL("P_ID_ILL",(-1)), 
SANK_KOD)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- K_TRSD_DBF_TEMP_ID  (Index) 
--
--  Dependencies: 
--   TRSD_DBF_TEMP (Table)
--
CREATE UNIQUE INDEX ASU.K_TRSD_DBF_TEMP_ID ON ASU.TRSD_DBF_TEMP
(FK_ID)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TRSD_DBF_TEMP_INSERT  (Trigger) 
--
--  Dependencies: 
--   TRSD_DBF_TEMP (Table)
--
CREATE OR REPLACE TRIGGER ASU."TRSD_DBF_TEMP_INSERT" 
 BEFORE
  INSERT
 ON asu.TRSD_DBF_TEMP
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
Begin
  IF :new.fk_id IS NULL THEN
    SELECT asu.SEQ_TSLUCH_DBF.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
  end if;
End;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TRSD_DBF_TEMP 
-- 
ALTER TABLE ASU.TRSD_DBF_TEMP ADD (
  CONSTRAINT K_TRSD_DBF_TEMP_ID
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
    TABLESPACE USR
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/

