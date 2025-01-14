ALTER TABLE ASU.TPHYSIOTHERAPY_MAPS
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TPHYSIOTHERAPY_MAPS CASCADE CONSTRAINTS
/

--
-- TPHYSIOTHERAPY_MAPS  (Table) 
--
CREATE TABLE ASU.TPHYSIOTHERAPY_MAPS
(
  FK_ID         NUMBER                          NOT NULL,
  FK_SENSOR_ID  NUMBER                          NOT NULL,
  FK_AREA_ID    NUMBER                          NOT NULL
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
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE ASU.TPHYSIOTHERAPY_MAPS IS '������������� ��� ��������� �������������������� ���� ����������. Author: rca'
/

COMMENT ON COLUMN ASU.TPHYSIOTHERAPY_MAPS.FK_ID IS '���������� �������������'
/

COMMENT ON COLUMN ASU.TPHYSIOTHERAPY_MAPS.FK_SENSOR_ID IS '������������� ������� �������'
/

COMMENT ON COLUMN ASU.TPHYSIOTHERAPY_MAPS.FK_AREA_ID IS '������������� ������� ����������'
/


--
-- PK_TPHYSIOTHERAPY_MAPS  (Index) 
--
--  Dependencies: 
--   TPHYSIOTHERAPY_MAPS (Table)
--
CREATE UNIQUE INDEX ASU.PK_TPHYSIOTHERAPY_MAPS ON ASU.TPHYSIOTHERAPY_MAPS
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
-- TPHYSIOTHERAPY_MAPS$BI  (Trigger) 
--
--  Dependencies: 
--   TPHYSIOTHERAPY_MAPS (Table)
--
CREATE OR REPLACE TRIGGER ASU."TPHYSIOTHERAPY_MAPS$BI" 
 BEFORE
  INSERT
 ON asu.tphysiotherapy_maps
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  --  Column "FK_ID" uses sequence SEQ_TPHYSIOTHERAPY_MAPS
  SELECT SEQ_TPHYSIOTHERAPY_MAPS.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TPHYSIOTHERAPY_MAPS 
-- 
ALTER TABLE ASU.TPHYSIOTHERAPY_MAPS ADD (
  CONSTRAINT PK_TPHYSIOTHERAPY_MAPS
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

