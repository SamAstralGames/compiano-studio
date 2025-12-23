import '../../core/bridge.dart';
import '../options.dart';

// Build the Rendering options section.
OptionSection buildRenderingOptions(MXMLBridge bridge) {
  return OptionSection(
    name: "Rendering Options",
    items: [
      OptionItem(
        key: "rendering_draw_title",
        label: "Draw Title",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawTitle,
        boolSetter: bridge.setRenderingDrawTitle,
      ),
      OptionItem(
        key: "rendering_draw_part_names",
        label: "Draw Part Names",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawPartNames,
        boolSetter: bridge.setRenderingDrawPartNames,
      ),
      OptionItem(
        key: "rendering_draw_measure_numbers",
        label: "Draw Measure Numbers",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawMeasureNumbers,
        boolSetter: bridge.setRenderingDrawMeasureNumbers,
      ),
      OptionItem(
        key: "rendering_draw_measure_numbers_only_at_system_start",
        label: "Draw Measure Numbers Only At System Start",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawMeasureNumbersOnlyAtSystemStart,
        boolSetter: bridge.setRenderingDrawMeasureNumbersOnlyAtSystemStart,
      ),
      OptionItem(
        key: "rendering_draw_measure_numbers_begin",
        label: "Draw Measure Numbers Begin",
        type: OptionValueType.integer,
        intGetter: bridge.getRenderingDrawMeasureNumbersBegin,
        intSetter: bridge.setRenderingDrawMeasureNumbersBegin,
      ),
      OptionItem(
        key: "rendering_measure_number_interval",
        label: "Measure Number Interval",
        type: OptionValueType.integer,
        intGetter: bridge.getRenderingMeasureNumberInterval,
        intSetter: bridge.setRenderingMeasureNumberInterval,
      ),
      OptionItem(
        key: "rendering_draw_time_signatures",
        label: "Draw Time Signatures",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawTimeSignatures,
        boolSetter: bridge.setRenderingDrawTimeSignatures,
      ),
      OptionItem(
        key: "rendering_draw_key_signatures",
        label: "Draw Key Signatures",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawKeySignatures,
        boolSetter: bridge.setRenderingDrawKeySignatures,
      ),
      OptionItem(
        key: "rendering_draw_fingerings",
        label: "Draw Fingerings",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawFingerings,
        boolSetter: bridge.setRenderingDrawFingerings,
      ),
      OptionItem(
        key: "rendering_draw_slurs",
        label: "Draw Slurs",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawSlurs,
        boolSetter: bridge.setRenderingDrawSlurs,
      ),
      OptionItem(
        key: "rendering_draw_pedals",
        label: "Draw Pedals",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawPedals,
        boolSetter: bridge.setRenderingDrawPedals,
      ),
      OptionItem(
        key: "rendering_draw_dynamics",
        label: "Draw Dynamics",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawDynamics,
        boolSetter: bridge.setRenderingDrawDynamics,
      ),
      OptionItem(
        key: "rendering_draw_wedges",
        label: "Draw Wedges",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawWedges,
        boolSetter: bridge.setRenderingDrawWedges,
      ),
      OptionItem(
        key: "rendering_draw_lyrics",
        label: "Draw Lyrics",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawLyrics,
        boolSetter: bridge.setRenderingDrawLyrics,
      ),
      OptionItem(
        key: "rendering_draw_credits",
        label: "Draw Credits",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawCredits,
        boolSetter: bridge.setRenderingDrawCredits,
      ),
      OptionItem(
        key: "rendering_draw_composer",
        label: "Draw Composer",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawComposer,
        boolSetter: bridge.setRenderingDrawComposer,
      ),
      OptionItem(
        key: "rendering_draw_lyricist",
        label: "Draw Lyricist",
        type: OptionValueType.boolean,
        boolGetter: bridge.getRenderingDrawLyricist,
        boolSetter: bridge.setRenderingDrawLyricist,
      ),
    ],
  );
}
