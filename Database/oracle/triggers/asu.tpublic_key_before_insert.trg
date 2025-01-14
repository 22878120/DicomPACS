DROP TRIGGER ASU.TPUBLIC_KEY_BEFORE_INSERT
/

--
-- TPUBLIC_KEY_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   SEQ_TPUBLIC_KEY (Sequence)
--   TPUBLIC_KEY (Table)
--
CREATE OR REPLACE TRIGGER ASU."TPUBLIC_KEY_BEFORE_INSERT" 
 BEFORE INSERT ON ASU.TPUBLIC_KEY  REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
pcnt INTEGER;
BEGIN
 if :NEW.FK_ID is null then
   SELECT SEQ_TPUBLIC_KEY.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
 end if;
 SELECT COUNT(1)
   INTO pcnt
   FROM ASU.TPUBLIC_KEY
  WHERE FK_PEOPLEID = :NEW.FK_PEOPLEID
    AND fl_del = 0;
 IF pcnt > 0 THEN
   raise_application_error (-20001, '��������� ��� ����� �������������� ����');
 END IF;
END;
/
SHOW ERRORS;


