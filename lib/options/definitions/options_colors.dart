import '../../core/bridge.dart';
import '../options.dart';

// Build the Color options section.
OptionSection buildColorOptions(MXMLBridge bridge) {
  return OptionSection(
    name: "Color Options",
    items: [
      OptionItem(
        key: "colors_dark_mode",
        label: "Dark Mode",
        type: OptionValueType.boolean,
        boolGetter: bridge.getColorsDarkMode,
        boolSetter: bridge.setColorsDarkMode,
      ),
      OptionItem(
        key: "colors_default_color_music",
        label: "Default Color Music",
        type: OptionValueType.text,
        stringGetter: bridge.getColorsDefaultColorMusic,
        stringSetter: bridge.setColorsDefaultColorMusic,
      ),
      OptionItem(
        key: "colors_default_color_notehead",
        label: "Default Color Notehead",
        type: OptionValueType.text,
        stringGetter: bridge.getColorsDefaultColorNotehead,
        stringSetter: bridge.setColorsDefaultColorNotehead,
      ),
      OptionItem(
        key: "colors_default_color_stem",
        label: "Default Color Stem",
        type: OptionValueType.text,
        stringGetter: bridge.getColorsDefaultColorStem,
        stringSetter: bridge.setColorsDefaultColorStem,
      ),
      OptionItem(
        key: "colors_default_color_rest",
        label: "Default Color Rest",
        type: OptionValueType.text,
        stringGetter: bridge.getColorsDefaultColorRest,
        stringSetter: bridge.setColorsDefaultColorRest,
      ),
      OptionItem(
        key: "colors_default_color_label",
        label: "Default Color Label",
        type: OptionValueType.text,
        stringGetter: bridge.getColorsDefaultColorLabel,
        stringSetter: bridge.setColorsDefaultColorLabel,
      ),
      OptionItem(
        key: "colors_default_color_title",
        label: "Default Color Title",
        type: OptionValueType.text,
        stringGetter: bridge.getColorsDefaultColorTitle,
        stringSetter: bridge.setColorsDefaultColorTitle,
      ),
      OptionItem(
        key: "colors_coloring_enabled",
        label: "Coloring Enabled",
        type: OptionValueType.boolean,
        boolGetter: bridge.getColorsColoringEnabled,
        boolSetter: bridge.setColorsColoringEnabled,
      ),
      OptionItem(
        key: "colors_coloring_mode",
        label: "Coloring Mode",
        type: OptionValueType.text,
        stringGetter: bridge.getColorsColoringMode,
        stringSetter: bridge.setColorsColoringMode,
      ),
      OptionItem(
        key: "colors_color_stems_like_noteheads",
        label: "Color Stems Like Noteheads",
        type: OptionValueType.boolean,
        boolGetter: bridge.getColorsColorStemsLikeNoteheads,
        boolSetter: bridge.setColorsColorStemsLikeNoteheads,
      ),
      OptionItem(
        key: "colors_coloring_set_custom",
        label: "Coloring Set Custom (comma separated)",
        type: OptionValueType.textList,
        stringListGetter: bridge.getColorsCustomSet,
        stringListSetter: bridge.setColorsCustomSet,
        hint: "e.g. #ff0000, #00ff00",
      ),
    ],
  );
}
