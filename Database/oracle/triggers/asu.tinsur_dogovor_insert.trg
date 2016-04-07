DROP TRIGGER ASU.TINSUR_DOGOVOR_INSERT
/

--
-- TINSUR_DOGOVOR_INSERT  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SEQ_TDOGOVOR (Sequence)
--   TINSUR_DOGOVOR (Table)
--
CREATE OR REPLACE TRIGGER ASU.TINSUR_DOGOVOR_INSERT
  BEFORE INSERT ON ASU.TINSUR_DOGOVOR   REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
BEGIN
  --SELECT SEQ_TINSUR_PROGRAMM.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
  SELECT ASU.SEQ_TDOGOVOR.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
END TINSUR_DOGOVOR_INSERT;
/
SHOW ERRORS;

