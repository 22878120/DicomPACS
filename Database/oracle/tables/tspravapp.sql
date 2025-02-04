DROP TABLE ASU.TSPRAVAPP CASCADE CONSTRAINTS
/

--
-- TSPRAVAPP  (Table) 
--
CREATE TABLE ASU.TSPRAVAPP
(
  FK_ID          NUMBER(15),
  FK_ASUID       NUMBER(15),
  FK_SPRAVAPPID  NUMBER(15)
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

COMMENT ON TABLE ASU.TSPRAVAPP IS '����������� ������������ �� ������������ by TimurLan'
/

COMMENT ON COLUMN ASU.TSPRAVAPP.FK_ID IS 'SEQUENCE=[SEQ_TSPRAVAPP]'
/

COMMENT ON COLUMN ASU.TSPRAVAPP.FK_ASUID IS '���� �������� �������������� ����������'
/

COMMENT ON COLUMN ASU.TSPRAVAPP.FK_SPRAVAPPID IS '���� ������� ��������� � �������� ����������'
/


--
-- TSPRAVAPP_INSERT  (Trigger) 
--
--  Dependencies: 
--   TSPRAVAPP (Table)
--
CREATE OR REPLACE TRIGGER ASU."TSPRAVAPP_INSERT" 
BEFORE INSERT
ON tspravapp
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Begin
  SELECT seq_tspravapp.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;


