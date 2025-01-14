DROP TABLE ASU.TRSF_SAVED_REESTR CASCADE CONSTRAINTS
/

--
-- TRSF_SAVED_REESTR  (Table) 
--
CREATE TABLE ASU.TRSF_SAVED_REESTR
(
  FK_RSFID       NUMBER                         NOT NULL,
  FK_PACID       NUMBER,
  FK_NAZID       NUMBER,
  FK_HEALID      NUMBER,
  FK_PERESELID   NUMBER,
  FK_INSURDOCID  NUMBER,
  FN_COUNT       NUMBER,
  FN_COST        NUMBER
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

COMMENT ON TABLE ASU.TRSF_SAVED_REESTR IS '������� �������� ���������� ��������. Author: Neronov A.S.'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FK_RSFID IS 'TRSF.FK_ID - ������ �� ����� �������'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FK_PACID IS 'VNAZ.FK_PACID - ID ��������'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FK_NAZID IS 'VNAZ.FK_ID - ID ����������'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FK_HEALID IS 'THEAL.FK_ID - ID ������'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FK_PERESELID IS 'TPERESEL.FK_ID - ID �������� �� ����������'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FK_INSURDOCID IS 'TINSURDOCS.FK_ID - ID ���������� ������'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FN_COUNT IS '���-��'
/

COMMENT ON COLUMN ASU.TRSF_SAVED_REESTR.FN_COST IS '����'
/


--
-- TRSF_SAVED_REESTR_BY_FK_HEALID  (Index) 
--
--  Dependencies: 
--   TRSF_SAVED_REESTR (Table)
--
CREATE INDEX ASU.TRSF_SAVED_REESTR_BY_FK_HEALID ON ASU.TRSF_SAVED_REESTR
(FK_HEALID)
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
-- TRSF_SAVED_REESTR_BY_FK_NAZID  (Index) 
--
--  Dependencies: 
--   TRSF_SAVED_REESTR (Table)
--
CREATE INDEX ASU.TRSF_SAVED_REESTR_BY_FK_NAZID ON ASU.TRSF_SAVED_REESTR
(FK_NAZID)
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
-- TRSF_SAVED_REESTR_BY_FK_RSFID  (Index) 
--
--  Dependencies: 
--   TRSF_SAVED_REESTR (Table)
--
CREATE INDEX ASU.TRSF_SAVED_REESTR_BY_FK_RSFID ON ASU.TRSF_SAVED_REESTR
(FK_RSFID)
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
-- TRSF_SAVED_REESTR_BY_INSURID  (Index) 
--
--  Dependencies: 
--   TRSF_SAVED_REESTR (Table)
--
CREATE INDEX ASU.TRSF_SAVED_REESTR_BY_INSURID ON ASU.TRSF_SAVED_REESTR
(FK_INSURDOCID)
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
-- TRSF_SAVED_REESTR_BY_PERESEL  (Index) 
--
--  Dependencies: 
--   TRSF_SAVED_REESTR (Table)
--
CREATE INDEX ASU.TRSF_SAVED_REESTR_BY_PERESEL ON ASU.TRSF_SAVED_REESTR
(FK_PERESELID)
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


