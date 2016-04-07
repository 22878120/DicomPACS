DROP TRIGGER ASU.TPRIEMORDER_INSERT
/

--
-- TPRIEMORDER_INSERT  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SEQ_TPRIEMORDER (Sequence)
--   TPRIEMORDER (Table)
--
CREATE OR REPLACE TRIGGER ASU."TPRIEMORDER_INSERT" 
 BEFORE
  INSERT
 ON asu.TPRIEMORDER
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
Begin
  SELECT asu.SEQ_TPRIEMORDER.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;

