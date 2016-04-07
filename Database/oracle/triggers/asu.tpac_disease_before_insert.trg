DROP TRIGGER ASU.TPAC_DISEASE_BEFORE_INSERT
/

--
-- TPAC_DISEASE_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SEQ_TPAC_DISEASE (Sequence)
--   TPAC_DISEASE (Table)
--
CREATE OR REPLACE TRIGGER ASU."TPAC_DISEASE_BEFORE_INSERT" 
BEFORE INSERT
ON ASU.TPAC_DISEASE REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
Begin
  SELECT SEQ_TPAC_DISEASE.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;

