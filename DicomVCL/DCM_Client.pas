{*******************************************************}
{							                                          }
{       Delphi DicomVCL Component Library	            	}
{       DicomVCL include file				                    }
{                                                       }
{       Copyright (c) 1999,2008 by Jiawen Feng	      	}
{                                                       }
{*******************************************************}
unit DCM_Client;
{$I DicomPack.inc}

{.$DEFINE DICOMDEBUGZ1}

interface
uses
  {$IFDEF LINUX}Types, Libc, {$ELSE}Windows, {$ENDIF}Classes, SysUtils, {$IFDEF LEVEL6}Variants,
  {$ENDIF}
  DCM_Connection, DCM_Attributes, DCM_UID, DCM_Dict, inifiles, DCM32, Messages,
  KxString, KxSockClient, KxSock, DCM32_Transforms, DCM32_Resamplers, DCM_Bitmap16,
  ComCtrls, dialogs, graphics, controls, DB, DBCommon, forms, extctrls, Buttons,
  //DCM_BinaryStreamFormat,
  // _DGLMap_StringCaseInsensitive_Integer, DGL_StringCaseInsensitive,
  {$IFDEF LEVEL5}SyncObjs, Masks, {$ENDIF}
  {$IFDEF DICOMDEBUGZ1}dbugintf, {$ENDIF}DCM_ImageData_Bitmap16,
  DCM_ImageData_Bitmap32, DCM_ImageData_Bitmap, DCM_MemBinaryStreamFormat,
  DCM_MemTable, cnssqldata, cnssqlparser, CnsMsg, registry, math, cnsvfw,
  DICOM_charset, DCM_log;

const
  BoundPortDefault = 0;
  WM_DICOM_CNS_RECEIVE = WM_USER + 4100 + 1;
  WM_DICOM_CNS_ERROR = WM_USER + 4100 + 2;
  WM_DICOM_CNS_RECEIVE_FINISH = WM_USER + 4100 + 3;

  WM_DICOM_CSTORAGE = WM_USER + 3000 + 3;
  WM_DICOM_SEND = WM_USER + 3000 + 4;

type
  TCnsDBTable = class;

  TOnGetStudyReportTextEvent = procedure(Sender: TObject; const AStudyUID, AstudyID: AnsiString; var
    AStudyHtml:
    AnsiString) of object;

  TOnSelectMultiSeriesEvent = procedure(Sender: TObject; ADataSet: TDataset; const AStudyUIDS,
    ASeriesUIDS: TStringList) of object;

  TOnCreateMainDatasetEvent = procedure(Sender: TObject; AObjectName: AnsiString; var ADataset:
    TCnsDBTable) of object;
  TOnSetStudyUIDEvent = procedure(Sender: TObject; const AStudyUID, AstudyID: AnsiString; AStudyDate:
    TDatetime) of object;
  TOnScriptCallEvent = procedure(Sender: TObject; const AStr1, AStr2: AnsiString; var AResult: AnsiString)
    of object;
  TOnSaveImageQuestionEvent = procedure(Sender: TObject; HaveNotSaved: Boolean; var CanBeDelete:
    Boolean; AInstanceUID: string) of object;
  TOnGetFormCaptionEvent = procedure(Sender: TObject; var ACaption: AnsiString) of object;

  TOnEnterCaptureEvent = procedure(Sender: TObject; AAccessNumber: AnsiString) of object;

  TOnSelectStudyUIDEvent = procedure(Sender: TObject; ATag: integer; var AStudyUID, ACaption:
    AnsiString) of object;

  TOnDicomPrintFilmEvent = procedure(Sender: TObject; var AResult: Boolean) of object;
  TOnBeforeDicomFilmPrintEvent = procedure(Sender: TObject; AFilmType: AnsiString; ALogDataset:
    TDataset) of object;
  TOnDicomPrintFilmGetAccessionNumberEvent = procedure(Sender: TObject; var AUserName, AFilmDesc, AAccessionNumber: string) of object;

  TOnCanUpdateimageEvent = procedure(Sender: TObject; var AResult: Boolean) of object;
  TOnCaptureFormSave = procedure(Sender: TObject; ADataset: TDicomDatasets) of object;

  TOnPrintImageToFilm = procedure(Sender: TObject; ADataset: TDicomDataset; APrinterName: string) of object;

  TOnOpenDetailtable = procedure(Sender: TObject; ADataset: TCnsDBTable) of object;

  TOnGetCurrentDatasetEvent = procedure(Sender: TObject; var ADataset: TDicomDatasets) of object;

  TOnCGETProcessEvent = procedure(Sender: TObject; ADataset: TDicomAttributes; AImageCount: Integer)
    of object;
  TOnPDUProcessEvent = procedure(Sender: TObject; APDUCount: Integer) of object;

  TCnsDBTableLoadMode = (cnsLoadFromNetwork, cnsLoadFromFile, cnsLoadFromSourceData,
    cnsLoadFromWado, cnsLoadFromWadoPost, cnsLoadFromNetworkEx, cnsLoadFromWadoPostEx);

  TRegisterFormNotifyEvent = procedure(Sender: TObject; AWhereSQL, AGroupText: string) of object;

  TBeforeClearImageNotifyEvent = procedure(Sender: TObject; AStudyUID: string) of object;


  TCnsCustomDicomConnection = class(TComponent)
  private
    FHost: AnsiString;
    FPort: integer;
    fMeasureReportDataset: TDataset;
    FOnDicomRequest: TDicomRequestEvent;
    FGetCurrentDataset: TOnGetCurrentDatasetEvent;
    FOnCGETProcess: TOnCGETProcessEvent;
    FOnPDUProcess: TOnPDUProcessEvent;

  protected
    function GetReceiveDatasets: TList; virtual;
    procedure SetHost(const Value: AnsiString); virtual;
    procedure SetPort(const Value: integer); virtual;
    function GetReceiveStreams: TList; virtual;
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetLastDatasets: TDicomDatasets;
    procedure Disconnect; virtual;
    procedure Clear; virtual;
    function C_Echo: Boolean; virtual;
    function C_MOVE(ADataset: TDicomAttributes): Boolean; virtual;
    function C_FIND(ADataset: TDicomAttributes): Boolean; virtual;
    function C_MWL(ADataset: TDicomAttributes): Boolean; virtual;
    function C_GET(ADataset: TDicomAttributes): Boolean; virtual;
    function C_STORAGE(ADataset: TDicomAttributes): Boolean; virtual;
    function C_Database(ADataset: TDicomAttributes): Boolean; virtual;

    function M_Database(ADataset: TDicomAttributes; var aResponseDataset: TDicomAttributes; var aStream: TStream): Boolean; virtual;

    function M_GET(AStudyUID: AnsiString): Boolean; virtual;
    function M_STORAGE(ADataset: TDicomDataset; AWithFileStream: Boolean = TRUE): Boolean; virtual;

    function GetFile(AFileName: AnsiString): TDicomAttributes; virtual;
    procedure SetFile(AFileName, ASourceFileName: AnsiString; APath: AnsiString = ''); virtual;
    procedure SetFileStream(AFileName: AnsiString; AStm: TStream; APath: AnsiString = ''); virtual;

    function N_CREATE(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean;
      virtual;
    function N_SET(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes): Boolean;
      virtual;
    function N_GET(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes): Boolean;
      virtual;
    function N_ACTION(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean;
      virtual;
    function N_DELETE(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean;
      virtual;
    function N_EVENT_REPORT(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean; virtual;

    function GetLocalIP: AnsiString; virtual;

    property ReceiveDatasets: TList read GetReceiveDatasets;
    property ReceiveStreams: TList read GetReceiveStreams;
    property Host: AnsiString read FHost write SetHost;
    property Port: integer read FPort write SetPort;
    property LastDatasets: TDicomDatasets read GetLastDatasets;
    property MeasureDataset: TDataset read fMeasureReportDataset write fMeasureReportDataset;

    property OnDicomRequest: TDicomRequestEvent read FOnDicomRequest write FOnDicomRequest;
    property OnGetCurrentDataset: TOnGetCurrentDatasetEvent read FGetCurrentDataset write
      FGetCurrentDataset;
    property OnCGETProcess: TOnCGETProcessEvent read FOnCGETProcess write FOnCGETProcess;
    property OnPDUProcess: TOnPDUProcessEvent read FOnPDUProcess write FOnPDUProcess;

  end;

  TCnsCustomDicomConnectionPoll = class(TComponent)
  private
    fConectList: TList;
    fTimer: TTimer;

  protected

    procedure DoCheckTimeout(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear;

    function GetConnection: TCnsCustomDicomConnection;

  published

  end;

  TCnsDicomConnection = class(TCnsCustomDicomConnection)
  private

    FSocket: TKXSockClient;

    FAssociation: TAssociation;
    FMessageID: Integer;
    fReceiveTimeout: Integer;

    FCallingTitle: AnsiString;
    // FOMIN 08_07_2012 MoveDestination
    // �������� �������� ��� C_MOVE
    FMoveDestination: AnsiString;
    //
    FCalledTitle: AnsiString;
    FMaxPduSize: Integer;

    FPresentationContext: TDCMIntegerArray;
    FPresentationContextCount: Integer;
    FTransferSyntaxes: TDCMIntegerArray;

    FOnConnected: TNotifyEvent;
    FOnDisConnected: TNotifyEvent;
    //    FLimit: AnsiString;
    FRetryHostList: TStrings;
    FRetryHostCurrentIndex: Integer;
    FRetryHostLastIndex: Integer;

    FCanRetryConnected: Boolean;

    function SendRequest(p_is_send_request:Boolean=True): TDicomResponse;
    function SendDicomRequest(ARequestType, ASOPClass: Integer; SopInstance: AnsiString; AAttriutes:
      TDicomAttributes): Boolean;
    function SendDicomRequest1(ARequestType, ASOPClass: Integer; SopInstance: AnsiString; AAttriutes:
      TDicomAttributes): Boolean;
    function SendCommandBySop(ASopClass: Integer; CommandAttributes, DataAttributes:
      TDicomAttributes): Boolean;
    function QueryHost(AMsg: AnsiString): Boolean;
    procedure DoDicomRequest(Address: AnsiString; ACommand: TDicomAttributes; ARequestDatasets,
      AResponseDatasets: TList);

  protected
    //
    procedure DoOnDisconnected; virtual;
    procedure DoOnConnected; virtual;
    function Connected: Boolean;
    function PrepareRequestCommand(ARequestType, ASopClass: Integer; SopInstance: AnsiString):
      TDicomAttributes; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property PresentationContext: TDCMIntegerArray read FPresentationContext;
    property PresentationContextCount: Integer read FPresentationContextCount write
      FPresentationContextCount;

    function GetReceiveStreams: TList; override;
    function GetReceiveDatasets: TList; override;
    procedure SetHost(const Value: AnsiString); override;
    procedure SetPort(const Value: integer); override;

    procedure SetRetryHostList(Value: TStrings);
    //    function SaveDicomImageEx(APath: AnsiString; ADataset: TDicomAttributes): TFileStream;
    //    function LoadDicomImageEx(APath: AnsiString): TFileStream;
//    function CheckLocalImageCache(Apath, AStudyUID: AnsiString): Boolean;

    //    function AppendImage(a1: TDicomAttributes; studyid, PName, pSex, PatientID: AnsiString;
    //      date1: TDatetime; studyuid, seriesuid, InstanceUID, ImageType, aid, afilename: AnsiString): Boolean;
    procedure Connect(const ATimeout: Integer = 0); virtual;
    procedure SendResult(ADataset: TDicomAttributes);

  public
    // ��������� ������� ���������
    v_is_log : Boolean;
    v_log_filename : string;
    procedure Conn_wrt_log (str:string);
    function MyBoolToStr(const p_par:boolean):string;

    // FOMIN 09.01.2013
     constructor Create(AOwner: TComponent); override;
//    constructor Create(AOwner: TComponent; p_MainTransferSyntax : Integer = 0; p_quality : Integer = 100 );
    destructor Destroy; override;

    // FOMIN 15_02_2013
    procedure MySetTransferSyntax( p_MainTransferSyntax : Integer = 0; p_quality : Integer = 100 );

    function SendCommand(APid: Byte; CommandAttributes, DataAttributes: TDicomAttributes): Boolean;

    procedure ResetSynTax;
    procedure addPresentationContext(APresentationContext: Integer);
    procedure ClearPresentationContext;
    procedure SendStatus(AStatus: Integer); overload;
    procedure SendStatus(AStatus, AMsgID: Integer); overload;
    procedure SetTransferSyntax(const Values: array of Variant);
    procedure AddCGETPresentationContexts( p_is_clr:Boolean=True );
    function SendFilePduRequest(AFIN: TAssociateFilePdu): Boolean;

    procedure Disconnect; override;
    procedure Clear; override;

    function C_Echo: Boolean; override;
    function C_MOVE(ADataset: TDicomAttributes): Boolean; override;
    function C_FIND(ADataset: TDicomAttributes): Boolean; override;
    function C_MWL(ADataset: TDicomAttributes): Boolean; override;
    function C_GET(ADataset: TDicomAttributes): Boolean; override;
    function C_STORAGE(ADataset: TDicomAttributes): Boolean; override;
    function C_Database(ADataset: TDicomAttributes): Boolean; override;
    function M_Database(ADataset: TDicomAttributes; var aResponseDataset: TDicomAttributes; var aStream: TStream): Boolean; override;
    //    function GetFile(AFileName: AnsiString): TDicomAttributes; override;
    function M_GET(AStudyUID: AnsiString): Boolean; override;
    function M_STORAGE(ADataset: TDicomDataset; AWithFileStream: Boolean = TRUE): Boolean;
      override;

    function N_GETPrinter(SOPInstance: Integer): TDicomAttributes;

    function N_CREATE(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean;
      override;
    function N_SET(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes): Boolean;
      override;
    function N_GET(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes): Boolean;
      override;
    function N_ACTION(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean;
      override;
    function N_DELETE(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean;
      override;
    function N_EVENT_REPORT(ASOPClass: Integer; SopInstance: AnsiString; ADataset: TDicomAttributes):
      Boolean; override;

    procedure SetReceiveTimeout(Value: Integer);

    function GetLocalIP: AnsiString; override;
    property Association: TAssociation read FAssociation;
    function GetState: integer;
    property RetryHostList: TStrings read FRetryHostList write SetRetryHostList;
    property CanRetryConnected: Boolean read FCanRetryConnected write FCanRetryConnected;

    property Socket: TKXSockClient read FSocket;
    // 27.07.2012 FOMIN
    property MessageID: Integer read FMessageID write FMessageID;
//    function GetMessageID : ;
  published
    property CallingTitle: AnsiString read FCallingTitle write FCallingTitle;
    property CalledTitle: AnsiString read FCalledTitle write FCalledTitle;
    // FOMIN 08_07_2012 MoveDestination
    // �������� �������� ��� C_MOVE
    property MoveDestination: AnsiString read FMoveDestination write FMoveDestination;
    //
    property Host;
    property Port;

    property MaxPduSize: Integer read FMaxPduSize write FMaxPduSize;
    property ReceiveTimeout: Integer read fReceiveTimeout write SetReceiveTimeout;

    property OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisConnected: TNotifyEvent read FOnDisConnected write FOnDisConnected;
    property OnCGETProcess;
    property OnPDUProcess;
  end;
  TCnsDicomConnectionIconImagesEvent = procedure(Sender: TObject; ADataset: TDicomAttribute) of
    object;
  TCnsDicomConnectionNewImageStreamEvent = procedure(Sender: TObject; ADatasetStream: TStream) of
    object;

  TCnsDicomConnectionNewImageEvent = procedure(Sender: TObject; ADataset: TDicomDataset) of object;
  TCnsDicomConnectionSendImageEvent = procedure(Sender: TObject; APosition: Integer) of object;

  TCnsDicomConnectionHttpGetEvent = procedure(Sender: TObject; AURL: AnsiString; AStm: TStream) of
    object;

  TCnsDicomConnectionHttpPostEvent = procedure(Sender: TObject; AURL: AnsiString; const ASource,
    AResponse: TStream) of object;

  TdctCommand = (dctcNone, dctcSendDatasets, dctcReceive, dctcSendFiles, dctcImportFiles, dctcImportFilesEx,
    dctcPrintFilm, dctcLoadFromFiles, dctcLoadFromDicomDIR, dctcWadoGetImage,
    dctcReceiveEx, dctcSendDatasetsEx);

  TCnsDicomConnectionMultiThread = class
  private
    fPort: Integer;
    fReceiveTimeout: Integer;
    FCallingTitle: AnsiString;
    FCalledTitle: AnsiString;
    fHost: AnsiString;
    fOnHttpGet: TCnsDicomConnectionHttpGetEvent;
    fOnHttpPost: TCnsDicomConnectionHttpPostEvent;
    fOnReceive: TCnsDicomConnectionNewImageStreamEvent;
    procedure SetReceiveTimeout(const Value: Integer);

  protected

  public
    constructor Create;
    destructor Destroy; override;

    procedure MGetImage(ALevel, AUID: AnsiString; AOnlyLoadKeyImage: Boolean); overload;
    procedure MGetImage(ALevel: AnsiString; AUIDS_Series, AUIDS_Study: tstrings;
      AOnlyLoadKeyImage: Boolean);
      overload;

    procedure WadoImages(AURL, ATransferSyntax: AnsiString; ADataset: TDicomDataset; AOnlyLoadKeyImage:
      Boolean);
  published
    property CallingTitle: AnsiString read FCallingTitle write FCallingTitle;
    property CalledTitle: AnsiString read FCalledTitle write FCalledTitle;
    property Host: AnsiString read fHost write fHost;
    property Port: Integer read fPort write fPort;

    property ReceiveTimeout: Integer read fReceiveTimeout write SetReceiveTimeout;
    property OnReceive: TCnsDicomConnectionNewImageStreamEvent read fOnReceive write fOnReceive;

    property OnHttpGet: TCnsDicomConnectionHttpGetEvent read fOnHttpGet write fOnHttpGet;
    property OnHttpPost: TCnsDicomConnectionHttpPostEvent read fOnHttpPost write fOnHttpPost;
  end;

  TCnsDMTable = class;

  TCnsDicomConnectionThread = class(TThread)
  private
    fParent: TObject;
    fList: TList;
    fFilenames: TStringList;
    fCommand: TdctCommand;
    fOnlyLoadKeyImage: Boolean;

    fOnIconReceive: TCnsDicomConnectionIconImagesEvent;
    fOnReceive: TCnsDicomConnectionNewImageEvent;
    fOnAfterSend: TCnsDicomConnectionSendImageEvent;
    fOnHttpGet: TCnsDicomConnectionHttpGetEvent;
    fOnHttpPost: TCnsDicomConnectionHttpPostEvent;

    fOnError: TNotifyEvent;

    fErrorMessage: AnsiString;
    fReceiveTimeout: Integer;

    FCallingTitle: AnsiString;
    FCalledTitle: AnsiString;
    fHost: AnsiString;
    fPort: Integer;

    fSendCommand: TDicomAttributes;
    fFreeAfterSend: Boolean;

    fPrintFormat: AnsiString;
    fPrintOrientation: AnsiString;
    fFilmSize: AnsiString;
    fCopys: integer;
    fFromIndex: integer;
    fLimitCount: Integer;
    fMagnificationType: AnsiString;
    fSmoothingType: AnsiString;
    fPolarity: AnsiString;
    fBorderDensity: AnsiString;
    fEmptyImageDensity: AnsiString;
    fTrim: AnsiString;
    fMediumType: AnsiString;
    fFilmDestination: AnsiString;
    fMinDensity: integer;
    fMaxDensity: integer;
    fIsColor: Boolean;
    fResolution: AnsiString;
    fbw: Integer;
    fRow: integer;
    fColumn: Integer;

    fPosition: Integer;
    fCurrentDataset: TDicomDataset;
    fIconCommandDataset: TDicomAttribute;

    fURL: AnsiString;
    fDataset: TDicomDataset;
    fWadoTransferSyntax: AnsiString;

    fImageTable: TDataset;
    fImagePath: AnsiString;
    FNeedResizeImage: Boolean;
    FFormHandle: THandle;
    FQueueIndex: Integer;
    FCurrentDatasets: TDicomDatasets;
    FOnWorkStart: TNotifyEvent;
    FOnConnected: TNotifyEvent;
    FPrintWithLabel: Boolean;
    //fSourceDatasets: TDicomDatasets;
    FDirectoryToLoad: AnsiString;
    FPrintLabelFirstImage: Boolean;

    fNoneThread: Boolean;
    FCustomViewSetting: string;
    FMultiViewMode: TMultiViewMode;
    FEnable12bitsGrayscale: Boolean;
    FPrintWindowWidthCenter: Boolean;
    FPrintwithBottomScale: Boolean;
    FPrintWithRightScale: Boolean;
    FSendPrintSetting: Boolean;
    FPrintWithDefaultParam: Boolean;
    FUseSynchronizeEvent: Boolean;

    procedure TiggleReceiveEvent;
    procedure TiggleSendEvent;
    procedure TiggleErrorEvent;
    function TestDcmFileDir(AQuery: TDataset; var AImageDir: AnsiString): Boolean;
    function TestFile(Query1: TDataset; basedir: AnsiString): AnsiString;
    procedure TiggleMGET(Sender: TObject; ADataset: TDicomDataset;
      AImageCount: Integer);
    procedure TiggleMReceiveEvent;
    procedure SetNeedResizeImage(const Value: Boolean);
    procedure SetFormHandle(const Value: THandle);
    procedure SetQueueIndex(const Value: Integer);
    procedure SetCurrentDatasets(const Value: TDicomDatasets);
    procedure SetOnWorkStart(const Value: TNotifyEvent);
    procedure SetOnConnected(const Value: TNotifyEvent);
    procedure SetPrintWithLabel(const Value: Boolean);
    procedure SetPrintLabelFirstImage(const Value: Boolean);
    procedure SetCustomViewSetting(const Value: string);
    procedure SetMultiViewMode(const Value: TMultiViewMode);
    procedure SetEnable12bitsGrayscale(const Value: Boolean);
    procedure SetPrintWindowWidthCenter(const Value: Boolean);
    procedure SetPrintwithBottomScale(const Value: Boolean);
    procedure SetPrintWithRightScale(const Value: Boolean);
    procedure SetSendPrintSetting(const Value: Boolean);
    procedure SetPrintWithDefaultParam(const Value: Boolean);
    procedure SetUseSynchronizeEvent(const Value: Boolean);
  protected
    procedure Execute; override;
    procedure DoSend;
    procedure DoSendFile;
    procedure DoReceive;
    procedure DoImport;
    procedure DoPrint;
    procedure DoWadoGet;
    function ReSizeAllImage(AIndex: Integer; ADataset: TDicomDataset): TDicomAttributes;
    function ReSizeAllImageEx(ADicomDatasets: TDicomDatasets): TCnsDMTable;

    procedure DoSendEx;
    procedure DoReceiveEx;

    procedure DoLoadFromFiles;
    procedure DoLoadFromDicomDIR;
    procedure TiggleCGET(Sender: TObject; ADataset: TDicomAttributes; AImageCount: Integer);
    procedure SetReceiveTimeout(Value: integer);

    function GetCountFromSetting: Integer;
    function GetRowOrColmn(AIndex: Integer): Integer;
    function GetRowOrColmnCount: Integer;
  public
    constructor Create(CreateSuspended: Boolean); virtual;
    destructor Destroy; override;

    procedure CGetImage(ALevel, AUID: AnsiString; AOnlyLoadKeyImage: Boolean);
    procedure SendImages(ADatasets: TDicomDatasets; AFreeAfterSend: Boolean); overload;

    procedure MGetImage(ALevel, AUID: AnsiString; AOnlyLoadKeyImage: Boolean); overload;
    procedure MGetImage(ALevel: AnsiString; AUIDS_Series, AUIDS_Study: TStringList;
      AOnlyLoadKeyImage: Boolean); overload;

    procedure SendImages(ADatasetFilenames: tstrings); overload;
    procedure ImportImages(ADatasetFilenames: tstrings);

    procedure ImportImagesEx(APath: AnsiString);

    procedure WadoImages(AURL, ATransferSyntax: AnsiString; ADataset: TDicomDataset; AOnlyLoadKeyImage:
      Boolean);

    procedure PrintDicomDatasets(ADatasets: TDicomDatasets; ACopys, AFromIndex, ALimitCount:
      Integer);

    procedure LoadFromFiles(AImagePath: AnsiString; AImageDataset: TDataset);
    procedure LoadFromDicomDIR(AImagePath: AnsiString; AImageDataset: TDataset);

    property ErrorMessage: AnsiString read fErrorMessage;
    property Terminated;
    property Parent: TObject read fParent write fParent;

    property UseSynchronizeEvent: Boolean read FUseSynchronizeEvent write SetUseSynchronizeEvent;

    property CurrentDatasets: TDicomDatasets read FCurrentDatasets write SetCurrentDatasets;
  published
    property CallingTitle: AnsiString read FCallingTitle write FCallingTitle;
    property CalledTitle: AnsiString read FCalledTitle write FCalledTitle;
    property Host: AnsiString read fHost write fHost;
    property Port: Integer read fPort write fPort;

    property FormHandle: THandle read FFormHandle write SetFormHandle;
    property QueueIndex: Integer read FQueueIndex write SetQueueIndex;

    property OnWorkStart: TNotifyEvent read FOnWorkStart write SetOnWorkStart;
    property OnConnected: TNotifyEvent read FOnConnected write SetOnConnected;

    property ReceiveTimeout: Integer read fReceiveTimeout write SetReceiveTimeout;
    property OnReceive: TCnsDicomConnectionNewImageEvent read fOnReceive write fOnReceive;
    property OnAfterSend: TCnsDicomConnectionSendImageEvent read fOnAfterSend write fOnAfterSend;
    property OnError: TNotifyEvent read fOnError write fOnError;
    property OnIconReceive: TCnsDicomConnectionIconImagesEvent read fOnIconReceive write
      fOnIconReceive;

    property OnHttpGet: TCnsDicomConnectionHttpGetEvent read fOnHttpGet write fOnHttpGet;
    property OnHttpPost: TCnsDicomConnectionHttpPostEvent read fOnHttpPost write fOnHttpPost;

    property PrintFormat: AnsiString read fPrintFormat write fPrintFormat;
    property PrintOrientation: AnsiString read fPrintOrientation write fPrintOrientation;
    property FilmSize: AnsiString read fFilmSize write fFilmSize;
    property Copys: integer read fCopys write fCopys;
    property FromIndex: integer read fFromIndex write fFromIndex;

    property PrintWithLabel: Boolean read FPrintWithLabel write SetPrintWithLabel;
    property PrintLabelFirstImage: Boolean read FPrintLabelFirstImage write SetPrintLabelFirstImage;

    property LimitCount: Integer read fLimitCount write fLimitCount;
    property MagnificationType: AnsiString read fMagnificationType write fMagnificationType;
    property SmoothingType: AnsiString read fSmoothingType write fSmoothingType;
    property PrintPolarity: AnsiString read fPolarity write fPolarity;
    property BorderDensity: AnsiString read fBorderDensity write fBorderDensity;
    property EmptyImageDensity: AnsiString read fEmptyImageDensity write fEmptyImageDensity;
    property FilmTrim: AnsiString read fTrim write fTrim;
    property MediumType: AnsiString read fMediumType write fMediumType;
    property FilmDestination: AnsiString read fFilmDestination write fFilmDestination;
    property MinDensity: integer read fMinDensity write fMinDensity;
    property MaxDensity: integer read fMaxDensity write fMaxDensity;
    property IsColor: Boolean read fIsColor write fIsColor;
    property Resolution: AnsiString read fResolution write fResolution;
    property bw: Integer read fbw write fbw;
    property Row: integer read fRow write fRow;
    property Column: Integer read fColumn write fColumn;
    property NeedResizeImage: Boolean read FNeedResizeImage write SetNeedResizeImage;

    property MultiViewMode: TMultiViewMode read FMultiViewMode write SetMultiViewMode;
    property CustomViewSetting: string read FCustomViewSetting write SetCustomViewSetting;

    property Enable12bitsGrayscale: Boolean read FEnable12bitsGrayscale write SetEnable12bitsGrayscale;
    property PrintWindowWidthCenter: Boolean read FPrintWindowWidthCenter write SetPrintWindowWidthCenter;
    property PrintWithRightScale: Boolean read FPrintWithRightScale write SetPrintWithRightScale;
    property PrintwithBottomScale: Boolean read FPrintwithBottomScale write SetPrintwithBottomScale;
    property PrintWithDefaultParam: Boolean read FPrintWithDefaultParam write SetPrintWithDefaultParam;
    property SendPrintSetting: Boolean read FSendPrintSetting write SetSendPrintSetting;
  end;

  TNetworkQueueStatus = (nqsPending, nqsActive, nqsIdle, nqsFinished, nqsError, nqsSelectSeries,
    nqsSendingRequest);
  TNetworkQueueDirection = (nqdReceive, nqdGetImage, nqdSend, nqdPrint, nqdImport, nqdLoad);

  TNetworkQueueItem = class
  private
    //status  pending active idle
    fStatus: TNetworkQueueStatus;
    //direction receive send
    fDirection: TNetworkQueueDirection;
    fFromOrTo: string;
    fPatientID: string;
    fPatientName: string;
    fStudyDate: TDatetime;
    fStartTime: TDatetime;
    fLastActive: TDatetime;
    fSeriesCount: Integer;
    fImageCount: Integer;
    fCurImageCount: Integer;

    fStudyUID: string;
    fForm: TForm;
    fDatasets: TDicomDatasets;
    fThread: TCnsDicomConnectionThread;
    FMessageString: string;
    FTag: Integer;
    FData: TObject;
    FPatientCName: string;
    FHospitalName: string;
    FPatientAge: string;
    FPatientSex: string;
    FTabData: TObject;
    procedure SetMessageString(const Value: string);
    procedure SetTag(const Value: Integer);
    procedure SetData(const Value: TObject);
    procedure SetHospitalName(const Value: string);
    procedure SetPatientCName(const Value: string);
    procedure SetPatientAge(const Value: string);
    procedure SetPatientSex(const Value: string);
    procedure SetTabData(const Value: TObject);
  protected
    //FQueueForm: TNetworkQueueForm;
    function GetStatusString: Ansistring;
    function GetDirection: Ansistring;
  public
    fMoveConnection: TCnsDicomConnection;
    constructor Create;
    destructor Destroy; override;

    property Status: TNetworkQueueStatus read fStatus write fStatus;
    property StatusText: AnsiString read GetStatusString;
    property Direction: TNetworkQueueDirection read fDirection write fDirection;
    property DirectionText: Ansistring read GetDirection;
    property FromOrTo: string read fFromOrTo write fFromOrTo;
    property PatientID: string read fPatientID write fPatientID;
    property PatientName: string read fPatientName write fPatientName;
    property MessageString: string read FMessageString write SetMessageString;
    property StudyDate: TDatetime read fStudyDate write fStudyDate;
    property StartTime: TDatetime read fStartTime write fStartTime;
    property LastActive: TDatetime read fLastActive write fLastActive;
    property SeriesCount: Integer read fSeriesCount write fSeriesCount;
    property ImageCount: Integer read fImageCount write fImageCount;
    property CurImageCount: Integer read fCurImageCount write fCurImageCount;

    property HospitalName: string read FHospitalName write SetHospitalName;
    property PatientCName: string read FPatientCName write SetPatientCName;
    property PatientSex: string read FPatientSex write SetPatientSex;
    property PatientAge: string read FPatientAge write SetPatientAge;

    //property Tag:Integer read FTag write SetTag;
    property Data: TObject read FData write SetData;
    property TabData: TObject read FTabData write SetTabData;
    property StudyUID: string read fStudyUID write fStudyUID;
    property ClientForm: TForm read fForm write fForm;
    property Datasets: TDicomDatasets read fDatasets write fDatasets;
    property MyThread: TCnsDicomConnectionThread read fThread write fThread;
  end;

  TGetDefaultValueEvent = procedure(AField: TField; Val: AnsiString) of object;
  TSelectProfileEvent = procedure(const AProfileList: AnsiString; var AProfileName: AnsiString) of object;
  TDataStateChangeEvent = procedure(Dataset: TDataset; AIsDisableFunction: Boolean;
    ADisableFunctions: AnsiString) of object;

  TCnsDataLink = class(TDataLink)
  private
    FOnMasterChange: TNotifyEvent;
    FOnMasterDisable: TNotifyEvent;
  protected
    procedure ActiveChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
  public
    constructor Create;
    destructor Destroy; override;
    property OnMasterChange: TNotifyEvent read FOnMasterChange write FOnMasterChange;
    property OnMasterDisable: TNotifyEvent read FOnMasterDisable write FOnMasterDisable;
  end;

  TCnsDeltaHandler = class(TkxmCustomDeltaHandler)
  private
    FList: TList;
  protected

    procedure InsertRecord(var Retry: boolean; var State: TUpdateStatus); override;
    procedure DeleteRecord(var Retry: boolean; var State: TUpdateStatus); override;
    procedure ModifyRecord(var Retry: boolean; var State: TUpdateStatus); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Commit;
    property CommitList: TList read FList;
  end;
  TCnsStorageProcedure = class(TComponent)
  private
    Fparams: TDicomAttributes;
    Fparam: TDicomAttribute;
    FAppSrvClient: TCnsCustomDicomConnection;
    FDatabaseName: AnsiString;
  protected

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(AProcname, AResultname: AnsiString): AnsiString;
    procedure SetFieldAsString(AFieldname, AValue: AnsiString);
    procedure SetFieldAsDatetime(AFieldname: AnsiString; AValue: Tdatetime);
    procedure SetFieldAsFloat(AFieldname: AnsiString; AValue: Double);
    procedure SetFieldAsInteger(AFieldname: AnsiString; AValue: Integer);
    procedure SetFieldAsmemo(AFieldname: AnsiString; AValue: AnsiString);

    property AppSrvClient: TCnsCustomDicomConnection read FAppSrvClient write FAppSrvClient;
    property DatabaseName: AnsiString read FDatabaseName write FDatabaseName;
  end;
  TCnsDBTable = class(TkxmCustomMemTable)
  private
    fInRefreshTable: Boolean;

    fMasterTimer: TTimer;
    fMasterTimerCount: Integer;

    fTableLoadMode: TCnsDBTableLoadMode;
    FDataFileName: AnsiString;
    FDataFileDirectory: AnsiString;
    FSourceData: TDicomAttributes;

    fAssociationID: Integer;
    FInterLoadingData: Boolean;
    FDataLoadedTime: TDatetime;
    FData: TDicomAttributes;

    FServerDBType: Integer;
    FParent: TComponent;
    FSelfDataSource: TDataSource;
    FDetailDatasetList: TList;
    FLookupDatasetList: TList;
    FValuesDatasetList: TList;
    FRecordViewDataset: TCnsDBTable;

    FOnGetDefaultValue: TGetDefaultValueEvent;
    FOnSelectProfileEvent: TSelectProfileEvent;
    FOnDataStateChangeEvent: TDataStateChangeEvent;
    fOnOpenDetailtable: TOnOpenDetailtable;
    fOnHttpGet: TCnsDicomConnectionHttpGetEvent;
    fOnHttpPost: TCnsDicomConnectionHttpPostEvent;

    FHaveBeenMarkDataset: Boolean;

    FAutoId: Integer;

    FAppSrvClient: TCnsCustomDicomConnection;
    FSelfAppSrvClient: TCnsCustomDicomConnection;

    FFetchCount: Integer;
    FFetchStart: Integer;
    FObjectName: AnsiString;
    FObjectTaskSQL: TStrings;

    FSQL: AnsiString;
    FOldKeyValue: AnsiString;

    FTableName: AnsiString;
    FDataBase: AnsiString;
    FPluginName: AnsiString;
    FDBOwnername: AnsiString;

    FKeyFields: TStrings;
    FDefaultValues: TStrings;

    fCalFields: TStrings;
    fCalFieldsLabel: TStrings;

    FProfilesOfUser: TStrings;
    FStatesOfProfile: TStrings;

    FSelectedProfileName: AnsiString;
    FSelectedStateName: AnsiString;
    FSelectedFormatName: AnsiString;

    FWhereSQL: AnsiString;
    FSpecialWhereSQL: TList;
    FDetailWhereSQL: AnsiString;

    FSQLData: TCnsSQLData;
    FScriptSource: TStrings;
    FAnalyzeScriptSource: TStrings;
    FDataAnalyzeScriptSource: TStrings;

    FListHtml: TStrings;
    FEdithtml: TStrings;
    FViewHtml: TStrings;
    FStartHtml: TStrings;

    FLastRecNo: Integer;
    FChangeInDataset: Boolean;

    FOrderIdxField: AnsiString;
    FTreeFields: TStrings;

    FCnsTable: TCnsTable;
    FColorFields: TStrings;

    //    FDatasetListForm: TForm;

    FParams: TParams;

    fDataStream: TStream;

    {$IFDEF ENABLE_REMOTE_MASTERLINK}
    FRemoteMasterLink: TMasterDataLink;
    FRemoteMasterLinkUsed: boolean;
    FRemoteMasterIndexList: TkxmFieldList;
    FRemoteDetailIndexList: TkxmFieldList;
    FRemoteDetailFieldNames: AnsiString;
    FPHPScript: AnsiString;
    FAddUpdateTime: Boolean;
    FConnectionPoll: TCnsCustomDicomConnectionPoll;
    //FDataTransferStreamFormat: Integer;

    procedure SetRemoteMasterFields(const Value: AnsiString);
    procedure SetRemoteDetailFields(const Value: AnsiString);
    function GetRemoteMasterFields: AnsiString;
    procedure SetRemoteDataSource(Value: TDataSource);
    function GetRemoteDataSource: TDataSource;
    procedure RemoteMasterChanged(Sender: TObject); virtual;
    procedure RemoteMasterChangedX(IsInter: Boolean);
    procedure RemoteMasterDisabled(Sender: TObject); virtual;
    {$ENDIF}
    procedure BaseSort;
    procedure MasterTimerTimer(Sender: TObject);
    function GetSeverTime: TDatetime;
    procedure SetPHPScript(const Value: AnsiString);
    procedure SetAddUpdateTime(const Value: Boolean);
    procedure SetConnectionPoll(const Value: TCnsCustomDicomConnectionPoll);
    function InternalSendSMS(AUserCode, AUserName, AMod,
      AData: string): string;
    function InternalGenID(AField: TField): Integer; overload;
    function InternalGenID(AFieldName: AnsiString; AutoInc: Boolean): Integer; overload;
    procedure InternalExecSQL(ADatabase, ASQL: AnsiString);
    function InternalSetGenID(AFieldName: AnsiString;
      Value: Integer): Integer;
  protected
    fActiveMasterLink: Boolean;

    procedure SetActiveMasterLink(Value: Boolean);

    procedure SetSelectedProfileName(AValue: AnsiString); virtual;
    procedure SetSelectedStateName(AValue: AnsiString); virtual;
    procedure SetDetailWhereSQL(AValue: AnsiString);
    function GetIncx(AField: TField): AnsiString;
    function GetRemmber(AField: TField): AnsiString;
    procedure SetSQL(AValue: AnsiString);
    procedure SetKeyFields(AValue: TStrings);

    procedure SetCalFields(AValue: TStrings);
    procedure SetCalFieldsLabel(AValue: TStrings);

    //    function TestForUserField(AWSQL: AnsiString): AnsiString;

    procedure DoAfterInsert; override;
    procedure DoBeforeInsert; override;

    procedure InternalPost; override;
    procedure InternalCancel; override;
    procedure InternalEdit; override;
    procedure InternalDelete; override;

    procedure InternalOpen; override;
    function BuildDataFromTaskSQL(ATaskSQL: TStrings): TDicomAttributes;
    function BuildNameFromTaskSQL(ATaskSQL: TStrings): AnsiString;

    procedure DoAfterOpen; override;

    procedure DoBeforePost; override;
    procedure DoAfterPost; override;
    procedure DoBeforeClose; override;

    procedure DoAfterDelete; override;

    procedure DoOnNewRecord; override;

    function GetCanModify: Boolean; override;
    procedure SetObjectName(Value: AnsiString);
    procedure SetObjectTaskSQL(Value: TStrings);
    //    procedure SetDataFileName(Value: AnsiString);

    function InternalApplyUpdates: Boolean;
    function GetKeyValue: AnsiString;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure ForceInsertAll;
    procedure SetWhereSQL(Value: AnsiString);
    function GetDetailDatasetByIndex(AIndex: Integer): TCnsDBTable;
    function GetDetailDataset(AIndex: AnsiString): TCnsDBTable;

    procedure BuildCnsTableData(AStr: string);
  public
    DatasetModify: Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function DoHttpPostDatabaseEx(ADataset: TDicomAttributes; var aResponseDataset: TDicomAttributes; var aStream: TStream): Boolean;
    function DoHttpPostDatabase(ADataset: TDicomAttributes): TDicomDataset;

    function GenID(AField: TField): Integer; overload;
    function GenID(AFieldName: AnsiString; AutoInc: Boolean): Integer; overload;
    function SetGenID(AFieldName: AnsiString; Value: Integer): Integer;
    procedure InsertCalFieldValue;

    function GetFile(AFileName: AnsiString): TDicomAttributes; virtual;
    procedure SetFile(AFileName, ASourceFileName: AnsiString; APath: AnsiString = ''); virtual;
    procedure SetFileStream(AFileName: AnsiString; AStm: TStream; APath: AnsiString = ''); virtual;
    procedure ChangeServerIni(AIniFileName, ASection, AName, AValue: string);

    function Parse(AStr: AnsiString): Boolean;
    procedure ExecSQL(ADatabase, ASQL: AnsiString);
    procedure ApplyProfileChange(AType: string);
    function SendSMS(AUserCode, AUserName, AMod, AData: string): string;

    procedure DeleteDetailDataset(AIndex: Integer); overload;
    procedure DeleteDetailDataset(AIndex: AnsiString); overload;
    procedure DeleteDetailDataset(AIndex: TCnsDBTable); overload;

    function ExecStorageProcedure(ADatabase, AProcName, AParamName, AParamValue: AnsiString): AnsiString;
    procedure OpenDetailTable(ADetailWhereSQL: AnsiString = ''); virtual;
    procedure OpenAllLookupTable; virtual;
    function GetDetailDatasetCount: Integer;

    function OpenLookupTable(AObjectName, AWhereSQL: AnsiString): TCnsDBTable;
    function OpenValuesTable(AFieldName: AnsiString): TDataset;
    function GetFieldDistinct(AField: AnsiString): TCnsDBTable;
    function OpenAsDetailTable(AObjectName, ADetailWhereSQL, AMasterFields, ADetailFields:
      AnsiString): TCnsDBTable;

    function CreateProcdure: TCnsStorageProcedure;

    //function FieldByNameEx(AFieldName:AnsiString):TField;

    procedure EnableDetail(Value: Boolean);

    function GetTreeNodeCaption: AnsiString;
    function ApplyUpdates: Boolean;
    procedure CancelUpdates;
    procedure HideRecord;
    procedure SetReadOnlyAndDisableFunction;
    function RefreshTable(ANewConnection: Boolean = false): Integer; virtual;
    //    property IgnoreReadOnly;

    procedure SaveToFile(AFilename: AnsiString);
    procedure LoadFromFile(AFileName: AnsiString);
    procedure LoadFromSource(AData: TDicomAttributes);
    procedure UpdateAllDataToServer;
    function GetData: TDicomAttributes;

    function SafeEdit: Boolean;
    function SafeDelete: Boolean;

    //function NewRecordView(AViewName: AnsiString): TForm;
    //procedure ShowNewRecord(AViewName: AnsiString);
    //function ShowListView(ATreeClassity: AnsiString): Boolean;
    procedure SavetaskSQL;

    //    function KxDateToStr(ADate: TDatetime): AnsiString;
    //    function KxDateToStrEx(ADate: TDatetime; ADBType: Integer): AnsiString;
        //�ű����

    procedure SetParamAsString(AParamName, AValue: AnsiString);
    procedure SetParamAsDatetime(AParamName: AnsiString; AValue: TDatetime);
    procedure SetParamAsInteger(AParamName: AnsiString; AValue: Integer);
    procedure SetParamAsFloat(AParamName: AnsiString; AValue: Double);
    procedure SetParamAsMemo(AParamName, AValue: AnsiString);

    property PluginName: AnsiString read FPluginName;
    property TableName: AnsiString read FTableName;
    property SelectedProfileName: AnsiString read FSelectedProfileName write SetSelectedProfileName;
    property SelectedStateName: AnsiString read FSelectedStateName write SetSelectedStateName;
    property SelectedFormatName: AnsiString read FSelectedFormatName write FSelectedFormatName;
    property KeyFields: TStrings read FKeyFields;
    property ColorFields: TStrings read FColorFields;
    property CalFields: TStrings read fCalFields write SetCalFields;
    property CalFieldsLabel: TStrings read fCalFieldsLabel write SetCalFieldsLabel;

    property DetailWhereSQL: AnsiString read FDetailWhereSQL write SetDetailWhereSQL;
    //property DataTransferStreamFormat: Integer read FDataTransferStreamFormat write SetDataTransferStreamFormat;

    property SQLData: TCnsSQLData read FSQLData;

    property ProfilesOfUser: TStrings read FProfilesOfUser;
    property StatesOfProfile: TStrings read FStatesOfProfile;
    property HaveBeenMarkDataset: Boolean read FHaveBeenMarkDataset write FHaveBeenMarkDataset;

    //    property InterLoadingData: Boolean read FInterLoadingData write FInterLoadingData;
//    property DetailDatasets: TList read FDetailDatasetList;
    property DetailsByIndex[Index: Integer]: TCnsDBtable read GetDetailDatasetByIndex;
    property Details[AName: AnsiString]: TCnsDBtable read GetDetailDataset;

    property ActiveMasterLink: Boolean read fActiveMasterLink write SetActiveMasterLink;

    property CnsTable: TCnsTable read FCnsTable;
    {$IFDEF ENABLE_REMOTE_MASTERLINK}
    property RemoteDetailFields: AnsiString read FRemoteDetailFieldNames write SetRemoteDetailFields;
    property RemoteMasterFields: AnsiString read GetRemoteMasterFields write SetRemoteMasterFields;
    property RemoteMasterSource: TDataSource read GetRemoteDataSource write SetRemoteDataSource;
    {$ENDIF}
    property ServerDBType: Integer read FServerDBType;
    property DBOwnername: AnsiString read FDBOwnername;
    property AnalyzeScriptSource: TStrings read FAnalyzeScriptSource;
    property DataAnalyzeScriptSource: TStrings read FDataAnalyzeScriptSource;
    property ScriptSource: TStrings read FScriptSource;

    property ListWebScript: TStrings read FListHtml;
    property EditWebScript: TStrings read FEdithtml;
    property ViewWebScript: TStrings read FViewHtml;
    property StartWebScript: TStrings read FStartHtml;

    property MyDataSource: TDataSource read FSelfDataSource;

    property Params: TParams read FParams;
    property DefaultValues: TStrings read FDefaultValues;
    property SpecialWhereSQL: TList read FSpecialWhereSQL;

    property InBusy: Boolean read fInRefreshTable;
  published
    property Active;

    property AppSrvClient: TCnsCustomDicomConnection read FAppSrvClient write FAppSrvClient;
    property ConnectionPoll: TCnsCustomDicomConnectionPoll read FConnectionPoll write SetConnectionPoll;

    property ObjectTaskSQL: TStrings read FObjectTaskSQL write SetObjectTaskSQL;
    property DataFileDirectory: AnsiString read FDataFileDirectory write FDataFileDirectory;
    property AddUpdateTime: Boolean read FAddUpdateTime write SetAddUpdateTime;

    property TableLoadMode: TCnsDBTableLoadMode read fTableLoadMode write fTableLoadMode;
    property WhereSQL: AnsiString read FWhereSQL write SetWhereSQL;
    property Database: AnsiString read FDatabase write FDatabase;
    property SQL: AnsiString read FSQL write SetSQL;

    property ObjectName: AnsiString read FObjectName write SetObjectName;
    property PHPScript: AnsiString read FPHPScript write SetPHPScript;
    property FetchCount: Integer read FFetchCount write FFetchCount;
    property FetchStart: Integer read FFetchStart write FFetchStart;

    property OnGetDefaultValue: TGetDefaultValueEvent read FOnGetDefaultValue write
      FOnGetDefaultValue;
    property OnSelectProfile: TSelectProfileEvent read FOnSelectProfileEvent write
      FOnSelectProfileEvent;
    property OnDataStateChange: TDataStateChangeEvent read FOnDataStateChangeEvent write
      FOnDataStateChangeEvent;
    property OnOpenDetailtable: TOnOpenDetailtable read fOnOpenDetailtable write
      fOnOpenDetailtable;
    property OnHttpGet: TCnsDicomConnectionHttpGetEvent read fOnHttpGet write fOnHttpGet;
    property OnHttpPost: TCnsDicomConnectionHttpPostEvent read fOnHttpPost write fOnHttpPost;

    {$IFNDEF LEVEL3}
    //    property DesignActivation;
    {$ENDIF}
    //    property AttachedTo;
    //    property AttachedAutoRefresh;
    //    property AttachMaxCount;
//    property AutoIncMinValue;
    property AutoCalcFields;
    property FieldDefs;
    property Filtered;
    property DeltaHandler;
    property EnableIndexes;
    property AutoReposition;
    property IndexFieldNames;
    property IndexName;
    property IndexDefs;
    property RecalcOnIndex;
    property RecalcOnFetch;
    property SortFields;
    property SortOptions;
    property ReadOnly;
    property Performance;
    property Standalone;
    property PersistentFile;
    property StoreDataOnForm;
    property Persistent;
    property PersistentBackup;
    property PersistentBackupExt;
    property ProgressFlags;
    property LoadLimit;
    property LoadedCompletely;
    property SaveLimit;
    property SavedCompletely;
    property EnableVersioning;
    property VersioningMode;
    property Filter;
    property FilterOptions;
    {$IFDEF ENABLEMASTERLINK}
    property MasterFields;
    property DetailFields;
    property MasterSource;
    {$ENDIF}
    //    property Version;
    property LanguageID;
    property SortID;
    property SubLanguageID;
    property LocaleID;
    property DefaultFormat;
    property CommaTextFormat;
    property PersistentFormat;
    property FormFormat;
    property OnProgress;
    property OnLoadRecord;
    property OnLoadField;
    property OnSaveRecord;
    property OnSaveField;
    property OnCompressBlobStream;
    property OnDecompressBlobStream;
    property OnSetupField;
    property OnSetupFieldProperties;
    property OnCompressField;
    property OnDecompressField;
    property OnSave;
    property OnLoad;
    property OnCompareFields;
    property OnFilterIndex;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    {$IFDEF LEVEL5}
    property BeforeRefresh;
    property AfterRefresh;
    {$ENDIF}
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
  end;

  TCnsUserItem = class
  private
    FPort: Integer;
    FCurrentProfile: string;
    FStatus: string;
    FUserName: string;
    FIP: string;
    FDialogForm: TForm;
    FOnLine: Boolean;
    procedure SetCurrentProfile(const Value: string);
    procedure SetDialogForm(const Value: TForm);
    procedure SetIP(const Value: string);
    procedure SetPort(const Value: Integer);
    procedure SetStatus(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetOnLine(const Value: Boolean);

  protected

  public
    constructor Create;
    destructor Destroy; override;
    property UserName: string read FUserName write SetUserName;
    property IP: string read FIP write SetIP;
    property Port: Integer read FPort write SetPort;
    property CurrentProfile: string read FCurrentProfile write SetCurrentProfile;
    property Status: string read FStatus write SetStatus;
    property DialogForm: TForm read FDialogForm write SetDialogForm;
    property OnLine: Boolean read FOnLine write SetOnLine;
  end;

  TCnsUserLogin = class(TComponent)
  private
    FConnection: TCnsCustomDicomConnection;

    FDatasetList: TList;

    FUserList: TThreadList;

    FUserCode: string;
    FUserName: string;
    FPassword: string;
    FIsGrouper: Boolean;
    FIsSysdba: Boolean;
    FIsSysdba1: Boolean;
    FIsSysdba2: Boolean;
    FIsSysdba3: Boolean;
    FIsSysdba4: Boolean;
    FIsSysdba5: Boolean;
    FIsSysdba6: Boolean;

    //FHospitalName: string;
    //FOEMName: string;

    FUserClass: Integer;
    FAllUserGroup: string;
    FPermit: TStrings;

    FUserOwner: string;

    FOnAfteruserLogin: TNotifyEvent;
    FServerApplicationVersion: Integer;

    FGroupTable: TCnsDBTable;
    fTableLoadMode: TCnsDBTableLoadMode;
    fOnHttpPost: TCnsDicomConnectionHttpPostEvent;
    FUserID: Integer;
    FDefaultInterface: Integer;
    FDefaultGroupID: Integer;
    FDefaultDept: string;
    fUserAuditMode: Integer;
    FMobilPhone: string;
    procedure SetConnection(const Value: TCnsCustomDicomConnection);
    function GetGroupTable: TCnsDBTable;
    function GetSeverTime: TDatetime;
    function GetItems(index: Integer): TCnsUserItem;
    function GetUserItemCount: Integer;
    function DoHttpPostDatabase(ADataset: TDicomAttributes): TDicomDataset;
    procedure SetMobilPhone(const Value: string);

  protected
    //
    function GetHospitalName: string;
    function GetOEMName: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function FindUserItem(AUserName, AIP: string): TCnsUserItem;
    function DoUserLogin(AUserCode, APassword: string): Boolean;
    function DoListUser: Boolean;
    function GetFile(AFileName: string): TDicomAttributes;
    procedure SetFile(ASourceFile, AFileName: string);
    function DoChangePassword(AUserCode, AStr: string): Boolean;
    function DoUserCheck(AUserCode, APassword: string;
      AClass: Integer): Boolean;

    function UpdateDatetime: Boolean;
    function AutoUpdate: Boolean;
    function UpdateToServer: Boolean;

    procedure DeleteDatasetEx(ADatasetName: string);
    function CreateDatasetEx(ADatasetName: string): TCnsDBTable;
    function GetDatasetByNameEx(AName: string): TCnsDBTable;

    property UserName: string read FUsername write FUserName;
    property UserOwner: string read FUserOwner;
    property UserCode: string read FUserCode;
    property UserID: Integer read FUserID;
    property UserAuditMode: Integer read fUserAuditMode;
    property DefaultGroupID: Integer read FDefaultGroupID;
    property DefaultInterface: Integer read FDefaultInterface;
    property DefaultDept: string read FDefaultDept;

    property Password: string read FPassword;
    property IsGrouper: Boolean read FIsGrouper;
    property IsSysdba: Boolean read FIsSysdba;
    property MobilPhone: string read FMobilPhone write SetMobilPhone;

    property CanRegister: Boolean read FIsSysdba1;
    property CanCheck: Boolean read FIsSysdba2;
    property CanReport: Boolean read FIsSysdba3;
    property CanAutit: Boolean read FIsSysdba4;
    property CanBurnImageCD: Boolean read FIsSysdba5;
    property CanDicomPrint: Boolean read FIsSysdba6;

    property HospitalName: string read GetHospitalName;
    property OEMName: string read GetOEMName;
    property UserClass: Integer read FUserClass;
    property AllUserGroup: string read FAllUserGroup;

    property Permit: TStrings read FPermit;

    property UserItems[index: Integer]: TCnsUserItem read GetItems;
    property UserCount: Integer read GetUserItemCount;

    property GroupTable: TCnsDBTable read GetGroupTable;
    property ServerApplicationVersion: Integer read FServerApplicationVersion;
  published
    property TableLoadMode: TCnsDBTableLoadMode read fTableLoadMode write fTableLoadMode;
    property Connection: TCnsCustomDicomConnection read FConnection write SetConnection;
    property OnAfteruserLogin: TNotifyEvent read FOnAfteruserLogin write FOnAfteruserLogin;
    property OnHttpPost: TCnsDicomConnectionHttpPostEvent read fOnHttpPost write fOnHttpPost;
  end;

  TImagesSelectedToPrint = class
  private
    FInstanceUID: AnsiString;
    FFrameIndex: integer;
    FWindowCenter: Integer;
    FWindowWidth: integer;
    Fbitmap: TBitmap;
    FAttributes: TDicomAttributes;
  protected
    procedure SetBitmap(Value: TBitmap);
  public
    constructor Create;
    destructor Destroy; override;

    property InstanceUID: AnsiString read FInstanceUID write FInstanceUID;
    property FrameIndex: integer read FFrameIndex write FFrameIndex;
    property WindowCenter: Integer read FWindowCenter write FWindowCenter;
    property WindowWidth: integer read FWindowWidth write FWindowWidth;
    property bitmap: TBitmap read Fbitmap write Setbitmap;
    property Attributes: TDicomAttributes read FAttributes write FAttributes;
  end;
  TCnsDMTableLoadMode = (dlmLoadAllImageFirst, dlmLoadBeforeUse, dlmLocalFiles);
  TCnsDMTable = class(TDicomDatasets)
  private
    FAppSrvClient: TCnsCustomDicomConnection;
    FCurrentindex: integer;
    FFetchCount: Integer;
    FStudyUID: AnsiString;
    FPName: AnsiString;
    //    FLocaleImagePath: AnsiString;
    //    FLoadMode: TCnsDicomLoadMode;
    FPrintList: TList;  
    FOnNewImage: TOnAddImageEvent;
    FSelectedDataset: TCnsDBTable;

    FLocalCacheDirectory: AnsiString;
    FUseLocalCache: Boolean;

    fUse_CGET_To_LoadImage: Boolean;
    FSpecifyLoadImageParam: AnsiString;
    FData1: TObject;
    FData2: TObject;
    procedure SetSpecifyLoadImageParam(const Value: AnsiString);
    procedure SetData1(const Value: TObject);
    procedure SetData2(const Value: TObject);

  protected

    procedure SetStudyuID(Value: AnsiString); virtual;
    procedure DoLoadImages_C_GET(StudyUID: AnsiString);
    procedure DoLoadImages_C_MOVE(StudyUID: AnsiString);
    procedure OnAcquire(const DibHandle: THandle; const XDpi: Word; const YDpi: Word; const
      CallBackData: LongInt);
    function LoadImages1(AProfileName, AStudyUID: AnsiString; AStrs: TStrings): Boolean;
    function DoOnNewImage(Sender: TObject; ADataset: TDicomDataset; AImageIndex: integer): Boolean;
    procedure DoOnNewImage1(Sender: TObject; ADataset: TDicomDataset; AImageIndex: integer);
    //        function TestDcmFileDir(ASTUDYUID: AnsiString; var AImageDir: AnsiString): Boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetSelectedForPrint(AIndex: Integer): TDicomAttributes; override;
    procedure SetAppSrvClient(Value: TCnsCustomDicomConnection);
    procedure SetPName(Value: AnsiString);

  public
    //    RelateData: Pointer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetStudyuIDEx(Value: AnsiString);

    procedure ClearSelectedImages;
    procedure AddSelectedImage(Index: Integer);
    procedure RemoveSelectedImage(Index: Integer);
    procedure SaveSelectedImagesToServer;
    procedure LoadSelectedImagesToPrint;

    procedure ScanSelectedImagesToPrint;
    function GetSelectedCountForPrint: integer; override;
    procedure PrintImage(ACanvas: TCanvas; rc: TRect; AIndex: Integer; AIsSelected: Boolean);
      override;

    procedure RefreshTable; virtual;

    procedure ScanImage(AIndex: Integer = -1; IsShowUI: Boolean = true);
    procedure CaptureImage(AIndex: Integer = -1; IsShowUI: Boolean = true);
    procedure ParseImage(x1, y1, x2, y2: integer);
    //    procedure EditImage;
    //    procedure ImportFrom(AFileName: AnsiString);
    procedure SaveToDicomDir(AFileName: AnsiString; AOnlySaveKeyImage: Boolean);
    procedure SaveToHtml(ADirName: AnsiString; AOnlySaveKeyImage, AWithLabel: Boolean);

    procedure ImportImageEx(ADataset: TDicomAttributes; AFileName: AnsiString; AIsMono: Boolean =
      false);
    function ImportImage(AFileName: AnsiString): TDicomDataset;
    procedure ExportImage(AIndex: Integer; AFileName: AnsiString; FilterIndex: Integer);

    function LoadFromDicomdir(AimagePath: AnsiString): Boolean;
    function LoadDcmFileDir(AImagePath: AnsiString): Boolean;
    function LoadDcmFileDirEx(AImagePath: AnsiString): Boolean;
    procedure ScanOldVRTextToDesc;
    property SelectedDataset: TCnsDBTable read FSelectedDataset;

    property LocalCacheDirectory: AnsiString read FLocalCacheDirectory write FLocalCacheDirectory;
    property UseLocalCache: Boolean read FUseLocalCache write FUseLocalCache;
    property Use_CGET_To_LoadImage: Boolean read fUse_CGET_To_LoadImage write fUse_CGET_To_LoadImage;
    property SpecifyLoadImageParam: AnsiString read FSpecifyLoadImageParam write SetSpecifyLoadImageParam;
  published
    property AppSrvClient: TCnsCustomDicomConnection read FAppSrvClient write SetAppSrvClient;

    property Data1: TObject read FData1 write SetData1;
    property Data2: TObject read FData2 write SetData2;

    property StudyUID: AnsiString read FStudyUID write SetStudyUID;
    property PName: AnsiString read FPName write SetPName;
    //    property LocaleImagePath: AnsiString read FLocaleImagePath write FLocaleImagePath;
    //    property LoadMode: TCnsDicomLoadMode read FLoadMode write FLoadMode;
    property Currentindex: Integer read FCurrentindex write FCurrentindex;
    property FetchCount: Integer read FFetchCount write FFetchCount;

    property OnNewImage: TOnAddImageEvent read FOnNewImage write FOnNewImage;
  end;

  TDcmIniFile = class(TCustomIniFile)
  private
    //    FConnection: TCnsCustomDicomConnection;
    FDataset: TCnsDBTable;
    //    function AddSection(const Section: AnsiString): TStrings;
    procedure LoadValues;
  public
    constructor Create(AConnection: TCnsCustomDicomConnection; const AFileName: AnsiString);
    destructor Destroy; override;
    procedure DeleteKey(const Section, Ident: string); override;
    procedure EraseSection(const Section: string); override;
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure UpdateFile; override;
    procedure WriteString(const Section, Ident, Value: string); override;
  end;

  (*  TFastIniFile = class(TCustomIniFile)
    private
      FIsChangFile: boolean;
      FSectionMap: TCIStrIntHashMap; //map: str <-> TCIStrHashMap
      function AddSection(const SectionName: string): TCIStrHashMap;
      function FindSection(const SectionName: string): TCIStrHashMap;
      procedure _ReadSectionValues(const Section: string; Strings: TStrings;
        const IsReadValue: boolean);
      procedure Clear();
      procedure privateLoadFromFile(const SrcFileName: string);
    protected
    public
      constructor Create(const DstFileName: string); //FileName can ''
      procedure LoadFromFile(const SrcFileName: string);
      destructor Destroy; override;

      function ReadString(const Section, Key, DefaultValue: string): string; override;
      procedure WriteString(const Section, Key, Value: string); override;
      procedure ReadSection(const Section: string; Strings: TStrings); override;
      procedure ReadSections(DstSectionNames: TStrings); override;
      procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
      procedure EraseSection(const Section: string); override;
      procedure DeleteKey(const Section, Key: string); override;
      procedure UpdateFile; override;

      function SectionExists(const Section: string): Boolean;
      function ValueExists(const Section, Key: string): Boolean;

      procedure SetFormStrings(SrcStrings: TStrings); virtual;
      procedure SaveToStrings(DstStrings: TStrings); virtual;
    end;  *)

  TDicomPrintOrientation = (dpoPortrait, dpoLandscape);
  TDicomFilmSize = (Film11INX14IN, Film8INX10IN, Film14INX17IN);
  TCnsDicomPrinter = class(TComponent)
  private
    FDatasets: TDicomDatasets;
    FServer: AnsiString;
    FPort: Integer;
    FCallingAE: AnsiString;
    FCalledAE: AnsiString;
    FPrintFormat: AnsiString;
    FPrintOrientation: TDicomPrintOrientation;
    FFilmSize: TDicomFilmSize;
    FCopys: Integer;
    FMagnificationType: AnsiString;
    FSmoothingType: AnsiString;
    FPolarity: AnsiString;
    FBorderDensity: AnsiString;
    FEmptyImageDensity: AnsiString;
    FTrim: AnsiString;
    FMediumType: AnsiString;
    FFilmDestination: AnsiString;
    FMinDensity: integer;
    FMaxDensity: integer;
    FIsColor: Boolean;
    FPrintWithDefaultParam: Boolean;
    procedure SetPrintWithDefaultParam(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(AFromIndex, ACount: Integer);
  published
    property Datasets: TDicomDatasets read FDatasets write FDatasets;
    property Server: AnsiString read FServer write FServer;
    property Port: Integer read FPort write FPort;
    property CallingAE: AnsiString read FCallingAE write FCallingAE;
    property CalledAE: AnsiString read FCalledAE write FCalledAE;
    property PrintFormat: AnsiString read FPrintFormat write FPrintFormat;
    property PrintOrientation: TDicomPrintOrientation read FPrintOrientation write
      FPrintOrientation;
    property FilmSize: TDicomFilmSize read FFilmSize write FFilmSize;
    property Copys: Integer read FCopys write FCopys;
    property MagnificationType: AnsiString read FMagnificationType write FMagnificationType;
    property SmoothingType: AnsiString read FSmoothingType write FSmoothingType;
    property Polarity: AnsiString read FPolarity write FPolarity;
    property BorderDensity: AnsiString read FBorderDensity write FBorderDensity;
    property EmptyImageDensity: AnsiString read FEmptyImageDensity write FEmptyImageDensity;
    property Trim: AnsiString read FTrim write FTrim;
    property MediumType: AnsiString read FMediumType write FMediumType;
    property FilmDestination: AnsiString read FFilmDestination write FFilmDestination;
    property MinDensity: integer read FMinDensity write FMinDensity;
    property MaxDensity: integer read FMaxDensity write FMaxDensity;
    property IsColor: Boolean read FIsColor write FIsColor;
    property PrintWithDefaultParam: Boolean read FPrintWithDefaultParam write SetPrintWithDefaultParam;
  end;

  TSRContentItemValueType = (srvtNONE, srvtTEXT, srvtNUM, srvtCODE, srvtDATETIME, srvtDATE
    , srvtTIME, srvtUIDREF, srvtPNAME, srvtCOMPOSITE, srvtIMAGE, srvtWAVEFORM
    , srvtSCOORD, srvtTCOORD, srvtCONTAINER);
  TSRContentItemCompletionFlag = (srcfNONE, srcfPARTIAL, // = Partial content
    srcfCOMPLETE); //= Complete content;
  TSRContentItemRelationshipType = (srrtNONE, srrtCONTAINS, srrtHAS_PROPERTIES,
    srrtHAS_OBS_CONTEXT, srrtHAS_ACQ_CONTEXT, srrtINFERRED_FROM,
    srrtSELECTED_FROM, srrtHAS_CONCEPT_MOD);
  TSRContentItemVerificationFlag = (srvfNONE, srvfUNVERIFIED, // = Not attested to
    srvfVERIFIED); // Attested to by a Verifying
  TSRContentItem = class;

  TSRContentItem = class
  private
    fIsRoot: Boolean;
    fItems: TList;
    fAttributes: TDicomAttributes;
    fContinuityOfContent: Boolean;
    fContentLevel: Integer;
    //FValueType: TSRContentItemValueType;
    //FCompletionFlag: TSRContentItemCompletionFlag;
    //FRelationshipType: TSRContentItemRelationshipType;
    //FVerificationFlag: TSRContentItemVerificationFlag;
    function GetItems(index: Integer): TSRContentItem;
    procedure SetValueType(const Value: TSRContentItemValueType);
    function GetValueType: TSRContentItemValueType;
    procedure SetCompletionFlag(const Value: TSRContentItemCompletionFlag);
    procedure SetRelationshipType(const Value: TSRContentItemRelationshipType);
    procedure SetVerificationFlag(const Value: TSRContentItemVerificationFlag);
    function GetCompletionFlag: TSRContentItemCompletionFlag;
    function GetRelationshipType: TSRContentItemRelationshipType;
    function GetVerificationFlag: TSRContentItemVerificationFlag;
    function GetCodeMeaning: AnsiString;
    function GetCodeValue: AnsiString;
    function GetCodingSchemeDesignator: AnsiString;
    function GetCount: Integer;
  protected

  public
    constructor Create(ADataset: TDicomAttributes; AContinuityOfContent: Boolean);
    destructor Destroy; override;

    procedure Clear;
    function AddContentItem(ADataset: TDicomAttributes): TSRContentItem;

    function AsString: AnsiString;
    function AsDatetime: TDatetime;

    procedure ExportToHtml(AStrs: TStringList);

    property CodeValue: AnsiString read GetCodeValue;
    property CodingSchemeDesignator: AnsiString read GetCodingSchemeDesignator;
    property CodeMeaning: AnsiString read GetCodeMeaning;

    property CompletionFlag: TSRContentItemCompletionFlag read GetCompletionFlag write SetCompletionFlag;
    property RelationshipType: TSRContentItemRelationshipType read GetRelationshipType write SetRelationshipType;
    property VerificationFlag: TSRContentItemVerificationFlag read GetVerificationFlag write SetVerificationFlag;

    property ValueType: TSRContentItemValueType read GetValueType write SetValueType;

    property ContinuityOfContent: Boolean read fContinuityOfContent;
    property ContentLevel: Integer read fContentLevel;
    property Count: Integer read GetCount;
    property Items[index: Integer]: TSRContentItem read GetItems;
    property Attributes: TDicomAttributes read fAttributes;
  published

  end;

var
  //  CurrentUserLimit: AnsiString;
  CnsErrorMessage: AnsiString;
  CnsErrorCode: Integer;

  CurrentTempImageIndex: integer;

  FLocalImagesTable: TCnsDBTable;
  FLocalStudiesTable: TCnsDBTable;

  fCaptureForm: TForm;

function ComponentToString(Component: TComponent): AnsiString;
function StringToComponent(AOwner: TComponent; Value: AnsiString): TComponent;

function GetVersionInfo(AFileName: string; var AAppName: AnsiString; var AVersion: Integer): Boolean;

function ResampleForPrint(DicomPrintDPI: Integer; bm: TBitmap; d1: TDicomImage): TBitmap;
function ResampleImage(AId: integer; bm: TBitmap): TBitmap;

function PrintDicomDatasetsEx(ADatasets: TDicomDatasets; AServer: AnsiString; APort: Integer;
  CallingAE, CalledAE, APrintFormat, APrintOrientation, AFilmSize: AnsiString;
  ACopys, AFromIndex, ALimitCount, AImagePage: Integer;
  AMagnificationType, ASmoothingType, APolarity, ABorderDensity, AEmptyImageDensity, ATrim,
  AMediumType, AFilmDestination: AnsiString;
  AMinDensity, AMaxDensity: integer; IsColor: Boolean; ATimeOutSec: Integer;
  n1: TNetworkQueueItem; AOnAfterSend: TCnsDicomConnectionSendImageEvent;
  ANeedDetailLog: Boolean; APrintWithDefaultParam: Boolean): Boolean;

function SaveSQToDataset(AData: TDicomAttribute): TDataset;
function SaveListToDataset(AList: TList): TDataset;

function SaveLocalDicomImage(Apath: AnsiString; ADataset: TDicomAttributes; InsertCacaheDB: Boolean =
  TRUE): TFileStream;
function LoadLocalDicomImage(Apath: AnsiString): TFileStream;
function TestCacheTableExists(APath: AnsiString): Boolean;
procedure DeleteLocalDicomImage(APath: AnsiString);

procedure BurnDicomCD(ADatasets: TDicomDatasets); overload;
procedure BurnDicomCD(ADatasetsList: TList); overload;

procedure PrepareParam(FParams: TParams; AAtt: TDicomAttribute);

function ListAttributesToDataset(AAttributes: TDicomAttributes): TDataset;
function MyVarAsType(AStr: string): Integer;

implementation

uses
  CnsJpgGr, CnsScan, CnsDiGrph, ImportAVIProcessing, shellapi, DCM_Client_Retry,
  {$IFDEF NEED_DIRECTX_CAPTURE}Video2Dicom, {$ENDIF}
  CnsTifGr, CnsPngGr, CnsPpmGr, CnsPcxGr, CnsDcxGr, CnsTgaGr,
  CnsDirScan, ImageAttributesList, SelectPacsHost, DCM_MpegWrite,
  Save2MpegStatus, Dicom2AVIStatus
  {$IFDEF NEED_DIRECTX_CAPTURE}, kxBurnImageSinglePatient{$ENDIF}
  {$IFDEF LEVEL6}, DateUtils{$ENDIF}
  {$IFNDEF LEVEL6}, FileCtrl{$ENDIF};


function MyVarAsType(AStr: string): Integer;
begin
  if AStr <> '' then
    Result := StrToInt(AStr)
  else
    Result := 0;
end;

{ TCnsDicomConnection }

procedure BurnDicomCD(ADatasets: TDicomDatasets);
begin
  {$IFDEF NEED_DIRECTX_CAPTURE}
  if ADatasets.Count > 0 then
    with TBurnSinglepatientDataCDForm.Create(nil) do
    try

      DatasetList.Add(ADatasets);
      RefreshStudyList;
      //ADatasets := DCMMultiImage1.DicomDatasets;
      //Edit1.Text := 'MyDicomCD'; //+ADatasets[0].Attributes.GetString($10, $10);
      {      if not assigned(ADatasets) then
              ADatasets := DicomMultiViewer1.DicomDatasets;
            if not assigned(ADatasets) then
              ADatasets := DicomMultiViewer1.ActiveView.DicomDatasets;
            if assigned(ADatasets) and (ADatasets.Count > 0) then}
      if DatasetList.Count > 0 then
        ShowModal;
    finally
      Free;
    end;
  {$ENDIF}
end;

procedure BurnDicomCD(ADatasetsList: TList);
var
  das1: TDicomDatasets;
  //  da1: TDicomAttributes;
  //  dd1: TDicomAttribute;
  i: integer;
begin
  {$IFDEF NEED_DIRECTX_CAPTURE}
  with TBurnSinglepatientDataCDForm.Create(nil) do
  try
    for i := 0 to ADatasetsList.Count - 1 do
    begin
      das1 := TDicomDatasets(ADatasetsList[i]);
      if das1.Count > 0 then
        DatasetList.Add(das1);
    end;
    RefreshStudyList;
    //ADatasets := DCMMultiImage1.DicomDatasets;
    //Edit1.Text := 'MyDicomCD'; //+ADatasets[0].Attributes.GetString($10, $10);
    {      if not assigned(ADatasets) then
            ADatasets := DicomMultiViewer1.DicomDatasets;
          if not assigned(ADatasets) then
            ADatasets := DicomMultiViewer1.ActiveView.DicomDatasets;
          if assigned(ADatasets) and (ADatasets.Count > 0) then}
    if DatasetList.Count > 0 then
      ShowModal;
  finally
    Free;
  end;
  {$ENDIF}
end;

constructor TCnsDicomPrinter.Create;
begin
  FDatasets := nil;
  FServer := '127.0.0.1';
  FPort := 104;
  FCallingAE := '';
  FCalledAE := '';
  FPrintFormat := 'STANDARD\4,5';
  FPrintOrientation := dpoPortrait;
  FFilmSize := Film14INx17IN;
  FCopys := 1;
  FMagnificationType := 'CUBIC';
  FSmoothingType := 'SHARP';
  FPolarity := '';
  FBorderDensity := 'BLACK';
  FEmptyImageDensity := 'BLACK';
  FTrim := 'YES';
  FMediumType := 'BLUE FILM';
  FFilmDestination := '';
  FMinDensity := 30;
  FMaxDensity := 290;
  FIsColor := false;
  FPrintWithDefaultParam := true;
end;

destructor TCnsDicomPrinter.Destroy;
begin

  inherited;
end;

procedure TCnsDicomPrinter.Execute(AFromIndex, ACount: Integer);
var
  msgid: Integer;
  tx, da1: TDicomAttribute;
  cmd1, ImageSequenceHolder, Printer, Session, Filmbox, RefSessionItem: TDicomAttributes;
  KxDcmClient1: TCnsDicomConnection;
  imno: Integer;
  imnofilm: Integer;
  uidint: Integer;
  uidroot: AnsiString;
  BFSUID, FilmboxUID: AnsiString;
  r: TDicomResponse;
  pcid1: Byte;
  status1: Integer;
  ste1: TStatusEntry;
begin
  if (not assigned(FDatasets)) then
    raise exception.Create('No Dataset to print');
  if FDatasets.Count <= 0 then
    raise exception.Create('No Dataset to print');

  uidint := 0;
  msgid := 1;
  Printer := nil;
  //uidroot := '1.2.40.0.13.0.192.168.1.10.17818297.1060271648171.';

  KxDcmClient1 := TCnsDicomConnection.Create(nil);
  KxDcmClient1.ResetSynTax;
  KxDcmClient1.Host := Server;
  KxDcmClient1.Port := Port;
  KxDcmClient1.CallingTitle := CallingAE;
  KxDcmClient1.CalledTitle := CalledAE;
  KxDcmClient1.AddPresentationContext(Verification);
  if IsColor then
    KxDcmClient1.AddPresentationContext(BasicColorPrintManagementMetaSOPClass)
  else
    KxDcmClient1.AddPresentationContext(BasicGrayscalePrintManagementMetaSOPClass); //
  KxDcmClient1.AddPresentationContext(BasicAnnotationBox);
  KxDcmClient1.AddPresentationContext(BasicPrintImageOverlayBox);
  KxDcmClient1.AddPresentationContext(PresentationLUT);
  KxDcmClient1.AddPresentationContext(PrintJob);
  KxDcmClient1.AddPresentationContext(PrinterConfigurationRetrieval);

  KxDcmClient1.Connect;

  //uidroot := '1.2.40.0.13.0.' + KxDcmClient1.GetLocalIP + '.' + FormatDatetime('yyyymmdd.hhnnsszzzz', now) + '.';
  uidroot := '1.2.40.0.13.0.' + IntToStr(Round(now * 10000)) + '.';

  try
    try
      r := KxDcmClient1.SendRequest;
    except
      on e: Exception do
      begin
        ShowMessage(V_CONNECT_REJECT_ERROR + e.Message);
        exit;
      end;
    end;
    if r = nil then
      ShowMessage(dcmDicomConnectNoACK)
    else
      if r is TDicomAbort then
      raise Exception.Create('Abort ' + TDicomAbort(r).Text)
    else
      if r is TDicomReject then
      raise Exception.Create('Reject ' + TDicomReject(r).Text)
    else
      if r is TAcknowledge then
    begin

    end
    else
      raise Exception.Create(V_CONNECT_REJECT_ERROR);
    if IsColor then
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicColorPrintManagementMetaSOPClass)
    else
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicGrayscalePrintManagementMetaSOPClass);

    cmd1 := createNGetRequest(msgid, uidPrinter, UIDS.AsString(PrinterModelSOPInstance));
    inc(msgid);
    if KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
    begin
      cmd1.Free;
      if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
      begin
        Printer := KxDcmClient1.FAssociation.ReceiveDatasets[0];
        KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
        //        Printer.ListAttrinute('printer:', KxForm.Memo1.Lines);
      end;
    end
    else
    begin
      ShowMessage('ger DICOM PRINTER error');
      exit;
    end;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      raise exception.Create(ste1.toString);
    end;

    Session := TDicomAttributes.Create;
    Session.AddVariant($2000, $10, Copys); // copies

    {.$IFDEF SEND_ALL_PRINT_PARAM}
    if PrintWithDefaultParam then
    begin
      Session.AddVariant($2000, $20, 'HIGH');
      Session.AddVariant($2000, $30, MediumType);
      Session.AddVariant($2000, $40, FilmDestination);
    end;
    {.$ENDIF}
    {receive dataset>:706[2000:0020](PrintPriority)CS=<1>HIGH
    receive dataset>:707[2000:0030](MediumType)CS=<1>BLUE FILM
    receive dataset>:708[2000:0040](FilmDestination)CS=<1>BIN_1
    }
    inc(uidint);
    {$IFNDEF USE_NULL_UID_ROOT}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, uidroot + IntToStr(uidint), true);
    {$ELSE}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, '', true);
    {$ENDIF}
    inc(msgid);
    if KxDcmClient1.SendCommand(pcid1, cmd1, Session) then
    begin
      cmd1.Free;
      Session.Free;
    end
    else
      exit;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      raise exception.Create(ste1.toString);
    end;

    BFSUID := uidroot + IntToStr(uidint);
    imno := AFromIndex;
    while (imno < Datasets.Count) do
    begin
      imnofilm := 0;

      Filmbox := TDicomAttributes.Create;
      try
        Filmbox.AddVariant($2010, $10, PrintFormat); //'STANDARD\2,1');
        if PrintOrientation = dpoPORTRAIT then
          Filmbox.AddVariant($2010, $40, 'PORTRAIT') //LANDSCAPE
        else
          Filmbox.AddVariant($2010, $40, 'LANDSCAPE');
        case FilmSize of
          Film14INx17IN:
            Filmbox.AddVariant($2010, $50, '14INx17IN');
        end;

        {.$IFDEF SEND_ALL_PRINT_PARAM}
        if PrintWithDefaultParam then
        begin
          Filmbox.AddVariant($2010, $60, MagnificationType); //OptionsBox.Magnification

          Filmbox.AddVariant($2010, $80, SmoothingType); //SmoothingType

          Filmbox.AddVariant($2010, $100, BorderDensity); //"BLACK"   BorderDensity
          Filmbox.AddVariant($2010, $110, EmptyImageDensity); //"BLACK"   EmptyImageDensity
          Filmbox.AddVariant($2010, $120, MinDensity); //MinDensity
          Filmbox.AddVariant($2010, $130, MaxDensity); //MaxDensity

          Filmbox.AddVariant($2010, $140, Trim); //"NO"   //Trim
        end;
        {.$ENDIF}
        {receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
        receive dataset>:719[2010:0100](BorderDensity)CS=<1>BLACK
        receive dataset>:720[2010:0110](EmptyImageDensity)CS=<1>1
        receive dataset>:721[2010:0120](MinDensity)US=<1>2
        receive dataset>:722[2010:0130](MaxDensity)US=<1>250
        receive dataset>:723[2010:0140](Trim)CS=<1>YES
        }
        RefSessionItem := TDicomAttributes.Create;
        RefSessionItem.AddVariant(8, $1150, UIDS.AsString(BasicFilmSession));
        //doSOP_BasicFilmSession
        {$IFNDEF USE_NULL_UID_ROOT}
        RefSessionItem.AddVariant(8, $1155, BFSUID);
        {$ELSE}
        RefSessionItem.Add(8, $1155);
        {$ENDIF}
        da1 := Filmbox.Add($2010, $500);
        da1.AddData(RefSessionItem);

        uidint := uidint + 1;

        {$IFNDEF USE_NULL_UID_ROOT}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, uidroot + IntToStr(uidint), true);
        {$ELSE}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, '', true);
        {$ENDIF}
        inc(msgid);
        if KxDcmClient1.SendCommand(pcid1, cmd1, Filmbox) then
        begin
          cmd1.Free;
          Filmbox.Free;
          Filmbox := nil;
          if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
          begin
            Filmbox := KxDcmClient1.FAssociation.ReceiveDatasets[0];
            KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
            //            Filmbox.ListAttrinute('Filmbox:', KxForm.Memo1.Lines);
          end
          else
          begin
            raise Exception.Create(dcmDicomPrintFilmCreatingError);
          end;
        end
        else
          exit;
        FilmboxUID := uidroot + IntToStr(uidint);
        if assigned(FilmBox) then
        begin
          tx := Filmbox.Item[$2010, $510];
          if (not assigned(tx)) or (tx.GetCount <= 0) then
          begin
            raise Exception.Create(V_DICOM_PRINT_FILMBOX_ERROR);
          end;
          while (imno < Datasets.Count) and (imnofilm < tx.GetCount) and (imnofilm < ACount) do
          begin
            ImageSequenceHolder := TDicomAttributes.Create;
            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if PrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, MagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, SmoothingType); //SmoothingType
              //ImageSequenceHolder.AddVariant($2020, $20, Polarity); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            ImageSequenceHolder.Add($2020, $110).AddData(Datasets.Item[imno].Attributes);

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox,
              tx.Attributes[imnofilm].GetString(8, $1155));
            inc(msgid);
            try
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                exit;
            finally
              cmd1.Free;
              ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;

            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end
        else
        begin
          while (imno < Datasets.Count) and (imnofilm < ACount) do
          begin
            ImageSequenceHolder := TDicomAttributes.Create;

            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if PrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, MagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, SmoothingType); //SmoothingType
              //ImageSequenceHolder.AddVariant($2020, $20, Polarity); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            ImageSequenceHolder.Add($2020, $110).AddData(Datasets.Item[imno].Attributes);

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox, '');
            inc(msgid);
            try
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                exit;
            finally
              cmd1.Free;
              ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;

            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end;

        cmd1 := createActionRequest(msgid, BasicFilmBox, FilmboxUID, False, 1);
        inc(msgid);
        try
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
          begin
            status1 := KxDcmClient1.GetState;
            if status1 <> 0 then
            begin
              ste1 := DicomStatus.getStatusEntry(status1);
              raise exception.Create(ste1.toString);
            end;
            exit;
          end;
        finally
          cmd1.Free;
        end;

        cmd1 := createDeleteRequest(msgid, BasicFilmBox, FilmboxUID);
        inc(msgid);
        try
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
            exit;
        finally
          cmd1.Free;
        end;

      finally
        if assigned(Filmbox) then
          Filmbox.Free;
      end;
    end;
  finally
    if assigned(Printer) then
      Printer.Free;
    //    KxDcmClient1.Disconnect;
    KxDcmClient1.Free;
  end;
end;
{procedure TCnsDicomConnectionThread.Execute;
begin
  while not Terminated do
  begin
        if not FClient.Connected then
          Terminate
        else
        try
          //FClient.ReadBuffer(CB, SizeOf(CB));
          //Synchronize(HandleInput);
        except
        end;
  end;
end;
}

function ComponentToString(Component: TComponent): AnsiString;
var
  BinStream: TMemoryStream;
  StrStream: TStringStream;
  s: AnsiString;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result := StrStream.DataString;
    finally
      StrStream.Free;

    end;
  finally
    BinStream.Free
  end;
end;

function StringToComponent(AOwner: TComponent; Value: AnsiString): TComponent;
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(nil);

    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

function TCnsDicomConnection.GetLocalIP: AnsiString;
begin
  //Result := FSocket.LocalIPAddress;
  Result := FSocket.LocalIPAddress;
end;

function TCnsDicomConnection.GetState: integer;
begin
  Result := 0;

  if assigned(FAssociation.ReceiveCommand) then
  begin
    Result := FAssociation.ReceiveCommand.getInteger(0, $900);
  end;
end;

procedure TCnsDicomConnection.DoOnDisconnected;
begin
  if Assigned(OnDisConnected) then
  begin
    OnDisConnected(Self);
  end;
  if FAssociation.IsConnected then
  begin
    FAssociation.Init;
  end;
end;

procedure TCnsDicomConnection.addPresentationContext(APresentationContext: Integer);
var
  i: integer;
begin
  for i := 0 to FPresentationContextCount - 1 do
    if FPresentationContext[i] = APresentationContext then
      exit;
  FPresentationContext[FPresentationContextCount] := APresentationContext;
  inc(FPresentationContextCount);
end;

procedure TCnsDicomConnection.ClearPresentationContext;
begin
  if (FAssociation.IsConnected) then
    raise Exception.Create(V_PLEASE_RECONNECT_TO_SERVER);
  FPresentationContextCount := 0;
end;

procedure TCnsDicomConnection.Disconnect;
var
  i: integer;
begin
  if (FAssociation.IsConnected) and FSocket.Connected then
  begin
    try
      FAssociation.sendReleaseRequest;
    except
      exit;
    end;
    if (FAssociation.IsConnected) and FSocket.Connected then
    begin
      i := FAssociation.ReadPduType;
      if i = 6 then
        FAssociation.receiveReleaseResponse(i);
    end
  end;
  FAssociation.Clear;
  FAssociation.Init;
  FSocket.Disconnect;
end;

procedure TCnsDicomConnection.Connect(const ATimeout: Integer);
begin
  FSocket.Host := self.Host;
  FSocket.Port := self.Port;
  FSocket.DoConnect;
end;

procedure TCnsDicomConnection.SetRetryHostList(Value: TStrings);
begin
  FRetryHostList.Assign(Value);
end;

function TCnsDicomConnection.MyBoolToStr(const p_par:boolean):string;
begin
  if p_par then begin
    MyBoolToStr := '1';
  end else begin
    MyBoolToStr := '0';
  end;
end;

procedure TCnsDicomConnection.Conn_wrt_log (str:string);
begin
  MnLg_ev(str,v_log_filename);
end;

procedure TCnsDicomConnection.MySetTransferSyntax( p_MainTransferSyntax : Integer = 0; p_quality : Integer = 100 );
begin
  // 25.01.2013 FOMIN
  //  FAssociation.ReceiveTimeout := fReceiveTimeout;
  FAssociation.v_quality := p_quality;
  SetLength(FTransferSyntaxes, 0);
  if p_MainTransferSyntax=0 then
  begin
    SetLength(FTransferSyntaxes, 7);
    FTransferSyntaxes[0] := ImplicitVRLittleEndian;
    FTransferSyntaxes[1] := ExplicitVRLittleEndian;
    FTransferSyntaxes[2] := ExplicitVRBigEndian;

    FTransferSyntaxes[3] := JPEGLossless;
    FTransferSyntaxes[4] := RLELossless;
    FTransferSyntaxes[5] := JPEGBaseline;
    FTransferSyntaxes[6] := JPEGExtendedProcess_2_4;
  end else
  begin
    SetLength(FTransferSyntaxes, 4);
    FTransferSyntaxes[0] := ImplicitVRLittleEndian;
    FTransferSyntaxes[1] := ExplicitVRLittleEndian;
    FTransferSyntaxes[2] := ExplicitVRBigEndian;

    FTransferSyntaxes[3] := p_MainTransferSyntax;
  end;
end;

constructor TCnsDicomConnection.Create(AOwner: TComponent); 
//var
//  MutexHandle: integer;
{$IFDEF FOR_TRIAL_VERSION}
  function IsIDERuning: Boolean;
  begin
    Result := (FindWindow('TAppBuilder', nil) <> 0) or
      (FindWindow('TPropertyInspector', nil) <> 0) or
      (FindWindow('TAlignPalette', nil) <> 0);
  end;
  {$ENDIF}

begin
  {$IFDEF FOR_TRIAL_VERSION}
  if not IsIDERuning then
    ShowMessage('You are eval dicomvcl trial. Please www.dicomvcl.com for more.');
  {$ENDIF}

  inherited Create(AOwner);

  fReceiveTimeout := 120000;

  FCanRetryConnected := true;
  FRetryHostList := TStringList.Create;
  FRetryHostCurrentIndex := 0;
  FRetryHostLastIndex := -1;

  FSocket := TKxSockClient.Create(self);
  FSocket.OutputBufferSize := bsfHUGE;

  FHost := '127.0.0.1';
  FPort := 104;
  //  FLimit := '';

  System.SetLength(FPresentationContext, 128);
  FPresentationContextCount := 0;

  FCallingTitle := '';
  FCalledTitle := '';
  FMaxPduSize := 1 * 1024 * 1024;
  //  LastStudyUID := '';

  FMessageID := 0;

  FAssociation := TAssociation.Create(FSocket);

  {$IFDEF ECLZLIBTransferSyntax}
  SetLength(FTransferSyntaxes, 10);
  FTransferSyntaxes[0] := ImplicitVRLittleEndian;
  FTransferSyntaxes[1] := ExplicitVRLittleEndian;
  FTransferSyntaxes[2] := ExplicitVRBigEndian;
  FTransferSyntaxes[3] := JPEGLossless;
  FTransferSyntaxes[4] := RLELossless;
  FTransferSyntaxes[5] := JPEGBaseline;
  FTransferSyntaxes[6] := JPEGExtendedProcess_2_4;

  FTransferSyntaxes[7] := zlibFastestTransferSyntax;
  FTransferSyntaxes[8] := ppmFastestTransferSyntax;
  FTransferSyntaxes[9] := bzipFastestTransferSyntax;
  {$ELSE}
    SetLength(FTransferSyntaxes, 7);
    FTransferSyntaxes[0] := ImplicitVRLittleEndian;
    FTransferSyntaxes[1] := ExplicitVRLittleEndian;
    FTransferSyntaxes[2] := ExplicitVRBigEndian;

    FTransferSyntaxes[3] := JPEGLossless;
    FTransferSyntaxes[4] := RLELossless;
    FTransferSyntaxes[5] := JPEGBaseline;
    FTransferSyntaxes[6] := JPEGExtendedProcess_2_4;

  {$ENDIF}
end;

procedure TCnsDicomConnection.ResetSynTax;
begin
  SetLength(FTransferSyntaxes, 3);
  FTransferSyntaxes[0] := ImplicitVRLittleEndian;
  FTransferSyntaxes[1] := ExplicitVRLittleEndian;
  FTransferSyntaxes[2] := ExplicitVRBigEndian;
end;

procedure TCnsDicomConnection.SetTransferSyntax(const Values: array of Variant);
var
  i: Integer;
begin
  SetLength(FTransferSyntaxes, High(Values) + 1);
  for I := 0 to High(Values) do
    FTransferSyntaxes[i] := Values[I];
end;

destructor TCnsDicomConnection.Destroy;
begin
  Disconnect;

  if assigned(FAssociation) then
  begin
    //FAssociation.sendAbort(DICOM_UL_SERVICE_USER_abort, UNEXPECTED_PDU);
    FAssociation.Free;
    FAssociation := nil;
  end;

  SetLength(FTransferSyntaxes, 0);

  FSocket.Free;
  FSocket := nil;

  FRetryHostList.Free;
  FRetryHostList := nil;

  inherited Destroy;
end;

procedure TCnsDicomConnection.DoOnConnected;
begin
  if Assigned(OnConnected) then
  begin
    OnConnected(Self);
  end;
end;

procedure TCnsDicomConnection.SetHost(const Value: AnsiString);
begin
  FHost := Value;
  FSocket.Host := FHost;
end;

procedure TCnsDicomConnection.SetPort(const Value: integer);
begin
  FPort := Value;
  FSocket.Port := FPort;
end;

function TCnsDicomConnection.Connected: Boolean;
begin
  Result := FSocket.Connected;
end;

function TCnsDicomConnection.C_Echo: Boolean;
var
  //  str1: AnsiString;
  k: Integer;
  r: Boolean;
  abort1: TDicomAbort;
  da1: TDicomAttributes;
  MyList: TList;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    AddPresentationContext(Verification);
  end;
  Result := SendDicomRequest(C_ECHO_REQUEST, PresentationContext[0], '', nil);
  if Result then
  begin
    MyList := TList.Create;
    try
      while true do
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];
          ReceiveDatasets.Clear;
          MyList.Add(da1);
          //        ds1 := TDicomDataset.Create(da1);
          //        Add(ds1);
                  //TImageForm(FImageForm).Viewer1.AddImage(ds1);
                  //            FOnAddImage(self, ds1)
          SendStatus(0);
          //          DoSleepEx(1); // allow sockets to digest tcpip.sys packets...
          //          ProcessWindowsMessageQueue;

        end
        else
        begin
          break;
        end;
        k := FAssociation.ReadPduType;
        if k = 4 then
        begin
          repeat
            r := FAssociation.ReceiveDataPdu(k);
            if not r then
            begin
              k := FAssociation.ReadPduType;
              if k = 7 then
              begin
                abort1 := FAssociation.receiveAbort(k);
                Disconnect;
                raise Exception.Create(V_RECEIVE_ABORT_ERROR + abort1.Text);
              end;
              if k = 5 then
              begin //sendReleaseRequest
                FAssociation.receiveReleaseRequest(k);
                FAssociation.sendReleaseResponse;
                Disconnect;
                raise Exception.Create(V_RECEIVE_RELEASE_REQUEST_ERROR);
              end;
              //        if k <> 4 then
              //          raise Exception.Create('No DataPdu To receive!');
            end
            else
              break;
          until r;
        end
        else
          raise Exception.Create(V_NO_IMAGE_RECEIVE);
      end;
    finally
      for k := 0 to MyList.Count - 1 do
        ReceiveDatasets.Add(MyList[k]);
      MyList.Clear;
      MyList.Free;
    end;
  end;
end;

function TCnsDicomConnection.C_MOVE(ADataset: TDicomAttributes): Boolean;
var
  str1: AnsiString;
  k: Integer;
  r: Boolean;
  abort1: TDicomAbort;
  da1: TDicomAttributes;
  MyList: TList;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    str1 := ADataset.GetString(78);

  {  if str1 = 'PATIENT' then
      AddPresentationContext(PatientRootQueryRetrieveInformationModelFIND)
    else
//      AddPresentationContext(StudyRootQueryRetrieveInformationModelFIND); 
      AddPresentationContext(PatientStudyOnlyQueryRetrieveInformationModelFIND);
    AddCGETPresentationContexts(False);
    Conn_wrt_log('AddFINDPresentationContext'); }

    if str1 = 'PATIENT' then
      AddPresentationContext(PatientRootQueryRetrieveInformationModelMOVE)
    else
      AddPresentationContext(StudyRootQueryRetrieveInformationModelMOVE);
    AddCGETPresentationContexts(False);
    Conn_wrt_log('AddMOVEPresentationContext');

    // FOMIN 13.08.2012 from c_get // 1.2.840.10008.5.1.4.1.1.128
    // addEntry(4151, TUIDEntry.Create(4151, '1.2.840.10008.5.1.4.1.1.128',
    //      'Positron Emission Tomography Image Storage SOP Class', 'PE', 1));
    // PositronEmissionTomographyImageStorage
  //  AddPresentationContext(DXImageStorageForProcessing);
  //  addPresentationContext(BasicTextSR);
  //  addPresentationContext(EnhancedSR);
  //  addPresentationContext(BasicVoiceAudioWaveformStorage);
  
  end;

  Conn_wrt_log('SendDicomRequest C_MOVE_REQUEST ');
  Result := SendDicomRequest(C_MOVE_REQUEST, PresentationContext[0], '', ADataset);
  Conn_wrt_log('C_MOVE_REQUEST Result='+MyBoolToStr(Result) );
  if Result then
  begin
    MyList := TList.Create;
    try
      while true do
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];
          ReceiveDatasets.Clear;
          MyList.Add(da1);
          //        ds1 := TDicomDataset.Create(da1);
          //        Add(ds1);
                  //TImageForm(FImageForm).Viewer1.AddImage(ds1);
                  //            FOnAddImage(self, ds1)
          SendStatus(0);
          //          DoSleepEx(1); // allow sockets to digest tcpip.sys packets...
          //          ProcessWindowsMessageQueue;

        end
        else
        begin
          break;
        end;
        k := FAssociation.ReadPduType;
        if k = 4 then
        begin
          repeat
            r := FAssociation.ReceiveDataPdu(k);
            if not r then
            begin
              k := FAssociation.ReadPduType;
              if k = 7 then
              begin
                abort1 := FAssociation.receiveAbort(k);
                Disconnect;
                raise Exception.Create(V_RECEIVE_ABORT_ERROR + abort1.Text);
              end;
              if k = 5 then
              begin //sendReleaseRequest
                FAssociation.receiveReleaseRequest(k);
                FAssociation.sendReleaseResponse;
                Disconnect;
                raise Exception.Create(V_RECEIVE_RELEASE_REQUEST_ERROR);
              end;
              //        if k <> 4 then
              //          raise Exception.Create('No DataPdu To receive!');
            end
            else
              break;
          until r;
        end
        else
          raise Exception.Create(V_NO_IMAGE_RECEIVE);
      end;
    finally
      for k := 0 to MyList.Count - 1 do
        ReceiveDatasets.Add(MyList[k]);
      MyList.Clear;
      MyList.Free;
    end;
  end;
end;

function TCnsDicomConnection.C_GET(ADataset: TDicomAttributes): Boolean;
var
  str1: AnsiString;
  k, kkk, cm1: Integer;
  r: Boolean;
  abort1: TDicomAbort;
  da1: TDicomAttributes;
  MyList: TList;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    str1 := ADataset.GetString(78);
    {    if str1 = 'PATIENT' then
          AddPresentationContext(PatientRootQueryRetrieveInformationModelMOVE)
        else
          AddPresentationContext(StudyRootQueryRetrieveInformationModelMOVE); }
    AddCGETPresentationContexts;

    AddPresentationContext(DXImageStorageForProcessing);
    addPresentationContext(BasicTextSR);
    addPresentationContext(EnhancedSR);
    addPresentationContext(BasicVoiceAudioWaveformStorage);
  end;
  Conn_wrt_log('SendDicomRequest C_GET_REQUEST ');
  Result := SendDicomRequest(C_GET_REQUEST, PresentationContext[0], '', ADataset);
  Conn_wrt_log('C_GET_REQUEST Result='+MyBoolToStr(Result) );
  kkk := 0;
  //  m1 := self.Association.ReceiveCommand.getInteger(0,$110);
  if Result then
  begin
    MyList := TList.Create;
    try
      while true do
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];
          ReceiveDatasets.Clear;
          MyList.Add(da1);
          kkk := 0;
          SendStatus(0, FMessageID);
          if assigned(FOnCGETProcess) then
            FOnCGETProcess(self, da1, MyList.count);
          //        ds1 := TDicomDataset.Create(da1);
          //        Add(ds1);
                  //TImageForm(FImageForm).Viewer1.AddImage(ds1);
                  //            FOnAddImage(self, ds1)
          //          DoSleepEx(1); // allow sockets to digest tcpip.sys packets...
          //          ProcessWindowsMessageQueue;

        end
        else
        begin
          cm1 := Association.ReceiveCommand.getInteger(0, $100);
          if cm1 = 32784 then
          begin
            if Association.ReceiveCommand.getInteger(0, $1020) <= 0 then
              break;
          end
          else
            break;
        end;
        k := FAssociation.ReadPduType;
        if k = 4 then
        begin
          repeat
            r := FAssociation.ReceiveDataPdu(k);
            if not r then
            begin
              k := FAssociation.ReadPduType;
              if k = 7 then
              begin
                abort1 := FAssociation.receiveAbort(k);
                Disconnect;
                Conn_wrt_log( V_RECEIVE_ABORT_ERROR + abort1.Text );
                raise Exception.Create(V_RECEIVE_ABORT_ERROR + abort1.Text);
              end;
              if k = 5 then
              begin //sendReleaseRequest
                FAssociation.receiveReleaseRequest(k);
                FAssociation.sendReleaseResponse;
                Disconnect;
                Conn_wrt_log( V_RECEIVE_RELEASE_REQUEST_ERROR );
                raise Exception.Create(V_RECEIVE_RELEASE_REQUEST_ERROR);
              end
              else
                if assigned(FOnPDUProcess) then
              begin
                FOnPDUProcess(self, kkk);
                inc(kkk);
              end;
              //        if k <> 4 then
              //          raise Exception.Create('No DataPdu To receive!');
            end
            else
              break;
          until r;
        end
        else
        begin
          Conn_wrt_log( V_NO_IMAGE_RECEIVE );
          raise Exception.Create(V_NO_IMAGE_RECEIVE);
        end;
      end;
    finally
      for k := 0 to MyList.Count - 1 do
        ReceiveDatasets.Add(MyList[k]);
      MyList.Clear;
      MyList.Free;
    end;
  end;
end;

function TCnsDicomConnection.C_FIND(ADataset: TDicomAttributes): Boolean;
var
  str1: AnsiString;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    Conn_wrt_log('ClearPresentationContext');
    str1 := ADataset.GetString(78);
    if str1 = 'PATIENT' then
      AddPresentationContext(PatientRootQueryRetrieveInformationModelFIND)
    else
      AddPresentationContext(StudyRootQueryRetrieveInformationModelFIND);
    Conn_wrt_log('AddPresentationContext');
  end;
  Result := SendDicomRequest(C_FIND_REQUEST, PresentationContext[0], '', ADataset);
  Conn_wrt_log('SendDicomRequest');
end;

function TCnsDicomConnection.C_MWL(ADataset: TDicomAttributes): Boolean;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    Conn_wrt_log('ClearPresentationContext');
    AddPresentationContext(ModalityWorklistInformationModelFIND);
    Conn_wrt_log('AddPresentationContext ModalityWorklistInformationModelFIND');
  end;
  Result := SendDicomRequest(C_FIND_REQUEST, PresentationContext[0], '', ADataset);
end;

function TCnsDicomConnection.N_GETPrinter(SOPInstance: Integer): TDicomAttributes;
var
  pcid1: integer;
  r: TDicomResponse;
  cmd1: TDicomAttributes;
  msgid: Integer;
begin
  msgid := 1;
  Result := nil;
  Connect;
  try
    r := SendRequest;
  except
    on e: Exception do
    begin
      ShowMessage('CONNECT_REJECT_ERROR' + e.Message);
      exit;
    end;
  end;
  if r = nil then
    ShowMessage('DicomConnectNoACK')
  else
    if r is TDicomAbort then
    raise Exception.Create('Abort ' + TDicomAbort(r).Text)
  else
    if r is TDicomReject then
    raise Exception.Create('Reject ' + TDicomReject(r).Text)
  else
    if r is TAcknowledge then
  begin

  end
  else
    raise Exception.Create(V_CONNECT_REJECT_ERROR);

  pcid1 := FAssociation.getPresentationContext(Verification);
  //            pcid1 := CnsDicomConnection1.FAssociation.getPresentationContext(BasicColorPrintManagementMetaSOPClass);

  cmd1 := createNGetRequest(msgid, uidPrinter, UIDS.AsString(SOPInstance));
  inc(msgid);
  if SendCommand(pcid1, cmd1, nil) then
  begin
    cmd1.Free;
    if FAssociation.ReceiveDatasets.Count > 0 then
    begin
      Result := FAssociation.ReceiveDatasets[0];
      FAssociation.ReceiveDatasets.Clear;
    end;
  end
  else
  begin
    ShowMessage('N-Get Error');
  end;
end;

function TCnsDicomConnection.M_STORAGE(ADataset: TDicomDataset; AWithFileStream: Boolean = TRUE):
  Boolean;
var
  fin1: TAssociateFilePdu;
  i, k: integer;
  das1, das2: TDicomAttributes;
  da1, da2, da3: TDicomAttribute;

  str1: AnsiString;
  //  stm1: TMemoryStream;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    str1 := ADataset.Attributes.GetString(62);
    PresentationContext[0] := UIDS.Items[str1].Constant;
    str1 := ADataset.Attributes.GetString(63);
    PresentationContextCount := 1;
  end
  else
  begin
    str1 := ADataset.Attributes.GetString(62);
  end;

  das1 := TDicomAttributes.Create;
  da1 := das1.Add($2813, $0110);
  das2 := TDicomAttributes.Create;
  //���� 8,$10,$18,$20,$28
  for i := 0 to ADataset.Attributes.Count - 1 do
  begin
    da2 := ADataset.Attributes.ItemByIndex[i];
    case da2.Group of
      8, $10, $18, $20, $28:
        begin
          da3 := TDicomAttribute.Create(das2);
          da3.Assign(da2);
          das2.Add(da3);
        end;
    end;
  end;

  da1.AddData(das2);

  Result := true;

  fin1 := TAssociateFilePdu.Create;
  try

    fin1.Command := das1;
    if AWithFileStream //and (ADataset.ImageFilename <> '') and FileExists(ADataset.ImageFilename)
    then
    begin
      ADataset.ImageStream.Position := 0;
      fin1.Add(ADataset.ImageStream);

      //stm1:= TMemoryStream.Create;
      //stm1.LoadFromStream(ADataset.ImageStream);
      //stm1 := TFileStream.Create(ADataset.ImageFilename, fmOpenRead);
      //fin1.Add(stm1);
    end
    else
      das1.AddVariant($2809, $1004, 1);

    SendFilePduRequest(fin1);
    //    fin1.write(FAssociation.Stream);

  finally
    fin1.ClearArray;
    fin1.free;
  end;
  k := FAssociation.ReadPduType;
  if k = $44 then
  begin
    fin1 := TAssociateFilePdu.Create;
    try
      fin1.readCommand(FAssociation.Stream, k);
      if (fin1.ReceiveCount > 0) and (assigned(fin1.Command)) then
      begin
        //        da1 := fin1.Command.Item[$2813, $0110];
        Result := true;
      end;
    finally
      fin1.free;
    end;
  end;
  //$2813, $0110 ������ͼ�� �������Ŀ  8,$10,$18,$20,$28
  {  ADataset.GetString($8, $60);
  studyid := ADataset.GetString($20, $10);
  a1 := ADataset.Item[8, $20];
  studyuid := ADataset.GetString($20, $D);
  seriesuid := ADataset.GetString($20, $E);
  PName := ADataset.GetString($10, $10);
  psex := ADataset.GetString($10, $40);
  PatientID := ADataset.GetString($10, $20);
  aid := ADataset.GetString($20, $13);
  InstanceUID := ADataset.GetString($8, $18);
  age := a1.GetString($10, $1010);
  sl := a1.GetString($18, $50);

  a1.getInteger($28, $10);
       a1.getInteger($28, $11);
       a1.getInteger($28, $101);
        a1.getInteger($28, $100);
        a1.getInteger($28, 2);
       a1.getString($28, 4);
       a1.GetString($8, $103E);

  a1.getString($8, $90);
        a1.getString($8, $1070);
       a1.getString($8, $1050);

       str1 := a1.GetString(8, $70);  }
end;

function AppendLocalImage(a1: TDicomAttributes; studyid, PName, pSex, PatientID: AnsiString;
  date1: TDatetime; studyuid, seriesuid, InstanceUID, ImageType, aid, afilename: AnsiString): Boolean;
begin
  Result := false;
  if assigned(FLocalStudiesTable) and FLocalStudiesTable.Active then
  begin
    if (not FLocalStudiesTable.Locate('STUDYUID', studyuid, [])) then
    begin
      FLocalStudiesTable.Insert;
      FLocalStudiesTable.FieldByName('STUDYUID').AsString := studyuid;
      FLocalStudiesTable.FieldByName('P_ENAME').AsString := PName;
      FLocalStudiesTable.FieldByName('P_SEX').AsString := pSex;
      FLocalStudiesTable.FieldByName('P_PID').AsString := PatientID;
      //    FLocalStudiesTable.FieldByName('STUDYID').AsString := studyuid;
      FLocalStudiesTable.FieldByName('STUDIESDATE').AsDateTime := Date1;
      FLocalStudiesTable.FieldByName('LOADDATE').AsDateTime := now;
      FLocalStudiesTable.FieldByName('STUDIES_IMAGE_TYPE').AsString := ImageType;
      FLocalStudiesTable.Post;
    end;
  end;
  if assigned(FLocalImagesTable) and FLocalImagesTable.Active then
  begin
    if (not FLocalImagesTable.Locate('INSTANCEUID', InstanceUID, [])) then
    begin
      FLocalImagesTable.Insert;
      FLocalImagesTable.FieldByName('STUDYUID').AsString := studyuid;
      FLocalImagesTable.FieldByName('SERIESUID').AsString := seriesuid;
      FLocalImagesTable.FieldByName('INSTANCEUID').AsString := InstanceUID;
      FLocalImagesTable.FieldByName('IMGNO').AsString := aid;
      FLocalImagesTable.FieldByName('IMAGETYPE').AsString := ImageType;
      FLocalImagesTable.FieldByName('IMAGEDATE').AsDatetime := date1;
      FLocalImagesTable.FieldByName('STUDIESDATE').AsDatetime := date1;

      {      FLocalImagesTable.FieldByName('SIZEX').AsInteger := a1.getInteger($28, $10);
            FLocalImagesTable.FieldByName('SIZEY').AsInteger := a1.getInteger($28, $11);
            FLocalImagesTable.FieldByName('BITS').AsInteger := a1.getInteger($28, $101);
            FLocalImagesTable.FieldByName('ABITS').AsInteger := a1.getInteger($28, $100);
            FLocalImagesTable.FieldByName('BITS_PER_SAMPLE').AsInteger := a1.getInteger($28, 2);
            FLocalImagesTable.FieldByName('PHOTOMETRIC').AsString := a1.getString($28, 4);}

      FLocalImagesTable.FieldByName('LAST_UPDATE_TIME').AsDatetime := now;
      FLocalImagesTable.FieldByName('TOBESAVE').AsInteger := 0;
      //      FLocalImagesTable.FieldByName('LAST_LOAD_TIME').AsDatetime := now;
      //      FLocalImagesTable.FieldByName('LOCALIMAGEFILENAME').AsString := afilename;
      FLocalImagesTable.Post;
    end
    else
    begin
      {      FLocalImagesTable.Edit;
            FLocalImagesTable.FieldByName('LAST_UPDATE_TIME').AsDatetime := now;
            FLocalImagesTable.FieldByName('LOAD_COUNT').AsInteger := 1;
            FLocalImagesTable.FieldByName('LAST_LOAD_TIME').AsDatetime := now;
            FLocalImagesTable.FieldByName('LOCALIMAGEFILENAME').AsString := afilename;
            FLocalImagesTable.Post;}
      Result := true;
    end;
  end;
end;

procedure DeleteLocalDicomImage(APath: AnsiString);
var
  ImageType, studyuid, str1: AnsiString;
  date1: TDatetime;
  y, m, d: Word;
begin
  if TestCacheTableExists(APath) then
  begin
    ImageType := FLocalStudiesTable.FieldByName('STUDIES_IMAGE_TYPE').AsString;

    date1 := FLocalStudiesTable.FieldByName('STUDIESDATE').AsDatetime;
    studyuid := FLocalStudiesTable.FieldByName('STUDYUID').AsString;

    DecodeDate(date1, y, m, d);

    str1 := Format('%s%s\%d\%d\%d\%s\', [APath, ImageType, y, m, d, studyuid]);
    DeleteFiles(str1, '*.*', true);
    RmDir(str1);

    FLocalImagesTable.Filter := Format('STUDYUID=''%s''', [StudyUID]);
    FLocalImagesTable.Filtered := true;
    FLocalImagesTable.Last;
    while not FLocalImagesTable.Bof do
    begin
      FLocalImagesTable.Delete;
    end;

    FLocalImagesTable.Filtered := false;
    FLocalStudiesTable.Delete;
  end;
end;

function TestCacheTableExists(APath: AnsiString): Boolean;
begin
  //  Result := false;
  if not assigned(FLocalStudiesTable) then
  begin
    FLocalStudiesTable := TCnsDBTable.Create(nil);

    FLocalStudiesTable.fTableLoadMode := cnsLoadFromFile;
    FLocalStudiesTable.DataFileDirectory := APath;
    with FLocalStudiesTable.ObjectTaskSQL do
    begin
      Add('TABLEGROUP �ڲ�{TABLE ͼ��( STUDIES){');
      Add('    PLUGIN IS ��ͨ');
      Add('    AUTOCREATE');
      Add('    DATABASE IS PACS FETCH = 3000');
      Add('    USERGROUP {');
      Add('      ������ TO ALL;');
      Add('    }');
      Add('    REPORT {');
      Add('    }');
      Add('    GROUP Ĭ��{');
      Add('      STUDYUID CHAR( 80 )');
      Add('        NOT NULL');
      Add('        PROMPT "ͼ���"');
      Add('        WIDTHINGRID 0');
      Add('        WIDTHINDIALOG 0');
      Add('      ,');
      Add('      P_ENAME CHAR( 32 )');
      Add('        PROMPT "����"');
      Add('        WIDTHINGRID 10');
      Add('        WIDTHINDIALOG 10');
      Add('      ,');
      Add('      P_SEX CHAR( 4 )');
      Add('       PROMPT "�Ա�"');
      Add('      ,');
      Add('      P_PID CHAR( 80 )');
      Add('        PROMPT "����"');
      Add('        WIDTHINGRID 8');
      Add('        WIDTHINDIALOG 8');
      Add('      ,');
      Add('      STUDYID CHAR( 20 )');
      Add('        PROMPT "����"');
      Add('        WIDTHINGRID 4');
      Add('        WIDTHINDIALOG 4');
      Add('      ,');
      Add('      STUDIES_IMAGE_TYPE CHAR( 4 )');
      Add('        PROMPT "ͼ������"');
      Add('    ,');
      Add('      STUDIESDATE DATE');
      Add('        PROMPT "�������"');
      Add('    ,');
      Add('      LOADDATE TIMESTAMP');
      Add('        PROMPT "��������" ASC');
      Add('    }');
      Add('    PRIMARY KEY ( STUDYUID )');
      Add('  }}');
    end;
    FLocalStudiesTable.RefreshTable;
  end;
  if not assigned(FLocalImagesTable) then
  begin
    FLocalImagesTable := TCnsDBTable.Create(nil);

    FLocalImagesTable.fTableLoadMode := cnsLoadFromFile;
    FLocalImagesTable.DataFileDirectory := APath;
    with FLocalImagesTable.ObjectTaskSQL do
    begin
      Add('TABLEGROUP �ڲ�{TABLE ͼ������( IMAGES){');
      Add('  PLUGIN IS ��ͨ');
      Add('  AUTOCREATE');
      //  Add('  MULTIDATABASE');
      Add('  DATABASE IS PACS FETCH = 0');
      Add('  USERGROUP {');
      Add('    ������ TO ALL;');
      Add('  }');
      Add('  REPORT {');
      Add('  }');
      Add('  GROUP Ĭ��{');
      Add('    STUDYUID CHAR( 80 )');
      Add('      NOT NULL');
      Add('      PROMPT "STUDYUID"');
      Add('      ASC');
      Add('    ,');
      Add('    SERIESUID CHAR( 80 )');
      Add('      NOT NULL');
      Add('      PROMPT "SERIESUID"');
      Add('      ASC');
      Add('    ,');
      Add('    INSTANCEUID CHAR( 80 )');
      Add('      NOT NULL');
      Add('      PROMPT "INSTANCEUID"');
      Add('    ,');
      Add('    IMGNO INTEGER');
      Add('      NOT NULL');
      Add('      PROMPT "IMGNO"');
      Add('      ASC');
      Add('    ,');
      Add('    IMAGETYPE CHAR( 4 )');
      Add('      PROMPT "modility"');
      Add('    ,');
      Add('    IMAGEDATE DATE');
      Add('      PROMPT "IMAGEDATE"');
      Add('    ,');
      Add('    STUDIESDATE DATE');
      Add('      PROMPT "STUDIESDATE"');
      Add('    ,');
      Add('    LAST_UPDATE_TIME TIMESTAMP');
      Add('      PROMPT "����޸�ʱ��"');
      Add('    ,');
      Add('    IMAGESIZE INTEGER');
      Add('      PROMPT "ͼ���С"');
      Add('    ,');
      Add('    TOBESAVE INTEGER');
      Add('      PROMPT "����"');
      Add('  }');
      Add('  PRIMARY KEY ( INSTANCEUID )');
      Add('}}');
    end;
    FLocalImagesTable.RefreshTable;

    if FLocalStudiesTable.RecordCount > 100 then
    begin
      FLocalStudiesTable.Filter := 'LOADDATE<''' + DateToStr(now - 5) + '''';
      FLocalStudiesTable.Filtered := true;
      if FLocalStudiesTable.RecordCount > 0 then
      begin
        FLocalStudiesTable.First;
        while not FLocalStudiesTable.Eof do
        begin
          DeleteLocalDicomImage(Apath);
          FLocalStudiesTable.Next;
        end;
        FLocalStudiesTable.Filtered := false;
        FLocalStudiesTable.ApplyUpdates;
        FLocalImagesTable.ApplyUpdates;
      end
      else
        FLocalStudiesTable.Filtered := false;

      FLocalStudiesTable.Filter := '';
    end;
  end;

  Result := assigned(FLocalStudiesTable) and FLocalStudiesTable.Active
    and assigned(FLocalImagesTable) and FLocalImagesTable.Active
    and DirectoryExists(APath);
end;

function LoadLocalDicomImage(Apath: AnsiString): TFileStream;
  function SetDir(ADir: AnsiString): Boolean;
  begin
    Result := false;
    if ADir <> '' then
    begin
      Result := DirectoryExists(ADir);
      if Result then
        SetCurrentDir(ADir);
    end;
  end;
var
  InstanceUID, aid, ImageType, seriesuid, studyuid: AnsiString;
  date1: TDatetime;
  //      a1: TDicomAttribute;
  y, m, d: Word;
  imagefilename: AnsiString;
begin
  Result := nil;
  if TestCacheTableExists(APath) then
  begin
    ImageType := FLocalImagesTable.FieldByName('IMAGETYPE').AsString;

    date1 := FLocalImagesTable.FieldByName('IMAGEDATE').AsDatetime;
    studyuid := FLocalImagesTable.FieldByName('STUDYUID').AsString;
    seriesuid := FLocalImagesTable.FieldByName('SERIESUID').AsString;

    aid := FLocalImagesTable.FieldByName('IMGNO').AsString;
    InstanceUID := FLocalImagesTable.FieldByName('INSTANCEUID').AsString;

    DecodeDate(date1, y, m, d);

    if Apath <> '' then
      if not SetDir(APath) then
        exit;
    //
    if not SetDir(ImageType) then
      exit;
    if not SetDir(IntToStr(y)) then
      exit;
    if not SetDir(IntToStr(m)) then
      exit;
    if not SetDir(IntToStr(d)) then
      exit;
    if not SetDir(studyuid) then
      exit;
    //      DstPath := getCurrentDir;

    if not SetDir(seriesuid) then
      exit;
    //    if aid = '' then
    imagefilename := InstanceUID + '.dcm';
    //    else
    //      imagefilename := AID + '.dcm';

    if FileExists(imagefilename) then
      Result := TFileStream.Create(imagefilename, fmOpenRead);
  end;
end;

function SaveLocalDicomImage(Apath: AnsiString; ADataset: TDicomAttributes; InsertCacaheDB: Boolean =
  TRUE): TFileStream;
  procedure SetDir(ADir: AnsiString);
  begin
    if ADir <> '' then
    begin
      if not DirectoryExists(ADir) then
        if not CreateDir(ADir) then
          raise Exception.Create('Cannot create ' + ADir);
      SetCurrentDir(ADir);
    end;
  end;
var
  InstanceUID, aid, PName, psex, ImageType, studyid, seriesuid, studyuid, PatientID: AnsiString;
  date1: TDatetime;
  a1: TDicomAttribute;
  y, m, d: Word;
  imagefilename: AnsiString;
begin
  Result := nil;
  if TestCacheTableExists(APath) then
  begin
    ImageType := ADataset.GetString($8, $60);
    if ImageType = 'PR' then
    begin
      //  ADataset.ListAttrinute('',KxImsForm.Memo1.Lines);
      exit;
    end;
    studyid := ADataset.GetString($20, $10);

    a1 := ADataset.Item[8, $20];
    if assigned(a1) then
      date1 := a1.AsDatetime[0]
    else
      date1 := now;

    studyuid := ADataset.GetString($20, $D);
    if Length(studyuid) <= 10 then
    begin
      if Length(studyuid) = 0 then
        studyuid := '1.826.' + FormatDatetime('yyyymmdd', date1) + '.' + studyid
      else
        studyuid := '1.826.' + FormatDatetime('yyyymmdd', date1) + '.' + studyuid;
    end;
    seriesuid := ADataset.GetString($20, $E);
    if SeriesuID = '' then
      seriesuid := ADataset.GetString($20, $11);

    PName := ADataset.GetString($10, $10);
    if Length(PName) > 20 then
      PName := Copy(PName, 1, 20);
    psex := ADataset.GetString($10, $40);
    PatientID := ADataset.GetString($10, $20);
    if PatientID = '' then
      PatientID := studyuid;
    //  if Length(PatientID) > 40 then
    //    PatientID := Copy(PatientID, 1, 40);
    if PatientID = '' then
      PatientID := '000';
    aid := ADataset.GetString($20, $13);
    if aid = '' then
      aid := ADataset.GetString($20, $12);
    if aid = '' then
      aid := '1';
    InstanceUID := ADataset.GetString($8, $18);

    DecodeDate(date1, y, m, d);

    if APath <> '' then
      SetDir(APath);
    //
    SetDir(ImageType);
    SetDir(IntToStr(y));
    SetDir(IntToStr(m));
    SetDir(IntToStr(d));
    SetDir(studyuid);

    //  DstPath := getCurrentDir;

    SetDir(seriesuid);
    {  imagefilename := DicomTempPath;
      if imagefilename[Length(imagefilename)] <> '\' then
        imagefilename := imagefilename + '\';
      imagefilename := imagefilename + Format('%s\%s\', [studyuid, seriesuid]);}

//    if aid = '' then
    imagefilename := InstanceUID + '.dcm';
    //    else
    //      imagefilename := AID + '.dcm';
    if InsertCacaheDB then
      AppendLocalImage(ADataset, studyid, PName, pSex, PatientID, date1, studyuid, seriesuid,
        InstanceUID, ImageType, aid, imagefilename);

    Result := TFileStream.Create(imagefilename, fmCreate);
  end;
end;

function CheckLocalImageCache(APath, AStudyUID: AnsiString): Boolean;
  function TestImageFile: Boolean;
    function SetDir(ADir: AnsiString): Boolean;
    begin
      Result := false;
      if ADir <> '' then
      begin
        Result := DirectoryExists(ADir);
        if Result then
          SetCurrentDir(ADir);
      end;
    end;
  var
    InstanceUID, aid, ImageType, seriesuid, studyuid: AnsiString;
    date1: TDatetime;
    //      a1: TDicomAttribute;
    y, m, d: Word;
    imagefilename: AnsiString;
  begin
    Result := false;
    ImageType := FLocalImagesTable.FieldByName('IMAGETYPE').AsString;

    date1 := FLocalImagesTable.FieldByName('IMAGEDATE').AsDatetime;
    studyuid := FLocalImagesTable.FieldByName('STUDYUID').AsString;
    seriesuid := FLocalImagesTable.FieldByName('SERIESUID').AsString;

    aid := FLocalImagesTable.FieldByName('IMGNO').AsString;
    InstanceUID := FLocalImagesTable.FieldByName('INSTANCEUID').AsString;

    DecodeDate(date1, y, m, d);

    if Apath <> '' then
      if not SetDir(APath) then
        exit;
    //
    if not SetDir(ImageType) then
      exit;
    if not SetDir(IntToStr(y)) then
      exit;
    if not SetDir(IntToStr(m)) then
      exit;
    if not SetDir(IntToStr(d)) then
      exit;
    if not SetDir(studyuid) then
      exit;
    //      DstPath := getCurrentDir;

    if not SetDir(seriesuid) then
      exit;
    if aid = '' then
      imagefilename := InstanceUID + '.dcm'
    else
      imagefilename := AID + '.dcm';
    Result := FileExists(imagefilename);
  end;
begin
  Result := false;
  if TestCacheTableExists(APath) then
  begin
    if FLocalStudiesTable.Locate('STUDYUID', AStudyUID, []) then
    begin
      FLocalImagesTable.Filter := Format('STUDYUID=''%s''', [AStudyUID]);
      FLocalImagesTable.Filtered := true;
      FLocalImagesTable.First;
      while not FLocalImagesTable.Eof do
      begin
        if TestImageFile then
        begin
          {        FLocalImagesTable.Edit;
                  FLocalImagesTable.FieldByName('LOAD_COUNT').AsInteger := ADataset.FieldByName('LOAD_COUNT').AsInteger + 1;
                  FLocalImagesTable.FieldByName('LAST_LOAD_TIME').AsDatetime := now;
                  FLocalImagesTable.Post; }
          FLocalImagesTable.Next;
        end
        else
          FLocalImagesTable.Delete;
      end;
      Result := not (FLocalImagesTable.Bof and FLocalImagesTable.Eof);
    end;
  end;
end;

function TCnsDicomConnection.M_GET(AStudyUID: AnsiString): Boolean;
var
  fin1: TAssociateFilePdu;
  i, k: integer;
  das1, das2: TDicomAttributes;
  da1: TDicomAttribute;
  stm1: TStream;
  str1: AnsiString;
  das: TDicomDataset;
begin
  //  DstPath := '';
  das1 := TDicomAttributes.Create;
  da1 := das1.Add($2813, $0111);
  das2 := TDicomAttributes.Create;
  with das2 do
  begin
    AddVariant(78, 'STUDY');
    AddVariant(dStudyInstanceUID, AStudyUID);
  end;
  da1.AddData(das2);

  Result := true;
  fin1 := TAssociateFilePdu.Create;
  try
    fin1.Command := das1;
    SendFilePduRequest(fin1);
    //fin1.write(FAssociation.Stream);
  finally
    fin1.free;
  end;
  k := FAssociation.ReadPduType;
  if k = $44 then
  begin
    fin1 := TAssociateFilePdu.Create;
    try
      fin1.readCommand(FAssociation.Stream, k);
      if (fin1.ReceiveCount > 0) and (assigned(fin1.Command)) then
      begin
        da1 := fin1.Command.Item[$2813, $0111]; //���ղ�����ͼ��
        if assigned(da1) and (da1.GetCount > 0) then
        begin
          for i := 0 to da1.GetCount - 1 do
          begin
            das1 := da1.Attributes[i];
            //������Ҫ��Ŀ¼������һЩ���ݵ����ݿ���
            //stm1 := SaveLocalDicomImage('', das1);
            {$IFDEF  MGETUSE_MEMORYSTREAM}
            stm1 := TMemoryStream.Create;
            {$ELSE}
            //            showmessage(ExtractFilePath(Application.ExeName));
            Inc(CurrentTempImageIndex);

            str1 := Format('%sDCMTEMP\T$%d_%d.DCM', [DicomTempPath,
              //Copy(AStudyUID, Length(AStudyUID) - 8, 8),
              CurrentTempImageIndex, Random(100000)]);
            stm1 := TFileStream.Create(str1, fmCreate);
            {$ENDIF}
            //���ղ������ļ�
            try
              //fin1.readData(FAssociation.Stream, stm1);

              //���ղ������ļ�

              fin1.readData(FAssociation.Stream, stm1);
              FAssociation.Stream.WriteInt32(1);
              FAssociation.Stream.FreshData;

              stm1.Position := 0;
              das := TDicomDataset.Create;

              {$IFDEF  MGETUSE_MEMORYSTREAM}
              das.LoadFromStream(stm1, false);
              {$ELSE}
              das.LoadFromStream(stm1, true);
              das.SetStreamAndFileName(stm1, str1, true);
              {$ENDIF}
              ReceiveDatasets.Add(das);
              //Add(das);
              //AddTopoDataset(das, (inherited getCount), das.Attributes.GetString(8, $60)= 'CT');

            finally
              {$IFDEF  MGETUSE_MEMORYSTREAM}
              stm1.Free;
              {$ENDIF}
            end;
          end;
        end;
      end;
    finally
      fin1.free;
    end;
  end;
end;

function TCnsDicomConnection.C_Database(ADataset: TDicomAttributes): Boolean;
{$IFDEF DICOMDEBUGZ1}
var
  str1: string;
  strs1: TStringList;
  kc: Integer;
  {$ENDIF}
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    AddPresentationContext(DBS_Verification);
  end;
  {$IFDEF DICOMDEBUGZ1}
  //SendDebug('SendDicomRequest');
  str1 := ADataset.GetString($2809, 1);
  strs1 := TStringList.Create;
  ADataset.ListAttrinute('', strs1);
  kc := GetTickCount;
  {$ENDIF}
  Result := SendDicomRequest(C_Database_REQUEST, DBS_Verification, '', ADataset);

  {$IFDEF DICOMDEBUGZ1}
  SendDebug(Format('C_Database(%d)%s', [GetTickCount - kc, strs1.Text]));
  strs1.Free;
  {$ENDIF}
end;

function TCnsDicomConnection.C_STORAGE(ADataset: TDicomAttributes): Boolean;
var
  str1: AnsiString;
  i: Integer;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    str1 := ADataset.GetString(62);
    PresentationContext[0] := UIDS.Items[str1].Constant;
    str1 := ADataset.GetString(63);
    PresentationContextCount := 1;
    i := PresentationContext[0];
  end
  else
  begin
    str1 := ADataset.GetString(62);
    i := UIDS.Items[str1].Constant;

    //Modification - Vincenzo. Resolve problem with DCMTK
    str1 := ADataset.GetString(63);
  end;
  Result := SendDicomRequest1(C_STORE_REQUEST, i, str1, ADataset);
end;

function TCnsDicomConnection.PrepareRequestCommand(ARequestType, ASopClass: Integer; SopInstance:
  AnsiString): TDicomAttributes;
var
  //  i, i1: Integer;
  s1: AnsiString;
  ai: TDCMIntegerArray;
begin
  inc(FMessageID);
  s1 := SopInstance;
  SetLength(ai, 0);
  case ARequestType of
    N_EVENT_REPORT_REQUEST:
      begin
        Result := createEventReportRequest(FMessageID, ASopClass, s1, true, 1);
      end;
    N_GET_REQUEST:
      begin
        Result := createNGetRequest(FMessageID, ASopClass, s1);
      end;
    N_SET_REQUEST:
      begin
        Result := createSetRequest(FMessageID, ASopClass, s1);
      end;
    N_ACTION_REQUEST:
      begin
        Result := createActionRequest(FMessageID, ASopClass, s1, true, 1);
      end;
    N_CREATE_REQUEST:
      begin
        Result := createCreateRequest(FMessageID, ASopClass, s1, true);
      end;
    N_DELETE_REQUEST:
      begin
        Result := createDeleteRequest(FMessageID, ASopClass, s1);
      end;
    C_STORE_REQUEST:
      begin
        Result := createStoreRequest(FMessageID, ASopClass, 0, s1, '', '');
      end;
    C_GET_REQUEST:
      begin
        Result := createCGetRequest(FMessageID, ASopClass, 0, FCallingTitle);
      end;
    C_FIND_REQUEST:
      begin
        Result := createFindRequest(FMessageID, ASopClass, 0);
      end;
    C_MOVE_REQUEST:
      begin
        // FOMIN 08_07_2012 MoveDestination
        // �������� �������� FMoveDestination
        // ���� �� ������ - ��� ������ - �� FCallingTitle
//        Result := createMoveRequest(FMessageID, ASopClass, 0, FCallingTitle);
        if FMoveDestination<>'' then begin
          Result := createMoveRequest(FMessageID, ASopClass, 0, FMoveDestination);
        end else begin
          Result := createMoveRequest(FMessageID, ASopClass, 0, FCallingTitle);
        end;
        // END FOMIN 
      end;
    C_ECHO_REQUEST:
      begin
        Result := createEchoRequest(FMessageID, ASopClass);
      end;
    C_CANCEL_FIND_REQUEST:
      begin
        Result := createCancelRequest(FMessageID);
      end;
    C_Database_REQUEST:
      begin
        Result := createDatabaseRequest(FMessageID, ASopClass, 0);
      end;
  else
    Result := nil;
  end;
end;

function TCnsDicomConnection.SendRequest(p_is_send_request:Boolean=True): TDicomResponse;
var
  k, i: Integer;
  FRequest: TRequest;
begin
  if FAssociation.IsConnected then
  begin
    Conn_wrt_log('FAssociation.IsConnected - exit');
    Result := nil;
    exit;
  end;
  Conn_wrt_log('FAssociation.Init');

  FAssociation.Init;

  FRequest := TRequest.Create;
  FRequest.CalledTitle := FCalledTitle;
  FRequest.CallingTitle := FCallingTitle;
  FRequest.MaxPduSize := FMaxPduSize;
  if PresentationContextCount <= 0 then
  begin
    raise Exception.Create('No PresentationContext!');
  end
  else
  begin
    for i := 0 to PresentationContextCount - 1 do
    begin
      FRequest.addPresentationContext(PresentationContext[i], FTransferSyntaxes);
    end;
  end;
  FAssociation.Clear;

  Conn_wrt_log('FAssociation.sendAssociateRequest(FRequest)');

  FAssociation.sendAssociateRequest(FRequest);

  Conn_wrt_log('FAssociation.ReadPduType');

  k := FAssociation.ReadPduType;

  FAssociation.v_is_log := v_is_log;
  FAssociation.v_log_filename:=v_log_filename;

  Conn_wrt_log('FAssociation.ReadPduType = '+inttostr(k));

  //if False then
  case k of
    2, 3, 7:
      begin
        Conn_wrt_log('FAssociation.receiveAssociateResponse(k) k='+inttostr(k));
      //  if p_is_send_request then
      //  begin
          Result := FAssociation.receiveAssociateResponse(k);
          Conn_wrt_log('FAssociation.receiveAssociateResponse(k) '+Result.Text+' '+IntToStr(Result.Reason));
      {  end else
          Result:=nil; }
      end;
  else
    begin
      Conn_wrt_log('No DicomResponse To receive!');
      raise Exception.Create('No DicomResponse To receive!');
    end;
  end;
end;

function TCnsDicomConnection.SendDicomRequest1(ARequestType, ASOPClass: Integer; SopInstance:
  AnsiString; AAttriutes: TDicomAttributes): Boolean;
var
  da1: TDicomAttributes;
begin
  Result := false;
  da1 := PrepareRequestCommand(ARequestType, ASOPClass, SopInstance);
  if not assigned(da1) then
  begin
    raise Exception.Create('NoDicomCommandDefine');
  end;
  if assigned(AAttriutes) then
  begin
    da1.AddVariant(dDataSetType, DICOM_DATA_PRESENT);
  end
  else
  begin
    da1.AddVariant(dDataSetType, DICOM_DATA_NOT_PRESENT);
  end;

  try
    try
      Result := SendCommandBySop(ASOPClass, da1, AAttriutes);
    except
      on e: Exception do
      begin
        FAssociation.Init;
        Disconnect;
        raise Exception.Create( e.Message );
      end;
    end;
  finally
    da1.Free;
  end;
end;

function TCnsDicomConnection.SendDicomRequest(ARequestType, ASOPClass: Integer; SopInstance:
  AnsiString; AAttriutes: TDicomAttributes): Boolean;
var
  da1: TDicomAttributes;
begin
  Result := false;
  Conn_wrt_log('before PrepareRequestCommand');
  da1 := PrepareRequestCommand(ARequestType, ASOPClass, SopInstance);
  Conn_wrt_log('PrepareRequestCommand');
  if not assigned(da1) then
  begin
    raise Exception.Create('NoDicomCommandDefine');
  end;
  if assigned(AAttriutes) then
  begin
    da1.AddVariant(dDataSetType, DICOM_DATA_PRESENT);
  end
  else
  begin
    da1.AddVariant(dDataSetType, DICOM_DATA_NOT_PRESENT);
  end;
  {$IFDEF DICOMDEBUG1}
  SendDebug('SendCommandBySop');
  {$ENDIF}
  
  try
    try
      Conn_wrt_log('SendCommandBySop ASOPClass='+inttostr(ASOPClass));
      Result := SendCommandBySop(ASOPClass, da1, AAttriutes);
      Conn_wrt_log('SendCommandBySop ASOPClass='+inttostr(ASOPClass)+' RESULT='+MyBoolToStr(Result));
    except
      on e: Exception do
      begin
        FAssociation.Init;
        Disconnect;

        MessageDlg('������ ������� DICOM : '+e.Message, mtWarning, [mbOK], 0);

      //  raise Exception.Create('Send Command, It raise error: ' + e.Message);
        Conn_wrt_log('Send Command, It raise error: ' + e.Message);
      end;
    end;
  finally
    da1.Free;
    AAttriutes.Free;
  end;
end;

function TCnsDicomConnection.SendFilePduRequest(AFIN: TAssociateFilePdu): Boolean;
label
  RetryConnect;
var
  //  k: Integer;
  //  abort1: TDicomAbort;
  rck1: TDicomResponse;
  str1: AnsiString;
  //  srvfail: Boolean;
  RetryConnectCount: Integer;
begin
  Result := false;
  //  srvfail := false;
  RetryConnectCount := 0;
  RetryConnect:
  if not Connected then
  begin
    Connect;
    if not Connected then
    begin
      FAssociation.Init;
      {$IFDEF RETRYCONNECTION}
      if FCanRetryConnected and
        QueryHost(Format('Can not connect to server (%s:%d)!Please check you network', [Host, Port])
        + #13#10 + dcmAssociationRetryConnect) then
      begin
        goto RetryConnect;
      end
      else
        raise Exception.Create(V_CONNECT_ABORT_ERROR);
      {$ENDIF}
      raise Exception.Create(Format(dcmAssociationConnectError, [FSocket.LastCommandStatus, FSocket.Host, FSocket.Port]));
    end
    else
      FAssociation.Init;
  end;

  if (not FAssociation.IsConnected) then
  begin
    rck1 := SendRequest;
    //    if (rck1 is TAcknowledge) then
    if (rck1 is TDicomReject) or (rck1 is TDicomAbort) then
    begin
      str1 := rck1.Text;
      raise Exception.Create(V_REQUEST_WAS_REJECT + '(' + FHost + ':' + IntToStr(FPort) + ')' +
        str1);
    end
  end
  else
    FAssociation.Clear;

  if not FAssociation.SendFilePduRequestEx(afin) then
  begin
    FAssociation.Init;

    try
      Disconnect;
    except
      on e: Exception do
        ShowMessage(e.Message);
    end;
    {$IFDEF RETRYCONNECTION}
    if RetryConnectCount < 3 then
    begin
      inc(RetryConnectCount);
      goto RetryConnect;
    end
    else
    begin
      if FCanRetryConnected and QueryHost(FAssociation.ErrorMsg + #13#10 +
        dcmAssociationRetryConnect) then
      begin
        goto RetryConnect;
      end
      else
        raise Exception.Create(V_CONNECT_ABORT_ERROR);
    end;
    {$ENDIF}
  end;
end;

function TCnsDicomConnection.QueryHost(AMsg: AnsiString): Boolean;
var
  h1, str1: AnsiString;
  i, p1: integer;
begin
  if FRetryHostLastIndex = -1 then
  begin
    if FRetryHostList.Count <= 0 then
    begin
      FRetryHostList.Add(Host + ':' + IntToStr(Port));
    end;
    FRetryHostLastIndex := FRetryHostList.IndexOf(Host + ':' + IntToStr(Port));
    FRetryHostCurrentIndex := FRetryHostLastIndex + 1;
    FRetryHostCurrentIndex := FRetryHostCurrentIndex mod FRetryHostList.Count;
  end;
  if FRetryHostLastIndex <> FRetryHostCurrentIndex then
  begin
    str1 := FRetryHostList[FRetryHostCurrentIndex];
    i := Pos(':', str1);
    Host := Copy(str1, 1, i - 1);
    Port := StrToint(Copy(str1, i + 1, Length(str1) - i));
    inc(FRetryHostCurrentIndex);
    FRetryHostCurrentIndex := FRetryHostCurrentIndex mod FRetryHostList.Count;
    Result := true;
  end
  else
  begin
    FRetryHostCurrentIndex := FRetryHostLastIndex + 1;
    FRetryHostCurrentIndex := FRetryHostCurrentIndex mod FRetryHostList.Count;
    with TSelectPacsHostForm.Create(self) do
    try
      RadioGroup1.Items.Text := FRetryHostList.Text;
      //    RadioGroup1.Items.Add(Host + ':' + IntToStr(Port));
      RadioGroup1.ItemIndex := 0;
      Memo1.Lines.Text := AMsg;
      Result := ShowModal = mrRetry;
      if Result then
      begin
        if newHost = '' then
        begin
          str1 := RadioGroup1.Items[RadioGroup1.Itemindex];
          i := Pos(':', str1);
          h1 := Copy(str1, 1, i - 1);
          P1 := StrToint(Copy(str1, i + 1, Length(str1) - i));
          if (h1 <> Host) or (p1 <> Port) then
          begin
            Host := h1;
            Port := p1;
            if FRetryHostList.IndexOf(str1) < 0 then
              FRetryHostList.Add(str1);
          end;
        end
        else
        begin
          h1 := newHost;
          p1 := newPort;
          if (h1 <> Host) or (p1 <> Port) then
          begin
            Host := h1;
            Port := p1;
            if FRetryHostList.IndexOf(str1) < 0 then
              FRetryHostList.Add(str1);
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TCnsDicomConnection.AddCGETPresentationContexts( p_is_clr:Boolean=True );
begin
  if p_is_clr then
    ClearPresentationContext;

//  AddPresentationContext(ComputedRadiographyImageStorage);

//  AddPresentationContext(PrivateTransferSyntax);
  

 // AddPresentationContext(ImplicitVRLittleEndian); // = 8193;
 // AddPresentationContext(ExplicitVRLittleEndian); // = 8194;
 // AddPresentationContext(ExplicitVRBigEndian); // = 8195;
 { AddPresentationContext(RLELossless); // = 8198;
  AddPresentationContext(JPEGBaseline); // = 8196;
  AddPresentationContext(JPEGLossless); // = 8197;
  }

//  AddPresentationContext(Verification);
//  AddPresentationContext(ComputedRadiographyImageStorage);
//  AddPresentationContext(DXImageStorageForPresentation);
//  AddPresentationContext(DXImageStorageForProcessing);
//  AddPresentationContext(DXMammographyImageStorageForPresentation);
//  AddPresentationContext(DXMammographyImageStorageForProcessing);
//  AddPresentationContext(DXIntraOralImageStorageForPresentation);
//  AddPresentationContext(DXIntraOralImageStorageForProcessing);
//  AddPresentationContext(CTImageStorage);
//  AddPresentationContext(UltrasoundMultiframeImageStorage);
//  AddPresentationContext(UltrasoundMultiframeImageStorage_Retired);
//  AddPresentationContext(MRImageStorage);
//  AddPresentationContext(UltrasoundImageStorage);
//  AddPresentationContext(UltrasoundImageStorage_Retired);
//  AddPresentationContext(SecondaryCaptureImageStorage);
//  AddPresentationContext(GrayscaleSoftcopyPresentationState);
//  AddPresentationContext(XRayAngiographicImageStorage);
//  AddPresentationContext(XRayRadiofluoroscopicImageStorage);
//  AddPresentationContext(XRayAngiographicBiPlaneImageStorage);
//  AddPresentationContext(NuclearMedicineImageStorage);
//  AddPresentationContext(VLEndoscopicImageStorage);
//  AddPresentationContext(VLMicroscopicImageStorage);
//  AddPresentationContext(VLSlideCoordinatesMicroscopicImageStorage);
//  AddPresentationContext(VLPhotographicImageStorage);
//  AddPresentationContext(PositronEmissionTomographyImageStorage);
//  AddPresentationContext(4201);
  //    AddPresentationContext(DXImageStorageForProcessing);
//  AddPresentationContext(HemodynamicWaveformStorage);
  //  AddPresentationContext(PatientRootQueryRetrieveInformationModelFIND);

  //  AddPresentationContext(StudyRootQueryRetrieveInformationModelFIND);
end;

function TCnsDicomConnection.SendCommandBySop(ASopClass: Integer; CommandAttributes,
  DataAttributes: TDicomAttributes): Boolean;
label
  RetryConnect;
var
  k: Integer;
  abort1: TDicomAbort;
  rck1: TDicomResponse;
  str1: AnsiString;
  //  srvfail: Boolean;
  RetryConnectCount: Integer;
begin
  Result := false;
  //  srvfail := false;
  RetryConnectCount := 0;
  RetryConnect:
  if not Connected then
  begin
    {$IFDEF DICOMDEBUG}
    SendDebug('Connecting');
    {$ENDIF}
    Conn_wrt_log('Try to connect ...');
    Connect;
    Conn_wrt_log('connected='+MyBoolToStr(Connected));
    if not Connected then
    begin
      Conn_wrt_log('FAssociation.Init ...');
      FAssociation.Init;

      {$IFDEF RETRYCONNECTION}
      if FCanRetryConnected and
        QueryHost(Format('Can not connect to server (%s:%d)!Please check you network', [Host, Port])
        + #13#10 + dcmAssociationRetryConnect) then
      begin
        //      if QueryHost(Format('���ӵ�������%s:%d���ɹ�!��������������á����������߼���ϵ����Ա��ѯ��', [Host, Port]) + dcmAssociationRetryConnect) then
        goto RetryConnect;
      end
      else
        raise Exception.Create(V_CONNECT_ABORT_ERROR);
      {$ENDIF}
      Conn_wrt_log(Format('Can not connect to server (%s:%d)!Please check you network', [Host, Port])
        + #13#10 + dcmAssociationRetryConnect);
     // Exit;
      raise Exception.Create(Format(dcmAssociationConnectError, [TKXSockClient(FSocket).LastCommandStatus, TKXSockClient(FSocket).Host, TKXSockClient(FSocket).Port]));
    end
    else
    begin
      Conn_wrt_log('FAssociation.Init ...');
      FAssociation.Init;
    end;
    {$IFDEF DICOMDEBUG}
    SendDebug('init Association');
    {$ENDIF}
  end;
  {$IFDEF DICOMDEBUG}
  SendDebug('Connect');
  {$ENDIF}
  Conn_wrt_log('connected='+MyBoolToStr(Connected)+' before SendRequest');
  if (not FAssociation.IsConnected) then
  begin
    rck1 := SendRequest(ASopClass<>4097);
    //    if (rck1 is TAcknowledge) then
    
    if (rck1 is TDicomReject) or (rck1 is TDicomAbort) then
    begin
      Conn_wrt_log('connected='+MyBoolToStr(Connected)+' TDicomReject or TDicomAbort');
      str1 := rck1.Text;
      Conn_wrt_log('raise Exception V_REQUEST_WAS_REJECT : '+V_REQUEST_WAS_REJECT + '(' + FHost + ':' + IntToStr(FPort) + ')' +
        str1);
      raise Exception.Create(V_REQUEST_WAS_REJECT + '(' + FHost + ':' + IntToStr(FPort) + ')' +
        str1);
    end
  end
  else
  begin
    Conn_wrt_log('FAssociation.Clear');
    FAssociation.Clear;
  end;

  Conn_wrt_log('connected='+MyBoolToStr(Connected)+' before sendDataPduBySOP');

  if not FAssociation.sendDataPduBySOP(ASopClass, CommandAttributes, DataAttributes) then
  begin
    Conn_wrt_log('not FAssociation.sendDataPduBySOP');
    Conn_wrt_log('FAssociation.Init');
    FAssociation.Init;

    try
      Conn_wrt_log('Disconnect');
      Disconnect;
    except
      on e: Exception do
      begin
        Conn_wrt_log('raise');
        raise;
      end;
    end;
    if RetryConnectCount < 3 then
    begin
      inc(RetryConnectCount);
      goto RetryConnect;
    end
    else
    begin
      if FCanRetryConnected and QueryHost(FAssociation.ErrorMsg + #13#10 +
        dcmAssociationRetryConnect) then
      begin
        goto RetryConnect;
      end
      else
        raise Exception.Create(V_CONNECT_ABORT_ERROR);
    end;
  end;
  {$IFDEF DICOMDEBUG}
  SendDebug('Receiving');
  {$ENDIF}

  Conn_wrt_log('FAssociation.ReadPduType');

  k := FAssociation.ReadPduType;

  Conn_wrt_log('FAssociation.ReadPduType='+inttostr(k));

  if k = 4 then
  begin
    repeat

      Conn_wrt_log('FAssociation.ReceiveDataPdu');

      Result := FAssociation.ReceiveDataPdu(k);

      Conn_wrt_log('FAssociation.ReceiveDataPdu='+inttostr(k));

      if not Result then
      begin
        Conn_wrt_log('FAssociation.ReadPduType');
        k := FAssociation.ReadPduType;
        Conn_wrt_log('FAssociation.ReadPduType='+inttostr(k));
        if k = 7 then
        begin
          Conn_wrt_log('FAssociation.receiveAbort');
          abort1 := FAssociation.receiveAbort(k);
          Conn_wrt_log('FAssociation.receiveAbort Reason='+inttostr(abort1.Reason)+'  and Disconnect');
          Disconnect;
          Conn_wrt_log('Exception.Create V_RECEIVE_ABORT_ERROR' + abort1.Text);
          raise Exception.Create(V_RECEIVE_ABORT_ERROR + abort1.Text);
        end;
        if k = 5 then
        begin //sendReleaseRequest
          Conn_wrt_log('FAssociation.receiveReleaseRequest');
          FAssociation.receiveReleaseRequest(k);
          Conn_wrt_log('FAssociation.receiveReleaseRequest k='+inttostr(k)+'  and sendReleaseResponse');
          FAssociation.sendReleaseResponse;
          Conn_wrt_log ('Disconnect');
          Disconnect;
          Conn_wrt_log ('Exception.Create V_RECEIVE_RELEASE_REQUEST_ERROR');
          raise Exception.Create(V_RECEIVE_RELEASE_REQUEST_ERROR);
        end;
        //        if k <> 4 then
        //          raise Exception.Create('No DataPdu To receive!');
      end
      else
        break;

    until Result;
  end
  else
  begin
    if k = 7 then
    begin
      Conn_wrt_log('FAssociation.receiveAbort');
      abort1 := FAssociation.receiveAbort(k);
      Conn_wrt_log('FAssociation.receiveAbort Reason='+inttostr(abort1.Reason)+'  and Disconnect');
      Disconnect;
      Conn_wrt_log('Exception.Create V_RECEIVE_ABORT_ERROR' + abort1.Text);
      raise Exception.Create(V_RECEIVE_ABORT_ERROR + abort1.Text);
    end;
    if k = 5 then
    begin //sendReleaseRequest
      Conn_wrt_log('FAssociation.receiveReleaseRequest');
      FAssociation.receiveReleaseRequest(k);
      Conn_wrt_log('FAssociation.receiveReleaseRequest k='+inttostr(k)+'  and sendReleaseResponse');
      FAssociation.sendReleaseResponse;
      Conn_wrt_log ('Disconnect');
      Disconnect;
      Conn_wrt_log ('Exception.Create V_RECEIVE_RELEASE_REQUEST_ERROR');
      raise Exception.Create(V_RECEIVE_RELEASE_REQUEST_ERROR);
    end;
  end; //   raise Exception.Create('No DataPdu To receive!');
end;

procedure TCnsDicomConnection.DoDicomRequest(Address: AnsiString; ACommand: TDicomAttributes;
  ARequestDatasets, AResponseDatasets: TList);
begin
  if assigned(FOnDicomRequest) then
    FOnDicomRequest(Address, ACommand, ARequestDatasets, AResponseDatasets);
end;

function TCnsDicomConnection.SendCommand(APid: Byte; CommandAttributes, DataAttributes:
  TDicomAttributes): Boolean;
var
  k: Integer;
  abort1: TDicomAbort;
  {$IFDEF DICOMDEBUG}
  strs: TStringList;
  {$ENDIF}

begin
  Result := false;
  if not Connected then
  begin
    Connect;
  end;

  if (not FAssociation.IsConnected) then
    SendRequest
  else
    FAssociation.Clear;

  if not FAssociation.SendDataPdu(APid, CommandAttributes, DataAttributes) then
  begin
    FAssociation.Init;
    try
      Disconnect;
    except
    end;
    raise Exception.Create(FAssociation.ErrorMsg);
  end;
  k := FAssociation.ReadPduType;
  if k = 4 then
  begin
    repeat
      Result := FAssociation.ReceiveDataPdu(k);
      {$IFDEF DICOMDEBUG}
      strs := TStringList.Create;
      FAssociation.ReceiveCommand.ListAttrinute('', strs);
      SendDebug(strs.Text);
      strs.Free;
      {$ENDIF}

      if not Result then
      begin
        k := FAssociation.ReadPduType;
        if k = 7 then
        begin
          abort1 := FAssociation.receiveAbort(k);
          Disconnect;
          raise Exception.Create(V_RECEIVE_ABORT_ERROR + abort1.Text);
        end;
        if k = 5 then
        begin //sendReleaseRequest
          FAssociation.receiveReleaseRequest(k);
          FAssociation.sendReleaseResponse;
          Disconnect;
          raise Exception.Create(V_RECEIVE_RELEASE_REQUEST_ERROR);
        end;
        //        if k <> 4 then
        //          raise Exception.Create('No DataPdu To receive!');
      end
      else
        break;
    until Result;
  end
    //  else
    //    raise Exception.Create('No DataPdu To receive!');
end;

procedure TCnsDicomConnection.SendResult(ADataset: TDicomAttributes);
var
  da1: TDicomAttributes;
begin
  da1 := FAssociation.PrepareResponseCommand;
  try
    FAssociation.ResponseDataPdu(da1, ADataset);
  finally
    da1.Free;
  end;
end;

procedure TCnsDicomConnection.SendStatus(AStatus: Integer);
var
  da1: TDicomAttributes;
begin
  da1 := FAssociation.PrepareResponseCommand;
  try
    da1.AddVariant(dStatus, 0);
    da1.AddVariant(dDataSetType, DICOM_DATA_NOT_PRESENT);
    FAssociation.ResponseDataPdu(da1, nil);
  finally
    da1.Free;
  end;
end;

procedure TCnsDicomConnection.SendStatus(AStatus, AMsgID: Integer);
var
  da1: TDicomAttributes;
begin
  da1 := FAssociation.PrepareResponseCommand;
  try
    da1.AddVariant(dStatus, 0);
    da1.AddVariant(dDataSetType, DICOM_DATA_NOT_PRESENT);
    da1.AddVariant(dMessageIDBeingRespondedTo, AMsgID);
    da1.Remove(0, $1000);
    FAssociation.ResponseDataPdu(da1, nil);
  finally
    da1.Free;
  end;
end;

function TCnsDicomConnection.GetReceiveDatasets: TList;
begin
  Result := FAssociation.ReceiveDatasets;
end;

procedure TCnsDicomConnection.Clear;
begin
  FAssociation.Clear;
end;

function PrintDicomDatasetsEx(ADatasets: TDicomDatasets; AServer: AnsiString; APort: Integer;
  CallingAE, CalledAE, APrintFormat, APrintOrientation, AFilmSize: AnsiString;
  ACopys, AFromIndex, ALimitCount, AImagePage: Integer;
  AMagnificationType, ASmoothingType, APolarity, ABorderDensity, AEmptyImageDensity, ATrim,
  AMediumType, AFilmDestination: AnsiString;
  AMinDensity, AMaxDensity: integer; IsColor: Boolean; ATimeOutSec: Integer;
  n1: TNetworkQueueItem; AOnAfterSend: TCnsDicomConnectionSendImageEvent;
  ANeedDetailLog: Boolean; APrintWithDefaultParam: Boolean): Boolean;
label
  Retry_print;
var
  msgid: Integer;
  tx, da1: TDicomAttribute;
  cmd1, ImageSequenceHolder, Printer, Session, Filmbox, RefSessionItem: TDicomAttributes;
  KxDcmClient1: TCnsDicomConnection;
  imno: Integer;
  imnofilm: Integer;
  uidint: Integer;
  uidroot: AnsiString;
  BFSUID, FilmboxUID: AnsiString;
  r: TDicomResponse;
  pcid1: Byte;
  status1: Integer;
  ste1: TStatusEntry;

  LogStrings: TStringList;
begin
  Result := false;
  CnsErrorMessage := '';
  uidint := 0;
  msgid := 1;
  Printer := nil;
  if ANeedDetailLog then
    LogStrings := TStringList.Create;

  KxDcmClient1 := TCnsDicomConnection.Create(nil);
  KxDcmClient1.ResetSynTax;
  KxDcmClient1.Host := AServer;
  KxDcmClient1.Port := APort;
  KxDcmClient1.CallingTitle := CallingAE;
  KxDcmClient1.CalledTitle := CalledAE;
  KxDcmClient1.AddPresentationContext(Verification);
  if ATimeOutSec > 0 then
    KxDcmClient1.ReceiveTimeout := ATimeOutSec * 1000
  else
    KxDcmClient1.ReceiveTimeout := 60 * 1000;

  if IsColor then
    KxDcmClient1.AddPresentationContext(BasicColorPrintManagementMetaSOPClass)
  else
    KxDcmClient1.AddPresentationContext(BasicGrayscalePrintManagementMetaSOPClass); //
  {  KxDcmClient1.AddPresentationContext(BasicAnnotationBox);
    KxDcmClient1.AddPresentationContext(BasicPrintImageOverlayBox);
    KxDcmClient1.AddPresentationContext(PresentationLUT);
    KxDcmClient1.AddPresentationContext(PrintJob);
    KxDcmClient1.AddPresentationContext(PrinterConfigurationRetrieval);}

  try
    Retry_print:

    KxDcmClient1.Connect;

    //uidroot := '1.2.40.0.13.0.' + KxDcmClient1.GetLocalIP + '.' + FormatDatetime('yyyymmdd.hhnnsszzzz', now) + '.';
    uidroot := '1.2.40.0.13.0.' + IntToStr(Round(now * 10000)) + '.';
    //ShowMessage(uidroot);
    try
      r := KxDcmClient1.SendRequest;
    except
      on e: Exception do
      begin
        //ShowMessage(V_PRINT_CONNECT_FAIL + e.Message);
        CnsErrorMessage := V_PRINT_CONNECT_FAIL + e.Message + '<' + KxDcmClient1.Host + ':' + IntToStr(KxDcmClient1.Port) + '>';
        exit;
      end;
    end;
    if r = nil then
      ShowMessage(V_PRINT_CONNECT_FAIL)
    else
      if r is TDicomAbort then
    begin
      if ANeedDetailLog then
        LogStrings.Add(TDicomAbort(r).Text);
      //raise Exception.Create('Abort ' + TDicomAbort(r).Text)
      if (MessageDlg('Abort ' + TDicomAbort(r).Text + #13#10 + 'Retry?', mtError, [mbYes, mbNo], 0) = mrYes) then
        goto Retry_print
      else
      begin
        CnsErrorMessage := 'Abort ' + TDicomAbort(r).Text;
        exit;
      end;
    end
    else
      if r is TDicomReject then
    begin
      if ANeedDetailLog then
        LogStrings.Add(TDicomReject(r).Text);
      //raise Exception.Create('Reject ' + TDicomReject(r).Text);
      if (MessageDlg('Abort ' + TDicomReject(r).Text + #13#10 + 'Retry?', mtError, [mbYes, mbNo], 0) = mrYes) then
        goto Retry_print
      else
      begin
        CnsErrorMessage := 'Abort ' + TDicomReject(r).Text;
        exit;
      end;
    end
    else
      if r is TAcknowledge then
    begin
      if ANeedDetailLog then
        LogStrings.Add(TAcknowledge(r).Text);
    end
    else
    begin
      //raise Exception.Create('Connection Fail');
      if (MessageDlg(V_PRINT_CONNECT_FAIL + #13#10 + 'Retry?', mtError, [mbYes, mbNo], 0) = mrYes) then
        goto Retry_print
      else
      begin
        CnsErrorMessage := V_PRINT_CONNECT_FAIL;
        exit;
      end;
    end;

    if IsColor then
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicColorPrintManagementMetaSOPClass)
    else
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicGrayscalePrintManagementMetaSOPClass);

    cmd1 := createNGetRequest(msgid, uidPrinter, UIDS.AsString(PrinterModelSOPInstance));
    inc(msgid);
    if ANeedDetailLog then
    begin
      LogStrings.Add('---------N-GET------------');
      cmd1.ListAttrinute('SendCommand>', LogStrings);
      //Session.ListAttrinute('Session>', LogStrings);
    end;
    if KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
    begin
      if ANeedDetailLog then
        KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
      cmd1.Free;
      if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
      begin
        Printer := KxDcmClient1.FAssociation.ReceiveDatasets[0];

        if ANeedDetailLog then
          Printer.ListAttrinute('Printer>', LogStrings);

        KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
        //        Printer.ListAttrinute('printer:', KxForm.Memo1.Lines);
      end;
    end
    else
    begin
      ShowMessage('Get DICOM PRINTER info error! The distinct reject!');
      exit;
    end;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      raise exception.Create(ste1.toString);
    end;

    Session := TDicomAttributes.Create;
    Session.AddVariant($2000, $10, ACopys); // copies

    {.$IFDEF SEND_ALL_PRINT_PARAM}
    //if APrintWithDefaultParam then
    begin
      Session.AddVariant($2000, $20, 'HIGH');
      Session.AddVariant($2000, $30, AMediumType);
      Session.AddVariant($2000, $40, AFilmDestination); // MAGSINE
    end;
    {.$ENDIF}
    {receive dataset>:706[2000:0020](PrintPriority)CS=<1>HIGH
    receive dataset>:707[2000:0030](MediumType)CS=<1>BLUE FILM
    receive dataset>:708[2000:0040](FilmDestination)CS=<1>BIN_1
    }
    inc(uidint);
    {$IFNDEF USE_NULL_UID_ROOT}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, uidroot + IntToStr(uidint), true);
    {$ELSE}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, '', true);
    {$ENDIF}
    inc(msgid);
    if ANeedDetailLog then
    begin
      LogStrings.Add('---------NCREATE------------');
      cmd1.ListAttrinute('SendCommand>', LogStrings);
      Session.ListAttrinute('Session>', LogStrings);
    end;
    if KxDcmClient1.SendCommand(pcid1, cmd1, Session) then
    begin
      if ANeedDetailLog then
        KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
      cmd1.Free;
      Session.Free;
    end
    else
      exit;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      if ste1 <> nil then
        raise exception.Create(ste1.toString)
      else
        raise exception.Create('Error Status (when sent N-Create command):' + IntToStr(status1))
    end;

    BFSUID := uidroot + IntToStr(uidint);
    imno := AFromIndex;
    while (imno < ADatasets.Count) do
    begin
      imnofilm := 0;

      Filmbox := TDicomAttributes.Create;
      try
        Filmbox.AddVariant($2010, $10, APrintFormat); //'STANDARD\2,1');
        Filmbox.AddVariant($2010, $40, APrintOrientation); //'PORTRAIT'); //LANDSCAPE
        Filmbox.AddVariant($2010, $50, AFilmSize); //'14INx17IN');
        {.$IFDEF SEND_ALL_PRINT_PARAM}
        if APrintWithDefaultParam then
        begin
          Filmbox.AddVariant($2010, $60, AMagnificationType); //OptionsBox.Magnification

          Filmbox.AddVariant($2010, $80, ASmoothingType); //SmoothingType

          //Filmbox.AddVariant($2010, $100, ABorderDensity); //"BLACK"   BorderDensity
          Filmbox.AddVariant($2010, $110, AEmptyImageDensity); //"BLACK"   EmptyImageDensity
          Filmbox.AddVariant($2010, $120, AMinDensity); //MinDensity
          Filmbox.AddVariant($2010, $130, AMaxDensity); //MaxDensity
          Filmbox.AddVariant($2010, $140, ATrim); //"NO"   //Trim
          {receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
          receive dataset>:719[2010:0100](BorderDensity)CS=<1>BLACK
          receive dataset>:720[2010:0110](EmptyImageDensity)CS=<1>1
          receive dataset>:721[2010:0120](MinDensity)US=<1>2
          receive dataset>:722[2010:0130](MaxDensity)US=<1>250
          receive dataset>:723[2010:0140](Trim)CS=<1>YES
          }
        end;
        {.$ENDIF}
        RefSessionItem := TDicomAttributes.Create;
        RefSessionItem.AddVariant(8, $1150, UIDS.AsString(BasicFilmSession));
        //doSOP_BasicFilmSession
        {$IFNDEF USE_NULL_UID_ROOT}
        RefSessionItem.AddVariant(8, $1155, BFSUID);
        {$ELSE}
        RefSessionItem.Add(8, $1155);
        {$ENDIF}
        da1 := Filmbox.Add($2010, $500);
        da1.AddData(RefSessionItem);

        uidint := uidint + 1;

        {$IFNDEF USE_NULL_UID_ROOT}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, uidroot + IntToStr(uidint), true);
        {$ELSE}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, '', true);
        {$ENDIF}
        inc(msgid);
        if ANeedDetailLog then
        begin
          LogStrings.Add('---------NCREATE------------');
          cmd1.ListAttrinute('SendCommand>', LogStrings);
          Filmbox.ListAttrinute('Filmbox>', LogStrings);
        end;
        if KxDcmClient1.SendCommand(pcid1, cmd1, Filmbox) then
        begin
          if ANeedDetailLog then
            KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
          cmd1.Free;
          Filmbox.Free;
          Filmbox := nil;
          if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
          begin
            Filmbox := KxDcmClient1.FAssociation.ReceiveDatasets[0];
            if ANeedDetailLog then
              Filmbox.ListAttrinute('Filmbox', LogStrings);
            KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
            //            Filmbox.ListAttrinute('Filmbox:', KxForm.Memo1.Lines);
          end
          else
          begin
            raise Exception.Create(dcmDicomPrintFilmCreatingError);
          end;
        end
        else
          exit;
        FilmboxUID := uidroot + IntToStr(uidint);
        if assigned(FilmBox) then
        begin
          tx := Filmbox.Item[$2010, $510];
          if (not assigned(tx)) or (tx.GetCount <= 0) then
          begin
            raise Exception.Create(V_DICOM_PRINT_FILMBOX_ERROR);
          end;
          while (imno < ADatasets.Count) and (imnofilm < tx.GetCount) and (imnofilm < ALimitCount)
            do
          begin
            ImageSequenceHolder := TDicomAttributes.Create;

            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if APrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, AMagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, ASmoothingType); //SmoothingType
              ImageSequenceHolder.AddVariant($2020, $20, 'NORMAL'); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            ImageSequenceHolder.Add($2020, $110).AddData(ADatasets.Item[imno].Attributes);

            if assigned(AOnAfterSend) then
              AOnAfterSend(n1, imno + 1);

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox,
              tx.Attributes[imnofilm].GetString(8, $1155));
            inc(msgid);
            try
              if ANeedDetailLog then
              begin
                LogStrings.Add('---------NSET------------');
                cmd1.ListAttrinute('SendCommand>', LogStrings);
                ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
              end;
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                exit;
              if ANeedDetailLog then
                KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
            finally
              cmd1.Free;
              ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;

            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end
        else
        begin
          while (imno < ADatasets.Count) and (imnofilm < ALimitCount) do
          begin
            ImageSequenceHolder := TDicomAttributes.Create;

            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if APrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, AMagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, ASmoothingType); //SmoothingType
              ImageSequenceHolder.AddVariant($2020, $20, 'NORMAL'); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            ImageSequenceHolder.Add($2020, $110).AddData(ADatasets.Item[imno].Attributes);
            if assigned(AOnAfterSend) then
              AOnAfterSend(n1, imno + 1);

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox, '');
            inc(msgid);
            try
              if ANeedDetailLog then
              begin
                LogStrings.Add('---------NSET------------');
                cmd1.ListAttrinute('SendCommand>', LogStrings);
                ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
              end;
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                exit;
              if ANeedDetailLog then
              begin
                KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);

              end;
            finally
              cmd1.Free;
              ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;

            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end;

        cmd1 := createActionRequest(msgid, BasicFilmBox, FilmboxUID, False, 1);
        inc(msgid);
        try
          if ANeedDetailLog then
          begin
            LogStrings.Add('---------N-ACTION-----------');
            cmd1.ListAttrinute('SendCommand>', LogStrings);
            //ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
          end;
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
          begin
            status1 := KxDcmClient1.GetState;
            if status1 <> 0 then
            begin
              ste1 := DicomStatus.getStatusEntry(status1);
              raise exception.Create(ste1.toString);
            end;
            exit;
          end;
          if ANeedDetailLog then
            KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
        finally
          cmd1.Free;
        end;

        cmd1 := createDeleteRequest(msgid, BasicFilmBox, FilmboxUID);
        inc(msgid);
        try
          if ANeedDetailLog then
          begin
            LogStrings.Add('---------N-DELETE------------');
            cmd1.ListAttrinute('SendCommand>', LogStrings);
            //ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
          end;
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
            exit;
        finally
          cmd1.Free;
        end;
        if ANeedDetailLog then
          KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand', LogStrings);

        Result := true;

        if AImagePage=1 then
           break;

      finally
        if assigned(Filmbox) then
          Filmbox.Free;
      end;
    end;
  finally

    if ANeedDetailLog then
      LogStrings.SaveToFile(ExtractFilePath(paramstr(0))+'PrintLog.txt');

    if assigned(Printer) then
      Printer.Free;
    //    KxDcmClient1.Disconnect;
    KxDcmClient1.Free;
  end;
end;

(*
function PrintDicomDatasetsEx(ADatasets: TDicomDatasets; AServer: AnsiString; APort: Integer;
  CallingAE, CalledAE, APrintFormat, APrintOrientation, AFilmSize: AnsiString;
  ACopys, AFromIndex, ALimitCount, AImagePerPage: Integer;
  AMagnificationType, ASmoothingType, APolarity, ABorderDensity, AEmptyImageDensity, ATrim,
  AMediumType, AFilmDestination: AnsiString;
  AMinDensity, AMaxDensity: integer; IsColor: Boolean; ATimeOutSec: Integer;
  n1: TNetworkQueueItem; AOnAfterSend: TCnsDicomConnectionSendImageEvent;
  ANeedDetailLog: Boolean; APrintWithDefaultParam: Boolean): Boolean;
label
  Retry_print;
var
  msgid: Integer;
  tx, da1: TDicomAttribute;
  cmd1, ImageSequenceHolder, Printer, Session, Filmbox, RefSessionItem: TDicomAttributes;
  KxDcmClient1: TCnsDicomConnection;
  imno: Integer;
  imnofilm: Integer;
  uidint: Integer;
  uidroot: AnsiString;
  BFSUID, FilmboxUID: AnsiString;
  r: TDicomResponse;
  pcid1: Byte;
  status1: Integer;
  ste1: TStatusEntry;
  filmcount: Integer;
  LogStrings: TStringList;
begin
  Result := false;
  CnsErrorMessage := '';
  uidint := 0;
  msgid := 1;
  Printer := nil;
  if ANeedDetailLog then
    LogStrings := TStringList.Create;

  KxDcmClient1 := TCnsDicomConnection.Create(nil);
  KxDcmClient1.ResetSynTax;
  KxDcmClient1.Host := AServer;
  KxDcmClient1.Port := APort;
  KxDcmClient1.CallingTitle := CallingAE;
  KxDcmClient1.CalledTitle := CalledAE;
  KxDcmClient1.AddPresentationContext(Verification);
  if ATimeOutSec > 0 then
    KxDcmClient1.ReceiveTimeout := ATimeOutSec * 1000
  else
    KxDcmClient1.ReceiveTimeout := 60 * 1000;

  if IsColor then
    KxDcmClient1.AddPresentationContext(BasicColorPrintManagementMetaSOPClass)
  else
    KxDcmClient1.AddPresentationContext(BasicGrayscalePrintManagementMetaSOPClass); //
  {  KxDcmClient1.AddPresentationContext(BasicAnnotationBox);
    KxDcmClient1.AddPresentationContext(BasicPrintImageOverlayBox);
    KxDcmClient1.AddPresentationContext(PresentationLUT);
    KxDcmClient1.AddPresentationContext(PrintJob);
    KxDcmClient1.AddPresentationContext(PrinterConfigurationRetrieval);}

  try
    Retry_print:

    KxDcmClient1.Connect;

    //uidroot := '1.2.40.0.13.0.' + KxDcmClient1.GetLocalIP + '.' + FormatDatetime('yyyymmdd.hhnnsszzzz', now) + '.';
    uidroot := '1.2.40.0.13.0.' + IntToStr(Round(now * 10000)) + '.';
    //ShowMessage(uidroot);
    try
      r := KxDcmClient1.SendRequest;
    except
      on e: Exception do
      begin
        //ShowMessage(V_PRINT_CONNECT_FAIL + e.Message);
        CnsErrorMessage := V_PRINT_CONNECT_FAIL + e.Message + '<' + KxDcmClient1.Host + ':' + IntToStr(KxDcmClient1.Port) + '>';
        exit;
      end;
    end;
    if r = nil then
      ShowMessage(V_PRINT_CONNECT_FAIL)
    else
      if r is TDicomAbort then
    begin
      if ANeedDetailLog then
        LogStrings.Add(TDicomAbort(r).Text);
      //raise Exception.Create('Abort ' + TDicomAbort(r).Text)
      if (MessageDlg('Abort ' + TDicomAbort(r).Text + #13#10 + 'Retry?', mtError, [mbYes, mbNo], 0) = mrYes) then
        goto Retry_print
      else
      begin
        CnsErrorMessage := 'Abort ' + TDicomAbort(r).Text;
        exit;
      end;
    end
    else
      if r is TDicomReject then
    begin
      if ANeedDetailLog then
        LogStrings.Add(TDicomReject(r).Text);
      //raise Exception.Create('Reject ' + TDicomReject(r).Text);
      if (MessageDlg('Abort ' + TDicomReject(r).Text + #13#10 + 'Retry?', mtError, [mbYes, mbNo], 0) = mrYes) then
        goto Retry_print
      else
      begin
        CnsErrorMessage := 'Abort ' + TDicomReject(r).Text;
        exit;
      end;
    end
    else
      if r is TAcknowledge then
    begin
      if ANeedDetailLog then
        LogStrings.Add(TAcknowledge(r).Text);
    end
    else
    begin
      //raise Exception.Create('Connection Fail');
      if (MessageDlg(V_PRINT_CONNECT_FAIL + #13#10 + 'Retry?', mtError, [mbYes, mbNo], 0) = mrYes) then
        goto Retry_print
      else
      begin
        CnsErrorMessage := V_PRINT_CONNECT_FAIL;
        exit;
      end;
    end;

    if IsColor then
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicColorPrintManagementMetaSOPClass)
    else
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicGrayscalePrintManagementMetaSOPClass);

    cmd1 := createNGetRequest(msgid, uidPrinter, UIDS.AsString(PrinterModelSOPInstance));
    inc(msgid);
    if ANeedDetailLog then
    begin
      LogStrings.Add('---------N-GET------------');
      cmd1.ListAttrinute('SendCommand>', LogStrings);
      //Session.ListAttrinute('Session>', LogStrings);
    end;
    if KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
    begin
      if ANeedDetailLog then
        KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
      cmd1.Free;
      if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
      begin
        Printer := KxDcmClient1.FAssociation.ReceiveDatasets[0];

        if ANeedDetailLog then
          Printer.ListAttrinute('Printer>', LogStrings);

        KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
        //        Printer.ListAttrinute('printer:', KxForm.Memo1.Lines);
      end;
    end
    else
    begin
      ShowMessage('Get DICOM PRINTER info error! The distinct reject!');
      exit;
    end;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      raise exception.Create(ste1.toString);
    end;

    Session := TDicomAttributes.Create;
    Session.AddVariant($2000, $10, ACopys); // copies

    {.$IFDEF SEND_ALL_PRINT_PARAM}
    //if APrintWithDefaultParam then
    begin
      Session.AddVariant($2000, $20, 'HIGH');
      Session.AddVariant($2000, $30, AMediumType);
      Session.AddVariant($2000, $40, AFilmDestination); // MAGSINE
    end;
    {.$ENDIF}
    {receive dataset>:706[2000:0020](PrintPriority)CS=<1>HIGH
    receive dataset>:707[2000:0030](MediumType)CS=<1>BLUE FILM
    receive dataset>:708[2000:0040](FilmDestination)CS=<1>BIN_1
    }
    inc(uidint);
    {$IFNDEF USE_NULL_UID_ROOT}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, uidroot + IntToStr(uidint), true);
    {$ELSE}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, '', true);
    {$ENDIF}
    inc(msgid);
    if ANeedDetailLog then
    begin
      LogStrings.Add('---------NCREATE------------');
      cmd1.ListAttrinute('SendCommand>', LogStrings);
      Session.ListAttrinute('Session>', LogStrings);
    end;
    if KxDcmClient1.SendCommand(pcid1, cmd1, Session) then
    begin
      if ANeedDetailLog then
        KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
      cmd1.Free;
      Session.Free;
    end
    else
      exit;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      if ste1 <> nil then
        raise exception.Create(ste1.toString)
      else
        raise exception.Create('Error Status (when sent N-Create command):' + IntToStr(status1))
    end;

    BFSUID := uidroot + IntToStr(uidint);
    imno := AFromIndex;
    filmcount := 0;
    while (imno < ADatasets.Count) and (filmcount < ALimitCount) do
    begin
      imnofilm := 0;

      Filmbox := TDicomAttributes.Create;
      try
        Filmbox.AddVariant($2010, $10, APrintFormat); //'STANDARD\2,1');
        Filmbox.AddVariant($2010, $40, APrintOrientation); //'PORTRAIT'); //LANDSCAPE
        Filmbox.AddVariant($2010, $50, AFilmSize); //'14INx17IN');
        {.$IFDEF SEND_ALL_PRINT_PARAM}
        if APrintWithDefaultParam then
        begin
          Filmbox.AddVariant($2010, $60, AMagnificationType); //OptionsBox.Magnification

          Filmbox.AddVariant($2010, $80, ASmoothingType); //SmoothingType

          //Filmbox.AddVariant($2010, $100, ABorderDensity); //"BLACK"   BorderDensity
          Filmbox.AddVariant($2010, $110, AEmptyImageDensity); //"BLACK"   EmptyImageDensity
          Filmbox.AddVariant($2010, $120, AMinDensity); //MinDensity
          Filmbox.AddVariant($2010, $130, AMaxDensity); //MaxDensity
          Filmbox.AddVariant($2010, $140, ATrim); //"NO"   //Trim
          {receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
          receive dataset>:719[2010:0100](BorderDensity)CS=<1>BLACK
          receive dataset>:720[2010:0110](EmptyImageDensity)CS=<1>1
          receive dataset>:721[2010:0120](MinDensity)US=<1>2
          receive dataset>:722[2010:0130](MaxDensity)US=<1>250
          receive dataset>:723[2010:0140](Trim)CS=<1>YES
          }
        end;
        {.$ENDIF}
        RefSessionItem := TDicomAttributes.Create;
        RefSessionItem.AddVariant(8, $1150, UIDS.AsString(BasicFilmSession));
        //doSOP_BasicFilmSession
        {$IFNDEF USE_NULL_UID_ROOT}
        RefSessionItem.AddVariant(8, $1155, BFSUID);
        {$ELSE}
        RefSessionItem.Add(8, $1155);
        {$ENDIF}
        da1 := Filmbox.Add($2010, $500);
        da1.AddData(RefSessionItem);

        uidint := uidint + 1;

        {$IFNDEF USE_NULL_UID_ROOT}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, uidroot + IntToStr(uidint), true);
        {$ELSE}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, '', true);
        {$ENDIF}
        inc(msgid);
        if ANeedDetailLog then
        begin
          LogStrings.Add('---------NCREATE------------');
          cmd1.ListAttrinute('SendCommand>', LogStrings);
          Filmbox.ListAttrinute('Filmbox>', LogStrings);
        end;
        if KxDcmClient1.SendCommand(pcid1, cmd1, Filmbox) then
        begin
          if ANeedDetailLog then
            KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
          cmd1.Free;
          Filmbox.Free;
          Filmbox := nil;
          if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
          begin
            Filmbox := KxDcmClient1.FAssociation.ReceiveDatasets[0];
            if ANeedDetailLog then
              Filmbox.ListAttrinute('Filmbox', LogStrings);
            KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
            //            Filmbox.ListAttrinute('Filmbox:', KxForm.Memo1.Lines);
          end
          else
          begin
            raise Exception.Create(dcmDicomPrintFilmCreatingError);
          end;
        end
        else
          exit;
        FilmboxUID := uidroot + IntToStr(uidint);
        if assigned(FilmBox) then
        begin
          tx := Filmbox.Item[$2010, $510];
          if (not assigned(tx)) or (tx.GetCount <= 0) then
          begin
            raise Exception.Create(V_DICOM_PRINT_FILMBOX_ERROR);
          end;
          while (imno < ADatasets.Count) and (imnofilm < tx.GetCount) and (imnofilm < AImagePerPage) do
          begin
            ImageSequenceHolder := TDicomAttributes.Create;

            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if APrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, AMagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, ASmoothingType); //SmoothingType
              ImageSequenceHolder.AddVariant($2020, $20, 'NORMAL'); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            ImageSequenceHolder.Add($2020, $110).AddData(ADatasets.Item[imno].Attributes);

            if assigned(AOnAfterSend) then
              AOnAfterSend(n1, imno + 1);

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox,
              tx.Attributes[imnofilm].GetString(8, $1155));
            inc(msgid);
            try
              if ANeedDetailLog then
              begin
                LogStrings.Add('---------NSET------------');
                cmd1.ListAttrinute('SendCommand>', LogStrings);
                ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
              end;
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                exit;
              if ANeedDetailLog then
                KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
            finally
              cmd1.Free;
              ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;

            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end
        else
        begin
          while (imno < ADatasets.Count) and (imnofilm < AImagePerPage) do
          begin
            ImageSequenceHolder := TDicomAttributes.Create;

            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if APrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, AMagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, ASmoothingType); //SmoothingType
              ImageSequenceHolder.AddVariant($2020, $20, 'NORMAL'); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            ImageSequenceHolder.Add($2020, $110).AddData(ADatasets.Item[imno].Attributes);
            if assigned(AOnAfterSend) then
              AOnAfterSend(n1, imno + 1);

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox, '');
            inc(msgid);
            try
              if ANeedDetailLog then
              begin
                LogStrings.Add('---------NSET------------');
                cmd1.ListAttrinute('SendCommand>', LogStrings);
                ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
              end;
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                exit;
              if ANeedDetailLog then
              begin
                KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);

              end;
            finally
              cmd1.Free;
              ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;

            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end;

        cmd1 := createActionRequest(msgid, BasicFilmBox, FilmboxUID, False, 1);
        inc(msgid);
        try
          if ANeedDetailLog then
          begin
            LogStrings.Add('---------N-ACTION-----------');
            cmd1.ListAttrinute('SendCommand>', LogStrings);
            //ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
          end;
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
          begin
            status1 := KxDcmClient1.GetState;
            if status1 <> 0 then
            begin
              ste1 := DicomStatus.getStatusEntry(status1);
              raise exception.Create(ste1.toString);
            end;
            exit;
          end;
          if ANeedDetailLog then
            KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand>', LogStrings);
        finally
          cmd1.Free;
        end;

        cmd1 := createDeleteRequest(msgid, BasicFilmBox, FilmboxUID);
        inc(msgid);
        try
          if ANeedDetailLog then
          begin
            LogStrings.Add('---------N-DELETE------------');
            cmd1.ListAttrinute('SendCommand>', LogStrings);
            //ImageSequenceHolder.ListAttrinute('SendDataset>', LogStrings);
          end;
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
            exit;
        finally
          cmd1.Free;
        end;
        if ANeedDetailLog then
          KxDcmClient1.Association.ReceiveCommand.ListAttrinute('ReceiveCommand', LogStrings);

        Result := true;

      finally
        if assigned(Filmbox) then
          Filmbox.Free;
      end;

      inc(filmcount);
    end;
  finally

 //   if ANeedDetailLog then
 //     LogStrings.SaveToFile('C:\PrintLog' + FormatDatetime('yyyymmdddhhnnsszzz', now) + '.txt');

    if assigned(Printer) then
      Printer.Free;
    //    KxDcmClient1.Disconnect;
    KxDcmClient1.Free;
  end;
end; *)

function GetVersionInfo(AFileName: string; var AAppName: AnsiString; var AVersion: Integer): Boolean;
type
  TLangAndCP = record
    wLanguage: word;
    wCodePage: word;
  end;
  PLangAndCP = ^TLangAndCP;
var
  S: AnsiString;
  n, Len, i: DWORD;
  k: Integer;
  Buf: pChar;
  Value: pChar;
  LangLen: cardinal;
  Lang: PLangAndCP;
  SubBlock, str1: string;
begin
  S := AFileName; //Application.ExeName;
  AAppName := '';
  AVersion := 0;
  n := GetFileVersionInfoSize(pChar(S), n);

  Result := n > 0;
  if Result then
  begin
    Buf := AllocMem(n);
    GetFileVersionInfo(pChar(S), 0, n, Buf);
    VerQueryValue(Buf, pChar('\\VarFileInfo\\Translation'), Pointer(Lang), LangLen);

    SubBlock := Format('\\StringFileInfo\\%.4x%.4x\\FileDescription', [Lang^.wLanguage,
      Lang^.wCodePage]);
    if VerQueryValue(Buf, pChar(SubBlock), Pointer(Value), Len) then
      AAppName := Value;

    SubBlock := Format('\\StringFileInfo\\%.4x%.4x\\FileVersion', [Lang^.wLanguage,
      Lang^.wCodePage]);
    if VerQueryValue(Buf, pChar(SubBlock), Pointer(Value), Len) then
      str1 := Value;
    k := Length(str1);
    for i := k downto 1 do
      if str1[i] = '.' then
      begin
        k := i;
        break;
      end;
    str1 := Copy(str1, k + 1, Length(str1) - k);
    AVersion := StrToInt(str1);

    Result := AAppName <> '';
    FreeMem(Buf, n);
  end;
end;

procedure TCnsDicomConnection.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, operation);
  if Operation = opRemove then
  begin
    //    else if (AComponent = ) then
//       := nil
    ;
  end;
end;

constructor TCnsStorageProcedure.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fparams := TDicomAttributes.Create;
  Fparam := Fparams.Add($2809, $2B);
end;

destructor TCnsStorageProcedure.Destroy;
begin
  Fparams.Clear;
  Fparams.Free;
  inherited;
end;

function TCnsStorageProcedure.Execute(AProcname, AResultname: AnsiString): AnsiString;
var
  FResultAttributes: TDicomAttributes;
begin
  with Fparams do
  begin
    AddVariant($2809, 1, 'PROC');
    AddVariant($2809, 2, DatabaseName);
    AddVariant($2809, $D, AProcname);
    if AResultname <> '' then
      AddVariant($2809, $E, AResultname);
  end;
  if FAppSrvClient.C_Database(Fparams) then
  begin
    if FAppSrvClient.ReceiveDatasets.Count > 0 then
    begin
      FResultAttributes := FAppSrvClient.ReceiveDatasets[0];
      if (FResultAttributes.getInteger($2809, $1004) = 1) then
      begin
        Result := FResultAttributes.GetString($2809, $1003);
      end;
    end;
  end;
  Fparams := TDicomAttributes.Create;
  Fparam := Fparams.Add($2809, $2B);
end;

procedure TCnsStorageProcedure.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, operation);
  if Operation = opRemove then
  begin
    if (AComponent = FAppSrvClient) then
      FAppSrvClient := nil
        ;
  end;
end;

procedure TCnsStorageProcedure.SetFieldAsString(AFieldname, AValue: AnsiString);
var
  pars1: TDicomAttributes;
begin
  pars1 := TDicomAttributes.Create;
  Fparam.AddData(pars1);
  pars1.AddVariant($2809, $28, AFieldname);
  pars1.AddVariant($2809, $29, 0);
  pars1.Add($2809, $23).AsString[0] := AValue;
end;

procedure TCnsStorageProcedure.SetFieldAsDatetime(AFieldname: AnsiString; AValue: Tdatetime);
var
  pars1: TDicomAttributes;
begin
  pars1 := TDicomAttributes.Create;
  Fparam.AddData(pars1);
  pars1.AddVariant($2809, $28, AFieldname);
  pars1.AddVariant($2809, $29, 3);
  pars1.Add($2809, $25).AsDatetime[0] := AValue;
end;

procedure TCnsStorageProcedure.SetFieldAsFloat(AFieldname: AnsiString; AValue: Double);
var
  pars1: TDicomAttributes;
begin
  pars1 := TDicomAttributes.Create;
  Fparam.AddData(pars1);
  pars1.AddVariant($2809, $28, AFieldname);
  pars1.AddVariant($2809, $29, 2);
  pars1.Add($2809, $21).AsFloat[0] := AValue;
end;

procedure TCnsStorageProcedure.SetFieldAsInteger(AFieldname: AnsiString; AValue: Integer);
var
  pars1: TDicomAttributes;
begin
  pars1 := TDicomAttributes.Create;
  Fparam.AddData(pars1);
  pars1.AddVariant($2809, $28, AFieldname);
  pars1.AddVariant($2809, $29, 1);
  pars1.Add($2809, $20).AsInteger[0] := AValue;
end;

procedure TCnsStorageProcedure.SetFieldAsmemo(AFieldname: AnsiString; AValue: AnsiString);
var
  pars1: TDicomAttributes;
begin
  pars1 := TDicomAttributes.Create;
  Fparam.AddData(pars1);
  pars1.AddVariant($2809, $28, AFieldname);
  pars1.AddVariant($2809, $29, 4);
  pars1.Add($2809, $23).AsString[0] := AValue;
end;

constructor TCnsDeltaHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList := TList.Create;

end;

destructor TCnsDeltaHandler.Destroy;
begin
  FList.Free;

  inherited;
end;

procedure TCnsDeltaHandler.Commit;
label
  DeltaHandlerRetry;
var
  d1: TCnsDBTable;
  das1: TDicomAttributes;
  da1: TDicomAttribute;
  i: Integer;
  str1: AnsiString;
  rcount: Integer;
  wadodas1: TDicomDataset;
begin
  if FList.Count = 0 then
    exit;
  d1 := TCnsDBTable(Dataset);
  rcount := 0;
  DeltaHandlerRetry:

  das1 := TDicomAttributes.Create;
  with das1 do
  begin
    AddVariant($2809, 1, 'EXEC');
    AddVariant($2809, 2, D1.FDataBase);

    if d1.CnsTable.LogExec then
      AddVariant($2813, $0120, 1);

    da1 := Add($2809, $2B);
    for i := 0 to FList.Count - 1 do
    begin
      da1.AddData(FList.Items[i]);
    end;
    FList.Clear;
  end;
  if d1.fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin

    if d1.AppSrvClient.C_Database(das1) then
    begin
      if d1.AppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        das1 := d1.AppSrvClient.ReceiveDatasets[0];
        if (das1.getInteger($2809, $1004) <> 1) and (das1.GetString($2809, $1003) <> '') then
        begin
          str1 := das1.GetString($2809, $1003);
          raise Exception.Create(str1);
        end;
        //        FAppSrvClient.FAssociation.ReceiveDatasets.Clear;
        //        da1.Free;
      end;
      {$IFDEF NOTKEEPCONNECTION}
      FAppSrvClient.Disconnect;
      {$ENDIF}
    end;
    d1.AppSrvClient.Clear;

  end
  else
    if d1.fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
  begin
    //todo
    wadodas1 := d1.DoHttpPostDatabase(das1);
    if wadodas1 <> nil then
    try
      das1 := wadodas1.Attributes;
      if (das1.getInteger($2809, $1004) <> 1) and (das1.GetString($2809, $1003) <> '') then
      begin
        str1 := das1.GetString($2809, $1003);
        raise Exception.Create(str1);
      end;
    finally
      wadodas1.Free;
    end;
  end
  else
    raise Exception.Create('This dataset is opened as readonly!');
end;

procedure TCnsDataLink.ActiveChanged;
begin
  //  if  not (csDestroying in FDataSet.ComponentState) then
  if Active then
  begin
    if Assigned(FOnMasterChange) then
      FOnMasterChange(Self);
  end
  else
    if Assigned(FOnMasterDisable) then
    FOnMasterDisable(Self);
end;

procedure TCnsDataLink.LayoutChanged;
begin
  ActiveChanged;
end;

procedure TCnsDataLink.RecordChanged(Field: TField);
begin
  if assigned(Field) then
    if (DataSource.State <> dsSetKey) and (Field.FieldName = 'STUDYUIDX') and
      Assigned(FOnMasterChange) then
      FOnMasterChange(Self);
end;

constructor TCnsDataLink.Create;
begin
  inherited Create;

end;

destructor TCnsDataLink.Destroy;
begin

  inherited;
end;

procedure TCnsDBTable.SetDetailWhereSQL(AValue: AnsiString);
begin
  FDetailWhereSQL := AValue;
  RemoteMasterChangedX(true);
end;

procedure TCnsDBTable.DoAfterPost;
begin
  inherited;
  if (not FInterLoadingData) and assigned(FCnsTable) and FCnsTable.NeedLock then
  begin
    ApplyUpdates;
  end;
end;

procedure TCnsDBTable.InternalPost;
var
  //  das1: TDicomAttributes;
  str1, str2: AnsiString;
  Field1: TField;
  I: Integer;
  //  k: Boolean;

  f1: TField;
  cf1: TCnsFieldGroup;
begin
  DatasetModify := true;
  if not FInterLoadingData then
  begin
    if FAddUpdateTime then
    begin
      f1 := FindField('LASTUPDATEDATE');
      if f1 <> nil then
      begin
        f1.AsDateTime := now;
      end;
    end;

    for i := 0 to Fields.Count - 1 do
    begin
      f1 := Fields[i];
      cf1 := CnsTable.FindNameField(f1.FieldName);
      if cf1 <> nil then
        if not cf1.IsNull then
          //if f1.Required then
          if f1.IsNull then
            raise Exception.Create(f1.DisplayLabel + ' Can not be null');
    end;

    {k := False;
    for I := 0 to Fields.Count - 1 do
    begin
      if ((FDefaultValues.Values[Fields[i].FieldName] = '')
        or (FDefaultValues.Values[Fields[i].FieldName] = 'REM'))
        and (not Fields[i].IsNull)
        and (Fields[i].FieldName <> FOrderIdxField) then
        k := True;
    end; // for
    if not k then
    begin
      Cancel;
    end; }

    //    if State in [dsInsert] then
    begin
      for I := 0 to FDefaultValues.Count - 1 do
      begin
        str1 := FDefaultValues.Names[i];
        str2 := SysUtils.UpperCase(FDefaultValues.Values[str1]);
        if {(State in [dsInsert]) and}((str2 = 'REM') or (str2 = 'INX')) then
        begin
          Field1 := FindField(str1);
          if assigned(Field1) and (not Field1.IsNull) then
          begin
            {jia            with TRegistry.Create do
                          if OpenKey('\Software\CNSoft\CurrentVersion\Remmber\' + TableName, True) then
                          try
                            WriteString(Field1.FieldName, Field1.AsString);
                          finally
                            Free;
                          end; { try/finally }
          end;
        end;
        {if (str2 = 'PY') or (str2 = 'WB') then
        begin
          Field1 := FindField('NAME');
          Field2 := FindField(str1);
          if assigned(Field1) and (not Field1.IsNull) then
          begin
            if str2 = 'PY' then
              Field2.AsString := GetPYHEAD(Field1.AsString)
            else
              if str2 = 'WB' then
              Field2.AsString := GetWB(Field1.AsString);
          end;
        end; }
      end; // for
    end;
  end;

  inherited;
end;

procedure TCnsDBTable.SetKeyFields(AValue: TStrings);
begin
  FKeyFields.Assign(AValue);
end;

procedure TCnsDBTable.SetCalFields(AValue: TStrings);
begin
  fCalFields.Assign(AValue);
end;

procedure TCnsDBTable.SetCalFieldsLabel(AValue: TStrings);
begin
  fCalFieldsLabel.Assign(AValue);
end;

(*function TCnsDBTable.TestForUserField(AWSQL: AnsiString): AnsiString;
  function GetUserownerAsSQL: AnsiString;
  var
    i: integer;
    strs: tstrings;
  begin
    strs := TStringList.Create;
    strs.Text := fUserLogin.UserOwner;
    Result := '';
    for i := 0 to strs.Count - 1 do
    begin
      Result := Result + '''' + strs[i] + '''';
      if i <> (strs.Count - 1) then
        Result := Result + ',';
    end;
    strs.Free;
  end;
  function GetUserownerAsSQLIsSingle: Boolean;
  var
    //    i: integer;
    strs: tstrings;
  begin
    strs := TStringList.Create;
    strs.Text := fUserLogin.UserOwner;
    Result := strs.Count = 1;
    strs.Free;
  end;
  function GetUserownerAsSQLWhickIsSingle: AnsiString;
  var
    //    i: integer;
    strs: tstrings;
  begin
    strs := TStringList.Create;
    strs.Text := fUserLogin.UserOwner;
    Result := strs[0];
    strs.Free;
  end;
var
  st1: TCnsState;
begin
  Result := AWSQL;
  if assigned(fUserLogin) and assigned(FCnsTable) then
  begin
    if assigned(FCnsTable.States) and (FSelectedStateName <> '') then
    begin
      st1 := FCnsTable.States.ItemByName[FSelectedStateName];
      if assigned(st1) then
      begin
        if st1.UserMode = 1 then //self
        begin
          if Result <> '' then
            Result := Result + '  and ';
          Result := Result + '((' + st1.UserField + '=''' + fUserLogin.UserName +
            ''')or(' + st1.UserField + '='''')or(' + st1.UserField + ' IS NULL))';
        end
        else
          if (st1.UserMode = 0) then //owner
        begin
          if (fUserLogin.UserOwner <> '') {and (not IsGrouperComfirm(FAppSrvClient.UserName))} then
          begin
            if Result <> '' then
              Result := Result + '  and ';
            if GetUserownerAsSQLIsSingle then
            begin
              Result := Result + '((' + st1.UserField + ' = ''' + GetUserownerAsSQLWhickIsSingle +
                ''')' +
                'or(' + st1.UserField + '='''')or(' + st1.UserField + ' IS NULL))';
            end
            else
              Result := Result + '((' + st1.UserField + ' in (' {+ fUserLogin.UserName + ''','} +
              GetUserownerAsSQL + '))' +
                'or(' + st1.UserField + '='''')or(' + st1.UserField + ' IS NULL))';
          end
          else
          begin
            if Result <> '' then
              Result := Result + '  and ';
            Result := Result + '((' + st1.UserField + '=''' + fUserLogin.UserName +
              ''')or(' + st1.UserField + '='''')or(' + st1.UserField + ' IS NULL))';
          end;
        end;
      end;
    end
    else
      if (FCnsTable.UserField <> '') then
    begin
      if Result <> '' then
        Result := Result + '  and ';
      Result := Result + FCnsTable.UserField + '=''' + fUserLogin.UserName + '''';
    end;
  end;
end; *)

procedure TCnsDBTable.EnableDetail(Value: Boolean);
begin
  if Value then
    FSelfDataSource.DataSet := self
  else
    FSelfDataSource.DataSet := nil
end;

function TCnsDBTable.OpenValuesTable(AFieldName: AnsiString): TDataset;
var
  i: Integer;
  d1: TKxmMemTable;
  f1: TCnsFieldGroup;
begin
  //  Result := nil;
  if assigned(FCnsTable) and Active then
  begin
    for i := 0 to FValuesDatasetList.Count - 1 do
    begin
      if TKxmMemTable(FValuesDatasetList[i]).Name = self.Name + '_MEM_' + AFieldName then
      begin
        Result := TKxmMemTable(FValuesDatasetList[i]);
        exit;
      end;
    end;
  end;
  f1 := CnsTable.FindNameField(AFieldName);
  d1 := TKxmMemTable.Create(Self);
  d1.Name := self.Name + '_MEM_' + AFieldName;
  d1.FieldDefs.Add('CODE', ftString, 6, false);
  d1.FieldDefs.Add('NAME', ftString, FieldByName(AFieldName).Size, false);
  d1.Open;
  for i := 1 to f1.SelectList.Count do
  begin
    d1.Insert;
    d1.FieldByName('CODE').AsInteger := i;
    d1.FieldByName('NAME').AsString := f1.SelectList[i - 1];
    d1.Post;
  end;
  FValuesDatasetList.Add(d1);
  Result := d1;
end;

function TCnsDBTable.OpenLookupTable(AObjectName, AWhereSQL: AnsiString): TCnsDBTable;
var
  i: Integer;
  d1: TCnsDBTable;
begin
  Result := nil;
  if assigned(FCnsTable) and Active then
  begin
    for i := 0 to FLookupDatasetList.Count - 1 do
    begin
      if TCnsDBTable(FLookupDatasetList[i]).ObjectName = AObjectName then
      begin
        Result := TCnsDBTable(FLookupDatasetList[i]);
        if AWhereSQL <> Result.WhereSQL then
        begin
          Result.WhereSQL := AWhereSQL;
          Result.RefreshTable;
        end;
        exit;
      end;
    end;
  end;
  d1 := TCnsDBTable.Create(self);
  d1.AppSrvClient := AppSrvClient;
  d1.TableLoadMode := TableLoadMode;
  d1.OnHttpGet := fOnHttpGet;
  d1.OnHttpPost := fOnHttpPost;
  d1.ObjectName := AObjectName;
  //  d1.DefaultFormat := DefaultFormat;
  d1.WhereSQL := AWhereSQL;
  d1.SelectedProfileName := self.SelectedProfileName;
  try
    d1.RefreshTable;
  except
    on e: Exception do
    begin
      d1.Free;
      ShowMessage(Format(V_OPENTABLE_ERROR, [e.Message]));
      exit;
    end;
  end;
  if d1.Active then
  begin
    FLookupDatasetList.Add(d1);
    Result := d1;
  end
  else
    d1.Free;
end;

procedure TCnsDBTable.OpenAllLookupTable;
var
  i, i1: integer;
  f1, f2, f3: TField;
  ccn1, ccn2: TCnsFieldGroup;
  t1: TCnsDBTable;
begin
  for i := 0 to Fields.Count - 1 do
  begin
    f1 := Fields[i];
    if f1.FieldKind = fkData then
    begin
      ccn1 := FCnsTable.FindNameField(f1.FieldName);
      if assigned(ccn1) and (ccn1.LookupTable <> '') then
      begin
        t1 := OpenLookupTable(ccn1.LookupTable, ccn1.LookupWhere);
        for i1 := 0 to t1.Fields.Count - 1 do
        begin
          f2 := t1.Fields[i1];
          ccn2 := t1.CnsTable.FindNameField(f2.FieldName);
          if assigned(ccn2) and (ccn2.WidthInMaster > 0) and (not ccn2.IsNull) then
          begin
            f3 := TField.Create(self);
            f3.FieldKind := fkLookup; //fkCalculated;
            f3.FieldName := t1.TableName + f2.FieldName;
            f3.LookupDataSet := t1;
            f3.LookupKeyFields := f1.FieldName;
            f3.LookupResultField := f2.FieldName;
            f3.DisplayLabel := ccn2.Prompt;
            Fields.Add(f3);
          end;
        end;
      end;
    end;
  end;
end;

procedure TCnsDBTable.OpenDetailTable(ADetailWhereSQL: AnsiString = '');
var
  i: Integer;
  d1: TCnsDBTable;
  //  str1: AnsiString;
  ccn1: TCnsFieldGroup;
begin
  if assigned(FCnsTable) and Active and (FCnsTable.Details.Count > 0) and (FDetailDatasetList.Count
    <= 0) then
  begin
    for i := 0 to FCnsTable.Details.Count - 1 do
    begin
      d1 := TCnsDBTable.Create(self);
      d1.AppSrvClient := AppSrvClient;
      d1.TableLoadMode := TableLoadMode;
      d1.OnHttpGet := fOnHttpGet;
      d1.OnHttpPost := fOnHttpPost;
      d1.ObjectName := FCnsTable.Details.Items[i].Name;
      d1.WhereSQL := ADetailWhereSQL;
      //      d1.DefaultFormat := DefaultFormat;
      d1.RemoteMasterSource := FSelfDataSource;
      d1.RemoteMasterFields := KeyFields[0];
      d1.RemoteDetailFields := KeyFields[0];
      d1.ActiveMasterLink := self.ActiveMasterLink;
      if not FieldByName(KeyFields[0]).IsNull then
      begin
        if FieldByName(KeyFields[0]).DataType in [ftSmallint, ftInteger, ftWord] then
          d1.WhereSQL := KeyFields[0] + '=' + FieldByName(KeyFields[0]).AsString
        else
          d1.WhereSQL := KeyFields[0] + '=''' + FieldByName(KeyFields[0]).AsString + '''';
      end
      else
      begin
        if FieldByName(KeyFields[0]).DataType in [ftSmallint, ftInteger, ftWord] then
          d1.WhereSQL := KeyFields[0] + '=0'
        else
          d1.WhereSQL := KeyFields[0] + '=''0''';
      end;
      if assigned(fOnOpenDetailtable) then
        fOnOpenDetailtable(self, d1);
      try
        d1.RefreshTable;
      except
        on e: Exception do
        begin
          d1.Free;
          ShowMessage(Format(V_OPENTABLE_ERROR, [e.Message]));
          exit;
        end;
      end;
      ccn1 := FCnsTable.ItemByName[d1.ObjectName];
      if assigned(ccn1) then
        d1.CnsTable.ReadOnlyState := ccn1.LookupTableDefine.ReadOnlyState;
      FDetailDatasetList.Add(d1);
      {if self.Name <> '' then
      begin
        str1 := GetPY(d1.ObjectName);
        for k := 1 to Length(str1) do
          if str1[k] = ' ' then
            str1[k] := '_';
        try
          d1.Name := str1 + '_Dataset';
        except
          d1.Name := '';
        end;
      end;}
      //          d1.Name := self.Name + '_Detail' + IntToStr(i);
      d1.OpenDetailTable;
      //      d1.RemoteMasterChangedX(False);
    end;
  end;
end;

function TCnsDBTable.OpenAsDetailTable(AObjectName, ADetailWhereSQL, AMasterFields, ADetailFields:
  AnsiString): TCnsDBTable;
var
  //  i: Integer;
  d1: TCnsDBTable;
  //  str1: AnsiString;
//  ccn1: TCnsFieldGroup;
begin
  if assigned(FCnsTable) and Active then
  begin
    d1 := TCnsDBTable.Create(self);
    d1.TableLoadMode := TableLoadMode;
    d1.OnHttpGet := fOnHttpGet;
    d1.OnHttpPost := fOnHttpPost;
    d1.AppSrvClient := AppSrvClient;

    d1.ObjectName := AObjectName;
    d1.WhereSQL := ADetailWhereSQL;
    //      d1.DefaultFormat := DefaultFormat;
    d1.RemoteMasterSource := FSelfDataSource;
    d1.RemoteMasterFields := AMasterFields;
    d1.RemoteDetailFields := ADetailFields;
    d1.ActiveMasterLink := ActiveMasterLink;
    if not FieldByName(AMasterFields).IsNull then
    begin
      if FieldByName(AMasterFields).DataType in [ftSmallint, ftInteger, ftWord] then
        d1.WhereSQL := ADetailFields + '=' + FieldByName(AMasterFields).AsString
      else
        d1.WhereSQL := ADetailFields + '=''' + FieldByName(AMasterFields).AsString + '''';
    end
    else
    begin
      if FieldByName(AMasterFields).DataType in [ftSmallint, ftInteger, ftWord] then
        d1.WhereSQL := ADetailFields + '=0'
      else
        d1.WhereSQL := ADetailFields + '=''0''';
    end;
    FDetailDatasetList.Add(d1);
    Result := d1;
  end;
end;

procedure TCnsDBTable.SetSQL(AValue: AnsiString);
begin
  FSQL := AValue;
  Close;
  FieldDefs.Clear;
end;

constructor TCnsDBTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FConnectionPoll := nil;
  FAppSrvClient := nil;
  FSelfAppSrvClient := nil;

  fActiveMasterLink := false;

  fInRefreshTable := false;
  FAddUpdateTime := false;

  fMasterTimer := nil;
  fMasterTimerCount := 0;

  //FDataTransferStreamFormat := 0;
  FRecordViewDataset := nil;

  fTableLoadMode := cnsLoadFromNetworkEx;
  FDataFileName := '';
  FDataFileDirectory := '';
  FSourceData := nil;

  FData := nil;
  fDataStream := nil;

  fAssociationID := 0;
  FInterLoadingData := false;
  FOldKeyValue := '';

  DatasetModify := False;

  FServerDBType := 0;
  FDBOwnername := '';
  EnableVersioning := False;
  AutoReposition := True;
  //    LanguageID := 4;
  //    SortID := 0;
  //    SubLanguageID := 2;
  //    LocaleID := 2052;
  SortOptions := [mtcoIgnoreLocale];

  FParent := AOwner;

  FCnsTable := nil;

  FHaveBeenMarkDataset := False;
  FAutoId := 1;
  FSQLData := TCnsSQLData.Create;
  FScriptSource := TStringList.Create;
  FAnalyzeScriptSource := TStringList.Create;
  FDataAnalyzeScriptSource := TStringList.Create;

  FListHtml := TStringList.Create;
  FEdithtml := TStringList.Create;
  FViewHtml := TStringList.Create;
  FStartHtml := TStringList.Create;

  FOrderIdxField := 'ORDER_IDX';
  FDatabase := '';
  FTableName := '';
  FSelectedProfileName := '';
  FSelectedStateName := '';
  FSelectedFormatName := '';
  FWhereSQL := '';
  FSpecialWhereSQL := TList.Create;

  FLastRecNo := -1;
  FChangeInDataset := False;

  FObjectName := '';
  FPHPScript := '';
  FFetchCount := 0;
  FFetchStart := 0;
  FSQL := '';
  FObjectTaskSQL := TStringList.Create;

  FProfilesOfUser := TStringList.Create;
  FStatesOfProfile := TStringList.Create;

  FKeyFields := TStringList.Create;
  FDefaultValues := TStringList.Create;

  fCalFields := TStringList.Create;
  fCalFieldsLabel := TStringList.Create;

  DeltaHandler := TCnsDeltaHandler.Create(nil);
  {$IFDEF ENABLE_REMOTE_MASTERLINK}
  FRemoteMasterIndexList := TkxmFieldList.Create;
  FRemoteDetailIndexList := TkxmFieldList.Create;

  FRemoteMasterLink := TMasterDataLink.Create(Self);
  FRemoteMasterLink.OnMasterChange := RemoteMasterChanged;
  FRemoteMasterLink.OnMasterDisable := RemoteMasterDisabled;
  FRemoteMasterLinkUsed := true;
  {$ENDIF}
  FColorFields := TStringList.Create;
  FTreeFields := TStringList.Create;

  FSelfDataSource := TDataSource.Create(self);
  FSelfDataSource.DataSet := self;

  FDetailDatasetList := TList.Create;
  FLookupDatasetList := TList.Create;
  FValuesDatasetList := TList.Create;

  FParams := TParams.Create(self);

end;

destructor TCnsDBTable.Destroy;
var
  i: Integer;
begin
  FSelfDataSource.Free;
  //  for i := 0 to FDetailDatasetList.Count - 1 do
  //    TCnsDBTable(FDetailDatasetList[i]).Free;

  FValuesDatasetList.Free;

  //  for i := 0 to FLookupDatasetList.Count - 1 do
  //    TCnsDBTable(FLookupDatasetList[i]).Free;
  FLookupDatasetList.Clear;
  FLookupDatasetList.Free;

  FColorFields.Free;
  FTreeFields.Free;

  FSQLData.Free;
  FScriptSource.Free;
  FAnalyzeScriptSource.Free;
  FDataAnalyzeScriptSource.Free;

  FObjectTaskSQL.Free;

  FListHtml.Free;
  FEditHtml.Free;
  FViewHtml.Free;
  FStartHtml.Free;

  FKeyFields.Free;
  FDefaultValues.Free;

  fCalFields.Free;
  fCalFieldsLabel.Free;

  FProfilesOfUser.Free;
  FStatesOfProfile.Free;

  DeltaHandler.Free;
  {$IFDEF ENABLE_REMOTE_MASTERLINK}
  FRemoteMasterLink.free;
  FRemoteMasterLink := nil;
  FRemoteMasterIndexList.Free;
  FRemoteMasterIndexList := nil;
  FRemoteDetailIndexList.Free;
  FRemoteDetailIndexList := nil;
  {$ENDIF}

  if assigned(FData) then
  begin
    FData.Clear;
    FData.Free;
    FData := nil;
  end;

  if fDataStream <> nil then
  begin
    fDataStream.free;
    fDataStream := nil;
  end;

  for i := 0 to FSpecialWhereSQL.Count - 1 do
    TDicomAttributes(FSpecialWhereSQL[i]).Free;
  FSpecialWhereSQL.Clear;
  FSpecialWhereSQL.Free;

  FParams.Free;

  if fMasterTimer = nil then
  begin
    fMasterTimer.Free;
  end;

  FDetailDatasetList.Clear;
  FDetailDatasetList.Free;

  if FSelfAppSrvClient <> nil then
  begin
    FSelfAppSrvClient.Disconnect;

    FSelfAppSrvClient.Free;
    FSelfAppSrvClient := nil;
  end;
  inherited Destroy;
end;

procedure TCnsDBTable.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, operation);
  if Operation = opRemove then
  begin
    {$IFDEF ENABLE_REMOTE_MASTERLINK}
    if assigned(FRemoteMasterLink) and (AComponent = FRemoteMasterLink.DataSource) then
      FRemoteMasterLink.DataSource := nil
        {$ENDIF}
    else
      if (AComponent = FAppSrvClient) then
      FAppSrvClient := nil
        //    else if (AComponent = ) then
//       := nil
      ;
  end;
end;

function TCnsDBTable.GetSeverTime: TDatetime;
begin
  Result := now;
end;

procedure TCnsDBTable.ApplyProfileChange(AType: string);
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'EXCHANGE');
    if AType <> '' then
    begin
      AddVariant($2809, 8, AType);
    end;
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FAppSrvClient.C_Database(da1) then
    begin
      if FAppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        da1 := FAppSrvClient.ReceiveDatasets[0];
        ShowMessage(da1.getString($2809, $17));
        //Result := da1.Item[$2809, $18].AsDatetime[0];
      end;
    end;
    FAppSrvClient.Clear;
  end
  else
  begin //todo
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      ShowMessage(da1.getString($2809, $17));
      //Result := da1.Item[$2809, $18].AsDatetime[0];
    finally
      wadodas1.Free;
    end;
  end;
end;

function TCnsDBTable.SendSMS(AUserCode, AUserName, AMod, AData: string): string;
label
   RetryConnectUpdate;
var
  retrycount:Integer;
  LastCode :Integer;
  totalretrycount,r1:Integer;
  f1 : TDicomConnectErrorForm;
  LastErrorMsg:string;
begin
  retrycount := 0;
  totalretrycount := 2;

  RetryConnectUpdate:
  LastErrorMsg := '';
  LastCode := 0;

  try
    InternalSendSMS(AUserCode, AUserName, AMod, AData);
  except
    on e: Exception do
    begin
      //todo try
      LastErrorMsg := e.Message;
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
        if LastCode = 0 then
          LastCode := 2;
      end
      else
        if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
      begin
        LastCode := 1;
      end
    end;
  end;

  if LastCode <> 0 then
  begin
    inc(retrycount);
    if LastCode <> 2 then
      totalretrycount := 2
    else
      totalretrycount := 10;
    if retrycount <= totalretrycount then
    begin
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
        AppSrvClient.Disconnect;
        AppSrvClient.Clear;
      end;
      goto RetryConnectUpdate
    end
    else
    begin
      f1 := TDicomConnectErrorForm.Create(self);
      try
        f1.ErrorCode := LastCode;
        f1.ErrorMessage := LastErrorMsg;
        f1.BitBtn2.Kind := bkIgnore;
        f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
        r1 := f1.ShowModal;
      finally
        f1.free;
      end;
      if r1 = mrRetry then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        retrycount := 0;
        goto RetryConnectUpdate
      end;
    end;
  end;
end;

function TCnsDBTable.InternalSendSMS(AUserCode, AUserName, AMod, AData: string): string;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'SENDSMS');
    AddVariant($2809, $17, AMod);
    AddVariant($2809, $16, AData);

    AddVariant($2809, 5, AUserCode);
    AddVariant($2809, $32, AUserName);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FAppSrvClient.C_Database(da1) then
    begin
      if FAppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        da1 := FAppSrvClient.ReceiveDatasets[0];
        Result := da1.getString($2809, $16);
      end;
    end;
    FAppSrvClient.Clear;
  end
  else
  begin //todo
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      Result := da1.getString($2809, $16);
    finally
      wadodas1.Free;
    end;
  end;
end;

procedure TCnsDBTable.DoAfterInsert;
var
  I: Integer;
  str1, str2, str3: AnsiString;
  Field1: TField;
begin
  if (csdesigning in componentstate) then
    exit;
  inherited DoAfterInsert;
  if not FInterLoadingData then
  begin
    for I := 0 to FDefaultValues.Count - 1 do
    begin
      str1 := FDefaultValues.Names[i];
      str2 := FDefaultValues.Values[str1];
      Field1 := FindField(str1);
      if assigned(Field1) and (Field1.CanModify) then
      begin
        str3 := SysUtils.UpperCase(str2);
        if ((str3) = 'NOW') then
          Field1.AsDateTime := GetSeverTime
        else
          if ((str3) = 'TOMORROW') then
          Field1.AsDateTime := GetSeverTime + 1
        else
          if ((str3) = 'YESTERDAY') then
          Field1.AsDateTime := GetSeverTime - 1
        else
          if ((str3) = 'NEXTYEAR') then
          Field1.AsDateTime := GetSeverTime + 365
        else
          if ((str3) = 'LASTYEAR') then
          Field1.AsDateTime := GetSeverTime - 365
        else
          if ((str3) = 'LAST3YEAR') then
          Field1.AsDateTime := GetSeverTime - 365
        else
          if ((str3) = 'NEXT3YEAR') then
          Field1.AsDateTime := GetSeverTime - 365
        else
          if ((str3) = 'AUTO') then
        begin
          inc(FAutoId);
          FAutoId := FAutoId mod 1000;
          Field1.AsString := FormatDatetime('yyyymmddhhnnsszzz', GetSeverTime) +
            IntToStr(FAutoId);
        end
        else
          if (str3 = 'GENID') then
          Field1.AsInteger := GenId(Field1)
        else
          if (str3 = 'INX') then
          Field1.AsString := GetIncx(Field1)
            {        else
if (str3 = 'USER') then
Field1.AsString := FAppSrvClient.UserName}
        else
          if (str3 = 'REM') then
          Field1.AsString := GetRemmber(Field1)
        else
          if (str2 = 'PY') or (str2 = 'WB') then
        begin

        end
        else
          if assigned(FOnGetDefaultValue) then
          FOnGetDefaultValue(Field1, str2)
        else
          Field1.AsString := str2;
      end;
    end; // for
    if (not FChangeInDataset) {and (not ControlsDisabled)} then
    begin
      Field1 := FindField(FOrderIdxField);
      if assigned(Field1) then
      begin
        Field1.AsInteger := FLastRecNo;
      end;
    end;
  end;
end;

function TCnsDBTable.GenID(AField: TField): Integer;
label
   RetryConnectUpdate;
var
  retrycount:Integer;
  LastCode :Integer;
  totalretrycount,r1:Integer;
  f1 : TDicomConnectErrorForm;
  LastErrorMsg:string;
begin
  retrycount := 0;
  totalretrycount := 2;

  RetryConnectUpdate:
  LastErrorMsg := '';
  LastCode := 0;

  try
    Result := InternalGenID(AField);
  except
    on e: Exception do
    begin
      //todo try
      LastErrorMsg := e.Message;
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
        if LastCode = 0 then
          LastCode := 2;
      end
      else
        if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
      begin
        LastCode := 1;
      end
    end;
  end;

  if LastCode <> 0 then
  begin
    inc(retrycount);
    if LastCode <> 2 then
      totalretrycount := 2
    else
      totalretrycount := 10;
    if retrycount <= totalretrycount then
    begin
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
        AppSrvClient.Disconnect;
        AppSrvClient.Clear;
      end;
      goto RetryConnectUpdate
    end
    else
    begin
      f1 := TDicomConnectErrorForm.Create(self);
      try
        f1.ErrorCode := LastCode;
        f1.ErrorMessage := LastErrorMsg;
        f1.BitBtn2.Kind := bkIgnore;
        f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
        r1 := f1.ShowModal;
      finally
        f1.free;
      end;
      if r1 = mrRetry then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        retrycount := 0;
        goto RetryConnectUpdate
      end;
    end;
  end;
end;

function TCnsDBTable.InternalGenID(AField: TField): Integer;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := 0;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'GENID');
    AddVariant($2809, $2, FDataBase);
    AddVariant($2809, $3, FTableName);
    AddVariant($2809, $10, AField.FieldName);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FAppSrvClient.C_Database(da1) then
    begin
      if FAppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        da1 := FAppSrvClient.ReceiveDatasets[0];
        Result := da1.GetInteger($2809, $29);
      end;
      {$IFDEF NOTKEEPCONNECTION}
      FAppSrvClient.Disconnect;
      {$ENDIF}
    end;
    FAppSrvClient.Clear;
  end
  else
  begin //todo
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      Result := da1.GetInteger($2809, $29);
    finally
      wadodas1.Free;
    end;
  end;
end;

function TCnsDBTable.GenID(AFieldName: AnsiString; AutoInc: Boolean): Integer;
label
   RetryConnectUpdate;
var
  retrycount:Integer;
  LastCode :Integer;
  totalretrycount,r1:Integer;
  f1 : TDicomConnectErrorForm;
  LastErrorMsg:string;
begin
  retrycount := 0;
  totalretrycount := 2;

  RetryConnectUpdate:
  LastErrorMsg := '';
  LastCode := 0;

  try
    Result := InternalGenID(AFieldName, AutoInc);
  except
    on e: Exception do
    begin
      //todo try
      LastErrorMsg := e.Message;
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
        if LastCode = 0 then
          LastCode := 2;
      end
      else
        if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
      begin
        LastCode := 1;
      end
    end;
  end;

  if LastCode <> 0 then
  begin
    inc(retrycount);
    if LastCode <> 2 then
      totalretrycount := 2
    else
      totalretrycount := 10;
    if retrycount <= totalretrycount then
    begin
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
        AppSrvClient.Disconnect;
        AppSrvClient.Clear;
      end;
      goto RetryConnectUpdate
    end
    else
    begin
      f1 := TDicomConnectErrorForm.Create(self);
      try
        f1.ErrorCode := LastCode;
        f1.ErrorMessage := LastErrorMsg;
        f1.BitBtn2.Kind := bkIgnore;
        f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
        r1 := f1.ShowModal;
      finally
        f1.free;
      end;
      if r1 = mrRetry then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        retrycount := 0;
        goto RetryConnectUpdate
      end;
    end;
  end;
end;

function TCnsDBTable.InternalGenID(AFieldName: AnsiString; AutoInc: Boolean): Integer;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := 0;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'GENID');
    AddVariant($2809, $2, FDataBase);
    AddVariant($2809, $3, FTableName);
    AddVariant($2809, $10, AFieldName);
    if not AutoInc then
      AddVariant($2809, $7, 'F');
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FAppSrvClient.C_Database(da1) then
    begin
      if FAppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        da1 := FAppSrvClient.ReceiveDatasets[0];
        Result := da1.GetInteger($2809, $29);
      end;
      {$IFDEF NOTKEEPCONNECTION}
      FAppSrvClient.Disconnect;
      {$ENDIF}
    end;
    FAppSrvClient.Clear;
  end
  else
  begin //todo
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      Result := da1.GetInteger($2809, $29);
    finally
      wadodas1.Free;
    end;
  end;
end;

function TCnsDBTable.SetGenID(AFieldName: AnsiString; Value: Integer): Integer;
label
   RetryConnectUpdate;
var
  retrycount:Integer;
  LastCode :Integer;
  totalretrycount,r1:Integer;
  f1 : TDicomConnectErrorForm;
  LastErrorMsg:string;
begin
  retrycount := 0;
  totalretrycount := 2;

  RetryConnectUpdate:
  LastErrorMsg := '';
  LastCode := 0;

  try
    Result := InternalSetGenID(AFieldName, Value);
  except
    on e: Exception do
    begin
      //todo try
      LastErrorMsg := e.Message;
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
        if LastCode = 0 then
          LastCode := 2;
      end
      else
        if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
      begin
        LastCode := 1;
      end
    end;
  end;

  if LastCode <> 0 then
  begin
    inc(retrycount);
    if LastCode <> 2 then
      totalretrycount := 2
    else
      totalretrycount := 10;
    if retrycount <= totalretrycount then
    begin
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
        AppSrvClient.Disconnect;
        AppSrvClient.Clear;
      end;
      goto RetryConnectUpdate
    end
    else
    begin
      f1 := TDicomConnectErrorForm.Create(self);
      try
        f1.ErrorCode := LastCode;
        f1.ErrorMessage := LastErrorMsg;
        f1.BitBtn2.Kind := bkIgnore;
        f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
        r1 := f1.ShowModal;
      finally
        f1.free;
      end;
      if r1 = mrRetry then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        retrycount := 0;
        goto RetryConnectUpdate
      end;
    end;
  end;
end;

function TCnsDBTable.InternalSetGenID(AFieldName: AnsiString; Value: Integer): Integer;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := 0;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'GENID');
    AddVariant($2809, $2, FDataBase);
    AddVariant($2809, $3, FTableName);
    AddVariant($2809, $10, AFieldName);
    AddVariant($2809, $7, 'F');
    AddVariant($2809, $1004, Value);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FAppSrvClient.C_Database(da1) then
    begin
      if FAppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        da1 := FAppSrvClient.ReceiveDatasets[0];
        Result := da1.GetInteger($2809, $29);
      end;
      {$IFDEF NOTKEEPCONNECTION}
      FAppSrvClient.Disconnect;
      {$ENDIF}
    end;
    FAppSrvClient.Clear;
  end
  else
  begin //todo
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      Result := da1.GetInteger($2809, $29);
    finally
      wadodas1.Free;
    end;
  end;
end;

function TCnsDBTable.GetRemmber(AField: TField): AnsiString;
begin
  {jia  with TRegistry.Create do
      if OpenKey('\Software\CNSoft\CurrentVersion\Remmber\' + TableName, True) then
      try
        Result := ReadString(AField.FieldName);
      finally
        Free;
      end; { try/finally }
end;

function TCnsDBTable.GetIncx(AField: TField): AnsiString;
var
  i, l: Integer;
  AStr: AnsiString;
begin
  Result := '';
  l := 0;
  AStr := GetRemmber(AField);
  if AStr = '' then
    exit;
  for i := Length(AStr) downto 1 do
  begin
    if (AStr[i] >= '0') and (AStr[i] <= '9') then
      Result := AStr[i] + Result
    else
    begin
      l := i;
      Break;
    end;
  end;
  if result <> '' then
  begin
    i := StrToInt(result);
    Result := Copy(AStr, 1, l) + Format('%*d', [Length(AStr) - l, i + 1]);
    result := strReplace(result, ' ', '0');
  end;
end;

procedure TCnsDBTable.DoBeforeInsert;
var
  f1: TField;
  b1: TBookmark;
  //  str1: AnsiString;
begin
  //  if not (bof and (eof)) then
  if (not FInterLoadingData) {and (not ControlsDisabled)} then
  begin
    f1 := FindField(FOrderIdxField);
    if assigned(f1) then
    begin
      FChangeInDataset := True;
      if eof then
        FLastRecNo := f1.AsInteger + 1
      else
      begin
        FLastRecNo := f1.AsInteger;
        b1 := GetBookMark;
        try
          while not eof do
          begin
            edit;
            f1.AsInteger := f1.AsInteger + 1;
            Post;
            Next;
          end; // while
        finally
          GotoBookMark(b1);
          FreeBookmark(b1);
        end;
      end;
      FChangeInDataset := False;
    end;
  end;
  inherited DoBeforeInsert;
end;

procedure TCnsDBTable.InternalEdit;
begin
  inherited InternalEdit;
end;

function TCnsDBTable.BuildDataFromTaskSQL(ATaskSQL: TStrings): TDicomAttributes;
  procedure AddFieldDefine(AAttributes: TDicomAttribute; AField: TCnsFieldGroup);
  var
    i: Integer;
    das1: TDicomAttributes;
  begin
    if AField.IsField then
    begin
      das1 := TDicomAttributes.Create;
      AAttributes.AddData(das1);

      das1.AddVariant($2813, $0101, AField.Name);

      das1.AddVariant($2813, $0103, AField.FieldLength);
      if not AField.IsNull then
        das1.AddVariant($2813, $0105, 1);

      case TFieldType(AField.FieldType) of
        ftMemo: das1.AddVariant($2813, $0102, 9);
        ftSmallint, ftInteger, ftWord, ftAutoInc: das1.AddVariant($2813, $0102, 2);
        ftBoolean: das1.AddVariant($2813, $0102, 3);
        ftFloat, ftCurrency: das1.AddVariant($2813, $0102, 4);
        ftDate: das1.AddVariant($2813, $0102, 5);
        ftTime: das1.AddVariant($2813, $0102, 6);
        ftDateTime: das1.AddVariant($2813, $0102, 7);
        ftBlob: das1.AddVariant($2813, $0102, 8);
        ftString: das1.AddVariant($2813, $0102, 1);
      end;
    end
    else
    begin
      for i := 0 to AField.Count - 1 do
      begin
        AddFieldDefine(AAttributes, AField.Items[i]);
      end;
    end;
  end;
var
  parse1: TCnsSQLParser;
  t1: TCnsTable;
  //  das1: TDicomAttributes;
  da1: TDicomAttribute;
  i: Integer;
begin
  Result := nil;
  if Assigned(ATaskSQL) and (ATaskSQL.Count > 0) then
  begin
    parse1 := TCnsSQLParser.Create;
    try
      SQLData.Clear;
      Parse1.SQLData := TCnsSQLData.Create;
      Parse1.SourceString := ATaskSQL.Text;
      Parse1.Parse;
      if (Parse1.errors = 0) and (Parse1.SQLData.TableGroup.Count > 0) then
      begin
        t1 := Parse1.SQLData.TableGroup.Items[0];
        Result := TDicomAttributes.Create;
        Result.AddVariant($2809, $1004, 1);
        Result.AddVariant($2809, $16, ATaskSQL.Text);
        da1 := Result.Add($2813, $0100);
        for i := 0 to t1.Count - 1 do
        begin
          AddFieldDefine(da1, t1.Items[i]);
        end;
        Result.Add($2813, $0110);
        FObjectName := t1.Name;
        if (Length(FDataFileDirectory) > 0) and (FDataFileDirectory[length(FDataFileDirectory)] <>
          '\') then
          FDataFileName := FDataFileDirectory + '\' + t1.TableName + '.DDB'
        else
          FDataFileName := FDataFileDirectory + t1.TableName + '.DDB';
      end
      else
        raise Exception.Create(Parse1.lst.DataString);
    finally
      Parse1.SQLData.Free;
      Parse1.Free;
    end;
  end;
end;

function TCnsDBTable.BuildNameFromTaskSQL(ATaskSQL: TStrings): AnsiString;
var
  parse1: TCnsSQLParser;
  t1: TCnsTable;
  //  das1: TDicomAttributes;
  //  da1: TDicomAttribute;
  //  i: Integer;
begin
  Result := '';
  if Assigned(ATaskSQL) and (ATaskSQL.Count > 0) then
  begin
    parse1 := TCnsSQLParser.Create;
    try
      SQLData.Clear;
      Parse1.SQLData := TCnsSQLData.Create;
      Parse1.SourceString := ATaskSQL.Text;
      Parse1.Parse;
      if (Parse1.errors = 0) and (Parse1.SQLData.TableGroup.Count > 0) then
      begin
        t1 := Parse1.SQLData.TableGroup.Items[0];

        FObjectName := t1.Name;
        if (Length(FDataFileDirectory) > 0) and (FDataFileDirectory[length(FDataFileDirectory)] <>
          '\') then
          Result := FDataFileDirectory + '\' + t1.TableName + '.DDB'
        else
          Result := FDataFileDirectory + t1.TableName + '.DDB';
      end
      else
        raise Exception.Create(Parse1.lst.DataString);
    finally
      Parse1.SQLData.Free;
      Parse1.Free;
    end;
  end;
end;

procedure PrepareParam(FParams: TParams; AAtt: TDicomAttribute);
var
  pars1: TDicomAttributes;
  i: integer;
  p1: TParam;
begin
  for i := 0 to FParams.Count - 1 do
  begin
    p1 := FParams.Items[i];
    pars1 := TDicomAttributes.Create;
    AAtt.AddData(pars1);
    pars1.AddVariant($2809, $28, p1.Name);
    case p1.DataType of
      ftString: //AnsiString
        begin
          pars1.AddVariant($2809, $29, 0);
          pars1.Add($2809, $23).AsString[0] := p1.AsString;
        end;
      ftSmallint, ftInteger, ftWord: //integer
        begin
          pars1.AddVariant($2809, $29, 1);
          pars1.Add($2809, $20).AsInteger[0] := p1.AsInteger;
        end;
      ftFloat, ftCurrency, ftBCD: //Float
        begin
          pars1.AddVariant($2809, $29, 2);
          pars1.Add($2809, $21).AsFloat[0] := p1.AsFloat;
        end;
      ftDate, ftTime, ftDateTime: //Datetime
        begin
          pars1.AddVariant($2809, $29, 3);
          pars1.Add($2809, $25).AsDatetime[0] := p1.AsDateTime;
        end;
      ftMemo, ftFmtMemo: //memo
        begin
          pars1.AddVariant($2809, $29, 4);
          pars1.Add($2809, $23).AsString[0] := p1.AsMemo;
        end;
    end;
  end;
end;

function TCnsDBTable.DoHttpPostDatabaseEx(ADataset: TDicomAttributes; var aResponseDataset: TDicomAttributes; var aStream: TStream): Boolean;
var
  stm1, stm2: TMemoryStream;
  str1: AnsiString;
  k, l1: Integer;
  p1: PByte;
  //  das1: TDicomDataset;
begin
  Result := false;
  stm1 := TMemoryStream.Create;
  stm2 := TMemoryStream.Create;
  ADataset.Write(stm2, ImplicitVRLittleEndian, 100, false);
  try

    str1 := format('http://%s:%d/SQL', [FAppSrvClient.Host, FAppSrvClient.Port + 1]);

    if assigned(fOnHttpPost) then
      fOnHttpPost(self, str1, stm2, stm1)
    else
      raise Exception.Create('You must set http post event');

    if stm1.Size > 0 then
    begin
      {$IFDEF DICOMDEBUGZ1}
      SendDebug(Format('DoHttpPostDatabaseEx: %s,%d', [str1, stm1.Size]));
      {$ENDIF}

      stm1.Position := 0;
      stm1.Read(k, SizeOf(Integer));

      if k > 0 then
      begin
        stm1.Read(l1, SizeOf(Integer));

        if l1 > 0 then
        begin
          getMem(p1, l1);
          stm1.Read(p1^, l1);

          aStream := TMemoryStream.Create;
          aStream.Write(p1^, l1);
          FreeMem(p1);
        end;

      end;
      //das1 := TDicomDataset.Create;
      //das1.LoadFromStream(stm1);
      //aResponseDataset := das1.Attributes;

      aResponseDataset := TDicomAttributes.Create;
      aResponseDataset.ReadData(stm1.Position, stm1, ImplicitVRLittleEndian);

      //das1.RecreateAttributes;
      Result := true;
    end;
  finally
    stm1.Free;
    stm2.Free;
  end;
end;

function TCnsDBTable.DoHttpPostDatabase(ADataset: TDicomAttributes): TDicomDataset;
var
  stm1, stm2: TMemoryStream;
  str1: AnsiString;
begin
  Result := nil;
  stm1 := TMemoryStream.Create;
  stm2 := TMemoryStream.Create;
  ADataset.Write(stm2, ImplicitVRLittleEndian, 100, false);
  try
    str1 := format('http://%s:%d/SQL', [FAppSrvClient.Host, FAppSrvClient.Port + 1]);

    if assigned(fOnHttpPost) then
      fOnHttpPost(self, str1, stm2, stm1)
    else
      raise Exception.Create('You must set http post event');

    if stm1.Size > 0 then
    begin
      Result := TDicomDataset.Create;
      stm1.Position := 0;
      Result.LoadFromStream(stm1);
    end;
  finally
    stm1.Free;
    stm2.Free;
  end;
end;

procedure TCnsDBTable.InternalOpen;
  procedure BuildCalFields;
  var
    strx1: AnsiString;
    strs1: TStringList;
    x1: Integer;
    ft1: TFieldType;
  begin
    strs1 := TStringList.Create;
    for x1 := 0 to fCalFields.Count - 1 do
    begin
      strx1 := fCalFields[x1];
      if strx1 <> '' then
      begin
        strs1.Text := strReplace(strx1, ';', #13#10);
        if strs1.Count >= 3 then
        begin
          strx1 := strs1[0];

          case strToInt(strs1[1]) of
            2: ft1 := ftInteger;
            3: ft1 := ftBoolean;
            4: ft1 := ftFloat;
            5: ft1 := ftDate;
            6: ft1 := ftTime;
            7: ft1 := ftDateTime;
            8: ft1 := ftBlob;
            9: ft1 := ftMemo;
            //            1:
          else
            ft1 := ftString;
          end;
          if ft1 = ftString then
            FieldDefs.Add(strx1, ft1, strToInt(strs1[2]), False)
          else
            FieldDefs.Add(strx1, ft1, 0, false);
        end;
      end;
    end;
    strs1.Free;
  end;
var
  I: Integer;
//  kc: Integer;
  //  ff1: TCnsFieldGroup;
  da1, das2: TDicomAttributes;
  aa1, a1: TDicomAttribute;
  str1: AnsiString;
  ft1: TFieldType;
  das1: TFileStream;
  fg1: TCnsFieldGroup;
  //  rcount: Integer;
  wadodas1: TDicomDataset;
  stm1: TMemoryStream;

  //  LogStrings: TStringList;
begin
  {$IFDEF DICOMDEBUGZ1}
  kc := GetTickCount;
  {$ENDIF}

  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromWadoPost, cnsLoadFromWadoPostEx, cnsLoadFromNetworkEx] then
  begin
    if not assigned(FAppSrvClient) then
      raise EDatabaseError.Create(FObjectName + V_DATASET_NOT_SETTED);

    DatasetModify := false;
    da1 := TDicomAttributes.Create;
    {$IFDEF DICOMDEBUG}
    SendDebug('ready to open');
    {$ENDIF}
    if Length(FSQL) > 0 then
    begin
      if FDatabase = '' then
        raise EDatabaseError.Create(FObjectName + V_DATABASE_NAME_CAN_NOT_BE_NULL);
      with da1 do
      begin
        AddVariant($2809, 1, 'SUMIT');
        AddVariant($2809, 2, FDatabase);
        AddVariant($2809, 3, FSQL);
        AddVariant($2809, $0011, FFetchCount);
        AddVariant($2809, $0012, FFetchStart);
        AddVariant($2809, $1005, 1);

        //use stream format transfer data
        //if FDataTransferStreamFormat > 0 then
        //  AddVariant($2809, $1006, FDataTransferStreamFormat);

        if FParams.Count > 0 then
        begin
          aa1 := Add($2809, $2B);
          PrepareParam(FParams, aa1);
        end;
      end;
    end
    else
      if FObjectName <> '' then
    begin
      with da1 do
      begin
        AddVariant($2809, 1, 'OBJECT');
        AddVariant($2809, 2, FObjectName);

        AddVariant($2809, $A, FSelectedProfileName);
        AddVariant($2809, $B, FSelectedStateName);
        AddVariant($2809, $C, FWhereSQL);
        //AddVariant($2809, $19, CurrentUserLimit);
        AddVariant($2809, $0011, FFetchCount);
        AddVariant($2809, $0012, FFetchStart);

        if SpecialWhereSQL.Count > 0 then
        begin
          for i := 0 to SpecialWhereSQL.Count - 1 do
            da1.Add($2813, $111).AddData(fSpecialWhereSQL[i]);
          //FSpecialWhereSQL := TDicomAttributes.Create;
          FSpecialWhereSQL.Clear;
        end;

        if FParams.Count > 0 then
        begin
          aa1 := Add($2809, $2B);
          PrepareParam(FParams, aa1);
        end;
        if not assigned(FCnsTable) then
        begin
          AddVariant($2809, $1005, 1);
          if FObjectTaskSQL.Count > 0 then
            AddVariant($2809, $16, FObjectTaskSQL.Text);
        end;

        //use stream format transfer data
        //if FDataTransferStreamFormat > 0 then
        //  AddVariant($2809, $1006, FDataTransferStreamFormat);

      end;
    end
    else
      if PHPScript <> '' then
    begin
      with da1 do
      begin
        AddVariant($2809, 1, 'PHP');
        AddVariant($2809, 2, PHPScript);

        AddVariant($2809, $C, FWhereSQL);
        //AddVariant($2809, $19, CurrentUserLimit);
        AddVariant($2809, $0011, FFetchCount);
        AddVariant($2809, $0012, FFetchStart);

        if SpecialWhereSQL.Count > 0 then
        begin
          for i := 0 to SpecialWhereSQL.Count - 1 do
            da1.Add($2813, $111).AddData(fSpecialWhereSQL[i]);
          //FSpecialWhereSQL := TDicomAttributes.Create;
          FSpecialWhereSQL.Clear;
        end;

        if FParams.Count > 0 then
        begin
          aa1 := Add($2809, $2B);
          PrepareParam(FParams, aa1);
        end;
      end;
    end
    else
      raise Exception.Create('ObjectName or SQL or PHPScript not assign a value');

    if fTableLoadMode = cnsLoadFromNetwork then
    begin
      try
        if FAppSrvClient.C_Database(da1) then
        begin
          if (FAppSrvClient.ReceiveDatasets.Count > 0) then
          begin
            if assigned(FData) then
            begin
              FData.Clear;
              FData.Free;
              FData := nil;
            end;
            FDataLoadedTime := now;
            FData := FAppSrvClient.ReceiveDatasets[0];
            FAppSrvClient.ReceiveDatasets.Clear;
            if FData.getInteger($2809, $1004) < 0 then
            begin
              ShowMessage(FData.GetString($2809, $1003));
            end;
          end;
        end;
        FAppSrvClient.Clear;

      except
        on E: Exception do
        begin
          raise Exception.Create('InternalOpen ' + ObjectName + ',Error:' + e.Message);
        end;
      end;
    end
    else
      if fTableLoadMode = cnsLoadFromNetworkEx then
    begin
      if assigned(FData) then
      begin
        FData.Clear;
        FData.Free;
        FData := nil;
      end;
      try
        if FAppSrvClient.M_Database(da1, fData, fDataStream) then
        begin
          FDataLoadedTime := now;

          {LogStrings := TStringList.Create;
          try
            FData.ListAttrinute('p1.ResponseDataset', LogStrings);
            ShowMessage(LogStrings.Text);
          finally
            LogStrings.Free;
          end; }
        end;
        FAppSrvClient.Clear;

      except
        on E: Exception do
        begin
          raise Exception.Create('InternalOpen ' + ObjectName + ',Error:' + e.Message);
        end;
      end;
    end
    else
      if fTableLoadMode = cnsLoadFromWadoPost then
    begin

      wadodas1 := DoHttpPostDatabase(da1);
      if wadodas1 <> nil then
      try
        FDataLoadedTime := now;
        if assigned(FData) then
        begin
          FData.Clear;
          FData.Free;
          FData := nil;
        end;
        FData := wadodas1.Attributes;
        wadodas1.RecreateAttributes;
      finally
        wadodas1.Free;
      end;

    end
    else
      if fTableLoadMode = cnsLoadFromWadoPostEx then
    begin
      if assigned(FData) then
      begin
        FData.Clear;
        FData.Free;
        FData := nil;
      end;
      //todo
      da1.AddVariant($2809, $1006, 1);

      DoHttpPostDatabaseEx(da1, fData, fDataStream);
    end;
  end
  else
    if fTableLoadMode = cnsLoadFromFile then
  begin
    if FDataFileName = '' then
    begin
      FDataFileName := BuildNameFromTaskSQL(ObjectTaskSQL);
    end;
    if FileExists(FDataFileName) then
    begin
      das1 := TFileStream.Create(FDataFileName, fmOpenRead);
      try
        if assigned(FData) then
        begin
          FData.Clear;
          FData.Free;
          FData := nil;
        end;
        FData := TDicomAttributes.Create;
        FData.ReadData(0, das1, ImplicitVRLittleEndian);
      finally
        das1.Free;
      end;
    end
    else
      if ObjectTaskSQL.Count > 0 then
    begin //����ObjectSQL������
      if assigned(FData) then
      begin
        FData.Clear;
        FData.Free;
        FData := nil;
      end;
      FData := BuildDataFromTaskSQL(ObjectTaskSQL);

    end;
  end
  else
    if fTableLoadMode = cnsLoadFromSourceData then
  begin
    if FObjectName = '' then
      raise Exception.Create('ObjectName not assign a value');
    if assigned(FData) then
    begin
      FData.Clear;
      FData.Free;
      FData := nil;
    end;
    FData := FSourceData;

  end
  else
    if fTableLoadMode = cnsLoadFromWado then
  begin

    str1 := format('http://%s:%d', [FAppSrvClient.Host, FAppSrvClient.Port + 1]) +
      '/TABLE?requestType=WADO' +
      '&objectname=' + FObjectName +
      '&wheresql=' + FWhereSQL +
      '&from=' + IntToStr(FFetchStart) +
      '&fecthcount=' + IntToStr(FFetchCount);

    stm1 := TMemoryStream.Create;
    try
      if assigned(fOnHttpGet) then
        fOnHttpGet(self, str1, stm1)
      else
        raise Exception.Create('You must set http get event');

      if stm1.Size > 0 then
      begin
        //stm1.SaveToFile('c:\t5.dcm');
        wadodas1 := TDicomDataset.Create;
        try
          wadodas1.LoadFromStream(stm1);
          FDataLoadedTime := now;
          if assigned(FData) then
          begin
            FData.Clear;
            FData.Free;
            FData := nil;
          end;
          FData := wadodas1.Attributes;
          wadodas1.RecreateAttributes;
        finally
          wadodas1.Free;
        end;
      end;
    finally
      stm1.Free;
    end;
  end;
  if assigned(FData) then
  begin
    fAssociationID := FData.getInteger($2809, $0011);
    if (FData.getInteger($2809, $1004) <> 1) and (FData.GetString($2809, $1003) <> '') then
    begin
      str1 := Format(V_OPENTABLE_ERROR, [FData.GetString($2809, $1003)]);

      raise EDatabaseError.Create('InternalOpen ' + ObjectName + ',Error:' + str1);
    end;
    if (not assigned(FCnsTable)) then
    begin
      FScriptSource.Text := FData.GetString($2809, $15); //scripter
      FAnalyzeScriptSource.Text := FData.GetString($2809, $1A); //scripter
      FDataAnalyzeScriptSource.Text := FData.GetString($2809, $1C); //scripter

      FListHtml.Text := FData.GetString($2809, $2021); //scripter
      FEditHtml.Text := FData.GetString($2809, $2022); //scripter
      FViewHtml.Text := FData.GetString($2809, $2023); //scripter
      FStartHtml.Text := FData.GetString($2809, $2024); //scripter

      str1 := FData.GetString($2809, $16); //task
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromWadoPost, cnsLoadFromWadoPostEx, cnsLoadFromNetworkEx] then
      begin
        FServerDBType := FData.GetInteger($2809, $2C);
        FDBOwnername := FData.GetString($2809, $2);
      end;
      if str1 <> '' then
        if parse(str1) then
        begin
          //            FCnsTable := SQLData.TableGroup.ItemByName[FObjectname];
        end;
      //      TDicomAttributes(FData).ListAttrinute('REV dataset>:', form1.Memo1.Lines);
            //        BaseSort;
    end;
    if assigned(FCnsTable) and (FTableName <> FCnsTable.TableName) then
    begin
      FTableName := FCnsTable.TableName;
      FDataBase := FCnsTable.DatabaseName;
      FPluginName := FCnsTable.PluginName;

      FDefaultValues.text := FCnsTable.GetDefaultString;
      FKeyFields.Text := FCnsTable.PrimaryKey.Text;

      FAddUpdateTime := FCnsTable.LogTime;

      if FCnsTable.ProfileFieldName <> '' then
      begin
        //          FProfilesOfUser.Text := FCnsTable.FromUserGroupToProfile(CurrentUserLimit);

        if (FProfilesOfUser.Count > 0) and (FSelectedProfileName = '') then
          FSelectedProfileName := FProfilesOfUser[0];
        if (FSelectedProfileName <> '') and assigned(FCnsTable.States) then
        begin
          //FStatesOfProfile.Text := FCnsTable.GetStatesForProfile(CurrentUserLimit,
          //  FSelectedProfileName);
          if (FStatesOfProfile.Count > 0) and (FSelectedStateName = '') then
            FSelectedStateName := FStatesOfProfile[0];
        end;
      end;
      FTreeFields.Text := FCnsTable.FindTreeField;
      //        FColorFields.Text := FCnsTable.
    end;
    a1 := FData.Item[$2813, $0100];
    if assigned(a1) and (a1.GetCount > 0) and (FieldDefs.Count <= 0) then
    begin
      for i := 0 to a1.GetCount - 1 do
      begin
        das2 := a1.Attributes[i];
        str1 := das2.GetString($2813, $0101);
        if assigned(FCnsTable) then
        begin
          fg1 := FCnsTable.FindNameField(str1);
          if assigned(fg1) and (fg1.ByName <> '') then
            str1 := fg1.ByName;
        end;
        case das2.getInteger($2813, $0102) of
          2: ft1 := ftInteger;
          3: ft1 := ftBoolean;
          4: ft1 := ftFloat;
          5: ft1 := ftDate;
          6: ft1 := ftTime;
          7: ft1 := ftDateTime;
          8: ft1 := ftBlob;
          9: ft1 := ftMemo;
          //            1:
        else
          ft1 := ftString;
        end;
        if ft1 = ftString then
          FieldDefs.Add(str1, ft1, das2.getInteger($2813, $0103),
            das2.getInteger($2813, $0105) = 1)
        else
          FieldDefs.Add(str1, ft1, 0,
            das2.getInteger($2813, $0105) = 1);
      end;
      BuildCalFields;
    end;
  end
  else
    exit; //raise Exception.Create('Can not load data');
  {$IFDEF DICOMDEBUG}
  SendDebug('Add fields OK');
  {$ENDIF}
  inherited InternalOpen;
  {$IFDEF DICOMDEBUGZ1}
  SendDebug(Format('InternalOpen(%d)', [GetTickCount - kc]));
  {$ENDIF}
end;

procedure TCnsDBTable.BuildCnsTableData(AStr: string);
  procedure BuildCalFields;
  var
    strx1: AnsiString;
    strs1: TStringList;
    x1: Integer;
    ft1: TFieldType;
  begin
    strs1 := TStringList.Create;
    for x1 := 0 to fCalFields.Count - 1 do
    begin
      strx1 := fCalFields[x1];
      if strx1 <> '' then
      begin
        strs1.Text := strReplace(strx1, ';', #13#10);
        if strs1.Count >= 3 then
        begin
          strx1 := strs1[0];

          case strToInt(strs1[1]) of
            2: ft1 := ftInteger;
            3: ft1 := ftBoolean;
            4: ft1 := ftFloat;
            5: ft1 := ftDate;
            6: ft1 := ftTime;
            7: ft1 := ftDateTime;
            8: ft1 := ftBlob;
            9: ft1 := ftMemo;
            //            1:
          else
            ft1 := ftString;
          end;
          if ft1 = ftString then
            FieldDefs.Add(strx1, ft1, strToInt(strs1[2]), False)
          else
            FieldDefs.Add(strx1, ft1, 0, false);
        end;
      end;
    end;
    strs1.Free;
  end;
var
  ft1: TFieldType;
  a1: TDicomAttribute;
  fg1: TCnsFieldGroup;
  I: Integer;
  das2: TDicomAttributes;
  str1: string;
begin
  if parse(astr) then
  begin
    //            FCnsTable := SQLData.TableGroup.ItemByName[FObjectname];
  end;
  //      TDicomAttributes(FData).ListAttrinute('REV dataset>:', form1.Memo1.Lines);
        //        BaseSort;
  if assigned(FCnsTable) then
  begin
    FTableName := FCnsTable.TableName;
    FDataBase := FCnsTable.DatabaseName;
    FPluginName := FCnsTable.PluginName;

    FDefaultValues.text := FCnsTable.GetDefaultString;
    FKeyFields.Text := FCnsTable.PrimaryKey.Text;
    if FCnsTable.ProfileFieldName <> '' then
    begin
      //          FProfilesOfUser.Text := FCnsTable.FromUserGroupToProfile(CurrentUserLimit);

      if (FProfilesOfUser.Count > 0) and (FSelectedProfileName = '') then
        FSelectedProfileName := FProfilesOfUser[0];
      if (FSelectedProfileName <> '') and assigned(FCnsTable.States) then
      begin
        //FStatesOfProfile.Text := FCnsTable.GetStatesForProfile(CurrentUserLimit,
        //  FSelectedProfileName);
        if (FStatesOfProfile.Count > 0) and (FSelectedStateName = '') then
          FSelectedStateName := FStatesOfProfile[0];
      end;
    end;
    FTreeFields.Text := FCnsTable.FindTreeField;
    //        FColorFields.Text := FCnsTable.
  end;
  a1 := FData.Item[$2813, $0100];
  if assigned(a1) and (a1.GetCount > 0) and (FieldDefs.Count <= 0) then
  begin
    for i := 0 to a1.GetCount - 1 do
    begin
      das2 := a1.Attributes[i];
      str1 := das2.GetString($2813, $0101);
      if assigned(FCnsTable) then
      begin
        fg1 := FCnsTable.FindNameField(str1);
        if assigned(fg1) and (fg1.ByName <> '') then
          str1 := fg1.ByName;
      end;
      case das2.getInteger($2813, $0102) of
        2: ft1 := ftInteger;
        3: ft1 := ftBoolean;
        4: ft1 := ftFloat;
        5: ft1 := ftDate;
        6: ft1 := ftTime;
        7: ft1 := ftDateTime;
        8: ft1 := ftBlob;
        9: ft1 := ftMemo;
        //            1:
      else
        ft1 := ftString;
      end;
      if ft1 = ftString then
        FieldDefs.Add(str1, ft1, das2.getInteger($2813, $0103),
          das2.getInteger($2813, $0105) = 1)
      else
        FieldDefs.Add(str1, ft1, 0,
          das2.getInteger($2813, $0105) = 1);

      {          FieldDefs.Add(str1,
                  TFieldType(das2.getInteger($2813, $0102)),
                  das2.getInteger($2813, $0103),
                  das2.getInteger($2813, $0105) = 1);}
      if assigned(FCnsTable) then
      begin
        //          ff1 := FCnsTable.FindNameField(str1);
        //          if assigned(ff1) then
        begin

          //            if (ff1.ColorStrings.Count > 0) then
          //              FColorFields.Add(Fields[i * 4 + 1]);
        end;
      end;
    end;
    BuildCalFields;
  end;
end;

procedure TCnsDBTable.DoBeforeClose;
begin
  if Active and (State in [dsEdit, dsInsert]) then
  begin
    try
      self.Post;
    except
    end;
  end;
  inherited DoBeforeClose;
end;

procedure TCnsDBTable.InsertCalFieldValue;
var
  str1, str2, str3: AnsiString;
  strs1: TStringList;
  i, k: integer;
  f1: TField;
begin
  strs1 := TStringList.Create;
  for i := 0 to fCalFieldsLabel.Count - 1 do
  begin
    str1 := fCalFieldsLabel.Names[i];
    str2 := fCalFieldsLabel.Values[str1];
    strs1.Text := StrReplace(str2, ';', #13#10);
    str3 := '';
    for k := 0 to strs1.Count - 1 do
    begin
      f1 := FindField(strs1[k]);
      if f1 <> nil then
        str3 := str3 + f1.AsString + #9;
    end;
    f1 := FindField(str1);
    if f1 <> nil then
      f1.AsString := str3;
  end;
  strs1.Free;
end;

procedure TCnsDBTable.DoAfterOpen;
var
  a1, a2, a3, af: TDicomAttribute;
  das1, das2: TDicomAttributes;
  i, k: Integer;
  f1: TField;
  ob1: TOBStream;
  Stream1: TStream;
  field1: TField;
  ff1: TCnsFieldGroup;
  str1: AnsiString;
  {$IFDEF DICOMDEBUGZ1}
  kc: Integer;
  {$ENDIF}
  //  FkxmBinaryStreamFormat1: TkbmBinaryStreamFormat;
begin
  {$IFDEF DICOMDEBUGZ1}
  kc := GetTickCount;
  {$ENDIF}

  if assigned(FData) then
  begin
    //    DisableControls;
    FInterLoadingData := true;
    try
      a1 := FData.Item[$2813, $0110];
      if assigned(a1) then
      begin
        for k := 0 to a1.GetCount - 1 do
        begin
          das1 := a1.Attributes[k];
          a2 := das1.Item[$2813, $0111];
          if assigned(a2) then
          begin
            self.Insert;
            for i := 0 to a2.GetCount - 1 do
            begin
              das2 := a2.Attributes[i];
              f1 := self.FindField(das2.GetString($2813, $0101));
              //f1 := Fields[i];
              if f1 = nil then
                continue;

              case f1.DataType of
                ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString:
                  f1.AsString := das2.GetString($2813, $0123);
                ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint:
                  f1.AsInteger := das2.GetInteger($2813, $0120);
                ftBoolean:
                  begin
                    f1.AsBoolean := das2.GetInteger($2813, $0120) = 1;
                  end;
                ftFloat, ftCurrency, ftBCD:
                  begin
                    af := das2.Item[$2813, $0121];
                    if (af <> nil) and (af.GetCount > 0) then
                      f1.AsFloat := af.AsFloat[0];
                  end;
                ftDate:
                  begin
                    af := das2.Item[$2813, $0126];
                    if (af <> nil) and (af.GetCount > 0) then
                      f1.AsDatetime := af.AsDatetime[0];
                  end;
                ftTime:
                  begin
                    af := das2.Item[$2813, $0127];
                    if (af <> nil) and (af.GetCount > 0) then
                      f1.AsDatetime := af.AsDatetime[0];
                  end;
                ftDateTime{$IFDEF LEVEL6}, ftTimeStamp{$ENDIF}:
                  begin
                    af := das2.Item[$2813, $0125];
                    if (af <> nil) and (af.GetCount > 0) then
                      f1.AsDatetime := af.AsDatetime[0];
                  end;
              else
                begin
                  a3 := das2.Item[$2813, $0124];
                  if (a3 <> nil) and (a3.GetCount > 0) then
                  begin
                    ob1 := a3.AsOBData[0];
                    ob1.Position := 0;

                    Stream1 := self.CreateBlobStream(f1, bmWrite);
                    try
                      Stream1.CopyFrom(ob1, ob1.Size);
                    finally
                      Stream1.Free;
                    end;
                  end;
                end;
              end;
            end;
            InsertCalFieldValue;
            self.Post;
          end;
        end;
      end
      else
        if fDataStream <> nil then
      begin
        if DefaultFormat = nil then
        begin
          DefaultFormat := TkbmBinaryStreamFormat.Create(nil);
        end;
        LoadFromStream(fDataStream);
        //FkxmBinaryStreamFormat1:= TkbmBinaryStreamFormat.Create(nil);

      end;
    finally
      //      EnableControls;
      FInterLoadingData := false;
    end;
    {    if assigned(FData) then
        begin
          FData.Clear;
          FData.Free;
          FData := nil;
        end;}

  end;
  inherited DoAfterOpen;

  if assigned(FCnsTable) then
  begin
    if assigned(FCnstable.States) and (FSelectedStateName <> '') then
    begin
      //        Filter := Fcnstable.States.Name + '=' + IntToStr(FCnsTable.States.ItemByName[FSelectedStateName].Value);
    end;
    for I := 0 to Fields.Count - 1 do // Iterate
    begin
      field1 := Fields[i];
      ff1 := FCnsTable.FindNameField(Field1.FieldName);
      if assigned(ff1) then
      begin
        //          Field1.DataSize := ff1.FieldLength;
        Field1.EditMask := ff1.PictureMask;
        //          Field1.ReadOnly := ff1.Readonly;
        if ff1.WIDTHINGRID = 0 then
          Field1.Visible := false
        else
          if ff1.WIDTHINGRID > 0 then
          Field1.DisplayWidth := ff1.WIDTHINGRID + 3;
        Field1.Required := not ff1.IsNull;
        {        if (ff1.Parent.name <> 'Ĭ��') and (ff1.Parent.name <> '�̳�') then
                begin
                  Field1.DisplayLabel := ff1.Parent.name + '|' + ff1.Prompt;
                end
                else}
        str1 := '';
        if FSelectedProfileName <> '' then
          str1 := ff1.GetProfileRelate('PROMPT', FSelectedProfileName);
        if str1 = '' then
        begin
          {$IFDEF FORCHINESEVERSION}
          if ff1.Prompt1 <> '' then
            Field1.DisplayLabel := ff1.Prompt1
          else
            {$ENDIF}
            Field1.DisplayLabel := ff1.Prompt;
        end
        else
          Field1.DisplayLabel := str1;
        if (ff1.ColorStrings.Count > 0) then
          FColorFields.Add(Field1.FieldName);
      end
      else
        if field1.FieldName = FCnsTable.ProfileFieldName then
        Field1.Visible := false
      else
        if assigned(FCnsTable.States) and (field1.FieldName = FCnsTable.States.Name) then
        Field1.Visible := false;
    end;
    //set readonly for table
    SetReadOnlyAndDisableFunction;

    if FRemoteDetailFieldNames <> '' then
      BuildFieldList(self, FRemoteDetailIndexList, FRemoteDetailFieldNames);

    BaseSort;
  end;

  if Fields.Count > 0 then
  begin
    VersioningMode := mtvmAllSinceCheckPoint;
    EnableVersioning := true;

    StartTransaction;
    CheckPoint;
  end
  else
    raise Exception.Create(Format('Open Table(%s %s) Error, Table No Data Return', [Objectname, sql]));
  {$IFDEF DICOMDEBUGZ1}
  SendDebug(Format('Load %d Data(time %d)', [self.RecordCount, GetTickCount - kc]));
  {$ENDIF}
end;

procedure TCnsDBTable.InternalDelete;
var
  //  das1: TDicomAttributes;
  str1: AnsiString;
  d1: TCnsDBtable;
  i, k: integer;
begin
  //todo ɾ����ϸ��
  if (FDetailDatasetList.Count > 0) then
  begin

    for i := 0 to self.GetDetailDatasetCount - 1 do
    begin
      d1 := self.DetailsByIndex[i];
      str1 := '';
      for k := 0 to d1.FRemoteDetailIndexList.Count - 1 do // Iterate
      begin
        if TField(d1.FRemoteMasterLink.Fields[k]).IsNull then
        begin
          ApplyUpdates;
          EmptyTable;
          exit;
        end;
        str1 := str1 + TField(d1.FRemoteDetailIndexList.Fields[k]).FieldName + '=''' +
          TField(d1.FRemoteMasterLink.Fields[k]).AsString + '''';
      end; // for
      if str1 <> '' then
        ExecSQL(Database, 'DELETE FROM ' + d1.TableName + ' WHERE ' + str1);
      {      d1.Last;
            while not d1.Bof do
              d1.Delete;
            d1.ApplyUpdates;}
    end;
  end;
  inherited InternalDelete;
end;

procedure TCnsDBTable.InternalCancel;
begin
  inherited;
end;

procedure TCnsDBTable.DoAfterDelete;
begin
  inherited;
end;

function TCnsDBTable.GetKeyValue: AnsiString;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FCnsTable.PrimaryKey.Count - 1 do
  begin
    if FCnsTable.PrimaryKey[i] <> '' then
      Result := Result + FieldByName(FCnsTable.PrimaryKey[i]).AsString + ';';
  end;
  FOldKeyValue := Result;
end;

procedure TCnsDBTable.ForceInsertAll;
begin

end;

procedure TCnsDBTable.SetWhereSQL(Value: AnsiString);
begin
  FWhereSQL := Value;
  //  FParams.Clear;
end;

function TCnsDBTable.ExecStorageProcedure(ADatabase, AProcName, AParamName, AParamValue: AnsiString):
  AnsiString;
var
  das1, pars1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := '';
  das1 := TDicomAttributes.Create;

  pars1 := TDicomAttributes.Create;
  das1.Add($2809, $2B).AddData(pars1);
  pars1.AddVariant($2809, $28, AParamname);
  //AnsiString
  pars1.AddVariant($2809, $29, 0);
  pars1.Add($2809, $23).AsString[0] := AParamValue;

  {
    //integer
    pars1.AddVariant($2809,$29,1);
    pars1.Add($2809,$20).AsInteger[0] := 0;
    //Float
    pars1.AddVariant($2809,$29,2);
    pars1.Add($2809,$21).AsFloat[0] := 0;
    //Datetime
    pars1.AddVariant($2809,$29,3);
    pars1.Add($2809,$25).AsDatetime[0] := now;
    //memo
    pars1.AddVariant($2809,$29,4);
    pars1.Add($2809,$23).AsString[0] := AParamValue;
  }
  with das1 do
  begin
    AddVariant($2809, 1, 'PROC');
    AddVariant($2809, 2, ADataBase);
    AddVariant($2809, $D, AProcName);

  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FAppSrvClient.C_Database(das1) then
    begin
      if FAppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        das1 := FAppSrvClient.ReceiveDatasets[0];
        if (das1.getInteger($2809, $1004) = 1) then
        begin
          Result := das1.GetString($2809, $1003);
        end;
      end;
      {$IFDEF NOTKEEPCONNECTION}
      FAppSrvClient.Disconnect;
      {$ENDIF}
    end;
    FAppSrvClient.Clear;
  end
  else
  begin //todo
    wadodas1 := DoHttpPostDatabase(das1);
    if wadodas1 <> nil then
    try
      das1 := wadodas1.Attributes;
      if (das1.getInteger($2809, $1004) = 1) then
      begin
        Result := das1.GetString($2809, $1003);
      end;
    finally
      wadodas1.Free;
    end;
  end;
end;

procedure TCnsDBTable.ExecSQL(ADatabase, ASQL: AnsiString);
label
   RetryConnectUpdate;
var
  retrycount:Integer;
  LastCode :Integer;
  totalretrycount,r1:Integer;
  f1 : TDicomConnectErrorForm;
  LastErrorMsg:string;
begin
  retrycount := 0;
  totalretrycount := 2;

  RetryConnectUpdate:
  LastErrorMsg := '';
  LastCode := 0;

  try
    InternalExecSQL(ADatabase, ASQL);
  except
    on e: Exception do
    begin
      //todo try
      LastErrorMsg := e.Message;
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
        if LastCode = 0 then
          LastCode := 2;
      end
      else
        if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
      begin
        LastCode := 1;
      end
    end;
  end;

  if LastCode <> 0 then
  begin
    inc(retrycount);
    if LastCode <> 2 then
      totalretrycount := 2
    else
      totalretrycount := 10;
    if retrycount <= totalretrycount then
    begin
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
        AppSrvClient.Disconnect;
        AppSrvClient.Clear;
      end;
      goto RetryConnectUpdate
    end
    else
    begin
      f1 := TDicomConnectErrorForm.Create(self);
      try
        f1.ErrorCode := LastCode;
        f1.ErrorMessage := LastErrorMsg;
        f1.BitBtn2.Kind := bkIgnore;
        f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
        r1 := f1.ShowModal;
      finally
        f1.free;
      end;
      if r1 = mrRetry then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        retrycount := 0;
        goto RetryConnectUpdate
      end;
    end;
  end;
end;

procedure TCnsDBTable.InternalExecSQL(ADatabase, ASQL: AnsiString);
var
  das1, das2: TDicomAttributes;
  da1: TDicomAttribute;
  wadodas1: TDicomDataset;
begin
  das2 := TDicomAttributes.Create;
  with das2 do
  begin
    AddVariant($2809, 3, ASQL);
  end;
  das1 := TDicomAttributes.Create;
  with das1 do
  begin
    AddVariant($2809, 1, 'EXEC');
    AddVariant($2809, 2, ADataBase);
    da1 := Add($2809, $2B);
    da1.AddData(das2);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FAppSrvClient.C_Database(das1) then
    begin
      if FAppSrvClient.ReceiveDatasets.Count > 0 then
      begin
        das1 := FAppSrvClient.ReceiveDatasets[0];
        if (das1.getInteger($2809, $1004) <> 1) and (das1.GetString($2809, $1003) <> '') then
        begin
          ShowMessage(V_EXECSQL_ERROR + das1.GetString($2809, $1003));
          raise EDatabaseError.Create(das1.GetString($2809, $1003));
        end;
      end;
      {$IFDEF NOTKEEPCONNECTION}
      FAppSrvClient.Disconnect;
      {$ENDIF}
    end;
    FAppSrvClient.Clear;
  end
  else
  begin //todo
    wadodas1 := DoHttpPostDatabase(das1);
    if wadodas1 <> nil then
    try
      das1 := wadodas1.Attributes;
      if (das1.getInteger($2809, $1004) <> 1) and (das1.GetString($2809, $1003) <> '') then
      begin
        ShowMessage(V_EXECSQL_ERROR + das1.GetString($2809, $1003));
        raise EDatabaseError.Create(das1.GetString($2809, $1003));
      end;
    finally
      wadodas1.Free;
    end;
  end;
end;

procedure TCnsDeltaHandler.ModifyRecord(var Retry: boolean; var State: TUpdateStatus);
var
  i: integer;
  s1, k1, acfieldname: AnsiString;
  v1, v: variant;
  d1: TCnsDBTable;
  //  FAppSrvClient: TCnsDicomConnection;
    //  a1: TDicomAttribute;
  da1, da2: TDicomAttributes;
  dd1: TDicomAttribute;
  //  p1:TOBData;
  fg1: TCnsFieldGroup;
  o1: TObStream;
begin
  State := usUnmodified;
  d1 := TCnsDBTable(Dataset);
  da1 := TDicomAttributes.Create;
  dd1 := da1.Add($2809, $2A);
  s1 := '';
  for i := 0 to FieldCount - 1 do
  begin
    if Values[i] <> OrigValues[i] then
    begin
      v := Values[i];
      if (VarIsNull(v)) then
      begin
        //          sv := 'NULL';
        if not VarIsNull(OrigValues[i]) then
        begin
          if s1 <> '' then
            s1 := s1 + ',';
          s1 := s1 + FieldNames[i] + '= NULL';
        end;
      end
      else
      begin
        //          sv := v;
        if s1 <> '' then
          s1 := s1 + ',';

        if assigned(d1.CnsTable) then
        begin
          fg1 := d1.CnsTable.FindNameField(Fields[i].FieldName);
          if assigned(fg1) then
            acfieldname := fg1.Name
          else
            acfieldname := Fields[i].FieldName;
        end;

        s1 := s1 + acfieldname + '= :' + acfieldname;
        //        s1 := s1 + FieldNames[i] + '= :' + FieldNames[i];
                //add value to params
        da2 := TDicomAttributes.Create;
        da2.AddVariant($2809, $28, acfieldname); //FieldNames[i]);

        case Fields[i].DataType of
          ftSmallint, ftInteger, ftWord:
            begin
              da2.AddVariant($2809, $29, 1);
              da2.Add($2809, $20).AsInteger[0] := ValuesByName[FieldNames[i]];
              //Fields[i].AsInteger;
            end;
          ftFloat, ftCurrency, ftBCD:
            begin
              da2.AddVariant($2809, $29, 2);
              da2.Add($2809, $21).AsFloat[0] := ValuesByName[FieldNames[i]]; //Fields[i].AsFloat;
            end;
          ftDate, ftTime, ftDateTime:
            begin
              da2.AddVariant($2809, $29, 3);
              da2.Add($2809, $25).AsDatetime[0] := ValuesByName[FieldNames[i]];
              //Fields[i].AsDatetime;
            end;
          ftString:
            begin
              da2.AddVariant($2809, $29, 0);
              da2.Add($2809, $23).AsString[0] := ValuesByName[FieldNames[i]];
              //, Fields[i].AsString);
            end;
          ftBlob:
            begin
              da2.AddVariant($2809, $29, 5);

              o1 := TObStream.Create;
              SetValueToStream(o1, FieldNames[i]);

              da2.Add($2809, $24).AddData(o1);
            end;
        else
          begin
            da2.AddVariant($2809, $29, 4);
            da2.Add($2809, $23).AsString[0] := GetValuesByNameEx(FieldNames[i]);
            //, Fields[i].AsString);
          end;
        end;
        dd1.AddData(da2);
      end;
    end;
  end;
  k1 := '';
  for I := 0 to d1.KeyFields.Count - 1 do // Iterate
  begin
    if k1 <> '' then
      k1 := k1 + ' and ';
    k1 := k1 + d1.KeyFields[i] + '=';
    v1 := OrigValuesByName[d1.KeyFields[i]];
    if VarType(v1) in [varSmallint, varInteger, varSingle, varDouble, varCurrency] then
      k1 := k1 + VarToStr(v1)
    else
      k1 := k1 + '''' + VarToStr(v1) + '''';
  end; // for
  if s1 <> '' then
  begin
    if (d1.DBOwnername <> '') and (Pos('.', d1.TableName) <= 0) then
      s1 := 'Update ' + d1.DBOwnername + '.' + d1.TableName + ' set ' + s1 + ' where ' + k1
    else
      s1 := 'Update ' + d1.TableName + ' set ' + s1 + ' where ' + k1;
    da1.AddVariant($2809, 3, s1);
    FList.Add(da1);
  end
  else
    da1.Free;
end;

procedure TCnsDeltaHandler.InsertRecord(var Retry: boolean; var State: TUpdateStatus);
var
  i: integer;
  s, s1, sv, acfieldname: AnsiString;
  v: variant;
  d1: TCnsDBTable;
  da2, da1: TDicomAttributes;
  dd1: TDicomAttribute;
  fg1: TCnsFieldGroup;
  o1: TObStream;
begin
  State := usUnmodified;
  d1 := TCnsDBTable(Dataset);
  s := '';
  s1 := '';
  da1 := TDicomAttributes.Create;
  dd1 := da1.Add($2809, $2A);
  for i := 0 to FieldCount - 1 do
  begin
    v := Values[i];
    if not (VarIsNull(v)) then
    begin
      if (Fields[i].DataType = ftString) and (ValuesByName[FieldNames[i]] = '') then
        continue;
      sv := v;
      if s1 <> '' then
      begin
        s1 := s1 + ',';
        s := s + ',';
      end;
      if assigned(d1.CnsTable) then
      begin
        fg1 := d1.CnsTable.FindNameField(Fields[i].FieldName);
        if assigned(fg1) then
          acfieldname := fg1.Name
        else
          acfieldname := Fields[i].FieldName;
      end;

      s1 := s1 + acfieldname; //Fields[i].FieldName;
      s := s + ':' + acfieldname; //Fields[i].FieldName;
      //add value to params
//      str1 := ValuesByName[FieldNames[i]];
      //          p1.Write(str1,Length(str1));
//      da2.AddVariant($2809, $2021 + kkkk, str1);
      da2 := TDicomAttributes.Create;
      da2.AddVariant($2809, $28, acfieldname); //FieldNames[i]);

      case Fields[i].DataType of
        ftSmallint, ftInteger, ftWord:
          begin
            da2.AddVariant($2809, $29, 1);
            da2.Add($2809, $20).AsInteger[0] := ValuesByName[FieldNames[i]]; //Fields[i].AsInteger;
          end;
        ftFloat, ftCurrency, ftBCD:
          begin
            da2.AddVariant($2809, $29, 2);
            da2.Add($2809, $21).AsFloat[0] := ValuesByName[FieldNames[i]]; //
          end;
        ftDate, ftTime, ftDateTime:
          begin
            da2.AddVariant($2809, $29, 3);
            da2.Add($2809, $25).AsDatetime[0] := ValuesByName[FieldNames[i]]; //
          end;
        ftString:
          begin
            da2.AddVariant($2809, $29, 0);
            da2.Add($2809, $23).AsString[0] := ValuesByName[FieldNames[i]]; //, Fields[i].AsString);
          end;
        ftBlob:
          begin
            da2.AddVariant($2809, $29, 5);

            o1 := TObStream.Create;
            SetValueToStream(o1, FieldNames[i]);

            da2.Add($2809, $24).AddData(o1);
          end;

      else
        begin
          da2.AddVariant($2809, $29, 4);
          da2.Add($2809, $23).AsString[0] := ValuesByName[FieldNames[i]]; //, Fields[i].AsString);
        end;
      end;
      dd1.AddData(da2);
    end;
  end;
  if s1 <> '' then
  begin
    if (d1.DBOwnername <> '') and (Pos('.', d1.TableName) <= 0) then
      s := 'insert into ' + d1.DBOwnername + '.' + d1.TableName + '(' + s1 + ') values(' + s + ')'
    else
      s := 'insert into ' + d1.TableName + '(' + s1 + ') values(' + s + ')';
    da1.AddVariant($2809, 3, s);
    FList.Add(da1);
  end
  else
    da1.Free;
end;

procedure TCnsDeltaHandler.DeleteRecord(var Retry: boolean; var State: TUpdateStatus);
var
  i: integer;
  s1, k1: AnsiString;
  d1: TCnsDBTable;
  da1: TDicomAttributes;
  v1: variant;
begin
  //  State := usUnmodified;
  d1 := TCnsDBTable(Dataset);
  k1 := '';
  for I := 0 to d1.KeyFields.Count - 1 do // Iterate
  begin
    if k1 <> '' then
      k1 := k1 + ' and ';
    k1 := k1 + d1.KeyFields[i] + '=';
    v1 := OrigValuesByName[d1.KeyFields[i]];
    if VarType(v1) in [varSmallint, varInteger, varSingle, varDouble, varCurrency] then
      k1 := k1 + VarToStr(v1)
    else
      k1 := k1 + '''' + VarToStr(v1) + '''';
  end; // for

  if (d1.DBOwnername <> '') and (Pos('.', d1.TableName) <= 0) then
    s1 := 'delete from ' + d1.DBOwnername + '.' + d1.TableName + ' where ' + k1
  else
    s1 := 'delete from ' + d1.TableName + ' where ' + k1;

  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 3, s1);
  end;
  FList.Add(da1);
end;

function TCnsDBTable.RefreshTable(ANewConnection: Boolean = false): Integer;
label
  RetryConnect, RetryConnectUpdate;
var
  LastErrorMsg: string;
  LastCode, r1: Integer;
  f1: TDicomConnectErrorForm;
  retrycount, totalretrycount: Integer;
begin
  //  DisableControls;
  if AppSrvClient = nil then
  begin
    raise Exception.Create('No Connection Data for load data');
  end;

  if not ANewConnection then
  begin
    while fInRefreshTable do
      Application.ProcessMessages;
  end
  else
    if (FSelfAppSrvClient = nil) and (fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx]) then
  begin
    FSelfAppSrvClient := TCnsDicomConnection.Create(self);
    FSelfAppSrvClient.Host := AppSrvClient.Host;
    FSelfAppSrvClient.Port := AppSrvClient.Port;

    AppSrvClient := FSelfAppSrvClient;
  end;

  Screen.cursor := crSQLWait;
  fInRefreshTable := true;
  try
    self.DisableControls;

    //apply update
    retrycount := 0;
    totalretrycount := 2;

    RetryConnectUpdate:
    LastErrorMsg := '';
    LastCode := 0;

    try
      InternalApplyUpdates;
    except
      on e: Exception do
      begin
        //todo try
        LastErrorMsg := e.Message;
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
          if LastCode = 0 then
            LastCode := 2;
        end
        else
          if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
        begin
          LastCode := 1;
        end
      end;
    end;

    if LastCode <> 0 then
    begin
      inc(retrycount);
      if LastCode <> 2 then
        totalretrycount := 2
      else
        totalretrycount := 10;
      if retrycount <= totalretrycount then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        goto RetryConnectUpdate
      end
      else
      begin
        f1 := TDicomConnectErrorForm.Create(self);
        try
          f1.ErrorCode := LastCode;
          f1.ErrorMessage := LastErrorMsg;
          f1.BitBtn2.Kind := bkIgnore;
          f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
          r1 := f1.ShowModal;
        finally
          f1.free;
        end;
        if r1 = mrRetry then
        begin
          if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
          begin
            TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
            AppSrvClient.Disconnect;
            AppSrvClient.Clear;
          end;
          retrycount := 0;
          goto RetryConnectUpdate
        end;
      end;
    end;

    //load table
    Active := false;
    retrycount := 0;

    RetryConnect:
    LastErrorMsg := '';
    LastCode := 0;

    try
      Active := true;
    except
      on e: Exception do
      begin
        //todo try
        LastErrorMsg := e.Message;
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
          if LastCode = 0 then
            LastCode := 2;
        end
        else
          if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
        begin
          LastCode := 1;
        end;
      end;
    end;

    if LastCode <> 0 then
    begin
      inc(retrycount);
      if LastCode <> 2 then
        totalretrycount := 2
      else
        totalretrycount := 10;
      if retrycount <= totalretrycount then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        goto RetryConnect
      end
      else
      begin
        f1 := TDicomConnectErrorForm.Create(self);
        try
          f1.ErrorCode := LastCode;
          f1.ErrorMessage := LastErrorMsg;
          f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
          r1 := f1.ShowModal;
        finally
          f1.free;
        end;
        if r1 = mrRetry then
        begin
          if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
          begin
            TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
            AppSrvClient.Disconnect;
            AppSrvClient.Clear;
          end;
          retrycount := 0;
          goto RetryConnect
        end
        else
          Application.Terminate;
      end;
    end;

    Result := 0;
    //self.EnableControls;
  finally
    fInRefreshTable := false;
    Screen.Cursor := crDefault;
    EnableControls;
  end;
end;

function TCnsDBTable.ApplyUpdates: Boolean;
label
   RetryConnectUpdate;
var
  retrycount:Integer;
  LastCode :Integer;
  totalretrycount,r1:Integer;
  f1 : TDicomConnectErrorForm;
  LastErrorMsg:string;
begin
  retrycount := 0;
  totalretrycount := 2;

  RetryConnectUpdate:
  LastErrorMsg := '';
  LastCode := 0;

  try
   Result := InternalApplyUpdates;
  except
    on e: Exception do
    begin
      //todo try
      LastErrorMsg := e.Message;
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        LastCode := TCnsDicomConnection(AppSrvClient).FSocket.LastCommandStatus;
        if LastCode = 0 then
          LastCode := 2;
      end
      else
        if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetworkEx] then
      begin
        LastCode := 1;
      end
    end;
  end;

  if LastCode <> 0 then
  begin
    inc(retrycount);
    if LastCode <> 2 then
      totalretrycount := 2
    else
      totalretrycount := 10;
    if retrycount <= totalretrycount then
    begin
      if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
      begin
        TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
        AppSrvClient.Disconnect;
        AppSrvClient.Clear;
      end;
      goto RetryConnectUpdate
    end
    else
    begin
      f1 := TDicomConnectErrorForm.Create(self);
      try
        f1.ErrorCode := LastCode;
        f1.ErrorMessage := LastErrorMsg;
        f1.BitBtn2.Kind := bkIgnore;
        f1.Host := Format('%s:%d', [AppSrvClient.Host, AppSrvClient.Port]);
        r1 := f1.ShowModal;
      finally
        f1.free;
      end;
      if r1 = mrRetry then
      begin
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          TCnsDicomConnection(AppSrvClient).FSocket.Disconnect;
          AppSrvClient.Disconnect;
          AppSrvClient.Clear;
        end;
        retrycount := 0;
        goto RetryConnectUpdate
      end;
    end;
  end;
end;

function TCnsDBTable.InternalApplyUpdates: Boolean;
var
  b1: TBookMark;
  i: integer;
  stm1: TFileStream;
  das1: TDicomAttributes;
begin
  Result := false;
  for i := 0 to GetDetailDatasetCount - 1 do
  begin
    if DetailsByIndex[i].State in [dsedit, dsinsert] then
      DetailsByIndex[i].Post;
    DetailsByIndex[i].ApplyUpdates;
  end;
  if Active and assigned(FCnsTable) then
  begin
    if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromNetwork, cnsLoadFromWadoPostEx, cnsLoadFromNetworkEx] then
    begin
      if assigned(DeltaHandler) then
      begin
        b1 := GetBookmark;
        //  DisableControls;
        try
          DeltaHandler.Resolve;

          try
            TCnsDeltaHandler(DeltaHandler).Commit;
          except
            on e: Exception do
            begin
              raise Exception.Create('Apply Update of ' + ObjectName + ',Error:' + e.Message);
            end;
          end;

          Result := true;
          Commit;
          StartTransaction;
          CheckPoint;
        finally
          GotoBookmark(b1);
          FreeBookmark(b1);
          //    EnableControls;
        end;
        //for i := 0 to FDetailDatasetList.Count - 1 do
        //  TCnsDBTable(FDetailDatasetList[i]).ApplyUpdates;
      end;
    end
    else
      if fTableLoadMode = cnsLoadFromFile then
    begin //���浽�ļ�
      if FDataFileName <> '' then
      begin
        Stm1 := TFileStream.Create(FDataFileName, fmCreate);
        Filtered := false;
        das1 := TDicomAttributes.Create;
        try
          das1.LoadDataset(self, 0, -1, nil);
          das1.AddVariant($2809, $1004, 1);
          das1.AddVariant($2809, $16, FObjectTaskSQL.Text);
          das1.Write(stm1, ImplicitVRLittleEndian, 100);
        finally
          das1.Free;
          stm1.Free;
          Filtered := true;
        end;
      end;
    end;
  end;
end;

procedure TCnsDBTable.CancelUpdates;
begin
  Rollback;
  StartTransaction;
  CheckPoint;
end;

procedure TCnsDBTable.HideRecord;
begin
  Rollback;
  Delete;
  StartTransaction;
  CheckPoint;
end;

procedure TCnsDBTable.SetReadOnlyAndDisableFunction;
var
  s1: TCnsState;
  f1: TField;
  k, k1, i: Integer;
begin
  if (FSelectedStateName <> '') and (assigned(FCnsTable)) and assigned(FCnsTable.States) then
  begin
    s1 := FCnsTable.States.ItemByName[FSelectedStateName];

    if assigned(s1) then
    begin
      if s1.IsReadOnly then
      begin
        k := 1;
        k1 := 0;
      end
      else
      begin
        k := 0;
        k1 := 1;
      end;

      if s1.ReadOnlyFields.Count > 0 then
      begin
        if s1.ReadOnlyFields[0] = 'ALL' then
        begin
          for I := 0 to Fields.Count - 1 do // Iterate
          begin
            Fields[i].Tag := 1;
            //            Fields[i].ReadOnly := s1.IsReadOnly;
          end;
        end
        else
        begin
          for I := 0 to Fields.Count - 1 do // Iterate
          begin
            Fields[i].Tag := k1;
            //            Fields[i].ReadOnly := not s1.IsReadOnly;
          end;
          for I := 0 to s1.ReadOnlyFields.Count - 1 do // Iterate
          begin
            f1 := FindField(s1.ReadOnlyFields[i]);
            if assigned(f1) then
            begin
              f1.Tag := k;
              //              f1.ReadOnly := s1.IsReadOnly;
            end;
          end; // for
        end;
      end;
      if (s1.DisableFunctions.Count > 0) and assigned(FOnDataStateChangeEvent) then
        FOnDataStateChangeEvent(self, s1.IsDisableFunction, s1.DisableFunctions.Text);
    end;
  end;
end;
{$IFDEF ENABLE_REMOTE_MASTERLINK}

procedure TCnsDBTable.SetRemoteMasterFields(const Value: AnsiString);
begin
  FRemoteMasterLink.FieldNames := Value;

  // Build master field list.
  if Active and (FRemoteMasterLink.DataSource <> nil) and (FRemoteMasterLink.DataSource.DataSet <>
    nil) then
    BuildFieldList(FRemoteMasterLink.DataSource.DataSet, FRemoteMasterIndexList,
      FRemoteMasterLink.FieldNames);
end;

procedure TCnsDBTable.SetRemoteDetailFields(const Value: AnsiString);
begin
  FRemoteDetailFieldNames := Value;

  // Build detail field list.
  if Active then
    BuildFieldList(self, FRemoteDetailIndexList, FRemoteDetailFieldNames);
end;

function TCnsDBTable.GetRemoteMasterFields: AnsiString;
begin
  Result := FRemoteMasterLink.FieldNames;
end;

procedure TCnsDBTable.SetRemoteDataSource(Value: TDataSource);
begin
  if IsLinkedTo(Value) then
    DatabaseError(kxmSelfRef{$IFNDEF LEVEL3}, Self{$ENDIF});
  FRemoteMasterLink.DataSource := Value;
end;

function TCnsDBTable.GetRemoteDataSource: TDataSource;
begin
  Result := FRemoteMasterLink.DataSource;
end;

procedure TCnsDBTable.BaseSort;
var
  str1: AnsiString;
  i: Integer;
  st1: TcnsState;
begin
  if assigned(FCnsTable) then
  begin
    if assigned(FCnsTable.States) and (FSelectedStateName <> '') then
    begin
      st1 := FCnsTable.States.ItemByName[FSelectedStateName];
      if assigned(st1) and (st1.OrderField <> '') then
      begin
        SortOn(st1.OrderField, [mtcoDescending, mtcoIgnoreLocale]);
      end;
    end
    else
    begin
      str1 := FCnsTable.FindOrderField;
      if str1 = '' then
      begin
        exit;
        for I := 0 to FKeyFields.Count - 1 do // Iterate
        begin
          if (i <> 0) then
            str1 := str1 + ',';
          str1 := str1 + FKeyFields[i];
        end; // for
      end;
      for I := 1 to Length(str1) do // Iterate
      begin
        if str1[i] = ',' then
          str1[i] := ';';
      end; // for
      SortOn(str1, [mtcoIgnoreLocale]);
    end;
  end;
end;

procedure TCnsDBTable.MasterTimerTimer(Sender: TObject);
begin
  if fMasterTimerCount >= 2 then
  begin
    fMasterTimerCount := 0;
    fMasterTimer.Enabled := false;
    RemoteMasterChangedX(False);
  end
  else
    inc(fMasterTimerCount);
end;

procedure TCnsDBTable.RemoteMasterChanged(Sender: TObject);
begin
  if FRemoteMasterLinkUsed then
    if fActiveMasterLink then
    begin
      RemoteMasterChangedX(False);
    end
    else
    begin
      if fMasterTimer = nil then
      begin
        fMasterTimer := TTimer.Create(self);
        fMasterTimer.Interval := 100;
        fMasterTimer.OnTimer := MasterTimerTimer;
      end;
      fMasterTimerCount := 0;
      fMasterTimer.Enabled := true;
    end;
end;

procedure TCnsDBTable.SetActiveMasterLink(Value: Boolean);
var
  i: integer;
begin
  if fActiveMasterLink <> Value then
  begin
    fActiveMasterLink := Value;
    for i := 0 to self.GetDetailDatasetCount - 1 do
    begin
      self.DetailsByIndex[i].ActiveMasterLink := Value;
      //      RemoteMasterChangedX(False);
    end;
    RemoteMasterChangedX(False);
  end;
end;

procedure TCnsDBTable.RemoteMasterChangedX(IsInter: Boolean);
var
  i: Integer;
  str1: AnsiString;
  hrd1: TCnsDBTable;
begin
  // Check if no fields defined for master/detail. Do nothing.
  if (FRemoteMasterLink.Fields.Count <= 0) then
    exit;

  // check if to use detailfieldlist or indexfieldlist (backwards compability).
  if (FRemoteDetailIndexList.Count <= 0) then
    exit;

  //refresh the table
  str1 := '';

  try
    self.DisableControls;
    for I := 0 to FRemoteDetailIndexList.Count - 1 do // Iterate
    begin
      if TField(FRemoteMasterLink.Fields[i]).IsNull then
      begin
        ApplyUpdates;
        EmptyTable;
        exit;
      end;
      str1 := str1 + TField(FRemoteDetailIndexList.Fields[i]).FieldName + '=''' +
        TField(FRemoteMasterLink.Fields[i]).AsString + '''';
    end; // for
    if IsInter then
    begin
      if FDetailWhereSQL <> '' then
        str1 := str1 + ' and ' + FDetailWhereSQL;
      WhereSQL := str1;
      RefreshTable(true);
      //      BaseSort;
    end
    else
      if (str1 <> WhereSQL) then
    begin
      if FDetailWhereSQL <> '' then
        str1 := str1 + ' and ' + FDetailWhereSQL;
      WhereSQL := str1;
      RefreshTable(true);
      //      BaseSort;
    end;
  finally
    if Fields[0].ReadOnly then
    begin
      for I := 0 to Fields.Count - 1 do // Iterate
      begin
        Fields[i].ReadOnly := false;
      end; // for
    end;
    if assigned(FCnsTable) and (FCnsTable.ReadOnlyState < 999) then
    begin
      hrd1 := TCnsDBTable(FRemoteMasterLink.DataSource.Dataset);
      if assigned(hrd1.FCnsTable) and (assigned(Hrd1.FCnsTable.States)) then
      begin
        if hrd1.FieldByName(Hrd1.FCnsTable.States.Name).AsInteger >= FCnsTable.ReadOnlyState then
        begin
          for I := 0 to Fields.Count - 1 do // Iterate
          begin
            Fields[i].ReadOnly := true;
          end; // for
        end;
      end;
    end;
    self.EnableControls;
  end;
end;

procedure TCnsDBTable.RemoteMasterDisabled(Sender: TObject);
begin
  First;
end;
{$ENDIF}

procedure TCnsDBTable.DoOnNewRecord;
var
  i, n: integer;
  aList: TkbmFieldList;
  s1: TCnsState;
  p1: TCnsprofile;
begin
  if not FInterLoadingData then
  begin
    {$IFDEF ENABLE_REMOTE_MASTERLINK}
    if FRemoteMasterLink.Active and
      (FRemoteMasterLink.Fields.Count > 0) and
      ((FRemoteDetailIndexList.Count > 0) or (FIndexList.Count > 0)) then
    begin
      // check if to use detailfieldlist or indexfieldlist (backwards compability).
      if (FRemoteDetailIndexList.Count <= 0) then
        aList := FIndexList
      else
        aList := FRemoteDetailIndexList;
      n := FRemoteMasterLink.Fields.Count;
      if aList.Count < n then
        n := aList.Count;

      for i := 0 to n - 1 do
        TField(Alist.Fields[i]).Value := TField(FRemoteMasterLink.Fields[i]).Value;
    end;
    {$ENDIF}
    if assigned(FCnsTable) then
    begin
      {      if (FCnsTable.ProfileFieldName <> '') then
            begin
              FieldByName(FCnsTable.ProfileFieldName).AsString := FSelectedProfileName;
            end;}
      if assigned(FCnsTable.Profiles) and (FCnsTable.Profiles.Count > 0) then
      begin
        p1 := FCnsTable.Profiles.ItemByname[FSelectedProfileName];
        if assigned(p1) then
          FieldByName(FCnsTable.ProfileFieldName).AsInteger := p1.Value;
      end;
      if assigned(FCnsTable.States) and (FCnsTable.States.Count > 0) then
      begin
        //      s1 := FCnsTable.States.ItemByName[FSelectedStateName];
        s1 := FCnsTable.States.Items[0];
        if assigned(s1) then
          FieldByName(FCnsTable.States.Name).AsInteger := s1.Value;
      end;
    end;
  end;
  inherited DoOnNewRecord;
end;

function TCnsDBTable.Parse(AStr: AnsiString): Boolean;
var
  parse1: TCnsSQLParser;
begin
  parse1 := TCnsSQLParser.Create;
  try
    SQLData.Clear;
    Parse1.SetSQLData(SQLData);
    Parse1.SourceString := AStr;
    Parse1.Parse;
    Result := Parse1.errors = 0;
    if not Result then
      raise Exception.Create(Parse1.lst.DataString)
    else
    begin
      FCnsTable := SQLData.TableGroup.ItemByName[FObjectname];
    end;
  finally
    Parse1.Free;
  end;
end;

procedure TCnsDBTable.SetSelectedProfileName(AValue: AnsiString);
//var
//  i: integer;
begin
  self.DisableControls;
  if (FSelectedProfileName <> AValue) then
  begin
    FSelectedProfileName := AValue;
    if assigned(FCnsTable) and Active and (FCnsTable.ProfileFieldName <> '') then
    begin
      if assigned(FCnsTable.States) then
      begin
        //        FStatesOfProfile.Text := FCnsTable.GetStatesForProfile(CurrentUserLimit,
        //          FSelectedProfileName);
        if (FStatesOfProfile.Count > 0) and (FStatesOfProfile.IndexOf(FSelectedStateName) >= 0)
          then
        begin
          //      FSelectedStateName := FStatesOfProfile[0];
        end
        else
        begin
          if (FStatesOfProfile.Count > 0) then
            FSelectedStateName := FStatesOfProfile[0]
          else
            FSelectedStateName := '';
        end;
      end;
      //      FWhereSQL := '';
      FSelectedFormatName := '';
      RefreshTable;
      {      for i := 0 to FLookupDatasetList.Count - 1 do
            begin
              TCnsDBTable(FLookupDatasetList[i]).SelectedProfileName := AValue;
            end;
      }
    end;
  end;
  self.EnableControls;
end;

procedure TCnsDBTable.SetSelectedStateName(AValue: AnsiString);
begin
  self.DisableControls;
  if FSelectedStateName <> AValue then
  begin
    FSelectedStateName := AValue;
    if assigned(FCnsTable) and Active and (assigned(FCnstable.States)) then
    begin
      //      FWhereSQL := '';
      RefreshTable;
    end;
  end;
  self.EnableControls;
end;

function TCnsDBTable.GetCanModify: Boolean;
var
  s1: TCnsState;
begin
  Result := (not FReadOnly);
  if Result and (assigned(FCnsTable)) and (FSelectedStateName <> '') and assigned(FCnsTable.States)
    then
  begin
    s1 := FCnsTable.States.ItemByName[FSelectedStateName];
    if assigned(s1) and (s1.ReadOnlyFields.Count = 1) and (s1.ReadOnlyFields[0] = 'ALL') then
      Result := false;
  end;
end;

procedure TCnsDBTable.SetObjectName(Value: AnsiString);
begin
  if FObjectname <> Value then
  begin
    Close;
    FObjectname := Value;
    SQLData.Clear;
    EmptyTable;
    FieldDefs.Clear;
    FCnsTable := nil;
  end;
end;

procedure TCnsDBTable.SetObjectTaskSQL(Value: TStrings);
begin
  FObjectTaskSQL.Assign(Value);
end;

{procedure TCnsDBTable.SetDataFileName(Value: AnsiString);
begin
  FDataFileName := Value;
end;}

function TCnsDBTable.GetTreeNodeCaption: AnsiString;
var
  i: Integer;
begin
  if FTreeFields.Count < 0 then
    result := fields[0].AsString
  else
  begin
    result := '';
    for i := 0 to FTreeFields.Count - 1 do
    begin
      if FTreeFields[i] <> '' then
      begin
        if i <> 0 then
          result := result + ';';
        result := result + FieldByName(FTreeFields[i]).AsString;
      end;
    end;
  end;
end;

function TCnsDBTable.GetFieldDistinct(AField: AnsiString): TCnsDBTable;
var
  //  i: Integer;
  d1: TCnsDBTable;
begin
  Result := nil;
  d1 := TCnsDBTable.Create(self);
  d1.AppSrvClient := AppSrvClient;
  d1.TableLoadMode := TableLoadMode;
  d1.OnHttpGet := fOnHttpGet;
  d1.OnHttpPost := fOnHttpPost;

  d1.Database := self.Database;
  d1.WhereSQL := self.WhereSQL;
  //  d1.DefaultFormat := DefaultFormat;
  if DBOwnername <> '' then
    d1.SQL := 'SELECT DISTINCT(' + AField + ') from ' + DBOwnername + '.' + tablename
  else
    d1.SQL := 'SELECT DISTINCT(' + AField + ') from ' + tablename;
  if WhereSQL <> '' then
    d1.sql := d1.sql + ' WHERE ' + self.WhereSQL;

  try
    d1.RefreshTable;
  except
    on e: Exception do
    begin
      d1.Free;
      ShowMessage(V_OPENTABLE_ERROR + e.Message);
      exit;
    end;
  end;
  if d1.Active then
  begin
    Result := d1;
  end
  else
    d1.Free;
end;

function TCnsDBTable.SafeEdit: Boolean;
begin
  Result := true;
  try
    self.Edit;
  except
    on E: Exception do
    begin
      ShowMessage(e.Message);
      Result := false;
    end;
  end;
end;

function TCnsDBTable.SafeDelete: Boolean;
begin
  Result := true;
  try
    self.Delete;
  except
    on E: Exception do
    begin
      ShowMessage(e.Message);
      Result := false;
    end;
  end;
end;

{function TCnsDBTable.ShowListView(ATreeClassity: AnsiString): Boolean;
var
  f1: TDatasetListForm;
begin
  if FDatasetListForm = nil then
  begin
    f1 := TDatasetListForm.Create(self);
    f1.DoRefreshTreeView(ATreeClassity, self);
    f1.baseWhereSQL := self.WhereSQL;
    FDatasetListForm := f1;
  end;
  Result := FDatasetListForm.ShowModal = mrok;
end;}

{procedure TCnsDBTable.ShowNewRecord(AViewName: AnsiString);
var
  f1: TForm;
begin
  f1 := NewRecordView(AViewName);
  try
    f1.Position := poScreenCenter;
    f1.ShowModal;
    self.ApplyUpdates;
  finally
    f1.Free;
  end;
end;

function TCnsDBTable.NewRecordView(AViewName: AnsiString): TForm;
var
  str1: AnsiString;
begin
  Result := nil;
  if Result = nil then
  begin
    Result := TNewRecordForm.Create(self);
    with TNewRecordForm(Result) do
    begin
      InputButton.Enabled := true;
      //    TBItembatInput.Enabled := CanInput;
      SetTaskDataset(self);
      ComboBox1.Items.Text := self.ProfilesOfUser.Text;
      ComboBox1.ItemIndex := self.ProfilesOfUser.IndexOf(self.SelectedProfileName);
      RecordPanel.RefreshLabel;
    end;
  end;
end; }

procedure TCnsDBTable.SavetaskSQL;
var
  da1: TDicomAttributes;
begin
  if CnsTable.GroupName = 'PACSDEV' then
    exit;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'TASK');
    AddVariant($2809, 2, ObjectName);
    AddVariant($2809, $15, FScriptSource.Text); //script
    AddVariant($2809, $16, SQLData.TableGroup.GetText('')); //task sql
    AddVariant($2809, $1A, AnalyzeScriptSource.Text); //task sql
    AddVariant($2809, $1C, DataAnalyzeScriptSource.Text); //task sql

    AddVariant($2809, $2021, FListHtml.Text); //task sql
    AddVariant($2809, $2022, FEditHtml.Text); //task sql
    AddVariant($2809, $2023, FViewHtml.Text); //task sql
    AddVariant($2809, $2024, FStartHtml.Text); //task sql
  end;
  if AppSrvClient.C_Database(da1) then
  begin
    {$IFDEF NOTKEEPCONNECTION}
    AppSrvClient.Disconnect;
    {$ENDIF}
  end;
  AppSrvClient.Clear;
end;

function TCnsDBTable.CreateProcdure: TCnsStorageProcedure;
begin
  Result := TCnsStorageProcedure.Create(FParent);
  Result.AppSrvClient := self.AppSrvClient;
  Result.DatabaseName := self.Database;
end;
(*
function TCnsDBTable.KxDateToStrEx(ADate: TDatetime; ADBType: Integer): AnsiString;
var
  y, m, d: Word;
  s1: AnsiString;
  //  Reg: TRegistry;
begin
  if ADate <= 0 then
    ADate := now;
  if ADBType = 1 then
  begin
    DecodeDate(ADate, y, m, d);
    s1 := IntToStr(y - 2000);
    if length(s1) <= 1 then
      s1 := '0' + s1;
    {    Reg := TRegistry.Create;
        try
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          if Reg.OpenKey('\SOFTWARE\ORACLE\HOME0', True) then
          begin
            if reg.ReadString('NLS_LANG') = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' then}
//              Result := IntToStr(d) + '-' + CShortMonthNames[m] + '-' + s1
//            else
    Result := IntToStr(d) + '-' + EnShortMonthNames[m] + '-' + s1;
    {        Reg.CloseKey;
          end;
        finally
          reg.free;
        end;}
  end
  else
    if ADBType = 2 then
  begin
    DecodeDate(ADate, y, m, d);
    s1 := IntToStr(y - 2000);
    if length(s1) <= 1 then
      s1 := '0' + s1;
    {    Reg := TRegistry.Create;
        try
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          if Reg.OpenKey('\SOFTWARE\ORACLE\HOME0', True) then
          begin
            if reg.ReadString('NLS_LANG') = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' then}
//              Result := IntToStr(d) + '-' + CShortMonthNames[m] + '-' + s1
//            else
    Result := IntToStr(d) + '-' + CShortMonthNames[m] + '-' + s1;
    {        Reg.CloseKey;
          end;
        finally
          reg.free;
        end;}
  end
  else
  begin
    Result := DateToStr(ADate);
  end;
end;

function TCnsDBTable.KxDateToStr(ADate: TDatetime): AnsiString;
var
  y, m, d: Word;
  s1: AnsiString;
  //  Reg: TRegistry;
begin
  if ADate <= 0 then
    ADate := now;
  if FServerDBType = 1 then
  begin
    DecodeDate(ADate, y, m, d);
    s1 := IntToStr(y - 2000);
    if length(s1) <= 1 then
      s1 := '0' + s1;
    {    Reg := TRegistry.Create;
        try
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          if Reg.OpenKey('\SOFTWARE\ORACLE\HOME0', True) then
          begin
            if reg.ReadString('NLS_LANG') = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' then}
//              Result := IntToStr(d) + '-' + CShortMonthNames[m] + '-' + s1
//            else
    Result := IntToStr(d) + '-' + EnShortMonthNames[m] + '-' + s1;
    {        Reg.CloseKey;
          end;
        finally
          reg.free;
        end;}
  end
  else
  begin
    Result := DateToStr(ADate);
  end;
end;
*)

procedure TCnsDBTable.SetParamAsString(AParamName, AValue: AnsiString);
var
  P1: TParam;
begin
  p1 := FParams.FindParam(AParamName);
  if not assigned(p1) then
    p1 := FParams.CreateParam(ftString, AParamName, ptInput);
  p1.AsString := AValue;
end;

procedure TCnsDBTable.SetParamAsDatetime(AParamName: AnsiString; AValue: TDatetime);
var
  P1: TParam;
begin
  p1 := FParams.FindParam(AParamName);
  if not assigned(p1) then
    p1 := FParams.CreateParam(ftDatetime, AParamName, ptInput);
  p1.AsDateTime := AValue
end;

procedure TCnsDBTable.SetParamAsInteger(AParamName: AnsiString; AValue: Integer);
var
  P1: TParam;
begin
  p1 := FParams.FindParam(AParamName);
  if not assigned(p1) then
    p1 := FParams.CreateParam(ftInteger, AParamName, ptInput);
  p1.AsInteger := AValue;
end;

procedure TCnsDBTable.SetParamAsFloat(AParamName: AnsiString; AValue: Double);
var
  P1: TParam;
begin
  p1 := FParams.FindParam(AParamName);
  if not assigned(p1) then
    p1 := FParams.CreateParam(ftFloat, AParamName, ptInput);
  p1.AsFloat := AValue;
end;

procedure TCnsDBTable.SetParamAsMemo(AParamName, AValue: AnsiString);
var
  P1: TParam;
begin
  p1 := FParams.FindParam(AParamName);
  if not assigned(p1) then
    p1 := FParams.CreateParam(ftMemo, AParamName, ptInput);
  p1.AsMemo := AValue;
end;

function TCnsDBTable.GetDetailDatasetByIndex(AIndex: Integer): TCnsDBTable;
begin
  if AIndex >= FDetailDatasetList.Count then
    raise Exception.Create(V_CAN_NOT_FIND_DETAIL_DATASET);
  Result := TCnsDBTable(FDetailDatasetList[AIndex]);
end;

function TCnsDBTable.GetDetailDataset(AIndex: AnsiString): TCnsDBTable;
var
  i: integer;
begin
  for i := 0 to FDetailDatasetList.Count - 1 do
  begin
    Result := TCnsDBTable(FDetailDatasetList[i]);
    if Result.ObjectName = AIndex then
      exit
    else
  end;
  Result := nil;
end;

function TCnsDBTable.GetDetailDatasetCount: Integer;
begin
  //  OpenDetailTable;
  Result := FDetailDatasetList.Count;
end;

function ResampleForPrint(DicomPrintDPI: Integer; bm: TBitmap; d1: TDicomImage): TBitmap;
var
  tmpbmp2: TBitmap;
begin
  case DicomPrintDPI of
    50:
      begin
        tmpbmp2 := TBitmap.Create;
        tmpbmp2.PixelFormat := bm.pixelformat;
        tmpbmp2.width := bm.Width div 2;
        tmpbmp2.height := bm.Height div 2;
        //            _QuickResample(tmpbmp1,tmpbmp2,fZoomFilter,nil,nil);
//        _Resample(bm, tmpbmp2, rfBell);
        bm.Free;
        Result := tmpbmp2;
        d1.CurrentDicomPrintDPI := 1;
      end;
    200:
      begin
        tmpbmp2 := TBitmap.Create;
        tmpbmp2.PixelFormat := bm.pixelformat;
        tmpbmp2.width := bm.Width * 2;
        tmpbmp2.height := bm.Height * 2;
        //            _QuickResample(tmpbmp1,tmpbmp2,fZoomFilter,nil,nil);
//        _Resample(bm, tmpbmp2, rfBell);
        bm.Free;
        Result := tmpbmp2;
        d1.CurrentDicomPrintDPI := 2;
      end;
    300:
      begin
        tmpbmp2 := TBitmap.Create;
        tmpbmp2.PixelFormat := bm.pixelformat;
        tmpbmp2.width := bm.Width * 3;
        tmpbmp2.height := bm.Height * 3;
        //            _QuickResample(tmpbmp1,tmpbmp2,fZoomFilter,nil,nil);
//        _Resample(bm, tmpbmp2, rfBell);
        bm.Free;
        Result := tmpbmp2;
        d1.CurrentDicomPrintDPI := 3;
      end;
    400:
      begin
        tmpbmp2 := TBitmap.Create;
        tmpbmp2.PixelFormat := bm.pixelformat;
        tmpbmp2.width := bm.Width * 4;
        tmpbmp2.height := bm.Height * 4;
        //            _QuickResample(tmpbmp1,tmpbmp2,fZoomFilter,nil,nil);
//        _Resample(bm, tmpbmp2, rfBell);
        bm.Free;
        Result := tmpbmp2;
        d1.CurrentDicomPrintDPI := 4;
      end;
  else
    Result := bm;
  end;

end;

function ResampleImage(AId: integer; bm: TBitmap): TBitmap;
var
  tmpbmp2: TBitmap;
begin
  tmpbmp2 := TBitmap.Create;
  tmpbmp2.PixelFormat := bm.pixelformat;
  tmpbmp2.width := bm.Width * AId;
  tmpbmp2.height := bm.Height * AId;
  //            _QuickResample(tmpbmp1,tmpbmp2,fZoomFilter,nil,nil);
//  _Resample(bm, tmpbmp2, rfBell);
  bm.Free;
  Result := tmpbmp2;
end;

procedure TCnsDMTable.SetStudyuIDEx(Value: AnsiString);
begin
  FStudyUID := Value;
end;

procedure TCnsDMTable.SetStudyuID(Value: AnsiString);
begin
  if FStudyUID <> Value then
  begin
    Clear;
    FStudyUID := Value;
    if (FStudyUID <> '') then
    begin
      RefreshTable;
    end
    else
      Clear;
  end;
end;

procedure TCnsDMTable.RefreshTable;
  function CheckLocalIsLast(StudyUID: AnsiString): Boolean;
  var
    d1: TCnsDBTable;
    k: Integer;
  begin
    Result := false;
    d1 := TCnsDBTable.Create(nil);
    d1.AppSrvClient := FAppSrvClient;
    d1.ObjectName := 'ͼ������';
    d1.WhereSQL := 'STUDYUID=''' + StudyUID + '''';
    d1.RefreshTable;
    d1.First;
    k := d1.RecordCount;
    if k = FLocalImagesTable.RecordCount then
    begin
      while not d1.Eof do
      begin
        if FLocalImagesTable.Locate('INSTANCEUID', d1.FieldByName('INSTANCEUID').AsString, []) then
        begin
          if FLocalImagesTable.FieldByName('LAST_UPDATE_TIME').AsDateTime
            >= d1.FieldByName('LAST_UPDATE_TIME').AsDateTime then
          begin
            k := k - 1;
          end;
        end
        else
          exit;
        d1.Next;
      end;
      Result := k <= 0;
    end;
  end;
var
  das1: TDicomAttributes;
  das2: TDicomAttributes;
  da1: TDicomAttribute;
  fin1: TAssociateFilePdu;
  i, k: Integer;
  stm1: TStream;
  das: TDicomDataset;
  str1: AnsiString;
begin
  if (assigned(FAppSrvClient)) then
  begin
    if fUse_CGET_To_LoadImage then
    begin
      DoLoadImages_C_GET(FStudyUID);
      //        LoadSelectedImagesToServer;
              //  LoadDcmFileDirEx(self.LocaleImagePath + '\' + FStudyUID);
      SortDatasets(dsbImageNumber);
    end
    else
    begin
      if FUseLocalCache and CheckLocalImageCache(FLocalCacheDirectory, FStudyUID) and
        CheckLocalIsLast(FStudyUID) then
      begin
        //���뱾��ͼ���ļ�
        FLocalImagesTable.First;
        while not FLocalImagesTable.Eof do
        begin
          stm1 := LoadLocalDicomImage(FLocalCacheDirectory);
          if assigned(stm1) then
          begin
            das := TDicomDataset.Create;
            stm1.Position := 0;
            das.LoadFromStream(stm1, true);
            das.SetStreamAndFileName(stm1, '', false);

            das.UserModify := FLocalImagesTable.FieldByName('TOBESAVE').AsInteger <> 0;

            AddDicomDataset(das);
            AddTopoDataset(das, (inherited getCount), das.Attributes.GetString(8, $60) = 'CT');
            //              stm1.Free;
          end;
          FLocalImagesTable.Next;
        end;
      end
      else
      begin

        das1 := TDicomAttributes.Create;
        da1 := das1.Add($2813, $0111);
        das2 := TDicomAttributes.Create;
        with das2 do
        begin
          AddVariant(78, 'STUDY');
          AddVariant(dStudyInstanceUID, FStudyUID);
          AddVariant($2809, $0045, FSpecifyLoadImageParam);
          //            if FUseLocalCache then
          //              AddVariant($2809, $001B, 1);
        end;
        da1.AddData(das2);

        fin1 := TAssociateFilePdu.Create;
        try
          fin1.Command := das1;
          TCnsDicomConnection(FAppSrvClient).SendFilePduRequest(fin1);
          //            fin1.write(TCnsDicomConnection(FAppSrvClient).Association.Stream);
        finally
          fin1.free;
        end;
        k := TCnsDicomConnection(FAppSrvClient).Association.ReadPduType;
        if k = $44 then
        begin
          fin1 := TAssociateFilePdu.Create;
          try
            fin1.readCommand(TCnsDicomConnection(FAppSrvClient).Association.Stream, k);
            if (fin1.ReceiveCount > 0) and (assigned(fin1.Command)) then
            begin
              da1 := fin1.Command.Item[$2813, $0111]; //���ղ�����ͼ��
              if assigned(da1) and (da1.GetCount > 0) then
              begin
                for i := 0 to da1.GetCount - 1 do
                begin
                  das1 := da1.Attributes[i];
                  if das1.Count > 0 then
                  begin
                    //������Ҫ��Ŀ¼������һЩ���ݵ����ݿ���
                    str1 := '';
                    if FUseLocalCache then
                      stm1 := SaveLocalDicomImage(FLocalCacheDirectory, das1)
                    else
                    begin
                      inc(CurrentTempImageIndex); //InterlockedIncrement
                      str1 := Format('%sDCMTEMP\T$%d_%d.DCM', [DicomTempPath,
                        CurrentTempImageIndex, Random(100000)]);
                      stm1 := TFileStream.Create(str1, fmCreate);
                    end;
                    //���ղ������ļ�
                    fin1.readData(TCnsDicomConnection(FAppSrvClient).Association.Stream, stm1);
                    TCnsDicomConnection(FAppSrvClient).FAssociation.Stream.WriteInt32(1);
                    TCnsDicomConnection(FAppSrvClient).Association.Stream.FreshData;

                    das := TDicomDataset.Create;
                    stm1.Position := 0;
                    das.LoadFromStream(stm1, TRUE);
                    das.SetStreamAndFileName(stm1, str1, true);

                    AddDicomDataset(das);

                    das.Attributes.DoAfterLoad(das1);

                    AddTopoDataset(das, (inherited getCount), das.Attributes.GetString(8, $60) =
                      'CT');
                  end;
                end;
                if FUseLocalCache then
                begin
                  FLocalStudiesTable.ApplyUpdates;
                  FLocalImagesTable.ApplyUpdates;
                end;
              end;
            end;
          finally
            fin1.free;
          end;
        end;
      end;
      SortDatasets(dsbImageNumber);
    end;
  end;
end;

function TCnsDMTable.GetSelectedForPrint(AIndex: Integer): TDicomAttributes;
begin
  if (FPrintList.Count <= 0) or (AIndex > FPrintList.Count) or (AIndex < 0) then
    Result := inherited GetSelectedForPrint(AIndex)
  else
  begin
    Result := TImagesSelectedToPrint(FPrintList[AIndex]).FAttributes;
  end;
end;

procedure TCnsDMTable.SetPName(Value: AnsiString);
begin
  FPName := Value;

  {$IFDEF NEED_HTMLVIEW_FORM}
  if Value <> '' then
    for i := 0 to Count - 1 do
    begin
      str1 := item[i].Attributes.GetString($10, $10);
      if str1 <> Value then
        item[i].Attributes.AddVariant($10, $10, Value + ' ' + str1);
    end;
  {$ENDIF}
end;

procedure TCnsDMTable.SetAppSrvClient(Value: TCnsCustomDicomConnection);
begin
  FAppSrvClient := Value;
  FSelectedDataset.AppSrvClient := Value;
end;

procedure TCnsDMTable.AddSelectedImage(Index: Integer);
var
  v1, v2: TImagesSelectedToPrint;
  das: TDicomAttributes;
  i, k: Integer;
  str1: AnsiString;
begin
  das := Item[Index].Attributes;
  if assigned(das) then
  begin
    str1 := das.GetString($8, $18);
    k := das.ImageData.FrameIndex;
    //    v1 := nil;
    for i := 0 to FPrintList.Count - 1 do
    begin
      v2 := TImagesSelectedToPrint(FPrintList[i]);
      if (v2.FInstanceUID = str1) and (v2.FFrameIndex = k) then
      begin
        Exit;
      end;
    end;
    v1 := TImagesSelectedToPrint.Create;
    v1.FInstanceUID := str1;
    v1.WindowCenter := das.ImageData.WindowCenter;
    v1.WindowWidth := das.ImageData.WindowWidth;
    v1.FFrameIndex := k;
    v1.FAttributes := das;
    DCM_ImageData_Bitmap.AssignToBitmap(das.ImageData, v1.Fbitmap, false);
    FPrintList.Add(v1);
  end;
end;

procedure TCnsDMTable.RemoveSelectedImage(Index: Integer);
var
  v2: TImagesSelectedToPrint;
  das: TDicomAttributes;
  i, k: Integer;
  str1: AnsiString;
begin
  das := Item[Index].Attributes;
  if assigned(das) then
  begin
    str1 := das.GetString($8, $18);
    k := das.ImageData.FrameIndex;
    //    v1 := nil;
    for i := 0 to FPrintList.Count - 1 do
    begin
      v2 := TImagesSelectedToPrint(FPrintList[i]);
      if (v2.FInstanceUID = str1) and (v2.FFrameIndex = k) then
      begin
        FPrintList.Delete(i);
        v2.Free;
        exit;
      end;
    end;
  end;
end;

function TCnsDMTable.GetSelectedCountForPrint: integer;
begin
  Result := FPrintList.Count;
  if Result <= 0 then
    Result := inherited GetSelectedCountForPrint;
end;

procedure TCnsDMTable.PrintImage(ACanvas: TCanvas; rc: TRect; AIndex: Integer; AIsSelected:
  Boolean);
var
  b1, b2: Double;
  v1: TImagesSelectedToPrint;
  h, r: Integer;
begin
  if FPrintList.Count <= 0 then
    inherited PrintImage(ACanvas, rc, AIndex, AIsSelected)
  else
  begin
    v1 := TImagesSelectedToPrint(FPrintList[AIndex]);
    b1 := v1.Fbitmap.Height / v1.Fbitmap.Width;

    rc.Right := rc.Right - 2;
    rc.Bottom := rc.Bottom - 2;
    b2 := (rc.Bottom - rc.Top) / (rc.Right - rc.Left);

    if (b1 < b2) then
    begin
      h := Round((((rc.Right - rc.Left) * b1) + rc.Top));
      printBitmapEx(ACanvas, Rect(rc.Left, rc.Top, rc.Right, h), v1.Fbitmap);
    end
    else
      if (b1 > b2) then
    begin
      r := Round((((rc.Bottom - rc.Top) / b1) + rc.Left));
      printBitmapEx(ACanvas, Rect(rc.Left, rc.Top, r, rc.Bottom), v1.Fbitmap);
    end
    else
      printBitmapEx(ACanvas, Rect(rc.Left, rc.Top, rc.Right, rc.Bottom), v1.Fbitmap);
  end;
end;

procedure TCnsDMTable.SaveSelectedImagesToServer;
var
  v1: TImagesSelectedToPrint;
  i: Integer;
begin
  if FSelectedDataset.Active then
  begin
    FSelectedDataset.EmptyTable;
    for i := 0 to FPrintList.Count - 1 do
    begin
      v1 := TImagesSelectedToPrint(FPrintList[i]);
      if not FSelectedDataset.Locate('INSTANCEUID;FRAMEINDEX', VarArrayOf([v1.FInstanceUID,
        v1.FFrameIndex]), []) then
      begin
        FSelectedDataset.Insert;
        FSelectedDataset.FieldByName('STUDYUID').AsString := FStudyUID;
        FSelectedDataset.FieldByName('INSTANCEUID').AsString := v1.FInstanceUID;
        FSelectedDataset.FieldByName('WINDOW_CENTER').AsInteger := v1.WindowCenter;
        FSelectedDataset.FieldByName('WINDOW_WIDTH').AsInteger := v1.WindowWidth;
        FSelectedDataset.FieldByName('FRAMEINDEX').AsInteger := v1.FFrameIndex;
        FSelectedDataset.Post;
      end
      else
      begin
        FSelectedDataset.Edit;
        FSelectedDataset.FieldByName('WINDOW_CENTER').AsInteger := v1.WindowCenter;
        FSelectedDataset.FieldByName('WINDOW_WIDTH').AsInteger := v1.WindowWidth;
        FSelectedDataset.Post;
      end;
    end;
    FSelectedDataset.ApplyUpdates;
  end;
end;

procedure TCnsDMTable.LoadSelectedImagesToPrint;
  function GetAttributes(AUID: AnsiString): TDicomAttributes;
  var
    i: integer;
    d1: TDicomDataset;
  begin
    Result := nil;
    for i := 0 to self.Count - 1 do
    begin
      d1 := Item[i];
      if d1.Attributes.GetString($8, $18) = AUID then
      begin
        Result := d1.Attributes;
        exit;
      end;
    end;
  end;
var
  v1: TImagesSelectedToPrint;
  das: TDicomAttributes;
begin
  if assigned(FAppSrvClient) and (FStudyUID <> '') then
  begin
    FSelectedDataset.WhereSQL := Format('STUDYUID =''%s''', [FStudyUID]);
    FSelectedDataset.RefreshTable;
    if FSelectedDataset.Active then
    begin
      ClearSelectedImages;
      FSelectedDataset.First;
      while not FSelectedDataset.Eof do
      begin
        v1 := TImagesSelectedToPrint.Create;
        v1.FInstanceUID := FSelectedDataset.FieldByName('INSTANCEUID').AsString;
        v1.WindowCenter := FSelectedDataset.FieldByName('WINDOW_CENTER').AsInteger;
        v1.WindowWidth := FSelectedDataset.FieldByName('WINDOW_WIDTH').AsInteger;
        v1.FFrameIndex := FSelectedDataset.FieldByName('FRAMEINDEX').AsInteger;
        das := GetAttributes(v1.FInstanceUID);
        v1.FAttributes := das;
        if assigned(das) then
        begin
          das.ImageData.FrameIndex := v1.FFrameIndex;
          DCM_ImageData_Bitmap.AssignToBitmap(das.ImageData, v1.Fbitmap);
        end;
        FPrintList.Add(v1);

        FSelectedDataset.Next;
      end;
    end;
  end;
end;

constructor TCnsDMTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //  RelateData := nil;
  fData1 := nil;
  fData2 := nil;

  FLocalCacheDirectory := '';
  FUseLocalCache := false;

  fUse_CGET_To_LoadImage := false;
  FSpecifyLoadImageParam := '';

  FAppSrvClient := nil;
  FStudyUID := '';
  FFetchCount := 0;
  //  FLoadMode := lmServerMode;
  //  FLocaleImagePath := '';
  FCurrentindex := 0;
  FPrintList := TList.Create;
  FSelectedDataset := TCnsDBTable.Create(self);
  FSelectedDataset.ObjectName := 'SelectedImages';

end;

destructor TCnsDMTable.Destroy;
begin
  FSelectedDataset.Free;
  ClearSelectedImages;
  FPrintList.Free;
  inherited;
end;

procedure TCnsDMTable.ClearSelectedImages;
var
  i: integer;
begin
  for i := 0 to FPrintList.Count - 1 do
    TImagesSelectedToPrint(FPrintList[i]).Free;
  FPrintList.Clear;
end;

procedure TCnsDMTable.ScanSelectedImagesToPrint;
var
  i: integer;
begin
  for i := 0 to GetCount - 1 do
    if Item[i].Attributes.MultiSelected2 then
      AddSelectedImage(i);
end;

procedure TCnsDMTable.DoLoadImages_C_GET(StudyUID: AnsiString);
var
  da1: TDicomAttributes;
  das: TDicomDataset;
  i: Integer;
begin
  if not assigned(FAppSrvClient) then
    exit;
  FCurrentindex := 0;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant(78, 'STUDY');
    AddVariant(dStudyInstanceUID, StudyUID); //'1.3.12.2.1107.5.1.1.14713.20000228085333717.2');
  end;
  if FAppSrvClient.C_GET(da1) then
  begin
    for i := 0 to FAppSrvClient.ReceiveDatasets.Count - 1 do
    begin
      das := NewDicomDataset(TDicomAttributes(FAppSrvClient.ReceiveDatasets[i]));
    end;
    FAppSrvClient.ReceiveDatasets.Clear;
  end;
end;

procedure TCnsDMTable.DoLoadImages_C_MOVE(StudyUID: AnsiString);
var
  da1: TDicomAttributes;
  das: TDicomDataset;
  i: Integer;
  {$IFDEF DICOMDEBUG}
  iii: integer;
  {$ENDIF}
begin
  if not assigned(FAppSrvClient) then
    exit;
  FCurrentindex := 0;
  {$IFDEF DICOMDEBUG}
  iii := getTickCount;
  {$ENDIF}
  //  s1 := Screen.Cursor;
  //  Screen.Cursor := crSQLWait;
  try
    da1 := TDicomAttributes.Create;
    with da1 do
    begin
      Add($0008, $0020); //(StudyDate)DA=<0>NULL
      Add($0008, $0030); //(StudyTime)TM=<0>NULL
      Add($0008, $0050); //(AccessionNumber)SH=<0>NULL
      //Add($0008,$0052);//(QueryRetrieveLevel)CS=<1>STUDY
      Add($0008, $0090); //(ReferringPhysiciansName)PN=<0>NULL
      Add($0008, $1030); //(StudyDescription)LO=<0>NULL
      Add($0010, $0010); //(PatientName)PN=<0>NULL
      Add($0010, $0020); //(PatientID)LO=<0>NULL
      Add($0010, $0030); //(PatientBirthDate)DA=<0>NULL
      Add($0010, $0040); //(PatientSex)CS=<0>NULL
      //Add($0020,$000D);//(StudyInstanceUID)UI=<1>1.3.12.2.1107.5.1.1.21044.20040906094229886.2
      Add($0020, $0010); //(StudyID)SH=<0>NULL

      AddVariant(78, 'STUDY');
      AddVariant(dStudyInstanceUID, StudyUID);
    end;
    if FAppSrvClient.C_MOVE(da1) then
    begin
      for i := 0 to FAppSrvClient.ReceiveDatasets.Count - 1 do
      begin
        das := NewDicomDataset(TDicomAttributes(FAppSrvClient.ReceiveDatasets[i]));
      end;
      FAppSrvClient.ReceiveDatasets.Clear;
    end;
  finally
    //    Screen.Cursor := s1;
    {$IFDEF DICOMDEBUG}
    iii := getTickCount - iii;
    if self.Count > 0 then
      SendDebug(Format('Load time:%d,Image Count %d,av %d', [iii, self.Count, iii div
        self.Count]));
    {$ENDIF}
  end
end;

procedure TCnsDMTable.OnAcquire(const DibHandle: THandle; const XDpi: Word;
  const YDpi: Word; const CallBackData: LongInt);
var
  Graphic: TDibGraphic;
  bm: TBitmap;
  da1: TDicomAttributes;
  das: TDicomDataset;
  i: Integer;
begin
  Graphic := TDibGraphic.Create;
  try
    Graphic.AssignFromDIBHandle(DibHandle);
    Graphic.XDotsPerInch := XDpi;
    Graphic.YDotsPerInch := YDpi;
    bm := TBitmap.Create;
    bm.Assign(Graphic);
    try
      da1 := NewImage(bm, false);
    finally
      bm.Free;
    end;
    das := TDicomDataset.Create(da1);
    i := 1;
    DoOnNewImage(self, das, i);

    AddDicomDataset(das);
  finally
    Graphic.Free;
  end;
end;

procedure TCnsDMTable.ScanImage(AIndex: Integer; IsShowUI: Boolean);
var
  i: integer;
  Reg: TIniFile;
  //Scanner1: TScanner;
begin
  //Scanner1 := TScanner.Create;
  try

    if not Scanner.IsConfigured then
    begin
      ShowMessage(V_NO_SCANER_ERROR);
      Exit;
    end;
    Scanner.ShowUI := IsShowUI;
    if AIndex < 0 then
    begin
      Reg := TIniFile.Create('CnsPacsScan.INI');
      try
        i := Reg.ReadInteger('Scaner', 'ScanIndex', -1);
        if i >= 0 then
          Scanner.ScannerIndex := i
        else
        begin
          Scanner.SelectScanner;
          if Scanner.ScannerIndex >= 0 then
            Reg.WriteInteger('Scaner', 'ScanIndex', Scanner.ScannerIndex);
        end;
      finally
        reg.free;
      end;
    end
    else
      Scanner.ScannerIndex := AIndex;
    Scanner.Acquire(OnAcquire, 0);

    Scanner.CloseSource;
  finally
    // Scanner1.Free;
  end;
end;

function TCnsDMTable.LoadImages1(AProfileName, AStudyUID: AnsiString; AStrs: TStrings): Boolean;
var
  da1: TDicomAttributes;
  //  strs1: TStringList;
begin
  Result := false;
  if assigned(FAppSrvClient) then
    exit;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'IMGFILE');
    AddVariant($20, $D, AStudyUID);
  end;

  if FAppSrvClient.C_Database(da1) then
  begin
    if FAppSrvClient.ReceiveDatasets.Count > 0 then
    begin
      da1 := FAppSrvClient.ReceiveDatasets[0];
      //      FAssociation.ReceiveDatasets.Clear;
      Result := da1.GetInteger($2809, $1004) = 1;
      if Result then
      begin
        // da1.ListAttrinute('', astrs);
      end
      else
      begin
        ShowMessage(da1.GetString($2809, $1003));
      end;
    end;
    //    DisconnectEx;
  end;
  FAppSrvClient.Clear;
end;

function TCnsDMTable.DoOnNewImage(Sender: TObject; ADataset: TDicomDataset; AImageIndex: integer):
  Boolean;
begin
  Result := true;
  if assigned(FOnNewImage) then
  begin
    FOnNewImage(Sender, ADataset, AImageIndex);
  end
  else
    Result := false;
end;

procedure TCnsDMTable.DoOnNewImage1(Sender: TObject; ADataset: TDicomDataset; AImageIndex:
  integer);
begin
  if assigned(FOnNewImage) then
  begin
    FOnNewImage(Sender, ADataset, AImageIndex);
  end
end;

{function TCnsDMTable.TestDcmFileDir(ASTUDYUID: AnsiString; var AImageDir: AnsiString): Boolean;
var
  str1: AnsiString;
  ADir: AnsiString;
begin
  AImageDir := '';
  ADir := LocaleImagePath;
  Result := ADir <> '';
  if not Result then
    exit;
  Result := false;
  if ADir[Length(ADir)] <> '\' then
    adir := adir + '\';
  str1 := adir + ASTUDYUID + '\';
  if DirectoryExists(str1) then
  begin
    AImageDir := str1;
    Result := true;
  end
end;}

function TCnsDMTable.LoadDcmFileDir(AImagePath: AnsiString): Boolean;
  function HaveTheimage(Das: TDicomDataset): Boolean;
  var
    i: integer;
    d1: TDicomDataset;
    str1, str2: AnsiString;
  begin
    Result := true;
    for i := 0 to Count - 1 do
    begin
      d1 := item[i];
      str1 := d1.Attributes.GetString(8, $18);
      str2 := das.Attributes.GetString(8, $18);
      if str1 = str2 then
      begin
        Result := false;
        exit;
      end;
    end;
  end;
var
  strx2, strx3, strx4: AnsiString;
  sr3: TSearchRec;
  das1: TDicomDataset;
  {$IFDEF FOR_TENFENG_MR}
  str2, str3: AnsiString;
  k: integer;
  {$ENDIF}
begin
  self.Clear;
  FStudyUID := '';

  strx2 := AImagePath;
  if strx2[Length(Strx2)] <> '\' then
    strx2 := strx2 + '\';
  {  if FindFirst(strx2 + '\*.*', faDirectory, sr2) = 0 then
    begin
      repeat
        if (sr2.Attr and faDirectory) = faDirectory then
        begin
          if (sr2.Name = '.') or (sr2.name = '..') then
            continue;
         }
  strx3 := strx2; //'\' + sr2.Name;
  if FindFirst(strx3 + '*.dcm', faAnyFile, sr3) = 0 then
  begin
    repeat
      //if (sr3.Attr and faAnyFile) = sr3.Attr then
      begin
        strx4 := strx3 + sr3.Name;
        das1 := TDicomDataset.Create;
        das1.LoadFromFile(strx4);

        das1.UserModify := false;

        if HaveTheimage(das1) then
        begin
          AddDicomDataset(das1);
          //AddTopoDataset(das1, (inherited getCount), das1.Attributes.GetString(8, $60) = 'CT');
        end
        else
          das1.Free;
      end;
    until FindNext(sr3) <> 0;
    FindClose(sr3);
    //        end;
    //      end;
    //    until FindNext(sr2) <> 0;
    //    FindClose(sr2);
  end;
  Result := true;
end;

procedure TCnsDMTable.ScanOldVRTextToDesc;
var
  i, k, z: integer;
  A1, a2: TDicomAttributes;
  d1: TDicomAttribute;
begin
  for i := 0 to GetCount - 1 do
  begin
    a1 := Item[i].Attributes;
    d1 := A1.Item[$2815, $0001];
    if (assigned(d1)) and (d1.GetCount > 0) and (a1.GetString($18, $15) = '') and (a1.GetString($8,
      $103E) = '') then
    begin
      z := 0;
      for k := 0 to d1.GetCount - 1 do
      begin
        a2 := d1.Attributes[k];
        if (a2.Getinteger($2815, $A) = 4) then
        begin
          if z = 0 then
            a1.AddVariant($18, $15, a2.GetString($2815, $9))
          else
            a1.AddVariant($8, $103E, a2.GetString($2815, $9));
          inc(z);
        end;
      end;
    end
  end;
end;

function TCnsDMTable.LoadDcmFileDirEx(AImagePath: AnsiString): Boolean;
var
  SL: TStringList;
  FScanFolder: TcbShellFolder;
  das1: TDicomDataset;
  function HaveTheimage(Das: TDicomDataset): Boolean;
  var
    i: integer;
    d1: TDicomDataset;
    str1, str2: AnsiString;
  begin
    Result := true;
    for i := 0 to Count - 1 do
    begin
      d1 := Item[i];
      str1 := d1.Attributes.GetString(8, $18);
      str2 := das.Attributes.GetString(8, $18);
      if str1 = str2 then
      begin
        Result := false;
        exit;
      end;
    end;
  end;
  procedure AddFolderToDataset(AFolder: TcbShellFolder);
  var
    str1: AnsiString;

    i: Integer;
  begin
    for i := 0 to AFolder.FileCount - 1 do
    begin
      str1 := AFolder.FullPath + '\' + AFolder.Files[i];
      if FileExists(str1) then
      begin
        das1 := TDicomDataset.Create;
        das1.LoadFromFile(str1, true);

        das1.UserModify := false;
        //        if HaveTheimage(das1) then
        AddDicomDataset(das1);

        //AddTopoDataset(das1, (inherited getCount), das1.Attributes.GetString(8, $60) = 'CT');
        //        else
        //          das1.Free;
      end;
    end;
    for i := 0 to AFolder.FolderCount - 1 do
    begin
      AddFolderToDataset(AFolder.Folders[i]);
    end;
  end;
begin
  self.Clear;
  FStudyUID := '';
  if DirectoryExists(AImagePath) then
  begin
    FScanFolder := TcbShellFolder.Create(nil, AImagePath);
    SL := TStringList.Create;
    try
      SL.Add('.dcm');
      SL.Add('.cti');
      SL.Add('.cts');
      FScanFolder.Enumerate(4, SL);
      AddFolderToDataset(FScanFolder);
    finally
      SL.Free;
      FreeAndNil(FScanFolder);
    end;
  end;
  Result := true;
end;

procedure TCnsDMTable.CaptureImage(AIndex: Integer; IsShowUI: Boolean);
begin
  {$IFDEF NEED_DIRECTX_CAPTURE}
  if fCaptureForm = nil then
  begin
    fCaptureForm := TCaptureVideoForm.Create(self);
    //initial the video
    TCaptureVideoForm(fCaptureForm).CaptureView.DicomDatasets := self;
  end;

  TCaptureVideoForm(fCaptureForm).fImageIndex := AIndex;

  TCaptureVideoForm(fCaptureForm).OnCaptureNewImage := DoOnNewImage1;
  fCaptureForm.ShowModal;
  {$ENDIF}
  fCaptureForm := nil;
end;

procedure TCnsDMTable.ParseImage(x1, y1, x2, y2: Integer);
var
  d1: TDicomAttributes;
  //  dd: TDicomAttribute;
  ds1: TDicomDataset;
  bm, bm1: TBitmap;
begin
  bm := TBitmap.Create;
  try
    if not _PasteFromClipboard(bm) then
      exit;
    if (x2 <> X1) and (y2 <> Y1) then
    begin
      bm1 := TBitmap.Create;
      try
        _KxCopyBitmapPoly(bm, bm1, x1, y1, x2, y2);
        d1 := NewImage(bm1, false);
      finally
        bm1.free;
      end;
    end
    else
      d1 := NewImage(bm, false);
  finally
    bm.Free;
  end;
  if assigned(d1) then
  begin
    ds1 := NewDicomDataset(d1);
    //AddDicomDataset(ds1);
  end;
end;

{
procedure TCnsDMTable.EditImage;
begin

end;
}

function TCnsDMTable.LoadFromDicomdir(AimagePath: AnsiString): Boolean;
{ procedure LoadImageToList(ADas: TDicomAttributes);
 var
   das: TDicomDataset;
   filename1: AnsiString;
 begin
   filename1 := GetFileName(ExtractFilePath(AimagePath), adas); //.Item[4, $1500].AsString[0];
   if FileExists(filename1) then
     das := TDicomDataset.Create
   else
     exit;
   das.LoadFromFile(filename1, true);
   das.UserModify := false;
   Add(das);
   AddTopoDataset(das, (inherited getCount), das.Attributes.GetString(8, $60) = 'CT');
 end; }
//var
  //  Node1, Node2, Node3: TTreeNode;
 // Reg: TRegistry;

begin
  Result := false;
  {  with TLoadDICOMDIRForm.Create(nil) do
    try
      if AimagePath <> '' then
        OpenDicomDir(AimagePath)
      else
      begin
        Reg := TRegistry.Create;
        try
          Reg.OpenKey('\SOFTWARE\CNS\DICOMDIR', true);
          OpenDialog1.InitialDir := Reg.ReadString('LastDirectory');
          if OpenDialog1.Execute then
          begin
            OpenDicomDir(OpenDialog1.FileName);
            Reg.WriteString('LastDirectory', ExtractFilePath(OpenDialog1.FileName));
          end
          else
            exit;
        finally
          Reg.CloseKey;
          Reg.Free;
        end;
      end;
      if ShowModal = mrok then
      begin
        self.Clear;
        FStudyUID := '';
        if assigned(TreeView1.Selected) then
        begin
          case TreeView1.Selected.Level of //
            0:
              begin
                Node3 := TreeView1.Selected.getFirstChild;
                while Node3 <> nil do
                begin
                  Node2 := Node3.getFirstChild;
                  while Node2 <> nil do
                  begin
                    Node1 := Node2.getFirstChild;
                    while Node1 <> nil do
                    begin
                      LoadImageToList(TDicomAttributes(Node1.Data));
                      Node1 := Node2.GetNextChild(Node1);
                    end;
                    Node2 := Node3.GetNextChild(Node2);
                  end;
                  Node3 := TreeView1.Selected.GetNextChild(Node3);
                end;
              end;
            1:
              begin
                Node2 := TreeView1.Selected.getFirstChild;
                while Node2 <> nil do
                begin

                  Node1 := Node2.getFirstChild;
                  while Node1 <> nil do
                  begin
                    LoadImageToList(TDicomAttributes(Node1.Data));
                    Node1 := Node2.GetNextChild(Node1);
                  end;

                  Node2 := TreeView1.Selected.GetNextChild(Node2);
                end;
              end;
            2:
              begin
                Node1 := TreeView1.Selected.getFirstChild;
                while Node1 <> nil do
                begin
                  LoadImageToList(TDicomAttributes(Node1.Data));
                  Node1 := TreeView1.Selected.GetNextChild(Node1);
                end;
              end;
            3:
              begin
                //              TopNode := TreeView1.Selected.Parent.Parent.Parent;
                LoadImageToList(TDicomAttributes(TreeView1.Selected.Data));
              end;
          end; // case
        end;
      end;
    finally
      Free;
    end;  }
end;
{
procedure TCnsDMTable.ImportFrom(AFileName: AnsiString);
begin

end;
}

procedure TCnsDMTable.SaveToDicomDir(AFileName: AnsiString; AOnlySaveKeyImage: Boolean);
begin
  SaveDicomDatasetsToDicomDir(self, AFilename, AOnlySaveKeyImage);
end;

procedure TCnsDMTable.SaveToHtml(ADirName: AnsiString; AOnlySaveKeyImage, AWithLabel: Boolean);
begin
  SaveDicomDatasetsAsHtml('', self, ADirName, AOnlySaveKeyImage, AWithLabel);
end;

function TCnsDMTable.ImportImage(AFileName: AnsiString): TDicomDataset;
begin
  Result := TDicomDataset.Create;
  ImportImageEx(Result.Attributes, AFileName);
  AddDicomDataset(Result);
end;

procedure TCnsDMTable.ImportImageEx(ADataset: TDicomAttributes; AFileName: AnsiString; AIsMono: Boolean
  = false);
const
  filterArray: array[0..11] of AnsiString = ('jpg', 'bmp', 'tif', 'tga', 'png',
    'pcx', 'ppm', 'gif', 'avi', 'mpg', 'jpeg', 'tiff');
  function GetFileType: Integer;
  var
    str1: AnsiString;
    i: integer;
  begin
    str1 := SysUtils.Lowercase(ExtractFileExt(AFileName));
    for i := 0 to 11 do
      if str1 = '.' + filterArray[i] then
      begin
        Result := i;
        exit;
      end;
    Result := -1;
  end;
  procedure NewAVIImage;
  var
    dimage: TDicomImageData;
    p1: Pointer;
    ALen: Integer;
//    List1: TList;
    i, x, y: Integer;
 //   bm1: TBitmap;
    avi1: TCnsAVIReader;
    da1: TDicomAttribute;
    bmp: TBitmap;
    //pb1: PByte;
    DestScanline: pRGBs;
    prgb1: pRGB;
    ProcessBarForm: TImportAVIProcessBarForm;
  begin
    avi1 := TCnsAVIReader.Create;
    try
      if avi1.Open(AFileName) >= 0 then
      begin
        ProcessBarForm := TImportAVIProcessBarForm.Create(nil);
        try
          ProcessBarForm.ProgressBar1.Position := 1;
          ProcessBarForm.ProgressBar1.Max := avi1.Ending - avi1.Start - 1;
          ProcessBarForm.Show;
          ProcessBarForm.Update;
          bmp := avi1.GetFrame(avi1.Start);

          ADataset.AddVariant(8, $16, '1.2.840.10008.5.1.4.1.1.7'); //sc

          ADataset.AddVariant(8, 8, 'ORIGINAL/PRIMARY//0001');
          //  Result.AddVariant(8, $60, AModility);
          //ADataset.AddVariant(8, $70, 'CNSSoft');

          ADataset.Add(8, $20).AsDatetime[0] := now;
          ADataset.Add(8, $21).AsDatetime[0] := now;
          ADataset.Add(8, $23).AsDatetime[0] := now;
          ADataset.Add(8, $30).AsDatetime[0] := now;
          ADataset.Add(8, $33).AsDatetime[0] := now;
          //  Result.AddVariant($20, $13, AImageIndex);
          ADataset.AddVariant($28, $11, bmp.Width);
          ADataset.AddVariant($28, $10, bmp.Height);

          //    if not AIsMONOCHROME then

          ALen := bmp.Width * bmp.Height * 3;

          ADataset.AddVariant($28, $8, avi1.Ending - avi1.Start - 1);
          ADataset.AddVariant($28, $2, 3);
          ADataset.AddVariant($28, $4, 'RGB');

          //ADataset.AddVariant($28, $2, 1);
          //ADataset.AddVariant($28, $4, 'MONOCHROME2');

          ADataset.AddVariant($28, $100, 8);
          ADataset.AddVariant($28, $101, 8);
          ADataset.AddVariant($28, $102, 8 - 1);

          da1 := ADataset.Add(32736, 16);

          GetMem(p1, alen);
          //Move(avi1.Punter^, p1^, ALen);
          prgb1 := p1;
          for y := 0 to bmp.Height - 1 do // Iterate
          begin
            DestScanline := bmp.ScanLine[y];
            for x := 0 to bmp.Width - 1 do
            begin
              prgb1^.b := DestScanLine^.b;
              prgb1^.g := DestScanLine^.g;
              prgb1^.r := DestScanLine^.r;

              inc(prgb1);
              inc(DestScanline);
            end;
          end; // for

          dimage := TDicomImageData.Create(ImplicitVRLittleEndian, p1, ALen);
          da1.AddData(dimage);

          for i := avi1.Start + 1 to avi1.Ending - 1 do
          begin
            bmp := avi1.GetFrame(i);
            if bmp <> nil then
            try
              GetMem(p1, alen);

              prgb1 := p1;
              for y := 0 to bmp.Height - 1 do // Iterate
              begin
                DestScanline := bmp.ScanLine[y];
                for x := 0 to bmp.Width - 1 do
                begin
                  prgb1^.b := DestScanLine^.b;
                  prgb1^.g := DestScanLine^.g;
                  prgb1^.r := DestScanLine^.r;

                  inc(prgb1);
                  inc(DestScanline);
                end;
              end; // for
              ProcessBarForm.ProgressBar1.Position := i;
              Application.ProcessMessages;
              dimage := TDicomImageData.Create(ImplicitVRLittleEndian, p1, ALen);
              da1.AddData(dimage);
              if ProcessBarForm.fAbort then
              begin
                if (MessageDlg('Are you want to abort Import', mtConfirmation, [mbYes, mbNo], 0) =
                  mrYes) then
                  break;
              end;
            finally
              bmp.free;
            end;
          end;
        finally
          ProcessBarForm.Free;
        end;
      end;
    finally
      avi1.Free;
    end;
  end;
  procedure NewTIFImage;
  var
    dimage: TDicomImageData;
    p1: Pointer;
    //    pb1: PByte;
    ALen: Integer;
    //    DestScanline: PColor32Array;
    //    prgb1: pRGB;
    f1: TTiffGraphic;
    List1: TList;
    i: Integer;
    bm1: TBitmap;
  begin
    list1 := TList.Create;
    f1 := TTiffGraphic.Create;
    f1.LoadFromFileEx(AFileName, list1);
    if list1.Count <= 0 then
    begin
      bm1 := TBitmap.Create;
      f1.AssignTo(bm1);
      NewImage(ADataset, bm1, AIsMono);
    end
    else
    begin

      //Result := TDicomAttributes.Create;
      //  Result.AddVariant(dPatientName, Patientname);
      //  Result.AddVariant(dPatientID, PatientID);

      //  Result.AddVariant(dStudyInstanceUID, StudyUID);
      //  Result.AddVariant(dSeriesInstanceUID, StudyUID + '.' + IntToStr(ASeriesIndex));
      //  Result.AddVariant(dSOPInstanceUID, StudyUID + '.' + IntToStr(ASeriesIndex) + '.' + IntToStr(AImageIndex + 1));

      ADataset.AddVariant(8, $16, '1.2.840.10008.5.1.4.1.1.7'); //sc
      //SOP CLASS
      //1.2.840.10008.5.1.4.1.1.2  CT
      //1.2.840.10008.5.1.4.1.1.7  secondary capture

      ADataset.AddVariant(8, 8, 'ORIGINAL/PRIMARY//0001');
      //  Result.AddVariant(8, $60, AModility);
      ADataset.AddVariant(8, $70, 'CNSSoft');

      ADataset.Add(8, $20).AsDatetime[0] := now;
      ADataset.Add(8, $21).AsDatetime[0] := now;
      ADataset.Add(8, $23).AsDatetime[0] := now;
      ADataset.Add(8, $30).AsDatetime[0] := now;
      ADataset.Add(8, $33).AsDatetime[0] := now;
      //  Result.AddVariant($20, $13, AImageIndex);
      ADataset.AddVariant($28, $11, f1.Width);
      ADataset.AddVariant($28, $10, f1.Height);
      //    if not AIsMONOCHROME then

      ADataset.AddVariant($28, $2, 1);
      ADataset.AddVariant($28, $4, 'MONOCHROME2');
      ALen := f1.Width * f1.Height;

      ADataset.AddVariant($28, $100, 16);
      ADataset.AddVariant($28, $101, 16);
      ADataset.AddVariant($28, $102, 15);
      for i := 0 to list1.Count - 1 do
      begin
        p1 := list1[i];
        dimage := TDicomImageData.Create(ImplicitVRLittleEndian, p1, ALen);
        ADataset.Add(32736, 16).AddData(dimage);
      end;
    end;
  end;
var
  //  i: integer;
  bm1: TBitmap;
  //  das1: TDicomAttributes;
    //d1: TDicomDataset;
begin
  ADataset.Clear;

  bm1 := TBitmap.Create;
  case GetFileType of
    0, 10: //jpeg
      begin
        with TJpegGraphic.Create do
        try
          LoadFromFile(AFilename);
          assignto(bm1);
        finally
          Free;
        end; //JPEG try..finally}
      end;
    1: //bmp
      begin
        bm1.LoadFromFile(AFilename);
      end;
    2, 11: //tif
      begin
        NewTIFImage;
        bm1.Free;
        exit;
        {with TTiffGraphic.Create do
        try
          LoadFromFile(AFilename);
          assignto(bm1);
        finally
          Free;
        end; }
      end;
    3: //tga
      begin
        with TTgaGraphic.Create do
        try
          LoadFromFile(AFilename);
          assignto(bm1);
        finally
          Free;
        end;
      end;
    4: //png
      begin
        with TPngGraphic.Create do
        try
          LoadFromFile(AFilename);
          assignto(bm1);
        finally
          Free;
        end;
      end;
    5: //pcx
      begin
        with TPcxGraphic.Create do
        try
          LoadFromFile(AFilename);
          assignto(bm1);
        finally
          Free;
        end;
      end;
    6: //ppm
      begin
        with TPpmGraphic.Create do
        try
          LoadFromFile(AFilename);
          assignto(bm1);
        finally
          Free;
        end;
      end;
    7: //gif
      begin

      end;
    8: //avi
      begin
        NewAVIImage;
        bm1.Free;
        exit;
      end;
    9: //mpg
      begin

      end;
  else
    begin
      bm1.Free;
      Exit;
    end;
  end;

  NewImage(ADataset, bm1, AIsMono);

  //Add(Result);
  bm1.Free;
end;

procedure TCnsDMTable.ExportImage(AIndex: Integer; AFileName: AnsiString; FilterIndex: Integer);
const
  QUANTCODE: array[0..7] of integer = (1, 2, 3, 4, 6, 8, 12, 16);
  filterarray: array[0..9] of AnsiString = ('jpg', 'bmp', 'tif', 'Tga', 'Png',
    'Pcx', 'Ppm', 'gif', 'mpg', 'avi');
  procedure SaveToMpeg(Afilename: AnsiString);
  var
    i, k: integer;
    fs: TFileStream;
    mpg: TMpeg;
    da1: TDicomAttributes;
    bm, bm1: TBitmap;

    f1: TConvert2MpegStatusForm;
  begin
    k := 32;
    f1 := TConvert2MpegStatusForm.Create(self);
    da1 := Item[AIndex].Attributes;
    mpg := TMpeg.Create;
    bm := TBitmap.Create;
    bm1 := TBitmap.Create;
    if (da1.ImageData.Width mod k) <> 0 then
      bm1.Width := (da1.ImageData.Width div k + 1) * k
    else
      bm1.Width := da1.ImageData.Width;
    if (da1.ImageData.Height mod k) <> 0 then
      bm1.Height := (da1.ImageData.Height div k + 1) * k
    else
      bm1.Height := da1.ImageData.Height;
    bm1.PixelFormat := pf24bit;
    // Initalization - Create a MPEG stream 400x96 pixels, base frequency
    // is 24 hz but it will be divided by 48 to provide 0.5 hz (one image
    // every 2 seconds). [The demo version has Height fixed to 96];

    fs := TFileStream.Create(Afilename, fmcreate);
    try
      //      mpg.Open(da1.ImageData.Width, da1.ImageData.Height, QUANTCODE[0], 100, bf24hz, fs);
      mpg.Open(bm1.Width, bm1.Height, QUANTCODE[0], 1000 div 25, bf25hz, fs);
      f1.ProgressBar1.Max := da1.ImageData.FrameCount - 1;
      f1.Show;
      if da1.ImageData.FrameCount > 1 then
      begin
        for i := 0 to da1.ImageData.FrameCount - 1 do
        begin
          if f1.Canceled then
            break;
          da1.ImageData.CurrentFrame := i;
          DCM_ImageData_Bitmap.AssignToBitmap(da1.ImageData, bm);
          bm1.Canvas.Draw((bm1.Width - bm.Width) div 2, (bm1.height - bm.height) div 2, bm);
          mpg.AddIImage(bm1);
          f1.ProgressBar1.Position := i;
          //mpg.Keep(24 * 2 - 1); // Keep the frame for 2 seconds.
        end;

      end
      else
      begin
        DCM_ImageData_Bitmap.AssignToBitmap(da1.ImageData, bm);
        bm1.Canvas.Draw((bm1.Width - bm.Width) div 2, (bm1.height - bm.height) div 2, bm);
        mpg.AddIImage(bm1);
      end;
      //mpg.Keep(24 * 2 - 1);
    finally
      mpg.Close; // Closes the stream and flush the buffers
      fs.Free;
      mpg.Free;
      bm.Free;
      bm1.Free;
      f1.Free;
    end;
    //    ShowMessage('�ɹ�');
  end;
  procedure SaveToAVI(Afilename: AnsiString);
  var
    fx1: TDicom2AVIStatusForm;
    da1: TDicomAttributes;
    i: integer;
    bm: TBitmap;
  begin
    fx1 := TDicom2AVIStatusForm.Create(self);
    da1 := Item[AIndex].Attributes;
    bm := TBitmap.Create;
    //    fx1.Width := da1.ImageData.Width;
    //    fx1.Height := da1.ImageData.Height;

    da1.ImageData.CurrentFrame := 0;
    DCM_ImageData_Bitmap.AssignToBitmap(da1.ImageData, bm);
    fx1.Width := bm.Width;
    fx1.Height := bm.Height;

    fx1.Filename := afilename;
    fx1.CreateAVIFile;

    fx1.ProgressBar1.Max := da1.ImageData.FrameCount - 1;
    fx1.Show;
    for i := 0 to da1.ImageData.FrameCount - 1 do
    begin
      //      if fx1.Canceled then
      //        break;
      da1.ImageData.CurrentFrame := i;
      DCM_ImageData_Bitmap.AssignToBitmap(da1.ImageData, bm);
      fx1.AddAVIFrame(bm);
      fx1.ProgressBar1.Position := i;
      //mpg.Keep(24 * 2 - 1); // Keep the frame for 2 seconds.
    end;

    fx1.CloseAVIFile;
    fx1.Free;
    bm.Free;
  end;
var
  filename1: AnsiString;
  bm1: TBitmap;
begin
  if (Count > 0) then
    exit;
  bm1 := TBitmap.Create;
  DCM_ImageData_Bitmap.AssignToBitmap(Item[AIndex].Attributes.ImageData, bm1, false);
  DCM_ImageData_Bitmap.LoadUserDrawObjectToBitmap(Item[AIndex].Attributes.ImageData, bm1);
  try
    begin
      FileName1 := AFileName;
      if Pos('.', filename1) <= 0 then
        filename1 := filename1 + '.' + filterarray[FilterIndex - 1];
      case FilterIndex - 1 of
        1:
          begin
            bm1.SaveToFile(FileName1);
          end;
        0: //jpeg
          begin
            with TJpegGraphic.Create do
            try
              SaveQuality := 100;
              assign(bm1);
              SaveToFile(filename1);
            finally
              Free;
            end; //JPEG try..finally}
          end;
        2: //tif
          begin
            //            WriteTiffToFile(filename1,bm1);
            with TTiffGraphic.Create do
            try
              assign(bm1);
              SaveToFile(filename1);
            finally
              Free;
            end;
          end;
        3: //tga
          begin
            with TTgaGraphic.Create do
            try
              assign(bm1);
              SaveToFile(filename1);
            finally
              Free;
            end;
          end;
        4: //png
          begin
            with TPngGraphic.Create do
            try
              assign(bm1);
              SaveToFile(filename1);
            finally
              Free;
            end;
          end;
        5: //pcx
          begin
            with TPcxGraphic.Create do
            try
              assign(bm1);
              SaveToFile(filename1);
            finally
              Free;
            end;
          end;
        6: //ppm
          begin
            with TPpmGraphic.Create do
            try
              assign(bm1);
              SaveToFile(filename1);
            finally
              Free;
            end;
          end;
        7: //jia TO DO GIF
          begin
            {                        with TGIFImage.Create do
                                    try
                                      assign(bm1);
                                      SaveToFile(filename1);
                                    finally
                                      Free;
                                    end;    }
          end;
        8: //mpg
          begin
            SaveToMpeg(filename1);
          end;
        9: //mpg
          begin
            SaveToAVI(filename1);
          end;
      end;
    end;
  finally
    bm1.Free;
  end;
end;

procedure TCnsDMTable.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, operation);
  if Operation = opRemove then
  begin
    if (AComponent = FAppSrvClient) then
      FAppSrvClient := nil
        //    else if (AComponent = ) then
//       := nil
      ;
  end;
end;

procedure TCnsDicomConnection.SetReceiveTimeout(Value: Integer);
begin
  fReceiveTimeout := Value;
  FAssociation.ReceiveTimeout := fReceiveTimeout;
end;

function TCnsDicomConnection.N_ACTION(ASOPClass: Integer; SopInstance: AnsiString; ADataset:
  TDicomAttributes): Boolean;
begin
  Result := SendDicomRequest(N_ACTION_REQUEST, ASOPClass, SopInstance, ADataset);
end;

function TCnsDicomConnection.N_CREATE(ASOPClass: Integer; SopInstance: AnsiString; ADataset:
  TDicomAttributes): Boolean;
begin
  Result := SendDicomRequest(N_CREATE_REQUEST, ASOPClass, SopInstance, ADataset);
end;

function TCnsDicomConnection.N_DELETE(ASOPClass: Integer; SopInstance: AnsiString; ADataset:
  TDicomAttributes): Boolean;
begin
  ClearPresentationContext;
  AddPresentationContext(Verification);
  AddPresentationContext(PatientRootQueryRetrieveInformationModelFIND);
  AddPresentationContext(StudyRootQueryRetrieveInformationModelGET);
  Result := SendDicomRequest(N_DELETE_REQUEST, ASOPClass, SopInstance, ADataset);
end;

function TCnsDicomConnection.N_EVENT_REPORT(ASOPClass: Integer; SopInstance: AnsiString; ADataset:
  TDicomAttributes): Boolean;
begin
  Result := SendDicomRequest(N_EVENT_REPORT_REQUEST, ASOPClass, SopInstance, ADataset);
end;

function TCnsDicomConnection.N_GET(ASOPClass: Integer; SopInstance: AnsiString; ADataset:
  TDicomAttributes): Boolean;
begin
  Result := SendDicomRequest(N_GET_REQUEST, ASOPClass, SopInstance, ADataset);
end;

function TCnsDicomConnection.N_SET(ASOPClass: Integer; SopInstance: AnsiString; ADataset:
  TDicomAttributes): Boolean;
begin
  Result := SendDicomRequest(N_SET_REQUEST, ASOPClass, SopInstance, ADataset);
end;

function TCnsDicomConnection.M_Database(ADataset: TDicomAttributes;
  var aResponseDataset: TDicomAttributes; var aStream: TStream): Boolean;
var
  {$IFDEF DICOMDEBUGZ1}
  kc: Integer;
  {$ENDIF}
  fin1: TAssociateFilePdu;
  i, k, k1: integer;
  das1: TDicomAttributes;
  da1: TDicomAttribute;
  stm1: TStream;
  //  str1: AnsiString;
  //  das: TDicomDataset;

    //  LogStrings: TStringList;
begin
  if (not FAssociation.IsConnected) then
  begin
    ClearPresentationContext;
    AddPresentationContext(DBS_Verification);
  end;
  {$IFDEF DICOMDEBUGZ1}
  //SendDebug('SendDicomRequest');
  kc := GetTickCount;
  {$ENDIF}

  Result := true;
  das1 := TDicomAttributes.Create;
  da1 := das1.Add($2813, $0112);

  da1.AddData(ADataset);

  fin1 := TAssociateFilePdu.Create;
  try
    fin1.Command := das1;
    SendFilePduRequest(fin1);
    //fin1.write(FAssociation.Stream);
  finally
    fin1.free;
  end;
  k := FAssociation.ReadPduType;
  if k = $44 then
  begin
    fin1 := TAssociateFilePdu.Create;
    try
      fin1.readCommand(FAssociation.Stream, k);
      if (fin1.ReceiveCount > 0) and (assigned(fin1.Command)) then
      begin
        da1 := fin1.Command.Item[$2813, $0112];
        if assigned(da1) and (da1.GetCount > 0) then
        begin
          for i := 0 to da1.GetCount - 1 do
          begin
            das1 := da1.Attributes[i];

            //ReceiveDatasets.Add(das1);
            aResponseDataset := das1;

            {LogStrings := TStringList.Create;
            try
              FData.ListAttrinute('p1.ResponseDataset', LogStrings);
              ShowMessage(LogStrings.Text);
            finally
              LogStrings.Free;
            end;}

            if das1.getInteger($2813, $0120) > 0 then
            begin
              for k1 := 0 to das1.getInteger($2813, $0120) - 1 do
              begin
                stm1 := TMemoryStream.Create;
                fin1.readData(FAssociation.Stream, stm1);
                FAssociation.Stream.WriteInt32(1);
                FAssociation.Stream.FreshData;

                stm1.Position := 0;

                //ReceiveStreams.Add(stm1);
                aStream := stm1;
              end;
            end;
          end;
          da1.ClearDataArray;
        end;
      end;
    finally
      fin1.free;
    end;
  end;

  {$IFDEF DICOMDEBUGZ1}
  SendDebug(Format('M_Database(%d)', [GetTickCount - kc]));
  {$ENDIF}
end;

function TCnsDicomConnection.GetReceiveStreams: TList;
begin
  Result := FAssociation.ReceiveStreams;
end;

{ TDcmIniFile }

constructor TDcmIniFile.Create(AConnection: TCnsCustomDicomConnection; const AFileName: AnsiString);
begin
  if AFileName <> '' then
    inherited Create(AFileName)
  else
  begin
    inherited Create(AConnection.GetLocalIP);
  end;
  FDataset := TCnsDBTable.Create(nil);
  FDataset.AppSrvClient := AConnection;
  FDataset.ObjectName := 'USERSETTING';
  FDataset.WhereSQL := 'USERNAME=''' + FileName + '''';
  LoadValues;
end;

destructor TDcmIniFile.Destroy;
begin
  UpdateFile;
  FDataset.Free;
  inherited Destroy;
end;

{function TDcmIniFile.AddSection(const Section: AnsiString): TStrings;
begin

end;}

procedure TDcmIniFile.DeleteKey(const Section, Ident: string);
begin

end;

procedure TDcmIniFile.EraseSection(const Section: string);
begin

end;

procedure TDcmIniFile.ReadSection(const Section: string;
  Strings: TStrings);
begin

end;

procedure TDcmIniFile.ReadSectionValues(const Section: string;
  Strings: TStrings);
begin
end;

function TDcmIniFile.ReadString(const Section, Ident,
  Default: string): string;
begin
  if FDataset.Locate('SECTIONNAME;ITEMNAME', VarArrayOf([Section, Ident]), []) then
  begin
    Result := FDataset.FieldByName('STRINGVALUE').AsString;
  end;
  if Result = '' then
    Result := Default;
end;

procedure TDcmIniFile.LoadValues;
begin
  FDataset.RefreshTable;
end;

procedure TDcmIniFile.UpdateFile;
begin
  FDataset.ApplyUpdates;
end;

procedure TDcmIniFile.WriteString(const Section, Ident, Value: string);
begin
  if FDataset.Locate('SECTIONNAME;ITEMNAME', VarArrayOf([Section, Ident]), []) then
  begin
    FDataset.Edit;
    FDataset.FieldByName('STRINGVALUE').AsString := Value;
    FDataset.Post;
  end
  else
  begin
    FDataset.Insert;
    FDataset.FieldByName('USERNAME').AsString := FileName;
    FDataset.FieldByName('SECTIONNAME').AsString := Section;
    FDataset.FieldByName('ITEMNAME').AsString := Ident;
    FDataset.FieldByName('STRINGVALUE').AsString := Value;
    FDataset.Post;
  end;
end;

constructor TCnsCustomDicomConnection.Create(AOwner: TComponent);
begin
  inherited;
  //  FLastDatasets := nil;
  fMeasureReportDataset := nil;
end;

destructor TCnsCustomDicomConnection.Destroy;
begin

  inherited;
end;

procedure TCnsCustomDicomConnection.Disconnect;
begin

end;

procedure TCnsCustomDicomConnection.Clear;
begin

end;

function TCnsCustomDicomConnection.GetLastDatasets: TDicomDatasets;
begin
  Result := nil;
  if assigned(FGetCurrentDataset) then
    FGetCurrentDataset(self, Result);
end;

function TCnsCustomDicomConnection.GetReceiveDatasets: TList;
begin
  Result := nil;
end;

function TCnsCustomDicomConnection.C_Echo: Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.C_MOVE(ADataset: TDicomAttributes): Boolean;
begin
  Result := false;

end;

function TCnsCustomDicomConnection.C_FIND(ADataset: TDicomAttributes): Boolean;
begin
  Result := false;

end;

function TCnsCustomDicomConnection.C_MWL(ADataset: TDicomAttributes): Boolean;
begin
  Result := false;

end;

function TCnsCustomDicomConnection.C_GET(ADataset: TDicomAttributes): Boolean;
begin
  Result := false;

end;

function TCnsCustomDicomConnection.C_STORAGE(ADataset: TDicomAttributes): Boolean;
begin
  Result := false;

end;

function TCnsCustomDicomConnection.C_Database(ADataset: TDicomAttributes): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.M_GET(AStudyUID: AnsiString): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.M_STORAGE(ADataset: TDicomDataset; AWithFileStream: Boolean =
  TRUE): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.GetFile(AFileName: AnsiString): TDicomAttributes;
var
  da1: TDicomAttributes;
begin
  Result := nil;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'GFILE');
    AddVariant($2809, $17, AFileName);
  end;
  if C_Database(da1) then
  begin
    if ReceiveDatasets.Count > 0 then
    begin
      Result := ReceiveDatasets[0];
      ReceiveDatasets.Clear;
    end;
  end;
  Clear;
end;

function TCnsCustomDicomConnection.GetLocalIP: AnsiString;
begin
  Result := '127.0.0.1';
end;

procedure TCnsCustomDicomConnection.SetHost(const Value: AnsiString);
begin
  FHost := Value;
end;

procedure TCnsCustomDicomConnection.SetPort(const Value: integer);
begin
  FPort := Value;
end;

function SaveSQToDataset(AData: TDicomAttribute): TDataset;
begin
  if AData.DataType = ddtAttributes then
  begin
    Result := SaveListToDataset(AData.DataArray);
  end
  else
    Result := nil;
  //    raise Exception.Create(V_IS_NOT_A_SQ_TYPE_DATA);
end;

function SaveListToDataset(AList: TList): TDataset;
var
  d1: TKxmMemtable;
  das1: TDicomAttributes;
  da1: TDicomAttribute;
  i, k: integer;
  //  g1,e1:Word;
  str1: AnsiString;
  ft1: TFieldType;
  f1: TField;
begin
  if Assigned(AList) and (AList.Count > 0) then
  begin
    d1 := TKxmMemtable.Create(nil);
    das1 := TDicomAttributes(AList[0]);
    for k := 0 to das1.Count - 1 do
    begin
      da1 := das1.ItemByIndex[k];
      if da1.Element = 0 then
        continue;
      str1 := IntToHex(da1.Group, 4) + IntToHex(da1.Element, 4);
      //      if not assigned(d1.FieldDefs.Find(str1)) then
      begin
        case da1.DataType of
          ddtString: ft1 := ftString;
          ddtShortInt, ddtInteger: ft1 := ftInteger;
          ddtSingle, ddtDouble: ft1 := ftFloat;
          ddtDatetime: ft1 := ftDateTime;
          ddtTime: ft1 := ftTime;
          //    ddtAttributes,
          ddtOBStream: ft1 := ftBlob;
          //    ddtImage
        else
          continue;
        end;
        if ft1 = ftString then
          d1.FieldDefs.Add(str1, ft1, 40, false)
        else
          d1.FieldDefs.Add(str1, ft1, 0, false);
      end;
    end;
    d1.Open;
    for i := 0 to AList.Count - 1 do
    begin
      das1 := TDicomAttributes(AList[i]);
      d1.Insert;
      for k := 0 to das1.Count - 1 do
      begin
        da1 := das1.ItemByIndex[k];
        str1 := IntToHex(da1.Group, 4) + IntToHex(da1.Element, 4);
        f1 := d1.FindField(str1);
        if assigned(f1) then
          f1.AsString := da1.AsString[0];
      end;
      d1.Post;
    end;
    for k := 0 to das1.Count - 1 do
    begin
      da1 := das1.ItemByIndex[k];
      str1 := IntToHex(da1.Group, 4) + IntToHex(da1.Element, 4);
      f1 := d1.FindField(str1);
      if assigned(f1) then
        f1.DisplayLabel := da1.Description;
    end;
    Result := d1;
  end
  else
    Result := nil;
end;

procedure TCnsDBTable.SaveToFile(AFilename: AnsiString);
var
  Das: TDicomDataset;
begin
  if Active and assigned(FData) then
  begin
    Das := TDicomDataset.Create(FData);
    {    with TImageAttributesForm.Create(self) do
        try
          caption := cns_ImageProperty;
          FData.ListAttrinute('', Memo1.Lines);
          ShowModal;
        finally
          Free;
        end;
    }
    das.SaveToFile(AFileName, true, 8194, 100);
    das.RecreateAttributes;
    das.Free;
  end;
end;

procedure TCnsDBTable.LoadFromFile(AFileName: AnsiString);
var
  bname: AnsiString;
begin
  if Active then
    Active := false;
  bname := FDataFileName;
  FDataFilename := AFilename;
  fTableLoadMode := cnsLoadFromFile;
  try
    Active := true;
  finally
    fTableLoadMode := cnsLoadFromNetwork;
    FDataFileName := bname;
  end;
end;

procedure TCnsDBTable.LoadFromSource(AData: TDicomAttributes);
begin
  if Active then
    Active := false;
  FSourceData := AData;
  fTableLoadMode := cnsLoadFromSourceData;
  try
    Active := true;
  finally
    fTableLoadMode := cnsLoadFromNetwork;
  end;
end;

function TCnsDBTable.GetData: TDicomAttributes;
begin
  Result := FData;
  FData := nil;
end;

procedure TCnsDBTable.UpdateAllDataToServer;
begin

end;

procedure TImagesSelectedToPrint.SetBitmap(Value: TBitmap);
begin
  Fbitmap.Assign(Value);
end;

constructor TImagesSelectedToPrint.Create;
begin
  inherited;
  FInstanceUID := '';
  FFrameIndex := 0;
  FWindowCenter := 0;
  FWindowWidth := 0;
  Fbitmap := TBitmap.Create;
  FAttributes := nil;
end;

destructor TImagesSelectedToPrint.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

{ TCnsDicomConnectionThread }

procedure TCnsDicomConnectionThread.CGetImage(ALevel, AUID: AnsiString; AOnlyLoadKeyImage: Boolean);
begin
  fOnlyLoadKeyImage := AOnlyLoadKeyImage;

  if not assigned(fSendCommand) then
    fSendCommand := TDicomAttributes.Create
  else
    fSendCommand.clear;
  with fSendCommand do
  begin
    AddVariant($0008, $0052, ALevel);
    if ALevel = 'PATIENT' then
      AddVariant($0010, $0020, AUID)
    else
      if ALevel = 'STUDY' then
      AddVariant($0020, $000D, AUID)
    else
      if ALevel = 'SERIES' then
      AddVariant($0020, $000E, AUID)
    else
      if ALevel = 'IMAGE' then
      AddVariant($0008, $0018, AUID)
    else
    begin
      ShowMessage('Error Level AnsiString"' + ALevel + '"');
      exit;
    end;
    if AOnlyLoadKeyImage then
      AddVariant($2813, $0120, 1);
    sort;
  end;
  fCommand := dctcReceive;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    resume;
end;

procedure TCnsDicomConnectionThread.MGetImage(ALevel: AnsiString; AUIDS_Series, AUIDS_Study:
  TStringList;
  AOnlyLoadKeyImage: Boolean);
var
  da1, da2: TDicomAttribute;
  i: Integer;
begin
  fOnlyLoadKeyImage := AOnlyLoadKeyImage;

  if not assigned(fSendCommand) then
    fSendCommand := TDicomAttributes.Create
  else
    fSendCommand.clear;
  with fSendCommand do
  begin
    if ALevel = 'STUDY' then
    begin
      da1 := Add($0020, $000D);
      for I := 0 to AUIDS_Series.Count - 1 do
      begin
        //da1.AsString[i] := AUIDS_Series[i];
        da1.AsString[i] := AUIDS_Study[i];
      end;
    end
    else
      if ALevel = 'SERIES' then
    begin
      da1 := Add($0020, $000E);
      da2 := Add($0020, $000D);
      for I := 0 to AUIDS_Series.Count - 1 do
      begin
        da1.AsString[i] := AUIDS_Series[i];
        da2.AsString[i] := AUIDS_Study[i];
      end;
    end
    else
      if ALevel = 'IMAGE' then
    begin
      da1 := Add($0008, $0018);
      da2 := Add($0020, $000D);
      for I := 0 to AUIDS_Series.Count - 1 do
      begin
        da1.AsString[i] := AUIDS_Series[i];
        da2.AsString[i] := AUIDS_Study[i];
      end;
    end
    else
    begin
      ShowMessage('Error Level AnsiString"' + ALevel + '"');
      exit;
    end;

    if AOnlyLoadKeyImage then
      AddVariant($2813, $0120, 1);
    AddVariant(78, ALevel);
    sort;
  end;
  fCommand := dctcReceiveEx;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //Free;
  end
  else
    resume;
end;

procedure TCnsDicomConnectionThread.MGetImage(ALevel, AUID: AnsiString; AOnlyLoadKeyImage: Boolean);
begin
  fOnlyLoadKeyImage := AOnlyLoadKeyImage;

  if not assigned(fSendCommand) then
    fSendCommand := TDicomAttributes.Create
  else
    fSendCommand.clear;
  with fSendCommand do
  begin
    if ALevel = 'PATIENT' then
      AddVariant(dPatientID, AUID)
    else
      if ALevel = 'STUDY' then
      AddVariant(dStudyInstanceUID, AUID)
    else
      if ALevel = 'SERIES' then
      AddVariant(dSeriesInstanceUID, AUID)
    else
      if ALevel = 'IMAGE' then
      AddVariant($0008, $0018, AUID)
    else
    begin
      ShowMessage('Error Level AnsiString"' + ALevel + '"');
      exit;
    end;
    if AOnlyLoadKeyImage then
      AddVariant($2813, $0120, 1);
    AddVariant(78, ALevel);
    sort;
  end;
  fCommand := dctcReceiveEx;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    // Free;
  end
  else
    resume;
end;

constructor TCnsDicomConnectionThread.Create(CreateSuspended: Boolean);
begin
  MnLg_ev('DCM_Client TCnsDicomConnectionThread.Create',vLogDir+pLogFile);

  inherited Create(CreateSuspended);

  FUseSynchronizeEvent := true;
  FSendPrintSetting := false;

  fNoneThread := CreateSuspended;
  FEnable12bitsGrayscale := false;

  FPrintWindowWidthCenter := true;
  FPrintwithBottomScale := true;
  FPrintWithRightScale := true;

  FPrintWithLabel := true;
  FPrintLabelFirstImage := false;

  CnsErrorMessage := '';
  fFormHandle := 0;

  fIconCommandDataset := nil;
  FCurrentDatasets := nil;
  fURL := '';
  fDataset := nil;
  fWadoTransferSyntax := '';

  fList := TList.Create;
  fImageTable := nil;

  fReceiveTimeout := 120000;

  fFilenames := TStringList.Create;

  fCommand := dctcNone;

  FCallingTitle := '';
  FCalledTitle := '';
  fHost := '127.0.0.1';
  fPort := 104;

  fSendCommand := nil; //TDicomAttributes.Create;
  fFreeAfterSend := false;

  fPrintFormat := '';
  fPrintOrientation := '';
  fFilmSize := '';
  fCopys := 1;
  fFromIndex := 0;
  fLimitCount := 1;
  fMagnificationType := 'CUBIC';
  fSmoothingType := 'SHARP';
  fPolarity := '';
  fBorderDensity := 'BLACK';
  fEmptyImageDensity := 'BLACK';
  fTrim := 'YES';
  fMediumType := '';
  fFilmDestination := '';
  fMinDensity := 30;
  fMaxDensity := 290;
  fIsColor := false;
  fNeedResizeImage := true;
  FPrintWithDefaultParam := true;

  //Priority := tpHigher;
  //tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest, tpTimeCritical
  //FreeOnTerminate := true;
end;

destructor TCnsDicomConnectionThread.Destroy;
begin
  fFilenames.Free;
  fList.Free;
  //fSendCommand.free;
  if fCommand = dctcLoadFromFiles then
    if assigned(fImageTable) then
      fImageTable.Free;
  if (FCurrentDatasets <> nil) and (fCommand = dctcPrintFilm) then
  begin
    FCurrentDatasets.Free;
  end;
  inherited;
end;

procedure TCnsDicomConnectionThread.DoImport;
var
  i: integer;
  das1: TDicomDataset;
begin
  if assigned(FOnWorkStart) then
    FOnWorkStart(self);
  for i := 0 to fFilenames.Count - 1 do
  begin
    if Terminated then
      exit;
    das1 := TDicomDataset.Create;
    if das1.LoadFromFile(fFilenames[i], true) then
    begin
      fCurrentDataset := das1;
      if fFormHandle > 0 then
      begin
        CurrentDatasets.AddDicomDataset(das1);
        PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1);
      end
      else
      begin
        {if ModuleIsLib then
          TiggleReceiveEvent
        else}
        if FUseSynchronizeEvent then
          Synchronize(TiggleReceiveEvent)
        else
          TiggleReceiveEvent;
      end;
      //if assigned(OnReceive) then
      //  OnReceive(self, das1);
    end;
  end;
end;

procedure TCnsDicomConnectionThread.DoReceiveEx;
var
  //  da1: TDicomDataset;
  //  i: Integer;
  CnsDicomConnection1: TCnsDicomConnection;
  function M_GET(ASendCommand: TDicomAttributes): Boolean;
  var
    fin1: TAssociateFilePdu;
    i, k: integer;
    das1: TDicomAttributes;
    da1: TDicomAttribute;
    stm1: TStream;
    str1, AStudyUID: AnsiString;
    das: TDicomDataset;
    {$IFDEF DICOMDEBUGZ1}
    kc: Integer;
    {$ENDIF}
  begin
    //  DstPath := '';
    das1 := TDicomAttributes.Create;
    da1 := das1.Add($2813, $0111);
    {das2 := TDicomAttributes.Create;
    with das2 do
    begin
      AddVariant(78, 'STUDY');
      AddVariant(dStudyInstanceUID, AStudyUID);
    end;}

    AStudyUID := ASendCommand.GetString(dStudyInstanceUID);

    da1.AddData(ASendCommand);
    {$IFDEF DICOMDEBUGZ1}
    kc := GetTickCount;
    {$ENDIF}

    Result := true;
    fin1 := TAssociateFilePdu.Create;
    try
      fin1.Command := das1;
      CnsDicomConnection1.SendFilePduRequest(fin1);
    finally
      fin1.free;
    end;
    if assigned(FOnWorkStart) then
      FOnWorkStart(self);
    k := CnsDicomConnection1.FAssociation.ReadPduType;
    if k = $44 then
    begin
      fin1 := TAssociateFilePdu.Create;
      try
        fin1.readCommand(CnsDicomConnection1.FAssociation.Stream, k);
        if (fin1.ReceiveCount > 0) and (assigned(fin1.Command)) then
        begin
          da1 := fin1.Command.Item[$2813, $0111]; //���ղ�����ͼ��
          if assigned(da1) and (da1.GetCount > 0) then
          begin
            //triggle for icon data update
            fIconCommandDataset := da1;

            if FUseSynchronizeEvent then
              Synchronize(TiggleMReceiveEvent)
            else
              TiggleMReceiveEvent;

            for i := 0 to da1.GetCount - 1 do
            begin

              das1 := da1.Attributes[i];
              {$IFDEF  MGETUSE_MEMORYSTREAM}
              stm1 := TMemoryStream.Create;
              {$ELSE}

              inc(CurrentTempImageIndex);
              str1 := Format('%sDCMTEMP\T$%d_%d.DCM', [DicomTempPath,
                //Copy(AStudyUID, Length(AStudyUID) - 8, 8),
                CurrentTempImageIndex, Random(100000)]);
              {$IFDEF DICOMDEBUGZ1}
              //SendDebug('before creating ' + str1);
              {$ENDIF}
              stm1 := TFileStream.Create(str1, fmCreate);
              {$IFDEF DICOMDEBUGZ1}
              //SendDebug('after created ' + str1);
              {$ENDIF}
              {$ENDIF}
              try
                {$IFDEF DICOMDEBUGZ1}
                //SendDebug('reading Data ');
                {$ENDIF}
                fin1.readData(CnsDicomConnection1.FAssociation.Stream, stm1);
                {$IFDEF DICOMDEBUGZ1}
                //SendDebug('readed Data ');
                {$ENDIF}
                if Terminated then
                begin
                  CnsDicomConnection1.FAssociation.Stream.WriteInt32(0);
                  break;
                end
                else
                  CnsDicomConnection1.FAssociation.Stream.WriteInt32(1);

                CnsDicomConnection1.FAssociation.Stream.FreshData;

                stm1.Position := 0;
                das := TDicomDataset.Create;
                {$IFDEF  MGETUSE_MEMORYSTREAM}
                das.LoadFromStream(stm1, false);
                {$ELSE}
                das.LoadFromStream(stm1, true);
                das.SetStreamAndFileName(stm1, str1, true);
                {$ENDIF}

                das.Attributes.AddVariant($2809, $001B, das1.getInteger($2809, $001B));
                das.Attributes.AddVariant($2809, $001C, das1.getString($2809, $001C));
                das.Attributes.AddVariant($2809, $001D, das1.getInteger($2809, $001D));
                das.Attributes.AddVariant($2809, $001E, das1.getInteger($2809, $001E));
                das.Attributes.AddVariant($2809, $001F, das1.getInteger($2809, $001F));
                das.Attributes.AddVariant($2809, $2000, das1.getInteger($2809, $2000));
                das.Attributes.AddVariant($2809, $2001, das1.getInteger($2809, $2001));
                {$IFDEF DICOMDEBUGZ1}
                SendDebug('receive ' + IntToStr(GetTickCount - kc) + ':' + str1);
                kc := GetTickCount;
                {$ENDIF}
                TiggleMGET(self, das, i);
                {$IFDEF DICOMDEBUGZ1}
                //SendDebug('view ' + IntToStr(GetTickCount - kc));
                //kc := GetTickCount;
                {$ENDIF}
              finally
                {$IFDEF  MGETUSE_MEMORYSTREAM}
                stm1.Free;
                {$ENDIF}
              end;
            end;
          end;
        end;
      finally
        fin1.free;
      end;
    end;
  end;
begin
  if assigned(fSendCommand) then
  begin
    CnsDicomConnection1 := TCnsDicomConnection.Create(nil);

    CnsDicomConnection1.Host := Host;
    CnsDicomConnection1.Port := Port;
    CnsDicomConnection1.CalledTitle := CalledTitle;
    CnsDicomConnection1.CallingTitle := CallingTitle;
    CnsDicomCOnnection1.OnCGETProcess := TiggleCGET;
    CnsDicomConnection1.ReceiveTimeout := fReceiveTimeout;
    CnsDicomCOnnection1.ResetSynTax;

    CnsDicomCOnnection1.ClearPresentationContext;
    CnsDicomCOnnection1.AddPresentationContext(DBS_Verification);

    try

      if M_GET(fSendCommand) then
      begin
        {for i := 0 to CnsDicomConnection1.ReceiveDatasets.Count - 1 do
        begin
          da1 := TDicomDataset.Create(TDicomAttributes(CnsDicomConnection1.ReceiveDatasets[i]));
          fList.Add(da1);
        end;}
        //CnsDicomConnection1.ReceiveDatasets.Clear;
      end;
    finally
      CnsDicomConnection1.free;
    end;
    fSendCommand := nil;
  end;
end;

procedure TCnsDicomConnectionThread.DoReceive;
var
  //  da1: TDicomDataset;
  //  i: Integer;
  CnsDicomConnection1: TCnsDicomConnection;

  function DOC_GET(ADataset: TDicomAttributes): Boolean;
  var
    str1: AnsiString;
    k, kkk, cm1: Integer;
    r: Boolean;
    abort1: TDicomAbort;
    da1: TDicomAttributes;
    MyList: TList;
  begin
    if (not CnsDicomConnection1.Association.IsConnected) then
    begin
      CnsDicomConnection1.ClearPresentationContext;
      str1 := ADataset.GetString(78);
      {    if str1 = 'PATIENT' then
            AddPresentationContext(PatientRootQueryRetrieveInformationModelMOVE)
          else
            AddPresentationContext(StudyRootQueryRetrieveInformationModelMOVE); }
      CnsDicomConnection1.AddCGETPresentationContexts;

      CnsDicomConnection1.AddPresentationContext(DXImageStorageForProcessing);
    end;
    Result := CnsDicomConnection1.SendDicomRequest(C_GET_REQUEST,
      CnsDicomConnection1.PresentationContext[0], '', ADataset);
    kkk := 0;
    //  m1 := self.Association.ReceiveCommand.getInteger(0,$110);
    if assigned(FOnWorkStart) then
      FOnWorkStart(self);

    if Result then
    begin
      MyList := TList.Create;
      try
        while true do
        begin
          if Terminated then
            break;
          if CnsDicomConnection1.ReceiveDatasets.Count > 0 then
          begin
            da1 := CnsDicomConnection1.ReceiveDatasets[0];
            CnsDicomConnection1.ReceiveDatasets.Clear;
            MyList.Add(da1);
            kkk := 0;
            CnsDicomConnection1.SendStatus(0, CnsDicomConnection1.FMessageID);
            if assigned(CnsDicomConnection1.OnCGETProcess) then
              CnsDicomConnection1.OnCGETProcess(CnsDicomConnection1, da1, MyList.count);
          end
          else
          begin
            cm1 := CnsDicomConnection1.Association.ReceiveCommand.getInteger(0, $100);
            if cm1 = 32784 then
            begin
              if CnsDicomConnection1.Association.ReceiveCommand.getInteger(0, $1020) <= 0 then
                break;
            end
            else
              break;
          end;
          k := CnsDicomConnection1.Association.ReadPduType;
          if k = 4 then
          begin
            repeat
              r := CnsDicomConnection1.Association.ReceiveDataPdu(k);
              if not r then
              begin
                k := CnsDicomConnection1.Association.ReadPduType;
                if k = 7 then
                begin
                  abort1 := CnsDicomConnection1.Association.receiveAbort(k);
                  CnsDicomConnection1.Disconnect;
                  raise Exception.Create(V_RECEIVE_ABORT_ERROR + abort1.Text);
                end;
                if k = 5 then
                begin //sendReleaseRequest
                  CnsDicomConnection1.Association.receiveReleaseRequest(k);
                  CnsDicomConnection1.Association.sendReleaseResponse;
                  CnsDicomConnection1.Disconnect;
                  raise Exception.Create(V_RECEIVE_RELEASE_REQUEST_ERROR);
                end
                else
                  if assigned(CnsDicomConnection1.OnPDUProcess) then
                begin
                  CnsDicomConnection1.OnPDUProcess(CnsDicomConnection1, kkk);
                  inc(kkk);
                end;
                //        if k <> 4 then
                //          raise Exception.Create('No DataPdu To receive!');
              end
              else
                break;
            until r;
          end
          else
            raise Exception.Create(V_NO_IMAGE_RECEIVE);
        end;
      finally
        for k := 0 to MyList.Count - 1 do
          CnsDicomConnection1.ReceiveDatasets.Add(MyList[k]);
        MyList.Clear;
        MyList.Free;
      end;
    end;
  end;
begin
  if assigned(fSendCommand) then
  begin
    CnsDicomConnection1 := TCnsDicomConnection.Create(nil);

    CnsDicomConnection1.Host := Host;
    CnsDicomConnection1.Port := Port;
    CnsDicomConnection1.CalledTitle := CalledTitle;
    CnsDicomConnection1.CallingTitle := CallingTitle;
    CnsDicomCOnnection1.OnCGETProcess := TiggleCGET;
    CnsDicomConnection1.ReceiveTimeout := fReceiveTimeout;
    try

      if DOC_GET(fSendCommand) then
      begin
        {for i := 0 to CnsDicomConnection1.ReceiveDatasets.Count - 1 do
        begin
          da1 := TDicomDataset.Create(TDicomAttributes(CnsDicomConnection1.ReceiveDatasets[i]));
          fList.Add(da1);
        end;}
        CnsDicomConnection1.ReceiveDatasets.Clear;
      end;
    finally
      CnsDicomConnection1.free;
    end;
    fSendCommand := nil;
  end;
end;

procedure TCnsDicomConnectionThread.DoSend;
var
  CnsDicomConnection1: TCnsDicomConnection;
  i: integer;
  das1: TDicomDataset;
begin
  if assigned(FOnWorkStart) then
    FOnWorkStart(self);
  for i := 0 to fList.Count - 1 do
  begin
    if Terminated then
      exit;
    das1 := TDicomDataset(fList[i]);
    CnsDicomConnection1 := TCnsDicomConnection.Create(nil);
    try
      CnsDicomConnection1.Host := Host;
      CnsDicomConnection1.Port := Port;
      CnsDicomConnection1.CalledTitle := CalledTitle;
      CnsDicomConnection1.CallingTitle := CallingTitle;
      CnsDicomConnection1.ReceiveTimeout := fReceiveTimeout;
      if fFreeAfterSend then
      begin
        CnsDicomConnection1.C_STORAGE(das1.Attributes);
        das1.RecreateAttributes;
      end
      else
        CnsDicomConnection1.C_STORAGE(CopyAttributes(das1.Attributes));
      fPosition := i;
      {if ModuleIsLib then
        TiggleSendEvent
      else}
      if FUseSynchronizeEvent then
        Synchronize(TiggleSendEvent)
      else
        TiggleSendEvent;
      //if assigned(OnAfterSend) then
      //begin
      //  OnAfterSend(self, i);
      //end;
    finally
      CnsDicomConnection1.Free;
    end;
  end;
  if fFreeAfterSend then
  begin
    for I := fList.Count - 1 downto 0 do // Iterate
    begin
      try
        TDicomDataset(fList[i]).Free;
      except
        on e: Exception do
        begin
          raise Exception('Image:' + IntToStr(i) + ':' + e.Message);
        end;
      end;
    end; // for
    fList.Clear;
  end;
end;

procedure TCnsDicomConnectionThread.DoSendFile;
var
  CnsDicomConnection1: TCnsDicomConnection;
  i: integer;
  das1: TDicomDataset;
begin
  if assigned(FOnWorkStart) then
    FOnWorkStart(self);
  for i := 0 to fFilenames.Count - 1 do
  begin
    if Terminated then
      exit;
    das1 := TDicomDataset.Create;
    try
      if das1.LoadFromFile(fFilenames[i], false) then
      begin

        CnsDicomConnection1 := TCnsDicomConnection.Create(nil);
        try
          CnsDicomConnection1.Host := Host;
          CnsDicomConnection1.Port := Port;
          CnsDicomConnection1.CalledTitle := CalledTitle;
          CnsDicomConnection1.CallingTitle := CallingTitle;
          CnsDicomConnection1.ReceiveTimeout := fReceiveTimeout;

          CnsDicomConnection1.C_STORAGE(das1.Attributes);
          das1.RecreateAttributes;

          fPosition := i;
          {if ModuleIsLib then
            TiggleSendEvent
          else}
          if FUseSynchronizeEvent then
            Synchronize(TiggleSendEvent)
          else
            TiggleSendEvent;
          //if assigned(OnAfterSend) then
          //begin
          //  OnAfterSend(self, i);
          //end;

        finally
          CnsDicomConnection1.Free;
        end;
      end;
    finally
      das1.Free;
    end;
  end;
end;

procedure TCnsDicomConnectionThread.Execute;
  procedure LoadPath(APath: AnsiString);
  var
    sr: TSearchRec;
    FileAttrs: Integer;
    das1: TDicomDataset;
  begin
    FileAttrs := faAnyFile;

    if FindFirst(APath + '\*.*', FileAttrs, sr) = 0 then
    begin
      repeat
        if ((faDirectory and sr.Attr) <> 0) then
        begin
          if (sr.Name <> '.') and (sr.Name <> '..') then
            LoadPath(APath + '\' + sr.Name);
        end
        else
          if SysUtils.UpperCase(ExtractFileExt(sr.Name)) = '.DCM' then
        begin
          //FDicomDatasets.LoadFromFile(APath + '\' + sr.Name);
          das1 := TDicomDataset.Create;
          if das1.LoadFromFile(APath + '\' + sr.Name, false) then
          begin
            fCurrentDataset := das1;
            if fFormHandle > 0 then
            begin
              CurrentDatasets.AddDicomDataset(das1);
              PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1);
            end
            else
            begin
              if FUseSynchronizeEvent then
                Synchronize(TiggleReceiveEvent)
              else
                TiggleReceiveEvent;
            end;
          end;
        end;
        if Terminated then
          break;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;
begin
  try
    while not Terminated do
      //if not Terminated then
    begin
      //do send or receive
      {$IFDEF DICOMDEBUGZ1}
      SendDebug('creating ' + IntToStr(Ord(fCommand)));
      {$ENDIF}

      case fCommand of
        dctcSendDatasets: //send;
          begin
            DoSend;
          end;
        dctcReceive: //cget
          begin
            DoReceive;
          end;
        dctcSendDatasetsEx: //msende;
          begin
            DoSendEx;
          end;
        dctcReceiveEx: //mget
          begin
            DoReceiveEx;
          end;
        dctcSendFiles: // send files
          begin
            DoSendFile;
          end;
        dctcImportFiles: //import file
          begin
            DoImport;
          end;
        dctcImportFilesEx: //import file
          begin
            LoadPath(FDirectoryToLoad);
          end;
        dctcPrintFilm: //print datasets
          begin
            DoPrint;
          end;
        dctcLoadFromFiles: //
          begin
            DoLoadFromFiles;
          end;
        dctcLoadFromDicomDIR:
          begin
            DoLoadFromDicomDIR;
          end;
        dctcWadoGetImage:
          begin
            DoWadoGet;
          end;
      else
        begin
          //fErrorMessage := 'Error Command';
          //ProcessWindowsMessageQueue;
          continue;
        end;
      end;

      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE_FINISH, FQueueIndex, 0);

      if FreeOnTerminate then
        Break;
      if not Terminated then
        Suspend;
      {$IFDEF DICOMWSOCKCLIENT}
      ProcessWindowsMessageQueue;
      {$ENDIF}
    end;
  finally
    Terminate;
  end;
end;

procedure TCnsDicomConnectionThread.SendImages(ADatasets: TDicomDatasets; AFreeAfterSend: Boolean);
var
  i: Integer;
begin
  fFreeAfterSend := AFreeAfterSend;
  for i := 0 to ADatasets.Count - 1 do
    fList.Add(ADatasets[i]);
  fCommand := dctcSendDatasets;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    Resume;
end;

procedure TCnsDicomConnectionThread.ImportImages(
  ADatasetFilenames: tstrings);
begin
  fFilenames.Text := ADatasetFilenames.Text;
  fCommand := dctcImportFiles;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    Resume;
end;

procedure TCnsDicomConnectionThread.SendImages(
  ADatasetFilenames: tstrings);
begin
  fFilenames.Text := ADatasetFilenames.Text;
  fCommand := dctcSendFiles;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    Resume;
end;

procedure TCnsDicomConnectionThread.TiggleCGET(Sender: TObject;
  ADataset: TDicomAttributes; AImageCount: Integer);
var
  da1: TDicomDataset;
begin
  da1 := TDicomDataset.Create(ADataset);
  fList.Add(da1);
  fCurrentDataset := da1;

  if fFormHandle > 0 then
  begin
    CurrentDatasets.AddDicomDataset(da1);
    PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1);
  end
    {else
      if ModuleIsLib then
      TiggleReceiveEvent}
  else
    if FUseSynchronizeEvent then
    Synchronize(TiggleReceiveEvent)
  else
    TiggleReceiveEvent;
  //  if assigned(OnReceive) then
  //    OnReceive(self, da1);
end;

procedure TCnsDicomConnectionThread.TiggleMGET(Sender: TObject;
  ADataset: TDicomDataset; AImageCount: Integer);
begin
  fList.Add(ADataset);
  fCurrentDataset := ADataset;

  if fFormHandle > 0 then
  begin
    CurrentDatasets.AddDicomDataset(ADataset);
    PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1)
  end
    {else
      if ModuleIsLib then
      TiggleReceiveEvent}
  else
    if FUseSynchronizeEvent then
    Synchronize(TiggleReceiveEvent)
  else
    if assigned(OnReceive) then
    OnReceive(self, ADataset);
end;

procedure TCnsDicomConnectionThread.PrintDicomDatasets(
  ADatasets: TDicomDatasets; ACopys, AFromIndex, ALimitCount: Integer);
//var
//  i: Integer;
begin

  fCopys := ACopys;
  fFromIndex := AFromIndex;
  fLimitCount := ALimitCount;
  FCurrentDatasets := ADatasets;

  //  fFreeAfterSend := AFreeAfterSend;

  //for i := 0 to ADatasets.Count - 1 do
  //  fList.Add(ADatasets[i]);

  fCommand := dctcPrintFilm;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    // Free;
  end
  else
    resume;
end;

function TCnsDicomConnectionThread.ReSizeAllImageEx(ADicomDatasets: TDicomDatasets): TCnsDMTable;
var
  i: Integer;
  maxX, maxY: integer;
  das1, das2: TDicomDataset;
  //  d1: TDicomAttributes;
  bm, dst: TCnsBitmap32;
  AT: TAffineTransformation;
  f1, sx, sy, dx: Double;
  AVerOff, AHizOff: Integer;
  str1: string;

  k_count, k_y_count, k_x_count, k2, k2_y, k2_x: Integer;

  v1, V2, v3: TDicomBitmap16;
  dstWidth, dstHeight: Integer;
begin
  str1 := fFilmSize;
  if str1 = '14INX17IN' then
  begin
    sx := 14;
    sy := 17;
  end
  else
    if str1 = '14INX14IN' then
  begin
    sx := 14;
    sy := 14;
  end
  else
    if str1 = '11INX17IN' then
  begin
    sx := 11;
    sy := 17;
  end
  else
    if str1 = '11INX14IN' then
  begin
    sx := 11;
    sy := 14;
  end
  else
    if str1 = '10INX14IN' then
  begin
    sx := 10;
    sy := 14;
  end
  else
    if str1 = '10INX12IN' then
  begin
    sx := 10;
    sy := 12;
  end
  else
    if str1 = '8_5INX11IN' then
  begin
    sx := 8.5;
    sy := 11;
  end
  else
    if str1 = '8INX10IN' then
  begin
    sx := 8;
    sy := 10;
  end
  else
    if str1 = '24CMX30CM' then
  begin
    sx := 24 / 2.54;
    sy := 30 / 2.54;
  end
  else
    if str1 = '24CMX24CM' then
  begin
    sx := 24 / 2.54;
    sy := 24 / 2.54;
  end
  else
    if str1 = 'A4' then
  begin
    sx := 21 / 2.54;
    sy := 29.7 / 2.54;
  end
  else
    if str1 = 'A3' then
  begin
    sx := 29.7 / 2.54;
    sy := 42 / 2.54;
  end
  else
    raise Exception.Create('Error paper or film size setting');

  if fPrintOrientation <> 'PORTRAIT' then
  begin
    f1 := sx;
    sx := sy;
    sy := f1;
  end;
  str1 := fResolution;
  if str1 = '1200 DPI' then
  begin
    dx := 1200
  end
  else
    if str1 = '1000 DPI' then
  begin
    dx := 1000
  end
  else
    if str1 = '800 DPI' then
  begin
    dx := 800
  end
  else
    if str1 = '600 DPI' then
  begin
    dx := 600
  end
  else
    if str1 = '300 DPI' then
  begin
    dx := 300
  end
  else
    if str1 = '200 DPI' then
  begin
    dx := 200
  end
  else
    if str1 = '150 DPI' then
  begin
    dx := 150
  end
  else
    if str1 = '100 DPI' then
  begin
    dx := 100
  end
  else
    if str1 = '75 DPI' then
  begin
    dx := 75
  end
  else
    dx := 150;

  sx := sx * dx;
  sy := sy * dx;

  maxx := trunc(sx / fColumn) - bw;
  maxy := trunc(sy / fRow) - bw;

  Result := TCnsDMTable.Create(nil);
  k2 := 0;
  k_count := GetCountFromSetting;
  k_y_count := GetRowOrColmnCount;
  // k2,
  k2_y := 0;
  k2_x := 0;

  {$IFDEF DICOMDEBUGZ1}
  SendDebug(Format('Print %dX%d', [maxx, maxy]));
  {$ENDIF}
  for i := 0 to ADicomDatasets.Count - 1 do
  begin
    das1 := ADicomDatasets[i];

    if fEnable12bitsGrayscale and (das1.Attributes.ImageData.Bits > 8) then
    begin
      v1 := TDicomBitmap16.Create;
      DCM_ImageData_Bitmap16.AssignToBitmap(das1.Attributes.ImageData, v1, false);

      if fNeedResizeImage then
      begin
        if (MultiViewMode = mvmSTANDARDView) or (CustomViewSetting = '') then
        begin
          //dst.SetSize(maxx, maxy);
          dstWidth := maxx;
          dstHeight := maxy;
        end
        else
        begin
          k_x_count := GetRowOrColmn(k2_y);
          case MultiViewMode of
            mvmROWView:
              begin
                maxx := trunc(sx / k_x_count) - bw;
                maxy := trunc(sy / k_y_count) - bw;

                //dst.SetSize(maxx, maxy);
                dstWidth := maxx;
                dstHeight := maxy;
              end;
            mvmCOLUMNView:
              begin
                maxx := trunc(sx / k_y_count) - bw;
                maxy := trunc(sy / k_x_count) - bw;

                //dst.SetSize(maxx, maxy);
                dstWidth := maxx;
                dstHeight := maxy;
              end
          end;
          inc(k2_x);
          if k2_x = k_x_count then
          begin
            k2_x := 0;
            inc(k2_y);
            if k2_y = k_y_count then
            begin
              k2_y := 0;
            end;
          end;
        end;
      end
      else
      begin
        //dst.SetSize(bm.Width, bm.Height);
        dstWidth := v1.Width * 2;
        dstHeight := v1.Height * 2;
      end;

      f1 := Min(DstWidth / v1.Width, DstHeight / v1.Height);
      //f1 := Min(DicomView1.Width / v1.Width, DicomView1.Height / v1.Height);

      if (abs(das1.Attributes.ImageData.ViewerZoom - 1) > 0.01) or (das1.Attributes.ImageData.OffsetY <> 0)
        or (das1.Attributes.ImageData.OffsetX <> 0) then
        //      if abs(das1.Attributes.ImageData.ViewerZoom - 1) > 0.01 then
      begin
        f1 := das1.Attributes.ImageData.ViewerZoom * f1;

        AVerOff := Trunc(das1.Attributes.ImageData.OffsetY * f1);

        AHizOff := Trunc(das1.Attributes.ImageData.OffsetX * f1);

      end
      else
      begin
        AVerOff := Trunc((dstHeight - v1.Height * f1) / 2);
        AHizOff := Trunc((dstWidth - v1.Width * f1) / 2);
      end;

      v2 := ResizeBicubic(v1, f1);
      v3 := CutImage(v2, AHizOff, AVerOff, dstWidth, dstHeight);

      //das1.Attributes.ImageData.OverlayLabels(v3);
      DCM_ImageData_Bitmap16.LoadUserDrawObjectToBitmap(das1.Attributes.ImageData, v3, f1, AHizOff, AVerOff);
      if fPrintWithLabel then
      begin
        DCM_ImageData_Bitmap16.OverlayLabels(das1.Attributes.ImageData, v3, fPrintWindowWidthCenter);
        DCM_ImageData_Bitmap16.DrawImagePosition(das1.Attributes.ImageData, v3);

        //if PrintWithRightScale1.Checked then
      end;
      if fPrintWithRightScale or fPrintwithBottomScale then
        DCM_ImageData_Bitmap16.DrawImageScale(das1.Attributes.ImageData, v3, fPrintWithRightScale, fPrintwithBottomScale);

      das2 := TDicomDataset.Create(DCM_ImageData_Bitmap16.NewImageForPrint(v3, true));
      Result.AddDicomDataset(das2);

      //das1.SaveToFile('c:\16bit.dcm', true, 8194, 100);
      //das1.Free;
      v1.Free;
      V2.Free;
      V3.Free;
    end
    else //8bit print
    begin

      bm := TCnsBitmap32.Create;
      dst := TCnsBitmap32.Create;
      DCM_ImageData_Bitmap32.AssignToBitmap(das1.Attributes.ImageData, bm, false);

      //TNearestResampler.Create(Bitmap);

      //TLinearResampler.Create(Bitmap);

      //TKernelResampler.Create(bm);
      //TKernelResampler(bm.Resampler).Kernel := TCubicKernel.Create;
      bm.Resampler := TKernelResampler.Create(bm);
      TKernelResampler(bm.Resampler).Kernel := TCubicKernel.Create; //
      TKernelResampler(bm.Resampler).KernelMode := kmTableLinear; //kmTableNearest;
      TKernelResampler(bm.Resampler).TableSize := 100;
      TKernelResampler(bm.Resampler).PixelAccessMode := pamWrap;
      //    das1.Attributes.ImageData.LoadUserDrawObjectToBitmap(bm);

      if fNeedResizeImage then
      begin
        if (MultiViewMode = mvmSTANDARDView) or (CustomViewSetting = '') then
        begin
          dst.SetSize(maxx, maxy);
        end
        else
        begin
          k_x_count := GetRowOrColmn(k2_y);
          case MultiViewMode of
            mvmROWView:
              begin
                maxx := trunc(sx / k_x_count) - bw;
                maxy := trunc(sy / k_y_count) - bw;

                dst.SetSize(maxx, maxy);
              end;
            mvmCOLUMNView:
              begin
                maxx := trunc(sx / k_y_count) - bw;
                maxy := trunc(sy / k_x_count) - bw;

                dst.SetSize(maxx, maxy);
              end
          end;
          inc(k2_x);
          if k2_x = k_x_count then
          begin
            k2_x := 0;
            inc(k2_y);
            if k2_y = k_y_count then
            begin
              k2_y := 0;
            end;
          end;
        end;
      end
      else
      begin
        dst.SetSize(bm.Width, bm.Height);
      end;

      AT := TAffineTransformation.Create;
      AT.SrcRect := FloatRect(0, 0, bm.Width - 1, bm.Height - 1);
      f1 := Min(Dst.Width / bm.Width, Dst.Height / bm.Height);

      if abs(das1.Attributes.ImageData.ViewerZoom - 1) > 0.01 then
      begin
        f1 := das1.Attributes.ImageData.ViewerZoom * f1;

        AVerOff := Trunc(das1.Attributes.ImageData.OffsetY * f1);

        AHizOff := Trunc(das1.Attributes.ImageData.OffsetX * f1);

      end
      else
      begin
        AVerOff := Trunc((maxy - bm.Height * f1) / 2);
        AHizOff := Trunc((maxx - bm.Width * f1) / 2);
      end;

      AT.Scale(f1, f1);

      if (AVerOff <> 0) or (AHizOff <> 0) then
        AT.Translate(AHizOff, AVerOff);

      Transform(Dst, bm, AT);
      Bm.Free;
      AT.Free;

      DCM_ImageData_Bitmap32.LoadUserDrawObjectToBitmap(das1.Attributes.ImageData, dst, f1, AHizOff, AVerOff);
      if FPrintWithLabel then
        if FPrintLabelFirstImage then
        begin
          if (i = 0) then
          begin
            DCM_ImageData_Bitmap32.OverlayLabels(das1.Attributes.ImageData, dst, true);
            DCM_ImageData_Bitmap32.DrawImageScale(das1.Attributes.ImageData, dst, true, true);
          end;
        end
        else
        begin
          DCM_ImageData_Bitmap32.OverlayLabels(das1.Attributes.ImageData, dst, true);
          DCM_ImageData_Bitmap32.DrawImageScale(das1.Attributes.ImageData, dst, true, true);
        end;
      //    das1.Attributes.ImageData.DrawTopoLine(dst, das1.Attributes.ImageData.Zoom * f1, AHizOff, AVerOff);

      //dst.SaveToFile('b' + IntToStr(i) + '.bmp');
      //das1.Attributes.Free;
      das2 := TDicomDataset.Create(DCM_ImageData_Bitmap32.NewImageForPrint(dst, not fIsColor));

      //das2.SaveToFile('PRINT' + IntToStr(i) + '.DCM', true, 8194, 100);

      Result.AddDicomDataset(das2);

      dst.Free;
    end;
  end;
end;

function TCnsDicomConnectionThread.ReSizeAllImage(AIndex: Integer; ADataset: TDicomDataset): TDicomAttributes;
var
  //  i: Integer;
  maxX, maxY: integer;
  bm, dst: TCnsBitmap32;
  AT: TAffineTransformation;
  f1, sx, sy, dx: Double;
  AVerOff, AHizOff: Integer;
  str1: AnsiString;
begin
  //cal from dicom printer filmsize and resolusion
  str1 := fFilmSize;
  if str1 = '14INX17IN' then
  begin
    sx := 14;
    sy := 17;
  end
  else
    if str1 = '14INX14IN' then
  begin
    sx := 14;
    sy := 14;
  end
  else
    if str1 = '11INX17IN' then
  begin
    sx := 11;
    sy := 17;
  end
  else
    if str1 = '11INX14IN' then
  begin
    sx := 11;
    sy := 14;
  end
  else
    if str1 = '10INX14IN' then
  begin
    sx := 10;
    sy := 14;
  end
  else
    if str1 = '10INX12IN' then
  begin
    sx := 10;
    sy := 12;
  end
  else
    if str1 = '8_5INX11IN' then
  begin
    sx := 8.5;
    sy := 11;
  end
  else
    if str1 = '8INX10IN' then
  begin
    sx := 8;
    sy := 10;
  end
  else
    if str1 = '24CMX30CM' then
  begin
    sx := 24 / 2.54;
    sy := 30 / 2.54;
  end
  else
    if str1 = '24CMX24CM' then
  begin
    sx := 24 / 2.54;
    sy := 24 / 2.54;
  end
  else
    if str1 = 'A4' then
  begin
    sx := 21 / 2.54;
    sy := 29.7 / 2.54;
  end
  else
    if str1 = 'A3' then
  begin
    sx := 29.7 / 2.54;
    sy := 42 / 2.54;
  end
  else
    raise Exception.Create('Error paper or film size setting');

  if fPrintOrientation <> 'PORTRAIT' then
  begin
    f1 := sx;
    sx := sy;
    sy := f1;
  end;
  str1 := fResolution;
  if str1 = '1200 DPI' then
  begin
    dx := 1200
  end
  else
    if str1 = '600 DPI' then
  begin
    dx := 600
  end
  else
    if str1 = '300 DPI' then
  begin
    dx := 300
  end
  else
    if str1 = '200 DPI' then
  begin
    dx := 200
  end
  else
    if str1 = '150 DPI' then
  begin
    dx := 150
  end
  else
    if str1 = '100 DPI' then
  begin
    dx := 100
  end
  else
    if str1 = '75 DPI' then
  begin
    dx := 75
  end
  else
    dx := 150;

  sx := sx * dx;
  sy := sy * dx;

  maxx := trunc(sx / fColumn) - bw;
  maxy := trunc(sy / fRow) - bw;

  bm := TCnsBitmap32.Create;
  dst := TCnsBitmap32.Create;
  DCM_ImageData_Bitmap32.AssignToBitmap(ADataset.Attributes.ImageData, bm, false);

  //TNearestResampler.Create(Bitmap);

  //TLinearResampler.Create(Bitmap);

  //TKernelResampler.Create(bm);
  //TKernelResampler(bm.Resampler).Kernel := TCubicKernel.Create;

  bm.Resampler := TKernelResampler.Create(bm);
  TKernelResampler(bm.Resampler).Kernel := TCubicKernel.Create; //
  TKernelResampler(bm.Resampler).KernelMode := kmTableLinear; //kmTableNearest;
  TKernelResampler(bm.Resampler).TableSize := 100;
  TKernelResampler(bm.Resampler).PixelAccessMode := pamWrap;
  //ADataset.Attributes.ImageData.LoadUserDrawObjectToBitmap(bm);

  {  hx := Min(maxx, maxy);
    if hx < 320 then
      hx := 320;
    if hx > 2000 then
      hx := 2000;
    hx := (hx div 16) * 16;
    dst.SetSize(hx, hx);}
  if fNeedResizeImage then
    dst.SetSize(maxx, maxy)
  else
    dst.SetSize(bm.Width, bm.Height);

  AT := TAffineTransformation.Create;
  AT.SrcRect := FloatRect(0, 0, bm.Width - 1, bm.Height - 1);
  f1 := Math.Min(Dst.Width / bm.Width, Dst.Height / bm.Height);

  if abs(ADataset.Attributes.ImageData.ViewerZoom - 1) > 0.01 then
  begin
    f1 := ADataset.Attributes.ImageData.ViewerZoom * f1;

    AVerOff := Trunc(ADataset.Attributes.ImageData.OffsetY * f1);

    AHizOff := Trunc(ADataset.Attributes.ImageData.OffsetX * f1);

  end
  else
  begin
    AVerOff := Trunc((dst.Height - bm.Height * f1) / 2);
    AHizOff := Trunc((dst.Width - bm.Width * f1) / 2);
  end;

  AT.Scale(f1, f1);

  if (AVerOff <> 0) or (AHizOff <> 0) then
    AT.Translate(AHizOff, AVerOff);

  Transform(Dst, bm, AT);
  Bm.Free;
  AT.Free;

  DCM_ImageData_Bitmap32.LoadUserDrawObjectToBitmap(ADataset.Attributes.ImageData, dst, f1, AHizOff, AVerOff);

  if FPrintWithLabel then
    if FPrintLabelFirstImage then
    begin
      if (AIndex = 0) then
        DCM_ImageData_Bitmap32.OverlayLabels(ADataset.Attributes.ImageData, dst, true);
    end
    else
    begin
      DCM_ImageData_Bitmap32.OverlayLabels(ADataset.Attributes.ImageData, dst, true);
    end;

  //    das1.Attributes.ImageData.DrawTopoLine(dst, das1.Attributes.ImageData.Zoom * f1, AHizOff, AVerOff);

  //dst.SaveToFile('b' + IntToStr(i) + '.bmp');
  //das1.Attributes.Free;
  Result := DCM_ImageData_Bitmap32.NewImageForPrint(dst, not fIsColor);

  //das2.SaveToFile('PRINT' + IntToStr(i) + '.DCM', true, 8194, 100);

  //fList.Add(das2);

  dst.Free;
end;

procedure TCnsDicomConnectionThread.DoPrint;
label
  Retry_to_print_film;
var
  msgid: Integer;
  tx, da1: TDicomAttribute;
 { das1,} cmd1, ImageSequenceHolder, Printer, Session, Filmbox, RefSessionItem: TDicomAttributes;
  KxDcmClient1: TCnsDicomConnection;
  imno: Integer;
  imnofilm: Integer;
  uidint: Integer;
  uidroot: AnsiString;
  BFSUID, FilmboxUID: AnsiString;
  r: TDicomResponse;
  pcid1: Byte;
  status1: Integer;
  ste1: TStatusEntry;

  printdas1: TDicomDatasets;

  RetryCount: Integer;

  filmcount: Integer;
begin
  uidint := 0;
  msgid := 1;
  Printer := nil;
  fErrorMessage := '';
  //uidroot := '1.2.40.0.13.0.192.168.1.10.17818297.1060271648171.';
  if assigned(FOnWorkStart) then
    FOnWorkStart(self);

  printdas1 := nil; //ReSizeAllImageEx(fCurrentDatasets);

  if assigned(OnAfterSend) then
  begin
    OnAfterSend(self, 1);
  end;

  printdas1 := ReSizeAllImageEx(fCurrentDatasets);

  RetryCount := 1;
  KxDcmClient1 := TCnsDicomConnection.Create(nil);
  try
    KxDcmClient1.ResetSynTax;

    KxDcmClient1.Host := Host;
    KxDcmClient1.Port := Port;
    KxDcmClient1.CalledTitle := CalledTitle;
    KxDcmClient1.CallingTitle := CallingTitle;
    KxDcmClient1.ReceiveTimeout := fReceiveTimeout;

    KxDcmClient1.AddPresentationContext(Verification);
    if IsColor then
      KxDcmClient1.AddPresentationContext(BasicColorPrintManagementMetaSOPClass)
    else
      KxDcmClient1.AddPresentationContext(BasicGrayscalePrintManagementMetaSOPClass); //
    KxDcmClient1.AddPresentationContext(BasicAnnotationBox);
    KxDcmClient1.AddPresentationContext(BasicPrintImageOverlayBox);
    KxDcmClient1.AddPresentationContext(PresentationLUT);
    KxDcmClient1.AddPresentationContext(PrintJob);
    KxDcmClient1.AddPresentationContext(PrinterConfigurationRetrieval);
    {$IFDEF DICOMDEBUGZ1}
    SendDebug(Format('Begin to print to %s:%d,%d', [Host, Port, fReceiveTimeout]));
    {$ENDIF}
    Retry_to_print_film:
    try
      KxDcmClient1.Connect;
    except
      on e: Exception do
      begin
        fErrorMessage := e.Message + '(Retry ' + IntToStr(RetryCount) + ')';
        if fFormHandle > 0 then
          PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
            {else
if ModuleIsLib then
TiggleErrorEvent}
        else
          Synchronize(TiggleErrorEvent);
        //exit;
      end;
    end;
    {$IFDEF DICOMDEBUGZ1}
    SendDebug('connected' + fErrorMessage);
    {$ENDIF}
    if fErrorMessage <> '' then
    begin
      fErrorMessage := '';
      inc(RetryCount);
      if RetryCount <= 3 then
        goto Retry_to_print_film
      else
        exit;
    end;

    try
      r := KxDcmClient1.SendRequest;
    except
      on e: Exception do
      begin
        fErrorMessage := V_CONNECT_REJECT_ERROR + e.Message;

        {$IFDEF DICOMDEBUGZ1}
        SendDebug('SendRequest error:' + fErrorMessage);
        {$ENDIF}

        if fFormHandle > 0 then
          PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
            {else
if ModuleIsLib then
TiggleErrorEvent}
        else
          Synchronize(TiggleErrorEvent);

        exit;
      end;
    end;
    {$IFDEF DICOMDEBUGZ1}
    SendDebug('SendRequest:' + fErrorMessage);
    {$ENDIF}
    if r = nil then
    begin
      fErrorMessage := dcmDicomConnectNoACK;
      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
          {else
if ModuleIsLib then
TiggleErrorEvent}
      else
        Synchronize(TiggleErrorEvent);

      exit;
    end
    else
      if r is TDicomAbort then
    begin
      fErrorMessage := 'Abort ' + TDicomAbort(r).Text;
      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
          {else
if ModuleIsLib then
TiggleErrorEvent}
      else
        Synchronize(TiggleErrorEvent);
      exit;
    end
    else
      if r is TDicomReject then
    begin
      fErrorMessage := 'Reject ' + TDicomReject(r).Text;
      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
          {else
if ModuleIsLib then
TiggleErrorEvent}
      else
        Synchronize(TiggleErrorEvent);
      exit;
    end
    else
      if r is TAcknowledge then
    begin

    end
    else
    begin
      fErrorMessage := 'Reject ';
      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
          {else
if ModuleIsLib then
TiggleErrorEvent}
      else
        Synchronize(TiggleErrorEvent);
      exit;
    end;
    {$IFDEF DICOMDEBUGZ1}
    SendDebug('After connect ' + fErrorMessage);
    {$ENDIF}
    uidroot := '1.2.40.0.13.0.' + IntToStr(Round(now * 10000)) + '.';

    //uidroot := '1.2.40.0.13.0.' + KxDcmClient1.GetLocalIP + '.' + FormatDatetime('yyyymmdd.hhnnsszzzz', now) + '.';
    //printdas1 := ReSizeAllImageEx(fCurrentDatasets);

    if assigned(OnAfterSend) then
    begin
      OnAfterSend(self, 2);
    end;

    if fIsColor then
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicColorPrintManagementMetaSOPClass)
    else
      pcid1 :=
        KxDcmClient1.FAssociation.getPresentationContext(BasicGrayscalePrintManagementMetaSOPClass);

    cmd1 := createNGetRequest(msgid, uidPrinter, UIDS.AsString(PrinterModelSOPInstance));
    inc(msgid);
    if KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
    begin
      cmd1.Free;
      if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
      begin
        Printer := KxDcmClient1.FAssociation.ReceiveDatasets[0];
        KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
        //        Printer.ListAttrinute('printer:', KxForm.Memo1.Lines);
      end;
    end
    else
    begin
      fErrorMessage := 'Get DICOM PRINTER info error! The distinct reject!';
      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
          {else
if ModuleIsLib then
TiggleErrorEvent}
      else
        Synchronize(TiggleErrorEvent);
      exit;
    end;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      fErrorMessage := ste1.toString;
      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
          {else
if ModuleIsLib then
TiggleErrorEvent}
      else
        Synchronize(TiggleErrorEvent);
      exit;
    end;

    Session := TDicomAttributes.Create;
    Session.AddVariant($2000, $10, fCopys); // copies

    {.$IFDEF SEND_ALL_PRINT_PARAM}
    //if PrintWithDefaultParam then
    begin
      Session.AddVariant($2000, $20, 'HIGH');
      Session.AddVariant($2000, $30, fMediumType);
      Session.AddVariant($2000, $40, fFilmDestination); //film  grid
    end;
    {.$ENDIF}
    {receive dataset>:706[2000:0020](PrintPriority)CS=<1>HIGH
    receive dataset>:707[2000:0030](MediumType)CS=<1>BLUE FILM
    receive dataset>:708[2000:0040](FilmDestination)CS=<1>BIN_1
    }
    inc(uidint);
    {$IFNDEF USE_NULL_UID_ROOT}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, uidroot + IntToStr(uidint), true);
    {$ELSE}
    cmd1 := createCreateRequest(msgid, BasicFilmSession, '', true);
    {$ENDIF}
    inc(msgid);
    if KxDcmClient1.SendCommand(pcid1, cmd1, Session) then
    begin
      cmd1.Free;
      Session.Free;
    end
    else
      exit;

    status1 := KxDcmClient1.GetState;
    if status1 <> 0 then
    begin
      ste1 := DicomStatus.getStatusEntry(status1);
      fErrorMessage := ste1.toString;
      if fFormHandle > 0 then
        PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
          {else
if ModuleIsLib then
TiggleErrorEvent}
      else
        Synchronize(TiggleErrorEvent);
      exit;
    end;

    BFSUID := uidroot + IntToStr(uidint);
    imno := fFromIndex;
    filmcount := 0;
    while (imno < printdas1.Count) and (filmcount < fLimitCount) do
    begin
      if Terminated then
        exit;
      imnofilm := 0;

      Filmbox := TDicomAttributes.Create;
      try
        Filmbox.AddVariant($2010, $10, fPrintFormat); //'STANDARD\2,1');
        Filmbox.AddVariant($2010, $40, fPrintOrientation); //'PORTRAIT'); //LANDSCAPE
        Filmbox.AddVariant($2010, $50, fFilmSize); //'14INx17IN');

        {.$IFDEF SEND_ALL_PRINT_PARAM}
        if FPrintWithDefaultParam then
        begin
          Filmbox.AddVariant($2010, $60, fMagnificationType); //OptionsBox.Magnification

          Filmbox.AddVariant($2010, $80, fSmoothingType); //SmoothingType
          Filmbox.AddVariant($2010, $100, fBorderDensity); //"BLACK"   BorderDensity
          Filmbox.AddVariant($2010, $110, fEmptyImageDensity); //"BLACK"   EmptyImageDensity
          Filmbox.AddVariant($2010, $120, fMinDensity); //MinDensity
          Filmbox.AddVariant($2010, $130, fMaxDensity); //MaxDensity
          Filmbox.AddVariant($2010, $140, fTrim); //"NO"   //Trim
          {receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
          receive dataset>:719[2010:0100](BorderDensity)CS=<1>BLACK
          receive dataset>:720[2010:0110](EmptyImageDensity)CS=<1>1
          receive dataset>:721[2010:0120](MinDensity)US=<1>2
          receive dataset>:722[2010:0130](MaxDensity)US=<1>250
          receive dataset>:723[2010:0140](Trim)CS=<1>YES
          }
        end;
        {.$ENDIF}
        RefSessionItem := TDicomAttributes.Create;
        RefSessionItem.AddVariant(8, $1150, UIDS.AsString(BasicFilmSession));
        //doSOP_BasicFilmSession
        {$IFNDEF USE_NULL_UID_ROOT}
        RefSessionItem.AddVariant(8, $1155, BFSUID);
        {$ELSE}
        RefSessionItem.Add(8, $1155);
        {$ENDIF}
        da1 := Filmbox.Add($2010, $500);
        da1.AddData(RefSessionItem);

        uidint := uidint + 1;

        {$IFNDEF USE_NULL_UID_ROOT}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, uidroot + IntToStr(uidint), true);
        {$ELSE}
        cmd1 := createCreateRequest(msgid, BasicFilmBox, '', true);
        {$ENDIF}
        inc(msgid);
        if KxDcmClient1.SendCommand(pcid1, cmd1, Filmbox) then
        begin
          cmd1.Free;
          Filmbox.Free;
          Filmbox := nil;
          if KxDcmClient1.FAssociation.ReceiveDatasets.Count > 0 then
          begin
            Filmbox := KxDcmClient1.FAssociation.ReceiveDatasets[0];
            KxDcmClient1.FAssociation.ReceiveDatasets.Clear;
            //            Filmbox.ListAttrinute('Filmbox:', KxForm.Memo1.Lines);
          end
          else
          begin
            fErrorMessage := dcmDicomPrintFilmCreatingError;
            if fFormHandle > 0 then
              PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
                {else
if ModuleIsLib then
TiggleErrorEvent}
            else
              Synchronize(TiggleErrorEvent);
            exit;
          end;
        end
        else
          exit;
        FilmboxUID := uidroot + IntToStr(uidint);
        if assigned(FilmBox) then
        begin
          tx := Filmbox.Item[$2010, $510];
          if (not assigned(tx)) or (tx.GetCount <= 0) then
          begin
            fErrorMessage := V_DICOM_PRINT_FILMBOX_ERROR;
            if fFormHandle > 0 then
              PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
                {else
if ModuleIsLib then
TiggleErrorEvent}
            else
              Synchronize(TiggleErrorEvent);
            exit;
          end;
          while (imno < printdas1.Count) and (imnofilm < tx.GetCount) do
          begin
            if Terminated then
              break;
            ImageSequenceHolder := TDicomAttributes.Create;

            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if PrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, fMagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, fSmoothingType); //SmoothingType
              //ImageSequenceHolder.AddVariant($2020, $20, fPolarity); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            //das1 := ReSizeAllImage(imnofilm, TDicomDataset(printdas1[imno]));
            //ImageSequenceHolder.Add($2020, $110).AddData(das1);

            ImageSequenceHolder.Add($2020, $110).AddData(printdas1.Item[imno].Attributes);
            printdas1.Item[imno].RecreateAttributes;

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox,
              tx.Attributes[imnofilm].GetString(8, $1155));
            inc(msgid);
            try
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                exit;
            finally
              cmd1.Free;
              //ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;
            fPosition := imno;
            //TiggleSendEvent;
            if assigned(OnAfterSend) then
            begin
              OnAfterSend(self, imno + 2);
            end;

            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end
        else
        begin
          while (imno < printdas1.Count) do //and (imnofilm < fLimitCount) do
          begin
            if Terminated then
              break;
            ImageSequenceHolder := TDicomAttributes.Create;

            {.$IFDEF SEND_ALL_PRINT_PARAM}
            if PrintWithDefaultParam then
            begin
              ImageSequenceHolder.AddVariant($2010, $60, fMagnificationType); //MagnificationType
              ImageSequenceHolder.AddVariant($2010, $80, fSmoothingType); //SmoothingType
              //ImageSequenceHolder.AddVariant($2020, $20, fPolarity); //Polarity
            end;
            {.$ENDIF}

            ImageSequenceHolder.AddVariant($2020, $10, imnofilm + 1);
            {receive dataset>:717[2010:0060](MagnificationType)CS=<1>BILINEAR
            receive dataset>:718[2010:0080](SmoothingType)CS=<1>SHARP
            receive dataset>:730[2020:0020](Polarity)CS=<1>REVERSE
            }
            //das1 := ReSizeAllImage(imnofilm, TDicomDataset(fList[imno]));
            //ImageSequenceHolder.Add($2020, $110).AddData(das1);

            ImageSequenceHolder.Add($2020, $110).AddData(printdas1.Item[imno].Attributes);
            printdas1.Item[imno].RecreateAttributes;

            //ImageSequenceHolder.Add($2020, $110).AddData(TDicomDataset(fList[imno]).Attributes);

            cmd1 := createSetRequest(msgid, BasicGrayscaleImageBox, '');
            inc(msgid);
            try
              if not KxDcmClient1.SendCommand(pcid1, cmd1, ImageSequenceHolder) then
                break;
            finally
              cmd1.Free;
              //ImageSequenceHolder.Item[$2020, $110].ClearDataArray;
              ImageSequenceHolder.Free;
            end;
            fPosition := imno;
            //TiggleSendEvent;
            if assigned(OnAfterSend) then
            begin
              OnAfterSend(self, imno + 2);
            end;
            imno := imno + 1;
            imnofilm := imnofilm + 1;
          end;
        end;

        cmd1 := createActionRequest(msgid, BasicFilmBox, FilmboxUID, False, 1);
        inc(msgid);
        try
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
          begin
            status1 := KxDcmClient1.GetState;
            if status1 <> 0 then
            begin
              ste1 := DicomStatus.getStatusEntry(status1);
              fErrorMessage := ste1.toString;
              if fFormHandle > 0 then
                PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, 0)
                  {else
if ModuleIsLib then
TiggleErrorEvent}
              else
                Synchronize(TiggleErrorEvent);
              exit;
            end;
            exit;
          end;
        finally
          cmd1.Free;
        end;

        cmd1 := createDeleteRequest(msgid, BasicFilmBox, FilmboxUID);
        inc(msgid);
        try
          if not KxDcmClient1.SendCommand(pcid1, cmd1, nil) then
            exit;
        finally
          cmd1.Free;
        end;

      finally
        if assigned(Filmbox) then
          Filmbox.Free;
      end;

      inc(filmcount);
    end;
  finally
    if assigned(Printer) then
      Printer.Free;
    //    KxDcmClient1.Disconnect;
    KxDcmClient1.Free;

    //fCurrentDatasets.Free;
    //fCurrentDatasets := nil;

    if printdas1 <> nil then
      printdas1.Free;
  end;
end;

procedure TCnsDicomConnectionThread.TiggleReceiveEvent;
begin
  if assigned(OnReceive) {and assigned(fCurrentDataset)} then
    OnReceive(self, fCurrentDataset);
end;

procedure TCnsDicomConnectionThread.TiggleMReceiveEvent;
begin
  if assigned(fOnIconReceive) then
    fOnIconReceive(self, fIconCommandDataset);
end;

procedure TCnsDicomConnectionThread.TiggleSendEvent;
begin
  if assigned(OnAfterSend) then
  begin
    OnAfterSend(self, fPosition);
  end;
end;

procedure TCnsDicomConnectionThread.TiggleErrorEvent;
begin
  if assigned(fOnError) then
    fOnError(self);
end;

procedure TCnsDicomConnectionThread.SetReceiveTimeout(Value: integer);
begin
  if fReceiveTimeout <> Value then
    fReceiveTimeout := Value;
end;

function TCnsDicomConnectionThread.GetCountFromSetting: Integer;
var
  str1: string;
  i: Integer;
  strs1: TStringList;
begin
  Result := 0;
  if CustomViewSetting <> '' then
  begin
    strs1 := TStringList.Create;
    try
      strs1.Text := StringReplace(CustomViewSetting, ',', #13#10, [rfReplaceAll]);
      for i := 0 to strs1.count - 1 do
      begin
        str1 := strs1[i];
        if str1 <> '' then
          Result := Result + StrToInt(str1);
      end;
    finally
      strs1.Free;
    end;
  end
  else
    Result := (Row * Column);
end;

function TCnsDicomConnectionThread.GetRowOrColmn(AIndex: Integer): Integer;
var
  str1: string;
  strs1: TStringList;
begin
  Result := 0;
  if CustomViewSetting <> '' then
  begin
    strs1 := TStringList.Create;
    try
      strs1.Text := StringReplace(CustomViewSetting, ',', #13#10, [rfReplaceAll]);
      if AIndex < strs1.count then
      begin
        str1 := strs1[AIndex];
        if str1 <> '' then
          Result := StrToInt(str1);
      end;
    finally
      strs1.Free;
    end;
  end
  else
    Result := Column;
end;

function TCnsDicomConnectionThread.GetRowOrColmnCount: Integer;
var
  strs1: TStringList;
begin
  Result := 0;
  if CustomViewSetting <> '' then
  begin
    strs1 := TStringList.Create;
    try
      strs1.Text := StringReplace(CustomViewSetting, ',', #13#10, [rfReplaceAll]);
      Result := strs1.count;
    finally
      strs1.Free;
    end;
  end
  else
    Result := Row;
end;

procedure TCnsDicomConnectionThread.DoLoadFromDicomDIR;
var
  str1: AnsiString;
  dd1: TDicomDataset;
begin
  fImageTable.First;

  while not fImageTable.Eof do
  begin
    if Terminated then
      exit;
    str1 := Trim(fImageTable.FieldByName('INSTANCEUID').AsString);

    if FileExists(str1) then
    begin
      dd1 := TDicomDataset.Create;
      if dd1.LoadFromFile(str1, false) then
      begin
        fList.Add(dd1);
        fCurrentDataset := dd1;

        if fFormHandle > 0 then
        begin
          CurrentDatasets.AddDicomDataset(dd1);
          PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1)
        end
          {else
            if ModuleIsLib then
            TiggleReceiveEvent}
        else
          if FUseSynchronizeEvent then
          Synchronize(TiggleReceiveEvent)
        else
          TiggleReceiveEvent;
      end
      else
        dd1.Free;
    end
    else
    begin
      str1 := fImagePath + str1;
      if FileExists(str1) then
      begin
        dd1 := TDicomDataset.Create;
        if dd1.LoadFromFile(str1, false) then
        begin
          fList.Add(dd1);
          fCurrentDataset := dd1;
          if fFormHandle > 0 then
          begin
            CurrentDatasets.AddDicomDataset(dd1);
            PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1)
          end
            {else
              if ModuleIsLib then
              TiggleReceiveEvent}
          else
            if FUseSynchronizeEvent then
            Synchronize(TiggleReceiveEvent)
          else
            TiggleReceiveEvent;
        end
        else
          dd1.Free;
      end
    end;
    fImageTable.Next;
  end;
end;

function TCnsDicomConnectionThread.TestFile(Query1: TDataset; basedir: AnsiString): AnsiString;
var
  pname: AnsiString;
begin
  pname := basedir + Trim(Query1.FieldByName('SERIESUID').AsString) + '\' +
    Trim(Query1.FieldByName('IMGNO').asstring) + '.dcm';
  if FileExists(pname) then
    Result := pname
  else
  begin
    pname := basedir + Trim(Query1.FieldByName('SERIESUID').AsString) + '\' +
      Trim(Query1.FieldByName('INSTANCEUID').asstring) + '.dcm';
    if FileExists(pname) then
      Result := pname
    else
    begin
      pname := basedir + ' ' + Trim(Query1.FieldByName('SERIESUID').AsString) + '\' +
        Trim(Query1.FieldByName('IMGNO').asstring) + '.dcm';
      if FileExists(pname) then
        Result := pname
      else
        Result := '';
    end;
  end;
end;

function TCnsDicomConnectionThread.TestDcmFileDir(AQuery: TDataset; var AImageDir: AnsiString):
  Boolean;
  function TestDir(ADir: AnsiString; ADate: TDatetime; ImageType: AnsiString): Boolean;
  var
    y, m, d: Word;
    str1: AnsiString;
  begin
    DecodeDate(adate, y, m, d);
    Result := false;
    if ADir[Length(ADir)] <> '\' then
      adir := adir + '\';
    if ImageType <> '' then
    begin
      str1 := adir + ImageType + '\' + IntToStr(y) + '\' + IntToStr(m) + '\' + IntToStr(d) + '\' +
        Trim(AQuery.FieldByName('STUDYUID').AsString) + '\';
    end
    else
    begin
      str1 := adir + Trim(AQuery.FieldByName('STUDYUID').AsString) + '\';
    end;
    if DirectoryExists(str1) then
    begin
      AImageDir := str1;
      Result := true;
    end
    else
    begin
      str1 := adir + Trim(AQuery.FieldByName('STUDYUID').AsString) + '\';
      if DirectoryExists(str1) then
      begin
        AImageDir := str1;
        Result := true;
      end;
    end;
  end;
var
  date1: TDatetime;
  ImageType: AnsiString;
  f1: TField;
begin

  f1 := AQuery.FindField('STUDIESDATE');
  if not assigned(f1) then
    f1 := AQuery.FindField('IMAGEDATE');

  date1 := f1.AsDatetime;
  //  ImageType := AQuery.FieldByName('ImageType').AsString;
  ImageType := Trim(AQuery.FieldByName('IMAGETYPE').AsString);
  Result := TestDir(fImagePath, date1, ImageType);
  if Result then
    exit;
  {for i := 0 to KXConfig.ImagePathList.Count - 1 do
  begin
    if KXConfig.ImagePathList[i] <> '' then
    begin
      Result := TestDir(KXConfig.ImagePathList[i], date1, ImageType);
      if Result then
        exit;
    end;
  end; }
  //    AQuery.Next;
end;

procedure TCnsDicomConnectionThread.DoLoadFromFiles;
  procedure SetSelectFrame(ADataset: TDicomDataset; const AStr: AnsiString);
  var
    strs1: TStringList;
    i, k: Integer;
  begin
    strs1 := TStringList.Create;
    strs1.Text := AStr;
    try
      for i := 0 to strs1.Count - 1 do
      begin
        if strs1[i] <> '' then
        begin
          k := StrToInt(strs1[i]);
          ADataset.Attributes.ImageData.ImageData[k].Selected := true;
        end
      end;
    finally
      strs1.Free;
    end;
  end;
var
  basedir, pname, str1: AnsiString;
  dd1: TDicomDataset;
begin
  fImageTable.First;
  if not fImageTable.eof then
  begin
    //      i1 := 1;   \
    str1 := '';
    basedir := '';
    if TestDcmFileDir(fImageTable, basedir) then
    begin
      while not fImageTable.Eof do
      begin
        if Terminated then
          exit;

        pname := TestFile(fImageTable, basedir);
        if (pname <> '') then
        begin
          if (str1 <> Trim(fImageTable.FieldByName('SERIESUID').AsString)) then
          begin
            if (str1 <> '') then
            begin
              fCurrentDataset := nil;
              if fFormHandle > 0 then
                PostMessage(fFormHandle, WM_DICOM_CNS_ERROR, FQueueIndex, -1)
                  {else
if ModuleIsLib then
TiggleReceiveEvent}
              else
                if FUseSynchronizeEvent then
                Synchronize(TiggleReceiveEvent)
              else
                TiggleReceiveEvent;
            end;
            str1 := Trim(fImageTable.FieldByName('SERIESUID').AsString);
          end;
          dd1 := TDicomDataset.Create;
          if dd1.LoadFromFile(pname, true) then
          begin
            dd1.Attributes.AddVariant($2809, $001B,
              fImageTable.FieldByName('SELECTEDINDEX').AsInteger);
            dd1.Attributes.AddVariant($2809, $001C, fImageTable.FieldByName('IMAGEFLAG').AsString);
            dd1.Attributes.AddVariant($2809, $001D,
              fImageTable.FieldByName('SELECTEDINDEX1').AsInteger);
            dd1.Attributes.AddVariant($2809, $001E,
              fImageTable.FieldByName('SELECTEDINDEX2').AsInteger);
            dd1.Attributes.AddVariant($2809, $001F,
              fImageTable.FieldByName('SELECTEDINDEX3').AsInteger);
            dd1.Attributes.AddVariant($2809, $2000,
              fImageTable.FieldByName('LAST_WINDOWS_CENTER').AsInteger);
            dd1.Attributes.AddVariant($2809, $2001,
              fImageTable.FieldByName('LAST_WINDOWS_WIDTH').AsInteger);
            //                    dd1.Attributes.AddVariant($2809, $2001, '');
            dd1.Attributes.Sort;
            SetSelectFrame(dd1, fImageTable.FieldByName('SELFRAME').AsString);

            fList.Add(dd1);
            fCurrentDataset := dd1;

            if fFormHandle > 0 then
            begin
              CurrentDatasets.AddDicomDataset(dd1);
              PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1)
            end
              {else
                if ModuleIsLib then
                TiggleReceiveEvent}
            else
              if FUseSynchronizeEvent then
              Synchronize(TiggleReceiveEvent)
            else
              TiggleReceiveEvent;
          end
          else
            dd1.Free;
        end;
        fImageTable.Next;
      end;
    end; //ensure dir exists
  end;
end;

procedure TCnsDicomConnectionThread.LoadFromDicomDIR(AImagePath: AnsiString;
  AImageDataset: TDataset);
begin
  fImageTable := AImageDataset;
  fImagePath := AImagePath;
  fCommand := dctcLoadFromDicomDIR;

  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    Resume;
end;

procedure TCnsDicomConnectionThread.LoadFromFiles(AImagePath: AnsiString; AImageDataset: TDataset);
begin
  fImageTable := AImageDataset;
  fImagePath := AImagePath;
  fCommand := dctcLoadFromFiles;

  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    Resume;
end;

procedure TCnsDicomConnectionThread.DoWadoGet;
var
  stm1: TMemoryStream;
  das1: TDicomDataset;
  str1: AnsiString;
  da1: TDicomAttribute;
  das: TDicomAttributes;
  i: Integer;
begin
  {$IFDEF DICOMDEBUGZ1}
  SendDebug('start wado');
  {$ENDIF}

  if (fDataset <> nil) and (fURL <> '') then
  begin
    da1 := fDataset.Attributes.Item[$2809, $2B];
    {$IFDEF DICOMDEBUGZ1}
    SendDebug('start wado ' + IntToStr(da1.GetCount));
    {$ENDIF}
    if assigned(FOnWorkStart) then
      FOnWorkStart(self);

    for i := 0 to da1.GetCount - 1 do
    begin
      if Terminated then
        break;
      das := da1.Attributes[i];
      //if AOnlyLoadKeyImage then
      //  AddVariant($2813, $0120, 1);

      str1 := fURL + '/WADO?requestType=WADO' +
        '&studyUID=' + das.GetString($20, $D) +
        '&seriesUID=' + das.GetString($20, $E) +
        '&objectUID=' + das.GetString($8, $18) +
        '&contentType=application%2Fdicom';
      if fWadoTransferSyntax <> '' then
        str1 := str1 + '&transferSyntax=' + fWadoTransferSyntax;
      //'&transferSyntax=1.2.840.10008.1.2.4.90';

      //showmessage(str1);
      {$IFDEF DICOMDEBUGZ1}
      SendDebug(str1);
      {$ENDIF}
      stm1 := TMemoryStream.Create;
      try
        try
          if assigned(fOnHttpGet) then
            fOnHttpGet(self, str1, stm1);
        except
        end;
        {$IFDEF DICOMDEBUGZ1}
        SendDebug('file size ' + IntToStr(stm1.Size));
        {$ENDIF}
        if Terminated then
          break;
        if stm1.Size > 0 then
        begin
          //stm1.SaveToFile('c:\t5.dcm');
          stm1.Position := 0;
          das1 := TDicomDataset.Create;
          try
            das1.LoadFromStream(stm1);
          except
            on e: Exception do
            begin
              {$IFDEF DICOMDEBUGZ1}
              SendDebug(e.Message);
              {$ENDIF}
              fErrorMessage := e.Message;
            end;
          end;

          if Terminated then
          begin
            das1.Free;
            fCurrentDataset := nil;
            break;
          end;

          fCurrentDataset := das1;
          if fFormHandle > 0 then
          begin
            CurrentDatasets.AddDicomDataset(das1);
            PostMessage(fFormHandle, WM_DICOM_CNS_RECEIVE, FQueueIndex, CurrentDatasets.Count - 1)
          end
            {else
              if ModuleIsLib then
              TiggleReceiveEvent}
          else
            if FUseSynchronizeEvent then
            Synchronize(TiggleReceiveEvent)
          else
            TiggleReceiveEvent;
          //if assigned(fOnReceive) then
          //  fOnReceive(self, das1);
        end;

      finally
        stm1.Free;
      end;
    end;
  end;
end;

procedure TCnsDicomConnectionThread.WadoImages(AURL, ATransferSyntax: AnsiString;
  ADataset: TDicomDataset; AOnlyLoadKeyImage: Boolean);
begin
  fOnlyLoadKeyImage := AOnlyLoadKeyImage;

  fURL := AURL;
  fDataset := ADataset;
  fWadoTransferSyntax := ATransferSyntax;

  fCommand := dctcWadoGetImage;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    Resume;
end;

procedure TCnsDicomConnectionThread.DoSendEx;
begin

end;

procedure TCnsDicomConnectionThread.SetNeedResizeImage(
  const Value: Boolean);
begin
  FNeedResizeImage := Value;
end;

procedure TCnsDicomConnectionThread.SetFormHandle(const Value: THandle);
begin
  FFormHandle := Value;
end;

procedure TCnsDicomConnectionThread.SetQueueIndex(const Value: Integer);
begin
  FQueueIndex := Value;
end;

procedure TCnsDicomConnectionThread.SetCurrentDatasets(
  const Value: TDicomDatasets);
begin
  FCurrentDatasets := Value;
end;

procedure TCnsDicomConnectionThread.SetOnWorkStart(
  const Value: TNotifyEvent);
begin
  FOnWorkStart := Value;
end;

procedure TCnsDicomConnectionThread.SetOnConnected(
  const Value: TNotifyEvent);
begin
  FOnConnected := Value;
end;

procedure TCnsDicomConnectionThread.SetPrintWithLabel(
  const Value: Boolean);
begin
  FPrintWithLabel := Value;
end;

procedure TCnsDicomConnectionThread.ImportImagesEx(APath: AnsiString);
begin
  FDirectoryToLoad := APath;

  fCommand := dctcImportFilesEx;
  if fNoneThread then
  begin
    Execute;
    if assigned(OnTerminate) then
      OnTerminate(self);
    //    Free;
  end
  else
    Resume;
end;

procedure TCnsDicomConnectionThread.SetPrintLabelFirstImage(
  const Value: Boolean);
begin
  FPrintLabelFirstImage := Value;
end;

procedure TCnsDicomConnectionThread.SetCustomViewSetting(
  const Value: string);
begin
  FCustomViewSetting := Value;
end;

procedure TCnsDicomConnectionThread.SetMultiViewMode(
  const Value: TMultiViewMode);
begin
  FMultiViewMode := Value;
end;

procedure TCnsDicomConnectionThread.SetEnable12bitsGrayscale(
  const Value: Boolean);
begin
  FEnable12bitsGrayscale := Value;
end;

procedure TCnsDicomConnectionThread.SetPrintWindowWidthCenter(
  const Value: Boolean);
begin
  FPrintWindowWidthCenter := Value;
end;

procedure TCnsDicomConnectionThread.SetPrintwithBottomScale(
  const Value: Boolean);
begin
  FPrintwithBottomScale := Value;
end;

procedure TCnsDicomConnectionThread.SetPrintWithRightScale(
  const Value: Boolean);
begin
  FPrintWithRightScale := Value;
end;

procedure TCnsDMTable.SetSpecifyLoadImageParam(const Value: AnsiString);
begin
  FSpecifyLoadImageParam := Value;
end;

function TCnsCustomDicomConnection.N_ACTION(ASOPClass: Integer; SopInstance: AnsiString;
  ADataset: TDicomAttributes): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.N_CREATE(ASOPClass: Integer; SopInstance: AnsiString;
  ADataset: TDicomAttributes): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.N_DELETE(ASOPClass: Integer; SopInstance: AnsiString;
  ADataset: TDicomAttributes): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.N_EVENT_REPORT(ASOPClass: Integer; SopInstance: AnsiString;
  ADataset: TDicomAttributes): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.N_GET(ASOPClass: Integer; SopInstance: AnsiString;
  ADataset: TDicomAttributes): Boolean;
begin
  Result := false;
end;

function TCnsCustomDicomConnection.N_SET(ASOPClass: Integer; SopInstance: AnsiString;
  ADataset: TDicomAttributes): Boolean;
begin
  Result := false;
end;

function ListAttributesToDataset(AAttributes: TDicomAttributes): TDataset;
var
  FLogTable1: TkxmMemTable;
  ID: Integer;
  procedure ListAttrinute(das: TDicomAttributes);
  var
    i{, k}: Integer;
    da1: TDicomAttribute;
  begin
    if not assigned(das) then
      exit;

    for I := 0 to das.Count - 1 do // Iterate
    begin
      da1 := das.ItemByIndex[i];
      FLogTable1.Insert;
      FLogTable1.FieldByName('ID').AsInteger := ID;
      inc(ID);
      FLogTable1.FieldByName('GroupID').AsString := '$' + IntToHex(da1.Group, 4);
      FLogTable1.FieldByName('ElementID').AsString := '$' + IntToHex(da1.Element, 4);
      FLogTable1.FieldByName('DataCount').AsInteger := da1.DataArray.Count;
      FLogTable1.FieldByName('Desc').AsString := da1.Description;
      FLogTable1.FieldByName('Datatype').AsString := da1.VR;
      FLogTable1.FieldByName('ABOUT').AsString := da1.GetAsStrings;
      FLogTable1.Post;
      {if das.ItemByIndex[i].DataType = ddtAttributes then
      begin
        for k := 0 to das.ItemByIndex[i].GetCount - 1 do
        begin
          //AStrs.Add(apre + '-----------' + IntToStr(k) + '------------');
          ListAttrinute(das.ItemByIndex[i].Attributes[k]);
        end;
      end; }
    end; // for
  end;
begin
  ID := 0;
  FLogTable1 := TkxmMemTable.Create(nil);
  with TkxmMemTable(FLogTable1) do
  begin
    with FieldDefs do
    begin
      Clear;
      Add('ID', ftInteger, 0, false);
      Add('GroupID', ftString, 5, false);
      Add('ElementID', ftString, 5, false);
      Add('DataCount', ftInteger, 0, false);
      Add('Datatype', ftString, 10, false);
      Add('Desc', ftString, 120, false);
      Add('ABOUT', ftMemo, 8, false);
    end;

    CreateTable;
    Open;
    Fields[0].DisplayLabel := 'ID';
    Fields[1].DisplayLabel := 'Group';
    Fields[2].DisplayLabel := 'Element';
    Fields[3].DisplayLabel := 'Data Count';
    Fields[4].DisplayLabel := 'Data Type';
    Fields[5].DisplayLabel := 'Desc';
    Fields[6].DisplayLabel := 'About';
    SortOn('ID', []);
  end;
  ListAttrinute(AAttributes);
  Result := FLogTable1;
end;

procedure TCnsDicomConnectionThread.SetSendPrintSetting(
  const Value: Boolean);
begin
  FSendPrintSetting := Value;
end;

procedure TCnsDicomConnectionThread.SetPrintWithDefaultParam(
  const Value: Boolean);
begin
  FPrintWithDefaultParam := Value;
end;

procedure TCnsDicomConnectionThread.SetUseSynchronizeEvent(
  const Value: Boolean);
begin
  FUseSynchronizeEvent := Value;
end;

{ TCnsDicomConnectionMultiThread }

constructor TCnsDicomConnectionMultiThread.Create;
begin
  MnLg_ev('DCM_Client TCnsDicomConnectionMultiThread.Create',vLogDir+pLogFile);
end;

destructor TCnsDicomConnectionMultiThread.Destroy;
begin
  MnLg_ev('DCM_Client TCnsDicomConnectionMultiThread.Destroy',vLogDir+pLogFile);

  inherited;
end;

procedure TCnsDicomConnectionMultiThread.MGetImage(ALevel, AUID: AnsiString;
  AOnlyLoadKeyImage: Boolean);
begin

end;

procedure TCnsDicomConnectionMultiThread.MGetImage(ALevel: AnsiString;
  AUIDS_Series, AUIDS_Study: tstrings; AOnlyLoadKeyImage: Boolean);
begin

end;

procedure TCnsDicomConnectionMultiThread.SetReceiveTimeout(
  const Value: Integer);
begin
  fReceiveTimeout := Value;
end;

procedure TCnsDicomConnectionMultiThread.WadoImages(AURL,
  ATransferSyntax: AnsiString; ADataset: TDicomDataset;
  AOnlyLoadKeyImage: Boolean);
begin

end;

constructor TNetworkQueueItem.Create;
begin
  //fQueueForm := AForm;
  fStatus := nqsPending;
  fForm := nil;
  fDatasets := nil;
  fData := nil;
  fTabData := nil;

  fDirection := nqdReceive;
  fFromOrTo := '';
  fPatientID := '';
  fPatientName := '';
  fStudyDate := now;
  fStartTime := now;
  fLastActive := now;
  fSeriesCount := 0;
  fImageCount := 0;
  fCurImageCount := 0;
  fStudyUID := '';
  fThread := nil;

  FPatientAge := '';
  FPatientSex := '';
end;

destructor TNetworkQueueItem.Destroy;
begin

  inherited;
end;

function TNetworkQueueItem.GetDirection: Ansistring;
begin
  case Direction of
    nqdSend: Result := 'Send';
    nqdPrint: Result := 'Print';
    nqdImport: Result := 'Import';
    nqdLoad: Result := 'Load';
  else
    Result := 'Receive';
  end;
end;

function TNetworkQueueItem.GetStatusString: AnsiString;
begin
  case Status of
    nqsPending:
      begin
        Result := 'Pending';
      end;
    nqsActive:
      begin
        Result := 'Active';
      end;
    nqsIdle:
      begin
        Result := 'Idle';
      end;
    nqsFinished:
      begin
        Result := 'Finished';
      end;
    nqsError:
      begin
        Result := 'Error';
      end;
    nqsSelectSeries:
      Result := 'SelectSeries';
    nqsSendingRequest:
      Result := 'SendingRequest';
  end;
end;

procedure TNetworkQueueItem.SetData(const Value: TObject);
begin
  FData := Value;
end;

procedure TNetworkQueueItem.SetHospitalName(const Value: string);
begin
  FHospitalName := Value;
end;

procedure TNetworkQueueItem.SetMessageString(const Value: string);
begin
  FMessageString := Value;
end;

procedure TNetworkQueueItem.SetPatientAge(const Value: string);
begin
  FPatientAge := Value;
end;

procedure TNetworkQueueItem.SetPatientCName(const Value: string);
begin
  FPatientCName := Value;
end;

procedure TNetworkQueueItem.SetPatientSex(const Value: string);
begin
  FPatientSex := Value;
end;

procedure TNetworkQueueItem.SetTabData(const Value: TObject);
begin
  FTabData := Value;
end;

procedure TNetworkQueueItem.SetTag(const Value: Integer);
begin
  FTag := Value;
end;

procedure TCnsDBTable.SetPHPScript(const Value: Ansistring);
begin
  FPHPScript := Value;
end;

{ TSRContentItem }

function TSRContentItem.AddContentItem(ADataset: TDicomAttributes): TSRContentItem;
begin
  Result := TSRContentItem.Create(ADataset, fContinuityOfContent);
  Result.fIsRoot := false;
  fItems.Add(Result);
end;

function TSRContentItem.AsDatetime: TDatetime;
var
  da1: TDicomAttribute;
begin
  //(0040,A120)  for DATETIME
  //(0040,A121)  for DATE
  //(0040,A122)  for TIME
  case ValueType of
    srvtDATETIME: da1 := fAttributes.Item[$0040, $A120];
    srvtDATE: da1 := fAttributes.Item[$0040, $A121];
    srvtTIME: da1 := fAttributes.Item[$0040, $A122];
  else
    da1 := nil;
  end;
  if da1 <> nil then
    Result := da1.AsDatetime[0]
  else
    Result := 0;
end;

function TSRContentItem.AsString: AnsiString;
var
  i: Integer;
begin
  //[0040:A160](TextValue)  for TEXT
  //[0040:A123](PersonName)  for PNAME
  //[0040,A124](UID)  for UIDREF
  case ValueType of
    srvtTEXT: Result := fAttributes.GetString($0040, $A160);
    srvtPNAME:
      begin
        Result := fAttributes.GetString($0040, $A123);
        for i := 1 to Length(Result) do
          if Result[i] = '^' then
            Result[i] := ' ';
      end;
    srvtUIDREF: Result := fAttributes.GetString($0040, $A124);
  else
    Result := '';
  end;
end;

procedure TSRContentItem.Clear;
var
  i: integer;
begin
  for i := fItems.Count - 1 downto 0 do
  begin
    TSRContentItem(fItems[i]).Free;
  end;
  fItems.Clear;
end;

constructor TSRContentItem.Create(ADataset: TDicomAttributes; AContinuityOfContent: Boolean);
var
  das1: TDicomAttributes;
  da1: TDicomAttribute;
  i: Integer;
  v1: TSRContentItem;
begin
  fContentLevel := 6;
  fIsRoot := true;
  fContinuityOfContent := AContinuityOfContent;

  fAttributes := ADataset;

  fItems := TList.Create;
  //  if ValueType = srvtCONTAINER then
  begin
    if fAttributes.GetString($0040, $A050) <> '' then
      fContinuityOfContent := fAttributes.GetString($0040, $A050) = 'SEPARATE';
    da1 := fAttributes.Item[$0040, $A730];
    if (da1 <> nil) and (da1.GetCount > 0) then
    begin
      for i := 0 to da1.GetCount - 1 do
      begin
        das1 := da1.Attributes[i];
        v1 := TSRContentItem.Create(das1, fContinuityOfContent);
        v1.fIsRoot := false;
        v1.fContentLevel := fContentLevel - 1;
        fItems.Add(v1);
      end;
    end;
  end;
end;

destructor TSRContentItem.Destroy;
begin
  Clear;
  fItems.Free;
  inherited;
end;

{>>1322[0040:A043](ConceptNameCodeSequence)SQ=<1>Sequence Data
>>-----------0------------
>>>>91[0008:0100](CodeValue)SH=<1>CODE_07
>>>>92[0008:0102](CodingSchemeDesignator)SH=<1>99_OFFIS_DCMTK
>>>>93[0008:0104](CodeMeaning)LO=<1>PA Chest}

procedure TSRContentItem.ExportToHtml(AStrs: TStringList);
  function StrToHtml(AStr: AnsiString): AnsiString;
  begin
    Result := StrReplace(astr, #10, '<br>');
    //Result := StrReplace(Result, ' ', '&nbsp;');
  end;
  function PNameToHtml(AStr: AnsiString): AnsiString;
  begin
    Result := StrReplace(AStr, '^', ' ');
    //Result := StrReplace(Result, ' ', '&nbsp;');
  end;
  function SexToHtml(AStr: AnsiString): AnsiString;
  begin
    if AStr = 'F' then
      Result := 'Fomale'
    else
      Result := 'Male';
  end;
var
  i: Integer;
  date1: TDatetime;
  d1: TDicomAttribute;
  das1, das2{, das3}: TDicomAttributes;
  v1: TSRContentItemValueType;
  str1, str2: AnsiString;
begin
  if fIsRoot then
  begin
    AStrs.Add('<HTML><HEAD><meta http-equiv="Content-Type" content="text/html><TITLE>' +
      'Structure Report</TITLE></HEAD><BODY oncontextmenu="return false;"   oncopy="return false;"   oncut="return false;">');

    //add patient info
    AStrs.Add('<TABLE BORDER="0" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">');

    AStrs.Add('<TR><TD width=50%><b>Patient:</b></TD><TD width=50%>');
    AStrs.Add(PNameToHtml(fAttributes.GetString($10, $10)) +
      '(' + SexToHtml(fAttributes.GetString($10, $40)) + ' ' +
      '*' + fAttributes.GetString($10, $30) + ' ' +
      '#' + fAttributes.GetString($10, $20) + ')');
    AStrs.Add('</TD></TR>');

    AStrs.Add('<TR><TD width=50%><b>Completion Flag:</b></TD><TD width=50%>');
    AStrs.Add(fAttributes.GetString($0040, $A491));
    AStrs.Add('</TD></TR>');

    AStrs.Add('<TR><TD width=50%><b>Verification Flag:</b></TD><TD width=50%>');
    AStrs.Add(fAttributes.GetString($0040, $A493));
    AStrs.Add('</TD></TR>');

    AStrs.Add('<TR><TD width=50%><b>Content Date/Time:</b></TD><TD width=50%>');
    d1 := fAttributes.Item[8, $23];
    if d1 <> nil then
      date1 := d1.AsDatetime[0];
    d1 := fAttributes.Item[8, $33];
    if d1 <> nil then
      date1 := date1 + d1.AsDatetime[0];
    AStrs.Add(FormatDatetime('yyyy-mm-dd hh:nn:ss', date1));
    AStrs.Add('</TD></TR>');

    AStrs.Add('</TABLE>');

    AStrs.Add('<hr>')
  end;

  v1 := ValueType;
  case v1 of
    srvtUIDREF, srvtPNAME, srvtTEXT:
      begin
        if RelationshipType = srrtHAS_OBS_CONTEXT then
        begin
          AStrs.Add('<p><b><u><font size=1> Observation Context: </u></b>' + CodeMeaning + ' = ');
          AStrs.Add(StrToHtml(AsString) + '</font></p>');
        end
        else
          if not fContinuityOfContent then
        begin
          if v1 = srvtPNAME then
            AStrs.Add('<u>' + StrToHtml(AsString) + '</u>')
          else
            AStrs.Add(StrToHtml(AsString));
        end
        else
        begin
          AStrs.Add('<p><b>' + CodeMeaning + ':</b><br>');
          AStrs.Add(StrToHtml(AsString) + '</p>');
        end;
      end;
    srvtNUM:
      begin
        d1 := fAttributes.Item[$0040, $A300];
        if (d1 <> nil) and (d1.GetCount > 0) then
        begin
          das1 := d1.Attributes[0];
          d1 := das1.Item[$0040, $8EA];
          if (d1 <> nil) and (d1.GetCount > 0) then
          begin
            das2 := d1.Attributes[0];
            AStrs.Add('<u>' + Format('%15.2f', [das1.Item[$40, $A30A].AsFloat[0]]) +
              ' ' + das2.GetString(8, $100) + '</u>');
          end;
        end;
      end;
    srvtCODE:
      begin
        d1 := fAttributes.Item[$0040, $A168];
        if (d1 <> nil) and (d1.GetCount > 0) then
        begin
          das1 := d1.Attributes[0];
          if not fContinuityOfContent then
          begin
            AStrs.Add('<u>' + das1.GetString($8, $104) + '</u>')
          end
          else
          begin
            str1 := das1.GetString($8, $104);

            d1 := fAttributes.Item[$0040, $A043];
            if (d1 <> nil) and (d1.GetCount > 0) then
            begin
              das1 := d1.Attributes[0];
              if not fContinuityOfContent then
              begin
                AStrs.Add('<b>' + das1.GetString($8, $104) + '</b>')
              end
              else
              begin
                AStrs.Add('<p><b>' + das1.GetString($8, $104) + ':</b><br>');
                AStrs.Add(str1 + '</p>');
              end;
            end;
          end;
        end;
      end;
    srvtDATETIME:
      AStrs.Add(FormatDatetime('yyyy-mm-dd hh:nn:ss', AsDatetime));
    srvtDATE:
      AStrs.Add(FormatDatetime('yyyy-mm-dd', AsDatetime));
    srvtTIME:
      AStrs.Add(FormatDatetime('hh:nn:ss', AsDatetime));
    srvtCOMPOSITE, srvtIMAGE:
      begin
        d1 := fAttributes.Item[$8, $1199];
        if (d1 <> nil) and (d1.GetCount > 0) then
        begin
          das1 := d1.Attributes[0];
          str1 := das1.GetString(8, $1150);
          str2 := das1.GetString(8, $1155);
          str1 := DCM_UID.UIDS.Items[str1].ShortName;
        end;
        if not fContinuityOfContent then
        begin
          AStrs.Add('<u>' + AsString + '</u>');
          //AStrs.Add('<img src='+str2+' align=left>');
          AStrs.Add('<a href="' + str2 + '">' + str1 + '</a>');
        end
        else
        begin
          AStrs.Add('<p><b>' + CodeMeaning + ':</b><br>');
          //AStrs.Add('<img src='+str2+' align=left>');
          AStrs.Add('<a href="/IMA/' + str2 + '">Image(' + str1 + ')</a></p>');
        end;
      end;
    {  srvtCOMPOSITE: //todo
        begin
          AStrs.Add('<p><b>' + CodeMeaning + '</b></p>');
          AStrs.Add('COMPOSITE' + '</p>');
        end;  }
    srvtWAVEFORM: //todo
      begin
        AStrs.Add('<p><b>' + CodeMeaning + '</b></p>');
        AStrs.Add('WAVEFORM' + '</p>');
      end;
    srvtSCOORD: //todo
      begin
        AStrs.Add('<p><b>' + CodeMeaning + '</b></p>');
        AStrs.Add('SCOORD' + '</p>');

      end;
    srvtTCOORD: //todo
      begin
        AStrs.Add('<p><b>' + CodeMeaning + '</b></p>');
        AStrs.Add('TCOORD' + '</p>');

      end;
    srvtCONTAINER:
      begin
        AStrs.Add('<p><b><font size=' + IntToStr(ContentLevel) + '> ' + CodeMeaning + '</font> </b></p>');
      end;
  end;

  for i := 0 to fItems.Count - 1 do
  begin
    Items[i].ExportToHtml(AStrs);
  end;

  if fIsRoot then
    AStrs.Add('</BODY></HTML>');
end;

function TSRContentItem.GetCodeMeaning: AnsiString;
var
  das1: TDicomAttributes;
  da1: TDicomAttribute;
begin
  Result := '';
  da1 := fAttributes.Item[$0040, $A043];
  if (da1 <> nil) and (da1.GetCount > 0) then
  begin
    das1 := da1.Attributes[0];
    Result := das1.GetString($0008, $0104);
  end;
end;

function TSRContentItem.GetCodeValue: AnsiString;
var
  das1: TDicomAttributes;
  da1: TDicomAttribute;
begin
  Result := '';
  da1 := fAttributes.Item[$0040, $A043];
  if (da1 <> nil) and (da1.GetCount > 0) then
  begin
    das1 := da1.Attributes[0];
    Result := das1.GetString($0008, $0100);
  end;
end;

function TSRContentItem.GetCodingSchemeDesignator: AnsiString;
var
  das1: TDicomAttributes;
  da1: TDicomAttribute;
begin
  Result := '';
  da1 := fAttributes.Item[$0040, $A043];
  if (da1 <> nil) and (da1.GetCount > 0) then
  begin
    das1 := da1.Attributes[0];
    Result := das1.GetString($0008, $0102);
  end;
end;

function TSRContentItem.GetCompletionFlag: TSRContentItemCompletionFlag;
var
  str1: AnsiString;
begin
  str1 := fAttributes.GetString($0040, $A491);
  if (str1 = 'PARTIAL') then
    Result := srcfPARTIAL
  else
    if (str1 = 'COMPLETE') then
    Result := srcfCOMPLETE;
end;

function TSRContentItem.GetCount: Integer;
begin
  Result := fItems.Count;
end;

function TSRContentItem.GetItems(index: Integer): TSRContentItem;
begin
  if (index < fItems.Count) and (index >= 0) then
    Result := TSRContentItem(fItems[index]);
end;

function TSRContentItem.GetRelationshipType: TSRContentItemRelationshipType;
var
  str1: AnsiString;
begin
  str1 := fAttributes.GetString($0040, $A010);
  if str1 = 'CONTAINS' then
    Result := srrtCONTAINS
  else
    if str1 = 'HAS PROPERTIES' then
    Result := srrtHAS_PROPERTIES
  else
    if str1 = 'HAS OBS CONTEXT' then
    Result := srrtHAS_OBS_CONTEXT
  else
    if str1 = 'HAS ACQ CONTEXT' then
    Result := srrtHAS_ACQ_CONTEXT
  else
    if str1 = 'INFERRED FROM' then
    Result := srrtINFERRED_FROM
  else
    if str1 = 'SELECTED FROM' then
    Result := srrtSELECTED_FROM
  else
    if str1 = 'HAS CONCEPT MOD' then
    Result := srrtHAS_CONCEPT_MOD;
end;

function TSRContentItem.GetValueType: TSRContentItemValueType;
var
  str1: AnsiString;
begin
  str1 := fAttributes.GetString($0040, $A040);
  //>>1429[0040:A040](ValueType)CS=<1>PNAME
  if str1 = 'TEXT' then
    Result := srvtTEXT
  else
    if str1 = 'NUM' then
    Result := srvtNUM
      {(0040,A300)(0040,A301)}
  else
    if str1 = 'CODE' then
    Result := srvtCODE
      {(0040,A168)}
  else
    if str1 = 'DATETIME' then
    Result := srvtDATETIME
  else
    if str1 = 'DATE' then
    Result := srvtDATE
  else
    if str1 = 'TIME' then
    Result := srvtTIME
  else
    if str1 = 'UIDREF' then
    Result := srvtUIDREF
  else
    if str1 = 'PNAME' then
    Result := srvtPNAME
  else
    if str1 = 'COMPOSITE' then
    Result := srvtCOMPOSITE
      {(0008,1199)}
  else
    if str1 = 'IMAGE' then
    Result := srvtIMAGE
  else
    if str1 = 'WAVEFORM' then
    Result := srvtWAVEFORM
      {(0040,A0B0)}
  else
    if str1 = 'SCOORD' then
    Result := srvtSCOORD
      {(0070,0022)}
  else
    if str1 = 'TCOORD' then
    Result := srvtTCOORD
      {(0040,A130)}
  else
    if str1 = 'CONTAINER' then
    Result := srvtCONTAINER
  else
    Result := srvtNONE
end;

function TSRContentItem.GetVerificationFlag: TSRContentItemVerificationFlag;
var
  str1: AnsiString;
begin
  str1 := fAttributes.GetString($0040, $A493);
  if str1 = 'UNVERIFIED' then
    Result := srvfUNVERIFIED
  else
    if str1 = 'VERIFIED' then
    Result := srvfVERIFIED
  else
    Result := srvfNONE;
end;

procedure TSRContentItem.SetCompletionFlag(
  const Value: TSRContentItemCompletionFlag);
begin
  //  FCompletionFlag := Value;
  case Value of
    srcfPARTIAL:
      fAttributes.AddVariant($0040, $A491, 'PARTIAL');
    srcfCOMPLETE:
      fAttributes.AddVariant($0040, $A491, 'COMPLETE');
  end;
end;

procedure TSRContentItem.SetRelationshipType(
  const Value: TSRContentItemRelationshipType);
begin
  //  FRelationshipType := Value;
  case Value of
    srrtCONTAINS:
      fAttributes.AddVariant($0040, $A010, 'CONTAINS');
    srrtHAS_PROPERTIES:
      fAttributes.AddVariant($0040, $A010, 'HAS PROPERTIES');
    srrtHAS_OBS_CONTEXT:
      fAttributes.AddVariant($0040, $A010, 'HAS OBS CONTEXT');
    srrtHAS_ACQ_CONTEXT:
      fAttributes.AddVariant($0040, $A010, 'HAS ACQ CONTEXT');
    srrtINFERRED_FROM:
      fAttributes.AddVariant($0040, $A010, 'INFERRED FROM');
    srrtSELECTED_FROM:
      fAttributes.AddVariant($0040, $A010, 'SELECTED FROM');
    srrtHAS_CONCEPT_MOD:
      fAttributes.AddVariant($0040, $A010, 'HAS CONCEPT MOD');
  end;
end;

procedure TSRContentItem.SetValueType(
  const Value: TSRContentItemValueType);
begin
  //  FValueType := Value;
  case Value of
    srvtTEXT:
      fAttributes.AddVariant($0040, $A040, 'TEXT');
    srvtNUM:
      fAttributes.AddVariant($0040, $A040, 'NUM');
    srvtCODE:
      fAttributes.AddVariant($0040, $A040, 'CODE');
    srvtDATETIME:
      fAttributes.AddVariant($0040, $A040, 'DATETIME');
    srvtDATE:
      fAttributes.AddVariant($0040, $A040, 'DATE');
    srvtTIME:
      fAttributes.AddVariant($0040, $A040, 'TIME');
    srvtUIDREF:
      fAttributes.AddVariant($0040, $A040, 'UIDREF');
    srvtPNAME:
      fAttributes.AddVariant($0040, $A040, 'PNAME');
    srvtCOMPOSITE:
      fAttributes.AddVariant($0040, $A040, 'COMPOSITE');
    srvtIMAGE:
      fAttributes.AddVariant($0040, $A040, 'IMAGE');
    srvtWAVEFORM:
      fAttributes.AddVariant($0040, $A040, 'WAVEFORM');
    srvtSCOORD:
      fAttributes.AddVariant($0040, $A040, 'SCOORD');
    srvtTCOORD:
      fAttributes.AddVariant($0040, $A040, 'TCOORD');
    srvtCONTAINER:
      fAttributes.AddVariant($0040, $A040, 'CONTAINER');
  end;
end;

procedure TSRContentItem.SetVerificationFlag(
  const Value: TSRContentItemVerificationFlag);
begin
  //  FVerificationFlag := Value;
  case Value of
    srvfUNVERIFIED:
      fAttributes.AddVariant($0040, $A493, 'UNVERIFIED');
    srvfVERIFIED:
      fAttributes.AddVariant($0040, $A493, 'VERIFIED');
  end;
end;

function TCnsDBTable.GetFile(AFileName: AnsiString): TDicomAttributes;
var
  da1: TDicomAttributes;
  das1: TDicomDataset;
begin
  Result := nil;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'GFILE');
    AddVariant($2809, $17, AFileName);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    try
      if FAppSrvClient.C_Database(da1) then
      begin
        if FAppSrvClient.ReceiveDatasets.Count > 0 then
        begin
          Result := FAppSrvClient.ReceiveDatasets[0];
          FAppSrvClient.ReceiveDatasets.Clear;
        end;
      end;
      FAppSrvClient.Clear;
    except
      on E: Exception do
      begin
        ShowMessage(e.Message + ',Please retry');
      end;
    end;
  end
  else
  begin
    das1 := DoHttpPostDatabase(da1);
    if das1 <> nil then
    try
      Result := das1.Attributes;
      das1.RecreateAttributes;
    finally
      das1.Free;
    end;
  end;
end;

procedure TCnsDBTable.ChangeServerIni(AIniFileName, ASection, AName, AValue: string);
var
  da1: TDicomAttributes;
  das1: TDicomDataset;
begin
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'UPDATEINI');
    AddVariant($2809, $16, ASection);
    AddVariant($2809, $17, AName);
    AddVariant($2809, $5, AIniFileName);
    AddVariant($2809, $32, AValue);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    try
      if AppSrvClient.C_Database(da1) then
      begin
        if AppSrvClient.ReceiveDatasets.Count > 0 then
        begin
          da1 := AppSrvClient.ReceiveDatasets[0];
          if da1.GetInteger($2809, $1004) <> 1 then
            ShowMessage(da1.GetString($2809, $1003));
        end;
      end;
      AppSrvClient.Clear;
    except
      on E: Exception do
      begin
        ShowMessage(e.Message + ',Please retry');
      end;
    end;
  end
  else
  begin
    das1 := DoHttpPostDatabase(da1);
    if das1 <> nil then
    try
      da1 := das1.Attributes;
      if da1.GetInteger($2809, $1004) <> 1 then
        ShowMessage(da1.GetString($2809, $1003));
    finally
      das1.Free;
    end;
  end;
end;

procedure TCnsDBTable.SetFile(AFileName, ASourceFileName: AnsiString; APath: AnsiString = '');
var
  da1: TDicomAttributes;
  das1: TDicomDataset;
begin
  if FileExists(ASourceFileName) then
  begin
    da1 := TDicomAttributes.Create;
    with da1 do
    begin
      AddVariant($2809, 1, 'SFILE');
      AddVariant($2809, $10, APath);
      AddVariant($2809, $17, AFileName);
      Add($2809, $1001).LoadFromFile(ASourceFileName);
    end;
    if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
    begin
      if AppSrvClient.C_Database(da1) then
      begin
        if AppSrvClient.ReceiveDatasets.Count > 0 then
        begin
          da1 := AppSrvClient.ReceiveDatasets[0];
          if da1.GetInteger($2809, $1004) <> 1 then
            ShowMessage(da1.GetString($2809, $1003));
          //ReceiveDatasets.Clear;
        end;
      end;
      AppSrvClient.Clear;
    end
    else
    begin
      das1 := DoHttpPostDatabase(da1);
      if das1 <> nil then
      try
        da1 := das1.Attributes;
        if da1.GetInteger($2809, $1004) <> 1 then
          ShowMessage(da1.GetString($2809, $1003));
      finally
        das1.Free;
      end;
    end;
  end;
end;

procedure TCnsDBTable.SetFileStream(AFileName: AnsiString; AStm: TStream; APath: AnsiString = '');
var
  da1: TDicomAttributes;
  das1: TDicomDataset;
begin
  if AStm <> nil then
  begin
    da1 := TDicomAttributes.Create;
    with da1 do
    begin
      AddVariant($2809, 1, 'SFILE');
      AddVariant($2809, $17, AFileName);
      AddVariant($2809, $10, APath);
      Add($2809, $1001).LoadFromStream(AStm);
    end;
    if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
    begin
      if AppSrvClient.C_Database(da1) then
      begin
        if AppSrvClient.ReceiveDatasets.Count > 0 then
        begin
          da1 := AppSrvClient.ReceiveDatasets[0];
          if da1.GetInteger($2809, $1004) <> 1 then
            ShowMessage(da1.GetString($2809, $1003));
          //ReceiveDatasets.Clear;
        end;
      end;
      AppSrvClient.Clear;
    end
    else
    begin
      das1 := DoHttpPostDatabase(da1);
      if das1 <> nil then
      try
        da1 := das1.Attributes;
        if da1.GetInteger($2809, $1004) <> 1 then
          ShowMessage(da1.GetString($2809, $1003));
      finally
        das1.Free;
      end;
    end;
  end;
end;

procedure TCnsCustomDicomConnection.SetFile(
  AFileName, ASourceFileName: AnsiString; APath: AnsiString = '');
var
  da1: TDicomAttributes;
begin
  if FileExists(ASourceFileName) then
  begin
    da1 := TDicomAttributes.Create;
    with da1 do
    begin
      AddVariant($2809, 1, 'SFILE');
      AddVariant($2809, $10, APath);
      AddVariant($2809, $17, AFileName);
      Add($2809, $1001).LoadFromFile(ASourceFileName);
    end;
    if C_Database(da1) then
    begin
      if ReceiveDatasets.Count > 0 then
      begin
        da1 := ReceiveDatasets[0];
        if da1.GetInteger($2809, $1004) <> 1 then
          ShowMessage(da1.GetString($2809, $1003));
        //ReceiveDatasets.Clear;
      end;
    end;
  end;
end;

procedure TCnsCustomDicomConnection.SetFileStream(AFileName: AnsiString;
  AStm: TStream; APath: AnsiString = '');
var
  da1: TDicomAttributes;
begin
  if AStm <> nil then
  begin
    da1 := TDicomAttributes.Create;
    with da1 do
    begin
      AddVariant($2809, 1, 'SFILE');
      AddVariant($2809, $10, APath);
      AddVariant($2809, $17, AFileName);
      Add($2809, $1001).LoadFromStream(AStm);
    end;
    if C_Database(da1) then
    begin
      if ReceiveDatasets.Count > 0 then
      begin
        da1 := ReceiveDatasets[0];
        if da1.GetInteger($2809, $1004) <> 1 then
          ShowMessage(da1.GetString($2809, $1003));
        //ReceiveDatasets.Clear;
      end;
    end;
  end;
end;

//////////////////////////////////////////////////////////////////////////////

function TCnsUserLogin.GetDatasetByNameEx(AName: string): TCnsDBTable;
var
  I: Integer;
begin
  Result := nil;
  AName := Uppercase(AName);

  for I := 0 to FDatasetList.Count - 1 do // Iterate
  begin
    if TCnsDBTable(FDatasetList[i]).Name = AName then
    begin
      Result := TCnsDBTable(FDatasetList[i]);
      exit;
    end;
  end; // for
end;

function TCnsUserLogin.CreateDatasetEx(ADatasetName: string): TCnsDBTable;
var
  r: TCnsDBTable;
begin
  r := GetDatasetByNameEx(ADatasetName);
  if assigned(r) then
    Result := r
  else
  begin
    Result := TCnsDBTable.Create(self);
    Result.AppSrvClient := self.FConnection;
    Result.Name := Uppercase(ADatasetName);
    FDatasetList.Add(Result);
  end;
end;

procedure TCnsUserLogin.DeleteDatasetEx(ADatasetName: string);
var
  I: Integer;
  ud1: TCnsDBTable;
begin
  for I := 0 to FDatasetList.Count - 1 do // Iterate
  begin
    if TCnsDBTable(FDatasetList[i]).Name = ADatasetName then
    begin
      ud1 := TCnsDBTable(FDatasetList[i]);
      ud1.Close;
      ud1.Free;
      FDatasetList.Delete(i);
      break;
    end;
  end; // for
end;

function TCnsUserLogin.DoHttpPostDatabase(ADataset: TDicomAttributes): TDicomDataset;
var
  stm1, stm2: TMemoryStream;
  str1: string;
begin
  Result := nil;
  stm1 := TMemoryStream.Create;
  stm2 := TMemoryStream.Create;
  ADataset.Write(stm2, ImplicitVRLittleEndian, 100, false);
  try
    str1 := format('http://%s:%d/SQL', [FConnection.Host, FConnection.Port + 1]);
    if assigned(fOnHttpPost) then
      fOnHttpPost(self, str1, stm2, stm1)
    else
      raise Exception.Create('You must set http post event');

    if stm1.Size > 0 then
    begin
      Result := TDicomDataset.Create;
      stm1.Position := 0;
      Result.LoadFromStream(stm1);
    end;
  finally
    stm1.Free;
    stm2.Free;
  end;
end;

function TCnsUserLogin.UpdateToServer: Boolean;

var
  da1: TDicomAttributes;
  //  dd1: TDicomAttribute;
  stm1: TOBStream;
  filename1: Ansistring;
  Inst: Integer;
  AppName1: Ansistring;
  Version1: Integer;
  wadodas1: TDicomDataset;
  ASPACKFILENAME: Ansistring;
begin
  Result := false;
  ASPACKFILENAME := 'ASPACK.EXE';

  if not GetVersionInfo(Application.ExeName, AppName1, Version1) then
  begin
    ShowMessage(V_CAN_NOT_FIND_VERSIONINFO);
    exit;
  end;
  Result := false;

  if FServerApplicationVersion >= Version1 then
  begin
    ShowMessage(AppName1 + V_DONT_NEED_UPDATE);
    exit;
  end;
  //  if InputPassword <> '83877197' then
  //    exit;
  filename1 := ChangeFileExt(Application.ExeName, 'TMP.EXE');
  if CopyFile(PChar(Application.ExeName), PChar(FileName1), false) then
  begin
    Inst := winexec(PAnsiChar(ASPACKFILENAME + ' "' + filename1 + '" /d+ /r+'), SW_SHOW);
    //    Inst := ShellExecute(0, 'open', PChar(ASPACKFILENAME), PChar(filename1), nil, SW_SHOW);
    if Inst <= 32 then
    begin
      MessageDlg(Format(V_COMPRESS_ERROR, [ASPACKFILENAME]), mtError, [mbOK], 0);
    end
    else
    begin
      if MessageDlg(V_CLICK_OK_AFTER_COMPRESS, mtWarning, [mbYes, mbNo], 0) = mryes then
      begin
        stm1 := TOBStream.Create;
        stm1.LoadFromFile(filename1);
        da1 := TDicomAttributes.Create;
        with da1 do
        begin
          AddVariant($2809, 1, 'VERSION');
          AddVariant($2809, $8, AppName1);
          AddVariant($2809, $9, Version1);
          Add($2809, $1001).AddData(stm1);
        end;
        if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
        begin
          with FConnection do
            if C_Database(da1) then
            begin
              if ReceiveDatasets.Count > 0 then
              begin
                da1 := ReceiveDatasets[0];
                if da1.getInteger($2809, $1004) = 0 then
                begin
                  ShowMessage(da1.GetString($2809, $1003));
                end
                else
                  ShowMessage(V_UPDATE_FINISH);
                {$IFDEF NOTKEEPCONNECTION}
                Disconnect;
                {$ENDIF}
              end;
            end
            else
              ShowMessage(V_FILE_COPY_ERROR);
        end
        else
          if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
        begin
          wadodas1 := DoHttpPostDatabase(da1);
          if wadodas1 <> nil then
          try
            da1 := wadodas1.Attributes;
            if da1.getInteger($2809, $1004) = 0 then
            begin
              ShowMessage(da1.GetString($2809, $1003));
            end
            else
              ShowMessage(V_UPDATE_FINISH);
          finally
            wadodas1.Free;
          end
          else
            ShowMessage(V_FILE_COPY_ERROR);
        end;
      end;
    end;
  end
  else
    ShowMessage(V_FILE_COPY_ERROR);
end;

destructor TCnsUserLogin.Destroy;
var
  i: Integer;
  l1: TList;
begin
  l1 := FUserList.LockList;
  for i := 0 to l1.Count - 1 do
  begin
    TCnsUserItem(l1[i]).Free;
  end;
  l1.Clear;
  FUserList.UnlockList;

  FUserList.Free;

  FPermit.Free;

  FDatasetList.Clear;
  FDatasetList.Free;
  FGroupTable.Free;
  inherited;
end;

constructor TCnsUserLogin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fTableLoadMode := cnsLoadFromNetworkEx;

  FDatasetList := TList.Create;
  FUserList := TThreadList.Create;

  FUsername := '';

  FUserCode := '';
  FPassword := '';
  FIsGrouper := False;
  FIsSysdba := False;
  FIsSysdba1 := False;
  FIsSysdba2 := False;
  FIsSysdba3 := False;
  FIsSysdba4 := False;
  FIsSysdba5 := False;
  FIsSysdba6 := False;

  FPermit := TStringList.Create;
  FGroupTable := TCnsDBTable.Create(self);
  FGroupTable.ObjectName := 'RIS_REPORT_GROUP';
end;

function TCnsUserLogin.GetSeverTime: TDatetime;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := now;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'NOW');
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    if FConnection.C_Database(da1) then
    begin
      if FConnection.ReceiveDatasets.Count > 0 then
      begin
        da1 := FConnection.ReceiveDatasets[0];
        Result := da1.Item[$2809, $18].AsDatetime[0];
      end;
    end;
  end
  else
    if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
  begin
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      Result := da1.Item[$2809, $18].AsDatetime[0];
    finally
      wadodas1.Free;
    end
  end;
end;

function TCnsUserLogin.GetFile(AFileName: string): TDicomAttributes;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := nil;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'GFILE');
    AddVariant($2809, $17, AFileName);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    with FConnection do
      if C_Database(da1) then
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          Result := ReceiveDatasets[0];
          if da1.getInteger($2809, 1004) <> 1 then
          begin
            Result := nil;
            raise Exception.Create(da1.GetString($2809, $1003))
          end
          else
            ReceiveDatasets.Clear;
        end;
      end;
  end
  else
    if fTableLoadMode = cnsLoadFromWadoPost then
  begin
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      Result := wadodas1.Attributes;
      if da1.getInteger($2809, 1004) <> 1 then
      begin
        Result := nil;
        raise Exception.Create(da1.GetString($2809, $1003))
      end
      else
        wadodas1.RecreateAttributes;
    finally
      wadodas1.Free;
    end
  end
  else
    if fTableLoadMode = cnsLoadFromWadoPostEx then
  begin
    //todo
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      Result := wadodas1.Attributes;
      if da1.getInteger($2809, 1004) <> 1 then
      begin
        Result := nil;
        raise Exception.Create(da1.GetString($2809, $1003))
      end
      else
        wadodas1.RecreateAttributes;
    finally
      wadodas1.Free;
    end
  end;
end;

procedure TCnsUserLogin.SetFile(ASourceFile, AFileName: string);
var
  da1: TDicomAttributes;
  d1: TDicomAttribute;
  wadodas1: TDicomDataset;
begin
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'SFILE');
    AddVariant($2809, $17, AFileName);
    d1 := Add($2809, $1001);
    d1.LoadFromFile(ASourceFile);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    with FConnection do
      if C_Database(da1) then
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];
          if da1.getInteger($2809, 1004) <> 1 then
            raise Exception.Create(da1.GetString($2809, $1003));
          //ReceiveDatasets.Clear;
        end;
      end;
  end
  else
    if fTableLoadMode = cnsLoadFromWadoPost then
  begin
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      if da1.getInteger($2809, 1004) <> 1 then
        raise Exception.Create(da1.GetString($2809, $1003));
    finally
      wadodas1.Free;
    end
  end
  else
    if fTableLoadMode = cnsLoadFromWadoPostEx then
  begin
    //todo
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      if da1.getInteger($2809, 1004) <> 1 then
        raise Exception.Create(da1.GetString($2809, $1003));
    finally
      wadodas1.Free;
    end
  end;
end;

function TCnsUserLogin.AutoUpdate: Boolean;
var
  da1: TDicomAttributes;
  dd1: TDicomAttribute;
  BatchFileList: TStringList;
  FN, FNOld: string;
  TempFileName, TheBatchFile, ThePath: string;
  AppName1: Ansistring;
  dSysTime: TSystemTime;
  Version1: Integer;
  time1: TDatetime;
  f1: Double;
  wadodas1: TDicomDataset;
begin
  Result := false;
  if not (FConnection is TCnsDicomConnection) then
    exit;
  time1 := GetSeverTime;
  f1 := abs(time1 - now);
  //  ShowMessage(FormatDatetime('hh:nn:ss-ZZZZZZ',TDatetime(f1)));
  if (f1 > 0.000001) then
  begin
    DateTimeToSystemTime(time1, dSysTime);
    Windows.SetLocalTime(dSysTime);
  end;

  if not GetVersionInfo(Application.ExeName, AppName1, Version1) then
  begin
    //    ShowMessage(V_CAN_NOT_FIND_VERSIONINFO);
    FServerApplicationVersion := -1;
    exit;
  end;

  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'UPDATE');
    AddVariant($2809, $8, AppName1);
    AddVariant($2809, $9, Version1);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    with FConnection do
      if C_Database(da1) then
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];

          case da1.getInteger($2809, $1004) of
            0:
              begin
                //              ShowMessage(da1.GetString($2809, $1003));
                FServerApplicationVersion := -1;
                Result := true;
              end;
            1:
              begin
                dd1 := da1.Item[$2809, $1001];

                if assigned(dd1) and (dd1.GetCount > 0) then
                begin
                  TempFileName := 'TempFile.exe';
                  FN := ExtractFileName(ParamStr(0));
                  FNOld := FN + '.OLD';
                  dd1.AsOBData[0].SaveToFile(TempFileName);
                  ThePath := ExtractFilePath(ParamStr(0));
                  TheBatchFile := ThePath + 'ReStart.bat';
                  BatchFileList := TStringList.Create;
                  FN := ExtractFileName(ParamStr(0));
                  FNOld := FN + '.OLD';
                  try
                    FNOld := FN + '.OLD';
                    BatchFileList.Add('DEL ' + FNOld);
                    BatchFileList.Add(':xRetry');
                    BatchFileList.Add('Rename ' + FN + ' ' + FNOld);
                    BatchFileList.Add('if not exist ' + FNOld + ' goto xRetry');
                    BatchfileList.Add('Rename ' + TempFileName + ' ' + FN);
                    BatchFileList.add('Call ' + cmdline);
                    BatchFileList.add('Del ReStart.Bat');

                    BatchFileList.SaveToFile(TheBatchFile);
                    ShellExecute(0, nil, PChar(TheBatchFile), nil, nil, SW_HIDE);
                    Disconnect;
                    Application.Terminate;
                  finally
                    BatchFileList.Free;
                  end;
                end;
              end;
            2:
              begin
                FServerApplicationVersion := da1.getInteger($2809, $9);
                Result := true;
              end;
          end;
        end;
        FConnection.Clear;
      end;
  end
  else
    if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
  begin
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      case da1.getInteger($2809, $1004) of
        0:
          begin
            //              ShowMessage(da1.GetString($2809, $1003));
            FServerApplicationVersion := -1;
            Result := true;
          end;
        1:
          begin
            dd1 := da1.Item[$2809, $1001];

            if assigned(dd1) and (dd1.GetCount > 0) then
            begin
              TempFileName := 'TempFile.exe';
              FN := ExtractFileName(ParamStr(0));
              FNOld := FN + '.OLD';
              dd1.AsOBData[0].SaveToFile(TempFileName);
              ThePath := ExtractFilePath(ParamStr(0));
              TheBatchFile := ThePath + 'ReStart.bat';
              BatchFileList := TStringList.Create;
              FN := ExtractFileName(ParamStr(0));
              FNOld := FN + '.OLD';
              try
                FNOld := FN + '.OLD';
                BatchFileList.Add('DEL ' + FNOld);
                BatchFileList.Add(':xRetry');
                BatchFileList.Add('Rename ' + FN + ' ' + FNOld);
                BatchFileList.Add('if not exist ' + FNOld + ' goto xRetry');
                BatchfileList.Add('Rename ' + TempFileName + ' ' + FN);
                BatchFileList.add('Call ' + cmdline);
                BatchFileList.add('Del ReStart.Bat');

                BatchFileList.SaveToFile(TheBatchFile);
                ShellExecute(0, nil, PChar(TheBatchFile), nil, nil, SW_HIDE);
                Application.Terminate;
              finally
                BatchFileList.Free;
              end;
            end;
          end;
        2:
          begin
            FServerApplicationVersion := da1.getInteger($2809, $9);
            Result := true;
          end;
      end;
    finally
      wadodas1.Free;
    end
  end;
end;

function TCnsUserLogin.GetHospitalName: string;
begin
  result := UserHospitalName;
end;

function TCnsUserLogin.GetOEMName: string;
begin
  Result := PacsSoftwareName;
end;

function TCnsUserLogin.DoUserLogin(AUserCode, APassword: string): Boolean;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := false;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'LOGIN');
    AddVariant($2809, 5, AUserCode);
    AddVariant($2809, 6, APassword);
  end;

  //todo da1.AddVariant($20, $D, GetKeyID);

  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    da1.AddVariant($10, $10, 'DICOM');
    with FConnection do
      if C_Database(da1) then
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];
          CnsErrorCode := da1.getInteger($2809, $1004);
          if (da1.getInteger($2809, $1004) <> 1) and (da1.GetString($2809, $1003) <> '') then
          begin
            {$IFDEF NOTKEEPCONNECTION}
            Disconnect;
            {$ENDIF}
            CnsErrorMessage := dcmLoginError + da1.GetString($2809, $1003);
          end
          else
          begin
            FUserName := da1.GetString($2809, $32);
            FUserID := da1.GetInteger($2809, $20);
            fUserAuditMode := da1.GetInteger($2811, $0203);

            FDefaultInterface := da1.GetInteger($2809, $1D);
            FDefaultGroupID := da1.GetInteger($2809, $1E);
            FDefaultDept := da1.GetString($2809, $19);

            fMobilPhone := da1.GetString($2817, $C);
            //showmessage(FDefaultDept);
            FUserCode := AUserCode;
            FPassword := APassword;

            FIsSysdba := (da1.GetInteger($2809, $1F) = 2008) or (Trim(da1.GetString($2809, $31)) = 'T');

            FIsGrouper := Trim(da1.GetString($2809, $30)) = 'T';
            FIsSysdba1 := Trim(da1.GetString($2809, $38)) = 'T';
            FIsSysdba2 := Trim(da1.GetString($2809, $39)) = 'T';
            FIsSysdba3 := Trim(da1.GetString($2809, $3A)) = 'T';
            FIsSysdba4 := Trim(da1.GetString($2809, $3B)) = 'T';
            FIsSysdba5 := Trim(da1.GetString($2809, $3C)) = 'T';
            FIsSysdba6 := Trim(da1.GetString($2809, $3D)) = 'T';

            UserHospitalName := da1.GetString($2809, $10);
            PacsSoftwareName := da1.GetString($8, $80);

            FUserOwner := da1.GetString($2809, $35);
            FPermit.Text := da1.GetString($2809, $34);

            FUserClass := da1.GetInteger($2809, $33);

            Result := true;
            if assigned(FOnAfteruserLogin) then
              FOnAfteruserLogin(self);
          end;
        end;
      end;
    FConnection.Clear;
  end
  else
    if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
  begin
    da1.AddVariant($10, $10, 'INTERNET');
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      CnsErrorCode := da1.getInteger($2809, $1004);
      if (da1.getInteger($2809, $1004) <> 1) and (da1.GetString($2809, $1003) <> '') then
      begin
        CnsErrorMessage := dcmLoginError + da1.GetString($2809, $1003);
      end
      else
      begin
        FUserName := da1.GetString($2809, $32);
        FUserID := da1.GetInteger($2809, $20);
        fUserAuditMode := da1.GetInteger($2811, $0203);

        FDefaultInterface := da1.GetInteger($2809, $1D);
        FDefaultGroupID := da1.GetInteger($2809, $1E);
        FDefaultDept := da1.GetString($2809, $19);

        FUserCode := AUserCode;
        FPassword := APassword;

        FIsSysdba := da1.GetInteger($2809, $1F) = 2008;

        FIsGrouper := Trim(da1.GetString($2809, $30)) = 'T';
        FIsSysdba1 := Trim(da1.GetString($2809, $38)) = 'T';
        FIsSysdba2 := Trim(da1.GetString($2809, $39)) = 'T';
        FIsSysdba3 := Trim(da1.GetString($2809, $3A)) = 'T';
        FIsSysdba4 := Trim(da1.GetString($2809, $3B)) = 'T';
        FIsSysdba5 := Trim(da1.GetString($2809, $3C)) = 'T';
        FIsSysdba6 := Trim(da1.GetString($2809, $3D)) = 'T';

        UserHospitalName := da1.GetString($2809, $10);
        PacsSoftwareName := da1.GetString($8, $80);

        FUserOwner := da1.GetString($2809, $35);
        FPermit.Text := da1.GetString($2809, $34);

        FUserClass := da1.GetInteger($2809, $33);

        Result := true;
        if assigned(FOnAfteruserLogin) then
          FOnAfteruserLogin(self);
      end;
    finally
      wadodas1.Free;
    end
  end;
end;

function TCnsUserLogin.DoUserCheck(AUserCode, APassword: string; AClass: Integer): Boolean;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := false;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'CHKUSER');
    AddVariant($2809, 5, AUserCode);
    AddVariant($2809, 6, APassword);
    AddVariant($2809, $11, AClass);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    with FConnection do
      if C_Database(da1) then
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];
          Result := da1.getInteger($2809, $1004) = 1;
          if Result then
            CnsErrorMessage := da1.GetString($2809, $1003)
          else
            if (da1.GetString($2809, $1003) <> '') then
          begin
            {$IFDEF NOTKEEPCONNECTION}
            Disconnect;
            {$ENDIF}
            CnsErrorMessage := dcmUserCheckError + da1.GetString($2809, $1003);
          end;
        end;
      end;
  end
  else
    if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
  begin
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      Result := da1.getInteger($2809, $1004) = 1;
      if Result then
        CnsErrorMessage := da1.GetString($2809, $1003)
      else
        if (da1.GetString($2809, $1003) <> '') then
      begin
        CnsErrorMessage := dcmUserCheckError + da1.GetString($2809, $1003);
      end;
    finally
      wadodas1.Free;
    end
  end;
end;

function TCnsUserLogin.DoChangePassword(AUserCode, AStr: string): Boolean;
var
  da1: TDicomAttributes;
  wadodas1: TDicomDataset;
begin
  Result := False;
  da1 := TDicomAttributes.Create;
  with da1 do
  begin
    AddVariant($2809, 1, 'CHPWD');
    AddVariant($2809, 5, AUserCode);
    AddVariant($2809, 6, AStr);
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    with FConnection do
      if C_Database(da1) then
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          da1 := ReceiveDatasets[0];
          if (da1.getInteger($2809, $1004) <> 1) and (da1.GetString($2809, $1003) <> '') then
          begin
            {$IFDEF NOTKEEPCONNECTION}
            Disconnect;
            {$ENDIF}
            raise Exception.Create(V_CHANGE_PASSWORD_ERROR + da1.GetString($2809, $1003));
          end
          else
            Result := true;
        end;
      end;
  end
  else
    if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
  begin
    wadodas1 := DoHttpPostDatabase(da1);
    if wadodas1 <> nil then
    try
      da1 := wadodas1.Attributes;
      if (da1.getInteger($2809, $1004) <> 1) and (da1.GetString($2809, $1003) <> '') then
      begin
        raise Exception.Create(V_CHANGE_PASSWORD_ERROR + da1.GetString($2809, $1003));
      end
      else
        Result := true;
    finally
      wadodas1.Free;
    end
  end;
end;

procedure TCnsUserLogin.SetConnection(
  const Value: TCnsCustomDicomConnection);
begin
  FConnection := Value;
  FGroupTable.AppSrvClient := FConnection;
end;

function TCnsUserLogin.GetGroupTable: TCnsDBTable;
begin
  if assigned(FGroupTable.AppSrvClient) and (not FGroupTable.Active) then
    FGroupTable.RefreshTable;
  Result := FGroupTable;
end;

function TCnsUserLogin.DoListUser: Boolean;
var
  das1: TDicomAttributes;
  da1, da2: TDicomAttribute;
  str1, str2: string;
  u1: TCnsUserItem;
  i: integer;
  l1: TList;
  wadodas1: TDicomDataset;
begin
  Result := false;
  l1 := FUserList.LockList;
  try
    for i := 0 to l1.Count - 1 do
    begin
      TCnsUserItem(l1[i]).OnLine := false;
    end;
  finally
    FUserList.UnlockList;
  end;
  das1 := TDicomAttributes.Create;
  with das1 do
  begin
    AddVariant($2809, 1, 'LISTUSER');
  end;
  if fTableLoadMode in [cnsLoadFromNetwork, cnsLoadFromNetworkEx] then
  begin
    with FConnection do
      if C_Database(das1) then
      begin
        if ReceiveDatasets.Count > 0 then
        begin
          das1 := ReceiveDatasets[0];

          da1 := das1.Item[$2809, $30];
          da2 := das1.Item[$2809, $31];
          if (da1 <> nil) and (da2 <> nil) then
          begin
            for i := 0 to da1.GetCount - 1 do
            begin
              str1 := Trim(da1.AsString[i]);
              str2 := Trim(da2.AsString[i]);
              if str1 <> Username then
              begin
                u1 := FindUserItem(str1, str2);
                if u1 = nil then
                begin
                  u1 := TCnsUserItem.Create;
                  u1.UserName := str1;
                  u1.IP := str2;
                  FUserList.Add(u1);
                end;
                u1.OnLine := true;
              end;
            end;
            Result := true;
          end;
        end;
      end;
    FConnection.Clear;
  end
  else
    if fTableLoadMode in [cnsLoadFromWadoPost, cnsLoadFromWadoPostEx] then
  begin
    wadodas1 := DoHttpPostDatabase(das1);
    if wadodas1 <> nil then
    try
      das1 := wadodas1.Attributes;
      da1 := das1.Item[$2809, $30];
      da2 := das1.Item[$2809, $31];
      if (da1 <> nil) and (da2 <> nil) then
      begin
        for i := 0 to da1.GetCount - 1 do
        begin
          str1 := Trim(da1.AsString[i]);
          str2 := Trim(da2.AsString[i]);
          if str1 <> Username then
          begin
            u1 := FindUserItem(str1, str2);
            if u1 = nil then
            begin
              u1 := TCnsUserItem.Create;
              u1.UserName := str1;
              u1.IP := str2;
              FUserList.Add(u1);
            end;
            u1.OnLine := true;
          end;
        end;
        Result := true;
      end;
    finally
      wadodas1.Free;
    end
  end;

  //free all no online user
  l1 := FUserList.LockList;
  try
    for i := l1.Count - 1 downto 0 do
    begin
      u1 := TCnsUserItem(l1[i]);
      if not u1.OnLine then
      begin
        //if u1.DialogForm = nil then
        begin
          u1.Free;
          l1.Delete(i);
        end;
      end;
    end;
  finally
    FUserList.UnlockList;
  end;
end;

{ TCnsUserItem }

constructor TCnsUserItem.Create;
begin
  FPort := 6006;
  FCurrentProfile := '';
  FStatus := '';
  FUserName := '';
  FIP := '';
  FDialogForm := nil;
end;

destructor TCnsUserItem.Destroy;
begin
  if FDialogForm <> nil then
    FDialogForm.Free;
  inherited;
end;

procedure TCnsUserItem.SetCurrentProfile(const Value: string);
begin
  FCurrentProfile := Value;
end;

procedure TCnsUserItem.SetDialogForm(const Value: TForm);
begin
  FDialogForm := Value;
end;

procedure TCnsUserItem.SetIP(const Value: string);
begin
  FIP := Value;
end;

procedure TCnsUserItem.SetOnLine(const Value: Boolean);
begin
  FOnLine := Value;
end;

procedure TCnsUserItem.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

procedure TCnsUserItem.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

procedure TCnsUserItem.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

function TCnsUserLogin.GetItems(index: Integer): TCnsUserItem;
var
  //  i: Integer;
  l1: TList;
begin
  l1 := FUserList.lockList;
  try
    Result := TCnsUserItem(l1[Index]);
  finally
    FUserList.UnlockList;
  end;
end;

function TCnsUserLogin.GetUserItemCount: Integer;
var
  l1: TList;
begin
  l1 := FUserList.lockList;
  try
    Result := l1.Count;
  finally
    FUserList.UnlockList;
  end;
end;

function TCnsUserLogin.FindUserItem(AUserName, AIP: string): TCnsUserItem;
var
  i: Integer;
  u1: TCnsUserItem;
  l1: TList;
begin
  Result := nil;
  l1 := FUserList.LockList;
  try
    for i := 0 to l1.Count - 1 do
    begin
      u1 := TCnsUserItem(l1[i]);
      if (Trim(u1.UserName) = AUserName) and (Trim(u1.IP) = AIP) then
      begin
        Result := u1;
        break;
      end;
    end;
  finally
    FUserList.UnlockList;
  end;
end;

procedure TCnsUserLogin.SetMobilPhone(const Value: string);
begin
  FMobilPhone := Value;
end;

procedure TCnsDBTable.DoBeforePost;
var
  f1: TField;
begin
  inherited;
  if FAddUpdateTime then
  begin
    f1 := FindField('LASTUPDATEDATE');
    if f1 <> nil then
    begin
      f1.AsDateTime := now;
    end;
  end;
end;

procedure TCnsDicomPrinter.SetPrintWithDefaultParam(const Value: Boolean);
begin
  FPrintWithDefaultParam := Value;
end;

procedure TCnsDMTable.SetData1(const Value: TObject);
begin
  FData1 := Value;
end;

procedure TCnsDMTable.SetData2(const Value: TObject);
begin
  FData2 := Value;
end;

function TCnsCustomDicomConnection.M_Database(
  ADataset: TDicomAttributes; var aResponseDataset: TDicomAttributes; var aStream: TStream): Boolean;
begin

end;

function TCnsCustomDicomConnection.GetReceiveStreams: TList;
begin
  Result := nil;
end;

procedure TCnsDBTable.SetAddUpdateTime(const Value: Boolean);
begin
  FAddUpdateTime := Value;
end;

{ TCnsCustomDicomConnectionPoll }

procedure TCnsCustomDicomConnectionPoll.Clear;
//var
//  i: Integer;
begin

end;

constructor TCnsCustomDicomConnectionPoll.Create(AOwner: TComponent);
begin
  inherited;
  fConectList := TList.Create;
  fTimer := TTimer.Create(self);
  FTimer.Enabled := false;
  FTimer.Interval := 1000;
  FTimer.OnTimer := DoCheckTimeout;

end;

destructor TCnsCustomDicomConnectionPoll.Destroy;
begin
  Clear;

  fConectList.Free;

  fTimer.Free;
  inherited;
end;

procedure TCnsCustomDicomConnectionPoll.DoCheckTimeout(Sender: TObject);
begin

end;

function TCnsCustomDicomConnectionPoll.GetConnection: TCnsCustomDicomConnection;
begin

end;

procedure TCnsDBTable.SetConnectionPoll(
  const Value: TCnsCustomDicomConnectionPoll);
begin
  FConnectionPoll := Value;
end;

function TCnsUserLogin.UpdateDatetime: Boolean;
var
  dSysTime: TSystemTime;
  time1: TDatetime;
  f1: Double;
begin
  Result := false;
  if not (FConnection is TCnsDicomConnection) then
    exit;
  time1 := GetSeverTime;
  f1 := abs(time1 - now);
  //  ShowMessage(FormatDatetime('hh:nn:ss-ZZZZZZ',TDatetime(f1)));
  if (f1 > 0.0001) then
  begin
    DateTimeToSystemTime(time1, dSysTime);
    Windows.SetLocalTime(dSysTime);
  end;
end;

procedure TCnsDBTable.DeleteDetailDataset(AIndex: AnsiString);
var
  i: integer;
  d1: TCnsDBTable;
begin
  d1 := nil;
  for i := 0 to FDetailDatasetList.Count - 1 do
  begin
    d1 := TCnsDBTable(FDetailDatasetList[i]);
    if d1.ObjectName = AIndex then
    begin
      break;
    end;
  end;
  FDetailDatasetList.Remove(d1);
  d1.Free;
end;

procedure TCnsDBTable.DeleteDetailDataset(AIndex: Integer);
var
//  i: integer;
  d1: TCnsDBTable;
begin
  if AIndex < FDetailDatasetList.Count then
  begin
    d1 := TCnsDBTable(FDetailDatasetList[AIndex]);
    FDetailDatasetList.Delete(AIndex);

    d1.Free;
  end;
end;

procedure TCnsDBTable.DeleteDetailDataset(AIndex: TCnsDBTable);
begin
  if (AIndex <> nil) and (FDetailDatasetList.IndexOf(AIndex) >= 0) then
  begin
    FDetailDatasetList.Remove(AIndex);
    AIndex.Free;
  end;
end;

initialization
  CnsErrorMessage := '';
  //  CurrentUserLimit := '';
  CurrentTempImageIndex := 0;

  Randomize;

  FLocalImagesTable := nil;
  FLocalStudiesTable := nil;

finalization
  if assigned(FLocalImagesTable) then
    FLocalImagesTable.Free;
  if assigned(FLocalStudiesTable) then
    FLocalStudiesTable.Free;

  {
   C_FIND MWL
  var
    da1, da2: TDicomAttributes;
    dd: TDicomAttribute;
    con1: TCnsDicomConnection;
    i: integer;
  begin
    da1 := TDicomAttributes.Create;
    with da1 do
    begin
      Add($0008, $0050); //(AccessionNumber)SH=<0>NULL
      Add($0008, $0090); //(ReferringPhysiciansName)PN=<0>NULL
      Add($0010, $0010); //(PatientName)PN=<0>NULL
      Add($0010, $0020); //(PatientID)LO=<1>31399
      Add($0010, $0030); //(PatientBirthDate)DA=<0>NULL
      Add($0010, $0040); //(PatientSex)CS=<0>NULL
      Add($0020, $000D); //(StudyInstanceUID)UI=<0>NULL
      Add($0032, $1060); //(RequestedProcedureDescription)LO=<0>NULL
      dd := Add($0040, $0100); //(ScheduledProcedureStepSequence)SQ=<1>Sequence Data
      da2 := TDicomAttributes.Create;
      dd.AddData(da2);
      da2.AddVariant($0008, $0060,'DX'); //(Modality)CS=<1>DX
      da2.Add($0040, $0001); //(ScheduledStationAETitle)AE=<1>HBLB
      dd := da2.Add($0040, $0002); //(ScheduledProcedureStepStartDate)DA=<1>2004-9-23 15:10:54
      dd.AsDatetime[0] := now-5;
      dd.AsDatetime[1] := now;
      da2.Add($0040, $0003); //(ScheduledProcedureStepStartTime)TM=<0>NULL
      da2.Add($0040, $0006); //(ScheduledPerformingPhysiciansName)PN=<0>NULL
      da2.Add($0040, $0007); //(ScheduledProcedureStepDescription)LO=<0>NULL
      da2.Add($0040, $0009); //(ScheduledProcedureStepID)SH=<0>NULL
      da2.Add($0040, $0010); //(ScheduledStationName)SH=<0>NULL
      Add($0040, $1001); //(RequestedProcedureID)SH=<0>NULL
    end;

    con1 := TCnsDicomConnection.Create(self);
    con1.Host := '127.0.0.1';
    con1.Port := 104;
    con1.CallingTitle := '1';
    con1.CalledTitle := '1';
    try
      if con1.C_MWL(da1) then
      begin
        if con1.ReceiveDatasets.Count > 0 then
        begin
          for i := 0 to con1.ReceiveDatasets.Count - 1 do
          begin
            da1 := con1.ReceiveDatasets[i];

          end;
        end;
      end;
    finally
      con1.Free;
    end;
  }
  {
  CFIND
      da1 := TDicomAttributes.Create;
      with da1 do
      begin
        Add($0008, $0020); //(StudyDate)DA=<0>NULL
        Add($0008, $0030); //(StudyTime)TM=<0>NULL
        Add($0008, $0050); //(AccessionNumber)SH=<0>NULL
        AddVariant($0008, $0052, 'PATIENT'); //(QueryRetrieveLevel)CS=<1>STUDY
        Add($0008, $0061); //(ModalitiesInStudy)CS=<0>NULL
        Add($0008, $0090); //(ReferringPhysiciansName)PN=<0>NULL
        Add($0008, $1030); //(StudyDescription)LO=<0>NULL
        Add($0008, $1048); //(PhysiciansOfRecord)PN=<0>NULL
        Add($0008, $1060); //(NameOfPhysiciansReadingStudy)PN=<0>NULL
        Add($0008, $1080); //(AdmittingDiagnosisDescription)LO=<0>NULL
        Add($0010, $0010); //(PatientName)PN=<0>NULL
        Add($0010, $0020); //(PatientID)LO=<0>NULL
        Add($0010, $0030); //(PatientBirthDate)DA=<0>NULL
        Add($0010, $0032); //(PatientBirthTime)TM=<0>NULL
        Add($0010, $0040); //(PatientSex)CS=<0>NULL
        Add($0010, $1000); //(OtherPatientID)LO=<0>NULL
        Add($0010, $1001); //(OtherPatientNames)PN=<0>NULL
        Add($0010, $1010); //(PatientAge)AS=<0>NULL
        Add($0010, $1020); //(PatientSize)DS=<0>NULL
        Add($0010, $1030); //(PatientWeight)DS=<0>NULL
        Add($0010, $2160); //(EthnicGroup)SH=<0>NULL
        Add($0010, $2180); //(Occupation)SH=<0>NULL
        Add($0010, $21B0); //(AdditionalPatientHistory)LT=<0>NULL
        Add($0010, $4000); //(PatientComments)LT=<0>NULL
        Add($0020, $000D); //(StudyInstanceUID)UI=<0>NULL
        Add($0020, $0010); //(StudyID)SH=<0>NULL
        Add($0020, $1206); //(NumberOfStudyRelatedSeries)IS=<0>NULL
        Add($0020, $1208); //(NumberOfStudyRelatedImages)IS=<0>NULL
      end;
      if Client1.C_FIND(da1) then
      begin
        if Client1.FAssociation.ReceiveDatasets.Count > 0 then
        begin
          for i := 0 to Client1.FAssociation.ReceiveDatasets.Count - 1 do
          begin
            da1 := Client1.FAssociation.ReceiveDatasets[i];
            da1.ListAttrinute('', memo1.Lines);
          end;
        end;
      end;
  }
end.

