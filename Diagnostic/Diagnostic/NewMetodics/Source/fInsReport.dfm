�
 TFRMINSREPORT 0�  TPF0TfrmInsReportfrmInsReportLeft0Top� Caption5   Добавление методики в отчётыClientHeight�ClientWidth^Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameTahoma
Font.Style OldCreateOrderPositionpoScreenCenterPixelsPerInch`
TextHeight TdxBarDockControldxBarDockControl1AlignWithMargins	LeftTopWidthXHeightAligndalTop
BarManagerdxBMSunkenBorder	UseOwnSunkenBorder	ExplicitLeft ExplicitTop ExplicitWidth^  TcxGridcxGrid1AlignWithMargins	LeftTop"WidthXHeight�Margins.Top AlignalClientTabOrderLookAndFeel.KindlfFlatExplicitLeft ExplicitTopExplicitWidth^ExplicitHeight� TcxGridDBTableViewTVREPNavigatorButtons.ConfirmDelete/DataController.Summary.DefaultGroupSummaryItems )DataController.Summary.FooterSummaryItemsKindskCountColumnVREPColumn1  $DataController.Summary.SummaryGroups OptionsBehavior.CellHints	OptionsBehavior.IncSearch	*OptionsCustomize.ColumnsQuickCustomization	OptionsData.CancelOnExitOptionsData.Deleting OptionsData.DeletingConfirmationOptionsData.EditingOptionsData.InsertingOptionsSelection.CellSelectOptionsView.ColumnAutoWidth	OptionsView.Footer	OptionsView.Indicator	 TcxGridDBColumnVREPColumn1Caption   $>@<0VisibleForCustomizationWidthl  TcxGridDBColumnVREPColumn2Caption   "01;8F0Width�   TcxGridDBColumnVREPColumn3Caption   !B@>:0Width�   TcxGridDBColumnVREPColumn4Caption   !B>;15FWidth�    TcxGridLevelcxGrid1Level1GridViewTVREP   TdxBarManagerdxBMFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSegoe UI
Font.Style Categories.Strings   По умолчанию Categories.ItemsVisibles Categories.Visibles	 ImageOptions.ImagesfrmMain.ilMainPopupMenuLinks UseSystemFont	Left�Top� DockControlHeights      TdxBardxBMBar1
AllowCloseAllowCustomizingAllowQuickCustomizing
AllowResetCaption	InsReportCaptionButtons DockControldxBarDockControl1DockedDockControldxBarDockControl1
DockedLeft 	DockedTop 	FloatLeft� FloatTopXFloatClientWidth FloatClientHeight 	ItemLinksVisible	ItemNamebb1 Visible	ItemNamebb2 Visible	ItemNamebb3 
BeginGroup	Visible	ItemNamebb4 
BeginGroup	Visible	ItemNamebbClose  
NotDockingdsNonedsLeftdsTopdsRightdsBottom OneOnRow	Row 
UseOwnFontVisible	WholeRow	  TdxBarButtonbb1ActionactAddCategory 
PaintStylepsCaptionGlyph  TdxBarButtonbb2ActionactEditCategory 
PaintStylepsCaptionGlyph  TdxBarButtonbb3ActionactDelCategory 
PaintStylepsCaptionGlyph  TdxBarButtonbb4Action
actRefreshCategory 
PaintStylepsCaptionGlyph  TdxBarButtonbbCloseActionactCloseCategory 
PaintStylepsCaptionGlyph   TActionListactlstInsRepImagesfrmMain.ilMainLeft�Top�  TActionactAddCaption   >1028BLHint   >1028BL
ImageIndex ShortCuts	OnExecuteactAddExecute  TActionactEditCaption   7<5=8BLHint   7<5=8BL
ImageIndexShortCutr	OnExecuteactEditExecute  TActionactDelCaption   #40;8BLHint   #40;8BL
ImageIndexShortCutw	OnExecuteactDelExecute  TActionactCloseCaption   0:@KBLHint   Закрыть форму
ImageIndex	OnExecuteactCloseExecute  TAction
actRefreshCaption   1=>28BLHint   1=>28BL
ImageIndexShortCutt	OnExecuteactRefreshExecute   TDataSource	dsListRepDataSet
odsListRepLeft@Top�   TOracleDataSet
odsListRepSQL.Strings2SELECT TS_COLUMNNAZ.FC_NAME, TS_COLUMNNAZ.FK_OWNER  FROM TS_COLUMNNAZ, TSMID) WHERE TS_COLUMNNAZ.FK_SMID = TSMID.FK_ID@      AND TSMID.FC_TYPE = '582АИРМ_НОВАЯ_МЕТОДИКА'   AND TSMID.FK_ID = :PFK_ID OptimizeVariables.Data
            :PFK_ID           Cursor	crSQLWaitSession
frmMain.os
BeforeOpenodsListRepBeforeOpenLeft@Topx   