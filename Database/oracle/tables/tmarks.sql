DROP TABLE ASU.TMARKS CASCADE CONSTRAINTS
/

--
-- TMARKS  (Table) 
--
CREATE TABLE ASU.TMARKS
(
  MARKSID  NUMBER,
  PACID    NUMBER,
  SOTRID   NUMBER
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

COMMENT ON TABLE ASU.TMARKS IS '������� ����� by TimurLan'
/

COMMENT ON COLUMN ASU.TMARKS.MARKSID IS '���'
/

COMMENT ON COLUMN ASU.TMARKS.PACID IS '��� �������� TKARTA.FK_ID'
/

COMMENT ON COLUMN ASU.TMARKS.SOTRID IS '��� ����������'
/


--
-- TMARKS_BY_PACID_SOTRID  (Index) 
--
--  Dependencies: 
--   TMARKS (Table)
--
CREATE UNIQUE INDEX ASU.TMARKS_BY_PACID_SOTRID ON ASU.TMARKS
(PACID, SOTRID)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TMARKS_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TMARKS (Table)
--
CREATE OR REPLACE TRIGGER ASU."TMARKS_BEFORE_INSERT" 
 BEFORE
 INSERT
 ON ASU.TMARKS  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
  SELECT SEQ_TMARKS.NEXTVAL INTO :NEW.MARKSID FROM DUAL;
END;
/
SHOW ERRORS;


