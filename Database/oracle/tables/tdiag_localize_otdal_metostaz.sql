DROP TABLE ASU.TDIAG_LOCALIZE_OTDAL_METOSTAZ CASCADE CONSTRAINTS
/

--
-- TDIAG_LOCALIZE_OTDAL_METOSTAZ  (Table) 
--
CREATE TABLE ASU.TDIAG_LOCALIZE_OTDAL_METOSTAZ
(
  FK_DIAGID  NUMBER,
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

COMMENT ON TABLE ASU.TDIAG_LOCALIZE_OTDAL_METOSTAZ IS '����������� ���������� �������� Author: Melnikov 2013.06.07'
/


--
-- TDIAG_LOCAL_OTD_MET_DIAGID  (Index) 
--
--  Dependencies: 
--   TDIAG_LOCALIZE_OTDAL_METOSTAZ (Table)
--
CREATE INDEX ASU.TDIAG_LOCAL_OTD_MET_DIAGID ON ASU.TDIAG_LOCALIZE_OTDAL_METOSTAZ
(FK_DIAGID)
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


