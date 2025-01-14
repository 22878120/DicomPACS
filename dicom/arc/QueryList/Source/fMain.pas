unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DCM_Client, DCM_Attributes, ComCtrls, StdCtrls, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxControls, cxContainer, cxEdit, cxLabel, cxGroupBox, Menus,
  cxLookAndFeelPainters, cxButtons, ExtCtrls, ActnList, Registry, cxSplitter,
  cxGraphics, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, dxmdaset,
  dxSkinsdxBarPainter, ImgList, dxBar, cxGridExportLink, frxClass, frxDBSet,
  cxCheckBox, DateUtils, dxSkinOffice2007Green,
  KXString, KXServerCore, DCM_Server, DCM_Connection, dxSkinBlack, 
  dxBarExtItems, dxSkinOffice2007Black, IniFiles, Medotrade, cxPC;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    cxGroupBox1: TcxGroupBox;
    AL: TActionList;
    aClose: TAction;
    aFind: TAction;
    cxLabel9: TcxLabel;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    teHost: TcxTextEdit;
    tePort: TcxTextEdit;
    teCalled: TcxTextEdit;
    teCalling: TcxTextEdit;
    cxSplitter1: TcxSplitter;
    dxMemData1: TdxMemData;
    dxMemData1Patient: TStringField;
    dxMemData1Number: TStringField;
    dxMemData1Date: TDateField;
    BM: TdxBarManager;
    Panel2: TPanel;
    dxBarDockControl1: TdxBarDockControl;
    cxGr: TcxGrid;
    TV: TcxGridTableView;
    VPAC: TcxGridColumn;
    VNUMBER: TcxGridColumn;
    VDATE: TcxGridColumn;
    cxGrLevel1: TcxGridLevel;
    BMBar1: TdxBar;
    dxBarButton1: TdxBarButton;
    dxBarButton3: TdxBarButton;
    IL: TImageList;
    aRefresh: TAction;
    aPrint: TAction;
    aSnimok: TAction;
    pmTV: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    aText: TAction;
    aWeb: TAction;
    aXML: TAction;
    aExcel: TAction;
    N4: TMenuItem;
    Web1: TMenuItem;
    XML1: TMenuItem;
    Excel1: TMenuItem;
    sdPopUp: TSaveDialog;
    bbClose: TdxBarButton;
    frxRep: TfrxReport;
    frxDB: TfrxDBDataset;
    cxLabel2: TcxLabel;
    teFam: TcxTextEdit;
    cxLabel7: TcxLabel;
    deBorn: TcxDateEdit;
    cxLabel3: TcxLabel;
    cbSex: TcxComboBox;
    cxLabel4: TcxLabel;
    cbType: TcxComboBox;
    cxLabel10: TcxLabel;
    teSotr: TcxTextEdit;
    cxLabel8: TcxLabel;
    teDesc: TcxTextEdit;
    paDates: TPanel;
    deBegin: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEnd: TcxDateEdit;
    bPeriod: TcxButton;
    cbDates: TcxCheckBox;
    cxLabel5: TcxLabel;
    cxLabel11: TcxLabel;
    cbPeriod: TcxComboBox;
    bToday: TcxButton;
    bYesterday: TcxButton;
    bClearFilter: TcxButton;
    VSTUDYID: TcxGridColumn;
    dxMemData1StudyID: TStringField;
    VACNUMBER: TcxGridColumn;
    dxMemData1AcNumber: TStringField;
    VMODALITY: TcxGridColumn;
    dxMemData1Modality: TStringField;
    VDESC: TcxGridColumn;
    dxMemData1Desc: TStringField;
    VSTUDYUID: TcxGridColumn;
    dxMemData1STUDYUID: TStringField;
    dxBarButton4: TdxBarButton;
    cxLabel15: TcxLabel;
    teLocalPort: TcxTextEdit;
    dxMemData1SERIESUID: TStringField;
    SERIESUID: TcxGridColumn;
    PopupMenu1: TPopupMenu;
    dxBarPopupMenu1: TdxBarPopupMenu;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    DicomServerCore1: TDicomServerCore;
    cxTextEdit1: TcxTextEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    dxBarButton2: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton9: TdxBarButton;
    AVideoCapt: TAction;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    actMAH1: TAction;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarButton12: TdxBarButton;
    aKIN: TAction;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton13: TdxBarButton;
    bsSeparator11: TdxBarSeparator;
    cxECHO: TcxButton;
    tePortStore: TcxTextEdit;
    cxLabel18: TcxLabel;
    dxBarButton14: TdxBarButton;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
    teNum: TcxTextEdit;
    dxBarButton15: TdxBarButton;
    aCD: TAction;
    cxTabSheet4: TcxTabSheet;
    cxLabel1: TcxLabel;
    teWLHost: TcxTextEdit;
    cxLabel19: TcxLabel;
    teWLPort: TcxTextEdit;
    cxLabel20: TcxLabel;
    teWLCalled: TcxTextEdit;
    cxLabel21: TcxLabel;
    teWLCalling: TcxTextEdit;
    cxButton1: TcxButton;
    Panel3: TPanel;
    cxGrid2: TcxGrid;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxFld_P_ENAME: TcxGridDBColumn;
    cxFld_P_DATEBORN: TcxGridDBColumn;
    cxFld_Modality: TcxGridDBColumn;
    cxFld_StationAETitle: TcxGridDBColumn;
    cxFld_StartDateWorklist: TcxGridDBColumn;
    cxFld_StepStartTime: TcxGridDBColumn;
    cxFld_StudyUID: TcxGridDBColumn;
    cxFld_P_PID: TcxGridDBColumn;
    cxGrid2Level1: TcxGridLevel;
    cxGroupBox6: TcxGroupBox;
    cxLabel22: TcxLabel;
    deStartDateWorklist: TcxDateEdit;
    cxLabel23: TcxLabel;
    deEndDateWorklist: TcxDateEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure aFindExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure teNumKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure teFamKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cxSplitter1BeforeClose(Sender: TObject; var AllowClose: Boolean);
    procedure cxSplitter1BeforeOpen(Sender: TObject; var NewSize: Integer;
      var AllowOpen: Boolean);
    procedure aSnimokExecute(Sender: TObject);
    procedure TVCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure aRefreshExecute(Sender: TObject);
    procedure aTextExecute(Sender: TObject);
    procedure aWebExecute(Sender: TObject);
    procedure aXMLExecute(Sender: TObject);
    procedure aExcelExecute(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure frxRepGetValue(const VarName: string; var Value: Variant);
    procedure N3Click(Sender: TObject);
    procedure bPeriodClick(Sender: TObject);
    procedure teDescKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure teSotrKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure teSotrClick(Sender: TObject);
    procedure teSotrEnter(Sender: TObject);
    procedure teFamClick(Sender: TObject);
    procedure teFamEnter(Sender: TObject);
    procedure cbDatesPropertiesEditValueChanged(Sender: TObject);
    procedure bYesterdayClick(Sender: TObject);
    procedure bTodayClick(Sender: TObject);
    procedure cbPeriodPropertiesEditValueChanged(Sender: TObject);
    procedure bClearFilterClick(Sender: TObject);
    procedure dxBarButton5Click(Sender: TObject);
    procedure dxBarButton6Click(Sender: TObject);
    procedure dxBarButton7Click(Sender: TObject);
    procedure DicomServerCore1DicomImage(AClientThread: TDicomClientThread;
      AAddress: string; ADataset: TDicomDataset);
    procedure AVideoCaptExecute(Sender: TObject);
    procedure actMAH1Execute(Sender: TObject);
    procedure aKINExecute(Sender: TObject);
    procedure cxECHOClick(Sender: TObject);
    procedure dxBarButton14Click(Sender: TObject);
    procedure aCDExecute(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    nDates : Integer;
    Russian : HKL; // ��� ������������ ���������
    procedure AddListGridItem(pDA: TDicomAttributes);
    procedure CheckEnabledButtons;
    { Private declarations }
    procedure DoShowFormMOVE(  const p_PATIENT : string;
                               const p_STUDYUID: string;
                               const p_VSTUDYID: string;
                               const p_SERIES  : string;
                               const p_ACCESSIONNUMBER : string;
                               const sLevel : string  );
  public
//    bCancel : Boolean;
    sUser : string;
    sCallingAETitle,
    sCalledAETitle : string;
    MWLReceiveDatasets: TList;
  end;

var
  frmMain: TfrmMain;
  v_debug : boolean; // ������� �������
  v_hkKadr,
  v_hkStartVideo,
  v_hkStopVideo   : Word;
  s_hkKadr,
  s_hkStartVideo,
  s_hkStopVideo   : string;

  v_ds_i:Integer;

  v_teHost      : string ;  // ������:
  v_tePort      : string ;  // ���� QUERY:
  v_tePortStore : string ;  // ���� STORE:
  v_teCalled    : string ;  // Called AE Title:
  v_teCalling   : string ;  // Calling AE Title:
  v_teLocalPort : string ;  // ��������� ����:

const v_is_ds_log = True;
      v_is_log    = True;
      c_delim = '-------------------------------------------------------------------------------';
      c_ini_file = 'querylist.ini';
      c_mn_log_file = 'dcmevents.log';
      c_events_log = 'events.log';

      c_rzd = 'MAIN';
      c_section_is_debug = 'DEBUG(1-on,0-off)';
      chkKadr       = '��� ������� �����';
      chkStartVideo = '��� ������ ������� �����';
      chkStopVideo  = '��� ���� ������� �����';

implementation

uses fSnimok, uPeriod, DCM_Dict, UnFrmProgressBar, CmnUnit, DICOM_CMN,
     fCapture, UnAbout, fCD, fSettings;

{$R *.dfm}

// ��������� ����������� studyid, studyuid
// �� accessionNumber
// ���� ������� ��������� ������� - ���������� ������ �� ���������
// ������������ �������� - true - �������� ������  false - ������
function p_studyid_fnd ( const p_accessionNumber : string;
                         const p_PatientID : string;
                         const p_StudyDate : string;
                          const p_host : string;
                          const p_port : string;
                          const p_CalledAET : string;
                          const p_CallingAET : string;
                          var p_amm_rec : Integer;
                          var p_studyid : string;
                          var p_studyuid : string
                        ):boolean;
var //v_ReceiveDatasets: TList;
    DA, DA1: TDicomAttributes;
  //  DateRange: TDicomAttribute;
    i: Integer; v_res : Boolean;
    CnsDicomConnection1: TCnsDicomConnection;
begin

  try
    CnsDicomConnection1.Host := p_host;
    CnsDicomConnection1.Port := StrToInt(p_port);
    CnsDicomConnection1.CalledTitle := p_CalledAET;
    if p_CallingAET <> '' then
      CnsDicomConnection1.CallingTitle := p_CallingAET;

    DA := TDicomAttributes.Create;

    DA.AddVariant(dQueryRetrieveLevel, 'STUDY' ); //    'PATIENT' 'STUDY' 'SERIES' 'IMAGES'
  //  DA.AddVariant(dAccessionNumber, p_accessionNumber) ; // dAccessionNumber  // Add($0008, $0050);  // , tSH, 'AccessionNumber', '1');
    DA.Add($0020, $000D); // dStudyInstanceUID
    // DA.Add($0020, $000E); // dSeriesInstanceUID
    DA.Add($0020, $0010); // dStudyID
    //
//    DA.AddVariant($0010, $0020, p_PatientID); // PatientID
//    DA.AddVariant($0008, $0020, p_StudyDate); // ](StudyDate)DA=<0>NULL
    //
{    DA.Add($0008, $0030); // ](StudyTime)TM=<0>NULL
    DA.Add($0008, $0061); // ](ModalitiesInStudy)CS=<0>NULL
    DA.Add($0008, $1030); // ](StudyDescription)LO=<0>NULL
    DA.Add($0010, $0010); // ](PatientName)PN=<0>NULL
    DA.Add($0010, $1010); // ](PatientAge)AS=<1>*
    DA.Add($0010, $1030); // ](PatientWeight)DS=<1>,00
    DA.Add($0020, $1208); // ](NumberOfStudyRelatedImages)IS=<0>NULL
    DA.Add($0088, $0130); // ](StorageMediaFilesetID)SH=<0>NULL
}    //

{
receive Command: 64[0008:0020](StudyDate)DA=<0>NULL
receive Command: 70[0008:0030](StudyTime)TM=<0>NULL
receive Command: 78[0008:0052](QueryRetrieveLevel)CS=<1>STUDY
receive Command: 82[0008:0061](ModalitiesInStudy)CS=<1>AS
receive Command: 95[0008:1030](StudyDescription)LO=<0>NULL
receive Command: 147[0010:0010](PatientName)PN=<0>NULL
receive Command: 148[0010:0020](PatientID)LO=<1>123
receive Command: 157[0010:1010](PatientAge)AS=<1>*
receive Command: 159[0010:1030](PatientWeight)DS=<1>,00
receive Command: 425[0020:000D](StudyInstanceUID)UI=<0>NULL
receive Command: 427[0020:0010](StudyID)SH=<0>NULL
receive Command: 457[0020:1208](NumberOfStudyRelatedImages)IS=<0>NULL
receive Command: 697[0088:0130](StorageMediaFilesetID)SH=<0>NULL
}

    //
    DA.Sort;
    //
    if v_debug then
      ds_sav(DA,nil,nil,'find_rec_move');
    //
    v_res:=False;
    if CnsDicomConnection1.C_FIND(DA) = True then
    begin
        v_res:=True;
        p_amm_rec:=CnsDicomConnection1.ReceiveDatasets.Count;
        //
        MnLg_ev( '���������� C_MOVE ������� '+inttostr(p_amm_rec)+' �������',
                 ExtractFilePath(paramstr(0))+c_mn_log_file,
                 False
               );
        //
        if p_amm_rec > 0 then
        begin
          for i := 0 to CnsDicomConnection1.ReceiveDatasets.Count - 1 do
          begin
            DA1 := TDicomAttributes(CnsDicomConnection1.ReceiveDatasets[i]);
            if (Trim(DA1.GetString($0008, $0050))=Trim(p_accessionNumber)) then
            begin
              p_studyid  := DA1.GetString(dStudyID);
              p_studyuid := DA1.GetString(dStudyInstanceUID);
              Break;
            end;
          end;
          CnsDicomConnection1.ReceiveDatasets.Clear;
        end
        else
        begin
          p_amm_rec:=0;
        end;
      CnsDicomConnection1.Clear;
      CnsDicomConnection1.Disconnect;
    end;
  finally
    MyDisconnectAssociation(CnsDicomConnection1);
    CnsDicomConnection1.Free;
    Application.ProcessMessages;
    Sleep(100);
  end;
  p_studyid_fnd:=v_res;
end;

procedure TfrmMain.aCDExecute(Sender: TObject);
var CnsDicomConnection1 : TCnsDicomConnection; vDirTmp : string; i:integer;
begin  // �������� DICOM CD
  Application.CreateForm(TfrmCD, frmCD);
  try
    frmCD.vParentForm     := 3;
    vDirTmp := GetTempDirectory+'\Dicom';
    if not DirectoryExists(vDirTmp) then CreateDir(vDirTmp);
    frmCD.lDir.Caption    := vDirTmp;
    frmCD.lbDir.Directory := vDirTmp;
    frmCD.vCDDir := vDirTmp;
    frmCD.v_DataSet:=dxMemData1;
    frmCD.lKolvo.Caption := IntToStr(TV.DataController.RecordCount);
    frmCD.v_DataSet.First;
    while not frmCD.v_DataSet.EOf do
    begin
      frmCD.vStudyUIDList.Append( frmCD.v_DataSet.FieldByName('STUDYUID').AsString );
      frmCD.v_DataSet.Next;
    end;
    //
    frmCD.vCnsDicomConnectionHost           := teHost.Text ;
    frmCD.vCnsDicomConnectionCalledTitle    := teCalled.Text ;
    if not TryStrToInt(tePort.Text,frmCD.vCnsDicomConnectionPort) then frmCD.vCnsDicomConnectionPort := 0 ;
    frmCD.vCnsDicomConnectionCallingAETitle := teCalling.Text ;
    //
    frmCD.ShowModal;
  finally
    frmCD.Free;
  end;
end;

procedure TfrmMain.aCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actMAH1Execute(Sender: TObject);
var v_str : TStringList;
    v_amm_res, i :Integer;
  //  v_studyUID :string;
begin // ���� MAKHAON
   if frmMain.teHost.Text = '' then
    begin
      MessageDlg('�� �� ������ ������������� ����������� � �������!'+#13+#10+
                 '�� ���������� IP-����� �������!', mtWarning, [mbOK], 0);
      frmMain.teHost.SetFocus;
      Exit;
    end;
  if frmMain.tePort.Text = '' then
    begin                        
      MessageDlg('�� �� ������ ������������� ����������� � �������!'+#13+#10+
                 '�� ���������� ���� ���������� � ��������!', mtWarning, [mbOK], 0);
      frmMain.tePort.SetFocus;
      Exit;
    end;
  try
    v_str := TStringList.Create;
    // -------------------------------------------------------------------------
    v_amm_res:=0;
    v_str.Clear;
    Screen.Cursor := crHourGlass;
    // ����� �� N ���������
    gt_studyUID_lst ( cxTextEdit1.Text, //'2721-08',     '001'
                      frmMain.teHost.Text,
                      MyStrToInt(frmMain.tePort.Text),
                      frmMain.teCalled.Text,
                      frmMain.teCalling.Text,
                      v_str,
                      v_amm_res
                    );
    if v_amm_res=0 then
    begin
      // �������������� �������� - ����� ���-�� ��������
    //  FrmProgressBar.MySetText('����� �� ������ ���.�����');
      // �� ����� - c_find �� ������ ���.�����
      gt_studyUID_lst ( teNum.Text, // ��� ����    '2721-08'
                        frmMain.teHost.Text,
                        MyStrToInt(frmMain.tePort.Text),
                        frmMain.teCalled.Text,
                        frmMain.teCalling.Text,
                        v_str,
                        v_amm_res
                      );
    end;
    if v_amm_res=0 then begin  // ��������� �� ������
      chk_close; // ������� ��������
      MessageDlg('������ �� ������� ...', mtInformation, [mbOK], 0);
    end else begin
      // ���� ����� - c_move �� ���������� ������ studyUID
      // �������� �����
      Application.CreateForm(TfrmSnimok, frmSnimok);
      frmSnimok.v_Host := frmMain.teHost.Text;
      frmSnimok.v_Port := StrToInt(frmMain.tePort.Text);
      frmSnimok.v_CalledTitle := frmMain.teCalled.Text;
      frmSnimok.v_CallingTitle := frmMain.teCalling.Text;
      //
      // �������� ��������
      Application.CreateForm(TFrmProgressBar, FrmProgressBar);
      // ������ c_move
      frmMain.DicomServerCore1.Stop;
      Application.ProcessMessages;
      Sleep(100);
      frmMain.DicomServerCore1.ServerPort:=MyStrToInt(frmMain.teLocalPort.Text);
      //
      // �������������� �������� - ����� ���-�� ��������
      FrmProgressBar.clc_pos( True,
                              '�������� ������������',      // ���������
                              v_str.Count,
                              (v_str.Count=1)
                            );
      FrmProgressBar.clc_posMain( 0,
                                  '�������� �����������',
                                  (v_str.Count=1)
                                );
      for I := 0 to v_str.Count - 1 do begin
        try
          CmnUnit.v_exit_progressbar:=0;
          FrmProgressBar.MyIncPosMain('�������� ������������ '+inttostr(i+1)+'/'+inttostr(v_str.Count));
          frmMain.DicomServerCore1.Start;
          gt_list_for_studyUIDs ( v_str[i],
                                  frmMain.teHost.Text,
                                  MyStrToInt(frmMain.tePort.Text),
                                  MyStrToInt(frmMain.teLocalPort.Text),
                                  frmMain.teCalled.Text,
                                  frmMain.teCalling.Text,
                                  FrmProgressBar,
                                  (v_str.Count=1)
                                );
        finally
          frmMain.DicomServerCore1.stop;
          Application.ProcessMessages;
          Sleep(100);
        end;
      end;
      chk_close; // ������� ��������
      if CmnUnit.v_exit_progressbar=2 then begin
        try
          frmSnimok.ShowModal;
        finally
          FreeAndNil(frmSnimok);
        end;
      end;
    end;
  finally
    screen.cursor := crDefault;
    FreeAndNil(v_str);
  end;
end;
procedure TfrmMain.AddListGridItem(pDA: TDicomAttributes);
//var v_s:AnsiString;// i:Integer;
begin
  TV.BeginUpdate;
  TV.DataController.RecordCount := TV.DataController.RecordCount + 1;
  with TV.DataController do
  begin
    try
      Values[TV.DataController.RecordCount - 1, VPAC.Index] := pDA.GetString(dPatientName); // pDA.GetString($10, $10); // Patient's Name
      Values[TV.DataController.RecordCount - 1, VNUMBER.Index] := pDA.GetString(dPatientID);    // pDA.GetString($10, $20); // Patient ID (� ��� ��� ����� ������������)
      Values[TV.DataController.RecordCount - 1, VDATE.Index] := pDA.GetString(dStudyDate);      // pDA.GetString($8, $20); // ���� ���������� ������������
      Values[TV.DataController.RecordCount - 1, VSTUDYID.Index] := pDA.GetString(dStudyID);     // pDA.GetString($20, $10); // StudyID
      Values[TV.DataController.RecordCount - 1, VACNUMBER.Index] := pDA.GetString(dAccessionNumber);     // pDA.GetString($8, $50); //
      //
      if pDA.GetString(dModality)<>'' then begin
        Values[TV.DataController.RecordCount - 1, VMODALITY.Index] := pDA.GetString(dModality);   // pDA.GetString($08, $61); // �����������
      end else begin
        Values[TV.DataController.RecordCount - 1, VMODALITY.Index] := pDA.GetString(dModalitiesInStudy);   // pDA.GetString($08, $61); // �����������
      end;
      //
      Values[TV.DataController.RecordCount - 1, VDESC.Index] := pDA.GetString(dStudyDescription);       // pDA.GetString($8, $1030); // Study Description
      Values[TV.DataController.RecordCount - 1, VSTUDYUID.Index] := pDA.GetString(dStudyInstanceUID); // pDA.GetString($20, $000D); // StudyUID
      Values[TV.DataController.RecordCount - 1, SERIESUID.Index] := pDA.GetString(dSeriesInstanceUID); //
      //
      dxMemData1.Insert;
      dxMemData1.FieldByName('Patient').AsString := pDA.GetString(dPatientName); // $10, $10
      dxMemData1.FieldByName('Number').AsString := pDA.GetString(dPatientID);    //  $10, $20
      dxMemData1.FieldByName('Modality').AsString := pDA.GetString(dModality);   // $08, $61
      dxMemData1.FieldByName('Date').AsString := pDA.GetString(dStudyDate);      // $8, $20
      dxMemData1.FieldByName('StudyID').AsString := pDA.GetString(dStudyID);     // $20, $10
      dxMemData1.FieldByName('AcNumber').AsString := pDA.GetString(dAccessionNumber);    // $8, $50
      dxMemData1.FieldByName('Desc').AsString := pDA.GetString(dStudyDescription);       // $8, $1030
      dxMemData1.FieldByName('StudyUID').AsString := pDA.GetString(dStudyInstanceUID);   //$20, $000D
      dxMemData1.FieldByName('SERIESUID').AsString := pDA.GetString(dSeriesInstanceUID);   //
      dxMemData1.Post;
      //
      dxMemData1.Next;
    finally
    end;
  end;
  TV.EndUpdate;
end;

procedure TfrmMain.aExcelExecute(Sender: TObject);
begin
  sdPopUp.DefaultExt := 'xls';
  sdPopUp.Filter := '������� Excel (*.xls)|*.xls';
  if sdPopUp.Execute then
    ExportGridToExcel(sdPopUp.FileName, cxGr, TRUE, TRUE);
end;

procedure TfrmMain.aFindExecute(Sender: TObject);
var DA, DA1: TDicomAttributes;
    DateRange: TDicomAttribute;
    i: Integer;
    CnsDicomConnection1: TCnsDicomConnection;
  procedure MyWrtLogF (p_str:string);
  begin
    if v_debug then
      MnLg_ev( p_str, ExtractFilePath(paramstr(0))+c_mn_log_file, True );
  end;
begin
  if (teFam.Text = '') and (deBorn.Text = '') and (cbSex.Text = '') and (teNum.Text = '') and (cbType.Text = '')
    and (teSotr.Text = '') and (teDesc.Text = '') and (cbDates.Checked = False) then
      begin
        if Application.MessageBox('�� ����������� �� ���� ������� ������. ���� ������ ����� ������ ��������������� �����! ����������?',
                                  '��������!',
                                  MB_YESNO+MB_ICONWARNING) <> mrYes then
          begin
            Exit;
          end;
      end;
  TV.DataController.RecordCount := 0;
  dxMemData1.Close;
  dxMemData1.Open;

  MyWrtLogF( '������ C_FIND '+#13+ 'Try to connect ... ' );

  CnsDicomConnection1 := TCnsDicomConnection.Create(self);
  try
    Screen.Cursor := crHourGlass;
    CnsDicomConnection1.Host := teHost.Text;
    CnsDicomConnection1.Port := StrToInt(tePort.Text);
    CnsDicomConnection1.CalledTitle := teCalled.Text;
    if teCalling.Text <> '' then
      CnsDicomConnection1.CallingTitle := teCalling.Text;

    DA := TDicomAttributes.Create;
    with DA do
      begin
//-->> level

    MyWrtLogF('1 TDicomAttributes.Create');

        AddVariant(dQueryRetrieveLevel, 'STUDY' ); // 'STUDY' 'PATIENT'
//-->> ����� ������������ (�� �� PatientID)
        if teNum.Text <> '' then
          Add($0010, $0020).AsString[0] := teNum.Text + '%'
        else
          Add($0010, $0020); // PatientID

    MyWrtLogF('2 dQueryRetrieveLevel');

//-->> ����������� (��� ������������)
        if cbType.Text<>'' then begin
          AddVariant(dModality, cbType.Text); // Modality
          AddVariant(dModalitiesInStudy, cbType.Text); // Modality
        end else begin
          Add($0008, $0061);   // ModalitiesInStudy
          Add($0008, $0060);   // Modality
        end;


    MyWrtLogF('3 dModality');

//-->> ����
        if cbDates.Checked = True then
          begin
            daterange := Add($8, $20);
            daterange.AsDatetime[0] := deBegin.Date; // StudyDate
            daterange.AsDatetime[1] := deEnd.Date;
          end;

    MyWrtLogF('4 cbDates');

//-->> ��� ��������
        if teFam.Text <> '' then
          AddVariant(dPatientName, teFam.Text + '%')
        else
          Add($0010, $0010); // (Patient's Name)

    MyWrtLogF('5 teFam');

//-->> ��� ��������
        if cbSex.Text <> '' then
          begin
            if cbSex.Text = '�������' then
              AddVariant(dPatientSex, 'M');
            if cbSex.Text = '�������' then
              AddVariant(dPatientSex, 'F');
          end else
            Add($0010, $0040); // (Patient's Sex)

    MyWrtLogF('6 cbSex');

//-->> ���� �������� ��������
         if deBorn.Text <> '' then
           AddVariant($0010, $0030, DateTimeToStr(deBorn.Date))
         else
           Add($0010, $0030); // (Patient's Birth Date)

    MyWrtLogF('7 deBorn');

//-->> �������� ������������ (Study Description)
         if teDesc.Text <> '' then
           AddVariant($0008, $1030, teDesc.Text + '%')
         else
           Add($0008, $1030); // StudyDescription

    MyWrtLogF('8 teDesc');

//-->> ���� (Referring Physician Name)
         if teSotr.Text <> '' then
           AddVariant($0008, $0090, teSotr.Text + '%')
         else
           Add($0008, $0090); // ReferringPhysician'sName


    MyWrtLogF('9 teSotr');

         // Add($0008, $000D); - �� ����� � ��������
         Add($0008, $1090);   // ManufacturerModelName
         Add($0008, $0050);   // AccessionNumber

         Add($0020, $0010);  // dStudyID
         Add($0008, $0050);  // AccessionNumber
         Add($0020, $000D);  // StudyInstanceUID
         Add($0020, $000E);  // dSeriesInstanceUID
         Add($0008, $0020);  // StudyDate

      end;

      MyWrtLogF( 'C_FIND: '+#13+
          ' Host = '+CnsDicomConnection1.Host+#13+
          ' Port = '+IntToStr(CnsDicomConnection1.Port)+#13+
          ' CalledTitle = '+CnsDicomConnection1.CalledTitle+#13+
          ' CallingTitle = '+CnsDicomConnection1.CallingTitle );

    CnsDicomConnection1.v_is_log := True;
    CnsDicomConnection1.v_log_filename := ExtractFilePath(paramstr(0))+c_mn_log_file;

    if CnsDicomConnection1.C_FIND(DA) then
    begin
        MyWrtLogF( 'C_FIND result: receive Datasets '+IntToStr(CnsDicomConnection1.ReceiveDatasets.Count) );

      if CnsDicomConnection1.ReceiveDatasets.Count > 0 then
        begin
          for i := 0 to CnsDicomConnection1.ReceiveDatasets.Count - 1 do
          begin
              DA1 := TDicomAttributes(CnsDicomConnection1.ReceiveDatasets[i]);
              //
              if v_debug then
                ds_sav(da1,nil,nil,'record');
              //
              MWLReceiveDatasets.Add(DA1);
              AddListGridItem(DA1);
          end;
          CnsDicomConnection1.ReceiveDatasets.Clear;
        end
      else
        ShowMessage('��� ������!');
      CnsDicomConnection1.Clear;
      CnsDicomConnection1.Disconnect;
    end else
    begin
      MyWrtLogF( 'C_FIND ERROR ' );
      ShowMessage('������ �� �������! ���������� � �������������� �������!');
    end;
  finally
    CheckEnabledButtons;
    Screen.Cursor := crDefault;
    MyDisconnectAssociation(CnsDicomConnection1);
    CnsDicomConnection1.Free;
    Application.ProcessMessages;
    Sleep(100);
  end;
end;

procedure TfrmMain.aPrintExecute(Sender: TObject);
begin
  frxRep.ShowReport;
end;

procedure TfrmMain.aRefreshExecute(Sender: TObject);
begin
  aFindExecute(nil);
end;

procedure f_get ( p_key : Boolean = False );
var v_ACCESSIONNUMBER,
    v_STUDYUID,
    v_VSTUDYID,
    v_VNUMBER,
    v_VPAC,
    v_StudyDate,
    v_SERIESUID : AnsiString;
  //  i, v_amm :Integer; v_s:AnsiString;
begin
    if frmMain.teHost.Text = '' then
    begin
      MessageDlg('�� �� ������ ������������� ����������� � �������!'+#13+#10+
                 '�� ���������� IP-����� �������!', mtWarning, [mbOK], 0);
      frmMain.teHost.SetFocus;
      Exit;
    end;
  if frmMain.tePort.Text = '' then
    begin                        
      MessageDlg('�� �� ������ ������������� ����������� � �������!'+#13+#10+
                 '�� ���������� ���� ���������� � ��������!', mtWarning, [mbOK], 0);
      frmMain.tePort.SetFocus;
      Exit;
    end;
  try
    Application.CreateForm(TfrmSnimok, frmSnimok);
    frmSnimok.v_Host := frmMain.teHost.Text;
    frmSnimok.v_Port := StrToInt(frmMain.teLocalPort.Text);
    frmSnimok.v_CalledTitle := frmMain.teCalled.Text;
    frmSnimok.v_CallingTitle := frmMain.teCalling.Text;

    try
      v_SERIESUID := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.SERIESUID.Index];
    except
      v_SERIESUID:='';
    end;
    try
      v_VPAC := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VPAC.Index];
    except
      v_VPAC:='';
    end;
    try
      v_VNUMBER := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VNUMBER.Index];
    except
      v_VNUMBER:='';
    end;
    try
      v_ACCESSIONNUMBER := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VACNUMBER.Index];
    except
      v_ACCESSIONNUMBER:='';
    end;
    try
      v_StudyDate        := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VDATE.Index];
    except
      v_StudyDate:='';
    end;
    // ������ studiuid
  {  p_studyid_fnd ( v_ACCESSIONNUMBER,
                    v_VNUMBER,
                    v_StudyDate,
                    frmMain.teHost.Text,
                    frmMain.tePort.Text,
                    frmMain.teCalled.Text,
                    frmMain.teCalling.Text,
                    v_amm,
                    v_VSTUDYID,
                    v_STUDYUID
                  );  }
    //
    // -------------------------------------------------------------------------
    try
      v_VSTUDYID := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VSTUDYID.Index];
    except
      v_VSTUDYID:='';
    end;
    try
      v_STUDYUID        := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VSTUDYUID.Index];
    except
      v_STUDYUID:='';
    end;
    // -------------------------------------------------------------------------
    frmSnimok.v_Host := frmMain.teHost.Text;
    frmSnimok.v_Port := StrToInt(frmMain.tePort.Text);
    frmSnimok.v_CalledTitle := frmMain.teCalled.Text;
    frmSnimok.v_CallingTitle := frmMain.teCalling.Text;

    MnLg_ev( '������ C_GET '+#13+
           ' v_SERIESUID='+v_SERIESUID+#13+
           ' v_VPAC='+v_VPAC+#13+
           ' v_VNUMBER='+v_VNUMBER+#13+
           ' v_VSTUDYID='+v_VSTUDYID+#13+
           ' v_ACCESSIONNUMBER='+v_ACCESSIONNUMBER+#13+
           ' v_STUDYUID='+v_STUDYUID+#13+
           ' v_VSTUDYID='+v_VSTUDYID+#13+
           ' CalledTitle='+frmSnimok.v_CalledTitle+#13+
           ' CallingTitle='+frmSnimok.v_CallingTitle+#13+
           ' Host='+frmSnimok.v_Host+#13+
           ' Port='+ IntToStr(frmSnimok.v_Port)
           ,
           ExtractFilePath(paramstr(0))+c_mn_log_file,
           False
         );

      frmSnimok.DoShowFormGET(v_VNUMBER,     //  PATIENT ID
                              v_STUDYUID,   // '1.2.410.200041.2.1.2012.6.5.10.31.8.281.1', // v_STUDYUID, // STUDY
                              v_VSTUDYID,
                              v_SERIESUID,         // SERIES
                              v_ACCESSIONNUMBER, // ACCESSIONNUMBER
                              'STUDY',
                              p_key); // 'PATIENT' 'STUDY' 'SERIES'  'IMAGE'

    frmSnimok.ShowModal;
  finally
    frmSnimok.Free;
  end;
end;

procedure TfrmMain.aSnimokExecute(Sender: TObject);
begin
  f_get(False);
end;

procedure TfrmMain.aKINExecute(Sender: TObject);
begin
  f_get(True);
end;

procedure TfrmMain.aTextExecute(Sender: TObject);
begin
  sdPopUp.DefaultExt := 'txt';
  sdPopUp.Filter := '��������� ����� (*.txt)|*.txt';
  if sdPopUp.Execute then
    ExportGridToText(sdPopUp.FileName, cxGr, TRUE, TRUE);
end;

procedure TfrmMain.AVideoCaptExecute(Sender: TObject);
begin // video captute
  frmCapture := TfrmCapture.Create(self);
  try
    frmCapture.CalledAE := frmMain.teCalled.Text;
    frmCapture.Host := frmMain.teHost.Text;
    frmCapture.Port := frmMain.tePort.Text;
    frmCapture.CallingAE := frmMain.teCalling.Text;
    frmCapture.vUser := sUser ;
    frmCapture.WLCalledAE  := frmMain.teWLCalled.Text ;
    frmCapture.WLHost      := frmMain.teWLHost.Text ;
    frmCapture.WLPort      := frmMain.teWLPort.Text ;
    frmCapture.WLCallingAE := frmMain.teWLCalling.Text ;
    if frmCapture.ShowModal=mrOk then
    begin

    end;
  finally
    FreeAndNil(frmCapture);
  end;
end;

procedure TfrmMain.aWebExecute(Sender: TObject);
begin
  sdPopUp.DefaultExt := 'html';
  sdPopUp.Filter := 'Web-�������� (*.html)|*.html';
  if sdPopUp.Execute then
    ExportGridToHTML(sdPopUp.FileName, cxGr, TRUE, TRUE);
end;

procedure TfrmMain.aXMLExecute(Sender: TObject);
begin
  sdPopUp.DefaultExt := 'xml';
  sdPopUp.Filter := 'XML-�������� (*.xml)|*.xml';
  if sdPopUp.Execute then
    ExportGridToXML(sdPopUp.FileName, cxGr, TRUE, TRUE);
end;

procedure TfrmMain.bClearFilterClick(Sender: TObject);
begin
  teFam.Text := '';
  deBorn.Text := '';
  cbSex.Text := '';
  teNum.Text := '';
  cbType.Text := '';
  teSotr.Text := '';
  teDesc.Text := '';
  cbDates.Checked := False;
end;

procedure TfrmMain.bPeriodClick(Sender: TObject);
begin
  with TfrmParamDate.Create(Self) do
    begin
      if Execute then
        begin
      if ModalResult = MrOK then
        begin
          deBegin.Date := Period.First;
          deEnd.Date := Period.Last;
        end;
        end;
    Free;
  end;
end;

procedure TfrmMain.bTodayClick(Sender: TObject);
begin
//  deBegin.Properties.OnEditValueChanged := nil;
//  deEnd.Properties.OnEditValueChanged := nil;
  deBegin.Date := StartOfTheDay(Now);
  deEnd.Date := EndOfTheDay(Now);
//  deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//  deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
end;

procedure TfrmMain.bYesterdayClick(Sender: TObject);
begin
//  deBegin.Properties.OnEditValueChanged := nil; //!!!
//  deEnd.Properties.OnEditValueChanged := nil;
  deBegin.Date := StartOfTheDay(Yesterday);
  deEnd.Date := EndOfTheDay(Yesterday);
//  deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//  deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
end;

procedure TfrmMain.cbDatesPropertiesEditValueChanged(Sender: TObject);
begin
  if cbDates.Checked = True then
    begin
      paDates.Enabled := True;
      deBegin.Enabled := True;
      deEnd.Enabled := True;
      cbPeriod.Enabled := True;
      bToday.Enabled := True;
      bYesterday.Enabled := True;
      bPeriod.Enabled := True;
    end else
    begin
      paDates.Enabled := False;
      deBegin.Enabled := False;
      deEnd.Enabled := False;
      cbPeriod.Enabled := False;
      bToday.Enabled := False;
      bYesterday.Enabled := False;
      bPeriod.Enabled := False;
    end;
end;

procedure TfrmMain.cbPeriodPropertiesEditValueChanged(Sender: TObject);
begin
  case cbPeriod.ItemIndex of
  0: // ����� (���� ����� ��� � 1 ���� = ������������ ������� ����)
    begin
//      deBegin.Properties.OnEditValueChanged := nil;
//      deEnd.Properties.OnEditValueChanged := nil;
      deBegin.Date := StartOfTheDay(Now);
      deEnd.Date := EndOfTheDay(Now);
//      deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//      deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
    end;
  1: // 1 ����
    begin
//      deBegin.Properties.OnEditValueChanged := nil;
//      deEnd.Properties.OnEditValueChanged := nil;
      deBegin.Date := StartOfTheDay(Now);
      deEnd.Date := EndOfTheDay(Now);
//      deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//      deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
    end;
  2: // 3 ���
    begin
//      deBegin.Properties.OnEditValueChanged := nil;
//      deEnd.Properties.OnEditValueChanged := nil;
      deBegin.Date := StartOfTheDay(Yesterday);
      deEnd.Date := EndOfTheDay(Tomorrow);
//      deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//      deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
    end;
  3: // ������
    begin
//      deBegin.Properties.OnEditValueChanged := nil;
//      deEnd.Properties.OnEditValueChanged := nil;
      deBegin.Date := StartOfTheWeek(Now);
      deEnd.Date := EndOfTheWeek(Now);
//      deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//      deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
    end;
  4: // �����
    begin
//      deBegin.Properties.OnEditValueChanged := nil;
//      deEnd.Properties.OnEditValueChanged := nil;
      deBegin.Date := StartOfTheMonth(Now);
      deEnd.Date := EndOfTheMonth(Now);
//      deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//      deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
    end;
  5: // ���
    begin
//      deBegin.Properties.OnEditValueChanged := nil;
//      deEnd.Properties.OnEditValueChanged := nil;
      deBegin.Date := StartOfTheYear(Now);
      deEnd.Date := EndOfTheYear(Now);
//      deBegin.Properties.OnEditValueChanged := deBeginPropertiesEditValueChanged;
//      deEnd.Properties.OnEditValueChanged := deEndPropertiesEditValueChanged;
    end;
  end;
end;

procedure TfrmMain.CheckEnabledButtons;
begin
  aPrint.Enabled := dxMemData1.RecordCount <> 0;
  aSnimok.Enabled := dxMemData1.RecordCount <> 0;
  aCD.Enabled := dxMemData1.RecordCount <> 0;

  // KIN
  aKIN.Enabled := False; // dxMemData1.RecordCount <> 0;
  dxBarButton12.Visible:=ivNever;

  if dxMemData1.RecordCount <> 0 then
    dxBarButton4.Visible:=ivAlways
  else
    dxBarButton4.Visible:=ivNever;
end;

procedure TfrmMain.cxButton1Click(Sender: TObject);
var DA, DA1: TDicomAttributes;
    DateRange: TDicomAttribute;
    i: Integer;
    CnsDicomConnection1: TCnsDicomConnection;
  procedure MyWrtLogF (p_str:string);
  begin
    if v_debug then
      MnLg_ev( p_str, ExtractFilePath(paramstr(0))+c_mn_log_file, True );
  end;
begin
  CnsDicomConnection1 := TCnsDicomConnection.Create(nil);
  try
    Screen.Cursor := crHourGlass;
    CnsDicomConnection1.Host := teWLHost.Text;
    CnsDicomConnection1.Port := StrToInt(teWLPort.Text);
    CnsDicomConnection1.CalledTitle := teWLCalled.Text;
    if teWLCalling.Text <> '' then
      CnsDicomConnection1.CallingTitle := teWLCalling.Text;

      MyWrtLogF( 'C_ECHO: '+#13+
          ' Host = '+CnsDicomConnection1.Host+#13+
          ' Port = '+IntToStr(CnsDicomConnection1.Port)+#13+
          ' CalledTitle = '+CnsDicomConnection1.CalledTitle+#13+
          ' CallingTitle = '+CnsDicomConnection1.CallingTitle );

    CnsDicomConnection1.v_is_log := True;
    CnsDicomConnection1.v_log_filename := ExtractFilePath(paramstr(0))+c_mn_log_file;

    if CnsDicomConnection1.C_Echo then
    begin
      MessageDlg('OK', mtWarning, [mbOK], 0);
    end else
    begin
      MyWrtLogF( 'C_ECHO ERROR ' );
      ShowMessage('������ �� �������! ���������� � �������������� �������!');
    end;
  finally
    CheckEnabledButtons;
    Screen.Cursor := crDefault;
    MyDisconnectAssociation(CnsDicomConnection1);
    CnsDicomConnection1.Free;
    Application.ProcessMessages;
    Sleep(100);
  end;
end;

procedure TfrmMain.cxECHOClick(Sender: TObject);
var DA, DA1: TDicomAttributes;
    DateRange: TDicomAttribute;
    i: Integer;
    CnsDicomConnection1: TCnsDicomConnection;
  procedure MyWrtLogF (p_str:string);
  begin
    if v_debug then
      MnLg_ev( p_str, ExtractFilePath(paramstr(0))+c_mn_log_file, True );
  end;
begin
  CnsDicomConnection1 := TCnsDicomConnection.Create(nil);
  try
    Screen.Cursor := crHourGlass;
    CnsDicomConnection1.Host := teHost.Text;
    CnsDicomConnection1.Port := StrToInt(tePort.Text);
    CnsDicomConnection1.CalledTitle := teCalled.Text;
    if teCalling.Text <> '' then
      CnsDicomConnection1.CallingTitle := teCalling.Text;

      MyWrtLogF( 'C_Echo: '+#13+
          ' Host = '+CnsDicomConnection1.Host+#13+
          ' Port = '+IntToStr(CnsDicomConnection1.Port)+#13+
          ' CalledTitle = '+CnsDicomConnection1.CalledTitle+#13+
          ' CallingTitle = '+CnsDicomConnection1.CallingTitle );

    CnsDicomConnection1.v_is_log := True;
    CnsDicomConnection1.v_log_filename := ExtractFilePath(paramstr(0))+c_mn_log_file;

    if CnsDicomConnection1.C_Echo then
    begin
      MessageDlg('OK', mtWarning, [mbOK], 0);
    end else
    begin
      MyWrtLogF( 'C_ECHO ERROR ' );
      ShowMessage('������ �� �������! ���������� � �������������� �������!');
    end;
  finally
    CheckEnabledButtons;
    Screen.Cursor := crDefault;
    MyDisconnectAssociation(CnsDicomConnection1);
    CnsDicomConnection1.Free;
    Application.ProcessMessages;
    Sleep(100);
  end;
end;

procedure TfrmMain.cxSplitter1BeforeClose(Sender: TObject;
  var AllowClose: Boolean);
begin
  Panel1.Visible := False;                       
end;

procedure TfrmMain.cxSplitter1BeforeOpen(Sender: TObject; var NewSize: Integer;
  var AllowOpen: Boolean);
begin
  Panel1.Visible := True;
end;

// ��������� ����������� - ������������ ��������� ������
// ������� ������� ��������� ���� ������ ������
procedure TfrmMain.DicomServerCore1DicomImage(AClientThread: TDicomClientThread;
  AAddress: string; ADataset: TDicomDataset);
begin
  MnLg_ev('DicomServerDicomImage port='+inttostr(DicomServerCore1.ServerPort)+#13+
          ' AAddress='+AAddress);
  // ��������� ������� ��������������� ������ - ���������������
  // � ����� ��������
  if CmnUnit.v_exit_progressbar=1 then // ���������� �����
  begin
    frmMain.DicomServerCore1.Stop;
  end else begin  // ����� ���������� �����������
    MnLg_ev('DicomServerDicomImage MoveImageCount '+inttostr(MoveImageCount)+
             ' / curr_count='+inttostr(v_amm_img_loaded),
             ExtractFilePath(paramstr(0))+'c_move.log',
             False );
    // ���� �������� ������� ������ ������
    // ���������� ������� ��������� �������
    // �������� ������ � �������
    frmSnimok.CnsDMTable1.Add(ADataset);
    // ������� ��������� ��� ������ ������ ��������� - 0
    AClientThread.Association.SendStatus(0);
   // if v_amm_img_loaded<=MoveImageCount then begin
      inc(v_amm_img_loaded);
      FrmProgressBar.MyIncPos; // ����������� ���������
      // ���� ������ ��������� - ��������� �����
      if ((v_amm_img_loaded>=MoveImageCount) and (MoveImageCount>0)) then
      begin
        CmnUnit.v_exit_progressbar:=2;  // ��������� ��������
        frmMain.DicomServerCore1.Stop;
      end;  
   // end;
  end;
end;

procedure TfrmMain.DoShowFormMOVE( const p_PATIENT : string;
                                     const p_STUDYUID: string;
                                     const p_VSTUDYID: string;
                                     const p_SERIES  : string;
                                     const p_ACCESSIONNUMBER : string;
                                     const sLevel : string );
begin
  // ��������� ���� �������
  if Trim(frmMain.teLocalPort.Text)='' then frmMain.teLocalPort.Text:='0';
  DicomServerCore1.ServerPort:=StrToInt(frmMain.teLocalPort.Text);
  // ������ �������
  DicomServerCore1.Stop;
  Application.ProcessMessages;
  Sleep(100);

  try
    DicomServerCore1.Start;
  except
    on E:Exception do
      ShowMessage(DateTimeToStr(Now)+' ERROR DicomServer Start : '+E.Message );
  end;

  try
    Screen.Cursor := crHourGlass;
    // �������� ��������
    Application.CreateForm(TFrmProgressBar, FrmProgressBar);
    MnLg_ev( 'gt_list_for_studyUIDs'+#13+
             'Host='+frmSnimok.v_Host+#13+
             'Port='+inttostr(frmSnimok.v_Port)+#13+
             'LocalPort='+frmMain.teLocalPort.Text+#13+
             'CalledTitle='+frmSnimok.v_CalledTitle+#13+
             'CallingTitle='+frmSnimok.v_CallingTitle  );
    gt_list_for_studyUIDs ( '',//p_STUDYUID,
                            frmSnimok.v_Host,
                            frmSnimok.v_Port,
                            StrToInt(frmMain.teLocalPort.Text),
                            frmSnimok.v_CalledTitle,
                            frmSnimok.v_CallingTitle,
                            FrmProgressBar,
                            True, //      const p_is_one : boolean;
                            p_PATIENT,
                            p_SERIES,
                            False, // p_key
                            True, // debug
                            p_ACCESSIONNUMBER
                          );
    // if CmnUnit.v_exit_progressbar=2 then ; // �� �������
  finally
    Sleep(1000); // ���� 1 �������
    DicomServerCore1.Stop;
    Screen.Cursor := crDefault;
    chk_close;
    Application.ProcessMessages;
    Sleep(100);
  end;
end;

// ��������� �������� ������� c_move
// p_level 'PATIENT', 'SERIES', 'STUDY'
procedure proc_c_move_cmn (const p_level : string);
var v_ACCESSIONNUMBER,
    v_STUDYUID,
    v_VSTUDYID,
    v_VNUMBER,
    v_VPAC,
    v_StudyDate,
    v_SERIESUID : AnsiString;
  //  i{, v_amm} :Integer; //v_s:AnsiString;
begin
  if frmMain.teHost.Text = '' then
    begin
      MessageDlg('�� �� ������ ������������� ����������� � �������!'+#13+#10+
                 '�� ���������� IP-����� �������!', mtWarning, [mbOK], 0);
      frmMain.teHost.SetFocus;
      Exit;
    end;
  if frmMain.tePort.Text = '' then
    begin
      MessageDlg('�� �� ������ ������������� ����������� � �������!'+#13+#10+
                 '�� ���������� ���� ���������� � ��������!', mtWarning, [mbOK], 0);
      frmMain.tePort.SetFocus;
      Exit;
    end;
    if p_level='PATIENT' then
    begin
      try
        v_VNUMBER := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VNUMBER.Index];
      except
        v_VNUMBER:='';
      end;
      try
        v_VPAC := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VPAC.Index];
      except
        v_VPAC:='';
      end;
    end else
    begin
      if p_level='STUDY' then
      begin
        try
          v_VSTUDYID := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VSTUDYID.Index];
        except
          v_VSTUDYID:='';
        end;
        try
          v_STUDYUID        := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VSTUDYUID.Index];
        except
          v_STUDYUID:='';
        end;
        try
          v_ACCESSIONNUMBER := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VACNUMBER.Index];
        except
          v_ACCESSIONNUMBER:='';
        end;
        try
          v_StudyDate        := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.VDATE.Index];
        except
          v_StudyDate:='';
        end;
      end else if p_level='SERIES' then
      begin
        try
          v_SERIESUID := frmMain.TV.DataController.Values[frmMain.TV.DataController.FocusedRecordIndex, frmMain.SERIESUID.Index];
        except
          v_SERIESUID:='';
        end;
      end;
    end;
    //
    // ������ studiuid
  {  p_studyid_fnd ( v_ACCESSIONNUMBER,
                    v_VNUMBER,
                    v_StudyDate,
                    frmMain.teHost.Text,
                    frmMain.tePort.Text,
                    frmMain.teCalled.Text,
                    frmMain.teCalling.Text,
                    v_amm,
                    v_VSTUDYID,
                    v_STUDYUID
                  );  }
    MnLg_ev( '������ c-move '+#13+
           ' level='+p_level+#13+
           ' v_SERIESUID='+v_SERIESUID+#13+
           ' v_VPAC='+v_VPAC+#13+
           ' v_VNUMBER='+v_VNUMBER+#13+
           ' v_VSTUDYID='+v_VSTUDYID+#13+
           ' v_ACCESSIONNUMBER='+v_ACCESSIONNUMBER+#13+
           ' v_STUDYUID='+v_STUDYUID+#13+
           ' v_VSTUDYID='+v_VSTUDYID,
           ExtractFilePath(paramstr(0))+c_mn_log_file,
           False
         );
    // �������� �����
    Application.CreateForm(TfrmSnimok, frmSnimok);
    frmSnimok.v_Host := frmMain.teHost.Text;
    frmSnimok.v_Port := StrToInt(frmMain.tePort.Text);
    frmSnimok.v_CalledTitle := frmMain.teCalled.Text;
    frmSnimok.v_CallingTitle := frmMain.teCalling.Text;
    // ������ c_move
    try
      frmMain.DoShowFormMOVE( v_VNUMBER,     //  PATIENT ID
                                v_STUDYUID,    // '1.2.410.200041.2.1.2012.6.5.10.31.8.281.1', // v_STUDYUID, // STUDY
                                v_VSTUDYID,
                                v_SERIESUID,         // SERIES
                                v_ACCESSIONNUMBER, // ACCESSIONNUMBER
                                p_level );
      if CmnUnit.v_exit_progressbar in [0,2] then begin
        try
          frmSnimok.ShowModal;
        finally
          frmSnimok.Free;
        end;
      end;
    except
      frmMain.DicomServerCore1.Stop;
      frmSnimok.Free;
    end;

end;

procedure TfrmMain.dxBarButton14Click(Sender: TObject);
begin // About
  Application.CreateForm(TFrmAbout, FrmAbout);
  try
    FrmAbout.vInfo := '��������� QueryList '+#13+
                      '������������� ��� ��������� '+#13+
                      '����������� ������������ �'+#13+
                      '������ � PACS ��������'+#13+
                      ''+#13+
                      ''+#13+
                      '';
    FrmAbout.ShowModal;
  finally
    FrmAbout.Free;
  end;
end;

procedure TfrmMain.dxBarButton5Click(Sender: TObject);
begin
  proc_c_move_cmn('PATIENT');
end;

procedure TfrmMain.dxBarButton6Click(Sender: TObject);
begin
  proc_c_move_cmn('SERIES');
end;

procedure TfrmMain.dxBarButton7Click(Sender: TObject);
begin
  proc_c_move_cmn('STUDY');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Application.MessageBox('�� ������ ����� �� ���������� ?', '������', MB_YESNO + MB_ICONQUESTION) = MrYes
  then begin
    action := caFree;
  end else begin
    action := caNone;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var Reg : TRegIniFile; Ini:TIniFile;
begin
  Reg := TRegIniFile.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if not Reg.OpenKey('\Software\Softmaster\QueryList\', False) then
    begin
      Reg.CreateKey('\Software\Softmaster\QueryList');
    end;
  try
    Reg.WriteString('\Software\Softmaster\QueryList', 'CLIENT_PORT_IMAGE', teLocalPort.Text);
    Reg.WriteString('\Software\Softmaster\QueryList', 'SERVER_PORT_QUERY', tePort.Text);
    Reg.WriteString('\Software\Softmaster\QueryList', 'SERVER_PORT_STORE', tePortStore.Text);
    Reg.WriteString('\Software\Softmaster\QueryList', 'SERVER_IP_QUERY', teHost.Text);
    Reg.WriteString('\Software\Softmaster\QueryList', 'CALLED_AE_TITLE_QUERY', teCalled.Text);
    Reg.WriteString('\Software\Softmaster\QueryList', 'CALLING_AE_TITLE_QUERY', teCalling.Text);

    Reg.WriteString('\Software\Softmaster\DicomClient', 'WLCalledAE', teWLCalled.Text);
    Reg.WriteString('\Software\Softmaster\DicomClient', 'WLHost', teWLHost.Text);
    Reg.WriteString('\Software\Softmaster\DicomClient', 'WLPort', teWLPort.Text);
    Reg.WriteString('\Software\Softmaster\DicomClient', 'WLCallingAE', teWLCalling.Text);

    if cbDates.Checked = True then
      Reg.WriteInteger('\Software\Softmaster\DicomClient', 'ISDATES', 1)
    else
      Reg.WriteInteger('\Software\Softmaster\DicomClient', 'ISDATES', 0);
  finally
    Reg.Free;
  end;
  Ini := TIniFile.Create(ExtractFilePath(paramstr(0))+c_ini_file);
  try   //
    Ini.WriteInteger(c_rzd,chkKadr,v_hkKadr);
    Ini.WriteInteger(c_rzd,chkStartVideo,v_hkStartVideo);
    Ini.WriteInteger(c_rzd,chkStopVideo,v_hkStopVideo);
  finally
    Ini.Free;
  end; 
  TV.StoreToRegistry('\SoftWare\SoftMaster\QueryList\TV', TRUE, [], 'TV');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var Ini:TIniFile;
begin
  //
  Height:=600;
  Width:=800;
  //
  cxPageControl1.ActivePageIndex:=0;
  Ini := TIniFile.Create(ExtractFilePath(paramstr(0))+c_ini_file);
  try   // ������ ���������� ���������� � ��
    v_hkKadr       := Ini.ReadInteger(c_rzd,chkKadr,0);
    v_hkStartVideo := Ini.ReadInteger(c_rzd,chkStartVideo,0);
    v_hkStopVideo  := Ini.ReadInteger(c_rzd,chkStopVideo,0);
    v_debug:=(Ini.ReadString(c_rzd,c_section_is_debug,'0')='1');
    if v_debug then
      Ini.WriteString(c_rzd,c_section_is_debug,'1')
    else
      Ini.WriteString(c_rzd,c_section_is_debug,'0');
    Ini.WriteInteger(c_rzd,chkKadr,v_hkKadr);
    Ini.WriteInteger(c_rzd,chkStartVideo,v_hkStartVideo);
    Ini.WriteInteger(c_rzd,chkStopVideo,v_hkStopVideo);
    s_hkKadr       := ShortCutToText(v_hkKadr);
    s_hkStartVideo := ShortCutToText(v_hkStartVideo);
    s_hkStopVideo  := ShortCutToText(v_hkStopVideo);
  finally
    Ini.Free;
  end;

  MWLReceiveDatasets := TList.Create;
  deEnd.Date := Date;
  deBegin.Date := Date - 30;
  aPrint.Enabled := False;
  aSnimok.Enabled := False;
  TV.StoreToRegistry('\SoftWare\SoftMaster\QueryList\TVDefault', TRUE, [], 'TV'); // ��������� �� ������� ��������� �����
  TV.RestoreFromRegistry('\SoftWare\SoftMaster\QueryList\TV', FALSE, FALSE, [], 'TV');
  Russian:=LoadKeyboardLayout('00000419', 0);
  //
  v_ds_i:=0;
  //
  CheckEnabledButtons;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to MWLReceiveDatasets.Count - 1 do
    TDicomAttributes(MWLReceiveDatasets[i]).Free;

  MWLReceiveDatasets.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var Reg : TRegIniFile;
begin
  Reg:=TRegIniFile.Create;
  try
    Reg.RootKey:=HKEY_CURRENT_USER;
//-->> ��������� ���� ��� ������ �����������
    teLocalPort.Text := Reg.ReadString('\Software\Softmaster\QueryList', 'CLIENT_PORT_IMAGE', '');
    if teLocalPort.Text = '' then
      teLocalPort.Text := '1115';
//-->> ����
    tePort.Text := Reg.ReadString('\Software\Softmaster\QueryList', 'SERVER_PORT_QUERY', '');
    tePortStore.Text := Reg.ReadString('\Software\Softmaster\QueryList', 'SERVER_PORT_STORE', '');
    if tePort.Text = '' then
      tePort.Text := Reg.ReadString('\Software\Softmaster\DicomServer', 'SERVER_PORT', '');
    if tePort.Text = '' then
      tePort.Text := '104';
//-->> ���� (PACS ������)
    teHost.Text := Reg.ReadString('\Software\Softmaster\QueryList', 'SERVER_IP_QUERY', '');
    if teHost.Text = '' then
      teHost.Text := Reg.ReadString('\Software\Softmaster\DicomClient', 'SERVER_IP', '');
//-->> Called AE Title
    teCalled.Text := Reg.ReadString('\Software\Softmaster\QueryList', 'CALLED_AE_TITLE_QUERY', '');
    if teCalled.Text = '' then
      teCalled.Text := Reg.ReadString('\Software\Softmaster\DicomServer', 'AE_TITLE', '');
//-->> Calling AE Title
    teCalling.Text := Reg.ReadString('\Software\Softmaster\QueryList', 'CALLING_AE_TITLE_QUERY', '');
    if teCalling.Text = '' then
      teCalling.Text := Reg.ReadString('\Software\Softmaster\DicomClient', 'CALLING_AE_TITLE', '');

    if teWLCalled.Text = '' then
      teWLCalled.Text := Reg.ReadString('\Software\Softmaster\DicomClient', 'WLCalledAE', '');
    if teWLHost.Text = '' then
      teWLHost.Text := Reg.ReadString('\Software\Softmaster\DicomClient', 'WLHost', '');
    if teWLPort.Text = '' then
      teWLPort.Text := Reg.ReadString('\Software\Softmaster\DicomClient', 'WLPort', '');
    if teWLCalling.Text = '' then
      teWLCalling.Text := Reg.ReadString('\Software\Softmaster\DicomClient', 'WLCallingAE', '');

//-->> �������� �� ���� �� ���������...
    nDates := Reg.ReadInteger('\Software\Softmaster\DicomClient', 'ISDATES', 0);
    case nDates of
      1: cbDates.EditValue := 1;
      0: cbDates.EditValue := 0;
    end;                        
  finally
    Reg.Free;
  end;
end;

procedure TfrmMain.frxRepGetValue(const VarName: string; var Value: Variant);
begin
  if VarName = 'DATESYS' then Value := Now; //!!!
  if VarName = 'KOLVO' then Value := dxMemData1.RecordCount;
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  TV.RestoreFromRegistry('\SoftWare\SoftMaster\QueryList\TVDefault', FALSE, FALSE, [], 'TV');
end;

procedure TfrmMain.teDescKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    aFindExecute(nil);
end;

procedure TfrmMain.teFamClick(Sender: TObject);
begin
  ActivateKeyboardLayout(russian, KLF_REORDER);
end;

procedure TfrmMain.teFamEnter(Sender: TObject);
begin
  ActivateKeyboardLayout(russian, KLF_REORDER);
end;

procedure TfrmMain.teFamKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    aFindExecute(nil);
end;

procedure TfrmMain.teNumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    aFindExecute(nil);
end;

procedure TfrmMain.teSotrClick(Sender: TObject);
begin
  ActivateKeyboardLayout(russian, KLF_REORDER);
end;

procedure TfrmMain.teSotrEnter(Sender: TObject);
begin
  ActivateKeyboardLayout(russian, KLF_REORDER);
end;

procedure TfrmMain.teSotrKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    aFindExecute(nil);
end;

procedure TfrmMain.TVCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  aSnimokExecute(nil);
end;

// ��������� ��� ������������ ������ ������
// initialization
//   ReportMemoryLeaksOnShutdown := True;
end.
