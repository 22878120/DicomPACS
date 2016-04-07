DROP TABLE ASU.TQC_MGROUP CASCADE CONSTRAINTS
/

--
-- TQC_MGROUP  (Table) 
--
CREATE TABLE ASU.TQC_MGROUP
(
  FK_ID        NUMBER                           NOT NULL,
  FC_NAME      VARCHAR2(255 BYTE),
  FK_OTDELID   INTEGER,
  FK_DEVICEID  INTEGER,
  FL_DEL       NUMBER
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

COMMENT ON COLUMN ASU.TQC_MGROUP.FC_NAME IS '������������'
/

COMMENT ON COLUMN ASU.TQC_MGROUP.FK_OTDELID IS '�����'
/

COMMENT ON COLUMN ASU.TQC_MGROUP.FK_DEVICEID IS '�������'
/

COMMENT ON COLUMN ASU.TQC_MGROUP.FL_DEL IS '���� ��������'
/


--
-- TQC_MGROUP_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TQC_MGROUP (Table)
--
CREATE OR REPLACE TRIGGER ASU."TQC_MGROUP_BEFORE_INSERT" 
 BEFORE
  INSERT
 ON ASU.TQC_MGROUP REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
    SELECT SEQ_QC_LAB.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;

