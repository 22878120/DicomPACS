�
 TFRMSETGLAVVRACH 0�  TPF0TfrmSetGlavVrachfrmSetGlavVrachLeft�TopJBorderStylebsDialogCaption:   Выбор руководителя организацииClientHeight5ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameTahoma
Font.Style OldCreateOrderPositionpoScreenCenterPixelsPerInch`
TextHeight TcxGridcxGrZavOtdelAlignWithMargins	LeftTop"Width�HeightMargins.Top AlignalClientTabOrder LookAndFeel.KindlfFlatLookAndFeel.SkinName ExplicitLeft ExplicitTopExplicitWidth�ExplicitHeight TcxGridDBTableViewTVGLAVVRACH	OnKeyDownTVGLAVVRACHKeyDownNavigatorButtons.ConfirmDeleteOnCellDblClickTVGLAVVRACHCellDblClickDataController.DataSourcedsGlavVrach/DataController.Summary.DefaultGroupSummaryItems )DataController.Summary.FooterSummaryItemsKindskCount	FieldNameFK_IDColumnVGLAVVRACHFIO  $DataController.Summary.SummaryGroups OptionsBehavior.CellHints	OptionsBehavior.IncSearch	 OptionsCustomize.ColumnFilteringOptionsData.CancelOnExitOptionsData.Deleting OptionsData.DeletingConfirmationOptionsData.EditingOptionsData.InsertingOptionsView.ColumnAutoWidth	OptionsView.Footer	OptionsView.GroupByBoxOptionsView.Indicator	 TcxGridDBColumnVGLAVVRACHFIOCaption&   Фамилия Имя ОтчествоDataBinding.FieldNameFC_NAMEWidth�   TcxGridDBColumnVGLAVVRACHNAMESPECCaption   !?5F80;870F8ODataBinding.FieldNameNAMESPECWidth�    TcxGridLevelcxGrZavOtdelLevel1GridViewTVGLAVVRACH   TdxBarDockControldxBarDockControl1AlignWithMargins	LeftTopWidth�HeightAligndalTop
BarManagerdxBMSunkenBorder	UseOwnSunkenBorder	  TActionListactlst1ImagesfrmMain.ilMainLeft� TopP TActionactSetCaption	   !>E@0=8BLHint	   !>E@0=8BL
ImageIndexShortCutq	OnExecuteactSetExecute  TAction	actCancelCaption   B<5=0Hint   B<5=0
ImageIndexShortCut	OnExecuteactCancelExecute   TdxBarManagerdxBM
AllowResetAutoDockColorFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSegoe UI
Font.Style Categories.StringsDefault Categories.ItemsVisibles Categories.Visibles	 	DockColor	clBtnFaceImageOptions.ImagesfrmMain.ilMainLookAndFeel.KindlfFlat
NotDockingdsNonedsLeftdsTopdsRightdsBottom PopupMenuLinks StylebmsUseLookAndFeelUseSystemFont	Left� Top� DockControlHeights      TdxBardxBMBar1
AllowCloseAllowCustomizingAllowQuickCustomizing
AllowResetCaptionOKCancelCaptionButtons DockControldxBarDockControl1DockedDockControldxBarDockControl1
DockedLeft 	DockedTop 	FloatLeft�FloatTop`FloatClientWidthRFloatClientHeight,	ItemLinksVisible	ItemNamebbOk Visible	ItemNamebbCancel  
NotDockingdsNonedsLeftdsTopdsRightdsBottom OneOnRow	Row 
UseOwnFontVisible	WholeRow	  TdxBarButtonbbOkActionactSetCategory 
PaintStylepsCaptionGlyph  TdxBarButtonbbCancelAction	actCancelCategory 
PaintStylepsCaptionGlyph   TOracleDataSetodsGlavVrachSQL.Strings9SELECT TSOTR.FK_ID, TSOTR.FC_FAM, TSOTR.FC_FAM || ' ' || Z       DECODE(VarcharIsNUll(TSOTR.FC_NAME), 1, '', SUBSTR(TSOTR.FC_NAME, 0, 1) || '. ' || e       DECODE (VarcharIsNUll(TSOTR.FC_OTCH), 1, '', SUBSTR(TSOTR.FC_OTCH, 0, 1) || '. ')) AS FC_NAME,$       TS_SPRAV.FC_NAME AS NAMESPEC  FROM ASU.TSOTR, ASU.TS_SPRAV ( WHERE TSOTR.FK_SPRAVID = TS_SPRAV.FK_ID   AND TSOTR.FL_DEL = 0 ORDER BY FC_FAM  OptimizeQBEDefinition.QBEFieldDefs
J            FK_ID        FC_FAM        FC_NAME        NAMESPEC     Cursor	crSQLWaitSessionfrmMain.osMainLeft0Top�   TDataSourcedsGlavVrachDataSetodsGlavVrachLeftpTop�    