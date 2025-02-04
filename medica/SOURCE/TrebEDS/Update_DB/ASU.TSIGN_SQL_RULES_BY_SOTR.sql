CREATE TABLE ASU.TSIGN_SQL_RULES_BY_SOTR
  (
  FK_ID NUMBER,
  FK_SIGN_SQL_RULES_ID NUMBER,
  FK_APPSOTR_ID NUMBER
 )
/
COMMENT ON TABLE ASU.TSIGN_SQL_RULES_BY_SOTR IS 
'������� ��� ����������� ���� ��������� �������������  ������ ����� ���. Author:Voronov'
/
COMMENT ON COLUMN ASU.TSIGN_SQL_RULES_BY_SOTR.FK_ID IS '����'
/
COMMENT ON COLUMN ASU.TSIGN_SQL_RULES_BY_SOTR.FK_SIGN_SQL_RULES_ID IS '������ �� ������� ��� ASU.TSIGN_SQL_RULES.FK_ID'
/
COMMENT ON COLUMN ASU.TSIGN_SQL_RULES_BY_SOTR.FK_APPSOTR_ID IS '������ �� LOGIN.TAPPSOTR.FK_ID'
/
CREATE SEQUENCE ASU.SEQ_TSIGN_SQL_RULES_BY_SOTR
/
CREATE TRIGGER ASU.TSIGN_SQL_RULES_BY_SOTR_INS
 BEFORE 
 INSERT
 ON ASU.TSIGN_SQL_RULES_BY_SOTR
 FOR EACH ROW 
begin
  if :NEW.FK_ID is null then
    select ASU.SEQ_TSIGN_SQL_RULES_BY_SOTR.NEXTVAL into :NEW.FK_ID from DUAL;
  end if;
end;
/

CREATE Unique INDEX ASU.TSIGN_SQL_RULES_BY_SOTR_UK ON ASU.TSIGN_SQL_RULES_BY_SOTR
   (  FK_ID ASC  ) 
 COMPUTE STATISTICS 
/

CREATE INDEX ASU.SIGN_RULES_BY_SOTR_FK_APPSOTR ON ASU.TSIGN_SQL_RULES_BY_SOTR
   (  FK_APPSOTR_ID ASC  ) 
 COMPUTE STATISTICS 
/

