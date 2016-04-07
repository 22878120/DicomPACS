ALTER TABLE ASU.TNAZMON
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TNAZMON CASCADE CONSTRAINTS
/

--
-- TNAZMON  (Table) 
--
CREATE TABLE ASU.TNAZMON
(
  FK_ID       NUMBER                            NOT NULL,
  FC_MESSAGE  VARCHAR2(4000 BYTE),
  FC_RE�IVER  VARCHAR2(10 BYTE),
  FL_RECIVED  NUMBER(1)                         DEFAULT 0
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1040K
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

COMMENT ON TABLE ASU.TNAZMON IS 'Created by TimurLan 4 aNazMon.dpr'
/

COMMENT ON COLUMN ASU.TNAZMON.FK_ID IS 'SEQUENCE=[SEQ_TNAZMON]'
/

COMMENT ON COLUMN ASU.TNAZMON.FC_MESSAGE IS '���������'
/

COMMENT ON COLUMN ASU.TNAZMON.FC_RE�IVER IS '����������'
/

COMMENT ON COLUMN ASU.TNAZMON.FL_RECIVED IS '1 - �������� ��������'
/


--
-- TNAZMON_BY_ID  (Index) 
--
--  Dependencies: 
--   TNAZMON (Table)
--
CREATE UNIQUE INDEX ASU.TNAZMON_BY_ID ON ASU.TNAZMON
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
-- TNAZMON_BY_RECIVED  (Index) 
--
--  Dependencies: 
--   TNAZMON (Table)
--
CREATE INDEX ASU.TNAZMON_BY_RECIVED ON ASU.TNAZMON
(FL_RECIVED)
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
-- TNAZMON_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TNAZMON (Table)
--
CREATE OR REPLACE TRIGGER ASU."TNAZMON_BEFORE_INSERT" 
  BEFORE INSERT
  ON ASU.TNAZMON   REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
Begin
  SELECT SEQ_TNAZMON.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TNAZMON 
-- 
ALTER TABLE ASU.TNAZMON ADD (
  CONSTRAINT TNAZMON_BY_ID
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
