ALTER TABLE ASU.TVACCIN_SHEMNAME
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TVACCIN_SHEMNAME CASCADE CONSTRAINTS
/

--
-- TVACCIN_SHEMNAME  (Table) 
--
--  Dependencies: 
--   TVACCIN_PREP (Table)
--
CREATE TABLE ASU.TVACCIN_SHEMNAME
(
  FK_ID       INTEGER                           NOT NULL,
  FC_NAME     VARCHAR2(150 BYTE)                NOT NULL,
  FC_REM      VARCHAR2(4000 BYTE),
  FK_VACPREP  INTEGER                           NOT NULL
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
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE ASU.TVACCIN_SHEMNAME IS '����� ���������� (��������)
Author: Ura'
/

COMMENT ON COLUMN ASU.TVACCIN_SHEMNAME.FK_ID IS 'SEQUENCE=[SEQ_VACCIN_SHEMNAME]'
/

COMMENT ON COLUMN ASU.TVACCIN_SHEMNAME.FC_NAME IS '��������'
/

COMMENT ON COLUMN ASU.TVACCIN_SHEMNAME.FC_REM IS '��������'
/

COMMENT ON COLUMN ASU.TVACCIN_SHEMNAME.FK_VACPREP IS 'TVACCIN_PREP.FK_ID'
/


--
-- IX_TVACCIN_SHEMNAME$FK_VACPREP  (Index) 
--
--  Dependencies: 
--   TVACCIN_SHEMNAME (Table)
--
CREATE INDEX ASU.IX_TVACCIN_SHEMNAME$FK_VACPREP ON ASU.TVACCIN_SHEMNAME
(FK_VACPREP)
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
-- PK_TVACCIN_SHEMNAME  (Index) 
--
--  Dependencies: 
--   TVACCIN_SHEMNAME (Table)
--
CREATE UNIQUE INDEX ASU.PK_TVACCIN_SHEMNAME ON ASU.TVACCIN_SHEMNAME
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
-- TVACCIN_SHEMNAME_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TVACCIN_SHEMNAME (Table)
--
CREATE OR REPLACE TRIGGER ASU."TVACCIN_SHEMNAME_BEFORE_INSERT" BEFORE INSERT
ON ASU.TVACCIN_SHEMNAME FOR EACH ROW
begin
    --  Column "FK_ID" uses sequence SEQ_VACCIN_SHEMNAME
      IF :NEW.FK_ID IS NULL
      THEN
         SELECT SEQ_VACCIN_SHEMNAME.NEXTVAL INTO :NEW.FK_ID from dual;
      END IF;
end;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TVACCIN_SHEMNAME 
-- 
ALTER TABLE ASU.TVACCIN_SHEMNAME ADD (
  CONSTRAINT PK_TVACCIN_SHEMNAME
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
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
               ))
/

-- 
-- Foreign Key Constraints for Table TVACCIN_SHEMNAME 
-- 
ALTER TABLE ASU.TVACCIN_SHEMNAME ADD (
  CONSTRAINT FK_TVACCIN_SHEM$TVACCIN_PREP 
 FOREIGN KEY (FK_VACPREP) 
 REFERENCES ASU.TVACCIN_PREP (FK_ID))
/

