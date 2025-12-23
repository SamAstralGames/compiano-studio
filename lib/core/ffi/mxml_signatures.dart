import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'mxml_types.dart';

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
typedef mxml_get_render_commands_func = Pointer<MXMLRenderCommandC> Function(
  Pointer<MXMLHandle>,
  Pointer<Size>,
);
typedef MxmlGetRenderCommands = Pointer<MXMLRenderCommandC> Function(
  Pointer<MXMLHandle>,
  Pointer<Size>,
);

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

// Presets.
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

// Rendering Options (bool).
typedef mxml_options_set_rendering_draw_title_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_title_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_part_names_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_part_names_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_measure_numbers_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_measure_numbers_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_measure_numbers_only_at_system_start_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_measure_numbers_only_at_system_start_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_measure_numbers_begin_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_measure_numbers_begin_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_measure_number_interval_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_measure_number_interval_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_time_signatures_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_time_signatures_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_key_signatures_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_key_signatures_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_rendering_draw_fingerings_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_rendering_draw_fingerings_func =
    Int32 Function(Pointer<MXMLOptions>);
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

// Layout Options.
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
typedef mxml_options_set_layout_page_margin_left_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_left_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_margin_right_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_right_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_margin_top_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_top_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_page_margin_bottom_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_page_margin_bottom_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_system_spacing_min_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_system_spacing_min_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_system_spacing_multi_staff_min_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_layout_system_spacing_multi_staff_min_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_new_system_from_xml_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_layout_new_system_from_xml_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_new_page_from_xml_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_layout_new_page_from_xml_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_layout_fill_empty_measures_with_whole_rest_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_layout_fill_empty_measures_with_whole_rest_func =
    Int32 Function(Pointer<MXMLOptions>);

// Line Breaking Options.
typedef mxml_options_set_line_breaking_justification_ratio_min_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_min_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_max_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_max_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_target_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_target_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_soft_min_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_soft_min_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_justification_ratio_soft_max_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_justification_ratio_soft_max_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_ratio_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_ratio_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_tight_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_tight_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_loose_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_loose_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_last_under_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_last_under_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_cost_power_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_cost_power_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_stretch_last_system_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_stretch_last_system_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_last_line_max_underfill_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_last_line_max_underfill_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_target_measures_per_system_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_target_measures_per_system_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_weight_count_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_weight_count_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_final_bar_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_final_bar_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_double_bar_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_double_bar_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_phras_end_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_phras_end_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_bonus_rehearsal_mark_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_bonus_rehearsal_mark_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_hairpin_across_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_hairpin_across_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_slur_across_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_slur_across_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_lyrics_hyphen_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_lyrics_hyphen_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_tie_across_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_tie_across_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_clef_change_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_clef_change_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_key_time_change_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_key_time_change_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_penalty_tempo_text_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_line_breaking_penalty_tempo_text_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_enable_two_pass_optimization_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_enable_two_pass_optimization_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_enable_break_features_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_enable_break_features_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_enable_system_level_spacing_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_enable_system_level_spacing_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_line_breaking_max_measures_per_line_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_line_breaking_max_measures_per_line_func =
    Int32 Function(Pointer<MXMLOptions>);

// Notation Options.
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
typedef mxml_options_set_notation_set_wanted_stem_direction_by_xml_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_set_wanted_stem_direction_by_xml_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_slur_lift_sample_count_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_slur_lift_sample_count_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_position_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_notation_fingering_position_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_inside_stafflines_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_notation_fingering_inside_stafflines_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_y_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fingering_y_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fingering_font_size_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fingering_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_y_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_y_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_line_thickness_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_line_thickness_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_text_font_size_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_text_font_size_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_text_to_line_start_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_text_to_line_start_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_line_to_end_symbol_gap_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_line_to_end_symbol_gap_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_pedal_change_notch_height_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_pedal_change_notch_height_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_dynamics_y_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_dynamics_y_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_dynamics_font_size_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_dynamics_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_y_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_y_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_height_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_height_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_line_thickness_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_line_thickness_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_wedge_inset_from_ends_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_wedge_inset_from_ends_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_lyrics_y_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_lyrics_y_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_lyrics_font_size_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_lyrics_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_lyrics_hyphen_min_gap_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_lyrics_hyphen_min_gap_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_articulation_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_articulation_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_articulation_stack_gap_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_articulation_stack_gap_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_articulation_line_thickness_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_articulation_line_thickness_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_tenuto_length_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_tenuto_length_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_accent_width_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_accent_width_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_accent_height_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_accent_height_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_marcato_width_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_marcato_width_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_marcato_height_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_marcato_height_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_staccato_dot_scale_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_staccato_dot_scale_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_y_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_y_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_dot_to_arc_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_dot_to_arc_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_width_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_width_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_height_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_height_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_thickness_start_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_thickness_start_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_thickness_mid_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_thickness_mid_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_fermata_dot_scale_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_fermata_dot_scale_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_ornament_y_offset_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_ornament_y_offset_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_ornament_stack_gap_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_ornament_stack_gap_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_ornament_font_size_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_ornament_font_size_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_notation_staff_distance_staff_spaces_func =
    Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_notation_staff_distance_staff_spaces_func =
    Double Function(Pointer<MXMLOptions>);

// Color Options.
typedef mxml_options_set_colors_dark_mode_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_colors_dark_mode_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_music_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_music_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_notehead_func =
    Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_notehead_func =
    Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_stem_func =
    Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_stem_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_rest_func =
    Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_rest_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_label_func =
    Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_label_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_default_color_title_func =
    Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_default_color_title_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_coloring_enabled_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_colors_coloring_enabled_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_coloring_mode_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_colors_coloring_mode_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_color_stems_like_noteheads_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_colors_color_stems_like_noteheads_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_colors_coloring_set_custom_func =
    Void Function(Pointer<MXMLOptions>, Pointer<Pointer<Utf8>>, Size);
typedef mxml_options_get_colors_coloring_set_custom_count_func = Size Function(Pointer<MXMLOptions>);
typedef mxml_options_get_colors_coloring_set_custom_at_func =
    Pointer<Utf8> Function(Pointer<MXMLOptions>, Size);

// Performance Options.
typedef mxml_options_set_performance_enable_glyph_cache_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_enable_glyph_cache_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_enable_spatial_indexing_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_enable_spatial_indexing_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_sky_bottom_line_batch_min_measures_func =
    Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_sky_bottom_line_batch_min_measures_func =
    Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_svg_precision_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_svg_precision_func = Int32 Function(Pointer<MXMLOptions>);
typedef mxml_options_set_performance_bench_enable_func = Void Function(Pointer<MXMLOptions>, Int32);
typedef mxml_options_get_performance_bench_enable_func = Int32 Function(Pointer<MXMLOptions>);

// Global Options.
typedef mxml_options_set_backend_func = Void Function(Pointer<MXMLOptions>, Pointer<Utf8>);
typedef mxml_options_get_backend_func = Pointer<Utf8> Function(Pointer<MXMLOptions>);
typedef mxml_options_set_zoom_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_zoom_func = Double Function(Pointer<MXMLOptions>);
typedef mxml_options_set_sheet_maximum_width_func = Void Function(Pointer<MXMLOptions>, Double);
typedef mxml_options_get_sheet_maximum_width_func = Double Function(Pointer<MXMLOptions>);

// Layout with options.
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
