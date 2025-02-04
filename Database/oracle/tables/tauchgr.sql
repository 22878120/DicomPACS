DROP TABLE ASU.TAUCHGR CASCADE CONSTRAINTS
/

--
-- TAUCHGR  (Table) 
--
CREATE TABLE ASU.TAUCHGR
(
  FK_ID       NUMBER(9)                         DEFAULT -1                    NOT NULL,
  FC_NAME     VARCHAR2(50 BYTE)                 NOT NULL,
  FC_COMMENT  VARCHAR2(120 BYTE),
  FL_REPORT   NUMBER(1)
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

COMMENT ON TABLE ASU.TAUCHGR IS '������� ������ � ������'
/

COMMENT ON COLUMN ASU.TAUCHGR.FK_ID IS 'SEQUENCE=[SEQ_TAUCHGR]'
/

COMMENT ON COLUMN ASU.TAUCHGR.FC_NAME IS '�������� ������� ������'
/

COMMENT ON COLUMN ASU.TAUCHGR.FC_COMMENT IS '�������� ������� ������'
/

COMMENT ON COLUMN ASU.TAUCHGR.FL_REPORT IS '�������� �� ��� ������ � �����'
/


--
-- TAUCHGR_INS  (Trigger) 
--
--  Dependencies: 
--   TAUCHGR (Table)
--
CREATE OR REPLACE TRIGGER ASU."TAUCHGR_INS" 
BEFORE INSERT
ON tauchgr
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  SELECT seq_TAUCHGR.nextval
    into :new.fk_id
    FROM dual;
END;
/
SHOW ERRORS;


--
-- TAUCHGRASU_INS  (Trigger) 
--
--  Dependencies: 
--   TAUCHGR (Table)
--
CREATE OR REPLACE TRIGGER ASU."TAUCHGRASU_INS" 
BEFORE INSERT
ON ASU.TAUCHGR REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  SELECT seq_TAUCHGR.nextval
    into :new.fk_id
    FROM dual;
END;
/
SHOW ERRORS;


