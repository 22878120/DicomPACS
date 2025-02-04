DROP TABLE ASU.TEXCHMIC_OPER CASCADE CONSTRAINTS
/

--
-- TEXCHMIC_OPER  (Table) 
--
CREATE GLOBAL TEMPORARY TABLE ASU.TEXCHMIC_OPER
(
  PID                 NUMBER,
  ID_ILL              NUMBER,
  ID_SERV             NUMBER(15)                NOT NULL,
  N_MAP               NUMBER,
  FK_OTDELID          NUMBER,
  DATE_OPER           VARCHAR2(19 BYTE),
  DATE_OPER_FOR_SERV  VARCHAR2(10 BYTE),
  MORPHEY             NUMBER,
  DOCTOR_N            VARCHAR2(150 BYTE),
  DOCTOR_N_ID         NUMBER,
  DOCTOR_W            VARCHAR2(150 BYTE),
  DOCTOR_W_ID         NUMBER,
  PLACE_W             NUMBER,
  PLACE_N             NUMBER,
  DOC_SPEC_N          NUMBER,
  DOC_SPEC_W          NUMBER,
  DOC_SPEC            NUMBER,
  DOC_SPECNAME        VARCHAR2(150 BYTE),
  DOC_SPECNAME_OUR    VARCHAR2(150 BYTE),
  TYPE_OPER           NUMBER,
  COMPL               CHAR(255 BYTE),
  O_ANASTEZ           CHAR(10 BYTE),
  O_OPERATS           CHAR(10 BYTE),
  WAS_LOADED          NUMBER,
  CIPHER              VARCHAR2(150 BYTE)
)
ON COMMIT PRESERVE ROWS
NOCACHE
/

COMMENT ON TABLE ASU.TEXCHMIC_OPER IS '�������� � ���. ��������� ������� �������� Author: Efimov'
/


