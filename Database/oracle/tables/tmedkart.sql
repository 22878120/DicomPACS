DROP TABLE ASU.TMEDKART CASCADE CONSTRAINTS
/

--
-- TMEDKART  (Table) 
--
CREATE TABLE ASU.TMEDKART
(
  FK_ID             NUMBER(9)                   NOT NULL,
  FC_NAME           VARCHAR2(255 BYTE),
  FK_MEDICID        NUMBER(9)                   NOT NULL,
  FC_COMMENT        VARCHAR2(300 BYTE),
  FK_APOSTAVSHIKID  NUMBER(9),
  FD_GODEN          DATE,
  FC_SERIAL         VARCHAR2(200 BYTE),
  FL_DEL            NUMBER(1)                   DEFAULT 0                     NOT NULL
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          280K
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

COMMENT ON TABLE ASU.TMEDKART IS '������ �������� ������������'
/

COMMENT ON COLUMN ASU.TMEDKART.FK_ID IS 'SEQUENCE=[SEQ_TMEDKART]'
/

COMMENT ON COLUMN ASU.TMEDKART.FC_NAME IS '��� ��������'
/

COMMENT ON COLUMN ASU.TMEDKART.FK_MEDICID IS '��� ����������� � �������� ����������� ��� ��������'
/

COMMENT ON COLUMN ASU.TMEDKART.FC_COMMENT IS '�����������'
/

COMMENT ON COLUMN ASU.TMEDKART.FK_APOSTAVSHIKID IS '�������� ��������'
/

COMMENT ON COLUMN ASU.TMEDKART.FD_GODEN IS '���� �������� �����������'
/

COMMENT ON COLUMN ASU.TMEDKART.FC_SERIAL IS '�������� �����'
/

COMMENT ON COLUMN ASU.TMEDKART.FL_DEL IS '������� ��������'
/


--
-- TMEDKART$ID  (Index) 
--
--  Dependencies: 
--   TMEDKART (Table)
--
CREATE UNIQUE INDEX ASU.TMEDKART$ID ON ASU.TMEDKART
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
-- TMEDKART$MEDICID  (Index) 
--
--  Dependencies: 
--   TMEDKART (Table)
--
CREATE INDEX ASU.TMEDKART$MEDICID ON ASU.TMEDKART
(FK_MEDICID)
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
-- TMEDKART$POSTAVSHIKID  (Index) 
--
--  Dependencies: 
--   TMEDKART (Table)
--
CREATE INDEX ASU.TMEDKART$POSTAVSHIKID ON ASU.TMEDKART
(FK_APOSTAVSHIKID)
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
-- TMEDKART_BIO$GODEN  (Trigger) 
--
--  Dependencies: 
--   TMEDKART (Table)
--
CREATE OR REPLACE TRIGGER ASU."TMEDKART_BIO$GODEN" 
BEFORE INSERT OR UPDATE OF FD_GODEN
ON ASU.TMEDKART REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  :new.fd_goden := TRUNC (:new.fd_goden);
END;
/
SHOW ERRORS;


--
-- TMEDKART$INS  (Trigger) 
--
--  Dependencies: 
--   TMEDKART (Table)
--
CREATE OR REPLACE TRIGGER ASU."TMEDKART$INS" 
BEFORE INSERT
ON ASU.TMEDKART REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
Begin
  select seq_TMEDKART.nextval into :new.fk_id from dual;
End;
/
SHOW ERRORS;


--
-- TMEDKART$DEL  (Trigger) 
--
--  Dependencies: 
--   TMEDKART (Table)
--
CREATE OR REPLACE TRIGGER ASU."TMEDKART$DEL" 
AFTER  DELETE  ON ASU.TMEDKART REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
BEGIN
  DELETE
    FROM taprihcont
   WHERE fk_medkartid = :old.fk_id;
END;
/
SHOW ERRORS;

