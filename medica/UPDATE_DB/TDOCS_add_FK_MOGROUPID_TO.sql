alter table med.TDOCS add FK_MOGROUPID_TO NUMBER(10) default 0;
-- Foreign Key
ALTER TABLE med.TDOCS ADD CONSTRAINT TDOCS_FK_MOGROUPID_TO FOREIGN KEY (FK_MOGROUPID_TO)
REFERENCES MED.TMO_GROUP (GROUPID) ON DELETE SET NULL DISABLE NOVALIDATE;
COMMENT ON COLUMN med.TDOCS.FK_MOGROUPID_TO is '������ ���. ���., ��� ������� ������������ �������� (TMO_GROUP)';
