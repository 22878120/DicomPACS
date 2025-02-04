ALTER TABLE ASU.TLPY_THERPOINS
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TLPY_THERPOINS CASCADE CONSTRAINTS
/

--
-- TLPY_THERPOINS  (Table) 
--
CREATE TABLE ASU.TLPY_THERPOINS
(
  FK_ID           INTEGER                       NOT NULL,
  FK_COMPANY_LPY  NUMBER(15)                    DEFAULT 0                     NOT NULL,
  FK_THERPOINT    INTEGER                       NOT NULL
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          160K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE ASU.TLPY_THERPOINS IS '����� ��� � ���������
Author: Ura'
/

COMMENT ON COLUMN ASU.TLPY_THERPOINS.FK_ID IS 'SEQUENCE=[SEQ_TLPY_THERPOINTS]'
/

COMMENT ON COLUMN ASU.TLPY_THERPOINS.FK_COMPANY_LPY IS 'TCOMPANY.FK_ID ������ �� ���'
/

COMMENT ON COLUMN ASU.TLPY_THERPOINS.FK_THERPOINT IS 'TTHERPOINTS.FK_ID ������ �� �������'
/


--
-- IX_TLPY_THERPOINS_FK_COMPANY  (Index) 
--
--  Dependencies: 
--   TLPY_THERPOINS (Table)
--
CREATE INDEX ASU.IX_TLPY_THERPOINS_FK_COMPANY ON ASU.TLPY_THERPOINS
(FK_THERPOINT)
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
-- IX_TLPY_THERPOINS_FK_THERPOINT  (Index) 
--
--  Dependencies: 
--   TLPY_THERPOINS (Table)
--
CREATE INDEX ASU.IX_TLPY_THERPOINS_FK_THERPOINT ON ASU.TLPY_THERPOINS
(FK_COMPANY_LPY)
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
-- PK_TLPY_THERPOINS  (Index) 
--
--  Dependencies: 
--   TLPY_THERPOINS (Table)
--
CREATE UNIQUE INDEX ASU.PK_TLPY_THERPOINS ON ASU.TLPY_THERPOINS
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
-- TLPY_THERPOINS$BI  (Trigger) 
--
--  Dependencies: 
--   TLPY_THERPOINS (Table)
--
CREATE OR REPLACE TRIGGER ASU."TLPY_THERPOINS$BI" 
 BEFORE
  INSERT
 ON tlpy_therpoins
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
begin
    --  Column "FK_ID" uses sequence SEQ_TLPY_THERPOINTS
    select SEQ_TLPY_THERPOINTS.NEXTVAL INTO :new.FK_ID from dual;
end;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TLPY_THERPOINS 
-- 
ALTER TABLE ASU.TLPY_THERPOINS ADD (
  CONSTRAINT PK_TLPY_THERPOINS
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

