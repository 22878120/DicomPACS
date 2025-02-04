DROP TABLE ASU.TLAB_REPORT_OTDEL CASCADE CONSTRAINTS
/

--
-- TLAB_REPORT_OTDEL  (Table) 
--
CREATE TABLE ASU.TLAB_REPORT_OTDEL
(
  FK_OTDELID  NUMBER
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

COMMENT ON TABLE ASU.TLAB_REPORT_OTDEL IS '������ ����������� ��� ������ Author:Kulbatsky'
/

COMMENT ON COLUMN ASU.TLAB_REPORT_OTDEL.FK_OTDELID IS 'LOGIN.TOTDEL.FK_ID'
/


