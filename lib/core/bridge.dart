import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'ffi/mxml_library.dart';
import 'ffi/mxml_signatures.dart';
import 'ffi/mxml_types.dart';

export 'ffi/mxml_types.dart';

class MXMLBridge {
  static late final MxmlLibrary _library;
  static const int _boolTrue = 1;
  static const int _boolFalse = 0;
  
  static late final MxmlCreate _create;
  static late final MxmlDestroy _destroy;
  static late final MxmlLoadFile _loadFile;
  static late final MxmlLayout _layout;
  static late final MxmlGetHeight _getHeight;
  static late final MxmlGetGlyphCodepoint _getGlyphCodepoint;
  static late final MxmlGetRenderCommands _getRenderCommands;
  static late final MxmlGetString _getString;
  static late final MxmlWriteSvgToFile _writeSvgToFile;
  static late final MxmlGetPipelineBench _getPipelineBench;
  static late final MxmlOptionsCreate _optionsCreate;
  static late final MxmlOptionsDestroy _optionsDestroy;
  static late final MxmlOptionsApplyStandard _optionsApplyStandard;
  static late final MxmlOptionsApplyPiano _optionsApplyPiano;
  static late final MxmlOptionsApplyPianoPedagogic _optionsApplyPianoPedagogic;
  static late final MxmlOptionsApplyCompact _optionsApplyCompact;
  static late final MxmlOptionsApplyPrint _optionsApplyPrint;
  static late final MxmlLayoutWithOptions _layoutWithOptions;
  static late final OptionsSetBool _setRenderingDrawTitle;
  static late final OptionsGetBool _getRenderingDrawTitle;
  static late final OptionsSetBool _setRenderingDrawPartNames;
  static late final OptionsGetBool _getRenderingDrawPartNames;
  static late final OptionsSetBool _setRenderingDrawMeasureNumbers;
  static late final OptionsGetBool _getRenderingDrawMeasureNumbers;
  static late final OptionsSetBool _setRenderingDrawMeasureNumbersOnlyAtSystemStart;
  static late final OptionsGetBool _getRenderingDrawMeasureNumbersOnlyAtSystemStart;
  static late final OptionsSetInt _setRenderingDrawMeasureNumbersBegin;
  static late final OptionsGetInt _getRenderingDrawMeasureNumbersBegin;
  static late final OptionsSetInt _setRenderingMeasureNumberInterval;
  static late final OptionsGetInt _getRenderingMeasureNumberInterval;
  static late final OptionsSetBool _setRenderingDrawTimeSignatures;
  static late final OptionsGetBool _getRenderingDrawTimeSignatures;
  static late final OptionsSetBool _setRenderingDrawKeySignatures;
  static late final OptionsGetBool _getRenderingDrawKeySignatures;
  static late final OptionsSetBool _setRenderingDrawFingerings;
  static late final OptionsGetBool _getRenderingDrawFingerings;
  static late final OptionsSetBool _setRenderingDrawSlurs;
  static late final OptionsGetBool _getRenderingDrawSlurs;
  static late final OptionsSetBool _setRenderingDrawPedals;
  static late final OptionsGetBool _getRenderingDrawPedals;
  static late final OptionsSetBool _setRenderingDrawDynamics;
  static late final OptionsGetBool _getRenderingDrawDynamics;
  static late final OptionsSetBool _setRenderingDrawWedges;
  static late final OptionsGetBool _getRenderingDrawWedges;
  static late final OptionsSetBool _setRenderingDrawLyrics;
  static late final OptionsGetBool _getRenderingDrawLyrics;
  static late final OptionsSetBool _setRenderingDrawCredits;
  static late final OptionsGetBool _getRenderingDrawCredits;
  static late final OptionsSetBool _setRenderingDrawComposer;
  static late final OptionsGetBool _getRenderingDrawComposer;
  static late final OptionsSetBool _setRenderingDrawLyricist;
  static late final OptionsGetBool _getRenderingDrawLyricist;
  static late final OptionsSetString _setLayoutPageFormat;
  static late final OptionsGetString _getLayoutPageFormat;
  static late final OptionsSetBool _setLayoutUseFixedCanvas;
  static late final OptionsGetBool _getLayoutUseFixedCanvas;
  static late final OptionsSetDouble _setLayoutFixedCanvasWidth;
  static late final OptionsGetDouble _getLayoutFixedCanvasWidth;
  static late final OptionsSetDouble _setLayoutFixedCanvasHeight;
  static late final OptionsGetDouble _getLayoutFixedCanvasHeight;
  static late final OptionsSetDouble _setLayoutPageHeight;
  static late final OptionsGetDouble _getLayoutPageHeight;
  static late final OptionsSetDouble _setLayoutPageMarginLeftStaffSpaces;
  static late final OptionsGetDouble _getLayoutPageMarginLeftStaffSpaces;
  static late final OptionsSetDouble _setLayoutPageMarginRightStaffSpaces;
  static late final OptionsGetDouble _getLayoutPageMarginRightStaffSpaces;
  static late final OptionsSetDouble _setLayoutPageMarginTopStaffSpaces;
  static late final OptionsGetDouble _getLayoutPageMarginTopStaffSpaces;
  static late final OptionsSetDouble _setLayoutPageMarginBottomStaffSpaces;
  static late final OptionsGetDouble _getLayoutPageMarginBottomStaffSpaces;
  static late final OptionsSetDouble _setLayoutSystemSpacingMinStaffSpaces;
  static late final OptionsGetDouble _getLayoutSystemSpacingMinStaffSpaces;
  static late final OptionsSetDouble _setLayoutSystemSpacingMultiStaffMinStaffSpaces;
  static late final OptionsGetDouble _getLayoutSystemSpacingMultiStaffMinStaffSpaces;
  static late final OptionsSetBool _setLayoutNewSystemFromXml;
  static late final OptionsGetBool _getLayoutNewSystemFromXml;
  static late final OptionsSetBool _setLayoutNewPageFromXml;
  static late final OptionsGetBool _getLayoutNewPageFromXml;
  static late final OptionsSetBool _setLayoutFillEmptyMeasuresWithWholeRest;
  static late final OptionsGetBool _getLayoutFillEmptyMeasuresWithWholeRest;
  static late final OptionsSetDouble _setLineBreakingJustificationRatioMin;
  static late final OptionsGetDouble _getLineBreakingJustificationRatioMin;
  static late final OptionsSetDouble _setLineBreakingJustificationRatioMax;
  static late final OptionsGetDouble _getLineBreakingJustificationRatioMax;
  static late final OptionsSetDouble _setLineBreakingJustificationRatioTarget;
  static late final OptionsGetDouble _getLineBreakingJustificationRatioTarget;
  static late final OptionsSetDouble _setLineBreakingJustificationRatioSoftMin;
  static late final OptionsGetDouble _getLineBreakingJustificationRatioSoftMin;
  static late final OptionsSetDouble _setLineBreakingJustificationRatioSoftMax;
  static late final OptionsGetDouble _getLineBreakingJustificationRatioSoftMax;
  static late final OptionsSetDouble _setLineBreakingWeightRatio;
  static late final OptionsGetDouble _getLineBreakingWeightRatio;
  static late final OptionsSetDouble _setLineBreakingWeightTight;
  static late final OptionsGetDouble _getLineBreakingWeightTight;
  static late final OptionsSetDouble _setLineBreakingWeightLoose;
  static late final OptionsGetDouble _getLineBreakingWeightLoose;
  static late final OptionsSetDouble _setLineBreakingWeightLastUnder;
  static late final OptionsGetDouble _getLineBreakingWeightLastUnder;
  static late final OptionsSetDouble _setLineBreakingCostPower;
  static late final OptionsGetDouble _getLineBreakingCostPower;
  static late final OptionsSetBool _setLineBreakingStretchLastSystem;
  static late final OptionsGetBool _getLineBreakingStretchLastSystem;
  static late final OptionsSetDouble _setLineBreakingLastLineMaxUnderfill;
  static late final OptionsGetDouble _getLineBreakingLastLineMaxUnderfill;
  static late final OptionsSetInt _setLineBreakingTargetMeasuresPerSystem;
  static late final OptionsGetInt _getLineBreakingTargetMeasuresPerSystem;
  static late final OptionsSetDouble _setLineBreakingWeightCount;
  static late final OptionsGetDouble _getLineBreakingWeightCount;
  static late final OptionsSetDouble _setLineBreakingBonusFinalBar;
  static late final OptionsGetDouble _getLineBreakingBonusFinalBar;
  static late final OptionsSetDouble _setLineBreakingBonusDoubleBar;
  static late final OptionsGetDouble _getLineBreakingBonusDoubleBar;
  static late final OptionsSetDouble _setLineBreakingBonusPhrasEnd;
  static late final OptionsGetDouble _getLineBreakingBonusPhrasEnd;
  static late final OptionsSetDouble _setLineBreakingBonusRehearsalMark;
  static late final OptionsGetDouble _getLineBreakingBonusRehearsalMark;
  static late final OptionsSetDouble _setLineBreakingPenaltyHairpinAcross;
  static late final OptionsGetDouble _getLineBreakingPenaltyHairpinAcross;
  static late final OptionsSetDouble _setLineBreakingPenaltySlurAcross;
  static late final OptionsGetDouble _getLineBreakingPenaltySlurAcross;
  static late final OptionsSetDouble _setLineBreakingPenaltyLyricsHyphen;
  static late final OptionsGetDouble _getLineBreakingPenaltyLyricsHyphen;
  static late final OptionsSetDouble _setLineBreakingPenaltyTieAcross;
  static late final OptionsGetDouble _getLineBreakingPenaltyTieAcross;
  static late final OptionsSetDouble _setLineBreakingPenaltyClefChange;
  static late final OptionsGetDouble _getLineBreakingPenaltyClefChange;
  static late final OptionsSetDouble _setLineBreakingPenaltyKeyTimeChange;
  static late final OptionsGetDouble _getLineBreakingPenaltyKeyTimeChange;
  static late final OptionsSetDouble _setLineBreakingPenaltyTempoText;
  static late final OptionsGetDouble _getLineBreakingPenaltyTempoText;
  static late final OptionsSetBool _setLineBreakingEnableTwoPassOptimization;
  static late final OptionsGetBool _getLineBreakingEnableTwoPassOptimization;
  static late final OptionsSetBool _setLineBreakingEnableBreakFeatures;
  static late final OptionsGetBool _getLineBreakingEnableBreakFeatures;
  static late final OptionsSetBool _setLineBreakingEnableSystemLevelSpacing;
  static late final OptionsGetBool _getLineBreakingEnableSystemLevelSpacing;
  static late final OptionsSetInt _setLineBreakingMaxMeasuresPerLine;
  static late final OptionsGetInt _getLineBreakingMaxMeasuresPerLine;
  static late final OptionsSetBool _setNotationAutoBeam;
  static late final OptionsGetBool _getNotationAutoBeam;
  static late final OptionsSetBool _setNotationTupletsBracketed;
  static late final OptionsGetBool _getNotationTupletsBracketed;
  static late final OptionsSetBool _setNotationTripletsBracketed;
  static late final OptionsGetBool _getNotationTripletsBracketed;
  static late final OptionsSetBool _setNotationTupletsRatioed;
  static late final OptionsGetBool _getNotationTupletsRatioed;
  static late final OptionsSetBool _setNotationAlignRests;
  static late final OptionsGetBool _getNotationAlignRests;
  static late final OptionsSetBool _setNotationSetWantedStemDirectionByXml;
  static late final OptionsGetBool _getNotationSetWantedStemDirectionByXml;
  static late final OptionsSetInt _setNotationSlurLiftSampleCount;
  static late final OptionsGetInt _getNotationSlurLiftSampleCount;
  static late final OptionsSetString _setNotationFingeringPosition;
  static late final OptionsGetString _getNotationFingeringPosition;
  static late final OptionsSetBool _setNotationFingeringInsideStafflines;
  static late final OptionsGetBool _getNotationFingeringInsideStafflines;
  static late final OptionsSetDouble _setNotationFingeringYOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationFingeringYOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationFingeringFontSize;
  static late final OptionsGetDouble _getNotationFingeringFontSize;
  static late final OptionsSetDouble _setNotationPedalYOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationPedalYOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationPedalLineThicknessStaffSpaces;
  static late final OptionsGetDouble _getNotationPedalLineThicknessStaffSpaces;
  static late final OptionsSetDouble _setNotationPedalTextFontSize;
  static late final OptionsGetDouble _getNotationPedalTextFontSize;
  static late final OptionsSetDouble _setNotationPedalTextToLineStartStaffSpaces;
  static late final OptionsGetDouble _getNotationPedalTextToLineStartStaffSpaces;
  static late final OptionsSetDouble _setNotationPedalLineToEndSymbolGapStaffSpaces;
  static late final OptionsGetDouble _getNotationPedalLineToEndSymbolGapStaffSpaces;
  static late final OptionsSetDouble _setNotationPedalChangeNotchHeightStaffSpaces;
  static late final OptionsGetDouble _getNotationPedalChangeNotchHeightStaffSpaces;
  static late final OptionsSetDouble _setNotationDynamicsYOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationDynamicsYOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationDynamicsFontSize;
  static late final OptionsGetDouble _getNotationDynamicsFontSize;
  static late final OptionsSetDouble _setNotationWedgeYOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationWedgeYOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationWedgeHeightStaffSpaces;
  static late final OptionsGetDouble _getNotationWedgeHeightStaffSpaces;
  static late final OptionsSetDouble _setNotationWedgeLineThicknessStaffSpaces;
  static late final OptionsGetDouble _getNotationWedgeLineThicknessStaffSpaces;
  static late final OptionsSetDouble _setNotationWedgeInsetFromEndsStaffSpaces;
  static late final OptionsGetDouble _getNotationWedgeInsetFromEndsStaffSpaces;
  static late final OptionsSetDouble _setNotationLyricsYOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationLyricsYOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationLyricsFontSize;
  static late final OptionsGetDouble _getNotationLyricsFontSize;
  static late final OptionsSetDouble _setNotationLyricsHyphenMinGapStaffSpaces;
  static late final OptionsGetDouble _getNotationLyricsHyphenMinGapStaffSpaces;
  static late final OptionsSetDouble _setNotationArticulationOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationArticulationOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationArticulationStackGapStaffSpaces;
  static late final OptionsGetDouble _getNotationArticulationStackGapStaffSpaces;
  static late final OptionsSetDouble _setNotationArticulationLineThicknessStaffSpaces;
  static late final OptionsGetDouble _getNotationArticulationLineThicknessStaffSpaces;
  static late final OptionsSetDouble _setNotationTenutoLengthStaffSpaces;
  static late final OptionsGetDouble _getNotationTenutoLengthStaffSpaces;
  static late final OptionsSetDouble _setNotationAccentWidthStaffSpaces;
  static late final OptionsGetDouble _getNotationAccentWidthStaffSpaces;
  static late final OptionsSetDouble _setNotationAccentHeightStaffSpaces;
  static late final OptionsGetDouble _getNotationAccentHeightStaffSpaces;
  static late final OptionsSetDouble _setNotationMarcatoWidthStaffSpaces;
  static late final OptionsGetDouble _getNotationMarcatoWidthStaffSpaces;
  static late final OptionsSetDouble _setNotationMarcatoHeightStaffSpaces;
  static late final OptionsGetDouble _getNotationMarcatoHeightStaffSpaces;
  static late final OptionsSetDouble _setNotationStaccatoDotScale;
  static late final OptionsGetDouble _getNotationStaccatoDotScale;
  static late final OptionsSetDouble _setNotationFermataYOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationFermataYOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationFermataDotToArcStaffSpaces;
  static late final OptionsGetDouble _getNotationFermataDotToArcStaffSpaces;
  static late final OptionsSetDouble _setNotationFermataWidthStaffSpaces;
  static late final OptionsGetDouble _getNotationFermataWidthStaffSpaces;
  static late final OptionsSetDouble _setNotationFermataHeightStaffSpaces;
  static late final OptionsGetDouble _getNotationFermataHeightStaffSpaces;
  static late final OptionsSetDouble _setNotationFermataThicknessStartStaffSpaces;
  static late final OptionsGetDouble _getNotationFermataThicknessStartStaffSpaces;
  static late final OptionsSetDouble _setNotationFermataThicknessMidStaffSpaces;
  static late final OptionsGetDouble _getNotationFermataThicknessMidStaffSpaces;
  static late final OptionsSetDouble _setNotationFermataDotScale;
  static late final OptionsGetDouble _getNotationFermataDotScale;
  static late final OptionsSetDouble _setNotationOrnamentYOffsetStaffSpaces;
  static late final OptionsGetDouble _getNotationOrnamentYOffsetStaffSpaces;
  static late final OptionsSetDouble _setNotationOrnamentStackGapStaffSpaces;
  static late final OptionsGetDouble _getNotationOrnamentStackGapStaffSpaces;
  static late final OptionsSetDouble _setNotationOrnamentFontSize;
  static late final OptionsGetDouble _getNotationOrnamentFontSize;
  static late final OptionsSetDouble _setNotationStaffDistanceStaffSpaces;
  static late final OptionsGetDouble _getNotationStaffDistanceStaffSpaces;
  static late final OptionsSetBool _setColorsDarkMode;
  static late final OptionsGetBool _getColorsDarkMode;
  static late final OptionsSetString _setColorsDefaultColorMusic;
  static late final OptionsGetString _getColorsDefaultColorMusic;
  static late final OptionsSetString _setColorsDefaultColorNotehead;
  static late final OptionsGetString _getColorsDefaultColorNotehead;
  static late final OptionsSetString _setColorsDefaultColorStem;
  static late final OptionsGetString _getColorsDefaultColorStem;
  static late final OptionsSetString _setColorsDefaultColorRest;
  static late final OptionsGetString _getColorsDefaultColorRest;
  static late final OptionsSetString _setColorsDefaultColorLabel;
  static late final OptionsGetString _getColorsDefaultColorLabel;
  static late final OptionsSetString _setColorsDefaultColorTitle;
  static late final OptionsGetString _getColorsDefaultColorTitle;
  static late final OptionsSetBool _setColorsColoringEnabled;
  static late final OptionsGetBool _getColorsColoringEnabled;
  static late final OptionsSetString _setColorsColoringMode;
  static late final OptionsGetString _getColorsColoringMode;
  static late final OptionsSetBool _setColorsColorStemsLikeNoteheads;
  static late final OptionsGetBool _getColorsColorStemsLikeNoteheads;
  static late final OptionsSetStringList _setColorsColoringSetCustom;
  static late final OptionsGetStringListCount _getColorsColoringSetCustomCount;
  static late final OptionsGetStringListAt _getColorsColoringSetCustomAt;
  static late final OptionsSetBool _setPerformanceEnableGlyphCache;
  static late final OptionsGetBool _getPerformanceEnableGlyphCache;
  static late final OptionsSetBool _setPerformanceEnableSpatialIndexing;
  static late final OptionsGetBool _getPerformanceEnableSpatialIndexing;
  static late final OptionsSetInt _setPerformanceSkyBottomLineBatchMinMeasures;
  static late final OptionsGetInt _getPerformanceSkyBottomLineBatchMinMeasures;
  static late final OptionsSetInt _setPerformanceSvgPrecision;
  static late final OptionsGetInt _getPerformanceSvgPrecision;
  static late final OptionsSetBool _setPerformanceBenchEnable;
  static late final OptionsGetBool _getPerformanceBenchEnable;
  static late final OptionsSetString _setBackend;
  static late final OptionsGetString _getBackend;
  static late final OptionsSetDouble _setZoom;
  static late final OptionsGetDouble _getZoom;
  static late final OptionsSetDouble _setSheetMaximumWidth;
  static late final OptionsGetDouble _getSheetMaximumWidth;

  static bool _initialized = false;

  static void initialize() {
    // Evite une reinitialisation inutile.
    if (_initialized) return;
    _library = MxmlLibrary.open();


    _create = _library.create;
    _destroy = _library.destroy;
    _loadFile = _library.loadFile;
    _layout = _library.layout;
    _getHeight = _library.getHeight;
    _getGlyphCodepoint = _library.getGlyphCodepoint;
    _getRenderCommands = _library.getRenderCommands;
    _getString = _library.getString;
    _writeSvgToFile = _library.writeSvgToFile;
    _getPipelineBench = _library.getPipelineBench;
    _optionsCreate = _library.optionsCreate;
    _optionsDestroy = _library.optionsDestroy;
    _optionsApplyStandard = _library.optionsApplyStandard;
    _optionsApplyPiano = _library.optionsApplyPiano;
    _optionsApplyPianoPedagogic = _library.optionsApplyPianoPedagogic;
    _optionsApplyCompact = _library.optionsApplyCompact;
    _optionsApplyPrint = _library.optionsApplyPrint;
    _layoutWithOptions = _library.layoutWithOptions;
    _setRenderingDrawTitle = _library.setRenderingDrawTitle;
    _getRenderingDrawTitle = _library.getRenderingDrawTitle;
    _setRenderingDrawPartNames = _library.setRenderingDrawPartNames;
    _getRenderingDrawPartNames = _library.getRenderingDrawPartNames;
    _setRenderingDrawMeasureNumbers = _library.setRenderingDrawMeasureNumbers;
    _getRenderingDrawMeasureNumbers = _library.getRenderingDrawMeasureNumbers;
    _setRenderingDrawMeasureNumbersOnlyAtSystemStart = _library.setRenderingDrawMeasureNumbersOnlyAtSystemStart;
    _getRenderingDrawMeasureNumbersOnlyAtSystemStart = _library.getRenderingDrawMeasureNumbersOnlyAtSystemStart;
    _setRenderingDrawMeasureNumbersBegin = _library.setRenderingDrawMeasureNumbersBegin;
    _getRenderingDrawMeasureNumbersBegin = _library.getRenderingDrawMeasureNumbersBegin;
    _setRenderingMeasureNumberInterval = _library.setRenderingMeasureNumberInterval;
    _getRenderingMeasureNumberInterval = _library.getRenderingMeasureNumberInterval;
    _setRenderingDrawTimeSignatures = _library.setRenderingDrawTimeSignatures;
    _getRenderingDrawTimeSignatures = _library.getRenderingDrawTimeSignatures;
    _setRenderingDrawKeySignatures = _library.setRenderingDrawKeySignatures;
    _getRenderingDrawKeySignatures = _library.getRenderingDrawKeySignatures;
    _setRenderingDrawFingerings = _library.setRenderingDrawFingerings;
    _getRenderingDrawFingerings = _library.getRenderingDrawFingerings;
    _setRenderingDrawSlurs = _library.setRenderingDrawSlurs;
    _getRenderingDrawSlurs = _library.getRenderingDrawSlurs;
    _setRenderingDrawPedals = _library.setRenderingDrawPedals;
    _getRenderingDrawPedals = _library.getRenderingDrawPedals;
    _setRenderingDrawDynamics = _library.setRenderingDrawDynamics;
    _getRenderingDrawDynamics = _library.getRenderingDrawDynamics;
    _setRenderingDrawWedges = _library.setRenderingDrawWedges;
    _getRenderingDrawWedges = _library.getRenderingDrawWedges;
    _setRenderingDrawLyrics = _library.setRenderingDrawLyrics;
    _getRenderingDrawLyrics = _library.getRenderingDrawLyrics;
    _setRenderingDrawCredits = _library.setRenderingDrawCredits;
    _getRenderingDrawCredits = _library.getRenderingDrawCredits;
    _setRenderingDrawComposer = _library.setRenderingDrawComposer;
    _getRenderingDrawComposer = _library.getRenderingDrawComposer;
    _setRenderingDrawLyricist = _library.setRenderingDrawLyricist;
    _getRenderingDrawLyricist = _library.getRenderingDrawLyricist;
    _setLayoutPageFormat = _library.setLayoutPageFormat;
    _getLayoutPageFormat = _library.getLayoutPageFormat;
    _setLayoutUseFixedCanvas = _library.setLayoutUseFixedCanvas;
    _getLayoutUseFixedCanvas = _library.getLayoutUseFixedCanvas;
    _setLayoutFixedCanvasWidth = _library.setLayoutFixedCanvasWidth;
    _getLayoutFixedCanvasWidth = _library.getLayoutFixedCanvasWidth;
    _setLayoutFixedCanvasHeight = _library.setLayoutFixedCanvasHeight;
    _getLayoutFixedCanvasHeight = _library.getLayoutFixedCanvasHeight;
    _setLayoutPageHeight = _library.setLayoutPageHeight;
    _getLayoutPageHeight = _library.getLayoutPageHeight;
    _setLayoutPageMarginLeftStaffSpaces = _library.setLayoutPageMarginLeftStaffSpaces;
    _getLayoutPageMarginLeftStaffSpaces = _library.getLayoutPageMarginLeftStaffSpaces;
    _setLayoutPageMarginRightStaffSpaces = _library.setLayoutPageMarginRightStaffSpaces;
    _getLayoutPageMarginRightStaffSpaces = _library.getLayoutPageMarginRightStaffSpaces;
    _setLayoutPageMarginTopStaffSpaces = _library.setLayoutPageMarginTopStaffSpaces;
    _getLayoutPageMarginTopStaffSpaces = _library.getLayoutPageMarginTopStaffSpaces;
    _setLayoutPageMarginBottomStaffSpaces = _library.setLayoutPageMarginBottomStaffSpaces;
    _getLayoutPageMarginBottomStaffSpaces = _library.getLayoutPageMarginBottomStaffSpaces;
    _setLayoutSystemSpacingMinStaffSpaces = _library.setLayoutSystemSpacingMinStaffSpaces;
    _getLayoutSystemSpacingMinStaffSpaces = _library.getLayoutSystemSpacingMinStaffSpaces;
    _setLayoutSystemSpacingMultiStaffMinStaffSpaces = _library.setLayoutSystemSpacingMultiStaffMinStaffSpaces;
    _getLayoutSystemSpacingMultiStaffMinStaffSpaces = _library.getLayoutSystemSpacingMultiStaffMinStaffSpaces;
    _setLayoutNewSystemFromXml = _library.setLayoutNewSystemFromXml;
    _getLayoutNewSystemFromXml = _library.getLayoutNewSystemFromXml;
    _setLayoutNewPageFromXml = _library.setLayoutNewPageFromXml;
    _getLayoutNewPageFromXml = _library.getLayoutNewPageFromXml;
    _setLayoutFillEmptyMeasuresWithWholeRest = _library.setLayoutFillEmptyMeasuresWithWholeRest;
    _getLayoutFillEmptyMeasuresWithWholeRest = _library.getLayoutFillEmptyMeasuresWithWholeRest;
    _setLineBreakingJustificationRatioMin = _library.setLineBreakingJustificationRatioMin;
    _getLineBreakingJustificationRatioMin = _library.getLineBreakingJustificationRatioMin;
    _setLineBreakingJustificationRatioMax = _library.setLineBreakingJustificationRatioMax;
    _getLineBreakingJustificationRatioMax = _library.getLineBreakingJustificationRatioMax;
    _setLineBreakingJustificationRatioTarget = _library.setLineBreakingJustificationRatioTarget;
    _getLineBreakingJustificationRatioTarget = _library.getLineBreakingJustificationRatioTarget;
    _setLineBreakingJustificationRatioSoftMin = _library.setLineBreakingJustificationRatioSoftMin;
    _getLineBreakingJustificationRatioSoftMin = _library.getLineBreakingJustificationRatioSoftMin;
    _setLineBreakingJustificationRatioSoftMax = _library.setLineBreakingJustificationRatioSoftMax;
    _getLineBreakingJustificationRatioSoftMax = _library.getLineBreakingJustificationRatioSoftMax;
    _setLineBreakingWeightRatio = _library.setLineBreakingWeightRatio;
    _getLineBreakingWeightRatio = _library.getLineBreakingWeightRatio;
    _setLineBreakingWeightTight = _library.setLineBreakingWeightTight;
    _getLineBreakingWeightTight = _library.getLineBreakingWeightTight;
    _setLineBreakingWeightLoose = _library.setLineBreakingWeightLoose;
    _getLineBreakingWeightLoose = _library.getLineBreakingWeightLoose;
    _setLineBreakingWeightLastUnder = _library.setLineBreakingWeightLastUnder;
    _getLineBreakingWeightLastUnder = _library.getLineBreakingWeightLastUnder;
    _setLineBreakingCostPower = _library.setLineBreakingCostPower;
    _getLineBreakingCostPower = _library.getLineBreakingCostPower;
    _setLineBreakingStretchLastSystem = _library.setLineBreakingStretchLastSystem;
    _getLineBreakingStretchLastSystem = _library.getLineBreakingStretchLastSystem;
    _setLineBreakingLastLineMaxUnderfill = _library.setLineBreakingLastLineMaxUnderfill;
    _getLineBreakingLastLineMaxUnderfill = _library.getLineBreakingLastLineMaxUnderfill;
    _setLineBreakingTargetMeasuresPerSystem = _library.setLineBreakingTargetMeasuresPerSystem;
    _getLineBreakingTargetMeasuresPerSystem = _library.getLineBreakingTargetMeasuresPerSystem;
    _setLineBreakingWeightCount = _library.setLineBreakingWeightCount;
    _getLineBreakingWeightCount = _library.getLineBreakingWeightCount;
    _setLineBreakingBonusFinalBar = _library.setLineBreakingBonusFinalBar;
    _getLineBreakingBonusFinalBar = _library.getLineBreakingBonusFinalBar;
    _setLineBreakingBonusDoubleBar = _library.setLineBreakingBonusDoubleBar;
    _getLineBreakingBonusDoubleBar = _library.getLineBreakingBonusDoubleBar;
    _setLineBreakingBonusPhrasEnd = _library.setLineBreakingBonusPhrasEnd;
    _getLineBreakingBonusPhrasEnd = _library.getLineBreakingBonusPhrasEnd;
    _setLineBreakingBonusRehearsalMark = _library.setLineBreakingBonusRehearsalMark;
    _getLineBreakingBonusRehearsalMark = _library.getLineBreakingBonusRehearsalMark;
    _setLineBreakingPenaltyHairpinAcross = _library.setLineBreakingPenaltyHairpinAcross;
    _getLineBreakingPenaltyHairpinAcross = _library.getLineBreakingPenaltyHairpinAcross;
    _setLineBreakingPenaltySlurAcross = _library.setLineBreakingPenaltySlurAcross;
    _getLineBreakingPenaltySlurAcross = _library.getLineBreakingPenaltySlurAcross;
    _setLineBreakingPenaltyLyricsHyphen = _library.setLineBreakingPenaltyLyricsHyphen;
    _getLineBreakingPenaltyLyricsHyphen = _library.getLineBreakingPenaltyLyricsHyphen;
    _setLineBreakingPenaltyTieAcross = _library.setLineBreakingPenaltyTieAcross;
    _getLineBreakingPenaltyTieAcross = _library.getLineBreakingPenaltyTieAcross;
    _setLineBreakingPenaltyClefChange = _library.setLineBreakingPenaltyClefChange;
    _getLineBreakingPenaltyClefChange = _library.getLineBreakingPenaltyClefChange;
    _setLineBreakingPenaltyKeyTimeChange = _library.setLineBreakingPenaltyKeyTimeChange;
    _getLineBreakingPenaltyKeyTimeChange = _library.getLineBreakingPenaltyKeyTimeChange;
    _setLineBreakingPenaltyTempoText = _library.setLineBreakingPenaltyTempoText;
    _getLineBreakingPenaltyTempoText = _library.getLineBreakingPenaltyTempoText;
    _setLineBreakingEnableTwoPassOptimization = _library.setLineBreakingEnableTwoPassOptimization;
    _getLineBreakingEnableTwoPassOptimization = _library.getLineBreakingEnableTwoPassOptimization;
    _setLineBreakingEnableBreakFeatures = _library.setLineBreakingEnableBreakFeatures;
    _getLineBreakingEnableBreakFeatures = _library.getLineBreakingEnableBreakFeatures;
    _setLineBreakingEnableSystemLevelSpacing = _library.setLineBreakingEnableSystemLevelSpacing;
    _getLineBreakingEnableSystemLevelSpacing = _library.getLineBreakingEnableSystemLevelSpacing;
    _setLineBreakingMaxMeasuresPerLine = _library.setLineBreakingMaxMeasuresPerLine;
    _getLineBreakingMaxMeasuresPerLine = _library.getLineBreakingMaxMeasuresPerLine;
    _setNotationAutoBeam = _library.setNotationAutoBeam;
    _getNotationAutoBeam = _library.getNotationAutoBeam;
    _setNotationTupletsBracketed = _library.setNotationTupletsBracketed;
    _getNotationTupletsBracketed = _library.getNotationTupletsBracketed;
    _setNotationTripletsBracketed = _library.setNotationTripletsBracketed;
    _getNotationTripletsBracketed = _library.getNotationTripletsBracketed;
    _setNotationTupletsRatioed = _library.setNotationTupletsRatioed;
    _getNotationTupletsRatioed = _library.getNotationTupletsRatioed;
    _setNotationAlignRests = _library.setNotationAlignRests;
    _getNotationAlignRests = _library.getNotationAlignRests;
    _setNotationSetWantedStemDirectionByXml = _library.setNotationSetWantedStemDirectionByXml;
    _getNotationSetWantedStemDirectionByXml = _library.getNotationSetWantedStemDirectionByXml;
    _setNotationSlurLiftSampleCount = _library.setNotationSlurLiftSampleCount;
    _getNotationSlurLiftSampleCount = _library.getNotationSlurLiftSampleCount;
    _setNotationFingeringPosition = _library.setNotationFingeringPosition;
    _getNotationFingeringPosition = _library.getNotationFingeringPosition;
    _setNotationFingeringInsideStafflines = _library.setNotationFingeringInsideStafflines;
    _getNotationFingeringInsideStafflines = _library.getNotationFingeringInsideStafflines;
    _setNotationFingeringYOffsetStaffSpaces = _library.setNotationFingeringYOffsetStaffSpaces;
    _getNotationFingeringYOffsetStaffSpaces = _library.getNotationFingeringYOffsetStaffSpaces;
    _setNotationFingeringFontSize = _library.setNotationFingeringFontSize;
    _getNotationFingeringFontSize = _library.getNotationFingeringFontSize;
    _setNotationPedalYOffsetStaffSpaces = _library.setNotationPedalYOffsetStaffSpaces;
    _getNotationPedalYOffsetStaffSpaces = _library.getNotationPedalYOffsetStaffSpaces;
    _setNotationPedalLineThicknessStaffSpaces = _library.setNotationPedalLineThicknessStaffSpaces;
    _getNotationPedalLineThicknessStaffSpaces = _library.getNotationPedalLineThicknessStaffSpaces;
    _setNotationPedalTextFontSize = _library.setNotationPedalTextFontSize;
    _getNotationPedalTextFontSize = _library.getNotationPedalTextFontSize;
    _setNotationPedalTextToLineStartStaffSpaces = _library.setNotationPedalTextToLineStartStaffSpaces;
    _getNotationPedalTextToLineStartStaffSpaces = _library.getNotationPedalTextToLineStartStaffSpaces;
    _setNotationPedalLineToEndSymbolGapStaffSpaces = _library.setNotationPedalLineToEndSymbolGapStaffSpaces;
    _getNotationPedalLineToEndSymbolGapStaffSpaces = _library.getNotationPedalLineToEndSymbolGapStaffSpaces;
    _setNotationPedalChangeNotchHeightStaffSpaces = _library.setNotationPedalChangeNotchHeightStaffSpaces;
    _getNotationPedalChangeNotchHeightStaffSpaces = _library.getNotationPedalChangeNotchHeightStaffSpaces;
    _setNotationDynamicsYOffsetStaffSpaces = _library.setNotationDynamicsYOffsetStaffSpaces;
    _getNotationDynamicsYOffsetStaffSpaces = _library.getNotationDynamicsYOffsetStaffSpaces;
    _setNotationDynamicsFontSize = _library.setNotationDynamicsFontSize;
    _getNotationDynamicsFontSize = _library.getNotationDynamicsFontSize;
    _setNotationWedgeYOffsetStaffSpaces = _library.setNotationWedgeYOffsetStaffSpaces;
    _getNotationWedgeYOffsetStaffSpaces = _library.getNotationWedgeYOffsetStaffSpaces;
    _setNotationWedgeHeightStaffSpaces = _library.setNotationWedgeHeightStaffSpaces;
    _getNotationWedgeHeightStaffSpaces = _library.getNotationWedgeHeightStaffSpaces;
    _setNotationWedgeLineThicknessStaffSpaces = _library.setNotationWedgeLineThicknessStaffSpaces;
    _getNotationWedgeLineThicknessStaffSpaces = _library.getNotationWedgeLineThicknessStaffSpaces;
    _setNotationWedgeInsetFromEndsStaffSpaces = _library.setNotationWedgeInsetFromEndsStaffSpaces;
    _getNotationWedgeInsetFromEndsStaffSpaces = _library.getNotationWedgeInsetFromEndsStaffSpaces;
    _setNotationLyricsYOffsetStaffSpaces = _library.setNotationLyricsYOffsetStaffSpaces;
    _getNotationLyricsYOffsetStaffSpaces = _library.getNotationLyricsYOffsetStaffSpaces;
    _setNotationLyricsFontSize = _library.setNotationLyricsFontSize;
    _getNotationLyricsFontSize = _library.getNotationLyricsFontSize;
    _setNotationLyricsHyphenMinGapStaffSpaces = _library.setNotationLyricsHyphenMinGapStaffSpaces;
    _getNotationLyricsHyphenMinGapStaffSpaces = _library.getNotationLyricsHyphenMinGapStaffSpaces;
    _setNotationArticulationOffsetStaffSpaces = _library.setNotationArticulationOffsetStaffSpaces;
    _getNotationArticulationOffsetStaffSpaces = _library.getNotationArticulationOffsetStaffSpaces;
    _setNotationArticulationStackGapStaffSpaces = _library.setNotationArticulationStackGapStaffSpaces;
    _getNotationArticulationStackGapStaffSpaces = _library.getNotationArticulationStackGapStaffSpaces;
    _setNotationArticulationLineThicknessStaffSpaces = _library.setNotationArticulationLineThicknessStaffSpaces;
    _getNotationArticulationLineThicknessStaffSpaces = _library.getNotationArticulationLineThicknessStaffSpaces;
    _setNotationTenutoLengthStaffSpaces = _library.setNotationTenutoLengthStaffSpaces;
    _getNotationTenutoLengthStaffSpaces = _library.getNotationTenutoLengthStaffSpaces;
    _setNotationAccentWidthStaffSpaces = _library.setNotationAccentWidthStaffSpaces;
    _getNotationAccentWidthStaffSpaces = _library.getNotationAccentWidthStaffSpaces;
    _setNotationAccentHeightStaffSpaces = _library.setNotationAccentHeightStaffSpaces;
    _getNotationAccentHeightStaffSpaces = _library.getNotationAccentHeightStaffSpaces;
    _setNotationMarcatoWidthStaffSpaces = _library.setNotationMarcatoWidthStaffSpaces;
    _getNotationMarcatoWidthStaffSpaces = _library.getNotationMarcatoWidthStaffSpaces;
    _setNotationMarcatoHeightStaffSpaces = _library.setNotationMarcatoHeightStaffSpaces;
    _getNotationMarcatoHeightStaffSpaces = _library.getNotationMarcatoHeightStaffSpaces;
    _setNotationStaccatoDotScale = _library.setNotationStaccatoDotScale;
    _getNotationStaccatoDotScale = _library.getNotationStaccatoDotScale;
    _setNotationFermataYOffsetStaffSpaces = _library.setNotationFermataYOffsetStaffSpaces;
    _getNotationFermataYOffsetStaffSpaces = _library.getNotationFermataYOffsetStaffSpaces;
    _setNotationFermataDotToArcStaffSpaces = _library.setNotationFermataDotToArcStaffSpaces;
    _getNotationFermataDotToArcStaffSpaces = _library.getNotationFermataDotToArcStaffSpaces;
    _setNotationFermataWidthStaffSpaces = _library.setNotationFermataWidthStaffSpaces;
    _getNotationFermataWidthStaffSpaces = _library.getNotationFermataWidthStaffSpaces;
    _setNotationFermataHeightStaffSpaces = _library.setNotationFermataHeightStaffSpaces;
    _getNotationFermataHeightStaffSpaces = _library.getNotationFermataHeightStaffSpaces;
    _setNotationFermataThicknessStartStaffSpaces = _library.setNotationFermataThicknessStartStaffSpaces;
    _getNotationFermataThicknessStartStaffSpaces = _library.getNotationFermataThicknessStartStaffSpaces;
    _setNotationFermataThicknessMidStaffSpaces = _library.setNotationFermataThicknessMidStaffSpaces;
    _getNotationFermataThicknessMidStaffSpaces = _library.getNotationFermataThicknessMidStaffSpaces;
    _setNotationFermataDotScale = _library.setNotationFermataDotScale;
    _getNotationFermataDotScale = _library.getNotationFermataDotScale;
    _setNotationOrnamentYOffsetStaffSpaces = _library.setNotationOrnamentYOffsetStaffSpaces;
    _getNotationOrnamentYOffsetStaffSpaces = _library.getNotationOrnamentYOffsetStaffSpaces;
    _setNotationOrnamentStackGapStaffSpaces = _library.setNotationOrnamentStackGapStaffSpaces;
    _getNotationOrnamentStackGapStaffSpaces = _library.getNotationOrnamentStackGapStaffSpaces;
    _setNotationOrnamentFontSize = _library.setNotationOrnamentFontSize;
    _getNotationOrnamentFontSize = _library.getNotationOrnamentFontSize;
    _setNotationStaffDistanceStaffSpaces = _library.setNotationStaffDistanceStaffSpaces;
    _getNotationStaffDistanceStaffSpaces = _library.getNotationStaffDistanceStaffSpaces;
    _setColorsDarkMode = _library.setColorsDarkMode;
    _getColorsDarkMode = _library.getColorsDarkMode;
    _setColorsDefaultColorMusic = _library.setColorsDefaultColorMusic;
    _getColorsDefaultColorMusic = _library.getColorsDefaultColorMusic;
    _setColorsDefaultColorNotehead = _library.setColorsDefaultColorNotehead;
    _getColorsDefaultColorNotehead = _library.getColorsDefaultColorNotehead;
    _setColorsDefaultColorStem = _library.setColorsDefaultColorStem;
    _getColorsDefaultColorStem = _library.getColorsDefaultColorStem;
    _setColorsDefaultColorRest = _library.setColorsDefaultColorRest;
    _getColorsDefaultColorRest = _library.getColorsDefaultColorRest;
    _setColorsDefaultColorLabel = _library.setColorsDefaultColorLabel;
    _getColorsDefaultColorLabel = _library.getColorsDefaultColorLabel;
    _setColorsDefaultColorTitle = _library.setColorsDefaultColorTitle;
    _getColorsDefaultColorTitle = _library.getColorsDefaultColorTitle;
    _setColorsColoringEnabled = _library.setColorsColoringEnabled;
    _getColorsColoringEnabled = _library.getColorsColoringEnabled;
    _setColorsColoringMode = _library.setColorsColoringMode;
    _getColorsColoringMode = _library.getColorsColoringMode;
    _setColorsColorStemsLikeNoteheads = _library.setColorsColorStemsLikeNoteheads;
    _getColorsColorStemsLikeNoteheads = _library.getColorsColorStemsLikeNoteheads;
    _setColorsColoringSetCustom = _library.setColorsColoringSetCustom;
    _getColorsColoringSetCustomCount = _library.getColorsColoringSetCustomCount;
    _getColorsColoringSetCustomAt = _library.getColorsColoringSetCustomAt;
    _setPerformanceEnableGlyphCache = _library.setPerformanceEnableGlyphCache;
    _getPerformanceEnableGlyphCache = _library.getPerformanceEnableGlyphCache;
    _setPerformanceEnableSpatialIndexing = _library.setPerformanceEnableSpatialIndexing;
    _getPerformanceEnableSpatialIndexing = _library.getPerformanceEnableSpatialIndexing;
    _setPerformanceSkyBottomLineBatchMinMeasures = _library.setPerformanceSkyBottomLineBatchMinMeasures;
    _getPerformanceSkyBottomLineBatchMinMeasures = _library.getPerformanceSkyBottomLineBatchMinMeasures;
    _setPerformanceSvgPrecision = _library.setPerformanceSvgPrecision;
    _getPerformanceSvgPrecision = _library.getPerformanceSvgPrecision;
    _setPerformanceBenchEnable = _library.setPerformanceBenchEnable;
    _getPerformanceBenchEnable = _library.getPerformanceBenchEnable;
    _setBackend = _library.setBackend;
    _getBackend = _library.getBackend;
    _setZoom = _library.setZoom;
    _getZoom = _library.getZoom;
    _setSheetMaximumWidth = _library.setSheetMaximumWidth;
    _getSheetMaximumWidth = _library.getSheetMaximumWidth;

    _initialized = true;
  }

  // --- Public Dart API ---

  Pointer<MXMLHandle> create() {
    return _create();
  }

  void destroy(Pointer<MXMLHandle> handle) {
    _destroy(handle);
  }

  bool loadFile(Pointer<MXMLHandle> handle, String path) {
    final pathPtr = path.toNativeUtf8();
    try {
      final result = _loadFile(handle, pathPtr);
      return result != 0;
    } finally {
      calloc.free(pathPtr);
    }
  }

  void layout(Pointer<MXMLHandle> handle, double width) {
    _layout(handle, width);
  }

  // Lance le layout avec options.
  void layoutWithOptions(Pointer<MXMLHandle> handle, double width, Pointer<MXMLOptions> opts) {
    _layoutWithOptions(handle, width, opts);
  }

  double getHeight(Pointer<MXMLHandle> handle) {
    return _getHeight(handle);
  }

  int getGlyphCodepoint(Pointer<MXMLHandle> handle, int glyphId) {
    return _getGlyphCodepoint(handle, glyphId);
  }

  Pointer<MXMLRenderCommandC> getRenderCommands(Pointer<MXMLHandle> handle, Pointer<Size> countOut) {
    return _getRenderCommands(handle, countOut);
  }
  
  String getString(Pointer<MXMLHandle> handle, int id) {
    final ptr = _getString(handle, id);
    if (ptr == nullptr) return "";
    return ptr.toDartString();
  }

  bool writeSvgToFile(Pointer<MXMLHandle> handle, String filepath) {
    final pathPtr = filepath.toNativeUtf8();
    try {
      final result = _writeSvgToFile(handle, pathPtr);
      return result != 0;
    } finally {
      calloc.free(pathPtr);
    }
  }

  // Récupère les benchmarks du pipeline (copie locale).
  MXMLPipelineBench? getPipelineBench(Pointer<MXMLHandle> handle) {
    final benchPtr = _getPipelineBench(handle);
    // Si la lib ne renvoie rien, on évite de deref.
    if (benchPtr == nullptr) return null;
    return MXMLPipelineBench.fromC(benchPtr.ref);
  }

  // --- Options API ---

  // Cree un handle d'options.
  Pointer<MXMLOptions> optionsCreate() {
    return _optionsCreate();
  }

  // Detruit un handle d'options.
  void optionsDestroy(Pointer<MXMLOptions> opts) {
    _optionsDestroy(opts);
  }

  // Applique le preset standard.
  void optionsApplyStandard(Pointer<MXMLOptions> opts) {
    _optionsApplyStandard(opts);
  }

  // Applique le preset piano.
  void optionsApplyPiano(Pointer<MXMLOptions> opts) {
    _optionsApplyPiano(opts);
  }

  // Applique le preset piano pedagogic.
  void optionsApplyPianoPedagogic(Pointer<MXMLOptions> opts) {
    _optionsApplyPianoPedagogic(opts);
  }

  // Applique le preset compact.
  void optionsApplyCompact(Pointer<MXMLOptions> opts) {
    _optionsApplyCompact(opts);
  }

  // Applique le preset print.
  void optionsApplyPrint(Pointer<MXMLOptions> opts) {
    _optionsApplyPrint(opts);
  }

  // --- Rendering Options ---

  // Recupere draw_title.
  bool getRenderingDrawTitle(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawTitle(opts) == _boolTrue;
  }

  // Definit draw_title.
  void setRenderingDrawTitle(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawTitle(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_part_names.
  bool getRenderingDrawPartNames(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawPartNames(opts) == _boolTrue;
  }

  // Definit draw_part_names.
  void setRenderingDrawPartNames(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawPartNames(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_measure_numbers.
  bool getRenderingDrawMeasureNumbers(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawMeasureNumbers(opts) == _boolTrue;
  }

  // Definit draw_measure_numbers.
  void setRenderingDrawMeasureNumbers(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawMeasureNumbers(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_measure_numbers_only_at_system_start.
  bool getRenderingDrawMeasureNumbersOnlyAtSystemStart(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawMeasureNumbersOnlyAtSystemStart(opts) == _boolTrue;
  }

  // Definit draw_measure_numbers_only_at_system_start.
  void setRenderingDrawMeasureNumbersOnlyAtSystemStart(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawMeasureNumbersOnlyAtSystemStart(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_measure_numbers_begin.
  int getRenderingDrawMeasureNumbersBegin(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawMeasureNumbersBegin(opts);
  }

  // Definit draw_measure_numbers_begin.
  void setRenderingDrawMeasureNumbersBegin(Pointer<MXMLOptions> opts, int value) {
    _setRenderingDrawMeasureNumbersBegin(opts, value);
  }

  // Recupere measure_number_interval.
  int getRenderingMeasureNumberInterval(Pointer<MXMLOptions> opts) {
    return _getRenderingMeasureNumberInterval(opts);
  }

  // Definit measure_number_interval.
  void setRenderingMeasureNumberInterval(Pointer<MXMLOptions> opts, int value) {
    _setRenderingMeasureNumberInterval(opts, value);
  }

  // Recupere draw_time_signatures.
  bool getRenderingDrawTimeSignatures(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawTimeSignatures(opts) == _boolTrue;
  }

  // Definit draw_time_signatures.
  void setRenderingDrawTimeSignatures(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawTimeSignatures(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_key_signatures.
  bool getRenderingDrawKeySignatures(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawKeySignatures(opts) == _boolTrue;
  }

  // Definit draw_key_signatures.
  void setRenderingDrawKeySignatures(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawKeySignatures(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_fingerings.
  bool getRenderingDrawFingerings(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawFingerings(opts) == _boolTrue;
  }

  // Definit draw_fingerings.
  void setRenderingDrawFingerings(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawFingerings(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_slurs.
  bool getRenderingDrawSlurs(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawSlurs(opts) == _boolTrue;
  }

  // Definit draw_slurs.
  void setRenderingDrawSlurs(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawSlurs(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_pedals.
  bool getRenderingDrawPedals(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawPedals(opts) == _boolTrue;
  }

  // Definit draw_pedals.
  void setRenderingDrawPedals(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawPedals(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_dynamics.
  bool getRenderingDrawDynamics(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawDynamics(opts) == _boolTrue;
  }

  // Definit draw_dynamics.
  void setRenderingDrawDynamics(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawDynamics(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_wedges.
  bool getRenderingDrawWedges(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawWedges(opts) == _boolTrue;
  }

  // Definit draw_wedges.
  void setRenderingDrawWedges(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawWedges(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_lyrics.
  bool getRenderingDrawLyrics(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawLyrics(opts) == _boolTrue;
  }

  // Definit draw_lyrics.
  void setRenderingDrawLyrics(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawLyrics(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_credits.
  bool getRenderingDrawCredits(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawCredits(opts) == _boolTrue;
  }

  // Definit draw_credits.
  void setRenderingDrawCredits(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawCredits(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_composer.
  bool getRenderingDrawComposer(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawComposer(opts) == _boolTrue;
  }

  // Definit draw_composer.
  void setRenderingDrawComposer(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawComposer(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere draw_lyricist.
  bool getRenderingDrawLyricist(Pointer<MXMLOptions> opts) {
    return _getRenderingDrawLyricist(opts) == _boolTrue;
  }

  // Definit draw_lyricist.
  void setRenderingDrawLyricist(Pointer<MXMLOptions> opts, bool value) {
    _setRenderingDrawLyricist(opts, value ? _boolTrue : _boolFalse);
  }

  // --- Layout Options ---

  // Recupere page_format.
  String getLayoutPageFormat(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getLayoutPageFormat(opts));
  }

  // Definit page_format.
  void setLayoutPageFormat(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setLayoutPageFormat, opts, value);
  }

  // Recupere use_fixed_canvas.
  bool getLayoutUseFixedCanvas(Pointer<MXMLOptions> opts) {
    return _getLayoutUseFixedCanvas(opts) == _boolTrue;
  }

  // Definit use_fixed_canvas.
  void setLayoutUseFixedCanvas(Pointer<MXMLOptions> opts, bool value) {
    _setLayoutUseFixedCanvas(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere fixed_canvas_width.
  double getLayoutFixedCanvasWidth(Pointer<MXMLOptions> opts) {
    return _getLayoutFixedCanvasWidth(opts);
  }

  // Definit fixed_canvas_width.
  void setLayoutFixedCanvasWidth(Pointer<MXMLOptions> opts, double value) {
    _setLayoutFixedCanvasWidth(opts, value);
  }

  // Recupere fixed_canvas_height.
  double getLayoutFixedCanvasHeight(Pointer<MXMLOptions> opts) {
    return _getLayoutFixedCanvasHeight(opts);
  }

  // Definit fixed_canvas_height.
  void setLayoutFixedCanvasHeight(Pointer<MXMLOptions> opts, double value) {
    _setLayoutFixedCanvasHeight(opts, value);
  }

  // Recupere page_height.
  double getLayoutPageHeight(Pointer<MXMLOptions> opts) {
    return _getLayoutPageHeight(opts);
  }

  // Definit page_height.
  void setLayoutPageHeight(Pointer<MXMLOptions> opts, double value) {
    _setLayoutPageHeight(opts, value);
  }

  // Recupere page_margin_left_staff_spaces.
  double getLayoutPageMarginLeftStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getLayoutPageMarginLeftStaffSpaces(opts);
  }

  // Definit page_margin_left_staff_spaces.
  void setLayoutPageMarginLeftStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setLayoutPageMarginLeftStaffSpaces(opts, value);
  }

  // Recupere page_margin_right_staff_spaces.
  double getLayoutPageMarginRightStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getLayoutPageMarginRightStaffSpaces(opts);
  }

  // Definit page_margin_right_staff_spaces.
  void setLayoutPageMarginRightStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setLayoutPageMarginRightStaffSpaces(opts, value);
  }

  // Recupere page_margin_top_staff_spaces.
  double getLayoutPageMarginTopStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getLayoutPageMarginTopStaffSpaces(opts);
  }

  // Definit page_margin_top_staff_spaces.
  void setLayoutPageMarginTopStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setLayoutPageMarginTopStaffSpaces(opts, value);
  }

  // Recupere page_margin_bottom_staff_spaces.
  double getLayoutPageMarginBottomStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getLayoutPageMarginBottomStaffSpaces(opts);
  }

  // Definit page_margin_bottom_staff_spaces.
  void setLayoutPageMarginBottomStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setLayoutPageMarginBottomStaffSpaces(opts, value);
  }

  // Recupere system_spacing_min_staff_spaces.
  double getLayoutSystemSpacingMinStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getLayoutSystemSpacingMinStaffSpaces(opts);
  }

  // Definit system_spacing_min_staff_spaces.
  void setLayoutSystemSpacingMinStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setLayoutSystemSpacingMinStaffSpaces(opts, value);
  }

  // Recupere system_spacing_multi_staff_min_staff_spaces.
  double getLayoutSystemSpacingMultiStaffMinStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getLayoutSystemSpacingMultiStaffMinStaffSpaces(opts);
  }

  // Definit system_spacing_multi_staff_min_staff_spaces.
  void setLayoutSystemSpacingMultiStaffMinStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setLayoutSystemSpacingMultiStaffMinStaffSpaces(opts, value);
  }

  // Recupere new_system_from_xml.
  bool getLayoutNewSystemFromXml(Pointer<MXMLOptions> opts) {
    return _getLayoutNewSystemFromXml(opts) == _boolTrue;
  }

  // Definit new_system_from_xml.
  void setLayoutNewSystemFromXml(Pointer<MXMLOptions> opts, bool value) {
    _setLayoutNewSystemFromXml(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere new_page_from_xml.
  bool getLayoutNewPageFromXml(Pointer<MXMLOptions> opts) {
    return _getLayoutNewPageFromXml(opts) == _boolTrue;
  }

  // Definit new_page_from_xml.
  void setLayoutNewPageFromXml(Pointer<MXMLOptions> opts, bool value) {
    _setLayoutNewPageFromXml(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere fill_empty_measures_with_whole_rest.
  bool getLayoutFillEmptyMeasuresWithWholeRest(Pointer<MXMLOptions> opts) {
    return _getLayoutFillEmptyMeasuresWithWholeRest(opts) == _boolTrue;
  }

  // Definit fill_empty_measures_with_whole_rest.
  void setLayoutFillEmptyMeasuresWithWholeRest(Pointer<MXMLOptions> opts, bool value) {
    _setLayoutFillEmptyMeasuresWithWholeRest(opts, value ? _boolTrue : _boolFalse);
  }

  // --- Line Breaking Options ---

  // Recupere justification_ratio_min.
  double getLineBreakingJustificationRatioMin(Pointer<MXMLOptions> opts) {
    return _getLineBreakingJustificationRatioMin(opts);
  }

  // Definit justification_ratio_min.
  void setLineBreakingJustificationRatioMin(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingJustificationRatioMin(opts, value);
  }

  // Recupere justification_ratio_max.
  double getLineBreakingJustificationRatioMax(Pointer<MXMLOptions> opts) {
    return _getLineBreakingJustificationRatioMax(opts);
  }

  // Definit justification_ratio_max.
  void setLineBreakingJustificationRatioMax(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingJustificationRatioMax(opts, value);
  }

  // Recupere justification_ratio_target.
  double getLineBreakingJustificationRatioTarget(Pointer<MXMLOptions> opts) {
    return _getLineBreakingJustificationRatioTarget(opts);
  }

  // Definit justification_ratio_target.
  void setLineBreakingJustificationRatioTarget(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingJustificationRatioTarget(opts, value);
  }

  // Recupere justification_ratio_soft_min.
  double getLineBreakingJustificationRatioSoftMin(Pointer<MXMLOptions> opts) {
    return _getLineBreakingJustificationRatioSoftMin(opts);
  }

  // Definit justification_ratio_soft_min.
  void setLineBreakingJustificationRatioSoftMin(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingJustificationRatioSoftMin(opts, value);
  }

  // Recupere justification_ratio_soft_max.
  double getLineBreakingJustificationRatioSoftMax(Pointer<MXMLOptions> opts) {
    return _getLineBreakingJustificationRatioSoftMax(opts);
  }

  // Definit justification_ratio_soft_max.
  void setLineBreakingJustificationRatioSoftMax(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingJustificationRatioSoftMax(opts, value);
  }

  // Recupere weight_ratio.
  double getLineBreakingWeightRatio(Pointer<MXMLOptions> opts) {
    return _getLineBreakingWeightRatio(opts);
  }

  // Definit weight_ratio.
  void setLineBreakingWeightRatio(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingWeightRatio(opts, value);
  }

  // Recupere weight_tight.
  double getLineBreakingWeightTight(Pointer<MXMLOptions> opts) {
    return _getLineBreakingWeightTight(opts);
  }

  // Definit weight_tight.
  void setLineBreakingWeightTight(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingWeightTight(opts, value);
  }

  // Recupere weight_loose.
  double getLineBreakingWeightLoose(Pointer<MXMLOptions> opts) {
    return _getLineBreakingWeightLoose(opts);
  }

  // Definit weight_loose.
  void setLineBreakingWeightLoose(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingWeightLoose(opts, value);
  }

  // Recupere weight_last_under.
  double getLineBreakingWeightLastUnder(Pointer<MXMLOptions> opts) {
    return _getLineBreakingWeightLastUnder(opts);
  }

  // Definit weight_last_under.
  void setLineBreakingWeightLastUnder(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingWeightLastUnder(opts, value);
  }

  // Recupere cost_power.
  double getLineBreakingCostPower(Pointer<MXMLOptions> opts) {
    return _getLineBreakingCostPower(opts);
  }

  // Definit cost_power.
  void setLineBreakingCostPower(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingCostPower(opts, value);
  }

  // Recupere stretch_last_system.
  bool getLineBreakingStretchLastSystem(Pointer<MXMLOptions> opts) {
    return _getLineBreakingStretchLastSystem(opts) == _boolTrue;
  }

  // Definit stretch_last_system.
  void setLineBreakingStretchLastSystem(Pointer<MXMLOptions> opts, bool value) {
    _setLineBreakingStretchLastSystem(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere last_line_max_underfill.
  double getLineBreakingLastLineMaxUnderfill(Pointer<MXMLOptions> opts) {
    return _getLineBreakingLastLineMaxUnderfill(opts);
  }

  // Definit last_line_max_underfill.
  void setLineBreakingLastLineMaxUnderfill(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingLastLineMaxUnderfill(opts, value);
  }

  // Recupere target_measures_per_system.
  int getLineBreakingTargetMeasuresPerSystem(Pointer<MXMLOptions> opts) {
    return _getLineBreakingTargetMeasuresPerSystem(opts);
  }

  // Definit target_measures_per_system.
  void setLineBreakingTargetMeasuresPerSystem(Pointer<MXMLOptions> opts, int value) {
    _setLineBreakingTargetMeasuresPerSystem(opts, value);
  }

  // Recupere weight_count.
  double getLineBreakingWeightCount(Pointer<MXMLOptions> opts) {
    return _getLineBreakingWeightCount(opts);
  }

  // Definit weight_count.
  void setLineBreakingWeightCount(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingWeightCount(opts, value);
  }

  // Recupere bonus_final_bar.
  double getLineBreakingBonusFinalBar(Pointer<MXMLOptions> opts) {
    return _getLineBreakingBonusFinalBar(opts);
  }

  // Definit bonus_final_bar.
  void setLineBreakingBonusFinalBar(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingBonusFinalBar(opts, value);
  }

  // Recupere bonus_double_bar.
  double getLineBreakingBonusDoubleBar(Pointer<MXMLOptions> opts) {
    return _getLineBreakingBonusDoubleBar(opts);
  }

  // Definit bonus_double_bar.
  void setLineBreakingBonusDoubleBar(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingBonusDoubleBar(opts, value);
  }

  // Recupere bonus_phras_end.
  double getLineBreakingBonusPhrasEnd(Pointer<MXMLOptions> opts) {
    return _getLineBreakingBonusPhrasEnd(opts);
  }

  // Definit bonus_phras_end.
  void setLineBreakingBonusPhrasEnd(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingBonusPhrasEnd(opts, value);
  }

  // Recupere bonus_rehearsal_mark.
  double getLineBreakingBonusRehearsalMark(Pointer<MXMLOptions> opts) {
    return _getLineBreakingBonusRehearsalMark(opts);
  }

  // Definit bonus_rehearsal_mark.
  void setLineBreakingBonusRehearsalMark(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingBonusRehearsalMark(opts, value);
  }

  // Recupere penalty_hairpin_across.
  double getLineBreakingPenaltyHairpinAcross(Pointer<MXMLOptions> opts) {
    return _getLineBreakingPenaltyHairpinAcross(opts);
  }

  // Definit penalty_hairpin_across.
  void setLineBreakingPenaltyHairpinAcross(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingPenaltyHairpinAcross(opts, value);
  }

  // Recupere penalty_slur_across.
  double getLineBreakingPenaltySlurAcross(Pointer<MXMLOptions> opts) {
    return _getLineBreakingPenaltySlurAcross(opts);
  }

  // Definit penalty_slur_across.
  void setLineBreakingPenaltySlurAcross(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingPenaltySlurAcross(opts, value);
  }

  // Recupere penalty_lyrics_hyphen.
  double getLineBreakingPenaltyLyricsHyphen(Pointer<MXMLOptions> opts) {
    return _getLineBreakingPenaltyLyricsHyphen(opts);
  }

  // Definit penalty_lyrics_hyphen.
  void setLineBreakingPenaltyLyricsHyphen(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingPenaltyLyricsHyphen(opts, value);
  }

  // Recupere penalty_tie_across.
  double getLineBreakingPenaltyTieAcross(Pointer<MXMLOptions> opts) {
    return _getLineBreakingPenaltyTieAcross(opts);
  }

  // Definit penalty_tie_across.
  void setLineBreakingPenaltyTieAcross(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingPenaltyTieAcross(opts, value);
  }

  // Recupere penalty_clef_change.
  double getLineBreakingPenaltyClefChange(Pointer<MXMLOptions> opts) {
    return _getLineBreakingPenaltyClefChange(opts);
  }

  // Definit penalty_clef_change.
  void setLineBreakingPenaltyClefChange(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingPenaltyClefChange(opts, value);
  }

  // Recupere penalty_key_time_change.
  double getLineBreakingPenaltyKeyTimeChange(Pointer<MXMLOptions> opts) {
    return _getLineBreakingPenaltyKeyTimeChange(opts);
  }

  // Definit penalty_key_time_change.
  void setLineBreakingPenaltyKeyTimeChange(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingPenaltyKeyTimeChange(opts, value);
  }

  // Recupere penalty_tempo_text.
  double getLineBreakingPenaltyTempoText(Pointer<MXMLOptions> opts) {
    return _getLineBreakingPenaltyTempoText(opts);
  }

  // Definit penalty_tempo_text.
  void setLineBreakingPenaltyTempoText(Pointer<MXMLOptions> opts, double value) {
    _setLineBreakingPenaltyTempoText(opts, value);
  }

  // Recupere enable_two_pass_optimization.
  bool getLineBreakingEnableTwoPassOptimization(Pointer<MXMLOptions> opts) {
    return _getLineBreakingEnableTwoPassOptimization(opts) == _boolTrue;
  }

  // Definit enable_two_pass_optimization.
  void setLineBreakingEnableTwoPassOptimization(Pointer<MXMLOptions> opts, bool value) {
    _setLineBreakingEnableTwoPassOptimization(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere enable_break_features.
  bool getLineBreakingEnableBreakFeatures(Pointer<MXMLOptions> opts) {
    return _getLineBreakingEnableBreakFeatures(opts) == _boolTrue;
  }

  // Definit enable_break_features.
  void setLineBreakingEnableBreakFeatures(Pointer<MXMLOptions> opts, bool value) {
    _setLineBreakingEnableBreakFeatures(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere enable_system_level_spacing.
  bool getLineBreakingEnableSystemLevelSpacing(Pointer<MXMLOptions> opts) {
    return _getLineBreakingEnableSystemLevelSpacing(opts) == _boolTrue;
  }

  // Definit enable_system_level_spacing.
  void setLineBreakingEnableSystemLevelSpacing(Pointer<MXMLOptions> opts, bool value) {
    _setLineBreakingEnableSystemLevelSpacing(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere max_measures_per_line.
  int getLineBreakingMaxMeasuresPerLine(Pointer<MXMLOptions> opts) {
    return _getLineBreakingMaxMeasuresPerLine(opts);
  }

  // Definit max_measures_per_line.
  void setLineBreakingMaxMeasuresPerLine(Pointer<MXMLOptions> opts, int value) {
    _setLineBreakingMaxMeasuresPerLine(opts, value);
  }

  // --- Notation Options ---

  // Recupere auto_beam.
  bool getNotationAutoBeam(Pointer<MXMLOptions> opts) {
    return _getNotationAutoBeam(opts) == _boolTrue;
  }

  // Definit auto_beam.
  void setNotationAutoBeam(Pointer<MXMLOptions> opts, bool value) {
    _setNotationAutoBeam(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere tuplets_bracketed.
  bool getNotationTupletsBracketed(Pointer<MXMLOptions> opts) {
    return _getNotationTupletsBracketed(opts) == _boolTrue;
  }

  // Definit tuplets_bracketed.
  void setNotationTupletsBracketed(Pointer<MXMLOptions> opts, bool value) {
    _setNotationTupletsBracketed(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere triplets_bracketed.
  bool getNotationTripletsBracketed(Pointer<MXMLOptions> opts) {
    return _getNotationTripletsBracketed(opts) == _boolTrue;
  }

  // Definit triplets_bracketed.
  void setNotationTripletsBracketed(Pointer<MXMLOptions> opts, bool value) {
    _setNotationTripletsBracketed(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere tuplets_ratioed.
  bool getNotationTupletsRatioed(Pointer<MXMLOptions> opts) {
    return _getNotationTupletsRatioed(opts) == _boolTrue;
  }

  // Definit tuplets_ratioed.
  void setNotationTupletsRatioed(Pointer<MXMLOptions> opts, bool value) {
    _setNotationTupletsRatioed(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere align_rests.
  bool getNotationAlignRests(Pointer<MXMLOptions> opts) {
    return _getNotationAlignRests(opts) == _boolTrue;
  }

  // Definit align_rests.
  void setNotationAlignRests(Pointer<MXMLOptions> opts, bool value) {
    _setNotationAlignRests(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere set_wanted_stem_direction_by_xml.
  bool getNotationSetWantedStemDirectionByXml(Pointer<MXMLOptions> opts) {
    return _getNotationSetWantedStemDirectionByXml(opts) == _boolTrue;
  }

  // Definit set_wanted_stem_direction_by_xml.
  void setNotationSetWantedStemDirectionByXml(Pointer<MXMLOptions> opts, bool value) {
    _setNotationSetWantedStemDirectionByXml(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere slur_lift_sample_count.
  int getNotationSlurLiftSampleCount(Pointer<MXMLOptions> opts) {
    return _getNotationSlurLiftSampleCount(opts);
  }

  // Definit slur_lift_sample_count.
  void setNotationSlurLiftSampleCount(Pointer<MXMLOptions> opts, int value) {
    _setNotationSlurLiftSampleCount(opts, value);
  }

  // Recupere fingering_position.
  String getNotationFingeringPosition(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getNotationFingeringPosition(opts));
  }

  // Definit fingering_position.
  void setNotationFingeringPosition(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setNotationFingeringPosition, opts, value);
  }

  // Recupere fingering_inside_stafflines.
  bool getNotationFingeringInsideStafflines(Pointer<MXMLOptions> opts) {
    return _getNotationFingeringInsideStafflines(opts) == _boolTrue;
  }

  // Definit fingering_inside_stafflines.
  void setNotationFingeringInsideStafflines(Pointer<MXMLOptions> opts, bool value) {
    _setNotationFingeringInsideStafflines(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere fingering_y_offset_staff_spaces.
  double getNotationFingeringYOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationFingeringYOffsetStaffSpaces(opts);
  }

  // Definit fingering_y_offset_staff_spaces.
  void setNotationFingeringYOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationFingeringYOffsetStaffSpaces(opts, value);
  }

  // Recupere fingering_font_size.
  double getNotationFingeringFontSize(Pointer<MXMLOptions> opts) {
    return _getNotationFingeringFontSize(opts);
  }

  // Definit fingering_font_size.
  void setNotationFingeringFontSize(Pointer<MXMLOptions> opts, double value) {
    _setNotationFingeringFontSize(opts, value);
  }

  // Recupere pedal_y_offset_staff_spaces.
  double getNotationPedalYOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationPedalYOffsetStaffSpaces(opts);
  }

  // Definit pedal_y_offset_staff_spaces.
  void setNotationPedalYOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationPedalYOffsetStaffSpaces(opts, value);
  }

  // Recupere pedal_line_thickness_staff_spaces.
  double getNotationPedalLineThicknessStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationPedalLineThicknessStaffSpaces(opts);
  }

  // Definit pedal_line_thickness_staff_spaces.
  void setNotationPedalLineThicknessStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationPedalLineThicknessStaffSpaces(opts, value);
  }

  // Recupere pedal_text_font_size.
  double getNotationPedalTextFontSize(Pointer<MXMLOptions> opts) {
    return _getNotationPedalTextFontSize(opts);
  }

  // Definit pedal_text_font_size.
  void setNotationPedalTextFontSize(Pointer<MXMLOptions> opts, double value) {
    _setNotationPedalTextFontSize(opts, value);
  }

  // Recupere pedal_text_to_line_start_staff_spaces.
  double getNotationPedalTextToLineStartStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationPedalTextToLineStartStaffSpaces(opts);
  }

  // Definit pedal_text_to_line_start_staff_spaces.
  void setNotationPedalTextToLineStartStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationPedalTextToLineStartStaffSpaces(opts, value);
  }

  // Recupere pedal_line_to_end_symbol_gap_staff_spaces.
  double getNotationPedalLineToEndSymbolGapStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationPedalLineToEndSymbolGapStaffSpaces(opts);
  }

  // Definit pedal_line_to_end_symbol_gap_staff_spaces.
  void setNotationPedalLineToEndSymbolGapStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationPedalLineToEndSymbolGapStaffSpaces(opts, value);
  }

  // Recupere pedal_change_notch_height_staff_spaces.
  double getNotationPedalChangeNotchHeightStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationPedalChangeNotchHeightStaffSpaces(opts);
  }

  // Definit pedal_change_notch_height_staff_spaces.
  void setNotationPedalChangeNotchHeightStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationPedalChangeNotchHeightStaffSpaces(opts, value);
  }

  // Recupere dynamics_y_offset_staff_spaces.
  double getNotationDynamicsYOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationDynamicsYOffsetStaffSpaces(opts);
  }

  // Definit dynamics_y_offset_staff_spaces.
  void setNotationDynamicsYOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationDynamicsYOffsetStaffSpaces(opts, value);
  }

  // Recupere dynamics_font_size.
  double getNotationDynamicsFontSize(Pointer<MXMLOptions> opts) {
    return _getNotationDynamicsFontSize(opts);
  }

  // Definit dynamics_font_size.
  void setNotationDynamicsFontSize(Pointer<MXMLOptions> opts, double value) {
    _setNotationDynamicsFontSize(opts, value);
  }

  // Recupere wedge_y_offset_staff_spaces.
  double getNotationWedgeYOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationWedgeYOffsetStaffSpaces(opts);
  }

  // Definit wedge_y_offset_staff_spaces.
  void setNotationWedgeYOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationWedgeYOffsetStaffSpaces(opts, value);
  }

  // Recupere wedge_height_staff_spaces.
  double getNotationWedgeHeightStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationWedgeHeightStaffSpaces(opts);
  }

  // Definit wedge_height_staff_spaces.
  void setNotationWedgeHeightStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationWedgeHeightStaffSpaces(opts, value);
  }

  // Recupere wedge_line_thickness_staff_spaces.
  double getNotationWedgeLineThicknessStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationWedgeLineThicknessStaffSpaces(opts);
  }

  // Definit wedge_line_thickness_staff_spaces.
  void setNotationWedgeLineThicknessStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationWedgeLineThicknessStaffSpaces(opts, value);
  }

  // Recupere wedge_inset_from_ends_staff_spaces.
  double getNotationWedgeInsetFromEndsStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationWedgeInsetFromEndsStaffSpaces(opts);
  }

  // Definit wedge_inset_from_ends_staff_spaces.
  void setNotationWedgeInsetFromEndsStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationWedgeInsetFromEndsStaffSpaces(opts, value);
  }

  // Recupere lyrics_y_offset_staff_spaces.
  double getNotationLyricsYOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationLyricsYOffsetStaffSpaces(opts);
  }

  // Definit lyrics_y_offset_staff_spaces.
  void setNotationLyricsYOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationLyricsYOffsetStaffSpaces(opts, value);
  }

  // Recupere lyrics_font_size.
  double getNotationLyricsFontSize(Pointer<MXMLOptions> opts) {
    return _getNotationLyricsFontSize(opts);
  }

  // Definit lyrics_font_size.
  void setNotationLyricsFontSize(Pointer<MXMLOptions> opts, double value) {
    _setNotationLyricsFontSize(opts, value);
  }

  // Recupere lyrics_hyphen_min_gap_staff_spaces.
  double getNotationLyricsHyphenMinGapStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationLyricsHyphenMinGapStaffSpaces(opts);
  }

  // Definit lyrics_hyphen_min_gap_staff_spaces.
  void setNotationLyricsHyphenMinGapStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationLyricsHyphenMinGapStaffSpaces(opts, value);
  }

  // Recupere articulation_offset_staff_spaces.
  double getNotationArticulationOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationArticulationOffsetStaffSpaces(opts);
  }

  // Definit articulation_offset_staff_spaces.
  void setNotationArticulationOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationArticulationOffsetStaffSpaces(opts, value);
  }

  // Recupere articulation_stack_gap_staff_spaces.
  double getNotationArticulationStackGapStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationArticulationStackGapStaffSpaces(opts);
  }

  // Definit articulation_stack_gap_staff_spaces.
  void setNotationArticulationStackGapStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationArticulationStackGapStaffSpaces(opts, value);
  }

  // Recupere articulation_line_thickness_staff_spaces.
  double getNotationArticulationLineThicknessStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationArticulationLineThicknessStaffSpaces(opts);
  }

  // Definit articulation_line_thickness_staff_spaces.
  void setNotationArticulationLineThicknessStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationArticulationLineThicknessStaffSpaces(opts, value);
  }

  // Recupere tenuto_length_staff_spaces.
  double getNotationTenutoLengthStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationTenutoLengthStaffSpaces(opts);
  }

  // Definit tenuto_length_staff_spaces.
  void setNotationTenutoLengthStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationTenutoLengthStaffSpaces(opts, value);
  }

  // Recupere accent_width_staff_spaces.
  double getNotationAccentWidthStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationAccentWidthStaffSpaces(opts);
  }

  // Definit accent_width_staff_spaces.
  void setNotationAccentWidthStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationAccentWidthStaffSpaces(opts, value);
  }

  // Recupere accent_height_staff_spaces.
  double getNotationAccentHeightStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationAccentHeightStaffSpaces(opts);
  }

  // Definit accent_height_staff_spaces.
  void setNotationAccentHeightStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationAccentHeightStaffSpaces(opts, value);
  }

  // Recupere marcato_width_staff_spaces.
  double getNotationMarcatoWidthStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationMarcatoWidthStaffSpaces(opts);
  }

  // Definit marcato_width_staff_spaces.
  void setNotationMarcatoWidthStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationMarcatoWidthStaffSpaces(opts, value);
  }

  // Recupere marcato_height_staff_spaces.
  double getNotationMarcatoHeightStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationMarcatoHeightStaffSpaces(opts);
  }

  // Definit marcato_height_staff_spaces.
  void setNotationMarcatoHeightStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationMarcatoHeightStaffSpaces(opts, value);
  }

  // Recupere staccato_dot_scale.
  double getNotationStaccatoDotScale(Pointer<MXMLOptions> opts) {
    return _getNotationStaccatoDotScale(opts);
  }

  // Definit staccato_dot_scale.
  void setNotationStaccatoDotScale(Pointer<MXMLOptions> opts, double value) {
    _setNotationStaccatoDotScale(opts, value);
  }

  // Recupere fermata_y_offset_staff_spaces.
  double getNotationFermataYOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationFermataYOffsetStaffSpaces(opts);
  }

  // Definit fermata_y_offset_staff_spaces.
  void setNotationFermataYOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationFermataYOffsetStaffSpaces(opts, value);
  }

  // Recupere fermata_dot_to_arc_staff_spaces.
  double getNotationFermataDotToArcStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationFermataDotToArcStaffSpaces(opts);
  }

  // Definit fermata_dot_to_arc_staff_spaces.
  void setNotationFermataDotToArcStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationFermataDotToArcStaffSpaces(opts, value);
  }

  // Recupere fermata_width_staff_spaces.
  double getNotationFermataWidthStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationFermataWidthStaffSpaces(opts);
  }

  // Definit fermata_width_staff_spaces.
  void setNotationFermataWidthStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationFermataWidthStaffSpaces(opts, value);
  }

  // Recupere fermata_height_staff_spaces.
  double getNotationFermataHeightStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationFermataHeightStaffSpaces(opts);
  }

  // Definit fermata_height_staff_spaces.
  void setNotationFermataHeightStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationFermataHeightStaffSpaces(opts, value);
  }

  // Recupere fermata_thickness_start_staff_spaces.
  double getNotationFermataThicknessStartStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationFermataThicknessStartStaffSpaces(opts);
  }

  // Definit fermata_thickness_start_staff_spaces.
  void setNotationFermataThicknessStartStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationFermataThicknessStartStaffSpaces(opts, value);
  }

  // Recupere fermata_thickness_mid_staff_spaces.
  double getNotationFermataThicknessMidStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationFermataThicknessMidStaffSpaces(opts);
  }

  // Definit fermata_thickness_mid_staff_spaces.
  void setNotationFermataThicknessMidStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationFermataThicknessMidStaffSpaces(opts, value);
  }

  // Recupere fermata_dot_scale.
  double getNotationFermataDotScale(Pointer<MXMLOptions> opts) {
    return _getNotationFermataDotScale(opts);
  }

  // Definit fermata_dot_scale.
  void setNotationFermataDotScale(Pointer<MXMLOptions> opts, double value) {
    _setNotationFermataDotScale(opts, value);
  }

  // Recupere ornament_y_offset_staff_spaces.
  double getNotationOrnamentYOffsetStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationOrnamentYOffsetStaffSpaces(opts);
  }

  // Definit ornament_y_offset_staff_spaces.
  void setNotationOrnamentYOffsetStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationOrnamentYOffsetStaffSpaces(opts, value);
  }

  // Recupere ornament_stack_gap_staff_spaces.
  double getNotationOrnamentStackGapStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationOrnamentStackGapStaffSpaces(opts);
  }

  // Definit ornament_stack_gap_staff_spaces.
  void setNotationOrnamentStackGapStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationOrnamentStackGapStaffSpaces(opts, value);
  }

  // Recupere ornament_font_size.
  double getNotationOrnamentFontSize(Pointer<MXMLOptions> opts) {
    return _getNotationOrnamentFontSize(opts);
  }

  // Definit ornament_font_size.
  void setNotationOrnamentFontSize(Pointer<MXMLOptions> opts, double value) {
    _setNotationOrnamentFontSize(opts, value);
  }

  // Recupere staff_distance_staff_spaces.
  double getNotationStaffDistanceStaffSpaces(Pointer<MXMLOptions> opts) {
    return _getNotationStaffDistanceStaffSpaces(opts);
  }

  // Definit staff_distance_staff_spaces.
  void setNotationStaffDistanceStaffSpaces(Pointer<MXMLOptions> opts, double value) {
    _setNotationStaffDistanceStaffSpaces(opts, value);
  }

  // --- Color Options ---

  // Recupere dark_mode.
  bool getColorsDarkMode(Pointer<MXMLOptions> opts) {
    return _getColorsDarkMode(opts) == _boolTrue;
  }

  // Definit dark_mode.
  void setColorsDarkMode(Pointer<MXMLOptions> opts, bool value) {
    _setColorsDarkMode(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere default_color_music.
  String getColorsDefaultColorMusic(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getColorsDefaultColorMusic(opts));
  }

  // Definit default_color_music.
  void setColorsDefaultColorMusic(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setColorsDefaultColorMusic, opts, value);
  }

  // Recupere default_color_notehead.
  String getColorsDefaultColorNotehead(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getColorsDefaultColorNotehead(opts));
  }

  // Definit default_color_notehead.
  void setColorsDefaultColorNotehead(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setColorsDefaultColorNotehead, opts, value);
  }

  // Recupere default_color_stem.
  String getColorsDefaultColorStem(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getColorsDefaultColorStem(opts));
  }

  // Definit default_color_stem.
  void setColorsDefaultColorStem(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setColorsDefaultColorStem, opts, value);
  }

  // Recupere default_color_rest.
  String getColorsDefaultColorRest(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getColorsDefaultColorRest(opts));
  }

  // Definit default_color_rest.
  void setColorsDefaultColorRest(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setColorsDefaultColorRest, opts, value);
  }

  // Recupere default_color_label.
  String getColorsDefaultColorLabel(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getColorsDefaultColorLabel(opts));
  }

  // Definit default_color_label.
  void setColorsDefaultColorLabel(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setColorsDefaultColorLabel, opts, value);
  }

  // Recupere default_color_title.
  String getColorsDefaultColorTitle(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getColorsDefaultColorTitle(opts));
  }

  // Definit default_color_title.
  void setColorsDefaultColorTitle(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setColorsDefaultColorTitle, opts, value);
  }

  // Recupere coloring_enabled.
  bool getColorsColoringEnabled(Pointer<MXMLOptions> opts) {
    return _getColorsColoringEnabled(opts) == _boolTrue;
  }

  // Definit coloring_enabled.
  void setColorsColoringEnabled(Pointer<MXMLOptions> opts, bool value) {
    _setColorsColoringEnabled(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere coloring_mode.
  String getColorsColoringMode(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getColorsColoringMode(opts));
  }

  // Definit coloring_mode.
  void setColorsColoringMode(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setColorsColoringMode, opts, value);
  }

  // Recupere color_stems_like_noteheads.
  bool getColorsColorStemsLikeNoteheads(Pointer<MXMLOptions> opts) {
    return _getColorsColorStemsLikeNoteheads(opts) == _boolTrue;
  }

  // Definit color_stems_like_noteheads.
  void setColorsColorStemsLikeNoteheads(Pointer<MXMLOptions> opts, bool value) {
    _setColorsColorStemsLikeNoteheads(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere la liste custom des couleurs.
  List<String> getColorsCustomSet(Pointer<MXMLOptions> opts) {
    final count = _getColorsColoringSetCustomCount(opts);
    final colors = <String>[];
    // On itere sur la liste exposee par la C-API.
    for (var index = 0; index < count; index++) {
      colors.add(_stringFromPointer(_getColorsColoringSetCustomAt(opts, index)));
    }
    return colors;
  }

  // Definit la liste custom des couleurs.
  void setColorsCustomSet(Pointer<MXMLOptions> opts, List<String> colors) {
    final count = colors.length;
    final listPtr = calloc<Pointer<Utf8>>(count);
    try {
      // On alloue chaque string avant l'appel natif.
      for (var index = 0; index < count; index++) {
        listPtr[index] = colors[index].toNativeUtf8();
      }
      _setColorsColoringSetCustom(opts, listPtr, count);
    } finally {
      // On libere chaque string et le tableau.
      for (var index = 0; index < count; index++) {
        calloc.free(listPtr[index]);
      }
      calloc.free(listPtr);
    }
  }

  // --- Performance Options ---

  // Recupere enable_glyph_cache.
  bool getPerformanceEnableGlyphCache(Pointer<MXMLOptions> opts) {
    return _getPerformanceEnableGlyphCache(opts) == _boolTrue;
  }

  // Definit enable_glyph_cache.
  void setPerformanceEnableGlyphCache(Pointer<MXMLOptions> opts, bool value) {
    _setPerformanceEnableGlyphCache(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere enable_spatial_indexing.
  bool getPerformanceEnableSpatialIndexing(Pointer<MXMLOptions> opts) {
    return _getPerformanceEnableSpatialIndexing(opts) == _boolTrue;
  }

  // Definit enable_spatial_indexing.
  void setPerformanceEnableSpatialIndexing(Pointer<MXMLOptions> opts, bool value) {
    _setPerformanceEnableSpatialIndexing(opts, value ? _boolTrue : _boolFalse);
  }

  // Recupere sky_bottom_line_batch_min_measures.
  int getPerformanceSkyBottomLineBatchMinMeasures(Pointer<MXMLOptions> opts) {
    return _getPerformanceSkyBottomLineBatchMinMeasures(opts);
  }

  // Definit sky_bottom_line_batch_min_measures.
  void setPerformanceSkyBottomLineBatchMinMeasures(Pointer<MXMLOptions> opts, int value) {
    _setPerformanceSkyBottomLineBatchMinMeasures(opts, value);
  }

  // Recupere svg_precision.
  int getPerformanceSvgPrecision(Pointer<MXMLOptions> opts) {
    return _getPerformanceSvgPrecision(opts);
  }

  // Definit svg_precision.
  void setPerformanceSvgPrecision(Pointer<MXMLOptions> opts, int value) {
    _setPerformanceSvgPrecision(opts, value);
  }

  // Recupere bench_enable.
  bool getPerformanceBenchEnable(Pointer<MXMLOptions> opts) {
    return _getPerformanceBenchEnable(opts) == _boolTrue;
  }

  // Definit bench_enable.
  void setPerformanceBenchEnable(Pointer<MXMLOptions> opts, bool value) {
    _setPerformanceBenchEnable(opts, value ? _boolTrue : _boolFalse);
  }

  // --- Global Options ---

  // Recupere backend.
  String getBackend(Pointer<MXMLOptions> opts) {
    return _stringFromPointer(_getBackend(opts));
  }

  // Definit backend.
  void setBackend(Pointer<MXMLOptions> opts, String value) {
    _setStringOption(_setBackend, opts, value);
  }

  // Recupere zoom.
  double getZoom(Pointer<MXMLOptions> opts) {
    return _getZoom(opts);
  }

  // Definit zoom.
  void setZoom(Pointer<MXMLOptions> opts, double value) {
    _setZoom(opts, value);
  }

  // Recupere sheet_maximum_width.
  double getSheetMaximumWidth(Pointer<MXMLOptions> opts) {
    return _getSheetMaximumWidth(opts);
  }

  // Definit sheet_maximum_width.
  void setSheetMaximumWidth(Pointer<MXMLOptions> opts, double value) {
    _setSheetMaximumWidth(opts, value);
  }

  // --- Helpers pour strings ---

  String _stringFromPointer(Pointer<Utf8> ptr) {
    // On renvoie une chaine vide si la C-API renvoie null.
    if (ptr == nullptr) return "";
    return ptr.toDartString();
  }

  void _setStringOption(
    OptionsSetString setter,
    Pointer<MXMLOptions> opts,
    String value,
  ) {
    final valuePtr = value.toNativeUtf8();
    try {
      setter(opts, valuePtr);
    } finally {
      calloc.free(valuePtr);
    }
  }
}
