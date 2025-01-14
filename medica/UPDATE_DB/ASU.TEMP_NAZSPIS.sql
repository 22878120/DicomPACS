DROP TABLE ASU.TMP_NAZSPIS;
CREATE GLOBAL TEMPORARY TABLE ASU.TMP_NAZSPIS
  (
  LEVEL_NUM NUMBER,
  FK_ID VARCHAR2 (30),
  FK_PARENT VARCHAR2 (30),
  FC_MOVENAME VARCHAR2 (50),
  FC_MEDIC_NAME VARCHAR2 (500),
  FN_MEDIC_KOL NUMBER,
  FC_MEDIC_EI VARCHAR2 (20),
  FC_FROM VARCHAR2 (100),
  FC_TO VARCHAR2 (100),
  FD_DATE_MOVE DATE,
  FD_GODEN DATE,
  FC_SERIAL VARCHAR2 (50),
  FK_PACID NUMBER,
  FK_VRACHID NUMBER,
  FK_NM_ID NUMBER,
  FK_NML_ID NUMBER,
  FC_PAC_FIO VARCHAR2(100),  
  FC_VIDANO_PAC VARCHAR2(20),
  DATE_PMS_GIVEN_TO_PAC DATE
 )
 ON COMMIT PRESERVE ROWS 
/


COMMENT ON COLUMN ASU.TMP_NAZSPIS.LEVEL_NUM IS '����� ������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FK_ID IS '��� ���������� ������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FK_PARENT IS '��� ���������� ������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_MOVENAME IS '�������� ��������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_MEDIC_NAME IS '�������� �����������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FN_MEDIC_KOL IS '���-�� �����������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_MEDIC_EI IS '��. ���������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_FROM IS '�� ����'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_TO IS '����'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FD_DATE_MOVE IS '����� ���� ��������� ��������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FD_GODEN IS '���� �������� ����������� �����������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_SERIAL IS '����� ����������� �����������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FK_PACID IS 'ID ����'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FK_VRACHID IS 'ID �����'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FK_NM_ID IS '������ �� ASU.TNAZMED.FK_ID'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FK_NML_ID IS '������ �� ASU.TNAZMEDLECH.FK_ID'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_PAC_FIO IS '��� ��������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.FC_VIDANO_PAC IS '�������, �������� ������'
/
COMMENT ON COLUMN ASU.TMP_NAZSPIS.DATE_PMS_GIVEN_TO_PAC IS '���� ������ ��������'
/
