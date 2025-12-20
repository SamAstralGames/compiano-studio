# mXMLOptions reference

This document lists the current options, grouped by pipeline stage and function.

## Units: staff space (SS)

A staff space (SS) is the distance between two adjacent staff lines. In the
engine, `1 SS = kStaffLineSpacing * 0.5` before zoom is applied. All layout
spacing options use SS. Canvas and page sizes stay in pixels (px) because they
define the output size.

## Pipeline: Global / Backend

- `backend` (string, default `svg`): output backend name.
- `zoom` (double, default `1.0`): global scale factor applied to layout and render.
- `sheetMaximumWidth` (double px, default `1440.0`): width used for Endless when no fixed canvas.
- Presets: `Standard`, `Piano`, `PianoPedagogic`, `Compact`, `Print` (factory configs).

## Pipeline: Layout / Page

- `pageFormat` (string, default `Endless`): `A4 P`, `A4 L`, `Endless`, `Horizontal`.
- `useFixedCanvas` (bool, default `false`): override page format with fixed size.
- `fixedCanvasWidth` (double px, default `0.0`): fixed canvas width.
- `fixedCanvasHeight` (double px, default `0.0`): fixed canvas height.
- `pageHeight` (double px, default `0.0`): max page height for multipage; `0` = Endless.
- `pageMarginLeftStaffSpaces` (double SS, default `8.0`): left page margin.
- `pageMarginRightStaffSpaces` (double SS, default `8.0`): right page margin.
- `pageMarginTopStaffSpaces` (double SS, default `5.0`): top page margin.
- `pageMarginBottomStaffSpaces` (double SS, default `5.0`): bottom page margin.
- `systemSpacingMinStaffSpaces` (double SS, default `10.0`): min spacing between systems.
- `systemSpacingMultiStaffMinStaffSpaces` (double SS, default `12.0`): min spacing for multi-staff systems.
- `newSystemFromXML` (bool, default `true`): force new system when XML says so.
- `newPageFromXML` (bool, default `false`): force new page when XML says so.
- `fillEmptyMeasuresWithWholeRest` (int, default `1`): `0` off, `1` visible, `2` invisible.

## Pipeline: Layout / Line Breaking

- `justificationRatioMin` (double, default `0.85`): hard minimum ratio.
- `justificationRatioMax` (double, default `5.0`): hard maximum ratio.
- `justificationRatioTarget` (double, default `1.0`): target ratio.
- `justificationRatioSoftMin` (double, default `0.90`): soft min ratio.
- `justificationRatioSoftMax` (double, default `1.20`): soft max ratio.
- `weightRatio` (double, default `10.0`): weight for ratio deviation.
- `weightTight` (double, default `5.0`): penalty when ratio < soft min.
- `weightLoose` (double, default `3.0`): penalty when ratio > soft max.
- `weightLastUnder` (double, default `1.0`): penalty for ragged last line underfill.
- `costPower` (double, default `2.0`): power used in cost.
- `stretchLastSystem` (bool, default `false`): justify the last system.
- `lastLineMaxUnderfill` (double, default `0.30`): max underfill before penalty.
- `targetMeasuresPerSystem` (int, default `-1`): target measures per system, `-1` disables.
- `weightCount` (double, default `0.0`): weight for measure count deviation.
- `bonusFinalBar` (double, default `-1.0`): bonus to break after final bar.
- `bonusDoubleBar` (double, default `-0.6`): bonus to break after double bar.
- `bonusPhrasEnd` (double, default `-0.3`): bonus to break at phrase end (slur).
- `bonusRehearsalMark` (double, default `-0.5`): bonus to break before rehearsal mark.
- `penaltyHairpinAcross` (double, default `1.0`): penalty for breaking a hairpin.
- `penaltySlurAcross` (double, default `0.8`): penalty for breaking a slur.
- `penaltyLyricsHyphen` (double, default `0.6`): penalty for breaking a hyphenated lyric.
- `penaltyTieAcross` (double, default `0.4`): penalty for breaking a tie.
- `penaltyClefChange` (double, default `0.3`): penalty before clef change.
- `penaltyKeyTimeChange` (double, default `0.3`): penalty before key/time change.
- `penaltyTempoText` (double, default `0.3`): penalty before tempo text.
- `enableTwoPassOptimization` (bool, default `true`): run pass 2.
- `enableBreakFeatures` (bool, default `true`): use semantic break features.
- `maxMeasuresPerLine` (int, default `20`): pruning limit for DP.

## Pipeline: Rendering / Visibility

- `drawTitle` (bool, default `true`): draw title text.
- `drawPartNames` (bool, default `false`): draw part names.
- `drawMeasureNumbers` (bool, default `true`): enable measure numbers.
- `drawMeasureNumbersOnlyAtSystemStart` (bool, default `true`): show numbers only at system start (overrides interval/begin).
- `drawMeasureNumbersBegin` (int, default `1`): first measure number to show.
- `measureNumberInterval` (int, default `5`): measure number interval.
- `drawTimeSignatures` (bool, default `true`): draw time signatures.
- `drawKeySignatures` (bool, default `true`): draw key signatures.
- `drawFingerings` (bool, default `false`): draw fingerings.
- `drawSlurs` (bool, default `true`): draw slurs.
- `drawPedals` (bool, default `true`): draw pedal markings.
- `drawDynamics` (bool, default `true`): draw dynamics.
- `drawWedges` (bool, default `true`): draw wedges (hairpins).
- `drawLyrics` (bool, default `false`): draw lyrics.
- `drawCredits` (bool, default `false`): draw credits.
- `drawComposer` (bool, default `false`): draw composer.
- `drawLyricist` (bool, default `false`): draw lyricist.

## Pipeline: Notation / Engraving

- `autoBeam` (bool, default `false`): automatic beaming.
- `tupletsBracketed` (bool, default `false`): show tuplet brackets.
- `tripletsBracketed` (bool, default `false`): show triplet brackets.
- `tupletsRatioed` (bool, default `false`): show tuplet ratios.
- `alignRests` (int, default `2`): `0` off, `1` on, `2` auto.
- `setWantedStemDirectionByXml` (bool, default `true`): keep XML stem direction.
- `fingeringPosition` (string, default `aboveorbelow`): `above`, `below`, `left`, `right`, `auto`.
- `fingeringInsideStafflines` (bool, default `false`): allow fingering inside staff.
- `fingeringYOffsetStaffSpaces` (double SS, default `2.6`): fingering offset.
- `fingeringFontSize` (double px, default `11.0`): fingering font size.
- `pedalYOffsetStaffSpaces` (double SS, default `3.0`): pedal offset under staff.
- `pedalLineThicknessStaffSpaces` (double SS, default `0.4`): pedal line thickness.
- `pedalTextFontSize` (double px, default `10.0`): pedal text font size.
- `pedalTextToLineStartStaffSpaces` (double SS, default `3.0`): text to line start.
- `pedalLineToEndSymbolGapStaffSpaces` (double SS, default `1.0`): line to end symbol gap.
- `pedalChangeNotchHeightStaffSpaces` (double SS, default `1.2`): notch height for change.
- `dynamicsYOffsetStaffSpaces` (double SS, default `2.6`): dynamics offset under staff.
- `dynamicsFontSize` (double px, default `12.0`): dynamics font size.
- `wedgeYOffsetStaffSpaces` (double SS, default `2.2`): wedge offset under staff.
- `wedgeHeightStaffSpaces` (double SS, default `1.2`): wedge height.
- `wedgeLineThicknessStaffSpaces` (double SS, default `0.3`): wedge line thickness.
- `wedgeInsetFromEndsStaffSpaces` (double SS, default `0.8`): inset from wedge ends.
- `lyricsYOffsetStaffSpaces` (double SS, default `3.2`): lyrics baseline offset.
- `lyricsFontSize` (double px, default `11.0`): lyrics font size.
- `lyricsHyphenMinGapStaffSpaces` (double SS, default `1.2`): min gap for hyphens.
- `articulationOffsetStaffSpaces` (double SS, default `2.0`): notehead to articulation.
- `articulationStackGapStaffSpaces` (double SS, default `1.2`): gap between stacked articulations.
- `articulationLineThicknessStaffSpaces` (double SS, default `0.24`): articulation stroke thickness.
- `tenutoLengthStaffSpaces` (double SS, default `3.0`): tenuto length.
- `accentWidthStaffSpaces` (double SS, default `3.2`): accent width.
- `accentHeightStaffSpaces` (double SS, default `1.6`): accent height.
- `marcatoWidthStaffSpaces` (double SS, default `3.0`): marcato width.
- `marcatoHeightStaffSpaces` (double SS, default `2.0`): marcato height.
- `staccatoDotScale` (double, default `0.9`): staccato dot scale.
- `fermataYOffsetStaffSpaces` (double SS, default `3.0`): fermata dot offset.
- `fermataDotToArcStaffSpaces` (double SS, default `1.0`): dot to arc distance.
- `fermataWidthStaffSpaces` (double SS, default `5.0`): fermata arc width.
- `fermataHeightStaffSpaces` (double SS, default `2.2`): fermata arc height.
- `fermataThicknessStartStaffSpaces` (double SS, default `0.16`): arc thickness at ends.
- `fermataThicknessMidStaffSpaces` (double SS, default `0.34`): arc thickness at middle.
- `fermataDotScale` (double, default `1.0`): fermata dot scale.
- `ornamentYOffsetStaffSpaces` (double SS, default `3.0`): ornament offset above staff.
- `ornamentStackGapStaffSpaces` (double SS, default `1.4`): ornament stack gap.
- `ornamentFontSize` (double px, default `12.0`): ornament font size.
- `staffDistanceStaffSpaces` (double SS, default `8.0`): distance between staff centers for multi-staff.

## Pipeline: Colors / Theme

- `darkMode` (bool, default `false`): dark mode switch.
- `defaultColorMusic` (string, default `#000000`): global music color.
- `defaultColorNotehead` (string, default `#000000`): notehead color.
- `defaultColorStem` (string, default `#000000`): stem color.
- `defaultColorRest` (string, default `#000000`): rest color.
- `defaultColorLabel` (string, default `#000000`): label text color.
- `defaultColorTitle` (string, default `#000000`): title color.
- `coloringEnabled` (bool, default `false`): enable pedagogic coloring.
- `coloringMode` (string, default `xml`): `xml`, `boomwhackers`, `custom`.
- `coloringSetCustom` (list, default empty): 8 colors (Do..Si + silence).
- `colorStemsLikeNoteheads` (bool, default `false`): match stem to notehead color.

## Pipeline: Performance

- `enableGlyphCache` (bool, default `true`): cache glyph paths.
- `enableSpatialIndexing` (bool, default `true`): enable spatial indexing.
- `skyBottomLineBatchMinMeasures` (int, default `50`): skyline batch size.
- `svgPrecision` (int, default `2`): SVG coordinate decimals.
