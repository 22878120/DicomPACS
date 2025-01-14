ALTER TABLE ASU.TSCREENING_SDIAG
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TSCREENING_SDIAG CASCADE CONSTRAINTS
/

--
-- TSCREENING_SDIAG  (Table) 
--
CREATE TABLE ASU.TSCREENING_SDIAG
(
  FK_ID        NUMBER(15)                       NOT NULL,
  FK_DIAGSMID  NUMBER(15),
  FD_INSDATE   DATE                             DEFAULT SYSDATE,
  FL_GKT       NUMBER(1)                        DEFAULT 1,
  FL_KRR       NUMBER(1)                        DEFAULT 0
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

COMMENT ON TABLE ASU.TSCREENING_SDIAG IS '������ ��������� ������� ������ �������� � ������ ���������. Author:Malev'
/

COMMENT ON COLUMN ASU.TSCREENING_SDIAG.FK_DIAGSMID IS '������ �� ������� (ASU.TSMID.FK_ID)'
/

COMMENT ON COLUMN ASU.TSCREENING_SDIAG.FD_INSDATE IS '���� �������'
/

COMMENT ON COLUMN ASU.TSCREENING_SDIAG.FL_GKT IS '������� "������� ���"'
/

COMMENT ON COLUMN ASU.TSCREENING_SDIAG.FL_KRR IS '������� "������� ���"'
/


--
-- TSCREENING_SDIAG_BY_ID  (Index) 
--
--  Dependencies: 
--   TSCREENING_SDIAG (Table)
--
CREATE UNIQUE INDEX ASU.TSCREENING_SDIAG_BY_ID ON ASU.TSCREENING_SDIAG
(FK_ID)
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
-- TSCREENING_SDIAG_BEF_INS  (Trigger) 
--
--  Dependencies: 
--   TSCREENING_SDIAG (Table)
--
CREATE OR REPLACE TRIGGER ASU."TSCREENING_SDIAG_BEF_INS"
BEFORE INSERT
ON ASU.TSCREENING_SDIAG REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  IF :NEW.FK_ID IS NULL THEN
     SELECT ASU.SEQ_TSCREENING_SDIAG.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
  END IF;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TSCREENING_SDIAG 
-- 
ALTER TABLE ASU.TSCREENING_SDIAG ADD (
  CONSTRAINT TSCREENING_SDIAG_BY_ID
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
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
               ))
/

