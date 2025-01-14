DROP TABLE ASU.CLNT_INFO CASCADE CONSTRAINTS
/

--
-- CLNT_INFO  (Table) 
--
CREATE TABLE ASU.CLNT_INFO
(
  DT                   DATE                     DEFAULT SYSDATE               NOT NULL,
  OSVER                VARCHAR2(200 BYTE),
  CPU_MANUFACTURER     VARCHAR2(200 BYTE),
  MEMORY               VARCHAR2(200 BYTE),
  OCI_VER              VARCHAR2(200 BYTE),
  DISPLAY              VARCHAR2(200 BYTE),
  ORA_HOME             VARCHAR2(4000 BYTE),
  NTPRODUCTTYPESTRING  VARCHAR2(200 BYTE),
  OSBUILD              VARCHAR2(200 BYTE),
  CPU_NAME             VARCHAR2(200 BYTE),
  CPU_FREQ             VARCHAR2(200 BYTE),
  MEMORY_FREE          VARCHAR2(100 BYTE),
  OSUSER               VARCHAR2(200 BYTE),
  MACHINE              VARCHAR2(200 BYTE),
  TERMINAL             VARCHAR2(200 BYTE),
  ADMIN                NUMBER(1),
  OFFICE_VER           VARCHAR2(200 BYTE),
  DISK_VOL             NUMBER,
  IE_VER               VARCHAR2(200 BYTE),
  DISK_FREE_VOL        NUMBER,
  ST_ASU_VER           VARCHAR2(20 BYTE)
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

COMMENT ON COLUMN ASU.CLNT_INFO.OSVER IS '������ OS'
/

COMMENT ON COLUMN ASU.CLNT_INFO.CPU_MANUFACTURER IS '������������� CPU'
/

COMMENT ON COLUMN ASU.CLNT_INFO.MEMORY IS '������ �� ����������'
/

COMMENT ON COLUMN ASU.CLNT_INFO.OCI_VER IS '������ Oracle Client'
/

COMMENT ON COLUMN ASU.CLNT_INFO.DISPLAY IS '���������� ������'
/

COMMENT ON COLUMN ASU.CLNT_INFO.MEMORY_FREE IS '�������� ������'
/

COMMENT ON COLUMN ASU.CLNT_INFO.ADMIN IS '���� ��������� �����'
/

COMMENT ON COLUMN ASU.CLNT_INFO.OFFICE_VER IS '������ �����'
/

COMMENT ON COLUMN ASU.CLNT_INFO.DISK_VOL IS '����� ������'
/

COMMENT ON COLUMN ASU.CLNT_INFO.IE_VER IS '������ IE'
/

COMMENT ON COLUMN ASU.CLNT_INFO.DISK_FREE_VOL IS '�������� �����'
/


--
-- CNT_INFO$BI  (Trigger) 
--
--  Dependencies: 
--   CLNT_INFO (Table)
--
CREATE OR REPLACE TRIGGER ASU."CNT_INFO$BI" 
 BEFORE 
 INSERT
 ON ASU.CLNT_INFO  FOR EACH ROW
DECLARE

CURSOR C1 is
    SELECT OSUSER, MACHINE, TERMINAL
          FROM V$SESSION
         WHERE AUDSID = USERENV('SESSIONID');

    sOSUSER VARCHAR2(100);
    sMACHINE VARCHAR2(200);
    sTERMINAL VARCHAR2(200);

BEGIN

    OPEN C1;
    FETCH C1 into :NEW.OSUSER, :NEW.MACHINE, :NEW.TERMINAL;
    CLOSE C1;

END;
/
SHOW ERRORS;


