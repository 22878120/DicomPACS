alter table med.tmo add FK_CURMOGROUPID NUMBER(10) default 0;
-- Foreign Key
ALTER TABLE med.tmo
ADD CONSTRAINT FK_CURMOGROUPID FOREIGN KEY (FK_CURMOGROUPID)
REFERENCES MED.TMO_GROUP (GROUPID) ON DELETE SET NULL
DISABLE NOVALIDATE;
COMMENT ON COLUMN med.tmo.FK_CURMOGROUPID is '������� ������ ���. ���.';