DROP TABLE ASU.TMAINGROUP CASCADE CONSTRAINTS
/

--
-- TMAINGROUP  (Table) 
--
CREATE TABLE ASU.TMAINGROUP
(
  FK_ID    NUMBER(15),
  FC_NAME  VARCHAR2(30 BYTE)
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          520K
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

COMMENT ON TABLE ASU.TMAINGROUP IS '���������� ������� ����� ������ by TimurLan'
/

COMMENT ON COLUMN ASU.TMAINGROUP.FK_ID IS 'ID'
/

COMMENT ON COLUMN ASU.TMAINGROUP.FC_NAME IS '��������'
/


