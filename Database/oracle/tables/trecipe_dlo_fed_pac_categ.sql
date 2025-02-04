ALTER TABLE ASU.TRECIPE_DLO_FED_PAC_CATEG
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TRECIPE_DLO_FED_PAC_CATEG CASCADE CONSTRAINTS
/

--
-- TRECIPE_DLO_FED_PAC_CATEG  (Table) 
--
--  Dependencies: 
--   TRECIPE_DLO_FED_PAC (Table)
--
CREATE TABLE ASU.TRECIPE_DLO_FED_PAC_CATEG
(
  FK_ID        NUMBER,
  FK_FEDPACID  NUMBER,
  C_KAT        VARCHAR2(3 BYTE),
  NAME_DL      VARCHAR2(80 BYTE),
  SN_DL        VARCHAR2(19 BYTE),
  DATE_BL      DATE,
  DATE_EL      DATE,
  MKB          VARCHAR2(6 BYTE)
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

COMMENT ON TABLE ASU.TRECIPE_DLO_FED_PAC_CATEG IS '���. ��������� ���������� ����������� ���������� � 7 ���������'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.FK_ID IS '����'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.FK_FEDPACID IS '������ �� ���������'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.C_KAT IS '��� ��������� ����������'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.NAME_DL IS '������������ ���������, ��������������� ����� �� ��������� ���'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.SN_DL IS '����� � ����� ���������'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.DATE_BL IS '���� ������ �������� ���'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.DATE_EL IS '���� ��������� �������� ���'
/

COMMENT ON COLUMN ASU.TRECIPE_DLO_FED_PAC_CATEG.MKB IS '��� �������� ��� (��� �������� 7 ���������)'
/


--
-- TRECIPE_FEDPAC_CATEG_PACID_IDX  (Index) 
--
--  Dependencies: 
--   TRECIPE_DLO_FED_PAC_CATEG (Table)
--
CREATE INDEX ASU.TRECIPE_FEDPAC_CATEG_PACID_IDX ON ASU.TRECIPE_DLO_FED_PAC_CATEG
(FK_FEDPACID)
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
-- TRECIPE_FEDPAC_CATEG_PK  (Index) 
--
--  Dependencies: 
--   TRECIPE_DLO_FED_PAC_CATEG (Table)
--
CREATE UNIQUE INDEX ASU.TRECIPE_FEDPAC_CATEG_PK ON ASU.TRECIPE_DLO_FED_PAC_CATEG
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
-- TRECIPE_DLO_FED_PAC_CATEG_INS  (Trigger) 
--
--  Dependencies: 
--   TRECIPE_DLO_FED_PAC_CATEG (Table)
--
CREATE OR REPLACE TRIGGER ASU."TRECIPE_DLO_FED_PAC_CATEG_INS"
 BEFORE
  INSERT
 ON ASU.TRECIPE_DLO_FED_PAC_CATEG REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
begin
  if (:new.fk_id is null) then
    select ASU.SEQ_TRECIPE_DLO_FED_PAC_CATEG.nextval into :new.fk_id from dual;
  end if;
end;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TRECIPE_DLO_FED_PAC_CATEG 
-- 
ALTER TABLE ASU.TRECIPE_DLO_FED_PAC_CATEG ADD (
  CONSTRAINT TRECIPE_FEDPAC_CATEG_PK
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
-- Foreign Key Constraints for Table TRECIPE_DLO_FED_PAC_CATEG 
-- 
ALTER TABLE ASU.TRECIPE_DLO_FED_PAC_CATEG ADD (
  CONSTRAINT TRECIPE_FEDPAC_CATEG_PACID_FK 
 FOREIGN KEY (FK_FEDPACID) 
 REFERENCES ASU.TRECIPE_DLO_FED_PAC (FK_ID))
/

