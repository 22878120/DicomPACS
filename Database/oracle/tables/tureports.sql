DROP TABLE ASU.TUREPORTS CASCADE CONSTRAINTS
/

--
-- TUREPORTS  (Table) 
--
CREATE TABLE ASU.TUREPORTS
(
  FK_ID          NUMBER(9)                      DEFAULT -1,
  FC_NAME        VARCHAR2(200 BYTE),
  FK_TYPE        NUMBER(1)                      DEFAULT 0,
  FK_PERIOD      NUMBER(1)                      DEFAULT 0,
  FL_SETKA       NUMBER(1)                      DEFAULT 0,
  FL_NULS        NUMBER(1)                      DEFAULT 0,
  FK_DIVIDE      NUMBER(1),
  FL_OUT         NUMBER(1)                      DEFAULT 0,
  FK_BEFORETEXT  NUMBER(9)                      DEFAULT -1,
  FK_AFTERTEXT   NUMBER(9)                      DEFAULT -1
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

COMMENT ON TABLE ASU.TUREPORTS IS '������� ������������� �������'
/

COMMENT ON COLUMN ASU.TUREPORTS.FK_ID IS 'SEQUENCE=[SEQ_TUREPORTS]'
/

COMMENT ON COLUMN ASU.TUREPORTS.FC_NAME IS '������������'
/

COMMENT ON COLUMN ASU.TUREPORTS.FK_TYPE IS '��� ������'
/

COMMENT ON COLUMN ASU.TUREPORTS.FK_PERIOD IS '������'
/

COMMENT ON COLUMN ASU.TUREPORTS.FL_SETKA IS '���������� ����� ��� ���'
/

COMMENT ON COLUMN ASU.TUREPORTS.FL_NULS IS '���������� 0 ��� ���'
/

COMMENT ON COLUMN ASU.TUREPORTS.FK_DIVIDE IS '������������� (0 - �� �������� ��������, 1 - �� �����������, 2 - �� ��������� ���������, 3 - �� �������������)'
/

COMMENT ON COLUMN ASU.TUREPORTS.FL_OUT IS '�������� �� �������� ��� ���'
/

COMMENT ON COLUMN ASU.TUREPORTS.FK_BEFORETEXT IS '����� ����� ������� TCLOBS->FK_ID'
/

COMMENT ON COLUMN ASU.TUREPORTS.FK_AFTERTEXT IS '����� ����� ������ TCLOBS->FK_ID'
/


--
-- TUREPORTS_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TUREPORTS (Table)
--
CREATE OR REPLACE TRIGGER ASU."TUREPORTS_BEFORE_INSERT" 
BEFORE  INSERT  ON ASU.TUREPORTS REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
Begin
  SELECT SEQ_TUREPORTS.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
  INSERT INTO TURCELLS (FK_REPORTID,FN_ROW,FN_COL) VALUES (:NEW.FK_ID,0,0);
End;
/
SHOW ERRORS;


--
-- TUREPORTS_AFTER_DELETE  (Trigger) 
--
--  Dependencies: 
--   TUREPORTS (Table)
--
CREATE OR REPLACE TRIGGER ASU."TUREPORTS_AFTER_DELETE" 
BEFORE  DELETE  ON ASU.TUREPORTS REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
Begin
  DELETE FROM TURCELLS WHERE FK_REPORTID=:OLD.FK_ID;
  DELETE FROM TCLOBS WHERE FK_ID=:OLD.FK_BEFORETEXT;
  DELETE FROM TCLOBS WHERE FK_ID=:OLD.FK_AFTERTEXT;
End;
/
SHOW ERRORS;


