import 'dart:ffi';
import 'dart:io';

import 'mxml_signatures.dart';

// Charge la bibliotheque native et expose les bindings FFI.
class MxmlLibrary {
  final DynamicLibrary _dylib;
  final MxmlCreate create;
  final MxmlDestroy destroy;
  final MxmlLoadFile loadFile;
  final MxmlLayout layout;
  final MxmlGetHeight getHeight;
  final MxmlGetGlyphCodepoint getGlyphCodepoint;
  final MxmlGetRenderCommands getRenderCommands;
  final MxmlGetString getString;
  final MxmlWriteSvgToFile writeSvgToFile;
  final MxmlGetPipelineBench getPipelineBench;
  final MxmlOptionsCreate optionsCreate;
  final MxmlOptionsDestroy optionsDestroy;
  final MxmlOptionsApplyStandard optionsApplyStandard;
  final MxmlOptionsApplyPiano optionsApplyPiano;
  final MxmlOptionsApplyPianoPedagogic optionsApplyPianoPedagogic;
  final MxmlOptionsApplyCompact optionsApplyCompact;
  final MxmlOptionsApplyPrint optionsApplyPrint;
  final MxmlLayoutWithOptions layoutWithOptions;
  final OptionsSetBool setRenderingDrawTitle;
  final OptionsGetBool getRenderingDrawTitle;
  final OptionsSetBool setRenderingDrawPartNames;
  final OptionsGetBool getRenderingDrawPartNames;
  final OptionsSetBool setRenderingDrawMeasureNumbers;
  final OptionsGetBool getRenderingDrawMeasureNumbers;
  final OptionsSetBool setRenderingDrawMeasureNumbersOnlyAtSystemStart;
  final OptionsGetBool getRenderingDrawMeasureNumbersOnlyAtSystemStart;
  final OptionsSetInt setRenderingDrawMeasureNumbersBegin;
  final OptionsGetInt getRenderingDrawMeasureNumbersBegin;
  final OptionsSetInt setRenderingMeasureNumberInterval;
  final OptionsGetInt getRenderingMeasureNumberInterval;
  final OptionsSetBool setRenderingDrawTimeSignatures;
  final OptionsGetBool getRenderingDrawTimeSignatures;
  final OptionsSetBool setRenderingDrawKeySignatures;
  final OptionsGetBool getRenderingDrawKeySignatures;
  final OptionsSetBool setRenderingDrawFingerings;
  final OptionsGetBool getRenderingDrawFingerings;
  final OptionsSetBool setRenderingDrawSlurs;
  final OptionsGetBool getRenderingDrawSlurs;
  final OptionsSetBool setRenderingDrawPedals;
  final OptionsGetBool getRenderingDrawPedals;
  final OptionsSetBool setRenderingDrawDynamics;
  final OptionsGetBool getRenderingDrawDynamics;
  final OptionsSetBool setRenderingDrawWedges;
  final OptionsGetBool getRenderingDrawWedges;
  final OptionsSetBool setRenderingDrawLyrics;
  final OptionsGetBool getRenderingDrawLyrics;
  final OptionsSetBool setRenderingDrawCredits;
  final OptionsGetBool getRenderingDrawCredits;
  final OptionsSetBool setRenderingDrawComposer;
  final OptionsGetBool getRenderingDrawComposer;
  final OptionsSetBool setRenderingDrawLyricist;
  final OptionsGetBool getRenderingDrawLyricist;
  final OptionsSetString setLayoutPageFormat;
  final OptionsGetString getLayoutPageFormat;
  final OptionsSetBool setLayoutUseFixedCanvas;
  final OptionsGetBool getLayoutUseFixedCanvas;
  final OptionsSetDouble setLayoutFixedCanvasWidth;
  final OptionsGetDouble getLayoutFixedCanvasWidth;
  final OptionsSetDouble setLayoutFixedCanvasHeight;
  final OptionsGetDouble getLayoutFixedCanvasHeight;
  final OptionsSetDouble setLayoutPageHeight;
  final OptionsGetDouble getLayoutPageHeight;
  final OptionsSetDouble setLayoutPageMarginLeftStaffSpaces;
  final OptionsGetDouble getLayoutPageMarginLeftStaffSpaces;
  final OptionsSetDouble setLayoutPageMarginRightStaffSpaces;
  final OptionsGetDouble getLayoutPageMarginRightStaffSpaces;
  final OptionsSetDouble setLayoutPageMarginTopStaffSpaces;
  final OptionsGetDouble getLayoutPageMarginTopStaffSpaces;
  final OptionsSetDouble setLayoutPageMarginBottomStaffSpaces;
  final OptionsGetDouble getLayoutPageMarginBottomStaffSpaces;
  final OptionsSetDouble setLayoutSystemSpacingMinStaffSpaces;
  final OptionsGetDouble getLayoutSystemSpacingMinStaffSpaces;
  final OptionsSetDouble setLayoutSystemSpacingMultiStaffMinStaffSpaces;
  final OptionsGetDouble getLayoutSystemSpacingMultiStaffMinStaffSpaces;
  final OptionsSetBool setLayoutNewSystemFromXml;
  final OptionsGetBool getLayoutNewSystemFromXml;
  final OptionsSetBool setLayoutNewPageFromXml;
  final OptionsGetBool getLayoutNewPageFromXml;
  final OptionsSetBool setLayoutFillEmptyMeasuresWithWholeRest;
  final OptionsGetBool getLayoutFillEmptyMeasuresWithWholeRest;
  final OptionsSetDouble setLineBreakingJustificationRatioMin;
  final OptionsGetDouble getLineBreakingJustificationRatioMin;
  final OptionsSetDouble setLineBreakingJustificationRatioMax;
  final OptionsGetDouble getLineBreakingJustificationRatioMax;
  final OptionsSetDouble setLineBreakingJustificationRatioTarget;
  final OptionsGetDouble getLineBreakingJustificationRatioTarget;
  final OptionsSetDouble setLineBreakingJustificationRatioSoftMin;
  final OptionsGetDouble getLineBreakingJustificationRatioSoftMin;
  final OptionsSetDouble setLineBreakingJustificationRatioSoftMax;
  final OptionsGetDouble getLineBreakingJustificationRatioSoftMax;
  final OptionsSetDouble setLineBreakingWeightRatio;
  final OptionsGetDouble getLineBreakingWeightRatio;
  final OptionsSetDouble setLineBreakingWeightTight;
  final OptionsGetDouble getLineBreakingWeightTight;
  final OptionsSetDouble setLineBreakingWeightLoose;
  final OptionsGetDouble getLineBreakingWeightLoose;
  final OptionsSetDouble setLineBreakingWeightLastUnder;
  final OptionsGetDouble getLineBreakingWeightLastUnder;
  final OptionsSetDouble setLineBreakingCostPower;
  final OptionsGetDouble getLineBreakingCostPower;
  final OptionsSetBool setLineBreakingStretchLastSystem;
  final OptionsGetBool getLineBreakingStretchLastSystem;
  final OptionsSetDouble setLineBreakingLastLineMaxUnderfill;
  final OptionsGetDouble getLineBreakingLastLineMaxUnderfill;
  final OptionsSetInt setLineBreakingTargetMeasuresPerSystem;
  final OptionsGetInt getLineBreakingTargetMeasuresPerSystem;
  final OptionsSetDouble setLineBreakingWeightCount;
  final OptionsGetDouble getLineBreakingWeightCount;
  final OptionsSetDouble setLineBreakingBonusFinalBar;
  final OptionsGetDouble getLineBreakingBonusFinalBar;
  final OptionsSetDouble setLineBreakingBonusDoubleBar;
  final OptionsGetDouble getLineBreakingBonusDoubleBar;
  final OptionsSetDouble setLineBreakingBonusPhrasEnd;
  final OptionsGetDouble getLineBreakingBonusPhrasEnd;
  final OptionsSetDouble setLineBreakingBonusRehearsalMark;
  final OptionsGetDouble getLineBreakingBonusRehearsalMark;
  final OptionsSetDouble setLineBreakingPenaltyHairpinAcross;
  final OptionsGetDouble getLineBreakingPenaltyHairpinAcross;
  final OptionsSetDouble setLineBreakingPenaltySlurAcross;
  final OptionsGetDouble getLineBreakingPenaltySlurAcross;
  final OptionsSetDouble setLineBreakingPenaltyLyricsHyphen;
  final OptionsGetDouble getLineBreakingPenaltyLyricsHyphen;
  final OptionsSetDouble setLineBreakingPenaltyTieAcross;
  final OptionsGetDouble getLineBreakingPenaltyTieAcross;
  final OptionsSetDouble setLineBreakingPenaltyClefChange;
  final OptionsGetDouble getLineBreakingPenaltyClefChange;
  final OptionsSetDouble setLineBreakingPenaltyKeyTimeChange;
  final OptionsGetDouble getLineBreakingPenaltyKeyTimeChange;
  final OptionsSetDouble setLineBreakingPenaltyTempoText;
  final OptionsGetDouble getLineBreakingPenaltyTempoText;
  final OptionsSetBool setLineBreakingEnableTwoPassOptimization;
  final OptionsGetBool getLineBreakingEnableTwoPassOptimization;
  final OptionsSetBool setLineBreakingEnableBreakFeatures;
  final OptionsGetBool getLineBreakingEnableBreakFeatures;
  final OptionsSetBool setLineBreakingEnableSystemLevelSpacing;
  final OptionsGetBool getLineBreakingEnableSystemLevelSpacing;
  final OptionsSetInt setLineBreakingMaxMeasuresPerLine;
  final OptionsGetInt getLineBreakingMaxMeasuresPerLine;
  final OptionsSetBool setNotationAutoBeam;
  final OptionsGetBool getNotationAutoBeam;
  final OptionsSetBool setNotationTupletsBracketed;
  final OptionsGetBool getNotationTupletsBracketed;
  final OptionsSetBool setNotationTripletsBracketed;
  final OptionsGetBool getNotationTripletsBracketed;
  final OptionsSetBool setNotationTupletsRatioed;
  final OptionsGetBool getNotationTupletsRatioed;
  final OptionsSetBool setNotationAlignRests;
  final OptionsGetBool getNotationAlignRests;
  final OptionsSetBool setNotationSetWantedStemDirectionByXml;
  final OptionsGetBool getNotationSetWantedStemDirectionByXml;
  final OptionsSetInt setNotationSlurLiftSampleCount;
  final OptionsGetInt getNotationSlurLiftSampleCount;
  final OptionsSetString setNotationFingeringPosition;
  final OptionsGetString getNotationFingeringPosition;
  final OptionsSetBool setNotationFingeringInsideStafflines;
  final OptionsGetBool getNotationFingeringInsideStafflines;
  final OptionsSetDouble setNotationFingeringYOffsetStaffSpaces;
  final OptionsGetDouble getNotationFingeringYOffsetStaffSpaces;
  final OptionsSetDouble setNotationFingeringFontSize;
  final OptionsGetDouble getNotationFingeringFontSize;
  final OptionsSetDouble setNotationPedalYOffsetStaffSpaces;
  final OptionsGetDouble getNotationPedalYOffsetStaffSpaces;
  final OptionsSetDouble setNotationPedalLineThicknessStaffSpaces;
  final OptionsGetDouble getNotationPedalLineThicknessStaffSpaces;
  final OptionsSetDouble setNotationPedalTextFontSize;
  final OptionsGetDouble getNotationPedalTextFontSize;
  final OptionsSetDouble setNotationPedalTextToLineStartStaffSpaces;
  final OptionsGetDouble getNotationPedalTextToLineStartStaffSpaces;
  final OptionsSetDouble setNotationPedalLineToEndSymbolGapStaffSpaces;
  final OptionsGetDouble getNotationPedalLineToEndSymbolGapStaffSpaces;
  final OptionsSetDouble setNotationPedalChangeNotchHeightStaffSpaces;
  final OptionsGetDouble getNotationPedalChangeNotchHeightStaffSpaces;
  final OptionsSetDouble setNotationDynamicsYOffsetStaffSpaces;
  final OptionsGetDouble getNotationDynamicsYOffsetStaffSpaces;
  final OptionsSetDouble setNotationDynamicsFontSize;
  final OptionsGetDouble getNotationDynamicsFontSize;
  final OptionsSetDouble setNotationWedgeYOffsetStaffSpaces;
  final OptionsGetDouble getNotationWedgeYOffsetStaffSpaces;
  final OptionsSetDouble setNotationWedgeHeightStaffSpaces;
  final OptionsGetDouble getNotationWedgeHeightStaffSpaces;
  final OptionsSetDouble setNotationWedgeLineThicknessStaffSpaces;
  final OptionsGetDouble getNotationWedgeLineThicknessStaffSpaces;
  final OptionsSetDouble setNotationWedgeInsetFromEndsStaffSpaces;
  final OptionsGetDouble getNotationWedgeInsetFromEndsStaffSpaces;
  final OptionsSetDouble setNotationLyricsYOffsetStaffSpaces;
  final OptionsGetDouble getNotationLyricsYOffsetStaffSpaces;
  final OptionsSetDouble setNotationLyricsFontSize;
  final OptionsGetDouble getNotationLyricsFontSize;
  final OptionsSetDouble setNotationLyricsHyphenMinGapStaffSpaces;
  final OptionsGetDouble getNotationLyricsHyphenMinGapStaffSpaces;
  final OptionsSetDouble setNotationArticulationOffsetStaffSpaces;
  final OptionsGetDouble getNotationArticulationOffsetStaffSpaces;
  final OptionsSetDouble setNotationArticulationStackGapStaffSpaces;
  final OptionsGetDouble getNotationArticulationStackGapStaffSpaces;
  final OptionsSetDouble setNotationArticulationLineThicknessStaffSpaces;
  final OptionsGetDouble getNotationArticulationLineThicknessStaffSpaces;
  final OptionsSetDouble setNotationTenutoLengthStaffSpaces;
  final OptionsGetDouble getNotationTenutoLengthStaffSpaces;
  final OptionsSetDouble setNotationAccentWidthStaffSpaces;
  final OptionsGetDouble getNotationAccentWidthStaffSpaces;
  final OptionsSetDouble setNotationAccentHeightStaffSpaces;
  final OptionsGetDouble getNotationAccentHeightStaffSpaces;
  final OptionsSetDouble setNotationMarcatoWidthStaffSpaces;
  final OptionsGetDouble getNotationMarcatoWidthStaffSpaces;
  final OptionsSetDouble setNotationMarcatoHeightStaffSpaces;
  final OptionsGetDouble getNotationMarcatoHeightStaffSpaces;
  final OptionsSetDouble setNotationStaccatoDotScale;
  final OptionsGetDouble getNotationStaccatoDotScale;
  final OptionsSetDouble setNotationFermataYOffsetStaffSpaces;
  final OptionsGetDouble getNotationFermataYOffsetStaffSpaces;
  final OptionsSetDouble setNotationFermataDotToArcStaffSpaces;
  final OptionsGetDouble getNotationFermataDotToArcStaffSpaces;
  final OptionsSetDouble setNotationFermataWidthStaffSpaces;
  final OptionsGetDouble getNotationFermataWidthStaffSpaces;
  final OptionsSetDouble setNotationFermataHeightStaffSpaces;
  final OptionsGetDouble getNotationFermataHeightStaffSpaces;
  final OptionsSetDouble setNotationFermataThicknessStartStaffSpaces;
  final OptionsGetDouble getNotationFermataThicknessStartStaffSpaces;
  final OptionsSetDouble setNotationFermataThicknessMidStaffSpaces;
  final OptionsGetDouble getNotationFermataThicknessMidStaffSpaces;
  final OptionsSetDouble setNotationFermataDotScale;
  final OptionsGetDouble getNotationFermataDotScale;
  final OptionsSetDouble setNotationOrnamentYOffsetStaffSpaces;
  final OptionsGetDouble getNotationOrnamentYOffsetStaffSpaces;
  final OptionsSetDouble setNotationOrnamentStackGapStaffSpaces;
  final OptionsGetDouble getNotationOrnamentStackGapStaffSpaces;
  final OptionsSetDouble setNotationOrnamentFontSize;
  final OptionsGetDouble getNotationOrnamentFontSize;
  final OptionsSetDouble setNotationStaffDistanceStaffSpaces;
  final OptionsGetDouble getNotationStaffDistanceStaffSpaces;
  final OptionsSetBool setColorsDarkMode;
  final OptionsGetBool getColorsDarkMode;
  final OptionsSetString setColorsDefaultColorMusic;
  final OptionsGetString getColorsDefaultColorMusic;
  final OptionsSetString setColorsDefaultColorNotehead;
  final OptionsGetString getColorsDefaultColorNotehead;
  final OptionsSetString setColorsDefaultColorStem;
  final OptionsGetString getColorsDefaultColorStem;
  final OptionsSetString setColorsDefaultColorRest;
  final OptionsGetString getColorsDefaultColorRest;
  final OptionsSetString setColorsDefaultColorLabel;
  final OptionsGetString getColorsDefaultColorLabel;
  final OptionsSetString setColorsDefaultColorTitle;
  final OptionsGetString getColorsDefaultColorTitle;
  final OptionsSetBool setColorsColoringEnabled;
  final OptionsGetBool getColorsColoringEnabled;
  final OptionsSetString setColorsColoringMode;
  final OptionsGetString getColorsColoringMode;
  final OptionsSetBool setColorsColorStemsLikeNoteheads;
  final OptionsGetBool getColorsColorStemsLikeNoteheads;
  final OptionsSetStringList setColorsColoringSetCustom;
  final OptionsGetStringListCount getColorsColoringSetCustomCount;
  final OptionsGetStringListAt getColorsColoringSetCustomAt;
  final OptionsSetBool setPerformanceEnableGlyphCache;
  final OptionsGetBool getPerformanceEnableGlyphCache;
  final OptionsSetBool setPerformanceEnableSpatialIndexing;
  final OptionsGetBool getPerformanceEnableSpatialIndexing;
  final OptionsSetInt setPerformanceSkyBottomLineBatchMinMeasures;
  final OptionsGetInt getPerformanceSkyBottomLineBatchMinMeasures;
  final OptionsSetInt setPerformanceSvgPrecision;
  final OptionsGetInt getPerformanceSvgPrecision;
  final OptionsSetBool setPerformanceBenchEnable;
  final OptionsGetBool getPerformanceBenchEnable;
  final OptionsSetString setBackend;
  final OptionsGetString getBackend;
  final OptionsSetDouble setZoom;
  final OptionsGetDouble getZoom;
  final OptionsSetDouble setSheetMaximumWidth;
  final OptionsGetDouble getSheetMaximumWidth;

  // Construit le conteneur a partir d'une lib deja chargee.
  MxmlLibrary._(
    this._dylib, {
    required this.create,
    required this.destroy,
    required this.loadFile,
    required this.layout,
    required this.getHeight,
    required this.getGlyphCodepoint,
    required this.getRenderCommands,
    required this.getString,
    required this.writeSvgToFile,
    required this.getPipelineBench,
    required this.optionsCreate,
    required this.optionsDestroy,
    required this.optionsApplyStandard,
    required this.optionsApplyPiano,
    required this.optionsApplyPianoPedagogic,
    required this.optionsApplyCompact,
    required this.optionsApplyPrint,
    required this.layoutWithOptions,
    required this.setRenderingDrawTitle,
    required this.getRenderingDrawTitle,
    required this.setRenderingDrawPartNames,
    required this.getRenderingDrawPartNames,
    required this.setRenderingDrawMeasureNumbers,
    required this.getRenderingDrawMeasureNumbers,
    required this.setRenderingDrawMeasureNumbersOnlyAtSystemStart,
    required this.getRenderingDrawMeasureNumbersOnlyAtSystemStart,
    required this.setRenderingDrawMeasureNumbersBegin,
    required this.getRenderingDrawMeasureNumbersBegin,
    required this.setRenderingMeasureNumberInterval,
    required this.getRenderingMeasureNumberInterval,
    required this.setRenderingDrawTimeSignatures,
    required this.getRenderingDrawTimeSignatures,
    required this.setRenderingDrawKeySignatures,
    required this.getRenderingDrawKeySignatures,
    required this.setRenderingDrawFingerings,
    required this.getRenderingDrawFingerings,
    required this.setRenderingDrawSlurs,
    required this.getRenderingDrawSlurs,
    required this.setRenderingDrawPedals,
    required this.getRenderingDrawPedals,
    required this.setRenderingDrawDynamics,
    required this.getRenderingDrawDynamics,
    required this.setRenderingDrawWedges,
    required this.getRenderingDrawWedges,
    required this.setRenderingDrawLyrics,
    required this.getRenderingDrawLyrics,
    required this.setRenderingDrawCredits,
    required this.getRenderingDrawCredits,
    required this.setRenderingDrawComposer,
    required this.getRenderingDrawComposer,
    required this.setRenderingDrawLyricist,
    required this.getRenderingDrawLyricist,
    required this.setLayoutPageFormat,
    required this.getLayoutPageFormat,
    required this.setLayoutUseFixedCanvas,
    required this.getLayoutUseFixedCanvas,
    required this.setLayoutFixedCanvasWidth,
    required this.getLayoutFixedCanvasWidth,
    required this.setLayoutFixedCanvasHeight,
    required this.getLayoutFixedCanvasHeight,
    required this.setLayoutPageHeight,
    required this.getLayoutPageHeight,
    required this.setLayoutPageMarginLeftStaffSpaces,
    required this.getLayoutPageMarginLeftStaffSpaces,
    required this.setLayoutPageMarginRightStaffSpaces,
    required this.getLayoutPageMarginRightStaffSpaces,
    required this.setLayoutPageMarginTopStaffSpaces,
    required this.getLayoutPageMarginTopStaffSpaces,
    required this.setLayoutPageMarginBottomStaffSpaces,
    required this.getLayoutPageMarginBottomStaffSpaces,
    required this.setLayoutSystemSpacingMinStaffSpaces,
    required this.getLayoutSystemSpacingMinStaffSpaces,
    required this.setLayoutSystemSpacingMultiStaffMinStaffSpaces,
    required this.getLayoutSystemSpacingMultiStaffMinStaffSpaces,
    required this.setLayoutNewSystemFromXml,
    required this.getLayoutNewSystemFromXml,
    required this.setLayoutNewPageFromXml,
    required this.getLayoutNewPageFromXml,
    required this.setLayoutFillEmptyMeasuresWithWholeRest,
    required this.getLayoutFillEmptyMeasuresWithWholeRest,
    required this.setLineBreakingJustificationRatioMin,
    required this.getLineBreakingJustificationRatioMin,
    required this.setLineBreakingJustificationRatioMax,
    required this.getLineBreakingJustificationRatioMax,
    required this.setLineBreakingJustificationRatioTarget,
    required this.getLineBreakingJustificationRatioTarget,
    required this.setLineBreakingJustificationRatioSoftMin,
    required this.getLineBreakingJustificationRatioSoftMin,
    required this.setLineBreakingJustificationRatioSoftMax,
    required this.getLineBreakingJustificationRatioSoftMax,
    required this.setLineBreakingWeightRatio,
    required this.getLineBreakingWeightRatio,
    required this.setLineBreakingWeightTight,
    required this.getLineBreakingWeightTight,
    required this.setLineBreakingWeightLoose,
    required this.getLineBreakingWeightLoose,
    required this.setLineBreakingWeightLastUnder,
    required this.getLineBreakingWeightLastUnder,
    required this.setLineBreakingCostPower,
    required this.getLineBreakingCostPower,
    required this.setLineBreakingStretchLastSystem,
    required this.getLineBreakingStretchLastSystem,
    required this.setLineBreakingLastLineMaxUnderfill,
    required this.getLineBreakingLastLineMaxUnderfill,
    required this.setLineBreakingTargetMeasuresPerSystem,
    required this.getLineBreakingTargetMeasuresPerSystem,
    required this.setLineBreakingWeightCount,
    required this.getLineBreakingWeightCount,
    required this.setLineBreakingBonusFinalBar,
    required this.getLineBreakingBonusFinalBar,
    required this.setLineBreakingBonusDoubleBar,
    required this.getLineBreakingBonusDoubleBar,
    required this.setLineBreakingBonusPhrasEnd,
    required this.getLineBreakingBonusPhrasEnd,
    required this.setLineBreakingBonusRehearsalMark,
    required this.getLineBreakingBonusRehearsalMark,
    required this.setLineBreakingPenaltyHairpinAcross,
    required this.getLineBreakingPenaltyHairpinAcross,
    required this.setLineBreakingPenaltySlurAcross,
    required this.getLineBreakingPenaltySlurAcross,
    required this.setLineBreakingPenaltyLyricsHyphen,
    required this.getLineBreakingPenaltyLyricsHyphen,
    required this.setLineBreakingPenaltyTieAcross,
    required this.getLineBreakingPenaltyTieAcross,
    required this.setLineBreakingPenaltyClefChange,
    required this.getLineBreakingPenaltyClefChange,
    required this.setLineBreakingPenaltyKeyTimeChange,
    required this.getLineBreakingPenaltyKeyTimeChange,
    required this.setLineBreakingPenaltyTempoText,
    required this.getLineBreakingPenaltyTempoText,
    required this.setLineBreakingEnableTwoPassOptimization,
    required this.getLineBreakingEnableTwoPassOptimization,
    required this.setLineBreakingEnableBreakFeatures,
    required this.getLineBreakingEnableBreakFeatures,
    required this.setLineBreakingEnableSystemLevelSpacing,
    required this.getLineBreakingEnableSystemLevelSpacing,
    required this.setLineBreakingMaxMeasuresPerLine,
    required this.getLineBreakingMaxMeasuresPerLine,
    required this.setNotationAutoBeam,
    required this.getNotationAutoBeam,
    required this.setNotationTupletsBracketed,
    required this.getNotationTupletsBracketed,
    required this.setNotationTripletsBracketed,
    required this.getNotationTripletsBracketed,
    required this.setNotationTupletsRatioed,
    required this.getNotationTupletsRatioed,
    required this.setNotationAlignRests,
    required this.getNotationAlignRests,
    required this.setNotationSetWantedStemDirectionByXml,
    required this.getNotationSetWantedStemDirectionByXml,
    required this.setNotationSlurLiftSampleCount,
    required this.getNotationSlurLiftSampleCount,
    required this.setNotationFingeringPosition,
    required this.getNotationFingeringPosition,
    required this.setNotationFingeringInsideStafflines,
    required this.getNotationFingeringInsideStafflines,
    required this.setNotationFingeringYOffsetStaffSpaces,
    required this.getNotationFingeringYOffsetStaffSpaces,
    required this.setNotationFingeringFontSize,
    required this.getNotationFingeringFontSize,
    required this.setNotationPedalYOffsetStaffSpaces,
    required this.getNotationPedalYOffsetStaffSpaces,
    required this.setNotationPedalLineThicknessStaffSpaces,
    required this.getNotationPedalLineThicknessStaffSpaces,
    required this.setNotationPedalTextFontSize,
    required this.getNotationPedalTextFontSize,
    required this.setNotationPedalTextToLineStartStaffSpaces,
    required this.getNotationPedalTextToLineStartStaffSpaces,
    required this.setNotationPedalLineToEndSymbolGapStaffSpaces,
    required this.getNotationPedalLineToEndSymbolGapStaffSpaces,
    required this.setNotationPedalChangeNotchHeightStaffSpaces,
    required this.getNotationPedalChangeNotchHeightStaffSpaces,
    required this.setNotationDynamicsYOffsetStaffSpaces,
    required this.getNotationDynamicsYOffsetStaffSpaces,
    required this.setNotationDynamicsFontSize,
    required this.getNotationDynamicsFontSize,
    required this.setNotationWedgeYOffsetStaffSpaces,
    required this.getNotationWedgeYOffsetStaffSpaces,
    required this.setNotationWedgeHeightStaffSpaces,
    required this.getNotationWedgeHeightStaffSpaces,
    required this.setNotationWedgeLineThicknessStaffSpaces,
    required this.getNotationWedgeLineThicknessStaffSpaces,
    required this.setNotationWedgeInsetFromEndsStaffSpaces,
    required this.getNotationWedgeInsetFromEndsStaffSpaces,
    required this.setNotationLyricsYOffsetStaffSpaces,
    required this.getNotationLyricsYOffsetStaffSpaces,
    required this.setNotationLyricsFontSize,
    required this.getNotationLyricsFontSize,
    required this.setNotationLyricsHyphenMinGapStaffSpaces,
    required this.getNotationLyricsHyphenMinGapStaffSpaces,
    required this.setNotationArticulationOffsetStaffSpaces,
    required this.getNotationArticulationOffsetStaffSpaces,
    required this.setNotationArticulationStackGapStaffSpaces,
    required this.getNotationArticulationStackGapStaffSpaces,
    required this.setNotationArticulationLineThicknessStaffSpaces,
    required this.getNotationArticulationLineThicknessStaffSpaces,
    required this.setNotationTenutoLengthStaffSpaces,
    required this.getNotationTenutoLengthStaffSpaces,
    required this.setNotationAccentWidthStaffSpaces,
    required this.getNotationAccentWidthStaffSpaces,
    required this.setNotationAccentHeightStaffSpaces,
    required this.getNotationAccentHeightStaffSpaces,
    required this.setNotationMarcatoWidthStaffSpaces,
    required this.getNotationMarcatoWidthStaffSpaces,
    required this.setNotationMarcatoHeightStaffSpaces,
    required this.getNotationMarcatoHeightStaffSpaces,
    required this.setNotationStaccatoDotScale,
    required this.getNotationStaccatoDotScale,
    required this.setNotationFermataYOffsetStaffSpaces,
    required this.getNotationFermataYOffsetStaffSpaces,
    required this.setNotationFermataDotToArcStaffSpaces,
    required this.getNotationFermataDotToArcStaffSpaces,
    required this.setNotationFermataWidthStaffSpaces,
    required this.getNotationFermataWidthStaffSpaces,
    required this.setNotationFermataHeightStaffSpaces,
    required this.getNotationFermataHeightStaffSpaces,
    required this.setNotationFermataThicknessStartStaffSpaces,
    required this.getNotationFermataThicknessStartStaffSpaces,
    required this.setNotationFermataThicknessMidStaffSpaces,
    required this.getNotationFermataThicknessMidStaffSpaces,
    required this.setNotationFermataDotScale,
    required this.getNotationFermataDotScale,
    required this.setNotationOrnamentYOffsetStaffSpaces,
    required this.getNotationOrnamentYOffsetStaffSpaces,
    required this.setNotationOrnamentStackGapStaffSpaces,
    required this.getNotationOrnamentStackGapStaffSpaces,
    required this.setNotationOrnamentFontSize,
    required this.getNotationOrnamentFontSize,
    required this.setNotationStaffDistanceStaffSpaces,
    required this.getNotationStaffDistanceStaffSpaces,
    required this.setColorsDarkMode,
    required this.getColorsDarkMode,
    required this.setColorsDefaultColorMusic,
    required this.getColorsDefaultColorMusic,
    required this.setColorsDefaultColorNotehead,
    required this.getColorsDefaultColorNotehead,
    required this.setColorsDefaultColorStem,
    required this.getColorsDefaultColorStem,
    required this.setColorsDefaultColorRest,
    required this.getColorsDefaultColorRest,
    required this.setColorsDefaultColorLabel,
    required this.getColorsDefaultColorLabel,
    required this.setColorsDefaultColorTitle,
    required this.getColorsDefaultColorTitle,
    required this.setColorsColoringEnabled,
    required this.getColorsColoringEnabled,
    required this.setColorsColoringMode,
    required this.getColorsColoringMode,
    required this.setColorsColorStemsLikeNoteheads,
    required this.getColorsColorStemsLikeNoteheads,
    required this.setColorsColoringSetCustom,
    required this.getColorsColoringSetCustomCount,
    required this.getColorsColoringSetCustomAt,
    required this.setPerformanceEnableGlyphCache,
    required this.getPerformanceEnableGlyphCache,
    required this.setPerformanceEnableSpatialIndexing,
    required this.getPerformanceEnableSpatialIndexing,
    required this.setPerformanceSkyBottomLineBatchMinMeasures,
    required this.getPerformanceSkyBottomLineBatchMinMeasures,
    required this.setPerformanceSvgPrecision,
    required this.getPerformanceSvgPrecision,
    required this.setPerformanceBenchEnable,
    required this.getPerformanceBenchEnable,
    required this.setBackend,
    required this.getBackend,
    required this.setZoom,
    required this.getZoom,
    required this.setSheetMaximumWidth,
    required this.getSheetMaximumWidth,
  });

  // Charge la lib native et fait tous les lookups.
  factory MxmlLibrary.open() {
    final dylib = _openDynamicLibrary();
    return MxmlLibrary.fromLibrary(dylib);
  }

  // Lie les symboles a partir d'une lib deja ouverte.
  factory MxmlLibrary.fromLibrary(DynamicLibrary dylib) {
    return MxmlLibrary._(
      dylib,
      create: dylib.lookupFunction<mxml_create_func, MxmlCreate>('mxml_create'),
      destroy: dylib.lookupFunction<mxml_destroy_func, MxmlDestroy>('mxml_destroy'),
      loadFile: dylib.lookupFunction<mxml_load_file_func, MxmlLoadFile>('mxml_load_file'),
      layout: dylib.lookupFunction<mxml_layout_func, MxmlLayout>('mxml_layout'),
      getHeight: dylib.lookupFunction<mxml_get_height_func, MxmlGetHeight>('mxml_get_height'),
      getGlyphCodepoint:
          dylib.lookupFunction<mxml_get_glyph_codepoint_func, MxmlGetGlyphCodepoint>(
        'mxml_get_glyph_codepoint',
      ),
      getRenderCommands: dylib.lookupFunction<mxml_get_render_commands_func, MxmlGetRenderCommands>(
        'mxml_get_render_commands',
      ),
      getString: dylib.lookupFunction<mxml_get_string_func, MxmlGetString>('mxml_get_string'),
      writeSvgToFile:
          dylib.lookupFunction<mxml_write_svg_to_file_func, MxmlWriteSvgToFile>('mxml_write_svg_to_file'),
      getPipelineBench:
          dylib.lookupFunction<mxml_get_pipeline_bench_func, MxmlGetPipelineBench>('mxml_get_pipeline_bench'),
      optionsCreate: dylib.lookupFunction<mxml_options_create_func, MxmlOptionsCreate>(
        'mxml_options_create',
      ),
      optionsDestroy: dylib.lookupFunction<mxml_options_destroy_func, MxmlOptionsDestroy>(
        'mxml_options_destroy',
      ),
      optionsApplyStandard:
          dylib.lookupFunction<mxml_options_apply_standard_func, MxmlOptionsApplyStandard>(
        'mxml_options_apply_standard',
      ),
      optionsApplyPiano: dylib.lookupFunction<mxml_options_apply_piano_func, MxmlOptionsApplyPiano>(
        'mxml_options_apply_piano',
      ),
      optionsApplyPianoPedagogic:
          dylib.lookupFunction<mxml_options_apply_piano_pedagogic_func, MxmlOptionsApplyPianoPedagogic>(
        'mxml_options_apply_piano_pedagogic',
      ),
      optionsApplyCompact:
          dylib.lookupFunction<mxml_options_apply_compact_func, MxmlOptionsApplyCompact>(
        'mxml_options_apply_compact',
      ),
      optionsApplyPrint:
          dylib.lookupFunction<mxml_options_apply_print_func, MxmlOptionsApplyPrint>(
        'mxml_options_apply_print',
      ),
      layoutWithOptions:
          dylib.lookupFunction<mxml_layout_with_options_func, MxmlLayoutWithOptions>(
        'mxml_layout_with_options',
      ),
      setRenderingDrawTitle:
          dylib.lookupFunction<mxml_options_set_rendering_draw_title_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_title',
      ),
      getRenderingDrawTitle:
          dylib.lookupFunction<mxml_options_get_rendering_draw_title_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_title',
      ),
      setRenderingDrawPartNames:
          dylib.lookupFunction<mxml_options_set_rendering_draw_part_names_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_part_names',
      ),
      getRenderingDrawPartNames:
          dylib.lookupFunction<mxml_options_get_rendering_draw_part_names_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_part_names',
      ),
      setRenderingDrawMeasureNumbers:
          dylib.lookupFunction<mxml_options_set_rendering_draw_measure_numbers_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_measure_numbers',
      ),
      getRenderingDrawMeasureNumbers:
          dylib.lookupFunction<mxml_options_get_rendering_draw_measure_numbers_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_measure_numbers',
      ),
      setRenderingDrawMeasureNumbersOnlyAtSystemStart:
          dylib.lookupFunction<
          mxml_options_set_rendering_draw_measure_numbers_only_at_system_start_func,
          OptionsSetBool>('mxml_options_set_rendering_draw_measure_numbers_only_at_system_start'),
      getRenderingDrawMeasureNumbersOnlyAtSystemStart:
          dylib.lookupFunction<
          mxml_options_get_rendering_draw_measure_numbers_only_at_system_start_func,
          OptionsGetBool>('mxml_options_get_rendering_draw_measure_numbers_only_at_system_start'),
      setRenderingDrawMeasureNumbersBegin:
          dylib.lookupFunction<mxml_options_set_rendering_draw_measure_numbers_begin_func, OptionsSetInt>(
        'mxml_options_set_rendering_draw_measure_numbers_begin',
      ),
      getRenderingDrawMeasureNumbersBegin:
          dylib.lookupFunction<mxml_options_get_rendering_draw_measure_numbers_begin_func, OptionsGetInt>(
        'mxml_options_get_rendering_draw_measure_numbers_begin',
      ),
      setRenderingMeasureNumberInterval:
          dylib.lookupFunction<mxml_options_set_rendering_measure_number_interval_func, OptionsSetInt>(
        'mxml_options_set_rendering_measure_number_interval',
      ),
      getRenderingMeasureNumberInterval:
          dylib.lookupFunction<mxml_options_get_rendering_measure_number_interval_func, OptionsGetInt>(
        'mxml_options_get_rendering_measure_number_interval',
      ),
      setRenderingDrawTimeSignatures:
          dylib.lookupFunction<mxml_options_set_rendering_draw_time_signatures_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_time_signatures',
      ),
      getRenderingDrawTimeSignatures:
          dylib.lookupFunction<mxml_options_get_rendering_draw_time_signatures_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_time_signatures',
      ),
      setRenderingDrawKeySignatures:
          dylib.lookupFunction<mxml_options_set_rendering_draw_key_signatures_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_key_signatures',
      ),
      getRenderingDrawKeySignatures:
          dylib.lookupFunction<mxml_options_get_rendering_draw_key_signatures_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_key_signatures',
      ),
      setRenderingDrawFingerings:
          dylib.lookupFunction<mxml_options_set_rendering_draw_fingerings_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_fingerings',
      ),
      getRenderingDrawFingerings:
          dylib.lookupFunction<mxml_options_get_rendering_draw_fingerings_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_fingerings',
      ),
      setRenderingDrawSlurs:
          dylib.lookupFunction<mxml_options_set_rendering_draw_slurs_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_slurs',
      ),
      getRenderingDrawSlurs:
          dylib.lookupFunction<mxml_options_get_rendering_draw_slurs_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_slurs',
      ),
      setRenderingDrawPedals:
          dylib.lookupFunction<mxml_options_set_rendering_draw_pedals_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_pedals',
      ),
      getRenderingDrawPedals:
          dylib.lookupFunction<mxml_options_get_rendering_draw_pedals_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_pedals',
      ),
      setRenderingDrawDynamics:
          dylib.lookupFunction<mxml_options_set_rendering_draw_dynamics_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_dynamics',
      ),
      getRenderingDrawDynamics:
          dylib.lookupFunction<mxml_options_get_rendering_draw_dynamics_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_dynamics',
      ),
      setRenderingDrawWedges:
          dylib.lookupFunction<mxml_options_set_rendering_draw_wedges_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_wedges',
      ),
      getRenderingDrawWedges:
          dylib.lookupFunction<mxml_options_get_rendering_draw_wedges_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_wedges',
      ),
      setRenderingDrawLyrics:
          dylib.lookupFunction<mxml_options_set_rendering_draw_lyrics_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_lyrics',
      ),
      getRenderingDrawLyrics:
          dylib.lookupFunction<mxml_options_get_rendering_draw_lyrics_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_lyrics',
      ),
      setRenderingDrawCredits:
          dylib.lookupFunction<mxml_options_set_rendering_draw_credits_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_credits',
      ),
      getRenderingDrawCredits:
          dylib.lookupFunction<mxml_options_get_rendering_draw_credits_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_credits',
      ),
      setRenderingDrawComposer:
          dylib.lookupFunction<mxml_options_set_rendering_draw_composer_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_composer',
      ),
      getRenderingDrawComposer:
          dylib.lookupFunction<mxml_options_get_rendering_draw_composer_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_composer',
      ),
      setRenderingDrawLyricist:
          dylib.lookupFunction<mxml_options_set_rendering_draw_lyricist_func, OptionsSetBool>(
        'mxml_options_set_rendering_draw_lyricist',
      ),
      getRenderingDrawLyricist:
          dylib.lookupFunction<mxml_options_get_rendering_draw_lyricist_func, OptionsGetBool>(
        'mxml_options_get_rendering_draw_lyricist',
      ),
      setLayoutPageFormat:
          dylib.lookupFunction<mxml_options_set_layout_page_format_func, OptionsSetString>(
        'mxml_options_set_layout_page_format',
      ),
      getLayoutPageFormat:
          dylib.lookupFunction<mxml_options_get_layout_page_format_func, OptionsGetString>(
        'mxml_options_get_layout_page_format',
      ),
      setLayoutUseFixedCanvas:
          dylib.lookupFunction<mxml_options_set_layout_use_fixed_canvas_func, OptionsSetBool>(
        'mxml_options_set_layout_use_fixed_canvas',
      ),
      getLayoutUseFixedCanvas:
          dylib.lookupFunction<mxml_options_get_layout_use_fixed_canvas_func, OptionsGetBool>(
        'mxml_options_get_layout_use_fixed_canvas',
      ),
      setLayoutFixedCanvasWidth:
          dylib.lookupFunction<mxml_options_set_layout_fixed_canvas_width_func, OptionsSetDouble>(
        'mxml_options_set_layout_fixed_canvas_width',
      ),
      getLayoutFixedCanvasWidth:
          dylib.lookupFunction<mxml_options_get_layout_fixed_canvas_width_func, OptionsGetDouble>(
        'mxml_options_get_layout_fixed_canvas_width',
      ),
      setLayoutFixedCanvasHeight:
          dylib.lookupFunction<mxml_options_set_layout_fixed_canvas_height_func, OptionsSetDouble>(
        'mxml_options_set_layout_fixed_canvas_height',
      ),
      getLayoutFixedCanvasHeight:
          dylib.lookupFunction<mxml_options_get_layout_fixed_canvas_height_func, OptionsGetDouble>(
        'mxml_options_get_layout_fixed_canvas_height',
      ),
      setLayoutPageHeight:
          dylib.lookupFunction<mxml_options_set_layout_page_height_func, OptionsSetDouble>(
        'mxml_options_set_layout_page_height',
      ),
      getLayoutPageHeight:
          dylib.lookupFunction<mxml_options_get_layout_page_height_func, OptionsGetDouble>(
        'mxml_options_get_layout_page_height',
      ),
      setLayoutPageMarginLeftStaffSpaces:
          dylib.lookupFunction<mxml_options_set_layout_page_margin_left_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_layout_page_margin_left_staff_spaces',
      ),
      getLayoutPageMarginLeftStaffSpaces:
          dylib.lookupFunction<mxml_options_get_layout_page_margin_left_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_layout_page_margin_left_staff_spaces',
      ),
      setLayoutPageMarginRightStaffSpaces:
          dylib.lookupFunction<
          mxml_options_set_layout_page_margin_right_staff_spaces_func,
          OptionsSetDouble>('mxml_options_set_layout_page_margin_right_staff_spaces'),
      getLayoutPageMarginRightStaffSpaces:
          dylib.lookupFunction<
          mxml_options_get_layout_page_margin_right_staff_spaces_func,
          OptionsGetDouble>('mxml_options_get_layout_page_margin_right_staff_spaces'),
      setLayoutPageMarginTopStaffSpaces:
          dylib.lookupFunction<
          mxml_options_set_layout_page_margin_top_staff_spaces_func,
          OptionsSetDouble>('mxml_options_set_layout_page_margin_top_staff_spaces'),
      getLayoutPageMarginTopStaffSpaces:
          dylib.lookupFunction<
          mxml_options_get_layout_page_margin_top_staff_spaces_func,
          OptionsGetDouble>('mxml_options_get_layout_page_margin_top_staff_spaces'),
      setLayoutPageMarginBottomStaffSpaces:
          dylib.lookupFunction<
          mxml_options_set_layout_page_margin_bottom_staff_spaces_func,
          OptionsSetDouble>('mxml_options_set_layout_page_margin_bottom_staff_spaces'),
      getLayoutPageMarginBottomStaffSpaces:
          dylib.lookupFunction<
          mxml_options_get_layout_page_margin_bottom_staff_spaces_func,
          OptionsGetDouble>('mxml_options_get_layout_page_margin_bottom_staff_spaces'),
      setLayoutSystemSpacingMinStaffSpaces:
          dylib.lookupFunction<
          mxml_options_set_layout_system_spacing_min_staff_spaces_func,
          OptionsSetDouble>('mxml_options_set_layout_system_spacing_min_staff_spaces'),
      getLayoutSystemSpacingMinStaffSpaces:
          dylib.lookupFunction<
          mxml_options_get_layout_system_spacing_min_staff_spaces_func,
          OptionsGetDouble>('mxml_options_get_layout_system_spacing_min_staff_spaces'),
      setLayoutSystemSpacingMultiStaffMinStaffSpaces:
          dylib.lookupFunction<
          mxml_options_set_layout_system_spacing_multi_staff_min_staff_spaces_func,
          OptionsSetDouble>('mxml_options_set_layout_system_spacing_multi_staff_min_staff_spaces'),
      getLayoutSystemSpacingMultiStaffMinStaffSpaces:
          dylib.lookupFunction<
          mxml_options_get_layout_system_spacing_multi_staff_min_staff_spaces_func,
          OptionsGetDouble>('mxml_options_get_layout_system_spacing_multi_staff_min_staff_spaces'),
      setLayoutNewSystemFromXml:
          dylib.lookupFunction<mxml_options_set_layout_new_system_from_xml_func, OptionsSetBool>(
        'mxml_options_set_layout_new_system_from_xml',
      ),
      getLayoutNewSystemFromXml:
          dylib.lookupFunction<mxml_options_get_layout_new_system_from_xml_func, OptionsGetBool>(
        'mxml_options_get_layout_new_system_from_xml',
      ),
      setLayoutNewPageFromXml:
          dylib.lookupFunction<mxml_options_set_layout_new_page_from_xml_func, OptionsSetBool>(
        'mxml_options_set_layout_new_page_from_xml',
      ),
      getLayoutNewPageFromXml:
          dylib.lookupFunction<mxml_options_get_layout_new_page_from_xml_func, OptionsGetBool>(
        'mxml_options_get_layout_new_page_from_xml',
      ),
      setLayoutFillEmptyMeasuresWithWholeRest:
          dylib.lookupFunction<
          mxml_options_set_layout_fill_empty_measures_with_whole_rest_func,
          OptionsSetBool>('mxml_options_set_layout_fill_empty_measures_with_whole_rest'),
      getLayoutFillEmptyMeasuresWithWholeRest:
          dylib.lookupFunction<
          mxml_options_get_layout_fill_empty_measures_with_whole_rest_func,
          OptionsGetBool>('mxml_options_get_layout_fill_empty_measures_with_whole_rest'),
      setLineBreakingJustificationRatioMin:
          dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_min_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_justification_ratio_min',
      ),
      getLineBreakingJustificationRatioMin:
          dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_min_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_justification_ratio_min',
      ),
      setLineBreakingJustificationRatioMax:
          dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_max_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_justification_ratio_max',
      ),
      getLineBreakingJustificationRatioMax:
          dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_max_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_justification_ratio_max',
      ),
      setLineBreakingJustificationRatioTarget:
          dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_target_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_justification_ratio_target',
      ),
      getLineBreakingJustificationRatioTarget:
          dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_target_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_justification_ratio_target',
      ),
      setLineBreakingJustificationRatioSoftMin:
          dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_soft_min_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_justification_ratio_soft_min',
      ),
      getLineBreakingJustificationRatioSoftMin:
          dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_soft_min_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_justification_ratio_soft_min',
      ),
      setLineBreakingJustificationRatioSoftMax:
          dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_soft_max_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_justification_ratio_soft_max',
      ),
      getLineBreakingJustificationRatioSoftMax:
          dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_soft_max_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_justification_ratio_soft_max',
      ),
      setLineBreakingWeightRatio:
          dylib.lookupFunction<mxml_options_set_line_breaking_weight_ratio_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_weight_ratio',
      ),
      getLineBreakingWeightRatio:
          dylib.lookupFunction<mxml_options_get_line_breaking_weight_ratio_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_weight_ratio',
      ),
      setLineBreakingWeightTight:
          dylib.lookupFunction<mxml_options_set_line_breaking_weight_tight_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_weight_tight',
      ),
      getLineBreakingWeightTight:
          dylib.lookupFunction<mxml_options_get_line_breaking_weight_tight_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_weight_tight',
      ),
      setLineBreakingWeightLoose:
          dylib.lookupFunction<mxml_options_set_line_breaking_weight_loose_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_weight_loose',
      ),
      getLineBreakingWeightLoose:
          dylib.lookupFunction<mxml_options_get_line_breaking_weight_loose_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_weight_loose',
      ),
      setLineBreakingWeightLastUnder:
          dylib.lookupFunction<mxml_options_set_line_breaking_weight_last_under_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_weight_last_under',
      ),
      getLineBreakingWeightLastUnder:
          dylib.lookupFunction<mxml_options_get_line_breaking_weight_last_under_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_weight_last_under',
      ),
      setLineBreakingCostPower:
          dylib.lookupFunction<mxml_options_set_line_breaking_cost_power_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_cost_power',
      ),
      getLineBreakingCostPower:
          dylib.lookupFunction<mxml_options_get_line_breaking_cost_power_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_cost_power',
      ),
      setLineBreakingStretchLastSystem:
          dylib.lookupFunction<mxml_options_set_line_breaking_stretch_last_system_func, OptionsSetBool>(
        'mxml_options_set_line_breaking_stretch_last_system',
      ),
      getLineBreakingStretchLastSystem:
          dylib.lookupFunction<mxml_options_get_line_breaking_stretch_last_system_func, OptionsGetBool>(
        'mxml_options_get_line_breaking_stretch_last_system',
      ),
      setLineBreakingLastLineMaxUnderfill:
          dylib.lookupFunction<mxml_options_set_line_breaking_last_line_max_underfill_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_last_line_max_underfill',
      ),
      getLineBreakingLastLineMaxUnderfill:
          dylib.lookupFunction<mxml_options_get_line_breaking_last_line_max_underfill_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_last_line_max_underfill',
      ),
      setLineBreakingTargetMeasuresPerSystem:
          dylib.lookupFunction<mxml_options_set_line_breaking_target_measures_per_system_func, OptionsSetInt>(
        'mxml_options_set_line_breaking_target_measures_per_system',
      ),
      getLineBreakingTargetMeasuresPerSystem:
          dylib.lookupFunction<mxml_options_get_line_breaking_target_measures_per_system_func, OptionsGetInt>(
        'mxml_options_get_line_breaking_target_measures_per_system',
      ),
      setLineBreakingWeightCount:
          dylib.lookupFunction<mxml_options_set_line_breaking_weight_count_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_weight_count',
      ),
      getLineBreakingWeightCount:
          dylib.lookupFunction<mxml_options_get_line_breaking_weight_count_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_weight_count',
      ),
      setLineBreakingBonusFinalBar:
          dylib.lookupFunction<mxml_options_set_line_breaking_bonus_final_bar_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_bonus_final_bar',
      ),
      getLineBreakingBonusFinalBar:
          dylib.lookupFunction<mxml_options_get_line_breaking_bonus_final_bar_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_bonus_final_bar',
      ),
      setLineBreakingBonusDoubleBar:
          dylib.lookupFunction<mxml_options_set_line_breaking_bonus_double_bar_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_bonus_double_bar',
      ),
      getLineBreakingBonusDoubleBar:
          dylib.lookupFunction<mxml_options_get_line_breaking_bonus_double_bar_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_bonus_double_bar',
      ),
      setLineBreakingBonusPhrasEnd:
          dylib.lookupFunction<mxml_options_set_line_breaking_bonus_phras_end_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_bonus_phras_end',
      ),
      getLineBreakingBonusPhrasEnd:
          dylib.lookupFunction<mxml_options_get_line_breaking_bonus_phras_end_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_bonus_phras_end',
      ),
      setLineBreakingBonusRehearsalMark:
          dylib.lookupFunction<mxml_options_set_line_breaking_bonus_rehearsal_mark_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_bonus_rehearsal_mark',
      ),
      getLineBreakingBonusRehearsalMark:
          dylib.lookupFunction<mxml_options_get_line_breaking_bonus_rehearsal_mark_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_bonus_rehearsal_mark',
      ),
      setLineBreakingPenaltyHairpinAcross:
          dylib.lookupFunction<mxml_options_set_line_breaking_penalty_hairpin_across_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_penalty_hairpin_across',
      ),
      getLineBreakingPenaltyHairpinAcross:
          dylib.lookupFunction<mxml_options_get_line_breaking_penalty_hairpin_across_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_penalty_hairpin_across',
      ),
      setLineBreakingPenaltySlurAcross:
          dylib.lookupFunction<mxml_options_set_line_breaking_penalty_slur_across_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_penalty_slur_across',
      ),
      getLineBreakingPenaltySlurAcross:
          dylib.lookupFunction<mxml_options_get_line_breaking_penalty_slur_across_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_penalty_slur_across',
      ),
      setLineBreakingPenaltyLyricsHyphen:
          dylib.lookupFunction<mxml_options_set_line_breaking_penalty_lyrics_hyphen_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_penalty_lyrics_hyphen',
      ),
      getLineBreakingPenaltyLyricsHyphen:
          dylib.lookupFunction<mxml_options_get_line_breaking_penalty_lyrics_hyphen_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_penalty_lyrics_hyphen',
      ),
      setLineBreakingPenaltyTieAcross:
          dylib.lookupFunction<mxml_options_set_line_breaking_penalty_tie_across_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_penalty_tie_across',
      ),
      getLineBreakingPenaltyTieAcross:
          dylib.lookupFunction<mxml_options_get_line_breaking_penalty_tie_across_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_penalty_tie_across',
      ),
      setLineBreakingPenaltyClefChange:
          dylib.lookupFunction<mxml_options_set_line_breaking_penalty_clef_change_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_penalty_clef_change',
      ),
      getLineBreakingPenaltyClefChange:
          dylib.lookupFunction<mxml_options_get_line_breaking_penalty_clef_change_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_penalty_clef_change',
      ),
      setLineBreakingPenaltyKeyTimeChange:
          dylib.lookupFunction<mxml_options_set_line_breaking_penalty_key_time_change_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_penalty_key_time_change',
      ),
      getLineBreakingPenaltyKeyTimeChange:
          dylib.lookupFunction<mxml_options_get_line_breaking_penalty_key_time_change_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_penalty_key_time_change',
      ),
      setLineBreakingPenaltyTempoText:
          dylib.lookupFunction<mxml_options_set_line_breaking_penalty_tempo_text_func, OptionsSetDouble>(
        'mxml_options_set_line_breaking_penalty_tempo_text',
      ),
      getLineBreakingPenaltyTempoText:
          dylib.lookupFunction<mxml_options_get_line_breaking_penalty_tempo_text_func, OptionsGetDouble>(
        'mxml_options_get_line_breaking_penalty_tempo_text',
      ),
      setLineBreakingEnableTwoPassOptimization:
          dylib.lookupFunction<mxml_options_set_line_breaking_enable_two_pass_optimization_func, OptionsSetBool>(
        'mxml_options_set_line_breaking_enable_two_pass_optimization',
      ),
      getLineBreakingEnableTwoPassOptimization:
          dylib.lookupFunction<mxml_options_get_line_breaking_enable_two_pass_optimization_func, OptionsGetBool>(
        'mxml_options_get_line_breaking_enable_two_pass_optimization',
      ),
      setLineBreakingEnableBreakFeatures:
          dylib.lookupFunction<mxml_options_set_line_breaking_enable_break_features_func, OptionsSetBool>(
        'mxml_options_set_line_breaking_enable_break_features',
      ),
      getLineBreakingEnableBreakFeatures:
          dylib.lookupFunction<mxml_options_get_line_breaking_enable_break_features_func, OptionsGetBool>(
        'mxml_options_get_line_breaking_enable_break_features',
      ),
      setLineBreakingEnableSystemLevelSpacing:
          dylib.lookupFunction<mxml_options_set_line_breaking_enable_system_level_spacing_func, OptionsSetBool>(
        'mxml_options_set_line_breaking_enable_system_level_spacing',
      ),
      getLineBreakingEnableSystemLevelSpacing:
          dylib.lookupFunction<mxml_options_get_line_breaking_enable_system_level_spacing_func, OptionsGetBool>(
        'mxml_options_get_line_breaking_enable_system_level_spacing',
      ),
      setLineBreakingMaxMeasuresPerLine:
          dylib.lookupFunction<mxml_options_set_line_breaking_max_measures_per_line_func, OptionsSetInt>(
        'mxml_options_set_line_breaking_max_measures_per_line',
      ),
      getLineBreakingMaxMeasuresPerLine:
          dylib.lookupFunction<mxml_options_get_line_breaking_max_measures_per_line_func, OptionsGetInt>(
        'mxml_options_get_line_breaking_max_measures_per_line',
      ),
      setNotationAutoBeam:
          dylib.lookupFunction<mxml_options_set_notation_auto_beam_func, OptionsSetBool>(
        'mxml_options_set_notation_auto_beam',
      ),
      getNotationAutoBeam:
          dylib.lookupFunction<mxml_options_get_notation_auto_beam_func, OptionsGetBool>(
        'mxml_options_get_notation_auto_beam',
      ),
      setNotationTupletsBracketed:
          dylib.lookupFunction<mxml_options_set_notation_tuplets_bracketed_func, OptionsSetBool>(
        'mxml_options_set_notation_tuplets_bracketed',
      ),
      getNotationTupletsBracketed:
          dylib.lookupFunction<mxml_options_get_notation_tuplets_bracketed_func, OptionsGetBool>(
        'mxml_options_get_notation_tuplets_bracketed',
      ),
      setNotationTripletsBracketed:
          dylib.lookupFunction<mxml_options_set_notation_triplets_bracketed_func, OptionsSetBool>(
        'mxml_options_set_notation_triplets_bracketed',
      ),
      getNotationTripletsBracketed:
          dylib.lookupFunction<mxml_options_get_notation_triplets_bracketed_func, OptionsGetBool>(
        'mxml_options_get_notation_triplets_bracketed',
      ),
      setNotationTupletsRatioed:
          dylib.lookupFunction<mxml_options_set_notation_tuplets_ratioed_func, OptionsSetBool>(
        'mxml_options_set_notation_tuplets_ratioed',
      ),
      getNotationTupletsRatioed:
          dylib.lookupFunction<mxml_options_get_notation_tuplets_ratioed_func, OptionsGetBool>(
        'mxml_options_get_notation_tuplets_ratioed',
      ),
      setNotationAlignRests:
          dylib.lookupFunction<mxml_options_set_notation_align_rests_func, OptionsSetBool>(
        'mxml_options_set_notation_align_rests',
      ),
      getNotationAlignRests:
          dylib.lookupFunction<mxml_options_get_notation_align_rests_func, OptionsGetBool>(
        'mxml_options_get_notation_align_rests',
      ),
      setNotationSetWantedStemDirectionByXml:
          dylib.lookupFunction<mxml_options_set_notation_set_wanted_stem_direction_by_xml_func, OptionsSetBool>(
        'mxml_options_set_notation_set_wanted_stem_direction_by_xml',
      ),
      getNotationSetWantedStemDirectionByXml:
          dylib.lookupFunction<mxml_options_get_notation_set_wanted_stem_direction_by_xml_func, OptionsGetBool>(
        'mxml_options_get_notation_set_wanted_stem_direction_by_xml',
      ),
      setNotationSlurLiftSampleCount:
          dylib.lookupFunction<mxml_options_set_notation_slur_lift_sample_count_func, OptionsSetInt>(
        'mxml_options_set_notation_slur_lift_sample_count',
      ),
      getNotationSlurLiftSampleCount:
          dylib.lookupFunction<mxml_options_get_notation_slur_lift_sample_count_func, OptionsGetInt>(
        'mxml_options_get_notation_slur_lift_sample_count',
      ),
      setNotationFingeringPosition:
          dylib.lookupFunction<mxml_options_set_notation_fingering_position_func, OptionsSetString>(
        'mxml_options_set_notation_fingering_position',
      ),
      getNotationFingeringPosition:
          dylib.lookupFunction<mxml_options_get_notation_fingering_position_func, OptionsGetString>(
        'mxml_options_get_notation_fingering_position',
      ),
      setNotationFingeringInsideStafflines:
          dylib.lookupFunction<mxml_options_set_notation_fingering_inside_stafflines_func, OptionsSetBool>(
        'mxml_options_set_notation_fingering_inside_stafflines',
      ),
      getNotationFingeringInsideStafflines:
          dylib.lookupFunction<mxml_options_get_notation_fingering_inside_stafflines_func, OptionsGetBool>(
        'mxml_options_get_notation_fingering_inside_stafflines',
      ),
      setNotationFingeringYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_fingering_y_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_fingering_y_offset_staff_spaces',
      ),
      getNotationFingeringYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_fingering_y_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_fingering_y_offset_staff_spaces',
      ),
      setNotationFingeringFontSize:
          dylib.lookupFunction<mxml_options_set_notation_fingering_font_size_func, OptionsSetDouble>(
        'mxml_options_set_notation_fingering_font_size',
      ),
      getNotationFingeringFontSize:
          dylib.lookupFunction<mxml_options_get_notation_fingering_font_size_func, OptionsGetDouble>(
        'mxml_options_get_notation_fingering_font_size',
      ),
      setNotationPedalYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_pedal_y_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_pedal_y_offset_staff_spaces',
      ),
      getNotationPedalYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_pedal_y_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_pedal_y_offset_staff_spaces',
      ),
      setNotationPedalLineThicknessStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_pedal_line_thickness_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_pedal_line_thickness_staff_spaces',
      ),
      getNotationPedalLineThicknessStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_pedal_line_thickness_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_pedal_line_thickness_staff_spaces',
      ),
      setNotationPedalTextFontSize:
          dylib.lookupFunction<mxml_options_set_notation_pedal_text_font_size_func, OptionsSetDouble>(
        'mxml_options_set_notation_pedal_text_font_size',
      ),
      getNotationPedalTextFontSize:
          dylib.lookupFunction<mxml_options_get_notation_pedal_text_font_size_func, OptionsGetDouble>(
        'mxml_options_get_notation_pedal_text_font_size',
      ),
      setNotationPedalTextToLineStartStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_pedal_text_to_line_start_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_pedal_text_to_line_start_staff_spaces',
      ),
      getNotationPedalTextToLineStartStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_pedal_text_to_line_start_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_pedal_text_to_line_start_staff_spaces',
      ),
      setNotationPedalLineToEndSymbolGapStaffSpaces:
          dylib.lookupFunction<
          mxml_options_set_notation_pedal_line_to_end_symbol_gap_staff_spaces_func,
          OptionsSetDouble>('mxml_options_set_notation_pedal_line_to_end_symbol_gap_staff_spaces'),
      getNotationPedalLineToEndSymbolGapStaffSpaces:
          dylib.lookupFunction<
          mxml_options_get_notation_pedal_line_to_end_symbol_gap_staff_spaces_func,
          OptionsGetDouble>('mxml_options_get_notation_pedal_line_to_end_symbol_gap_staff_spaces'),
      setNotationPedalChangeNotchHeightStaffSpaces:
          dylib.lookupFunction<
          mxml_options_set_notation_pedal_change_notch_height_staff_spaces_func,
          OptionsSetDouble>('mxml_options_set_notation_pedal_change_notch_height_staff_spaces'),
      getNotationPedalChangeNotchHeightStaffSpaces:
          dylib.lookupFunction<
          mxml_options_get_notation_pedal_change_notch_height_staff_spaces_func,
          OptionsGetDouble>('mxml_options_get_notation_pedal_change_notch_height_staff_spaces'),
      setNotationDynamicsYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_dynamics_y_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_dynamics_y_offset_staff_spaces',
      ),
      getNotationDynamicsYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_dynamics_y_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_dynamics_y_offset_staff_spaces',
      ),
      setNotationDynamicsFontSize:
          dylib.lookupFunction<mxml_options_set_notation_dynamics_font_size_func, OptionsSetDouble>(
        'mxml_options_set_notation_dynamics_font_size',
      ),
      getNotationDynamicsFontSize:
          dylib.lookupFunction<mxml_options_get_notation_dynamics_font_size_func, OptionsGetDouble>(
        'mxml_options_get_notation_dynamics_font_size',
      ),
      setNotationWedgeYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_wedge_y_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_wedge_y_offset_staff_spaces',
      ),
      getNotationWedgeYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_wedge_y_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_wedge_y_offset_staff_spaces',
      ),
      setNotationWedgeHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_wedge_height_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_wedge_height_staff_spaces',
      ),
      getNotationWedgeHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_wedge_height_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_wedge_height_staff_spaces',
      ),
      setNotationWedgeLineThicknessStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_wedge_line_thickness_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_wedge_line_thickness_staff_spaces',
      ),
      getNotationWedgeLineThicknessStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_wedge_line_thickness_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_wedge_line_thickness_staff_spaces',
      ),
      setNotationWedgeInsetFromEndsStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_wedge_inset_from_ends_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_wedge_inset_from_ends_staff_spaces',
      ),
      getNotationWedgeInsetFromEndsStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_wedge_inset_from_ends_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_wedge_inset_from_ends_staff_spaces',
      ),
      setNotationLyricsYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_lyrics_y_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_lyrics_y_offset_staff_spaces',
      ),
      getNotationLyricsYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_lyrics_y_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_lyrics_y_offset_staff_spaces',
      ),
      setNotationLyricsFontSize:
          dylib.lookupFunction<mxml_options_set_notation_lyrics_font_size_func, OptionsSetDouble>(
        'mxml_options_set_notation_lyrics_font_size',
      ),
      getNotationLyricsFontSize:
          dylib.lookupFunction<mxml_options_get_notation_lyrics_font_size_func, OptionsGetDouble>(
        'mxml_options_get_notation_lyrics_font_size',
      ),
      setNotationLyricsHyphenMinGapStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_lyrics_hyphen_min_gap_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_lyrics_hyphen_min_gap_staff_spaces',
      ),
      getNotationLyricsHyphenMinGapStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_lyrics_hyphen_min_gap_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_lyrics_hyphen_min_gap_staff_spaces',
      ),
      setNotationArticulationOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_articulation_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_articulation_offset_staff_spaces',
      ),
      getNotationArticulationOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_articulation_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_articulation_offset_staff_spaces',
      ),
      setNotationArticulationStackGapStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_articulation_stack_gap_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_articulation_stack_gap_staff_spaces',
      ),
      getNotationArticulationStackGapStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_articulation_stack_gap_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_articulation_stack_gap_staff_spaces',
      ),
      setNotationArticulationLineThicknessStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_articulation_line_thickness_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_articulation_line_thickness_staff_spaces',
      ),
      getNotationArticulationLineThicknessStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_articulation_line_thickness_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_articulation_line_thickness_staff_spaces',
      ),
      setNotationTenutoLengthStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_tenuto_length_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_tenuto_length_staff_spaces',
      ),
      getNotationTenutoLengthStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_tenuto_length_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_tenuto_length_staff_spaces',
      ),
      setNotationAccentWidthStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_accent_width_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_accent_width_staff_spaces',
      ),
      getNotationAccentWidthStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_accent_width_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_accent_width_staff_spaces',
      ),
      setNotationAccentHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_accent_height_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_accent_height_staff_spaces',
      ),
      getNotationAccentHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_accent_height_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_accent_height_staff_spaces',
      ),
      setNotationMarcatoWidthStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_marcato_width_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_marcato_width_staff_spaces',
      ),
      getNotationMarcatoWidthStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_marcato_width_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_marcato_width_staff_spaces',
      ),
      setNotationMarcatoHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_marcato_height_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_marcato_height_staff_spaces',
      ),
      getNotationMarcatoHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_marcato_height_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_marcato_height_staff_spaces',
      ),
      setNotationStaccatoDotScale:
          dylib.lookupFunction<mxml_options_set_notation_staccato_dot_scale_func, OptionsSetDouble>(
        'mxml_options_set_notation_staccato_dot_scale',
      ),
      getNotationStaccatoDotScale:
          dylib.lookupFunction<mxml_options_get_notation_staccato_dot_scale_func, OptionsGetDouble>(
        'mxml_options_get_notation_staccato_dot_scale',
      ),
      setNotationFermataYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_fermata_y_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_fermata_y_offset_staff_spaces',
      ),
      getNotationFermataYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_fermata_y_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_fermata_y_offset_staff_spaces',
      ),
      setNotationFermataDotToArcStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_fermata_dot_to_arc_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_fermata_dot_to_arc_staff_spaces',
      ),
      getNotationFermataDotToArcStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_fermata_dot_to_arc_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_fermata_dot_to_arc_staff_spaces',
      ),
      setNotationFermataWidthStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_fermata_width_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_fermata_width_staff_spaces',
      ),
      getNotationFermataWidthStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_fermata_width_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_fermata_width_staff_spaces',
      ),
      setNotationFermataHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_fermata_height_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_fermata_height_staff_spaces',
      ),
      getNotationFermataHeightStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_fermata_height_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_fermata_height_staff_spaces',
      ),
      setNotationFermataThicknessStartStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_fermata_thickness_start_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_fermata_thickness_start_staff_spaces',
      ),
      getNotationFermataThicknessStartStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_fermata_thickness_start_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_fermata_thickness_start_staff_spaces',
      ),
      setNotationFermataThicknessMidStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_fermata_thickness_mid_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_fermata_thickness_mid_staff_spaces',
      ),
      getNotationFermataThicknessMidStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_fermata_thickness_mid_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_fermata_thickness_mid_staff_spaces',
      ),
      setNotationFermataDotScale:
          dylib.lookupFunction<mxml_options_set_notation_fermata_dot_scale_func, OptionsSetDouble>(
        'mxml_options_set_notation_fermata_dot_scale',
      ),
      getNotationFermataDotScale:
          dylib.lookupFunction<mxml_options_get_notation_fermata_dot_scale_func, OptionsGetDouble>(
        'mxml_options_get_notation_fermata_dot_scale',
      ),
      setNotationOrnamentYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_ornament_y_offset_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_ornament_y_offset_staff_spaces',
      ),
      getNotationOrnamentYOffsetStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_ornament_y_offset_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_ornament_y_offset_staff_spaces',
      ),
      setNotationOrnamentStackGapStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_ornament_stack_gap_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_ornament_stack_gap_staff_spaces',
      ),
      getNotationOrnamentStackGapStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_ornament_stack_gap_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_ornament_stack_gap_staff_spaces',
      ),
      setNotationOrnamentFontSize:
          dylib.lookupFunction<mxml_options_set_notation_ornament_font_size_func, OptionsSetDouble>(
        'mxml_options_set_notation_ornament_font_size',
      ),
      getNotationOrnamentFontSize:
          dylib.lookupFunction<mxml_options_get_notation_ornament_font_size_func, OptionsGetDouble>(
        'mxml_options_get_notation_ornament_font_size',
      ),
      setNotationStaffDistanceStaffSpaces:
          dylib.lookupFunction<mxml_options_set_notation_staff_distance_staff_spaces_func, OptionsSetDouble>(
        'mxml_options_set_notation_staff_distance_staff_spaces',
      ),
      getNotationStaffDistanceStaffSpaces:
          dylib.lookupFunction<mxml_options_get_notation_staff_distance_staff_spaces_func, OptionsGetDouble>(
        'mxml_options_get_notation_staff_distance_staff_spaces',
      ),
      setColorsDarkMode:
          dylib.lookupFunction<mxml_options_set_colors_dark_mode_func, OptionsSetBool>(
        'mxml_options_set_colors_dark_mode',
      ),
      getColorsDarkMode:
          dylib.lookupFunction<mxml_options_get_colors_dark_mode_func, OptionsGetBool>(
        'mxml_options_get_colors_dark_mode',
      ),
      setColorsDefaultColorMusic:
          dylib.lookupFunction<mxml_options_set_colors_default_color_music_func, OptionsSetString>(
        'mxml_options_set_colors_default_color_music',
      ),
      getColorsDefaultColorMusic:
          dylib.lookupFunction<mxml_options_get_colors_default_color_music_func, OptionsGetString>(
        'mxml_options_get_colors_default_color_music',
      ),
      setColorsDefaultColorNotehead:
          dylib.lookupFunction<mxml_options_set_colors_default_color_notehead_func, OptionsSetString>(
        'mxml_options_set_colors_default_color_notehead',
      ),
      getColorsDefaultColorNotehead:
          dylib.lookupFunction<mxml_options_get_colors_default_color_notehead_func, OptionsGetString>(
        'mxml_options_get_colors_default_color_notehead',
      ),
      setColorsDefaultColorStem:
          dylib.lookupFunction<mxml_options_set_colors_default_color_stem_func, OptionsSetString>(
        'mxml_options_set_colors_default_color_stem',
      ),
      getColorsDefaultColorStem:
          dylib.lookupFunction<mxml_options_get_colors_default_color_stem_func, OptionsGetString>(
        'mxml_options_get_colors_default_color_stem',
      ),
      setColorsDefaultColorRest:
          dylib.lookupFunction<mxml_options_set_colors_default_color_rest_func, OptionsSetString>(
        'mxml_options_set_colors_default_color_rest',
      ),
      getColorsDefaultColorRest:
          dylib.lookupFunction<mxml_options_get_colors_default_color_rest_func, OptionsGetString>(
        'mxml_options_get_colors_default_color_rest',
      ),
      setColorsDefaultColorLabel:
          dylib.lookupFunction<mxml_options_set_colors_default_color_label_func, OptionsSetString>(
        'mxml_options_set_colors_default_color_label',
      ),
      getColorsDefaultColorLabel:
          dylib.lookupFunction<mxml_options_get_colors_default_color_label_func, OptionsGetString>(
        'mxml_options_get_colors_default_color_label',
      ),
      setColorsDefaultColorTitle:
          dylib.lookupFunction<mxml_options_set_colors_default_color_title_func, OptionsSetString>(
        'mxml_options_set_colors_default_color_title',
      ),
      getColorsDefaultColorTitle:
          dylib.lookupFunction<mxml_options_get_colors_default_color_title_func, OptionsGetString>(
        'mxml_options_get_colors_default_color_title',
      ),
      setColorsColoringEnabled:
          dylib.lookupFunction<mxml_options_set_colors_coloring_enabled_func, OptionsSetBool>(
        'mxml_options_set_colors_coloring_enabled',
      ),
      getColorsColoringEnabled:
          dylib.lookupFunction<mxml_options_get_colors_coloring_enabled_func, OptionsGetBool>(
        'mxml_options_get_colors_coloring_enabled',
      ),
      setColorsColoringMode:
          dylib.lookupFunction<mxml_options_set_colors_coloring_mode_func, OptionsSetString>(
        'mxml_options_set_colors_coloring_mode',
      ),
      getColorsColoringMode:
          dylib.lookupFunction<mxml_options_get_colors_coloring_mode_func, OptionsGetString>(
        'mxml_options_get_colors_coloring_mode',
      ),
      setColorsColorStemsLikeNoteheads:
          dylib.lookupFunction<mxml_options_set_colors_color_stems_like_noteheads_func, OptionsSetBool>(
        'mxml_options_set_colors_color_stems_like_noteheads',
      ),
      getColorsColorStemsLikeNoteheads:
          dylib.lookupFunction<mxml_options_get_colors_color_stems_like_noteheads_func, OptionsGetBool>(
        'mxml_options_get_colors_color_stems_like_noteheads',
      ),
      setColorsColoringSetCustom:
          dylib.lookupFunction<mxml_options_set_colors_coloring_set_custom_func, OptionsSetStringList>(
        'mxml_options_set_colors_coloring_set_custom',
      ),
      getColorsColoringSetCustomCount:
          dylib.lookupFunction<mxml_options_get_colors_coloring_set_custom_count_func, OptionsGetStringListCount>(
        'mxml_options_get_colors_coloring_set_custom_count',
      ),
      getColorsColoringSetCustomAt:
          dylib.lookupFunction<mxml_options_get_colors_coloring_set_custom_at_func, OptionsGetStringListAt>(
        'mxml_options_get_colors_coloring_set_custom_at',
      ),
      setPerformanceEnableGlyphCache:
          dylib.lookupFunction<mxml_options_set_performance_enable_glyph_cache_func, OptionsSetBool>(
        'mxml_options_set_performance_enable_glyph_cache',
      ),
      getPerformanceEnableGlyphCache:
          dylib.lookupFunction<mxml_options_get_performance_enable_glyph_cache_func, OptionsGetBool>(
        'mxml_options_get_performance_enable_glyph_cache',
      ),
      setPerformanceEnableSpatialIndexing:
          dylib.lookupFunction<mxml_options_set_performance_enable_spatial_indexing_func, OptionsSetBool>(
        'mxml_options_set_performance_enable_spatial_indexing',
      ),
      getPerformanceEnableSpatialIndexing:
          dylib.lookupFunction<mxml_options_get_performance_enable_spatial_indexing_func, OptionsGetBool>(
        'mxml_options_get_performance_enable_spatial_indexing',
      ),
      setPerformanceSkyBottomLineBatchMinMeasures:
          dylib.lookupFunction<mxml_options_set_performance_sky_bottom_line_batch_min_measures_func, OptionsSetInt>(
        'mxml_options_set_performance_sky_bottom_line_batch_min_measures',
      ),
      getPerformanceSkyBottomLineBatchMinMeasures:
          dylib.lookupFunction<mxml_options_get_performance_sky_bottom_line_batch_min_measures_func, OptionsGetInt>(
        'mxml_options_get_performance_sky_bottom_line_batch_min_measures',
      ),
      setPerformanceSvgPrecision:
          dylib.lookupFunction<mxml_options_set_performance_svg_precision_func, OptionsSetInt>(
        'mxml_options_set_performance_svg_precision',
      ),
      getPerformanceSvgPrecision:
          dylib.lookupFunction<mxml_options_get_performance_svg_precision_func, OptionsGetInt>(
        'mxml_options_get_performance_svg_precision',
      ),
      setPerformanceBenchEnable:
          dylib.lookupFunction<mxml_options_set_performance_bench_enable_func, OptionsSetBool>(
        'mxml_options_set_performance_bench_enable',
      ),
      getPerformanceBenchEnable:
          dylib.lookupFunction<mxml_options_get_performance_bench_enable_func, OptionsGetBool>(
        'mxml_options_get_performance_bench_enable',
      ),
      setBackend:
          dylib.lookupFunction<mxml_options_set_backend_func, OptionsSetString>('mxml_options_set_backend'),
      getBackend:
          dylib.lookupFunction<mxml_options_get_backend_func, OptionsGetString>('mxml_options_get_backend'),
      setZoom: dylib.lookupFunction<mxml_options_set_zoom_func, OptionsSetDouble>('mxml_options_set_zoom'),
      getZoom: dylib.lookupFunction<mxml_options_get_zoom_func, OptionsGetDouble>('mxml_options_get_zoom'),
      setSheetMaximumWidth:
          dylib.lookupFunction<mxml_options_set_sheet_maximum_width_func, OptionsSetDouble>(
        'mxml_options_set_sheet_maximum_width',
      ),
      getSheetMaximumWidth:
          dylib.lookupFunction<mxml_options_get_sheet_maximum_width_func, OptionsGetDouble>(
        'mxml_options_get_sheet_maximum_width',
      ),
    );
  }

  // Selectionne le binaire en fonction de la plateforme.
  static DynamicLibrary _openDynamicLibrary() {
    // Choix du binaire selon la plateforme courante.
    if (Platform.isLinux) {
      return DynamicLibrary.open('libmxmlconverter.so');
    } else if (Platform.isAndroid) {
      return DynamicLibrary.open('libmxmlconverter.so');
    } else if (Platform.isMacOS || Platform.isIOS) {
      return DynamicLibrary.open('libmxmlconverter.dylib');
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('mxmlconverter.dll');
    }
    // Fallback pour les plateformes non supportees.
    throw UnsupportedError('Platform not supported');
  }
}
