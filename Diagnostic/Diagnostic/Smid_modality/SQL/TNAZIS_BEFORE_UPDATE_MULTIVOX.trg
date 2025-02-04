CREATE OR REPLACE TRIGGER ASU.TNAZIS_BEFORE_UPDATE_MULTIVOX
 BEFORE 
 UPDATE
 ON ASU.TNAZIS
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
DECLARE
  sMODULENAME VARCHAR2(100);
  sGUID VARCHAR2(36);
  nOwner NUMBER;
BEGIN
  SELECT PROGRAM INTO sMODULENAME
    FROM V$SESSION
   WHERE SID=USERENV('SID');
-->> 1. ��������� ���������� �� ��������� ����� ������ ��������
  IF ( asu.get_tnazis_mod(:OLD.FK_SMID) is not null ) or
     (sMODULENAME = 'List_xrays_lab.exe') OR
     (sMODULENAME = 'List_xrays_vrach.exe') OR
     (sMODULENAME = 'RgRegistr.exe') OR
     (sMODULENAME = 'TestMultiVox.exe') THEN
    sGUID := NEW_UUID;
    INSERT INTO ASU."DbConnector"("oID", "UID", "Source", "Destination", "ContentType", "Message", "SendTime", "ExchangeTime", "NazID")
    VALUES(LOWER(NEW_UUID), LOWER(sGUID), 'MIS', 'RIS', NULL,
           ASU.SET_CLOB_MULTIVOX(:NEW.FK_ID,
                                 :NEW.FK_PACID,
                                 :NEW.FK_VRACHID,
                                 :NEW.FD_RUN, 
                                 :NEW.FC_TYPE,
                                 :NEW.FK_SMID,
                                 :NEW.FK_ISPOLID,
                                 :NEW.FK_ROOMID,
                                 sGUID,
                                 :NEW.FK_NAZSOSID,
                                 'XO'),
           systimestamp, to_date('01.01.1900', 'dd.mm.yyyy'), :NEW.FK_ID);
  else
    select fk_owner into nOwner from asu.tsmid where fk_id = :new.fk_smid;
    if nOwner = asu.get_endoscop_issl then
      if :new.fk_nazsosid <> asu.get_pass_registrator then
        sGUID := NEW_UUID;
        INSERT INTO ASU."DbConnector"("oID", "UID", "Source", "Destination", "ContentType", "Message", "SendTime", "ExchangeTime", "NazID")
        VALUES(LOWER(NEW_UUID), LOWER(sGUID), 'MIS', 'RIS', NULL,
               ASU.SET_CLOB_MULTIVOX(:NEW.FK_ID,
                                     :NEW.FK_PACID,
                                     :NEW.FK_VRACHID,
                                     :NEW.FD_RUN,
                                     :NEW.FC_TYPE,
                                     :NEW.FK_SMID,
                                     :NEW.FK_ISPOLID,
                                     :NEW.FK_ROOMID,
                                     sGUID,
                                     :NEW.FK_NAZSOSID,
                                     'XO'),
               systimestamp, to_date('01.01.1900', 'dd.mm.yyyy'), :NEW.FK_ID);
      end if;
    end if;
  END IF;
END;
/
