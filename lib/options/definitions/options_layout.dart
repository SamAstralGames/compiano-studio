import '../../core/bridge.dart';
import '../options.dart';

// Build the Layout options section.
OptionSection buildLayoutOptions(MXMLBridge bridge) {
  return OptionSection(
    name: "Layout Options",
    items: [
      OptionItem(
        key: "layout_page_format",
        label: "Page Format",
        type: OptionValueType.text,
        stringGetter: bridge.getLayoutPageFormat,
        stringSetter: bridge.setLayoutPageFormat,
      ),
      OptionItem(
        key: "layout_use_fixed_canvas",
        label: "Use Fixed Canvas",
        type: OptionValueType.boolean,
        boolGetter: bridge.getLayoutUseFixedCanvas,
        boolSetter: bridge.setLayoutUseFixedCanvas,
      ),
      OptionItem(
        key: "layout_fixed_canvas_width",
        label: "Fixed Canvas Width",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutFixedCanvasWidth,
        doubleSetter: bridge.setLayoutFixedCanvasWidth,
      ),
      OptionItem(
        key: "layout_fixed_canvas_height",
        label: "Fixed Canvas Height",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutFixedCanvasHeight,
        doubleSetter: bridge.setLayoutFixedCanvasHeight,
      ),
      OptionItem(
        key: "layout_page_height",
        label: "Page Height",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutPageHeight,
        doubleSetter: bridge.setLayoutPageHeight,
      ),
      OptionItem(
        key: "layout_page_margin_left_staff_spaces",
        label: "Page Margin Left (Staff Spaces)",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutPageMarginLeftStaffSpaces,
        doubleSetter: bridge.setLayoutPageMarginLeftStaffSpaces,
      ),
      OptionItem(
        key: "layout_page_margin_right_staff_spaces",
        label: "Page Margin Right (Staff Spaces)",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutPageMarginRightStaffSpaces,
        doubleSetter: bridge.setLayoutPageMarginRightStaffSpaces,
      ),
      OptionItem(
        key: "layout_page_margin_top_staff_spaces",
        label: "Page Margin Top (Staff Spaces)",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutPageMarginTopStaffSpaces,
        doubleSetter: bridge.setLayoutPageMarginTopStaffSpaces,
      ),
      OptionItem(
        key: "layout_page_margin_bottom_staff_spaces",
        label: "Page Margin Bottom (Staff Spaces)",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutPageMarginBottomStaffSpaces,
        doubleSetter: bridge.setLayoutPageMarginBottomStaffSpaces,
      ),
      OptionItem(
        key: "layout_system_spacing_min_staff_spaces",
        label: "System Spacing Min (Staff Spaces)",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutSystemSpacingMinStaffSpaces,
        doubleSetter: bridge.setLayoutSystemSpacingMinStaffSpaces,
      ),
      OptionItem(
        key: "layout_system_spacing_multi_staff_min_staff_spaces",
        label: "System Spacing Multi Staff Min (Staff Spaces)",
        type: OptionValueType.decimal,
        doubleGetter: bridge.getLayoutSystemSpacingMultiStaffMinStaffSpaces,
        doubleSetter: bridge.setLayoutSystemSpacingMultiStaffMinStaffSpaces,
      ),
      OptionItem(
        key: "layout_new_system_from_xml",
        label: "New System From XML",
        type: OptionValueType.boolean,
        boolGetter: bridge.getLayoutNewSystemFromXml,
        boolSetter: bridge.setLayoutNewSystemFromXml,
      ),
      OptionItem(
        key: "layout_new_page_from_xml",
        label: "New Page From XML",
        type: OptionValueType.boolean,
        boolGetter: bridge.getLayoutNewPageFromXml,
        boolSetter: bridge.setLayoutNewPageFromXml,
      ),
      OptionItem(
        key: "layout_fill_empty_measures_with_whole_rest",
        label: "Fill Empty Measures With Whole Rest",
        type: OptionValueType.boolean,
        boolGetter: bridge.getLayoutFillEmptyMeasuresWithWholeRest,
        boolSetter: bridge.setLayoutFillEmptyMeasuresWithWholeRest,
      ),
    ],
  );
}
