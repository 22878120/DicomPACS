ALTER TABLE ASU.TVACCIN_PREP_STORE_LOG
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TVACCIN_PREP_STORE_LOG CASCADE CONSTRAINTS
/

--
-- TVACCIN_PREP_STORE_LOG  (Table) 
--
--  Dependencies: 
--   TVACCIN_PREP_STORE (Table)
--
CREATE TABLE ASU.TVACCIN_PREP_STORE_LOG
(
  FK_ID                 NUMBER                  NOT NULL,
  FK_VACCIN_PREP_STORE  NUMBER,
  FD                    DATE,
  FN_TYPE               NUMBER,
  FN_NUM                NUMBER(16,3),
  FK_SOTR               NUMBER,
  FC_REM                VARCHAR2(200 BYTE),
  FN_OLD                NUMBER(16,3),
  FN_NEW                NUMBER(16,3)
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
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

COMMENT ON TABLE ASU.TVACCIN_PREP_STORE_LOG IS '������� �������� � ���������� ������ ���������� ��� ��������������
Author: Ura'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FK_ID IS 'SEQUENCE=[SEQ_VACCIN]'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FK_VACCIN_PREP_STORE IS '������ �� TVACCIN_PREP_STORE'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FD IS '����'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FN_TYPE IS '1- ������; 2-������; 3-��������; 4- �������; 5- ����������� �� ������� �����'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FN_NUM IS '����������, ������������ - ������, ������������� ������ ��� �������'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FK_SOTR IS '���� ��� ��� ������'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FC_REM IS '����������'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FN_OLD IS '���� �� ������'
/

COMMENT ON COLUMN ASU.TVACCIN_PREP_STORE_LOG.FN_NEW IS '����� �� ������'
/


--
-- PK_TVACCIN_PREP_STORE_LOG  (Index) 
--
--  Dependencies: 
--   TVACCIN_PREP_STORE_LOG (Table)
--
CREATE UNIQUE INDEX ASU.PK_TVACCIN_PREP_STORE_LOG ON ASU.TVACCIN_PREP_STORE_LOG
(FK_ID)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TVACCIN_PREP_STORE_LOG$FK_VPS  (Index) 
--
--  Dependencies: 
--   TVACCIN_PREP_STORE_LOG (Table)
--
CREATE INDEX ASU.TVACCIN_PREP_STORE_LOG$FK_VPS ON ASU.TVACCIN_PREP_STORE_LOG
(FK_VACCIN_PREP_STORE)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TVACCIN_PREP_STORE_LOG_BEFORI  (Trigger) 
--
--  Dependencies: 
--   TVACCIN_PREP_STORE_LOG (Table)
--
CREATE OR REPLACE TRIGGER ASU."TVACCIN_PREP_STORE_LOG_BEFORI" 
 BEFORE
  INSERT
 ON ASU.TVACCIN_PREP_STORE_LOG REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  IF :NEW.fk_id IS NULL
  THEN
    SELECT SEQ_VACCIN.NEXTVAL
      INTO :NEW.fk_id
      FROM DUAL;
  END IF;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TVACCIN_PREP_STORE_LOG 
-- 
ALTER TABLE ASU.TVACCIN_PREP_STORE_LOG ADD (
  CONSTRAINT PK_TVACCIN_PREP_STORE_LOG
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
    TABLESPACE INDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          128K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/

-- 
-- Foreign Key Constraints for Table TVACCIN_PREP_STORE_LOG 
-- 
ALTER TABLE ASU.TVACCIN_PREP_STORE_LOG ADD (
  CONSTRAINT FK_TVACCIN_PL$TVACCIN_PREP 
 FOREIGN KEY (FK_VACCIN_PREP_STORE) 
 REFERENCES ASU.TVACCIN_PREP_STORE (FK_ID))
/

