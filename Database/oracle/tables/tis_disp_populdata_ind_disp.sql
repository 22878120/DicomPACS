ALTER TABLE ASU.TIS_DISP_POPULDATA_IND_DISP
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TIS_DISP_POPULDATA_IND_DISP CASCADE CONSTRAINTS
/

--
-- TIS_DISP_POPULDATA_IND_DISP  (Table) 
--
--  Dependencies: 
--   TIS_DISP_POPULDATA_INDICATOR (Table)
--
CREATE TABLE ASU.TIS_DISP_POPULDATA_IND_DISP
(
  FK_ID                        NUMBER           NOT NULL,
  FC_SOCIALSTATUSCODEID        VARCHAR2(64 BYTE),
  FL_SOCIALHELP                NUMBER(1),
  FC_CATEGORYCODEID            VARCHAR2(64 BYTE),
  FC_CITYVILLAGEID             VARCHAR2(64 BYTE),
  FN_PEOPLECOUNT               NUMBER,
  FK_IS_DISP_POPULDATA_IND_ID  NUMBER
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

COMMENT ON TABLE ASU.TIS_DISP_POPULDATA_IND_DISP IS '��������������� ������ � ���������'
/


--
-- PK_TIS_DISP_POPULDATA_IND_DISP  (Index) 
--
--  Dependencies: 
--   TIS_DISP_POPULDATA_IND_DISP (Table)
--
CREATE UNIQUE INDEX ASU.PK_TIS_DISP_POPULDATA_IND_DISP ON ASU.TIS_DISP_POPULDATA_IND_DISP
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
-- TIS_DISP_POPULDATA_IND_DISP_BI  (Trigger) 
--
--  Dependencies: 
--   TIS_DISP_POPULDATA_IND_DISP (Table)
--
CREATE OR REPLACE TRIGGER ASU.TIS_DISP_POPULDATA_IND_DISP_BI
  BEFORE INSERT
  ON ASU.TIS_DISP_POPULDATA_IND_DISP   REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
BEGIN
  IF :NEW.fk_id IS NULL
  THEN
    SELECT asu.seq_TIS_DISP_POPULDATA_IND_DIS.NEXTVAL
      INTO :NEW.fk_id
      FROM DUAL;
  END IF;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TIS_DISP_POPULDATA_IND_DISP 
-- 
ALTER TABLE ASU.TIS_DISP_POPULDATA_IND_DISP ADD (
  CONSTRAINT PK_TIS_DISP_POPULDATA_IND_DISP
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
-- Foreign Key Constraints for Table TIS_DISP_POPULDATA_IND_DISP 
-- 
ALTER TABLE ASU.TIS_DISP_POPULDATA_IND_DISP ADD (
  CONSTRAINT FK_TIS_DISP_REFERENCE_TIS_DIS3 
 FOREIGN KEY (FK_IS_DISP_POPULDATA_IND_ID) 
 REFERENCES ASU.TIS_DISP_POPULDATA_INDICATOR (FK_ID))
/

