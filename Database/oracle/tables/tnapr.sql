DROP TABLE ASU.TNAPR CASCADE CONSTRAINTS
/

--
-- TNAPR  (Table) 
--
CREATE TABLE ASU.TNAPR
(
  FK_ID       NUMBER(9)                         DEFAULT -1                    NOT NULL,
  FC_NAME     VARCHAR2(30 BYTE),
  FC_SHORT    VARCHAR2(10 BYTE),
  FL_DEFAULT  NUMBER(1)                         DEFAULT 0,
  FN_ORDER    NUMBER(3)
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

COMMENT ON TABLE ASU.TNAPR IS '���������� ����������� �� ������������ ������������'
/

COMMENT ON COLUMN ASU.TNAPR.FK_ID IS 'SEQUENCE=[SEQ_TNAPR]'
/

COMMENT ON COLUMN ASU.TNAPR.FC_NAME IS '��������'
/

COMMENT ON COLUMN ASU.TNAPR.FC_SHORT IS '��������'
/

COMMENT ON COLUMN ASU.TNAPR.FL_DEFAULT IS '�� ���������?'
/

COMMENT ON COLUMN ASU.TNAPR.FN_ORDER IS '�������'
/


--
-- TNAPR_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TNAPR (Table)
--
CREATE OR REPLACE TRIGGER ASU."TNAPR_BEFORE_INSERT" 
BEFORE  INSERT  ON ASU.TNAPR REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
Begin
  SELECT SEQ_TNAPR.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;


