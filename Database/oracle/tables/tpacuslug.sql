ALTER TABLE ASU.TPACUSLUG
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TPACUSLUG CASCADE CONSTRAINTS
/

--
-- TPACUSLUG  (Table) 
--
CREATE TABLE ASU.TPACUSLUG
(
  FK_ID             NUMBER                      NOT NULL,
  FK_PACID          NUMBER,
  FK_HEAL           NUMBER,
  FK_ASSUMEISPOL    NUMBER,
  FK_KABINET        NUMBER,
  FD_REMOVEDATE     DATE,
  FK_INSUR_DOGOVOR  NUMBER
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

COMMENT ON TABLE ASU.TPACUSLUG IS '������, ��������� �� ����������, �� ����������� �� ��������� ��� ������ ��� �������� ������ ����������. by A.Nakorjakov 080508'
/

COMMENT ON COLUMN ASU.TPACUSLUG.FK_ID IS 'SEQUENCE=[SEQ_TPACUSLUG]'
/

COMMENT ON COLUMN ASU.TPACUSLUG.FK_HEAL IS 'THEAL.FK_ID'
/

COMMENT ON COLUMN ASU.TPACUSLUG.FK_ASSUMEISPOL IS 'TOTDEL.FK_ID;TSOTR.FK_ID �����������??�� ����������� (����� ���� ��������� ��� ���������)'
/

COMMENT ON COLUMN ASU.TPACUSLUG.FK_KABINET IS 'TKABINET.FK_ID'
/

COMMENT ON COLUMN ASU.TPACUSLUG.FD_REMOVEDATE IS '���� �������� ������ �� ������ ��������� �����'
/

COMMENT ON COLUMN ASU.TPACUSLUG.FK_INSUR_DOGOVOR IS 'TINSUR_DOGOVOR.FK_ID'
/


--
-- PK_PACUSLUG  (Index) 
--
--  Dependencies: 
--   TPACUSLUG (Table)
--
CREATE UNIQUE INDEX ASU.PK_PACUSLUG ON ASU.TPACUSLUG
(FK_ID)
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


--
-- TPACUSLUG_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TPACUSLUG (Table)
--
CREATE OR REPLACE TRIGGER ASU."TPACUSLUG_BEFORE_INSERT" 
 BEFORE
 INSERT
 ON ASU.TPACUSLUG  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
  SELECT SEQ_TPACUSLUG.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TPACUSLUG 
-- 
ALTER TABLE ASU.TPACUSLUG ADD (
  CONSTRAINT PK_PACUSLUG
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
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
               ))
/

