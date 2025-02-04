DROP TABLE ASU.TXRAY_TEMPLATE_RECOM CASCADE CONSTRAINTS
/

--
-- TXRAY_TEMPLATE_RECOM  (Table) 
--
CREATE TABLE ASU.TXRAY_TEMPLATE_RECOM
(
  FK_ID      NUMBER,
  FC_NAME    VARCHAR2(100 BYTE),
  FK_SOTRID  NUMBER,
  FC_TEXT    VARCHAR2(4000 BYTE),
  FK_SMID    NUMBER
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

COMMENT ON TABLE ASU.TXRAY_TEMPLATE_RECOM IS '������� ���������� ��� ������������ �������� Prihodko N. 09.04.2013'
/

COMMENT ON COLUMN ASU.TXRAY_TEMPLATE_RECOM.FK_ID IS 'UID'
/

COMMENT ON COLUMN ASU.TXRAY_TEMPLATE_RECOM.FC_NAME IS '������������ �������'
/

COMMENT ON COLUMN ASU.TXRAY_TEMPLATE_RECOM.FK_SOTRID IS 'TSOTR.FK_ID'
/

COMMENT ON COLUMN ASU.TXRAY_TEMPLATE_RECOM.FC_TEXT IS '����� �������'
/

COMMENT ON COLUMN ASU.TXRAY_TEMPLATE_RECOM.FK_SMID IS 'TSMID.FK_ID'
/


--
-- TXRAY_TEMPLATE_RECOM_SMIDID  (Index) 
--
--  Dependencies: 
--   TXRAY_TEMPLATE_RECOM (Table)
--
CREATE INDEX ASU.TXRAY_TEMPLATE_RECOM_SMIDID ON ASU.TXRAY_TEMPLATE_RECOM
(FK_SMID)
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
-- TXRAY_TEMPLATE_RECOM_SOTRID  (Index) 
--
--  Dependencies: 
--   TXRAY_TEMPLATE_RECOM (Table)
--
CREATE INDEX ASU.TXRAY_TEMPLATE_RECOM_SOTRID ON ASU.TXRAY_TEMPLATE_RECOM
(FK_SOTRID)
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
-- TXRAY_TEMPLATE_RECOM_BI  (Trigger) 
--
--  Dependencies: 
--   TXRAY_TEMPLATE_RECOM (Table)
--
CREATE OR REPLACE TRIGGER ASU."TXRAY_TEMPLATE_RECOM_BI" 
 BEFORE
  INSERT
 ON asu.txray_template_recom
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
begin
  select asu.seq_txray_template_recom.NEXTVAL into :new.fk_id from dual;
end;
/
SHOW ERRORS;


