ALTER TABLE ASU.THEAL_MEDIC
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.THEAL_MEDIC CASCADE CONSTRAINTS
/

--
-- THEAL_MEDIC  (Table) 
--
--  Dependencies: 
--   THEAL (Table)
--   TMEDIC (Table)
--
CREATE TABLE ASU.THEAL_MEDIC
(
  FK_ID       INTEGER                           NOT NULL,
  FK_HEAL     INTEGER                           NOT NULL,
  FK_MEDICID  INTEGER                           NOT NULL
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

COMMENT ON TABLE ASU.THEAL_MEDIC IS '����� ����� �� ���������� ������������(���76) � ��������� ����� MED.TMEDIC'
/

COMMENT ON COLUMN ASU.THEAL_MEDIC.FK_ID IS 'SEQUENCE=[SEQ_HEAL_SMID]'
/


--
-- PK_THEAL_MEDIC  (Index) 
--
--  Dependencies: 
--   THEAL_MEDIC (Table)
--
CREATE UNIQUE INDEX ASU.PK_THEAL_MEDIC ON ASU.THEAL_MEDIC
(FK_ID)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- THEAL_MEDIC_INSERT  (Trigger) 
--
--  Dependencies: 
--   THEAL_MEDIC (Table)
--
CREATE OR REPLACE TRIGGER ASU."THEAL_MEDIC_INSERT"
 BEFORE
  INSERT
 ON ASU.THEAL_MEDIC REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH row
begin
  if :new.FK_ID IS NULL then
     select asu.SEQ_HEAL_SMID.NEXTVAL INTO :new.FK_ID  from dual;
  end if;
end;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table THEAL_MEDIC 
-- 
ALTER TABLE ASU.THEAL_MEDIC ADD (
  CONSTRAINT PK_THEAL_MEDIC
 PRIMARY KEY
 (FK_ID))
/

-- 
-- Foreign Key Constraints for Table THEAL_MEDIC 
-- 
ALTER TABLE ASU.THEAL_MEDIC ADD (
  CONSTRAINT FK_THEAL_MEDIC_TMEDIC_MEDICID 
 FOREIGN KEY (FK_MEDICID) 
 REFERENCES MED.TMEDIC (MEDICID),
  CONSTRAINT FK_THEAL_MEDIC_THEAL_FK_ID 
 FOREIGN KEY (FK_HEAL) 
 REFERENCES ASU.THEAL (FK_ID))
/

