ALTER TABLE MED.TKARTCO_ITEM ADD (FK_TREB_DPC_ID NUMBER)
/
COMMENT ON COLUMN MED.TKARTCO_ITEM.FK_TREB_DPC_ID IS '������ �� ���������� �� ����������, �� �������� ������� ������������'
/

CREATE INDEX MED.TKARTCO_ITEM_FK_TREB_DPC_ID ON MED.TKARTCO_ITEM
   (  FK_TREB_DPC_ID ASC  ) 
 COMPUTE STATISTICS 
/
