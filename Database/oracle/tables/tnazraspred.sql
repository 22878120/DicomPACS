DROP TABLE ASU.TNAZRASPRED CASCADE CONSTRAINTS
/

--
-- TNAZRASPRED  (Table) 
--
CREATE TABLE ASU.TNAZRASPRED
(
  FK_ID    NUMBER(9),
  FK_SMID  NUMBER(9),
  FK_SPEC  NUMBER(9)
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

COMMENT ON TABLE ASU.TNAZRASPRED IS '�����-�� ���������� /TimurLan'
/

COMMENT ON COLUMN ASU.TNAZRASPRED.FK_ID IS 'SEQUENCE=[SEQ_TNAZRASPRED]'
/


--
-- TNAZRASPRED_ALL  (Index) 
--
--  Dependencies: 
--   TNAZRASPRED (Table)
--
CREATE INDEX ASU.TNAZRASPRED_ALL ON ASU.TNAZRASPRED
(FK_ID, FK_SMID, FK_SPEC)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TNAZRASPRED$ID  (Index) 
--
--  Dependencies: 
--   TNAZRASPRED (Table)
--
CREATE UNIQUE INDEX ASU.TNAZRASPRED$ID ON ASU.TNAZRASPRED
(FK_ID)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          12672K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TNAZRASPRED_SPEC  (Index) 
--
--  Dependencies: 
--   TNAZRASPRED (Table)
--
CREATE INDEX ASU.TNAZRASPRED_SPEC ON ASU.TNAZRASPRED
(FK_SPEC)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TNAZRASPRED$SPEC_SMID  (Index) 
--
--  Dependencies: 
--   TNAZRASPRED (Table)
--
CREATE INDEX ASU.TNAZRASPRED$SPEC_SMID ON ASU.TNAZRASPRED
(FK_SMID, FK_SPEC)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          12672K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TNAZRASPRED_BEFOR_INSERT  (Trigger) 
--
--  Dependencies: 
--   TNAZRASPRED (Table)
--
CREATE OR REPLACE TRIGGER ASU."TNAZRASPRED_BEFOR_INSERT" 
BEFORE  INSERT  ON ASU.TNAZRASPRED REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
Begin
    select seq_tnazraspred.nextval into :new.fk_id from dual;
End;
/
SHOW ERRORS;


