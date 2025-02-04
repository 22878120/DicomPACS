DROP TABLE ASU.TOPER_IN_FOREIGN_LPU CASCADE CONSTRAINTS
/

--
-- TOPER_IN_FOREIGN_LPU  (Table) 
--
CREATE TABLE ASU.TOPER_IN_FOREIGN_LPU
(
  FK_ID          NUMBER(15)                     NOT NULL,
  FK_PEOPLEID    NUMBER(15)                     NOT NULL,
  FD_BEGIN       DATE,
  FD_END         DATE,
  FC_NAME        VARCHAR2(500 BYTE)             NOT NULL,
  FC_VRACH       VARCHAR2(100 BYTE),
  FK_ANESTHESIA  NUMBER(15),
  FC_LPUNAME     VARCHAR2(200 BYTE),
  FK_LPUNAMEID   NUMBER,
  FC_COMMENT     VARCHAR2(4000 BYTE),
  FK_IKUSAGE     NUMBER,
  FC_OSL         VARCHAR2(4000 BYTE),
  FK_HEALID      NUMBER(15)
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

COMMENT ON TABLE ASU.TOPER_IN_FOREIGN_LPU IS '������ ��������, ������� ����������� �� � ������ ������� ���. Author: Neronov A.S.'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FK_ID IS 'SEQUENCE=[SEQ_TOPER_NOTINLPU]'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FK_PEOPLEID IS '������� �� TPEOPLE'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FD_BEGIN IS '���� ������ ��������'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FD_END IS '���� ��������� ��������'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FC_NAME IS '�������� ��������'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FC_VRACH IS '����, ����������� ��������'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FK_ANESTHESIA IS '��������� �� TSMID � ����� ''PROTHOPER_OBEZBOL'''
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FC_LPUNAME IS '�������� ���, � ������� ������������� ��������'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FK_LPUNAMEID IS '������ �� TSMID (������� �� ������������ )'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FC_OSL IS '���������� � ��������� ����'
/

COMMENT ON COLUMN ASU.TOPER_IN_FOREIGN_LPU.FK_HEALID IS '������ �� asu.theal.fk_id (owner = get_med_usl_operacii) ������������ �������� �� ����������� '
/


