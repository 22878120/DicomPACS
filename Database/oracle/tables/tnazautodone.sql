DROP TABLE ASU.TNAZAUTODONE CASCADE CONSTRAINTS
/

--
-- TNAZAUTODONE  (Table) 
--
CREATE TABLE ASU.TNAZAUTODONE
(
  FK_ID    NUMBER,
  FK_SMID  NUMBER,
  FN_TYPE  NUMBER                               DEFAULT 1
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

COMMENT ON TABLE ASU.TNAZAUTODONE IS '������ ����������, ������������� �������������'
/

COMMENT ON COLUMN ASU.TNAZAUTODONE.FK_ID IS 'SEQUENCE=[SEQ_TNAZAUTODONE]'
/

COMMENT ON COLUMN ASU.TNAZAUTODONE.FK_SMID IS '��� �� ����������� TSMID'
/

COMMENT ON COLUMN ASU.TNAZAUTODONE.FN_TYPE IS '��� ���������� (1-��������������, 2-������������� ���������, 3 - ��������� ���������)'
/


--
-- TNAZAUTODONE_BY_SMID  (Index) 
--
--  Dependencies: 
--   TNAZAUTODONE (Table)
--
CREATE UNIQUE INDEX ASU.TNAZAUTODONE_BY_SMID ON ASU.TNAZAUTODONE
(FK_SMID)
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
-- TNAZAUTODONE_BEFOR_INSERT  (Trigger) 
--
--  Dependencies: 
--   TNAZAUTODONE (Table)
--
CREATE OR REPLACE TRIGGER ASU."TNAZAUTODONE_BEFOR_INSERT" 
BEFORE  INSERT  ON ASU.TNAZAUTODONE REFERENCING
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
Begin
  select seq_tnazautodone.nextval into :new.fk_id from dual;
End;
/
SHOW ERRORS;


--
-- TNAZAUTODONE$BIUD  (Trigger) 
--
--  Dependencies: 
--   TNAZAUTODONE (Table)
--
CREATE OR REPLACE TRIGGER ASU."TNAZAUTODONE$BIUD" 
 BEFORE 
 INSERT OR DELETE OR UPDATE
 ON ASU.TNAZAUTODONE  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
  if INSERTING then
    PKG_LOG.Do_log('TNAZAUTODONE', 'FK_ID', 'INSERT', null, PKG_LOG.GET_VALUE(:new.FK_ID), :new.fk_id);
    PKG_LOG.Do_log('TNAZAUTODONE', 'FK_SMID', 'INSERT', null, PKG_LOG.GET_VALUE(:new.FK_SMID), :new.fk_id);
    PKG_LOG.Do_log('TNAZAUTODONE', 'FN_TYPE', 'INSERT', null, PKG_LOG.GET_VALUE(:new.FN_TYPE), :new.fk_id);
  elsif DELETING then
    PKG_LOG.Do_log('TNAZAUTODONE', 'FK_ID', 'DELETE', PKG_LOG.GET_VALUE(:old.FK_ID), null, :old.fk_id);
    PKG_LOG.Do_log('TNAZAUTODONE', 'FK_SMID', 'DELETE', PKG_LOG.GET_VALUE(:old.FK_SMID), null, :old.fk_id);
    PKG_LOG.Do_log('TNAZAUTODONE', 'FN_TYPE', 'DELETE', PKG_LOG.GET_VALUE(:old.FN_TYPE), null, :old.fk_id);
  elsif UPDATING then
    PKG_LOG.Do_log('TNAZAUTODONE', 'FK_ID', 'UPDATE', PKG_LOG.GET_VALUE(:old.FK_ID), PKG_LOG.GET_VALUE(:new.FK_ID), :old.fk_id);
    if UPDATING ('FK_SMID') AND PKG_LOG.GET_VALUE(:old.FK_SMID) <> PKG_LOG.GET_VALUE(:new.FK_SMID) then
      PKG_LOG.Do_log('TNAZAUTODONE', 'FK_SMID', 'UPDATE', PKG_LOG.GET_VALUE(:old.FK_SMID), PKG_LOG.GET_VALUE(:new.FK_SMID), :old.fk_id);
    end if;
    if UPDATING ('FN_TYPE') AND PKG_LOG.GET_VALUE(:old.FN_TYPE) <> PKG_LOG.GET_VALUE(:new.FN_TYPE) then
      PKG_LOG.Do_log('TNAZAUTODONE', 'FN_TYPE', 'UPDATE', PKG_LOG.GET_VALUE(:old.FN_TYPE), PKG_LOG.GET_VALUE(:new.FN_TYPE), :old.fk_id);
    end if;
  end if;
  null;
END TSMID_LOG;
/
SHOW ERRORS;


