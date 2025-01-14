DROP TRIGGER ASU.TPERIODS_BEFORE_INSERT
/

--
-- TPERIODS_BEFORE_INSERT  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SEQ_TPEOPLES (Sequence)
--   TPERIODS (Table)
--
CREATE OR REPLACE TRIGGER ASU."TPERIODS_BEFORE_INSERT" 
  BEFORE INSERT ON ASU.TPERIODS   REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW-- by TimurLan


-- ��� �������� ������������� �������� �������������� ��������� ��������� ���������� aTrigger.exe ��:20.09.2005 23:15:17
BEGIN
  IF (USERENV('CLIENT_INFO') is null) or (USERENV('CLIENT_INFO') <> '%MAIL%') THEN
    BEGIN
    -- ORIGINAL TRIGGER BODY BEGIN FROM HERE:

Begin
  SELECT SEQ_TPEOPLES.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
  /*begin
    SELECT TRUNC(NVL(TPERIODS.FD_DATE2,TPERIODS.FD_DATE1))+1 INTO :NEW.FD_DATE1 FROM TPERIODS WHERE FK_ID = (SELECT MAX(FK_ID) FROM TPERIODS WHERE FK_PEPLID = :NEW.FK_PEPLID);
  exception when others then
    SELECT SYSDATE INTO :NEW.FD_DATE1 FROM DUAL;
  end;*/
End;

    -- ORIGINAL TRIGGER BODY ENDS HERE
    END;
  END IF;
END;
/
SHOW ERRORS;


