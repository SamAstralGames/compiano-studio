#ifndef MXML_C_API_H
#define MXML_C_API_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * mXMLConverter C API
 * Expose le moteur de rendu mXML pour une utilisation native (Dart FFI, JNI, etc.)
 */

// Handles opaques
typedef struct mXMLHandle mXMLHandle;
typedef struct mxml_options mxml_options;

// Types de base
typedef uint32_t mXMLStringId;
typedef uint16_t mXMLGlyphId;

typedef struct {
    float x;
    float y;
} mXMLPointC;

typedef struct {
    float x;
    float y;
    float width;
    float height;
} mXMLRectC;

// Structures de données des commandes (Layout binaire identique au C++)
typedef struct {
    mXMLGlyphId id;
    mXMLPointC pos;
    float scale;
} mXMLGlyphDataC;

typedef struct {
    mXMLPointC p1;
    mXMLPointC p2;
    float thickness;
} mXMLLineDataC;

typedef struct {
    mXMLStringId textId;
    mXMLPointC pos;
    float fontSize;
    int8_t italic; // bool en C++8 (POD)
} mXMLTextDataC;

typedef struct {
    mXMLRectC rect;
    mXMLStringId cssClassId;
    mXMLStringId strokeId;
    float strokeWidth;
    mXMLStringId fillId;
    float opacity;
} mXMLDebugRectDataC;

typedef struct {
    mXMLStringId dId;
    mXMLStringId cssClassId;
    mXMLStringId fillId;
    float opacity;
} mXMLPathDataC;

typedef enum {
    MXML_GLYPH = 0,
    MXML_LINE = 1,
    MXML_TEXT = 2,
    MXML_DEBUG_RECT = 3,
    MXML_PATH = 4
} mXMLRenderCommandTypeC;

typedef struct {
    uint8_t type; // mXMLRenderCommandTypeC
    union {
        mXMLGlyphDataC glyph;
        mXMLLineDataC line;
        mXMLTextDataC text;
        mXMLDebugRectDataC debugRect;
        mXMLPathDataC path;
    };
} mXMLRenderCommandC;

// Benchmarks pipeline (millisecondes), regroupés par layer.
typedef struct {
    float inputXmlLoadMs;
    float inputModelBuildMs;
    float inputTotalMs;
    float layoutMetricsMs;
    float layoutLineBreakingMs;
    float layoutTotalMs;
    float renderCommandsMs;
    float exportSerializeSvgMs;
    float pipelineTotalMs;
} mXMLPipelineBenchC;

// --- Fonctions de Cycle de Vie ---

mXMLHandle* mxml_create();
void mxml_destroy(mXMLHandle* handle);

// --- Fonctions de Traitement ---

// Charge un fichier MusicXML
// Retourne 1 si succès, 0 sinon.
int mxml_load_file(mXMLHandle* handle, const char* path);

// Execute le layout avec une largeur cible
void mxml_layout(mXMLHandle* handle, float width);

// Récupère la hauteur totale calculée lors du dernier layout
float mxml_get_height(mXMLHandle* handle);

// Récupère le codepoint SMuFL (UTF-32) pour un ID de glyphe donné
// Retourne 0 si non trouvé.
uint32_t mxml_get_glyph_codepoint(mXMLHandle* handle, mXMLGlyphId id);

// --- Accès aux données ---

// Récupère le pointeur vers le buffer de commandes (Zero-Copy)
// Le nombre de commandes est écrit dans count.
// Le pointeur reste valide jusqu'au prochain appel à mxml_layout ou mxml_destroy.
const mXMLRenderCommandC* mxml_get_render_commands(mXMLHandle* handle, size_t* count);

// Récupère une chaîne du StringPool par son ID
const char* mxml_get_string(mXMLHandle* handle, mXMLStringId id);

// --- Export ---

// Génère le code SVG complet pour la partition actuelle.
// Retourne une chaîne allouée qu'il faut libérer avec mxml_free_string (à ajouter) ou qui est gérée par le contexte ?
// Pour faire simple et éviter les fuites : on retourne un const char* géré par le handle (buffer interne temporaire) ou on écrit dans un fichier.
// Option choisie : écrire dans un fichier pour le "Download".
int mxml_write_svg_to_file(mXMLHandle* handle, const char* filepath);

// Récupère les métriques du pipeline pour le dernier traitement.
// Le pointeur reste valide tant que le handle est vivant.
const mXMLPipelineBenchC* mxml_get_pipeline_bench(mXMLHandle* handle);
// --- Options ---

// Crée une instance d'options avec les valeurs Standard
mxml_options* mxml_options_create();

// Détruit une instance d'options
void mxml_options_destroy(mxml_options* opts);

// --- Presets ---

void mxml_options_apply_standard(mxml_options* opts);
void mxml_options_apply_piano(mxml_options* opts);
void mxml_options_apply_piano_pedagogic(mxml_options* opts);
void mxml_options_apply_compact(mxml_options* opts);
void mxml_options_apply_print(mxml_options* opts);

// --- Rendering Options ---

void mxml_options_set_rendering_draw_title(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_title(const mxml_options* opts);

void mxml_options_set_rendering_draw_part_names(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_part_names(const mxml_options* opts);

void mxml_options_set_rendering_draw_measure_numbers(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_measure_numbers(const mxml_options* opts);

void mxml_options_set_rendering_draw_measure_numbers_only_at_system_start(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_measure_numbers_only_at_system_start(const mxml_options* opts);

void mxml_options_set_rendering_draw_measure_numbers_begin(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_measure_numbers_begin(const mxml_options* opts);

void mxml_options_set_rendering_measure_number_interval(mxml_options* opts, int value);
int mxml_options_get_rendering_measure_number_interval(const mxml_options* opts);

void mxml_options_set_rendering_draw_time_signatures(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_time_signatures(const mxml_options* opts);

void mxml_options_set_rendering_draw_key_signatures(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_key_signatures(const mxml_options* opts);

void mxml_options_set_rendering_draw_fingerings(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_fingerings(const mxml_options* opts);

void mxml_options_set_rendering_draw_slurs(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_slurs(const mxml_options* opts);

void mxml_options_set_rendering_draw_pedals(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_pedals(const mxml_options* opts);

void mxml_options_set_rendering_draw_dynamics(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_dynamics(const mxml_options* opts);

void mxml_options_set_rendering_draw_wedges(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_wedges(const mxml_options* opts);

void mxml_options_set_rendering_draw_lyrics(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_lyrics(const mxml_options* opts);

void mxml_options_set_rendering_draw_credits(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_credits(const mxml_options* opts);

void mxml_options_set_rendering_draw_composer(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_composer(const mxml_options* opts);

void mxml_options_set_rendering_draw_lyricist(mxml_options* opts, int value);
int mxml_options_get_rendering_draw_lyricist(const mxml_options* opts);

// --- Layout Options ---

void mxml_options_set_layout_page_format(mxml_options* opts, const char* value);
const char* mxml_options_get_layout_page_format(const mxml_options* opts);

void mxml_options_set_layout_use_fixed_canvas(mxml_options* opts, int value);
int mxml_options_get_layout_use_fixed_canvas(const mxml_options* opts);

void mxml_options_set_layout_fixed_canvas_width(mxml_options* opts, double value);
double mxml_options_get_layout_fixed_canvas_width(const mxml_options* opts);

void mxml_options_set_layout_fixed_canvas_height(mxml_options* opts, double value);
double mxml_options_get_layout_fixed_canvas_height(const mxml_options* opts);

void mxml_options_set_layout_page_height(mxml_options* opts, double value);
double mxml_options_get_layout_page_height(const mxml_options* opts);

void mxml_options_set_layout_page_margin_left_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_layout_page_margin_left_staff_spaces(const mxml_options* opts);

void mxml_options_set_layout_page_margin_right_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_layout_page_margin_right_staff_spaces(const mxml_options* opts);

void mxml_options_set_layout_page_margin_top_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_layout_page_margin_top_staff_spaces(const mxml_options* opts);

void mxml_options_set_layout_page_margin_bottom_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_layout_page_margin_bottom_staff_spaces(const mxml_options* opts);

void mxml_options_set_layout_system_spacing_min_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_layout_system_spacing_min_staff_spaces(const mxml_options* opts);

void mxml_options_set_layout_system_spacing_multi_staff_min_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_layout_system_spacing_multi_staff_min_staff_spaces(const mxml_options* opts);

void mxml_options_set_layout_new_system_from_xml(mxml_options* opts, int value);
int mxml_options_get_layout_new_system_from_xml(const mxml_options* opts);

void mxml_options_set_layout_new_page_from_xml(mxml_options* opts, int value);
int mxml_options_get_layout_new_page_from_xml(const mxml_options* opts);

void mxml_options_set_layout_fill_empty_measures_with_whole_rest(mxml_options* opts, int value);
int mxml_options_get_layout_fill_empty_measures_with_whole_rest(const mxml_options* opts);

// --- Line Breaking Options ---

void mxml_options_set_line_breaking_justification_ratio_min(mxml_options* opts, double value);
double mxml_options_get_line_breaking_justification_ratio_min(const mxml_options* opts);

void mxml_options_set_line_breaking_justification_ratio_max(mxml_options* opts, double value);
double mxml_options_get_line_breaking_justification_ratio_max(const mxml_options* opts);

void mxml_options_set_line_breaking_justification_ratio_target(mxml_options* opts, double value);
double mxml_options_get_line_breaking_justification_ratio_target(const mxml_options* opts);

void mxml_options_set_line_breaking_justification_ratio_soft_min(mxml_options* opts, double value);
double mxml_options_get_line_breaking_justification_ratio_soft_min(const mxml_options* opts);

void mxml_options_set_line_breaking_justification_ratio_soft_max(mxml_options* opts, double value);
double mxml_options_get_line_breaking_justification_ratio_soft_max(const mxml_options* opts);

void mxml_options_set_line_breaking_weight_ratio(mxml_options* opts, double value);
double mxml_options_get_line_breaking_weight_ratio(const mxml_options* opts);

void mxml_options_set_line_breaking_weight_tight(mxml_options* opts, double value);
double mxml_options_get_line_breaking_weight_tight(const mxml_options* opts);

void mxml_options_set_line_breaking_weight_loose(mxml_options* opts, double value);
double mxml_options_get_line_breaking_weight_loose(const mxml_options* opts);

void mxml_options_set_line_breaking_weight_last_under(mxml_options* opts, double value);
double mxml_options_get_line_breaking_weight_last_under(const mxml_options* opts);

void mxml_options_set_line_breaking_cost_power(mxml_options* opts, double value);
double mxml_options_get_line_breaking_cost_power(const mxml_options* opts);

void mxml_options_set_line_breaking_stretch_last_system(mxml_options* opts, int value);
int mxml_options_get_line_breaking_stretch_last_system(const mxml_options* opts);

void mxml_options_set_line_breaking_last_line_max_underfill(mxml_options* opts, double value);
double mxml_options_get_line_breaking_last_line_max_underfill(const mxml_options* opts);

void mxml_options_set_line_breaking_target_measures_per_system(mxml_options* opts, int value);
int mxml_options_get_line_breaking_target_measures_per_system(const mxml_options* opts);

void mxml_options_set_line_breaking_weight_count(mxml_options* opts, double value);
double mxml_options_get_line_breaking_weight_count(const mxml_options* opts);

void mxml_options_set_line_breaking_bonus_final_bar(mxml_options* opts, double value);
double mxml_options_get_line_breaking_bonus_final_bar(const mxml_options* opts);

void mxml_options_set_line_breaking_bonus_double_bar(mxml_options* opts, double value);
double mxml_options_get_line_breaking_bonus_double_bar(const mxml_options* opts);

void mxml_options_set_line_breaking_bonus_phras_end(mxml_options* opts, double value);
double mxml_options_get_line_breaking_bonus_phras_end(const mxml_options* opts);

void mxml_options_set_line_breaking_bonus_rehearsal_mark(mxml_options* opts, double value);
double mxml_options_get_line_breaking_bonus_rehearsal_mark(const mxml_options* opts);

void mxml_options_set_line_breaking_penalty_hairpin_across(mxml_options* opts, double value);
double mxml_options_get_line_breaking_penalty_hairpin_across(const mxml_options* opts);

void mxml_options_set_line_breaking_penalty_slur_across(mxml_options* opts, double value);
double mxml_options_get_line_breaking_penalty_slur_across(const mxml_options* opts);

void mxml_options_set_line_breaking_penalty_lyrics_hyphen(mxml_options* opts, double value);
double mxml_options_get_line_breaking_penalty_lyrics_hyphen(const mxml_options* opts);

void mxml_options_set_line_breaking_penalty_tie_across(mxml_options* opts, double value);
double mxml_options_get_line_breaking_penalty_tie_across(const mxml_options* opts);

void mxml_options_set_line_breaking_penalty_clef_change(mxml_options* opts, double value);
double mxml_options_get_line_breaking_penalty_clef_change(const mxml_options* opts);

void mxml_options_set_line_breaking_penalty_key_time_change(mxml_options* opts, double value);
double mxml_options_get_line_breaking_penalty_key_time_change(const mxml_options* opts);

void mxml_options_set_line_breaking_penalty_tempo_text(mxml_options* opts, double value);
double mxml_options_get_line_breaking_penalty_tempo_text(const mxml_options* opts);

void mxml_options_set_line_breaking_enable_two_pass_optimization(mxml_options* opts, int value);
int mxml_options_get_line_breaking_enable_two_pass_optimization(const mxml_options* opts);

void mxml_options_set_line_breaking_enable_break_features(mxml_options* opts, int value);
int mxml_options_get_line_breaking_enable_break_features(const mxml_options* opts);

void mxml_options_set_line_breaking_max_measures_per_line(mxml_options* opts, int value);
int mxml_options_get_line_breaking_max_measures_per_line(const mxml_options* opts);

// --- Notation Options ---

void mxml_options_set_notation_auto_beam(mxml_options* opts, int value);
int mxml_options_get_notation_auto_beam(const mxml_options* opts);

void mxml_options_set_notation_tuplets_bracketed(mxml_options* opts, int value);
int mxml_options_get_notation_tuplets_bracketed(const mxml_options* opts);

void mxml_options_set_notation_triplets_bracketed(mxml_options* opts, int value);
int mxml_options_get_notation_triplets_bracketed(const mxml_options* opts);

void mxml_options_set_notation_tuplets_ratioed(mxml_options* opts, int value);
int mxml_options_get_notation_tuplets_ratioed(const mxml_options* opts);

void mxml_options_set_notation_align_rests(mxml_options* opts, int value);
int mxml_options_get_notation_align_rests(const mxml_options* opts);

void mxml_options_set_notation_set_wanted_stem_direction_by_xml(mxml_options* opts, int value);
int mxml_options_get_notation_set_wanted_stem_direction_by_xml(const mxml_options* opts);

void mxml_options_set_notation_slur_lift_sample_count(mxml_options* opts, int value);
int mxml_options_get_notation_slur_lift_sample_count(const mxml_options* opts);

void mxml_options_set_notation_fingering_position(mxml_options* opts, const char* value);
const char* mxml_options_get_notation_fingering_position(const mxml_options* opts);

void mxml_options_set_notation_fingering_inside_stafflines(mxml_options* opts, int value);
int mxml_options_get_notation_fingering_inside_stafflines(const mxml_options* opts);

void mxml_options_set_notation_fingering_y_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_fingering_y_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_fingering_font_size(mxml_options* opts, double value);
double mxml_options_get_notation_fingering_font_size(const mxml_options* opts);

void mxml_options_set_notation_pedal_y_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_pedal_y_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_pedal_line_thickness_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_pedal_line_thickness_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_pedal_text_font_size(mxml_options* opts, double value);
double mxml_options_get_notation_pedal_text_font_size(const mxml_options* opts);

void mxml_options_set_notation_pedal_text_to_line_start_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_pedal_text_to_line_start_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_pedal_line_to_end_symbol_gap_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_pedal_line_to_end_symbol_gap_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_pedal_change_notch_height_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_pedal_change_notch_height_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_dynamics_y_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_dynamics_y_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_dynamics_font_size(mxml_options* opts, double value);
double mxml_options_get_notation_dynamics_font_size(const mxml_options* opts);

void mxml_options_set_notation_wedge_y_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_wedge_y_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_wedge_height_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_wedge_height_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_wedge_line_thickness_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_wedge_line_thickness_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_wedge_inset_from_ends_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_wedge_inset_from_ends_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_lyrics_y_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_lyrics_y_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_lyrics_font_size(mxml_options* opts, double value);
double mxml_options_get_notation_lyrics_font_size(const mxml_options* opts);

void mxml_options_set_notation_lyrics_hyphen_min_gap_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_lyrics_hyphen_min_gap_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_articulation_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_articulation_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_articulation_stack_gap_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_articulation_stack_gap_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_articulation_line_thickness_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_articulation_line_thickness_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_tenuto_length_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_tenuto_length_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_accent_width_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_accent_width_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_accent_height_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_accent_height_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_marcato_width_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_marcato_width_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_marcato_height_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_marcato_height_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_staccato_dot_scale(mxml_options* opts, double value);
double mxml_options_get_notation_staccato_dot_scale(const mxml_options* opts);

void mxml_options_set_notation_fermata_y_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_fermata_y_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_fermata_dot_to_arc_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_fermata_dot_to_arc_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_fermata_width_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_fermata_width_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_fermata_height_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_fermata_height_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_fermata_thickness_start_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_fermata_thickness_start_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_fermata_thickness_mid_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_fermata_thickness_mid_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_fermata_dot_scale(mxml_options* opts, double value);
double mxml_options_get_notation_fermata_dot_scale(const mxml_options* opts);

void mxml_options_set_notation_ornament_y_offset_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_ornament_y_offset_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_ornament_stack_gap_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_ornament_stack_gap_staff_spaces(const mxml_options* opts);

void mxml_options_set_notation_ornament_font_size(mxml_options* opts, double value);
double mxml_options_get_notation_ornament_font_size(const mxml_options* opts);

void mxml_options_set_notation_staff_distance_staff_spaces(mxml_options* opts, double value);
double mxml_options_get_notation_staff_distance_staff_spaces(const mxml_options* opts);

// --- Color Options ---

void mxml_options_set_colors_dark_mode(mxml_options* opts, int value);
int mxml_options_get_colors_dark_mode(const mxml_options* opts);

void mxml_options_set_colors_default_color_music(mxml_options* opts, const char* value);
const char* mxml_options_get_colors_default_color_music(const mxml_options* opts);

void mxml_options_set_colors_default_color_notehead(mxml_options* opts, const char* value);
const char* mxml_options_get_colors_default_color_notehead(const mxml_options* opts);

void mxml_options_set_colors_default_color_stem(mxml_options* opts, const char* value);
const char* mxml_options_get_colors_default_color_stem(const mxml_options* opts);

void mxml_options_set_colors_default_color_rest(mxml_options* opts, const char* value);
const char* mxml_options_get_colors_default_color_rest(const mxml_options* opts);

void mxml_options_set_colors_default_color_label(mxml_options* opts, const char* value);
const char* mxml_options_get_colors_default_color_label(const mxml_options* opts);

void mxml_options_set_colors_default_color_title(mxml_options* opts, const char* value);
const char* mxml_options_get_colors_default_color_title(const mxml_options* opts);

void mxml_options_set_colors_coloring_enabled(mxml_options* opts, int value);
int mxml_options_get_colors_coloring_enabled(const mxml_options* opts);

void mxml_options_set_colors_coloring_mode(mxml_options* opts, const char* value);
const char* mxml_options_get_colors_coloring_mode(const mxml_options* opts);

void mxml_options_set_colors_color_stems_like_noteheads(mxml_options* opts, int value);
int mxml_options_get_colors_color_stems_like_noteheads(const mxml_options* opts);

// Note: coloringSetCustom (vector) nécessite une API spéciale
void mxml_options_set_colors_coloring_set_custom(mxml_options* opts, const char** colors, size_t count);
size_t mxml_options_get_colors_coloring_set_custom_count(const mxml_options* opts);
const char* mxml_options_get_colors_coloring_set_custom_at(const mxml_options* opts, size_t index);

// --- Performance Options ---

void mxml_options_set_performance_enable_glyph_cache(mxml_options* opts, int value);
int mxml_options_get_performance_enable_glyph_cache(const mxml_options* opts);

void mxml_options_set_performance_enable_spatial_indexing(mxml_options* opts, int value);
int mxml_options_get_performance_enable_spatial_indexing(const mxml_options* opts);

void mxml_options_set_performance_sky_bottom_line_batch_min_measures(mxml_options* opts, int value);
int mxml_options_get_performance_sky_bottom_line_batch_min_measures(const mxml_options* opts);

void mxml_options_set_performance_svg_precision(mxml_options* opts, int value);
int mxml_options_get_performance_svg_precision(const mxml_options* opts);

void mxml_options_set_performance_bench_enable(mxml_options* opts, int value);
int mxml_options_get_performance_bench_enable(const mxml_options* opts);

// --- Global Options ---

void mxml_options_set_backend(mxml_options* opts, const char* value);
const char* mxml_options_get_backend(const mxml_options* opts);

void mxml_options_set_zoom(mxml_options* opts, double value);
double mxml_options_get_zoom(const mxml_options* opts);

void mxml_options_set_sheet_maximum_width(mxml_options* opts, double value);
double mxml_options_get_sheet_maximum_width(const mxml_options* opts);

// --- Layout avec options ---

// Nouvelle version avec options personnalisées
void mxml_layout_with_options(mXMLHandle* handle, float width, const mxml_options* opts);

#ifdef __cplusplus
}
#endif

#endif // MXML_C_API_H
