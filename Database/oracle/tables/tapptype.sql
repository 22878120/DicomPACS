DROP TABLE ASU.TAPPTYPE CASCADE CONSTRAINTS
/

--
-- TAPPTYPE  (Table) 
--
CREATE TABLE ASU.TAPPTYPE
(
  FK_ID    NUMBER(9)                            NOT NULL,
  FC_NAME  VARCHAR2(100 BYTE)                   NOT NULL
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

COMMENT ON TABLE ASU.TAPPTYPE IS '���������� ����� ������ by TimurLan'
/

COMMENT ON COLUMN ASU.TAPPTYPE.FK_ID IS 'SEQUENCE=[SEQ_TAPPTYPE]'
/

COMMENT ON COLUMN ASU.TAPPTYPE.FC_NAME IS '��������'
/


--
-- TAPPTYPE_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TAPPTYPE (Table)
--
CREATE OR REPLACE TRIGGER ASU."TAPPTYPE_BEFORE_INSERT" BEFORE INSERT ON ASU.TAPPTYPE REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
Begin SELECT SEQ_TAPPTYPE.NEXTVAL INTO :NEW.FK_ID FROM DUAL; End;
/
SHOW ERRORS;


