DROP TABLE ASU.TRUSGUEST CASCADE CONSTRAINTS
/

--
-- TRUSGUEST  (Table) 
--
CREATE TABLE ASU.TRUSGUEST
(
  FK_ID       NUMBER(9)                         DEFAULT -1,
  FC_GUESNU   VARCHAR2(10 BYTE),
  FC_FAM      VARCHAR2(40 BYTE),
  FC_NAME     VARCHAR2(30 BYTE),
  FC_OTCH     VARCHAR2(30 BYTE),
  FC_ROOM     VARCHAR2(6 BYTE),
  FP_SEX      NUMBER(1),
  FD_ROJD     DATE,
  FC_ADR      VARCHAR2(100 BYTE),
  FD_DATA1    DATE,
  FD_DATA2    DATE,
  FD_DATA3    DATE,
  FC_COMMENT  VARCHAR2(100 BYTE),
  FK_TARIFF   NUMBER,
  FC_WORK     VARCHAR2(100 BYTE),
  FC_PUT      VARCHAR2(10 BYTE),
  FK_PACID    NUMBER(9)                         DEFAULT -1
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          160K
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

COMMENT ON TABLE ASU.TRUSGUEST IS '�������-������ � ������� ������....'
/


--
-- TRUSGUEST_BY_GUESNU  (Index) 
--
--  Dependencies: 
--   TRUSGUEST (Table)
--
CREATE UNIQUE INDEX ASU.TRUSGUEST_BY_GUESNU ON ASU.TRUSGUEST
(FC_GUESNU)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          12672K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


