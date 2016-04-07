DROP TRIGGER ASU.TIS_GENSTAT_WORKINGDAYS_BI
/

--
-- TIS_GENSTAT_WORKINGDAYS_BI  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SEQ_TIS_GENSTAT_WORKINGDAYS (Sequence)
--   TIS_GENSTAT_WORKINGDAYS (Table)
--
CREATE OR REPLACE TRIGGER ASU.TIS_GENSTAT_WORKINGDAYS_BI
  BEFORE INSERT
  ON ASU.TIS_GENSTAT_WORKINGDAYS   REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
BEGIN
  IF :NEW.fk_id IS NULL
  THEN
    SELECT asu.seq_TIS_GENSTAT_WORKINGDAYS.NEXTVAL
      INTO :NEW.fk_id
      FROM DUAL;
  END IF;
END;
/
SHOW ERRORS;

