DROP TABLE ASU.TROOMTYPEPARAM CASCADE CONSTRAINTS
/

--
-- TROOMTYPEPARAM  (Table) 
--
CREATE TABLE ASU.TROOMTYPEPARAM
(
  FK_ID     NUMBER                              NOT NULL,
  FC_NAME   VARCHAR2(128 BYTE),
  FC_SHORT  VARCHAR2(32 BYTE),
  FC_EI     VARCHAR2(32 BYTE),
  FN_ORDER  NUMBER,
  FL_DEL    NUMBER(1)
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

COMMENT ON COLUMN ASU.TROOMTYPEPARAM.FC_NAME IS '��������'
/

COMMENT ON COLUMN ASU.TROOMTYPEPARAM.FC_SHORT IS '�������� ��������'
/

COMMENT ON COLUMN ASU.TROOMTYPEPARAM.FC_EI IS '��. ���.'
/

COMMENT ON COLUMN ASU.TROOMTYPEPARAM.FN_ORDER IS '�������'
/

COMMENT ON COLUMN ASU.TROOMTYPEPARAM.FL_DEL IS '���� ��������'
/


--
-- "Troomtypeparam_BEFORE_INSERT"  (Trigger) 
--
--  Dependencies: 
--   TROOMTYPEPARAM (Table)
--
CREATE OR REPLACE TRIGGER ASU."Troomtypeparam_BEFORE_INSERT" 
BEFORE INSERT
ON ASU.Troomtypeparam
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  SELECT asu.Seq_Troomtypeparam.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;


--
-- TROOMTYPEPARAM_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TROOMTYPEPARAM (Table)
--
CREATE OR REPLACE TRIGGER ASU.Troomtypeparam_BEFORE_INSERT
BEFORE INSERT
ON ASU.TROOMTYPEPARAM REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  SELECT asu.Seq_Troomtypeparam.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;


