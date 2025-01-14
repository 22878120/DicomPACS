DROP TABLE ASU.TAPRIH CASCADE CONSTRAINTS
/

--
-- TAPRIH  (Table) 
--
CREATE TABLE ASU.TAPRIH
(
  FK_ID             NUMBER(9)                   NOT NULL,
  FD_DATE           DATE                        NOT NULL,
  FC_DOC            VARCHAR2(15 BYTE),
  FK_APOSTAVSHIKID  NUMBER(9)                   NOT NULL,
  FK_AKOMUID        NUMBER(9)                   NOT NULL,
  FC_COMMENT        VARCHAR2(300 BYTE),
  FK_APRIHVIDID     NUMBER(9)
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          520K
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

COMMENT ON TABLE ASU.TAPRIH IS '������ ���������� �� ������'
/

COMMENT ON COLUMN ASU.TAPRIH.FK_ID IS 'SEQUENCE=[SEQ_TAPRIH]'
/

COMMENT ON COLUMN ASU.TAPRIH.FD_DATE IS '�����'
/

COMMENT ON COLUMN ASU.TAPRIH.FC_DOC IS '����� ���������'
/

COMMENT ON COLUMN ASU.TAPRIH.FK_APOSTAVSHIKID IS '�� ���� ������ TAPOSTAVSHIK.FK_ID'
/

COMMENT ON COLUMN ASU.TAPRIH.FK_AKOMUID IS '���� ������ TAPOSTAVSHIK.FK_ID'
/

COMMENT ON COLUMN ASU.TAPRIH.FC_COMMENT IS '�����������'
/

COMMENT ON COLUMN ASU.TAPRIH.FK_APRIHVIDID IS '��� ������� ��� �������'
/


--
-- TAPRIH$AKOMUID  (Index) 
--
--  Dependencies: 
--   TAPRIH (Table)
--
CREATE INDEX ASU.TAPRIH$AKOMUID ON ASU.TAPRIH
(FK_AKOMUID)
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
-- TAPRIH$ID$APOSTAV$AKOMUID  (Index) 
--
--  Dependencies: 
--   TAPRIH (Table)
--
CREATE UNIQUE INDEX ASU.TAPRIH$ID$APOSTAV$AKOMUID ON ASU.TAPRIH
(FK_ID, FK_APOSTAVSHIKID, FK_AKOMUID)
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
-- TAPRIH$ID$DATE  (Index) 
--
--  Dependencies: 
--   TAPRIH (Table)
--
CREATE UNIQUE INDEX ASU.TAPRIH$ID$DATE ON ASU.TAPRIH
(FK_ID, FD_DATE)
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
-- TAPRIH$KUMO$POSTAVSHIK  (Index) 
--
--  Dependencies: 
--   TAPRIH (Table)
--
CREATE INDEX ASU.TAPRIH$KUMO$POSTAVSHIK ON ASU.TAPRIH
(FK_APOSTAVSHIKID, FK_AKOMUID)
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
-- TAPRIH$INS  (Trigger) 
--
--  Dependencies: 
--   TAPRIH (Table)
--
CREATE OR REPLACE TRIGGER ASU."TAPRIH$INS" 
BEFORE INSERT
ON ASU.TAPRIH REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  SELECT seq_taprih.nextval
    INTO :new.fk_id
    FROM dual;
END;
/
SHOW ERRORS;


--
-- TAPRIH$DEL  (Trigger) 
--
--  Dependencies: 
--   TAPRIH (Table)
--
CREATE OR REPLACE TRIGGER ASU."TAPRIH$DEL" 
AFTER DELETE
ON ASU.TAPRIH REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  DELETE
    FROM taprihcont
   WHERE fk_aprihid = :old.fk_id;
END;
/
SHOW ERRORS;


