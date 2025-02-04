ALTER TABLE ASU.TUSL_RENTAB
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TUSL_RENTAB CASCADE CONSTRAINTS
/

--
-- TUSL_RENTAB  (Table) 
--
CREATE TABLE ASU.TUSL_RENTAB
(
  FK_ID       INTEGER                           DEFAULT -1                    NOT NULL,
  FK_HEALID   INTEGER,
  FN_PROC     NUMBER(22,4),
  FC_NAME     VARCHAR2(40 BYTE),
  FC_FORMULA  VARCHAR2(4000 BYTE)
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

COMMENT ON TABLE ASU.TUSL_RENTAB IS '�������� ������� ��������� �����'
/

COMMENT ON COLUMN ASU.TUSL_RENTAB.FK_HEALID IS '������ �� ������ � THAEL'
/

COMMENT ON COLUMN ASU.TUSL_RENTAB.FN_PROC IS '���-�� ��������� �������� ������'
/

COMMENT ON COLUMN ASU.TUSL_RENTAB.FC_NAME IS '������������ �������� ������� ��������������'
/


--
-- TUSL_RENTAB_FK_ID  (Index) 
--
--  Dependencies: 
--   TUSL_RENTAB (Table)
--
CREATE UNIQUE INDEX ASU.TUSL_RENTAB_FK_ID ON ASU.TUSL_RENTAB
(FK_ID)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TUSL_RENTAB_HEALID  (Index) 
--
--  Dependencies: 
--   TUSL_RENTAB (Table)
--
CREATE INDEX ASU.TUSL_RENTAB_HEALID ON ASU.TUSL_RENTAB
(FK_HEALID)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TUSL_RENTAB_BEFORE_INS  (Trigger) 
--
--  Dependencies: 
--   TUSL_RENTAB (Table)
--
CREATE OR REPLACE TRIGGER ASU."TUSL_RENTAB_BEFORE_INS" 
 BEFORE
  INSERT
 ON tusl_rentab
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
Begin
  SELECT SEQ_tusl_rentab.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TUSL_RENTAB 
-- 
ALTER TABLE ASU.TUSL_RENTAB ADD (
  CONSTRAINT PK_TUSL_RENTAB
 PRIMARY KEY
 (FK_ID))
/

