DROP TRIGGER ASU.TNAZMED_BEFORE_DELETE
/

--
-- TNAZMED_BEFORE_DELETE  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   TNAZMED (Table)
--   TNAZMEDLECH (Table)
--   TNAZMEDLECHVID (Table)
--   TNAZMED_PARAM (Table)
--   TPRIEMNAZ (Table)
--
CREATE OR REPLACE TRIGGER ASU."TNAZMED_BEFORE_DELETE" 
 BEFORE  DELETE  ON ASU.TNAZMED  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
BEGIN
  DELETE FROM TNAZMEDLECHVID WHERE TNAZMEDLECHVID.FK_NAZMEDLECHID IN (SELECT FK_ID FROM TNAZMEDLECH WHERE FK_NAZMEDID = :OLD.FK_ID); /*������� ����� ������ ����������*/
  DELETE FROM TNAZMEDLECH WHERE FK_NAZMEDID = :OLD.FK_ID; /*������� ����������� ����������*/
  DELETE FROM TNAZMED_PARAM WHERE FK_TNAZMEDID = :OLD.FK_ID; /*������� ��������� ��� ��������������� ����������*/

  DELETE FROM TPRIEMNAZ WHERE FK_NAZID=:OLD.FK_ID AND FK_PARENTID=:OLD.FK_OSMOTRID; /*������� �� �������� �������*/ /*ADDED BY X-SIDE 16.02.06*/
END TNAZMED_BEFORE_DELETE;
/
SHOW ERRORS;


