DROP TABLE ASU.TKORP CASCADE CONSTRAINTS
/

--
-- TKORP  (Table) 
--
CREATE TABLE ASU.TKORP
(
  FK_ID      NUMBER(15),
  FC_NAME    VARCHAR2(40 BYTE),
  FN_FLOOR   NUMBER(2),
  FN_ORDER   NUMBER(15),
  FK_STOLID  NUMBER(15)                         DEFAULT -1                    NOT NULL
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          576K
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

COMMENT ON TABLE ASU.TKORP IS '���������� �������� by TimurLan'
/

COMMENT ON COLUMN ASU.TKORP.FK_ID IS 'SEQUENCE=[SEQ_TKORP]'
/

COMMENT ON COLUMN ASU.TKORP.FC_NAME IS '��������'
/

COMMENT ON COLUMN ASU.TKORP.FN_FLOOR IS '�-�� ������'
/

COMMENT ON COLUMN ASU.TKORP.FN_ORDER IS '������� ��� ����������'
/

COMMENT ON COLUMN ASU.TKORP.FK_STOLID IS '��� ��������'
/


--
-- TKORP_BY_ID  (Index) 
--
--  Dependencies: 
--   TKORP (Table)
--
CREATE UNIQUE INDEX ASU.TKORP_BY_ID ON ASU.TKORP
(FK_ID)
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
-- TKORP_LOG  (Trigger) 
--
--  Dependencies: 
--   TKORP (Table)
--
CREATE OR REPLACE TRIGGER ASU."TKORP_LOG" 
 AFTER
 INSERT OR DELETE OR UPDATE
 ON ASU.TKORP  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
  nTemp NUMBER;
BEGIN
  if INSERTING then
    PKG_LOG.Do_log('TKORP', 'FK_ID', 'INSERT', null, PKG_LOG.GET_VALUE(:new.fk_id), :new.fk_id);
  elsif DELETING then
    PKG_LOG.Do_log('TKORP', 'FK_ID', 'DELETE', PKG_LOG.GET_VALUE(:old.fk_id), null, :old.fk_id);
    PKG_LOG.Do_log('TKORP', 'FC_NAME', 'DELETE', PKG_LOG.GET_VALUE(:old.FC_NAME), null, :old.fk_id);
    PKG_LOG.Do_log('TKORP', 'FN_FLOOR', 'DELETE', PKG_LOG.GET_VALUE(:old.FN_FLOOR), null, :old.fk_id);
    PKG_LOG.Do_log('TKORP', 'FK_STOLID', 'DELETE', PKG_LOG.GET_VALUE(:old.FK_STOLID), null, :old.fk_id);
  elsif UPDATING then
    PKG_LOG.Do_log('TKORP', 'FK_ID', 'UPDATE', PKG_LOG.GET_VALUE(:old.fk_id), PKG_LOG.GET_VALUE(:new.fk_id), :old.fk_id);
    if UPDATING ('FC_NAME') AND PKG_LOG.GET_VALUE(:old.FC_NAME) <> PKG_LOG.GET_VALUE(:new.FC_NAME) then
      PKG_LOG.Do_log('TKORP', 'FC_NAME', 'UPDATE', PKG_LOG.GET_VALUE(:old.FC_NAME), PKG_LOG.GET_VALUE(:new.FC_NAME), :old.fk_id);
    end if;
    if UPDATING ('FN_FLOOR') AND PKG_LOG.GET_VALUE(:old.FN_FLOOR) <> PKG_LOG.GET_VALUE(:new.FN_FLOOR) then
      PKG_LOG.Do_log('TKORP', 'FN_FLOOR', 'UPDATE', PKG_LOG.GET_VALUE(:old.FN_FLOOR), PKG_LOG.GET_VALUE(:new.FN_FLOOR), :old.fk_id);
    end if;
    if UPDATING ('FK_STOLID') AND PKG_LOG.GET_VALUE(:old.FK_STOLID) <> PKG_LOG.GET_VALUE(:new.FK_STOLID) then
      PKG_LOG.Do_log('TKORP', 'FK_STOLID', 'UPDATE', PKG_LOG.GET_VALUE(:old.FK_STOLID), PKG_LOG.GET_VALUE(:new.FK_STOLID), :old.fk_id);
    end if;
  end if;
  null;
END TKORP_LOG;
/
SHOW ERRORS;


--
-- TKORP_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   TKORP (Table)
--
CREATE OR REPLACE TRIGGER ASU."TKORP_BEFORE_INSERT" 
BEFORE INSERT
ON ASU.TKORP REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
Begin
  SELECT SEQ_TKORP.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;


--
-- TKORP_AFTER_UPDATE  (Trigger) 
--
--  Dependencies: 
--   TKORP (Table)
--
CREATE OR REPLACE TRIGGER ASU."TKORP_AFTER_UPDATE" 
AFTER UPDATE
ON ASU.TKORP REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
Begin
--This is trigger for manual using only. It must be disabled!!!!
  UPDATE TROOM SET FK_KORPID = :NEW.FK_ID where FK_KORPID = :OLD.FK_ID;
End;
/
SHOW ERRORS;


--
-- TKORP_AFTER_INSERT  (Trigger) 
--
--  Dependencies: 
--   TKORP (Table)
--
CREATE OR REPLACE TRIGGER ASU."TKORP_AFTER_INSERT" 
AFTER DELETE
ON ASU.TKORP REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
Begin
  DELETE FROM TROOM WHERE FK_KORPID=:OLD.FK_ID;
End;
/
SHOW ERRORS;


DROP SYNONYM FOOD.TS_KORP
/

--
-- TS_KORP  (Synonym) 
--
--  Dependencies: 
--   TKORP (Table)
--
CREATE SYNONYM FOOD.TS_KORP FOR ASU.TKORP
/


