DROP TABLE ASU.TQC_SERIES CASCADE CONSTRAINTS
/

--
-- TQC_SERIES  (Table) 
--
CREATE TABLE ASU.TQC_SERIES
(
  FK_ID                  INTEGER                NOT NULL,
  FK_METODID             INTEGER,
  FK_LOTID               INTEGER,
  FC_NAME                VARCHAR2(255 BYTE),
  FD_BEGIN               DATE,
  FD_END                 DATE,
  FL_ACTIVE              INTEGER,
  FK_TYPE                INTEGER,
  FK_SOTRID              INTEGER,
  FL_STATUS              INTEGER,
  FC_MAP_CRITERION_LIST  VARCHAR2(255 BYTE),
  FL_DEL                 NUMBER                 DEFAULT 0
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

COMMENT ON COLUMN ASU.TQC_SERIES.FK_METODID IS 'TQC_METHOD.FK_ID'
/

COMMENT ON COLUMN ASU.TQC_SERIES.FK_LOTID IS 'TQC_LOT.FK_ID'
/

COMMENT ON COLUMN ASU.TQC_SERIES.FC_NAME IS '������������ �����'
/

COMMENT ON COLUMN ASU.TQC_SERIES.FD_BEGIN IS '���� ������ �����'
/

COMMENT ON COLUMN ASU.TQC_SERIES.FD_END IS '���� �������� �����'
/

COMMENT ON COLUMN ASU.TQC_SERIES.FL_ACTIVE IS '������� ���������� �����'
/

COMMENT ON COLUMN ASU.TQC_SERIES.FK_SOTRID IS 'TSOTR.FK_ID'
/


--
-- TQC_SERIES_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TQC_SERIES (Table)
--
CREATE OR REPLACE TRIGGER ASU."TQC_SERIES_BEFORE_INSERT" 
 BEFORE
  INSERT
 ON ASU.TQC_SERIES REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
    SELECT SEQ_QC_LAB.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;


