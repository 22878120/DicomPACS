DROP TABLE ASU.TPAC_FAMILY CASCADE CONSTRAINTS
/

--
-- TPAC_FAMILY  (Table) 
--
CREATE TABLE ASU.TPAC_FAMILY
(
  FK_ID           NUMBER                        NOT NULL,
  FK_PEOPLID      NUMBER,
  FK_LEVEL        NUMBER,
  FN_FAMILYGROUP  NUMBER,
  FK_KARTA        NUMBER
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
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE ASU.TPAC_FAMILY IS '������� ����������� ������ ���������.
������� 02.10.2006 ��������� �.�.'
/

COMMENT ON COLUMN ASU.TPAC_FAMILY.FK_ID IS 'SEQUENCE=[SEQ_TPAC_FAMILY]'
/

COMMENT ON COLUMN ASU.TPAC_FAMILY.FK_PEOPLID IS '������� ������ �� TPeoples'
/

COMMENT ON COLUMN ASU.TPAC_FAMILY.FK_LEVEL IS '������� �������'
/

COMMENT ON COLUMN ASU.TPAC_FAMILY.FN_FAMILYGROUP IS '�������������� ������ �����'
/

COMMENT ON COLUMN ASU.TPAC_FAMILY.FK_KARTA IS '������ �� ����� ����'
/


--
-- TPAC_FAMILY_BY_GROUPPEOPLE  (Index) 
--
--  Dependencies: 
--   TPAC_FAMILY (Table)
--
CREATE INDEX ASU.TPAC_FAMILY_BY_GROUPPEOPLE ON ASU.TPAC_FAMILY
(FK_PEOPLID, FN_FAMILYGROUP)
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
-- TPAC_FAMILY_BY_PEOPLID  (Index) 
--
--  Dependencies: 
--   TPAC_FAMILY (Table)
--
CREATE INDEX ASU.TPAC_FAMILY_BY_PEOPLID ON ASU.TPAC_FAMILY
(FK_PEOPLID)
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
-- TPAC_FAMILY_INSERT  (Trigger) 
--
--  Dependencies: 
--   TPAC_FAMILY (Table)
--
CREATE OR REPLACE TRIGGER ASU."TPAC_FAMILY_INSERT" 
 BEFORE
  INSERT
 ON asu.tpac_family
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
Begin
  SELECT SEQ_TPAC_FAMILY.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;

