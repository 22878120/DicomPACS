ALTER TABLE ASU.TFUS_SMIDLPU
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TFUS_SMIDLPU CASCADE CONSTRAINTS
/

--
-- TFUS_SMIDLPU  (Table) 
--
--  Dependencies: 
--   TFUS_SMID (Table)
--
CREATE TABLE ASU.TFUS_SMIDLPU
(
  FK_ID       NUMBER,
  FK_SMID     NUMBER,
  FK_FUSSMID  NUMBER,
  FK_LPU      NUMBER
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

COMMENT ON TABLE ASU.TFUS_SMIDLPU IS '������������ ����� ������ ��� � ������ ���������������'
/

COMMENT ON COLUMN ASU.TFUS_SMIDLPU.FK_SMID IS 'TSMID.FK_ID'
/

COMMENT ON COLUMN ASU.TFUS_SMIDLPU.FK_FUSSMID IS 'TFUS_SMID.FK_ID'
/

COMMENT ON COLUMN ASU.TFUS_SMIDLPU.FK_LPU IS 'TCOMPANY.FK_ID'
/


--
-- PK_TFUS_SMIDLPU  (Index) 
--
--  Dependencies: 
--   TFUS_SMIDLPU (Table)
--
CREATE UNIQUE INDEX ASU.PK_TFUS_SMIDLPU ON ASU.TFUS_SMIDLPU
(FK_ID)
NOLOGGING
TABLESPACE USR
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
-- TFUS_SMIDLPU_BEFORE_INS  (Trigger) 
--
--  Dependencies: 
--   TFUS_SMIDLPU (Table)
--
CREATE OR REPLACE TRIGGER ASU."TFUS_SMIDLPU_BEFORE_INS" 
 BEFORE
 INSERT
 ON ASU.TFUS_SMIDLPU  REFERENCING OLD AS old NEW AS new
 FOR EACH ROW
BEGIN
 SELECT SEQ_TFUS_SMIDLPU.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TFUS_SMIDLPU 
-- 
ALTER TABLE ASU.TFUS_SMIDLPU ADD (
  CONSTRAINT PK_TFUS_SMIDLPU
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
    TABLESPACE USR
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

-- 
-- Foreign Key Constraints for Table TFUS_SMIDLPU 
-- 
ALTER TABLE ASU.TFUS_SMIDLPU ADD (
  CONSTRAINT TFUS_SMIDLPU_FK_FUSSMID 
 FOREIGN KEY (FK_FUSSMID) 
 REFERENCES ASU.TFUS_SMID (FK_ID))
/

