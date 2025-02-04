DROP TABLE ASU.TQCDAILYMEEN CASCADE CONSTRAINTS
/

--
-- TQCDAILYMEEN  (Table) 
--
CREATE TABLE ASU.TQCDAILYMEEN
(
  FK_ID       NUMBER(9)                         DEFAULT -1                    NOT NULL,
  FN_VALUE    NUMBER(9,4)                       DEFAULT 0,
  FK_SMID     NUMBER(9)                         DEFAULT -1,
  FD_DATE     DATE,
  FC_COMMENT  VARCHAR2(4000 BYTE),
  FK_FIXID    NUMBER(9)                         DEFAULT -1
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

COMMENT ON TABLE ASU.TQCDAILYMEEN IS '������� ��� �������� ������ �� ���������'
/

COMMENT ON COLUMN ASU.TQCDAILYMEEN.FK_ID IS 'SEQUENCE=[SEQ_TQCDAILYMEEN]'
/

COMMENT ON COLUMN ASU.TQCDAILYMEEN.FN_VALUE IS '�������� ��������'
/

COMMENT ON COLUMN ASU.TQCDAILYMEEN.FK_SMID IS '��� �� ����'
/

COMMENT ON COLUMN ASU.TQCDAILYMEEN.FD_DATE IS '���� ���������� ��������'
/

COMMENT ON COLUMN ASU.TQCDAILYMEEN.FC_COMMENT IS '�����������'
/

COMMENT ON COLUMN ASU.TQCDAILYMEEN.FK_FIXID IS '��� ������������'
/


--
-- TQCDAILYMEEN_BY_DATE  (Index) 
--
--  Dependencies: 
--   TQCDAILYMEEN (Table)
--
CREATE INDEX ASU.TQCDAILYMEEN_BY_DATE ON ASU.TQCDAILYMEEN
(FD_DATE)
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
-- TQCDAILYMEEN_BY_DATE_SMID  (Index) 
--
--  Dependencies: 
--   TQCDAILYMEEN (Table)
--
CREATE UNIQUE INDEX ASU.TQCDAILYMEEN_BY_DATE_SMID ON ASU.TQCDAILYMEEN
(FD_DATE, FK_SMID)
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
-- TQCDAILYMEEN_BY_ID  (Index) 
--
--  Dependencies: 
--   TQCDAILYMEEN (Table)
--
CREATE UNIQUE INDEX ASU.TQCDAILYMEEN_BY_ID ON ASU.TQCDAILYMEEN
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
-- TQCDAILYMEEN_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TQCDAILYMEEN (Table)
--
CREATE OR REPLACE TRIGGER ASU."TQCDAILYMEEN_BEFORE_INSERT" 
BEFORE INSERT
ON ASU.TQCDAILYMEEN REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
Begin
  SELECT SEQ_TQCDAILYMEEN.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;


--
-- TQCDAILYMEEN_AFTER_INSERT  (Trigger) 
--
--  Dependencies: 
--   TQCDAILYMEEN (Table)
--
CREATE OR REPLACE TRIGGER ASU."TQCDAILYMEEN_AFTER_INSERT" 
AFTER INSERT
ON ASU.TQCDAILYMEEN 
Begin
  DELETE FROM TQCDAILYMEEN WHERE FK_SMID=-1;
End;
/
SHOW ERRORS;


