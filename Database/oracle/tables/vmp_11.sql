ALTER TABLE ASU.VMP_11
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.VMP_11 CASCADE CONSTRAINTS
/

--
-- VMP_11  (Table) 
--
CREATE TABLE ASU.VMP_11
(
  FK_ID       NUMBER,
  FK_PERESEL  VARCHAR2(15 BYTE),
  VID_VME     VARCHAR2(15 BYTE),
  VID_HMP     VARCHAR2(15 BYTE),
  METOD_HMP   VARCHAR2(15 BYTE),
  CODE_USL    VARCHAR2(15 BYTE),
  TARIF       NUMBER(15,2),
  PROFIL      NUMBER(9)
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

COMMENT ON TABLE ASU.VMP_11 IS '������� ������� ������������� � ���������� �������� DBF'
/

COMMENT ON COLUMN ASU.VMP_11.FK_ID IS 'ASU.SEQ_VMP_11'
/


--
-- K_VMP_11_ID  (Index) 
--
--  Dependencies: 
--   VMP_11 (Table)
--
CREATE UNIQUE INDEX ASU.K_VMP_11_ID ON ASU.VMP_11
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
-- VMP_11_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   VMP_11 (Table)
--
CREATE OR REPLACE TRIGGER ASU.VMP_11_BEFORE_INSERT
  BEFORE INSERT
  ON ASU.VMP_11   REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
BEGIN
  SELECT ASU.SEQ_VMP_11.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table VMP_11 
-- 
ALTER TABLE ASU.VMP_11 ADD (
  CONSTRAINT K_VMP_11_ID
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

