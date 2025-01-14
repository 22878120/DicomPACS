ALTER TABLE ASU.TNAPRAVLECH
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TNAPRAVLECH CASCADE CONSTRAINTS
/

--
-- TNAPRAVLECH  (Table) 
--
CREATE TABLE ASU.TNAPRAVLECH
(
  FK_ID      NUMBER                             NOT NULL,
  FK_TYPE    NUMBER                             NOT NULL,
  FD_DATE    DATE                               NOT NULL,
  FK_PEPLID  NUMBER                             NOT NULL,
  FK_SOTRID  NUMBER                             NOT NULL
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

COMMENT ON TABLE ASU.TNAPRAVLECH IS '������ �������� ����������� �� ������ ���� ������� -- Galtsev I.A. 25/06/2010'
/

COMMENT ON COLUMN ASU.TNAPRAVLECH.FK_ID IS 'SEQUENCE=[SEQ_TNAPRAVLECH]'
/

COMMENT ON COLUMN ASU.TNAPRAVLECH.FK_TYPE IS '��� ������� =TSMID.FK_D (TSMID.FK_OWNER= ASU.GET_SYNID(''LECH_TYPE''))'
/

COMMENT ON COLUMN ASU.TNAPRAVLECH.FD_DATE IS '���� ������ �����������'
/

COMMENT ON COLUMN ASU.TNAPRAVLECH.FK_PEPLID IS 'ID �������� = TPEOPLES.FK_ID'
/

COMMENT ON COLUMN ASU.TNAPRAVLECH.FK_SOTRID IS 'ID ���������� ���������� ������= TSOTR.FK_ID'
/


--
-- TNAPRAVLECH_PAC_TYPE  (Index) 
--
--  Dependencies: 
--   TNAPRAVLECH (Table)
--
CREATE INDEX ASU.TNAPRAVLECH_PAC_TYPE ON ASU.TNAPRAVLECH
(FK_PEPLID, FK_TYPE, FD_DATE)
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
-- TNAPRAVLECH_PK  (Index) 
--
--  Dependencies: 
--   TNAPRAVLECH (Table)
--
CREATE UNIQUE INDEX ASU.TNAPRAVLECH_PK ON ASU.TNAPRAVLECH
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
-- TNAPRAVLECH_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TNAPRAVLECH (Table)
--
CREATE OR REPLACE TRIGGER ASU."TNAPRAVLECH_BEFORE_INSERT" 
 BEFORE INSERT ON ASU.TNAPRAVLECH  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
 IF :NEW.FK_ID IS NULL THEN
  SELECT ASU.SEQ_TNAPRAVLECH.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
 END IF;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TNAPRAVLECH 
-- 
ALTER TABLE ASU.TNAPRAVLECH ADD (
  CONSTRAINT TNAPRAVLECH_PK
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
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
               ))
/

