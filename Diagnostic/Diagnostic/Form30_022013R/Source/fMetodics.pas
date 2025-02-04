unit fMetodics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinsDefaultPainters, dxSkinsdxBarPainter, dxBar,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, OracleData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ActnList, JvDBUtils, Oracle, frxClass, frxDBSet;

type
  TfrmMetodics = class(TForm)
    dxBarDockControl1: TdxBarDockControl;
    BMMetodics: TdxBarManager;
    BMBar1: TdxBar;
    bbClose: TdxBarButton;
    TVMETODICS: TcxGridDBTableView;
    cxGrLevel1: TcxGridLevel;
    cxGr: TcxGrid;
    odsMetodics: TOracleDataSet;
    dsMetodics: TDataSource;
    VMETODICSNAME: TcxGridDBColumn;
    alMetodics: TActionList;
    aClose: TAction;
    bbAdd: TdxBarButton;
    bbDel: TdxBarButton;
    aAdd: TAction;
    aDel: TAction;
    aRefresh: TAction;
    aPrint: TAction;
    bbRefresh: TdxBarButton;
    bbPrint: TdxBarButton;
    VMETODICSFK_ID: TcxGridDBColumn;
    frxRepMetodics: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    bbCopy: TdxBarButton;
    bbPaste: TdxBarButton;
    aCopy: TAction;
    aPaste: TAction;
    procedure odsMetodicsBeforeOpen(DataSet: TDataSet);
    procedure aCloseExecute(Sender: TObject);
    procedure aAddExecute(Sender: TObject);
    procedure aDelExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure frxRepMetodicsGetValue(const VarName: string; var Value: Variant);
    procedure odsMetodicsAfterOpen(DataSet: TDataSet);
    procedure aCopyExecute(Sender: TObject);
    procedure aPasteExecute(Sender: TObject);
  private
    sSYNONIM : String;
//    pRow : String;
//    pColumn : String;
    sTableName : String;
    sSysDate_4Rep : String;

    procedure CheckExistCell(ATableName: String; ACellSynonim: String);

    { Private declarations }
  public
    procedure DoShowForm(pSYNONIM : String; ATable: String);
    { Public declarations }
  end;

var
  frmMetodics: TfrmMetodics;

implementation
uses fMain, fChooseNaz;
{$R *.dfm}


procedure TfrmMetodics.CheckExistCell(ATableName: String; ACellSynonim: String);
var
  ods: TOracleDataSet;
  q  : TOracleQuery;
  nID: Integer;
  
begin
  nID := -1;
  
  ods := TOracleDataSet.Create(nil);
  try
     ods.Session := frmMain.os;
     ods.SQL.Text := 'select fk_id from asu.ts_columnnaz where fk_owner = ASU.GET_FORM30ID and fl_del = 0 and fc_synonim = :pfc_synonim and fc_tablename = :pfc_tablename ';
     ods.DeclareAndSet('pfc_synonim', otString, ACellSynonim);
     ods.DeclareAndSet('pfc_tablename', otString, ATableName);
     ods.Open;
     if (ods.RecordCount > 0) then begin
        nID := ods.FieldByName('fk_id').AsInteger;
     end;
  finally
     ods.Close;
     ods.Free;
  end;


  if (nID = -1) then begin
     q := TOracleQuery.Create(nil);
     try
        q.Session := frmMain.os;
        q.SQL.Text := 'begin ' +
                      '   insert into asu.ts_columnnaz(fc_name, fk_owner, fk_smid, fl_del, fc_synonim, fc_tablename) ' +
                      '        values (null, ASU.GET_FORM30ID, -1, 0, :pfc_synonim, :pfc_tablename); ' + 
                      '   commit; ' +
                      'end; ';
        q.DeclareAndSet('pfc_synonim', otString, ACellSynonim);
        q.DeclareAndSet('pfc_tablename', otString, ATableName);

        q.Execute;
     finally
        q.Free;
     end;  
  end;
end;

procedure TfrmMetodics.aAddExecute(Sender: TObject);
var oq : TOracleQuery;
begin
  Application.CreateForm(TfrmChooseNaz, frmChooseNaz);
  frmChooseNaz.DoShowForm;
  frmChooseNaz.ShowModal;
  if frmChooseNaz.ModalResult = MrOk then
    begin
      oq := TOracleQuery.Create(nil);
      try
        oq.Session := frmMain.os;
        oq.Cursor := crSQLWait;
        oq.SQL.Text := ' DELETE FROM asu.TS_COLUMNNAZ WHERE FK_OWNER IN (SELECT FK_ID FROM asu.TS_COLUMNNAZ WHERE FC_SYNONIM = :PFC_SYNONIM AND FC_TABLENAME = :PFC_TABLENAME) ';
        oq.DeclareAndSet('PFC_SYNONIM', otString, sSYNONIM);
        oq.DeclareAndSet('PFC_TABLENAME', otString, sTableName);
        oq.Execute;
        frmMain.os.Commit;

        Self.CheckExistCell(sTableName, sSYNONIM);

        frmChooseNaz.odsNazCheck.First;
        while not frmChooseNaz.odsNazCheck.Eof do begin
          if frmChooseNaz.odsNazCheck.FieldByName('FL_CHECK').AsInteger = 1 then begin
             oq.DeleteVariables;
             oq.SQL.Text := ' INSERT INTO asu.TS_COLUMNNAZ(FC_NAME, FK_OWNER, FK_SMID) '+#13+
                            ' VALUES(:pFC_NAME, (SELECT MAX(FK_ID) FROM asu.TS_COLUMNNAZ WHERE FC_SYNONIM = :PFC_SYNONIM AND FC_TABLENAME = :PFC_TABLENAME), :pFK_SMID)';
             oq.DeclareAndSet('pFC_NAME', otString, frmChooseNaz.odsNazCheck.FieldByName('FC_NAME').AsString);
             oq.DeclareAndSet('PFC_SYNONIM', otString, sSYNONIM);
             oq.DeclareAndSet('PFC_TABLENAME', otString, sTableName);
             oq.DeclareAndSet('pFK_SMID', otInteger, frmChooseNaz.odsNazCheck.FieldByName('FK_ID').AsInteger);

             oq.Execute;

             frmMain.os.Commit;
          end;
          frmChooseNaz.odsNazCheck.Next;
        end;
        RefreshQuery(odsMetodics);
      finally
        oq.Free;
      end;
    end;
  frmChooseNaz.Free;

end;

procedure TfrmMetodics.aCloseExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmMetodics.aCopyExecute(Sender: TObject);
var i : Integer;
begin
  SetLength(frmMain.arrID, 0);
  if TVMETODICS.Controller.SelectedRowCount > 1 then
    begin
      for i := 0 to TVMETODICS.Controller.SelectedRowCount -1 do
        begin
          TVMETODICS.Controller.SelectedRows[i].Focused := TRUE;
          SetLength(frmMain.arrID, length(frmMain.arrID)+1);
          frmMain.arrID[high(frmMain.arrID)] := odsMetodics.FieldByName('FK_SMID').AsInteger;
        end;
    end else
    begin
      SetLength(frmMain.arrID, length(frmMain.arrID)+1);
      frmMain.arrID[high(frmMain.arrID)] := odsMetodics.FieldByName('FK_SMID').AsInteger;
    end;
end;

procedure TfrmMetodics.aDelExecute(Sender: TObject);
var oq : TOracleQuery;
     i : Integer;
begin
  if Application.MessageBox('�� ������������� ������ ������� ��������(-�) �� ������?', '������', MB_YESNO + MB_ICONQUESTION) = MrYes then
    begin
      for I := 0 to TVMETODICS.Controller.SelectedRecordCount -1  do    // Iterate
        begin
          if TVMETODICS.DataController.Controller.SelectedRecords[I].Selected = TRUE then
            begin
              oq := TOracleQuery.Create(nil);
              try
                oq.Session := frmMain.os;
                oq.Cursor := crSQLWait;
                oq.SQL.Text := ' DELETE FROM ASU.TS_COLUMNNAZ WHERE FK_ID = :PFK_ID ';
                oq.DeclareAndSet('PFK_ID', otInteger, TVMETODICS.Controller.SelectedRecords[i].Values[VMETODICSFK_ID.Index]);
                oq.Execute;
                frmMain.os.Commit;
              finally
                oq.Free;
              end;
            end;
        end;
      RefreshQuery(odsMetodics);  
    end;
end;

procedure TfrmMetodics.aPasteExecute(Sender: TObject);
var oq : TOracleQuery;
     i : Integer;
begin
   if Length(frmMain.arrID) <= 0 then
      Exit;

   Self.CheckExistCell(sTableName, sSYNONIM);

   for i := 0 to Length(frmMain.arrID)-1 do begin
      oq := TOracleQuery.Create(nil);
      try
         oq.Session := frmMain.os;
         oq.Cursor := crSQLWait;
         oq.SQL.Text := ' INSERT INTO TS_COLUMNNAZ(FC_NAME, FK_OWNER, FK_SMID) '+
                        ' VALUES(GET_SMIDNAME(:PFK_SMID), (SELECT FK_ID FROM TS_COLUMNNAZ WHERE FC_SYNONIM = :PFC_SYNONIM AND FC_TABLENAME = :PFC_TABLENAME), :PFK_SMID) ';
         oq.DeclareAndSet('PFC_SYNONIM', otString, sSYNONIM);
         oq.DeclareAndSet('PFC_TABLENAME', otString, sTableName);         
         oq.DeclareAndSet('PFK_SMID', otInteger, frmMain.arrID[i]);
         oq.Execute;
         frmMain.os.Commit;
         RefreshQuery(odsMetodics);
      finally
         oq.Free;
      end;
    end;
end;

procedure TfrmMetodics.aPrintExecute(Sender: TObject);
var ods : TOracleDataSet;
begin
  ods := TOracleDataSet.Create(nil);
  try
    ods.Session := frmMain.os;
    ods.Cursor := crSQLWait;
    ods.SQL.Text := 'SELECT TO_CHAR(SYSDATE, ''DD.MM.YYYY HH24:MI'') AS DATESYS FROM DUAL';
    ods.Open;
    sSysDate_4Rep := ods.FieldByName('DATESYS').AsString;
  finally
    ods.Free;
  end;
  frxRepMetodics.ShowReport;
end;

procedure TfrmMetodics.aRefreshExecute(Sender: TObject);
begin
  RefreshQuery(odsMetodics);
end;

procedure TfrmMetodics.DoShowForm(pSYNONIM: String; ATable: String);
begin
  sSYNONIM := pSYNONIM;
  sTableName := ATable;

  if (not odsMetodics.Active) then
     odsMetodics.Open;
end;

procedure TfrmMetodics.frxRepMetodicsGetValue(const VarName: string;
  var Value: Variant);
begin
  if VarName = 'COMPANYNAME' then Value := frmMain.sCompanyName;
  if VarName = 'OTDELNAME' then Value := frmMain.sOtdelName;
  if VarName = 'NAMETABLE' then Value := sTableName;
  if VarName = 'CELL' then Value := sSYNONIM;
  if VarName = 'SYSDATE' then Value := sSysDate_4Rep;
  if VarName = 'SOTRNAME' then Value := frmMain.sVrachFIO;
  if VarName = 'KOLVO' then Value := odsMetodics.RecordCount;
  if VarName = 'MEDOTRADESIGN' then Value := frmMain.MedotradeSign;
end;

procedure TfrmMetodics.odsMetodicsAfterOpen(DataSet: TDataSet);
begin
  aDel.Enabled := odsMetodics.RecordCount <> 0;
  aPrint.Enabled := odsMetodics.RecordCount <> 0;
  aCopy.Enabled := odsMetodics.RecordCount <> 0;
end;

procedure TfrmMetodics.odsMetodicsBeforeOpen(DataSet: TDataSet);
begin
  odsMetodics.SetVariable('PFC_SYNONIM', sSYNONIM);
end;

end.
