ALTER TABLE ASU.TIS_DISP_POPULDATA
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TIS_DISP_POPULDATA CASCADE CONSTRAINTS
/

--
-- TIS_DISP_POPULDATA  (Table) 
--
--  Dependencies: 
--   TIS_DISP (Table)
--
CREATE TABLE ASU.TIS_DISP_POPULDATA
(
  FK_ID          NUMBER                         NOT NULL,
  FN_AGE         NUMBER,
  FK_SEXID       NUMBER,
  FK_IS_DISP_ID  NUMBER
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

COMMENT ON TABLE ASU.TIS_DISP_POPULDATA IS '���������������
'
/


--
-- PK_TIS_DISP_POPULDATA  (Index) 
--
--  Dependencies: 
--   TIS_DISP_POPULDATA (Table)
--
CREATE UNIQUE INDEX ASU.PK_TIS_DISP_POPULDATA ON ASU.TIS_DISP_POPULDATA
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
-- TIS_DISP_POPULDATA_BI  (Trigger) 
--
--  Dependencies: 
--   TIS_DISP_POPULDATA (Table)
--
CREATE OR REPLACE TRIGGER ASU.TIS_DISP_POPULDATA_BI
  BEFORE INSERT
  ON ASU.TIS_DISP_POPULDATA   REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
BEGIN
  IF :NEW.fk_id IS NULL
  THEN
    SELECT asu.seq_TIS_DISP_POPULDATA.NEXTVAL
      INTO :NEW.fk_id
      FROM DUAL;
  END IF;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TIS_DISP_POPULDATA 
-- 
ALTER TABLE ASU.TIS_DISP_POPULDATA ADD (
  CONSTRAINT PK_TIS_DISP_POPULDATA
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
-- Foreign Key Constraints for Table TIS_DISP_POPULDATA 
-- 
ALTER TABLE ASU.TIS_DISP_POPULDATA ADD (
  CONSTRAINT FK_TIS_DISP_REFERENCE_TIS_DIS2 
 FOREIGN KEY (FK_IS_DISP_ID) 
 REFERENCES ASU.TIS_DISP (FK_ID))
/
