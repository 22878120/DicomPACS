DROP TABLE ASU.TINFOPANEL_DATA CASCADE CONSTRAINTS
/

--
-- TINFOPANEL_DATA  (Table) 
--
CREATE TABLE ASU.TINFOPANEL_DATA
(
  FK_PAGEID      NUMBER,
  FK_KABVRACHID  NUMBER,
  FC_KABNUM      VARCHAR2(100 BYTE),
  FC_ACCESS      VARCHAR2(50 BYTE),
  FN_ORDER       NUMBER(2),
  FL_SHOW        NUMBER(1)                      DEFAULT 1,
  FC_PRIEMNAME   VARCHAR2(100 BYTE),
  FT_TIME1       DATE,
  FT_TIME2       DATE
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

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FK_PAGEID IS 'tinfopanel_otdlist.fk_id'
/

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FK_KABVRACHID IS 'tvrachkab.fk_id'
/

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FC_KABNUM IS '����� ��������'
/

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FC_ACCESS IS '������ (����/���)'
/

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FL_SHOW IS '���������� � ������ =1'
/

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FC_PRIEMNAME IS '�������� ������'
/

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FT_TIME1 IS '����� ������ ������'
/

COMMENT ON COLUMN ASU.TINFOPANEL_DATA.FT_TIME2 IS '����� ��������� ������'
/


