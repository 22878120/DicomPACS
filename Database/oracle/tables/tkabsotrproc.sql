DROP TABLE ASU.TKABSOTRPROC CASCADE CONSTRAINTS
/

--
-- TKABSOTRPROC  (Table) 
--
CREATE TABLE ASU.TKABSOTRPROC
(
  FK_ID         NUMBER,
  FK_OWNER      NUMBER,
  FC_NAME       VARCHAR2(4000 BYTE),
  FK_KABINETID  NUMBER,
  FK_SOTRID     NUMBER,
  FK_SMID       NUMBER,
  FL_SHOWREP    NUMBER(1)                       DEFAULT 1,
  FL_MAIN       NUMBER(1)                       DEFAULT 0,
  FN_WHAT       NUMBER
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1280K
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

COMMENT ON TABLE ASU.TKABSOTRPROC IS '��������� ����� ����������'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FK_ID IS 'SEQUENCE=[SEQ_TKABSOTRPROC]'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FK_OWNER IS '��������� ����'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FC_NAME IS '��������� ����'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FK_KABINETID IS '��� ��������'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FK_SOTRID IS '��� ����������'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FK_SMID IS '��� �� ����������� TSMID'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FL_SHOWREP IS '��������� ����'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FL_MAIN IS '��������� ����'
/

COMMENT ON COLUMN ASU.TKABSOTRPROC.FN_WHAT IS '��������� ����'
/


--
-- TKABSOTRPROC_BEFOREINSERT  (Trigger) 
--
--  Dependencies: 
--   TKABSOTRPROC (Table)
--
CREATE OR REPLACE TRIGGER ASU."TKABSOTRPROC_BEFOREINSERT" 
  before insert on tkabsotrproc  
  for each row
begin
  SELECT seq_tkabsotrproc.NEXTVAL INTO :new.fk_id FROM dual;
end;
/
SHOW ERRORS;


