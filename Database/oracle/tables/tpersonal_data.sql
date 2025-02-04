DROP TABLE ASU.TPERSONAL_DATA CASCADE CONSTRAINTS
/

--
-- TPERSONAL_DATA  (Table) 
--
CREATE TABLE ASU.TPERSONAL_DATA
(
  FK_PEOPLE  NUMBER,
  FD_DATE    DATE,
  FK_SOTR    NUMBER,
  FP_TYPE    NUMBER
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

COMMENT ON TABLE ASU.TPERSONAL_DATA IS '����������� ������ �������� � ������� �� ��������� ������������ ������ Author: Spasskiy S.N.'
/

COMMENT ON COLUMN ASU.TPERSONAL_DATA.FK_PEOPLE IS 'TPEOPLE.FK_ID'
/

COMMENT ON COLUMN ASU.TPERSONAL_DATA.FD_DATE IS '���� �����'
/

COMMENT ON COLUMN ASU.TPERSONAL_DATA.FK_SOTR IS '��� ���������� ����������� ����'
/

COMMENT ON COLUMN ASU.TPERSONAL_DATA.FP_TYPE IS '0 - ��������, 1- �����'
/


--
-- IX_TPERSONAL_DATA$FK_PEOPLE  (Index) 
--
--  Dependencies: 
--   TPERSONAL_DATA (Table)
--
CREATE INDEX ASU.IX_TPERSONAL_DATA$FK_PEOPLE ON ASU.TPERSONAL_DATA
(FK_PEOPLE)
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


