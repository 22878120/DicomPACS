ALTER TABLE ASU.TRECIPE_DLO_PAC_ADRPREB
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TRECIPE_DLO_PAC_ADRPREB CASCADE CONSTRAINTS
/

--
-- TRECIPE_DLO_PAC_ADRPREB  (Table) 
--
--  Dependencies: 
--   TRECIPE_DLO_REG_PAC (Table)
--
CREATE TABLE ASU.TRECIPE_DLO_PAC_ADRPREB
(
  FK_ID        NUMBER,
  FK_REGPACID  NUMBER,
  FK_LPU       NUMBER,
  FD_DATA      DATE,
  DADRPREB     VARCHAR2(100 BYTE)
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

COMMENT ON TABLE ASU.TRECIPE_DLO_PAC_ADRPREB IS '���. ������������ ������� ����������. ���� ������ �� ������� ���������� ���������'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_PAC_ADRPREB.FK_ID IS '����'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_PAC_ADRPREB.FK_REGPACID IS '������ �� ���������'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_PAC_ADRPREB.FK_LPU IS '��� ���'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_PAC_ADRPREB.FD_DATA IS '���� �����'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_PAC_ADRPREB.DADRPREB IS '�������������� ����� ����������'
/


--
-- TRECIPE_DLO_PAC_ADRPREB_IDX  (Index) 
--
--  Dependencies: 
--   TRECIPE_DLO_PAC_ADRPREB (Table)
--
CREATE INDEX ASU.TRECIPE_DLO_PAC_ADRPREB_IDX ON ASU.TRECIPE_DLO_PAC_ADRPREB
(FK_REGPACID, FK_LPU)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TRECIPE_DLO_PAC_ADRPREB_PK  (Index) 
--
--  Dependencies: 
--   TRECIPE_DLO_PAC_ADRPREB (Table)
--
CREATE UNIQUE INDEX ASU.TRECIPE_DLO_PAC_ADRPREB_PK ON ASU.TRECIPE_DLO_PAC_ADRPREB
(FK_ID)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TRECIPE_DLO_PAC_ADRPREB_INS  (Trigger) 
--
--  Dependencies: 
--   TRECIPE_DLO_PAC_ADRPREB (Table)
--
CREATE OR REPLACE TRIGGER ASU."TRECIPE_DLO_PAC_ADRPREB_INS"
 BEFORE
  INSERT
 ON ASU.TRECIPE_DLO_PAC_ADRPREB REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
begin
  if (:new.fk_id is null) then
    select ASU.SEQ_TRECIPE_DLO_PAC_ADRPREB.nextval into :new.fk_id from dual;
  end if;
end;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TRECIPE_DLO_PAC_ADRPREB 
-- 
ALTER TABLE ASU.TRECIPE_DLO_PAC_ADRPREB ADD (
  CONSTRAINT TRECIPE_DLO_PAC_ADRPREB_PK
 PRIMARY KEY
 (FK_ID))
/

-- 
-- Foreign Key Constraints for Table TRECIPE_DLO_PAC_ADRPREB 
-- 
ALTER TABLE ASU.TRECIPE_DLO_PAC_ADRPREB ADD (
  CONSTRAINT TRECIPE_DLO_PAC_ADRPREB_PAC_FK 
 FOREIGN KEY (FK_REGPACID) 
 REFERENCES ASU.TRECIPE_DLO_REG_PAC (FK_ID))
/
