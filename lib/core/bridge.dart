import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// --- Type Definitions ---

// Handle opaque pour l'instance du convertisseur
base class MXMLHandle extends Opaque {}
// Handle opaque pour les options
base class MXMLOptions extends Opaque {}

// Types de base
typedef MXMLStringId = Uint32;
typedef MXMLGlyphId = Uint16;

// Structs
base class MXMLPointC extends Struct {
  @Float()
  external double x;

  @Float()
  external double y;
}

base class MXMLRectC extends Struct {
  @Float()
  external double x;

  @Float()
  external double y;

  @Float()
  external double width;

  @Float()
  external double height;
}

// Structures de données des commandes
base class MXMLGlyphDataC extends Struct {
  @Uint16()
  external int id;

  external MXMLPointC pos;

  @Float()
  external double scale;
}

base class MXMLLineDataC extends Struct {
  external MXMLPointC p1;
  external MXMLPointC p2;

  @Float()
  external double thickness;
}

base class MXMLTextDataC extends Struct {
  @Uint32()
  external int textId;

  external MXMLPointC pos;

  @Float()
  external double fontSize;

  @Int8()
  external int italic; // 1 = true, 0 = false
}

base class MXMLDebugRectDataC extends Struct {
  external MXMLRectC rect;

  @Uint32()
  external int cssClassId;

  @Uint32()
  external int strokeId;

  @Float()
  external double strokeWidth;

  @Uint32()
  external int fillId;

  @Float()
  external double opacity;
}

base class MXMLPathDataC extends Struct {
  @Uint32()
  external int dId;

  @Uint32()
  external int cssClassId;

  @Uint32()
  external int fillId;

  @Float()
  external double opacity;
}

// Benchmarks pipeline (millisecondes), regroupés par layer.
base class MXMLPipelineBenchC extends Struct {
  @Float()
  external double inputXmlLoadMs;

  @Float()
  external double inputModelBuildMs;

  @Float()
  external double inputTotalMs;

  @Float()
  external double layoutMetricsMs;

  @Float()
  external double layoutLineBreakingMs;

  @Float()
  external double layoutTotalMs;

  @Float()
  external double renderCommandsMs;

  @Float()
  external double exportSerializeSvgMs;

  @Float()
  external double pipelineTotalMs;
}

// Enum simulation
class MXMLRenderCommandTypeC {
  static const int MXML_GLYPH = 0;
  static const int MXML_LINE = 1;
  static const int MXML_TEXT = 2;
  static const int MXML_DEBUG_RECT = 3;
  static const int MXML_PATH = 4;
}

// Union pour RenderCommand
base class MXMLRenderCommandUnion extends Union {
  external MXMLGlyphDataC glyph;
  external MXMLLineDataC line;
  external MXMLTextDataC text;
  external MXMLDebugRectDataC debugRect;
  external MXMLPathDataC path;
}

base class MXMLRenderCommandC extends Struct {
  @Uint8()
  external int type;

  external MXMLRenderCommandUnion data;
}

// --- FFI Signatures ---

// mXMLHandle* mxml_create();
typedef mxml_create_func = Pointer<MXMLHandle> Function();
typedef MxmlCreate = Pointer<MXMLHandle> Function();

// void mxml_destroy(mXMLHandle* handle);
typedef mxml_destroy_func = Void Function(Pointer<MXMLHandle>);
typedef MxmlDestroy = void Function(Pointer<MXMLHandle>);

// int mxml_load_file(mXMLHandle* handle, const char* path);
typedef mxml_load_file_func = Int32 Function(Pointer<MXMLHandle>, Pointer<Utf8>);
typedef MxmlLoadFile = int Function(Pointer<MXMLHandle>, Pointer<Utf8>);

// void mxml_layout(mXMLHandle* handle, float width);
typedef mxml_layout_func = Void Function(Pointer<MXMLHandle>, Float);
typedef MxmlLayout = void Function(Pointer<MXMLHandle>, double);

// float mxml_get_height(mXMLHandle* handle);
typedef mxml_get_height_func = Float Function(Pointer<MXMLHandle>);
typedef MxmlGetHeight = double Function(Pointer<MXMLHandle>);

// uint32_t mxml_get_glyph_codepoint(mXMLHandle* handle, mXMLGlyphId id);
typedef mxml_get_glyph_codepoint_func = Uint32 Function(Pointer<MXMLHandle>, Uint16);
typedef MxmlGetGlyphCodepoint = int Function(Pointer<MXMLHandle>, int);

// const mXMLRenderCommandC* mxml_get_render_commands(mXMLHandle* handle, size_t* count);
typedef mxml_get_render_commands_func = Pointer<MXMLRenderCommandC> Function(Pointer<MXMLHandle>, Pointer<Size>);
typedef MxmlGetRenderCommands = Pointer<MXMLRenderCommandC> Function(Pointer<MXMLHandle>, Pointer<Size>);

// const char* mxml_get_string(mXMLHandle* handle, mXMLStringId id);
typedef mxml_get_string_func = Pointer<Utf8> Function(Pointer<MXMLHandle>, Uint32);
typedef MxmlGetString = Pointer<Utf8> Function(Pointer<MXMLHandle>, int);

// int mxml_write_svg_to_file(mXMLHandle* handle, const char* filepath);
typedef mxml_write_svg_to_file_func = Int32 Function(Pointer<MXMLHandle>, Pointer<Utf8>);
typedef MxmlWriteSvgToFile = int Function(Pointer<MXMLHandle>, Pointer<Utf8>);

// const mXMLPipelineBenchC* mxml_get_pipeline_bench(mXMLHandle* handle);
typedef mxml_get_pipeline_bench_func = Pointer<MXMLPipelineBenchC> Function(Pointer<MXMLHandle>);
typedef MxmlGetPipelineBench = Pointer<MXMLPipelineBenchC> Function(Pointer<MXMLHandle>);

// --- Options FFI Signatures ---

// mxml_options* mxml_options_create();
typedef mxml_options_create_func = Pointer<MXMLOptions> Function();
typedef MxmlOptionsCreate = Pointer<MXMLOptions> Function();

// void mxml_options_destroy(mxml_options* opts);
typedef mxml_options_destroy_func = Void Function(Pointer<MXMLOptions>);
typedef MxmlOptionsDestroy = void Function(Pointer<MXMLOptions>);

// Presets
typedef mxml_options_apply_standard_func = Void Function(Pointer<MXMLOptions>);
typedef MxmlOptionsApplyStandard = void Function(Pointer<MXMLOptions>);
typedef mxml_options_apply_piano_func = Void Function(Pointer<MXMLOptions>);
typedef MxmlOptionsApplyPiano = void Function(Pointer<MXMLOptions>);
typedef mxml_options_apply_piano_pedagogic_func = Void Function(Pointer<MXMLOptions>);
typedef MxmlOptionsApplyPianoPedagogic = void Function(Pointer<MXMLOptions>);
typedef mxml_options_apply_compact_func = Void Function(Pointer<MXMLOptions>);
typedef MxmlOptionsApplyCompact = void Function(Pointer<MXMLOptions>);
typedef mxml_options_apply_print_func = Void Function(Pointer<MXMLOptions>);
typedef MxmlOptionsApplyPrint = void Function(Pointer<MXMLOptions>);

// Rendering Options (bool)
typedef mxml_options_set_rendering_draw_title_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_title_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_part_names_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_part_names_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_measure_numbers_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_measure_numbers_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_measure_numbers_only_at_system_start_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_measure_numbers_only_at_system_start_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_measure_numbers_begin_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_measure_numbers_begin_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_measure_number_interval_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_measure_number_interval_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_time_signatures_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_time_signatures_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_key_signatures_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_key_signatures_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_fingerings_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_fingerings_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_slurs_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_slurs_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_pedals_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_pedals_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_dynamics_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_dynamics_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_wedges_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_wedges_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_lyrics_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_lyrics_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_credits_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_credits_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_composer_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_composer_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_lyricist_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_lyricist_func = Int32 Function(Pointer<MXMLOptions>);

// Layout Options
typedef mxml_options_set_layout_page_format_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_layout_page_format_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_use_fixed_canvas_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_layout_use_fixed_canvas_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_fixed_canvas_width_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_fixed_canvas_width_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_fixed_canvas_height_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_fixed_canvas_height_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_height_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_height_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_margin_left_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_left_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_margin_right_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_right_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_margin_top_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_top_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_margin_bottom_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_bottom_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_system_spacing_min_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_system_spacing_min_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_system_spacing_multi_staff_min_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_system_spacing_multi_staff_min_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_new_system_from_xml_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_layout_new_system_from_xml_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_new_page_from_xml_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_layout_new_page_from_xml_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_fill_empty_measures_with_whole_rest_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_layout_fill_empty_measures_with_whole_rest_func = Int32 Function(Pointer<MXMLOptions>);

// Line Breaking Options
typedef mxml_options_set_line_breaking_justification_ratio_min_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_min_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_max_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_max_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_target_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_target_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_soft_min_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_soft_min_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_soft_max_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_soft_max_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_ratio_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_ratio_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_tight_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_tight_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_loose_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_loose_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_last_under_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_last_under_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_cost_power_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_cost_power_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_stretch_last_system_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_stretch_last_system_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_last_line_max_underfill_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_last_line_max_underfill_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_target_measures_per_system_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_target_measures_per_system_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_count_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_count_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_final_bar_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_final_bar_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_double_bar_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_double_bar_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_phras_end_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_phras_end_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_rehearsal_mark_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_rehearsal_mark_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_hairpin_across_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_hairpin_across_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_slur_across_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_slur_across_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_lyrics_hyphen_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_lyrics_hyphen_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_tie_across_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_tie_across_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_clef_change_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_clef_change_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_key_time_change_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_key_time_change_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_tempo_text_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_tempo_text_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_enable_two_pass_optimization_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_enable_two_pass_optimization_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_enable_break_features_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_enable_break_features_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_max_measures_per_line_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_max_measures_per_line_func = Int32 Function(Pointer<MXMLOptions>);

// Notation Options
typedef mxml_options_set_notation_auto_beam_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_auto_beam_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_tuplets_bracketed_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_tuplets_bracketed_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_triplets_bracketed_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_triplets_bracketed_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_tuplets_ratioed_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_tuplets_ratioed_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_align_rests_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_align_rests_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_set_wanted_stem_direction_by_xml_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_set_wanted_stem_direction_by_xml_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_slur_lift_sample_count_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_slur_lift_sample_count_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_position_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_notation_fingering_position_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_inside_stafflines_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_fingering_inside_stafflines_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_y_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fingering_y_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_font_size_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fingering_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_y_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_y_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_line_thickness_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_line_thickness_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_text_font_size_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_text_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_text_to_line_start_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_text_to_line_start_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_line_to_end_symbol_gap_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_line_to_end_symbol_gap_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_change_notch_height_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_change_notch_height_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_dynamics_y_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_dynamics_y_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_dynamics_font_size_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_dynamics_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_y_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_y_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_height_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_height_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_line_thickness_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_line_thickness_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_inset_from_ends_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_inset_from_ends_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_lyrics_y_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_lyrics_y_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_lyrics_font_size_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_lyrics_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_lyrics_hyphen_min_gap_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_lyrics_hyphen_min_gap_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_articulation_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_articulation_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_articulation_stack_gap_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_articulation_stack_gap_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_articulation_line_thickness_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_articulation_line_thickness_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_tenuto_length_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_tenuto_length_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_accent_width_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_accent_width_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_accent_height_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_accent_height_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_marcato_width_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_marcato_width_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_marcato_height_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_marcato_height_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_staccato_dot_scale_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_staccato_dot_scale_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_y_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_y_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_dot_to_arc_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_dot_to_arc_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_width_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_width_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_height_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_height_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_thickness_start_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_thickness_start_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_thickness_mid_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_thickness_mid_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_dot_scale_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_dot_scale_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_ornament_y_offset_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_ornament_y_offset_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_ornament_stack_gap_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_ornament_stack_gap_staff_spaces_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_ornament_font_size_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_ornament_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_staff_distance_staff_spaces_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_staff_distance_staff_spaces_func = Double Function(Pointer<MXMLOptions>);

// Color Options
typedef mxml_options_set_colors_dark_mode_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_colors_dark_mode_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_music_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_music_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_notehead_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_notehead_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_stem_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_stem_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_rest_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_rest_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_label_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_label_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_title_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_title_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_coloring_enabled_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_colors_coloring_enabled_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_coloring_mode_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_coloring_mode_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_color_stems_like_noteheads_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_colors_color_stems_like_noteheads_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_coloring_set_custom_func = Void Function(Pointer<MXMLOptions>, Pointer<Pointer<Utf8>>, Size);
typedef mxml_options_get_colors_coloring_set_custom_count_func = Size Function(Pointer<MXMLOptions>);
typedef mxml_options_get_colors_coloring_set_custom_at_func = Pointer<Utf8> Function(Pointer<MXMLOptions>, Size);

// Performance Options
typedef mxml_options_set_performance_enable_glyph_cache_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_enable_glyph_cache_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_enable_spatial_indexing_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_enable_spatial_indexing_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_sky_bottom_line_batch_min_measures_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_sky_bottom_line_batch_min_measures_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_svg_precision_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_svg_precision_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_bench_enable_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_bench_enable_func = Int32 Function(Pointer<MXMLOptions>);

// Global Options
typedef mxml_options_set_backend_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_backend_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_zoom_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_zoom_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_sheet_maximum_width_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_sheet_maximum_width_func = Double Function(Pointer<MXMLOptions>);

// Layout with options
typedef mxml_layout_with_options_func = Void Function(Pointer<MXMLHandle>, Float, Pointer<MXMLOptions>);
typedef MxmlLayoutWithOptions = void Function(Pointer<MXMLHandle>, double, Pointer<MXMLOptions>);


// --- Options Dart Typedefs ---

typedef OptionsSetBool = void Function(Pointer<MXMLOptions>, int);
typedef OptionsGetBool = int Function(Pointer<MXMLOptions>);
typedef OptionsSetInt = void Function(Pointer<MXMLOptions>, int);
typedef OptionsGetInt = int Function(Pointer<MXMLOptions>);
typedef OptionsSetDouble = void Function(Pointer<MXMLOptions>, double);
typedef OptionsGetDouble = double Function(Pointer<MXMLOptions>);
typedef OptionsSetString = void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef OptionsGetString = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef OptionsSetStringList = void Function(Pointer<MXMLOptions>, Pointer<Pointer<Utf8>>, int);
typedef OptionsGetStringListCount = int Function(Pointer<MXMLOptions>);
typedef OptionsGetStringListAt = Pointer<Utf8> Function(Pointer<MXMLOptions>, int);


// Conteneur Dart pour les benchmarks pipeline.
class MXMLPipelineBench {
  final double inputXmlLoadMs;
  final double inputModelBuildMs;
  final double inputTotalMs;
  final double layoutMetricsMs;
  final double layoutLineBreakingMs;
  final double layoutTotalMs;
  final double renderCommandsMs;
  final double exportSerializeSvgMs;
  final double pipelineTotalMs;

  // Construit une copie Dart depuis la struct C.
  MXMLPipelineBench({
    required this.inputXmlLoadMs,
    required this.inputModelBuildMs,
    required this.inputTotalMs,
    required this.layoutMetricsMs,
    required this.layoutLineBreakingMs,
    required this.layoutTotalMs,
    required this.renderCommandsMs,
    required this.exportSerializeSvgMs,
    required this.pipelineTotalMs,
  });

  // Convertit la struct C en copie Dart pour éviter de garder un pointeur.
  static MXMLPipelineBench fromC(MXMLPipelineBenchC bench) {
    return MXMLPipelineBench(
      inputXmlLoadMs: bench.inputXmlLoadMs,
      inputModelBuildMs: bench.inputModelBuildMs,
      inputTotalMs: bench.inputTotalMs,
      layoutMetricsMs: bench.layoutMetricsMs,
      layoutLineBreakingMs: bench.layoutLineBreakingMs,
      layoutTotalMs: bench.layoutTotalMs,
      renderCommandsMs: bench.renderCommandsMs,
      exportSerializeSvgMs: bench.exportSerializeSvgMs,
      pipelineTotalMs: bench.pipelineTotalMs,
    );
  }
}

class MXMLBridge {
  static late final DynamicLibrary _dylib;
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
    if (_initialized) return;

    if (Platform.isLinux) {
      _dylib = DynamicLibrary.open('libmxmlconverter.so');
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libmxmlconverter.so');
    } else if (Platform.isMacOS || Platform.isIOS) {
      _dylib = DynamicLibrary.open('libmxmlconverter.dylib'); 
    } else if (Platform.isWindows) {
      _dylib = DynamicLibrary.open('mxmlconverter.dll');
    } else {
      throw UnsupportedError('Platform not supported');
    }

    _create = _dylib.lookupFunction<mxml_create_func, MxmlCreate>('mxml_create');
    _destroy = _dylib.lookupFunction<mxml_destroy_func, MxmlDestroy>('mxml_destroy');
    _loadFile = _dylib.lookupFunction<mxml_load_file_func, MxmlLoadFile>('mxml_load_file');
    _layout = _dylib.lookupFunction<mxml_layout_func, MxmlLayout>('mxml_layout');
    _getHeight = _dylib.lookupFunction<mxml_get_height_func, MxmlGetHeight>('mxml_get_height');
    _getGlyphCodepoint = _dylib.lookupFunction<mxml_get_glyph_codepoint_func, MxmlGetGlyphCodepoint>('mxml_get_glyph_codepoint');
    _getRenderCommands = _dylib.lookupFunction<mxml_get_render_commands_func, MxmlGetRenderCommands>('mxml_get_render_commands');
    _getString = _dylib.lookupFunction<mxml_get_string_func, MxmlGetString>('mxml_get_string');
    _writeSvgToFile = _dylib.lookupFunction<mxml_write_svg_to_file_func, MxmlWriteSvgToFile>('mxml_write_svg_to_file');
    _getPipelineBench = _dylib.lookupFunction<mxml_get_pipeline_bench_func, MxmlGetPipelineBench>('mxml_get_pipeline_bench');
    _optionsCreate = _dylib.lookupFunction<mxml_options_create_func, MxmlOptionsCreate>('mxml_options_create');
    _optionsDestroy = _dylib.lookupFunction<mxml_options_destroy_func, MxmlOptionsDestroy>('mxml_options_destroy');
    _optionsApplyStandard = _dylib.lookupFunction<mxml_options_apply_standard_func, MxmlOptionsApplyStandard>('mxml_options_apply_standard');
    _optionsApplyPiano = _dylib.lookupFunction<mxml_options_apply_piano_func, MxmlOptionsApplyPiano>('mxml_options_apply_piano');
    _optionsApplyPianoPedagogic = _dylib.lookupFunction<mxml_options_apply_piano_pedagogic_func, MxmlOptionsApplyPianoPedagogic>('mxml_options_apply_piano_pedagogic');
    _optionsApplyCompact = _dylib.lookupFunction<mxml_options_apply_compact_func, MxmlOptionsApplyCompact>('mxml_options_apply_compact');
    _optionsApplyPrint = _dylib.lookupFunction<mxml_options_apply_print_func, MxmlOptionsApplyPrint>('mxml_options_apply_print');
    _layoutWithOptions = _dylib.lookupFunction<mxml_layout_with_options_func, MxmlLayoutWithOptions>('mxml_layout_with_options');
    _setRenderingDrawTitle = _dylib.lookupFunction<mxml_options_set_rendering_draw_title_func, OptionsSetBool>('mxml_options_set_rendering_draw_title');
    _getRenderingDrawTitle = _dylib.lookupFunction<mxml_options_get_rendering_draw_title_func, OptionsGetBool>('mxml_options_get_rendering_draw_title');
    _setRenderingDrawPartNames = _dylib.lookupFunction<mxml_options_set_rendering_draw_part_names_func, OptionsSetBool>('mxml_options_set_rendering_draw_part_names');
    _getRenderingDrawPartNames = _dylib.lookupFunction<mxml_options_get_rendering_draw_part_names_func, OptionsGetBool>('mxml_options_get_rendering_draw_part_names');
    _setRenderingDrawMeasureNumbers = _dylib.lookupFunction<mxml_options_set_rendering_draw_measure_numbers_func, OptionsSetBool>('mxml_options_set_rendering_draw_measure_numbers');
    _getRenderingDrawMeasureNumbers = _dylib.lookupFunction<mxml_options_get_rendering_draw_measure_numbers_func, OptionsGetBool>('mxml_options_get_rendering_draw_measure_numbers');
    _setRenderingDrawMeasureNumbersOnlyAtSystemStart = _dylib.lookupFunction<mxml_options_set_rendering_draw_measure_numbers_only_at_system_start_func, OptionsSetBool>('mxml_options_set_rendering_draw_measure_numbers_only_at_system_start');
    _getRenderingDrawMeasureNumbersOnlyAtSystemStart = _dylib.lookupFunction<mxml_options_get_rendering_draw_measure_numbers_only_at_system_start_func, OptionsGetBool>('mxml_options_get_rendering_draw_measure_numbers_only_at_system_start');
    _setRenderingDrawMeasureNumbersBegin = _dylib.lookupFunction<mxml_options_set_rendering_draw_measure_numbers_begin_func, OptionsSetInt>('mxml_options_set_rendering_draw_measure_numbers_begin');
    _getRenderingDrawMeasureNumbersBegin = _dylib.lookupFunction<mxml_options_get_rendering_draw_measure_numbers_begin_func, OptionsGetInt>('mxml_options_get_rendering_draw_measure_numbers_begin');
    _setRenderingMeasureNumberInterval = _dylib.lookupFunction<mxml_options_set_rendering_measure_number_interval_func, OptionsSetInt>('mxml_options_set_rendering_measure_number_interval');
    _getRenderingMeasureNumberInterval = _dylib.lookupFunction<mxml_options_get_rendering_measure_number_interval_func, OptionsGetInt>('mxml_options_get_rendering_measure_number_interval');
    _setRenderingDrawTimeSignatures = _dylib.lookupFunction<mxml_options_set_rendering_draw_time_signatures_func, OptionsSetBool>('mxml_options_set_rendering_draw_time_signatures');
    _getRenderingDrawTimeSignatures = _dylib.lookupFunction<mxml_options_get_rendering_draw_time_signatures_func, OptionsGetBool>('mxml_options_get_rendering_draw_time_signatures');
    _setRenderingDrawKeySignatures = _dylib.lookupFunction<mxml_options_set_rendering_draw_key_signatures_func, OptionsSetBool>('mxml_options_set_rendering_draw_key_signatures');
    _getRenderingDrawKeySignatures = _dylib.lookupFunction<mxml_options_get_rendering_draw_key_signatures_func, OptionsGetBool>('mxml_options_get_rendering_draw_key_signatures');
    _setRenderingDrawFingerings = _dylib.lookupFunction<mxml_options_set_rendering_draw_fingerings_func, OptionsSetBool>('mxml_options_set_rendering_draw_fingerings');
    _getRenderingDrawFingerings = _dylib.lookupFunction<mxml_options_get_rendering_draw_fingerings_func, OptionsGetBool>('mxml_options_get_rendering_draw_fingerings');
    _setRenderingDrawSlurs = _dylib.lookupFunction<mxml_options_set_rendering_draw_slurs_func, OptionsSetBool>('mxml_options_set_rendering_draw_slurs');
    _getRenderingDrawSlurs = _dylib.lookupFunction<mxml_options_get_rendering_draw_slurs_func, OptionsGetBool>('mxml_options_get_rendering_draw_slurs');
    _setRenderingDrawPedals = _dylib.lookupFunction<mxml_options_set_rendering_draw_pedals_func, OptionsSetBool>('mxml_options_set_rendering_draw_pedals');
    _getRenderingDrawPedals = _dylib.lookupFunction<mxml_options_get_rendering_draw_pedals_func, OptionsGetBool>('mxml_options_get_rendering_draw_pedals');
    _setRenderingDrawDynamics = _dylib.lookupFunction<mxml_options_set_rendering_draw_dynamics_func, OptionsSetBool>('mxml_options_set_rendering_draw_dynamics');
    _getRenderingDrawDynamics = _dylib.lookupFunction<mxml_options_get_rendering_draw_dynamics_func, OptionsGetBool>('mxml_options_get_rendering_draw_dynamics');
    _setRenderingDrawWedges = _dylib.lookupFunction<mxml_options_set_rendering_draw_wedges_func, OptionsSetBool>('mxml_options_set_rendering_draw_wedges');
    _getRenderingDrawWedges = _dylib.lookupFunction<mxml_options_get_rendering_draw_wedges_func, OptionsGetBool>('mxml_options_get_rendering_draw_wedges');
    _setRenderingDrawLyrics = _dylib.lookupFunction<mxml_options_set_rendering_draw_lyrics_func, OptionsSetBool>('mxml_options_set_rendering_draw_lyrics');
    _getRenderingDrawLyrics = _dylib.lookupFunction<mxml_options_get_rendering_draw_lyrics_func, OptionsGetBool>('mxml_options_get_rendering_draw_lyrics');
    _setRenderingDrawCredits = _dylib.lookupFunction<mxml_options_set_rendering_draw_credits_func, OptionsSetBool>('mxml_options_set_rendering_draw_credits');
    _getRenderingDrawCredits = _dylib.lookupFunction<mxml_options_get_rendering_draw_credits_func, OptionsGetBool>('mxml_options_get_rendering_draw_credits');
    _setRenderingDrawComposer = _dylib.lookupFunction<mxml_options_set_rendering_draw_composer_func, OptionsSetBool>('mxml_options_set_rendering_draw_composer');
    _getRenderingDrawComposer = _dylib.lookupFunction<mxml_options_get_rendering_draw_composer_func, OptionsGetBool>('mxml_options_get_rendering_draw_composer');
    _setRenderingDrawLyricist = _dylib.lookupFunction<mxml_options_set_rendering_draw_lyricist_func, OptionsSetBool>('mxml_options_set_rendering_draw_lyricist');
    _getRenderingDrawLyricist = _dylib.lookupFunction<mxml_options_get_rendering_draw_lyricist_func, OptionsGetBool>('mxml_options_get_rendering_draw_lyricist');
    _setLayoutPageFormat = _dylib.lookupFunction<mxml_options_set_layout_page_format_func, OptionsSetString>('mxml_options_set_layout_page_format');
    _getLayoutPageFormat = _dylib.lookupFunction<mxml_options_get_layout_page_format_func, OptionsGetString>('mxml_options_get_layout_page_format');
    _setLayoutUseFixedCanvas = _dylib.lookupFunction<mxml_options_set_layout_use_fixed_canvas_func, OptionsSetBool>('mxml_options_set_layout_use_fixed_canvas');
    _getLayoutUseFixedCanvas = _dylib.lookupFunction<mxml_options_get_layout_use_fixed_canvas_func, OptionsGetBool>('mxml_options_get_layout_use_fixed_canvas');
    _setLayoutFixedCanvasWidth = _dylib.lookupFunction<mxml_options_set_layout_fixed_canvas_width_func, OptionsSetDouble>('mxml_options_set_layout_fixed_canvas_width');
    _getLayoutFixedCanvasWidth = _dylib.lookupFunction<mxml_options_get_layout_fixed_canvas_width_func, OptionsGetDouble>('mxml_options_get_layout_fixed_canvas_width');
    _setLayoutFixedCanvasHeight = _dylib.lookupFunction<mxml_options_set_layout_fixed_canvas_height_func, OptionsSetDouble>('mxml_options_set_layout_fixed_canvas_height');
    _getLayoutFixedCanvasHeight = _dylib.lookupFunction<mxml_options_get_layout_fixed_canvas_height_func, OptionsGetDouble>('mxml_options_get_layout_fixed_canvas_height');
    _setLayoutPageHeight = _dylib.lookupFunction<mxml_options_set_layout_page_height_func, OptionsSetDouble>('mxml_options_set_layout_page_height');
    _getLayoutPageHeight = _dylib.lookupFunction<mxml_options_get_layout_page_height_func, OptionsGetDouble>('mxml_options_get_layout_page_height');
    _setLayoutPageMarginLeftStaffSpaces = _dylib.lookupFunction<mxml_options_set_layout_page_margin_left_staff_spaces_func, OptionsSetDouble>('mxml_options_set_layout_page_margin_left_staff_spaces');
    _getLayoutPageMarginLeftStaffSpaces = _dylib.lookupFunction<mxml_options_get_layout_page_margin_left_staff_spaces_func, OptionsGetDouble>('mxml_options_get_layout_page_margin_left_staff_spaces');
    _setLayoutPageMarginRightStaffSpaces = _dylib.lookupFunction<mxml_options_set_layout_page_margin_right_staff_spaces_func, OptionsSetDouble>('mxml_options_set_layout_page_margin_right_staff_spaces');
    _getLayoutPageMarginRightStaffSpaces = _dylib.lookupFunction<mxml_options_get_layout_page_margin_right_staff_spaces_func, OptionsGetDouble>('mxml_options_get_layout_page_margin_right_staff_spaces');
    _setLayoutPageMarginTopStaffSpaces = _dylib.lookupFunction<mxml_options_set_layout_page_margin_top_staff_spaces_func, OptionsSetDouble>('mxml_options_set_layout_page_margin_top_staff_spaces');
    _getLayoutPageMarginTopStaffSpaces = _dylib.lookupFunction<mxml_options_get_layout_page_margin_top_staff_spaces_func, OptionsGetDouble>('mxml_options_get_layout_page_margin_top_staff_spaces');
    _setLayoutPageMarginBottomStaffSpaces = _dylib.lookupFunction<mxml_options_set_layout_page_margin_bottom_staff_spaces_func, OptionsSetDouble>('mxml_options_set_layout_page_margin_bottom_staff_spaces');
    _getLayoutPageMarginBottomStaffSpaces = _dylib.lookupFunction<mxml_options_get_layout_page_margin_bottom_staff_spaces_func, OptionsGetDouble>('mxml_options_get_layout_page_margin_bottom_staff_spaces');
    _setLayoutSystemSpacingMinStaffSpaces = _dylib.lookupFunction<mxml_options_set_layout_system_spacing_min_staff_spaces_func, OptionsSetDouble>('mxml_options_set_layout_system_spacing_min_staff_spaces');
    _getLayoutSystemSpacingMinStaffSpaces = _dylib.lookupFunction<mxml_options_get_layout_system_spacing_min_staff_spaces_func, OptionsGetDouble>('mxml_options_get_layout_system_spacing_min_staff_spaces');
    _setLayoutSystemSpacingMultiStaffMinStaffSpaces = _dylib.lookupFunction<mxml_options_set_layout_system_spacing_multi_staff_min_staff_spaces_func, OptionsSetDouble>('mxml_options_set_layout_system_spacing_multi_staff_min_staff_spaces');
    _getLayoutSystemSpacingMultiStaffMinStaffSpaces = _dylib.lookupFunction<mxml_options_get_layout_system_spacing_multi_staff_min_staff_spaces_func, OptionsGetDouble>('mxml_options_get_layout_system_spacing_multi_staff_min_staff_spaces');
    _setLayoutNewSystemFromXml = _dylib.lookupFunction<mxml_options_set_layout_new_system_from_xml_func, OptionsSetBool>('mxml_options_set_layout_new_system_from_xml');
    _getLayoutNewSystemFromXml = _dylib.lookupFunction<mxml_options_get_layout_new_system_from_xml_func, OptionsGetBool>('mxml_options_get_layout_new_system_from_xml');
    _setLayoutNewPageFromXml = _dylib.lookupFunction<mxml_options_set_layout_new_page_from_xml_func, OptionsSetBool>('mxml_options_set_layout_new_page_from_xml');
    _getLayoutNewPageFromXml = _dylib.lookupFunction<mxml_options_get_layout_new_page_from_xml_func, OptionsGetBool>('mxml_options_get_layout_new_page_from_xml');
    _setLayoutFillEmptyMeasuresWithWholeRest = _dylib.lookupFunction<mxml_options_set_layout_fill_empty_measures_with_whole_rest_func, OptionsSetBool>('mxml_options_set_layout_fill_empty_measures_with_whole_rest');
    _getLayoutFillEmptyMeasuresWithWholeRest = _dylib.lookupFunction<mxml_options_get_layout_fill_empty_measures_with_whole_rest_func, OptionsGetBool>('mxml_options_get_layout_fill_empty_measures_with_whole_rest');
    _setLineBreakingJustificationRatioMin = _dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_min_func, OptionsSetDouble>('mxml_options_set_line_breaking_justification_ratio_min');
    _getLineBreakingJustificationRatioMin = _dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_min_func, OptionsGetDouble>('mxml_options_get_line_breaking_justification_ratio_min');
    _setLineBreakingJustificationRatioMax = _dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_max_func, OptionsSetDouble>('mxml_options_set_line_breaking_justification_ratio_max');
    _getLineBreakingJustificationRatioMax = _dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_max_func, OptionsGetDouble>('mxml_options_get_line_breaking_justification_ratio_max');
    _setLineBreakingJustificationRatioTarget = _dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_target_func, OptionsSetDouble>('mxml_options_set_line_breaking_justification_ratio_target');
    _getLineBreakingJustificationRatioTarget = _dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_target_func, OptionsGetDouble>('mxml_options_get_line_breaking_justification_ratio_target');
    _setLineBreakingJustificationRatioSoftMin = _dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_soft_min_func, OptionsSetDouble>('mxml_options_set_line_breaking_justification_ratio_soft_min');
    _getLineBreakingJustificationRatioSoftMin = _dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_soft_min_func, OptionsGetDouble>('mxml_options_get_line_breaking_justification_ratio_soft_min');
    _setLineBreakingJustificationRatioSoftMax = _dylib.lookupFunction<mxml_options_set_line_breaking_justification_ratio_soft_max_func, OptionsSetDouble>('mxml_options_set_line_breaking_justification_ratio_soft_max');
    _getLineBreakingJustificationRatioSoftMax = _dylib.lookupFunction<mxml_options_get_line_breaking_justification_ratio_soft_max_func, OptionsGetDouble>('mxml_options_get_line_breaking_justification_ratio_soft_max');
    _setLineBreakingWeightRatio = _dylib.lookupFunction<mxml_options_set_line_breaking_weight_ratio_func, OptionsSetDouble>('mxml_options_set_line_breaking_weight_ratio');
    _getLineBreakingWeightRatio = _dylib.lookupFunction<mxml_options_get_line_breaking_weight_ratio_func, OptionsGetDouble>('mxml_options_get_line_breaking_weight_ratio');
    _setLineBreakingWeightTight = _dylib.lookupFunction<mxml_options_set_line_breaking_weight_tight_func, OptionsSetDouble>('mxml_options_set_line_breaking_weight_tight');
    _getLineBreakingWeightTight = _dylib.lookupFunction<mxml_options_get_line_breaking_weight_tight_func, OptionsGetDouble>('mxml_options_get_line_breaking_weight_tight');
    _setLineBreakingWeightLoose = _dylib.lookupFunction<mxml_options_set_line_breaking_weight_loose_func, OptionsSetDouble>('mxml_options_set_line_breaking_weight_loose');
    _getLineBreakingWeightLoose = _dylib.lookupFunction<mxml_options_get_line_breaking_weight_loose_func, OptionsGetDouble>('mxml_options_get_line_breaking_weight_loose');
    _setLineBreakingWeightLastUnder = _dylib.lookupFunction<mxml_options_set_line_breaking_weight_last_under_func, OptionsSetDouble>('mxml_options_set_line_breaking_weight_last_under');
    _getLineBreakingWeightLastUnder = _dylib.lookupFunction<mxml_options_get_line_breaking_weight_last_under_func, OptionsGetDouble>('mxml_options_get_line_breaking_weight_last_under');
    _setLineBreakingCostPower = _dylib.lookupFunction<mxml_options_set_line_breaking_cost_power_func, OptionsSetDouble>('mxml_options_set_line_breaking_cost_power');
    _getLineBreakingCostPower = _dylib.lookupFunction<mxml_options_get_line_breaking_cost_power_func, OptionsGetDouble>('mxml_options_get_line_breaking_cost_power');
    _setLineBreakingStretchLastSystem = _dylib.lookupFunction<mxml_options_set_line_breaking_stretch_last_system_func, OptionsSetBool>('mxml_options_set_line_breaking_stretch_last_system');
    _getLineBreakingStretchLastSystem = _dylib.lookupFunction<mxml_options_get_line_breaking_stretch_last_system_func, OptionsGetBool>('mxml_options_get_line_breaking_stretch_last_system');
    _setLineBreakingLastLineMaxUnderfill = _dylib.lookupFunction<mxml_options_set_line_breaking_last_line_max_underfill_func, OptionsSetDouble>('mxml_options_set_line_breaking_last_line_max_underfill');
    _getLineBreakingLastLineMaxUnderfill = _dylib.lookupFunction<mxml_options_get_line_breaking_last_line_max_underfill_func, OptionsGetDouble>('mxml_options_get_line_breaking_last_line_max_underfill');
    _setLineBreakingTargetMeasuresPerSystem = _dylib.lookupFunction<mxml_options_set_line_breaking_target_measures_per_system_func, OptionsSetInt>('mxml_options_set_line_breaking_target_measures_per_system');
    _getLineBreakingTargetMeasuresPerSystem = _dylib.lookupFunction<mxml_options_get_line_breaking_target_measures_per_system_func, OptionsGetInt>('mxml_options_get_line_breaking_target_measures_per_system');
    _setLineBreakingWeightCount = _dylib.lookupFunction<mxml_options_set_line_breaking_weight_count_func, OptionsSetDouble>('mxml_options_set_line_breaking_weight_count');
    _getLineBreakingWeightCount = _dylib.lookupFunction<mxml_options_get_line_breaking_weight_count_func, OptionsGetDouble>('mxml_options_get_line_breaking_weight_count');
    _setLineBreakingBonusFinalBar = _dylib.lookupFunction<mxml_options_set_line_breaking_bonus_final_bar_func, OptionsSetDouble>('mxml_options_set_line_breaking_bonus_final_bar');
    _getLineBreakingBonusFinalBar = _dylib.lookupFunction<mxml_options_get_line_breaking_bonus_final_bar_func, OptionsGetDouble>('mxml_options_get_line_breaking_bonus_final_bar');
    _setLineBreakingBonusDoubleBar = _dylib.lookupFunction<mxml_options_set_line_breaking_bonus_double_bar_func, OptionsSetDouble>('mxml_options_set_line_breaking_bonus_double_bar');
    _getLineBreakingBonusDoubleBar = _dylib.lookupFunction<mxml_options_get_line_breaking_bonus_double_bar_func, OptionsGetDouble>('mxml_options_get_line_breaking_bonus_double_bar');
    _setLineBreakingBonusPhrasEnd = _dylib.lookupFunction<mxml_options_set_line_breaking_bonus_phras_end_func, OptionsSetDouble>('mxml_options_set_line_breaking_bonus_phras_end');
    _getLineBreakingBonusPhrasEnd = _dylib.lookupFunction<mxml_options_get_line_breaking_bonus_phras_end_func, OptionsGetDouble>('mxml_options_get_line_breaking_bonus_phras_end');
    _setLineBreakingBonusRehearsalMark = _dylib.lookupFunction<mxml_options_set_line_breaking_bonus_rehearsal_mark_func, OptionsSetDouble>('mxml_options_set_line_breaking_bonus_rehearsal_mark');
    _getLineBreakingBonusRehearsalMark = _dylib.lookupFunction<mxml_options_get_line_breaking_bonus_rehearsal_mark_func, OptionsGetDouble>('mxml_options_get_line_breaking_bonus_rehearsal_mark');
    _setLineBreakingPenaltyHairpinAcross = _dylib.lookupFunction<mxml_options_set_line_breaking_penalty_hairpin_across_func, OptionsSetDouble>('mxml_options_set_line_breaking_penalty_hairpin_across');
    _getLineBreakingPenaltyHairpinAcross = _dylib.lookupFunction<mxml_options_get_line_breaking_penalty_hairpin_across_func, OptionsGetDouble>('mxml_options_get_line_breaking_penalty_hairpin_across');
    _setLineBreakingPenaltySlurAcross = _dylib.lookupFunction<mxml_options_set_line_breaking_penalty_slur_across_func, OptionsSetDouble>('mxml_options_set_line_breaking_penalty_slur_across');
    _getLineBreakingPenaltySlurAcross = _dylib.lookupFunction<mxml_options_get_line_breaking_penalty_slur_across_func, OptionsGetDouble>('mxml_options_get_line_breaking_penalty_slur_across');
    _setLineBreakingPenaltyLyricsHyphen = _dylib.lookupFunction<mxml_options_set_line_breaking_penalty_lyrics_hyphen_func, OptionsSetDouble>('mxml_options_set_line_breaking_penalty_lyrics_hyphen');
    _getLineBreakingPenaltyLyricsHyphen = _dylib.lookupFunction<mxml_options_get_line_breaking_penalty_lyrics_hyphen_func, OptionsGetDouble>('mxml_options_get_line_breaking_penalty_lyrics_hyphen');
    _setLineBreakingPenaltyTieAcross = _dylib.lookupFunction<mxml_options_set_line_breaking_penalty_tie_across_func, OptionsSetDouble>('mxml_options_set_line_breaking_penalty_tie_across');
    _getLineBreakingPenaltyTieAcross = _dylib.lookupFunction<mxml_options_get_line_breaking_penalty_tie_across_func, OptionsGetDouble>('mxml_options_get_line_breaking_penalty_tie_across');
    _setLineBreakingPenaltyClefChange = _dylib.lookupFunction<mxml_options_set_line_breaking_penalty_clef_change_func, OptionsSetDouble>('mxml_options_set_line_breaking_penalty_clef_change');
    _getLineBreakingPenaltyClefChange = _dylib.lookupFunction<mxml_options_get_line_breaking_penalty_clef_change_func, OptionsGetDouble>('mxml_options_get_line_breaking_penalty_clef_change');
    _setLineBreakingPenaltyKeyTimeChange = _dylib.lookupFunction<mxml_options_set_line_breaking_penalty_key_time_change_func, OptionsSetDouble>('mxml_options_set_line_breaking_penalty_key_time_change');
    _getLineBreakingPenaltyKeyTimeChange = _dylib.lookupFunction<mxml_options_get_line_breaking_penalty_key_time_change_func, OptionsGetDouble>('mxml_options_get_line_breaking_penalty_key_time_change');
    _setLineBreakingPenaltyTempoText = _dylib.lookupFunction<mxml_options_set_line_breaking_penalty_tempo_text_func, OptionsSetDouble>('mxml_options_set_line_breaking_penalty_tempo_text');
    _getLineBreakingPenaltyTempoText = _dylib.lookupFunction<mxml_options_get_line_breaking_penalty_tempo_text_func, OptionsGetDouble>('mxml_options_get_line_breaking_penalty_tempo_text');
    _setLineBreakingEnableTwoPassOptimization = _dylib.lookupFunction<mxml_options_set_line_breaking_enable_two_pass_optimization_func, OptionsSetBool>('mxml_options_set_line_breaking_enable_two_pass_optimization');
    _getLineBreakingEnableTwoPassOptimization = _dylib.lookupFunction<mxml_options_get_line_breaking_enable_two_pass_optimization_func, OptionsGetBool>('mxml_options_get_line_breaking_enable_two_pass_optimization');
    _setLineBreakingEnableBreakFeatures = _dylib.lookupFunction<mxml_options_set_line_breaking_enable_break_features_func, OptionsSetBool>('mxml_options_set_line_breaking_enable_break_features');
    _getLineBreakingEnableBreakFeatures = _dylib.lookupFunction<mxml_options_get_line_breaking_enable_break_features_func, OptionsGetBool>('mxml_options_get_line_breaking_enable_break_features');
    _setLineBreakingMaxMeasuresPerLine = _dylib.lookupFunction<mxml_options_set_line_breaking_max_measures_per_line_func, OptionsSetInt>('mxml_options_set_line_breaking_max_measures_per_line');
    _getLineBreakingMaxMeasuresPerLine = _dylib.lookupFunction<mxml_options_get_line_breaking_max_measures_per_line_func, OptionsGetInt>('mxml_options_get_line_breaking_max_measures_per_line');
    _setNotationAutoBeam = _dylib.lookupFunction<mxml_options_set_notation_auto_beam_func, OptionsSetBool>('mxml_options_set_notation_auto_beam');
    _getNotationAutoBeam = _dylib.lookupFunction<mxml_options_get_notation_auto_beam_func, OptionsGetBool>('mxml_options_get_notation_auto_beam');
    _setNotationTupletsBracketed = _dylib.lookupFunction<mxml_options_set_notation_tuplets_bracketed_func, OptionsSetBool>('mxml_options_set_notation_tuplets_bracketed');
    _getNotationTupletsBracketed = _dylib.lookupFunction<mxml_options_get_notation_tuplets_bracketed_func, OptionsGetBool>('mxml_options_get_notation_tuplets_bracketed');
    _setNotationTripletsBracketed = _dylib.lookupFunction<mxml_options_set_notation_triplets_bracketed_func, OptionsSetBool>('mxml_options_set_notation_triplets_bracketed');
    _getNotationTripletsBracketed = _dylib.lookupFunction<mxml_options_get_notation_triplets_bracketed_func, OptionsGetBool>('mxml_options_get_notation_triplets_bracketed');
    _setNotationTupletsRatioed = _dylib.lookupFunction<mxml_options_set_notation_tuplets_ratioed_func, OptionsSetBool>('mxml_options_set_notation_tuplets_ratioed');
    _getNotationTupletsRatioed = _dylib.lookupFunction<mxml_options_get_notation_tuplets_ratioed_func, OptionsGetBool>('mxml_options_get_notation_tuplets_ratioed');
    _setNotationAlignRests = _dylib.lookupFunction<mxml_options_set_notation_align_rests_func, OptionsSetBool>('mxml_options_set_notation_align_rests');
    _getNotationAlignRests = _dylib.lookupFunction<mxml_options_get_notation_align_rests_func, OptionsGetBool>('mxml_options_get_notation_align_rests');
    _setNotationSetWantedStemDirectionByXml = _dylib.lookupFunction<mxml_options_set_notation_set_wanted_stem_direction_by_xml_func, OptionsSetBool>('mxml_options_set_notation_set_wanted_stem_direction_by_xml');
    _getNotationSetWantedStemDirectionByXml = _dylib.lookupFunction<mxml_options_get_notation_set_wanted_stem_direction_by_xml_func, OptionsGetBool>('mxml_options_get_notation_set_wanted_stem_direction_by_xml');
    _setNotationSlurLiftSampleCount = _dylib.lookupFunction<mxml_options_set_notation_slur_lift_sample_count_func, OptionsSetInt>('mxml_options_set_notation_slur_lift_sample_count');
    _getNotationSlurLiftSampleCount = _dylib.lookupFunction<mxml_options_get_notation_slur_lift_sample_count_func, OptionsGetInt>('mxml_options_get_notation_slur_lift_sample_count');
    _setNotationFingeringPosition = _dylib.lookupFunction<mxml_options_set_notation_fingering_position_func, OptionsSetString>('mxml_options_set_notation_fingering_position');
    _getNotationFingeringPosition = _dylib.lookupFunction<mxml_options_get_notation_fingering_position_func, OptionsGetString>('mxml_options_get_notation_fingering_position');
    _setNotationFingeringInsideStafflines = _dylib.lookupFunction<mxml_options_set_notation_fingering_inside_stafflines_func, OptionsSetBool>('mxml_options_set_notation_fingering_inside_stafflines');
    _getNotationFingeringInsideStafflines = _dylib.lookupFunction<mxml_options_get_notation_fingering_inside_stafflines_func, OptionsGetBool>('mxml_options_get_notation_fingering_inside_stafflines');
    _setNotationFingeringYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_fingering_y_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_fingering_y_offset_staff_spaces');
    _getNotationFingeringYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_fingering_y_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_fingering_y_offset_staff_spaces');
    _setNotationFingeringFontSize = _dylib.lookupFunction<mxml_options_set_notation_fingering_font_size_func, OptionsSetDouble>('mxml_options_set_notation_fingering_font_size');
    _getNotationFingeringFontSize = _dylib.lookupFunction<mxml_options_get_notation_fingering_font_size_func, OptionsGetDouble>('mxml_options_get_notation_fingering_font_size');
    _setNotationPedalYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_pedal_y_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_pedal_y_offset_staff_spaces');
    _getNotationPedalYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_pedal_y_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_pedal_y_offset_staff_spaces');
    _setNotationPedalLineThicknessStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_pedal_line_thickness_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_pedal_line_thickness_staff_spaces');
    _getNotationPedalLineThicknessStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_pedal_line_thickness_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_pedal_line_thickness_staff_spaces');
    _setNotationPedalTextFontSize = _dylib.lookupFunction<mxml_options_set_notation_pedal_text_font_size_func, OptionsSetDouble>('mxml_options_set_notation_pedal_text_font_size');
    _getNotationPedalTextFontSize = _dylib.lookupFunction<mxml_options_get_notation_pedal_text_font_size_func, OptionsGetDouble>('mxml_options_get_notation_pedal_text_font_size');
    _setNotationPedalTextToLineStartStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_pedal_text_to_line_start_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_pedal_text_to_line_start_staff_spaces');
    _getNotationPedalTextToLineStartStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_pedal_text_to_line_start_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_pedal_text_to_line_start_staff_spaces');
    _setNotationPedalLineToEndSymbolGapStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_pedal_line_to_end_symbol_gap_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_pedal_line_to_end_symbol_gap_staff_spaces');
    _getNotationPedalLineToEndSymbolGapStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_pedal_line_to_end_symbol_gap_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_pedal_line_to_end_symbol_gap_staff_spaces');
    _setNotationPedalChangeNotchHeightStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_pedal_change_notch_height_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_pedal_change_notch_height_staff_spaces');
    _getNotationPedalChangeNotchHeightStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_pedal_change_notch_height_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_pedal_change_notch_height_staff_spaces');
    _setNotationDynamicsYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_dynamics_y_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_dynamics_y_offset_staff_spaces');
    _getNotationDynamicsYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_dynamics_y_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_dynamics_y_offset_staff_spaces');
    _setNotationDynamicsFontSize = _dylib.lookupFunction<mxml_options_set_notation_dynamics_font_size_func, OptionsSetDouble>('mxml_options_set_notation_dynamics_font_size');
    _getNotationDynamicsFontSize = _dylib.lookupFunction<mxml_options_get_notation_dynamics_font_size_func, OptionsGetDouble>('mxml_options_get_notation_dynamics_font_size');
    _setNotationWedgeYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_wedge_y_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_wedge_y_offset_staff_spaces');
    _getNotationWedgeYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_wedge_y_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_wedge_y_offset_staff_spaces');
    _setNotationWedgeHeightStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_wedge_height_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_wedge_height_staff_spaces');
    _getNotationWedgeHeightStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_wedge_height_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_wedge_height_staff_spaces');
    _setNotationWedgeLineThicknessStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_wedge_line_thickness_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_wedge_line_thickness_staff_spaces');
    _getNotationWedgeLineThicknessStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_wedge_line_thickness_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_wedge_line_thickness_staff_spaces');
    _setNotationWedgeInsetFromEndsStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_wedge_inset_from_ends_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_wedge_inset_from_ends_staff_spaces');
    _getNotationWedgeInsetFromEndsStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_wedge_inset_from_ends_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_wedge_inset_from_ends_staff_spaces');
    _setNotationLyricsYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_lyrics_y_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_lyrics_y_offset_staff_spaces');
    _getNotationLyricsYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_lyrics_y_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_lyrics_y_offset_staff_spaces');
    _setNotationLyricsFontSize = _dylib.lookupFunction<mxml_options_set_notation_lyrics_font_size_func, OptionsSetDouble>('mxml_options_set_notation_lyrics_font_size');
    _getNotationLyricsFontSize = _dylib.lookupFunction<mxml_options_get_notation_lyrics_font_size_func, OptionsGetDouble>('mxml_options_get_notation_lyrics_font_size');
    _setNotationLyricsHyphenMinGapStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_lyrics_hyphen_min_gap_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_lyrics_hyphen_min_gap_staff_spaces');
    _getNotationLyricsHyphenMinGapStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_lyrics_hyphen_min_gap_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_lyrics_hyphen_min_gap_staff_spaces');
    _setNotationArticulationOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_articulation_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_articulation_offset_staff_spaces');
    _getNotationArticulationOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_articulation_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_articulation_offset_staff_spaces');
    _setNotationArticulationStackGapStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_articulation_stack_gap_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_articulation_stack_gap_staff_spaces');
    _getNotationArticulationStackGapStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_articulation_stack_gap_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_articulation_stack_gap_staff_spaces');
    _setNotationArticulationLineThicknessStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_articulation_line_thickness_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_articulation_line_thickness_staff_spaces');
    _getNotationArticulationLineThicknessStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_articulation_line_thickness_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_articulation_line_thickness_staff_spaces');
    _setNotationTenutoLengthStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_tenuto_length_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_tenuto_length_staff_spaces');
    _getNotationTenutoLengthStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_tenuto_length_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_tenuto_length_staff_spaces');
    _setNotationAccentWidthStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_accent_width_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_accent_width_staff_spaces');
    _getNotationAccentWidthStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_accent_width_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_accent_width_staff_spaces');
    _setNotationAccentHeightStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_accent_height_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_accent_height_staff_spaces');
    _getNotationAccentHeightStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_accent_height_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_accent_height_staff_spaces');
    _setNotationMarcatoWidthStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_marcato_width_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_marcato_width_staff_spaces');
    _getNotationMarcatoWidthStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_marcato_width_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_marcato_width_staff_spaces');
    _setNotationMarcatoHeightStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_marcato_height_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_marcato_height_staff_spaces');
    _getNotationMarcatoHeightStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_marcato_height_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_marcato_height_staff_spaces');
    _setNotationStaccatoDotScale = _dylib.lookupFunction<mxml_options_set_notation_staccato_dot_scale_func, OptionsSetDouble>('mxml_options_set_notation_staccato_dot_scale');
    _getNotationStaccatoDotScale = _dylib.lookupFunction<mxml_options_get_notation_staccato_dot_scale_func, OptionsGetDouble>('mxml_options_get_notation_staccato_dot_scale');
    _setNotationFermataYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_fermata_y_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_fermata_y_offset_staff_spaces');
    _getNotationFermataYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_fermata_y_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_fermata_y_offset_staff_spaces');
    _setNotationFermataDotToArcStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_fermata_dot_to_arc_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_fermata_dot_to_arc_staff_spaces');
    _getNotationFermataDotToArcStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_fermata_dot_to_arc_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_fermata_dot_to_arc_staff_spaces');
    _setNotationFermataWidthStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_fermata_width_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_fermata_width_staff_spaces');
    _getNotationFermataWidthStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_fermata_width_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_fermata_width_staff_spaces');
    _setNotationFermataHeightStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_fermata_height_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_fermata_height_staff_spaces');
    _getNotationFermataHeightStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_fermata_height_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_fermata_height_staff_spaces');
    _setNotationFermataThicknessStartStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_fermata_thickness_start_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_fermata_thickness_start_staff_spaces');
    _getNotationFermataThicknessStartStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_fermata_thickness_start_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_fermata_thickness_start_staff_spaces');
    _setNotationFermataThicknessMidStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_fermata_thickness_mid_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_fermata_thickness_mid_staff_spaces');
    _getNotationFermataThicknessMidStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_fermata_thickness_mid_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_fermata_thickness_mid_staff_spaces');
    _setNotationFermataDotScale = _dylib.lookupFunction<mxml_options_set_notation_fermata_dot_scale_func, OptionsSetDouble>('mxml_options_set_notation_fermata_dot_scale');
    _getNotationFermataDotScale = _dylib.lookupFunction<mxml_options_get_notation_fermata_dot_scale_func, OptionsGetDouble>('mxml_options_get_notation_fermata_dot_scale');
    _setNotationOrnamentYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_ornament_y_offset_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_ornament_y_offset_staff_spaces');
    _getNotationOrnamentYOffsetStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_ornament_y_offset_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_ornament_y_offset_staff_spaces');
    _setNotationOrnamentStackGapStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_ornament_stack_gap_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_ornament_stack_gap_staff_spaces');
    _getNotationOrnamentStackGapStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_ornament_stack_gap_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_ornament_stack_gap_staff_spaces');
    _setNotationOrnamentFontSize = _dylib.lookupFunction<mxml_options_set_notation_ornament_font_size_func, OptionsSetDouble>('mxml_options_set_notation_ornament_font_size');
    _getNotationOrnamentFontSize = _dylib.lookupFunction<mxml_options_get_notation_ornament_font_size_func, OptionsGetDouble>('mxml_options_get_notation_ornament_font_size');
    _setNotationStaffDistanceStaffSpaces = _dylib.lookupFunction<mxml_options_set_notation_staff_distance_staff_spaces_func, OptionsSetDouble>('mxml_options_set_notation_staff_distance_staff_spaces');
    _getNotationStaffDistanceStaffSpaces = _dylib.lookupFunction<mxml_options_get_notation_staff_distance_staff_spaces_func, OptionsGetDouble>('mxml_options_get_notation_staff_distance_staff_spaces');
    _setColorsDarkMode = _dylib.lookupFunction<mxml_options_set_colors_dark_mode_func, OptionsSetBool>('mxml_options_set_colors_dark_mode');
    _getColorsDarkMode = _dylib.lookupFunction<mxml_options_get_colors_dark_mode_func, OptionsGetBool>('mxml_options_get_colors_dark_mode');
    _setColorsDefaultColorMusic = _dylib.lookupFunction<mxml_options_set_colors_default_color_music_func, OptionsSetString>('mxml_options_set_colors_default_color_music');
    _getColorsDefaultColorMusic = _dylib.lookupFunction<mxml_options_get_colors_default_color_music_func, OptionsGetString>('mxml_options_get_colors_default_color_music');
    _setColorsDefaultColorNotehead = _dylib.lookupFunction<mxml_options_set_colors_default_color_notehead_func, OptionsSetString>('mxml_options_set_colors_default_color_notehead');
    _getColorsDefaultColorNotehead = _dylib.lookupFunction<mxml_options_get_colors_default_color_notehead_func, OptionsGetString>('mxml_options_get_colors_default_color_notehead');
    _setColorsDefaultColorStem = _dylib.lookupFunction<mxml_options_set_colors_default_color_stem_func, OptionsSetString>('mxml_options_set_colors_default_color_stem');
    _getColorsDefaultColorStem = _dylib.lookupFunction<mxml_options_get_colors_default_color_stem_func, OptionsGetString>('mxml_options_get_colors_default_color_stem');
    _setColorsDefaultColorRest = _dylib.lookupFunction<mxml_options_set_colors_default_color_rest_func, OptionsSetString>('mxml_options_set_colors_default_color_rest');
    _getColorsDefaultColorRest = _dylib.lookupFunction<mxml_options_get_colors_default_color_rest_func, OptionsGetString>('mxml_options_get_colors_default_color_rest');
    _setColorsDefaultColorLabel = _dylib.lookupFunction<mxml_options_set_colors_default_color_label_func, OptionsSetString>('mxml_options_set_colors_default_color_label');
    _getColorsDefaultColorLabel = _dylib.lookupFunction<mxml_options_get_colors_default_color_label_func, OptionsGetString>('mxml_options_get_colors_default_color_label');
    _setColorsDefaultColorTitle = _dylib.lookupFunction<mxml_options_set_colors_default_color_title_func, OptionsSetString>('mxml_options_set_colors_default_color_title');
    _getColorsDefaultColorTitle = _dylib.lookupFunction<mxml_options_get_colors_default_color_title_func, OptionsGetString>('mxml_options_get_colors_default_color_title');
    _setColorsColoringEnabled = _dylib.lookupFunction<mxml_options_set_colors_coloring_enabled_func, OptionsSetBool>('mxml_options_set_colors_coloring_enabled');
    _getColorsColoringEnabled = _dylib.lookupFunction<mxml_options_get_colors_coloring_enabled_func, OptionsGetBool>('mxml_options_get_colors_coloring_enabled');
    _setColorsColoringMode = _dylib.lookupFunction<mxml_options_set_colors_coloring_mode_func, OptionsSetString>('mxml_options_set_colors_coloring_mode');
    _getColorsColoringMode = _dylib.lookupFunction<mxml_options_get_colors_coloring_mode_func, OptionsGetString>('mxml_options_get_colors_coloring_mode');
    _setColorsColorStemsLikeNoteheads = _dylib.lookupFunction<mxml_options_set_colors_color_stems_like_noteheads_func, OptionsSetBool>('mxml_options_set_colors_color_stems_like_noteheads');
    _getColorsColorStemsLikeNoteheads = _dylib.lookupFunction<mxml_options_get_colors_color_stems_like_noteheads_func, OptionsGetBool>('mxml_options_get_colors_color_stems_like_noteheads');
    _setColorsColoringSetCustom = _dylib.lookupFunction<mxml_options_set_colors_coloring_set_custom_func, OptionsSetStringList>('mxml_options_set_colors_coloring_set_custom');
    _getColorsColoringSetCustomCount = _dylib.lookupFunction<mxml_options_get_colors_coloring_set_custom_count_func, OptionsGetStringListCount>('mxml_options_get_colors_coloring_set_custom_count');
    _getColorsColoringSetCustomAt = _dylib.lookupFunction<mxml_options_get_colors_coloring_set_custom_at_func, OptionsGetStringListAt>('mxml_options_get_colors_coloring_set_custom_at');
    _setPerformanceEnableGlyphCache = _dylib.lookupFunction<mxml_options_set_performance_enable_glyph_cache_func, OptionsSetBool>('mxml_options_set_performance_enable_glyph_cache');
    _getPerformanceEnableGlyphCache = _dylib.lookupFunction<mxml_options_get_performance_enable_glyph_cache_func, OptionsGetBool>('mxml_options_get_performance_enable_glyph_cache');
    _setPerformanceEnableSpatialIndexing = _dylib.lookupFunction<mxml_options_set_performance_enable_spatial_indexing_func, OptionsSetBool>('mxml_options_set_performance_enable_spatial_indexing');
    _getPerformanceEnableSpatialIndexing = _dylib.lookupFunction<mxml_options_get_performance_enable_spatial_indexing_func, OptionsGetBool>('mxml_options_get_performance_enable_spatial_indexing');
    _setPerformanceSkyBottomLineBatchMinMeasures = _dylib.lookupFunction<mxml_options_set_performance_sky_bottom_line_batch_min_measures_func, OptionsSetInt>('mxml_options_set_performance_sky_bottom_line_batch_min_measures');
    _getPerformanceSkyBottomLineBatchMinMeasures = _dylib.lookupFunction<mxml_options_get_performance_sky_bottom_line_batch_min_measures_func, OptionsGetInt>('mxml_options_get_performance_sky_bottom_line_batch_min_measures');
    _setPerformanceSvgPrecision = _dylib.lookupFunction<mxml_options_set_performance_svg_precision_func, OptionsSetInt>('mxml_options_set_performance_svg_precision');
    _getPerformanceSvgPrecision = _dylib.lookupFunction<mxml_options_get_performance_svg_precision_func, OptionsGetInt>('mxml_options_get_performance_svg_precision');
    _setPerformanceBenchEnable = _dylib.lookupFunction<mxml_options_set_performance_bench_enable_func, OptionsSetBool>('mxml_options_set_performance_bench_enable');
    _getPerformanceBenchEnable = _dylib.lookupFunction<mxml_options_get_performance_bench_enable_func, OptionsGetBool>('mxml_options_get_performance_bench_enable');
    _setBackend = _dylib.lookupFunction<mxml_options_set_backend_func, OptionsSetString>('mxml_options_set_backend');
    _getBackend = _dylib.lookupFunction<mxml_options_get_backend_func, OptionsGetString>('mxml_options_get_backend');
    _setZoom = _dylib.lookupFunction<mxml_options_set_zoom_func, OptionsSetDouble>('mxml_options_set_zoom');
    _getZoom = _dylib.lookupFunction<mxml_options_get_zoom_func, OptionsGetDouble>('mxml_options_get_zoom');
    _setSheetMaximumWidth = _dylib.lookupFunction<mxml_options_set_sheet_maximum_width_func, OptionsSetDouble>('mxml_options_set_sheet_maximum_width');
    _getSheetMaximumWidth = _dylib.lookupFunction<mxml_options_get_sheet_maximum_width_func, OptionsGetDouble>('mxml_options_get_sheet_maximum_width');

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
