�
 TFRMADDEDITREP 0�  TPF0TfrmAddEditRepfrmAddEditRepLeft�ToplBorderStylebsDialogCaption3   Параметры методики в отчётеClientHeight� ClientWidth� Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameTahoma
Font.Style OldCreateOrderPositionpoScreenCenterOnCreate
FormCreatePixelsPerInch`
TextHeight TdxBarDockControldxBarDockControl1AlignWithMargins	LeftTopWidth� HeightAligndalTop
BarManagerdxBMSunkenBorder	UseOwnSunkenBorder	ExplicitLeft ExplicitTop ExplicitWidth  TPanelpnl1AlignWithMargins	LeftTop"Width� Height}Margins.Top AlignalClient
BevelInnerbvRaised
BevelOuter	bvLoweredTabOrderExplicitLeft ExplicitTopExplicitWidthExplicitHeight�  TcxLabelcxLabel1LeftTopCaption   Форма:  TcxLookupComboBoxcxFormaLeft@TopHint   Группы диагнозовProperties.AutoSelectProperties.DropDownListStylelsFixedListProperties.DropDownSizeable	Properties.GridMode	Properties.HideSelectionProperties.ImmediatePost	Properties.KeyFieldNamesFK_IDProperties.ListColumns	FieldNameFC_NAME  !Properties.ListOptions.ShowHeaderProperties.ListSourcedsFormaProperties.ReadOnlyStyle.LookAndFeel.SkinNameOffice2007Green"StyleDisabled.LookAndFeel.SkinNameOffice2007Green!StyleFocused.LookAndFeel.SkinNameOffice2007GreenStyleHot.LookAndFeel.SkinNameOffice2007GreenTabOrderWidth�   TcxLabelcxLabel2LeftTop)Caption   Таблица:  TcxLookupComboBoxcxTableLeft@Top(Hint   Группы диагнозовProperties.AutoSelectProperties.DropDownListStylelsFixedListProperties.DropDownSizeable	Properties.GridMode	Properties.HideSelectionProperties.ImmediatePost	Properties.KeyFieldNamesFC_NAMEProperties.ListColumns	FieldNameFC_NAME  !Properties.ListOptions.ShowHeaderProperties.ListSourcedsTableProperties.ReadOnlyStyle.LookAndFeel.SkinNameOffice2007Green"StyleDisabled.LookAndFeel.SkinNameOffice2007Green!StyleFocused.LookAndFeel.SkinNameOffice2007GreenStyleHot.LookAndFeel.SkinNameOffice2007GreenTabOrderWidth�   TcxLabelcxLabel3LeftTopACaption   Строка:  TcxLabelcxLabel4LeftTopZCaption   Столбец:  TcxSpinEditcxSpinEdit1Left@TopAProperties.SpinButtons.VisibleStyle.LookAndFeel.SkinNameOffice2007Green"StyleDisabled.LookAndFeel.SkinNameOffice2007Green!StyleFocused.LookAndFeel.SkinNameOffice2007GreenStyleHot.LookAndFeel.SkinNameOffice2007GreenTabOrderWidthC  TcxSpinEditcxSpinEdit2Left@TopZProperties.SpinButtons.VisibleStyle.LookAndFeel.SkinNameOffice2007Green"StyleDisabled.LookAndFeel.SkinNameOffice2007Green!StyleFocused.LookAndFeel.SkinNameOffice2007GreenStyleHot.LookAndFeel.SkinNameOffice2007GreenTabOrderWidthC   TdxBarManagerdxBMFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSegoe UI
Font.Style Categories.Strings   По умолчанию Categories.ItemsVisibles Categories.Visibles	 ImageOptions.ImagesfrmMain.ilMainPopupMenuLinks UseSystemFont	Left� Top DockControlHeights      TdxBardxBMBar1
AllowCloseAllowCustomizingAllowQuickCustomizing
AllowResetCaptionOKCancelCaptionButtons DockControldxBarDockControl1DockedDockControldxBarDockControl1
DockedLeft 	DockedTop 	FloatLeftSFloatToplFloatClientWidth FloatClientHeight 	ItemLinksVisible	ItemNamebbOK Visible	ItemNamebbCancel  
NotDockingdsNonedsLeftdsTopdsRightdsBottom OneOnRow	Row 
UseOwnFontVisible	WholeRow	  TdxBarButtonbbOKActionactOkCategory 
PaintStylepsCaptionGlyph  TdxBarButtonbbCancelAction	actCancelCategory 
PaintStylepsCaptionGlyph   TActionListactlst1ImagesfrmMain.ilMainLeft� Topp TActionactOkCaption	   !>E@0=8BLHint	   !>E@0=8BL
ImageIndex	OnExecuteactOkExecute  TAction	actCancelCaption   B<5=0Hint   B<5=0
ImageIndexShortCut	OnExecuteactCancelExecute   TDataSourcedsFormaDataSetodsFormaLeft� TopZ  TOracleDataSetodsFormaSQL.StringsSELECT * FROM TS_COLUMNNAZWHERE FK_OWNER = -1ORDER BY FK_ID OptimizeQBEDefinition.QBEFieldDefs
�            FK_ID        FC_NAME        FK_OWNER        FK_SMID        FL_DEL     
   FC_SYNONIM        FC_TABLENAME     Cursor	crSQLWaitSession
frmMain.osLeft� TopZ  TOracleDataSetodsTableSQL.Strings(SELECT DISTINCT(FC_TABLENAME) AS FC_NAME  FROM TS_COLUMNNAZ WHERE FK_OWNER = 1ORDER BY FC_TABLENAME  OptimizeQBEDefinition.QBEFieldDefs
            FC_NAME     Cursor	crSQLWaitSession
frmMain.osLeft� Top�   TDataSourcedsTableDataSetodsTableLeft� Top�    