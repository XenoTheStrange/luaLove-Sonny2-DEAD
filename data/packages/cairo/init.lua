-- Lib cairo bind
--
local ffi = require('ffi')
local libcairo = ffi.load('cairo')

-- Pre Define
ffi.cdef[[
// Fix for cairo_surface_write_to_png_stream
typedef void (*cairo_write_func_t)(void *closure, const unsigned char *data, unsigned int length);

// Define version information
int cairo_version(void);
const char * cairo_version_string(void);
]]

-- Define cairo.h
require('cairo-luajit-ffi.src.cairo_h')
-- Define cairo-pdf.h
require('cairo-luajit-ffi.src.cairo-pdf_h')
-- Define cairo-svg.h
require('cairo-luajit-ffi.src.cairo-svg_h')
-- Define cairo-ps.h
require('cairo-luajit-ffi.src.cairo-ps_h')
-- Define cairo-tee.h
require('cairo-luajit-ffi.src.cairo-tee_h')

local cairo = {
  lib = libcairo
}

do -- Version
  cairo.version = libcairo.cairo_version
  cairo.version_string = function ()
    return ffi.string(libcairo.cairo_version_string())
  end
end

do -- Drawing
  --
  -- cairo_t
  --
  cairo.create = libcairo.cairo_create
  cairo.reference = libcairo.cairo_reference
  cairo.destroy = libcairo.cairo_destroy
  cairo.status = libcairo.cairo_status
  cairo.save = libcairo.cairo_save
  cairo.restore = libcairo.cairo_restore
  cairo.get_target = libcairo.cairo_get_target
  cairo.push_group = libcairo.cairo_push_group
  cairo.push_group_with_content = libcairo.cairo_push_group_with_content
  cairo.pop_group = libcairo.cairo_pop_group
  cairo.pop_group_to_source = libcairo.cairo_pop_group_to_source
  cairo.get_group_target = libcairo.cairo_get_group_target
  cairo.set_source_rgb = libcairo.cairo_set_source_rgb
  cairo.set_source_rgba = libcairo.cairo_set_source_rgba
  cairo.set_source = libcairo.cairo_set_source
  cairo.set_source_surface = libcairo.cairo_set_source_surface
  cairo.get_source = libcairo.cairo_get_source
  cairo.set_antialias = libcairo.cairo_set_antialias
  cairo.get_antialias = libcairo.cairo_get_antialias

  cairo.set_dash = function(cr, dashes, offset)
    return libcairo.cairo_set_dash(cr, ffi.new("double[?]", #dashes, dashes), #dashes, offset)
  end

  cairo.get_dash_count = libcairo.cairo_get_dash_count
  cairo.get_dash = libcairo.cairo_get_dash
  cairo.set_fill_rule = libcairo.cairo_set_fill_rule
  cairo.get_fill_rule = libcairo.cairo_get_fill_rule
  cairo.set_line_cap = libcairo.cairo_set_line_cap
  cairo.get_line_cap = libcairo.cairo_get_line_cap
  cairo.set_line_join = libcairo.cairo_set_line_join
  cairo.get_line_join = libcairo.cairo_get_line_join
  cairo.set_line_width = libcairo.cairo_set_line_width
  cairo.get_line_width = libcairo.cairo_get_line_width
  cairo.set_miter_limit = libcairo.cairo_set_miter_limit
  cairo.get_miter_limit = libcairo.cairo_get_miter_limit
  cairo.set_operator = libcairo.cairo_set_operator
  cairo.get_operator = libcairo.cairo_get_operator
  cairo.set_tolerance = libcairo.cairo_set_tolerance
  cairo.get_tolerance = libcairo.cairo_get_tolerance
  cairo.clip = libcairo.cairo_clip
  cairo.clip_preserve = libcairo.cairo_clip_preserve
  cairo.clip_extents = libcairo.cairo_clip_extents
  cairo.in_clip = libcairo.cairo_in_clip
  cairo.reset_clip = libcairo.cairo_reset_clip
  cairo.rectangle_list_destroy = libcairo.cairo_rectangle_list_destroy
  cairo.copy_clip_rectangle_list = libcairo.cairo_copy_clip_rectangle_list
  cairo.fill = libcairo.cairo_fill
  cairo.fill_preserve = libcairo.cairo_fill_preserve
  cairo.fill_extents = libcairo.cairo_fill_extents
  cairo.in_fill = libcairo.cairo_in_fill
  cairo.mask = libcairo.cairo_mask
  cairo.mask_surface = libcairo.cairo_mask_surface
  cairo.paint = libcairo.cairo_paint
  cairo.paint_with_alpha = libcairo.cairo_paint_with_alpha
  cairo.stroke = libcairo.cairo_stroke
  cairo.stroke_preserve = libcairo.cairo_stroke_preserve
  cairo.stroke_extents = libcairo.cairo_stroke_extents
  cairo.in_stroke = libcairo.cairo_in_stroke
  cairo.copy_page = libcairo.cairo_copy_page
  cairo.show_page = libcairo.cairo_show_page
  cairo.get_reference_count = libcairo.cairo_get_reference_count
  cairo.set_user_data = libcairo.cairo_set_user_data
  cairo.get_user_data = libcairo.cairo_get_user_data

  if libcairo.cairo_version() >= 11800 then
    cairo.set_hairline = libcairo.cairo_set_hairline
    cairo.get_hairline = libcairo.cairo_get_hairline
  end

  --
  -- Paths
  --
  cairo.copy_path = libcairo.cairo_copy_path
  cairo.copy_path_flat = libcairo.cairo_copy_path_flat
  cairo.path_destroy = libcairo.cairo_path_destroy
  cairo.append_path = libcairo.cairo_append_path
  cairo.has_current_point = libcairo.cairo_has_current_point
  cairo.get_current_point = libcairo.cairo_get_current_point
  cairo.new_path = libcairo.cairo_new_path
  cairo.new_sub_path = libcairo.cairo_new_sub_path
  cairo.close_path = libcairo.cairo_close_path
  cairo.arc = libcairo.cairo_arc
  cairo.arc_negative = libcairo.cairo_arc_negative
  cairo.curve_to = libcairo.cairo_curve_to
  cairo.line_to = libcairo.cairo_line_to
  cairo.move_to = libcairo.cairo_move_to
  cairo.rectangle = libcairo.cairo_rectangle
  cairo.glyph_path = libcairo.cairo_glyph_path
  cairo.text_path = libcairo.cairo_text_path
  cairo.rel_curve_to = libcairo.cairo_rel_curve_to
  cairo.rel_line_to = libcairo.cairo_rel_line_to
  cairo.rel_move_to = libcairo.cairo_rel_move_to
  cairo.path_extents = libcairo.cairo_path_extents

  --
  -- cairo_pattern_t
  --
  cairo.pattern_add_color_stop_rgb = libcairo. cairo_pattern_add_color_stop_rgb
  cairo.pattern_add_color_stop_rgba = libcairo.cairo_pattern_add_color_stop_rgba
  cairo.pattern_get_color_stop_count = libcairo.cairo_pattern_get_color_stop_count
  cairo.pattern_get_color_stop_rgba = libcairo.cairo_pattern_get_color_stop_rgba
  cairo.pattern_create_rgb = libcairo.cairo_pattern_create_rgb
  cairo.pattern_create_rgba = libcairo.cairo_pattern_create_rgba
  cairo.pattern_get_rgba = libcairo.cairo_pattern_get_rgba
  cairo.pattern_create_for_surface = libcairo.cairo_pattern_create_for_surface
  cairo.pattern_get_surface = libcairo.cairo_pattern_get_surface
  cairo.pattern_create_linear = libcairo.cairo_pattern_create_linear
  cairo.pattern_get_linear_points = libcairo.cairo_pattern_get_linear_points
  cairo.pattern_create_radial = libcairo.cairo_pattern_create_radial
  cairo.pattern_get_radial_circles = libcairo.cairo_pattern_get_radial_circles
  cairo.pattern_create_mesh = libcairo.cairo_pattern_create_mesh
  cairo.mesh_pattern_begin_patch = libcairo.cairo_mesh_pattern_begin_patch
  cairo.mesh_pattern_end_patch = libcairo.cairo_mesh_pattern_end_patch
  cairo.mesh_pattern_move_to = libcairo.cairo_mesh_pattern_move_to
  cairo.mesh_pattern_line_to = libcairo.cairo_mesh_pattern_line_to
  cairo.mesh_pattern_curve_to = libcairo.cairo_mesh_pattern_curve_to
  cairo.mesh_pattern_set_control_point = libcairo.cairo_mesh_pattern_set_control_point
  cairo.mesh_pattern_set_corner_color_rgb = libcairo.cairo_mesh_pattern_set_corner_color_rgb
  cairo.mesh_pattern_set_corner_color_rgba = libcairo.cairo_mesh_pattern_set_corner_color_rgba
  cairo.mesh_pattern_get_patch_count = libcairo.cairo_mesh_pattern_get_patch_count
  cairo.mesh_pattern_get_path = libcairo.cairo_mesh_pattern_get_path
  cairo.mesh_pattern_get_control_point = libcairo.cairo_mesh_pattern_get_control_point
  cairo.mesh_pattern_get_corner_color_rgba = libcairo.cairo_mesh_pattern_get_corner_color_rgba
  cairo.pattern_reference = libcairo.cairo_pattern_reference
  cairo.pattern_destroy = libcairo.cairo_pattern_destroy
  cairo.pattern_status = libcairo.cairo_pattern_status
  cairo.pattern_set_extend = libcairo.cairo_pattern_set_extend
  cairo.pattern_get_extend = libcairo.cairo_pattern_get_extend
  cairo.pattern_set_filter = libcairo.cairo_pattern_set_filter
  cairo.pattern_get_filter = libcairo.cairo_pattern_get_filter
  cairo.pattern_set_matrix = libcairo.cairo_pattern_set_matrix
  cairo.pattern_get_matrix = libcairo.cairo_pattern_get_matrix
  cairo.pattern_get_type = libcairo.cairo_pattern_get_type
  cairo.pattern_get_reference_count = libcairo.cairo_pattern_get_reference_count
  cairo.pattern_set_user_data = libcairo.cairo_pattern_set_user_data
  cairo.pattern_get_user_data = libcairo.cairo_pattern_get_user_data

  if libcairo.cairo_version() >= 11800 then
    cairo.pattern_set_dither = libcairo.cairo_pattern_set_dither
    cairo.pattern_get_dither = libcairo.cairo_pattern_get_dither
  end

  --
  -- Regions
  --
  cairo.region_create = libcairo.cairo_region_create
  cairo.region_create_rectangle = libcairo.cairo_region_create_rectangle
  cairo.region_create_rectangles = libcairo.cairo_region_create_rectangles
  cairo.region_copy = libcairo.cairo_region_copy
  cairo.region_reference = libcairo.cairo_region_reference
  cairo.region_destroy = libcairo.cairo_region_destroy
  cairo.region_status = libcairo.cairo_region_status
  cairo.region_get_extents = libcairo.cairo_region_get_extents
  cairo.region_num_rectangles = libcairo.cairo_region_num_rectangles
  cairo.region_get_rectangle = libcairo.cairo_region_get_rectangle
  cairo.region_is_empty = libcairo.cairo_region_is_empty
  cairo.region_contains_point = libcairo.cairo_region_contains_point
  cairo.region_contains_rectangle = libcairo.cairo_region_contains_rectangle
  cairo.region_equal = libcairo.cairo_region_equal
  cairo.region_translate = libcairo.cairo_region_translate
  cairo.region_intersect = libcairo.cairo_region_intersect
  cairo.region_intersect_rectangle = libcairo.cairo_region_intersect_rectangle
  cairo.region_subtract = libcairo.cairo_region_subtract
  cairo.region_subtract_rectangle = libcairo.cairo_region_subtract_rectangle
  cairo.region_union = libcairo.cairo_region_union
  cairo.region_union_rectangle = libcairo.cairo_region_union_rectangle
  cairo.region_xor = libcairo.cairo_region_xor
  cairo.region_xor_rectangle = libcairo.cairo_region_xor_rectangle

  --
  -- Transformations
  --
  cairo.translate = libcairo.cairo_translate
  cairo.scale = libcairo.cairo_scale
  cairo.rotate = libcairo.cairo_rotate
  cairo.transform = libcairo.cairo_transform
  cairo.set_matrix = libcairo.cairo_set_matrix
  cairo.get_matrix = libcairo.cairo_get_matrix
  cairo.identity_matrix = libcairo.cairo_identity_matrix
  cairo.user_to_device = libcairo.cairo_user_to_device
  cairo.user_to_device_distance = libcairo.cairo_user_to_device_distance
  cairo.device_to_user = libcairo.cairo_device_to_user
  cairo.device_to_user_distance = libcairo.cairo_device_to_user_distance

  --
  -- text
  --
  cairo.select_font_face = libcairo.cairo_select_font_face
  cairo.set_font_size = libcairo.cairo_set_font_size
  cairo.set_font_matrix = libcairo.cairo_set_font_matrix
  cairo.get_font_matrix = libcairo.cairo_get_font_matrix
  cairo.set_font_options = libcairo.cairo_set_font_options
  cairo.get_font_options = libcairo.cairo_get_font_options
  cairo.set_font_face = libcairo.cairo_set_font_face
  cairo.get_font_face = libcairo.cairo_get_font_face
  cairo.set_scaled_font = libcairo.cairo_set_scaled_font
  cairo.get_scaled_font = libcairo.cairo_get_scaled_font
  cairo.show_text = libcairo.cairo_show_text
  cairo.show_glyphs = libcairo.cairo_show_glyphs
  cairo.show_text_glyphs = libcairo.cairo_show_text_glyphs
  cairo.font_extents = libcairo.cairo_font_extents
  cairo.text_extents = function(cr, text)
    local extents = ffi.new("cairo_text_extents_t")
    libcairo.cairo_text_extents(cr, text, extents)

    return extents
  end
  cairo.glyph_extents = libcairo.cairo_glyph_extents
  cairo.toy_font_face_create = libcairo.cairo_toy_font_face_create
  cairo.toy_font_face_get_family = libcairo.cairo_toy_font_face_get_family
  cairo.toy_font_face_get_slant = libcairo.cairo_toy_font_face_get_slant
  cairo.toy_font_face_get_weight = libcairo.cairo_toy_font_face_get_weight
  cairo.glyph_allocate = libcairo.cairo_glyph_allocate
  cairo.glyph_free = libcairo.cairo_glyph_free
  cairo.text_cluster_allocate = libcairo.cairo_text_cluster_allocate
  cairo.text_cluster_free = libcairo.cairo_text_cluster_free

  --
  -- Raster Sources
  --
  cairo.pattern_create_raster_source = libcairo.cairo_pattern_create_raster_source
  cairo.raster_source_pattern_set_callback_data = libcairo.cairo_raster_source_pattern_set_callback_data
  cairo.raster_source_pattern_get_callback_data = libcairo.cairo_raster_source_pattern_get_callback_data
  cairo.raster_source_pattern_set_acquire = libcairo.cairo_raster_source_pattern_set_acquire
  cairo.raster_source_pattern_get_acquire = libcairo.cairo_raster_source_pattern_get_acquire
  cairo.raster_source_pattern_set_snapshot = libcairo.cairo_raster_source_pattern_set_snapshot
  cairo.raster_source_pattern_get_snapshot = libcairo.cairo_raster_source_pattern_get_snapshot
  cairo.raster_source_pattern_set_copy = libcairo.cairo_raster_source_pattern_set_copy
  cairo.raster_source_pattern_get_copy = libcairo.cairo_raster_source_pattern_get_copy
  cairo.raster_source_pattern_set_finish = libcairo.cairo_raster_source_pattern_set_finish
  cairo.raster_source_pattern_get_finish = libcairo.cairo_raster_source_pattern_get_finish

  --
  -- Tags and Links
  --
  cairo.tag_begin = libcairo. cairo_tag_begin
  cairo.tag_end = libcairo.cairo_tag_end
end

do -- Fonts
  --
  -- cairo_font_face_t
  --
  cairo.font_face_reference = libcairo. cairo_font_face_reference
  cairo.font_face_destroy = libcairo.cairo_font_face_destroy
  cairo.font_face_status = libcairo.cairo_font_face_status
  cairo.font_face_get_type = libcairo.cairo_font_face_get_type
  cairo.font_face_get_reference_count = libcairo.cairo_font_face_get_reference_count
  cairo.font_face_set_user_data = libcairo.cairo_font_face_set_user_data
  cairo.font_face_get_user_data = libcairo.cairo_font_face_get_user_data

  --
  -- cairo_scaled_font_t
  --
  cairo.scaled_font_create = libcairo. cairo_scaled_font_create
  cairo.scaled_font_reference = libcairo.cairo_scaled_font_reference
  cairo.scaled_font_destroy = libcairo.cairo_scaled_font_destroy
  cairo.scaled_font_status = libcairo.cairo_scaled_font_status
  cairo.scaled_font_extents = libcairo.cairo_scaled_font_extents
  cairo.scaled_font_text_extents = libcairo.cairo_scaled_font_text_extents
  cairo.scaled_font_glyph_extents = libcairo.cairo_scaled_font_glyph_extents
  cairo.scaled_font_text_to_glyphs = libcairo.cairo_scaled_font_text_to_glyphs
  cairo.scaled_font_get_font_face = libcairo.cairo_scaled_font_get_font_face
  cairo.scaled_font_get_font_options = libcairo.cairo_scaled_font_get_font_options
  cairo.scaled_font_get_font_matrix = libcairo.cairo_scaled_font_get_font_matrix
  cairo.scaled_font_get_ctm = libcairo.cairo_scaled_font_get_ctm
  cairo.scaled_font_get_scale_matrix = libcairo.cairo_scaled_font_get_scale_matrix
  cairo.scaled_font_get_type = libcairo.cairo_scaled_font_get_type
  cairo.scaled_font_get_reference_count = libcairo.cairo_scaled_font_get_reference_count
  cairo.scaled_font_set_user_data = libcairo.cairo_scaled_font_set_user_data
  cairo.scaled_font_get_user_data = libcairo.cairo_scaled_font_get_user_data

  --
  -- cairo_font_options_t
  --
  cairo.font_options_create = libcairo. cairo_font_options_create
  cairo.font_options_copy = libcairo.cairo_font_options_copy
  cairo.font_options_destroy = libcairo.cairo_font_options_destroy
  cairo.font_options_status = libcairo.cairo_font_options_status
  cairo.font_options_merge = libcairo.cairo_font_options_merge
  cairo.font_options_hash = libcairo.cairo_font_options_hash
  cairo.font_options_equal = libcairo.cairo_font_options_equal
  cairo.font_options_set_antialias = libcairo.cairo_font_options_set_antialias
  cairo.font_options_get_antialias = libcairo.cairo_font_options_get_antialias
  cairo.font_options_set_subpixel_order = libcairo.cairo_font_options_set_subpixel_order
  cairo.font_options_get_subpixel_order = libcairo.cairo_font_options_get_subpixel_order
  cairo.font_options_set_hint_style = libcairo.cairo_font_options_set_hint_style
  cairo.font_options_get_hint_style = libcairo.cairo_font_options_get_hint_style
  cairo.font_options_set_hint_metrics = libcairo.cairo_font_options_set_hint_metrics
  cairo.font_options_get_hint_metrics = libcairo.cairo_font_options_get_hint_metrics
  cairo.font_options_get_variations = libcairo.cairo_font_options_get_variations
  cairo.font_options_set_variations = libcairo.cairo_font_options_set_variations

  if libcairo.cairo_version() >= 11800 then
    cairo.font_options_set_color_mode = libcairo.cairo_font_options_set_color_mode
    cairo.font_options_get_color_mode = libcairo.cairo_font_options_get_color_mode
    cairo.font_options_set_color_palette = libcairo.cairo_font_options_set_color_palette
    cairo.font_options_get_color_palette = libcairo.cairo_font_options_get_color_palette
    cairo.font_options_set_custom_palette_color = libcairo.cairo_font_options_set_custom_palette_color
    cairo.font_options_get_custom_palette_color = libcairo.cairo_font_options_get_custom_palette_color
  end

  --
  -- FreeType Fonts
  --
  -- cairo.ft_font_face_create_for_ft_face = libcairo.cairo_ft_font_face_create_for_ft_face
  -- cairo.ft_font_face_create_for_pattern = libcairo.cairo_ft_font_face_create_for_pattern
  -- cairo.ft_font_options_substitute = libcairo.cairo_ft_font_options_substitute
  -- cairo.ft_scaled_font_lock_face = libcairo.cairo_ft_scaled_font_lock_face
  -- cairo.ft_scaled_font_unlock_face = libcairo.cairo_ft_scaled_font_unlock_face
  -- cairo.ft_font_face_get_synthesize = libcairo.cairo_ft_font_face_get_synthesize
  -- cairo.ft_font_face_set_synthesize = libcairo.cairo_ft_font_face_set_synthesize
  -- cairo.ft_font_face_unset_synthesize = libcairo.cairo_ft_font_face_unset_synthesize

  --
  -- Win32 GDI Fonts
  --
  -- cairo.win32_font_face_create_for_logfontw = libcairo.cairo_win32_font_face_create_for_logfontw
  -- cairo.win32_font_face_create_for_hfont = libcairo.cairo_win32_font_face_create_for_hfont
  -- cairo.win32_font_face_create_for_logfontw_hfont = libcairo.cairo_win32_font_face_create_for_logfontw_hfont
  -- cairo.win32_scaled_font_select_font = libcairo.cairo_win32_scaled_font_select_font
  -- cairo.win32_scaled_font_done_font = libcairo.cairo_win32_scaled_font_done_font
  -- cairo.win32_scaled_font_get_metrics_factor = libcairo.cairo_win32_scaled_font_get_metrics_factor
  -- cairo.win32_scaled_font_get_logical_to_device = libcairo.cairo_win32_scaled_font_get_logical_to_device
  -- cairo.win32_scaled_font_get_device_to_logical = libcairo.cairo_win32_scaled_font_get_device_to_logical

  --
  -- DWrite Fonts
  --
  -- cairo.dwrite_font_face_create_for_dwrite_fontface = libcairo.cairo_dwrite_font_face_create_for_dwrite_fontface
  -- cairo.dwrite_font_face_get_rendering_params = libcairo.cairo_dwrite_font_face_get_rendering_params
  -- cairo.dwrite_font_face_set_rendering_params = libcairo.cairo_dwrite_font_face_set_rendering_params
  -- cairo.dwrite_font_face_get_measuring_mode = libcairo.cairo_dwrite_font_face_get_measuring_mode
  -- cairo.dwrite_font_face_set_measuring_mode = libcairo.cairo_dwrite_font_face_set_measuring_mode

  --
  -- Quartz (CGFont) Fonts
  --
  -- cairo.quartz_font_face_create_for_cgfont = libcairo.cairo_quartz_font_face_create_for_cgfont
  -- cairo.quartz_font_face_create_for_atsu_font_id = libcairo.cairo_quartz_font_face_create_for_atsu_font_id

  --
  -- User Fonts
  --
  cairo.user_font_face_create = libcairo. cairo_user_font_face_create
  cairo.user_font_face_set_init_func = libcairo.cairo_user_font_face_set_init_func
  cairo.user_font_face_get_init_func = libcairo.cairo_user_font_face_get_init_func
  cairo.user_font_face_set_render_glyph_func = libcairo.cairo_user_font_face_set_render_glyph_func
  cairo.user_font_face_get_render_glyph_func = libcairo.cairo_user_font_face_get_render_glyph_func

  if libcairo.cairo_version() >= 11800 then
    cairo.user_font_face_set_render_color_glyph_func = libcairo.cairo_user_font_face_set_render_color_glyph_func
    cairo.user_font_face_get_render_color_glyph_func = libcairo.cairo_user_font_face_get_render_color_glyph_func
    cairo.user_font_face_set_unicode_to_glyph_func = libcairo.cairo_user_font_face_set_unicode_to_glyph_func
    cairo.user_font_face_get_unicode_to_glyph_func = libcairo.cairo_user_font_face_get_unicode_to_glyph_func
    cairo.user_font_face_set_text_to_glyphs_func = libcairo.cairo_user_font_face_set_text_to_glyphs_func
    cairo.user_font_face_get_text_to_glyphs_func = libcairo.cairo_user_font_face_get_text_to_glyphs_func
    cairo.user_scaled_font_get_foreground_marker = libcairo.cairo_user_scaled_font_get_foreground_marker
    cairo.user_scaled_font_get_foreground_source = libcairo.cairo_user_scaled_font_get_foreground_source
  end
end

do -- Surfaces
  --
  -- cairo_device_t
  --
  cairo.device_reference = libcairo. cairo_device_reference
  cairo.device_destroy = libcairo.cairo_device_destroy
  cairo.device_status = libcairo.cairo_device_status
  cairo.device_finish = libcairo.cairo_device_finish
  cairo.device_flush = libcairo.cairo_device_flush
  cairo.device_get_type = libcairo.cairo_device_get_type
  cairo.device_get_reference_count = libcairo.cairo_device_get_reference_count
  cairo.device_set_user_data = libcairo.cairo_device_set_user_data
  cairo.device_get_user_data = libcairo.cairo_device_get_user_data
  cairo.device_acquire = libcairo.cairo_device_acquire
  cairo.device_release = libcairo.cairo_device_release
  cairo.device_observer_elapsed = libcairo.cairo_device_observer_elapsed
  cairo.device_observer_fill_elapsed = libcairo.cairo_device_observer_fill_elapsed
  cairo.device_observer_glyphs_elapsed = libcairo.cairo_device_observer_glyphs_elapsed
  cairo.device_observer_mask_elapsed = libcairo.cairo_device_observer_mask_elapsed
  cairo.device_observer_paint_elapsed = libcairo.cairo_device_observer_paint_elapsed
  cairo.device_observer_print = libcairo.cairo_device_observer_print
  cairo.device_observer_stroke_elapsed = libcairo.cairo_device_observer_stroke_elapsed

  --
  -- cairo_surface_t
  --
  cairo.surface_create_similar = libcairo. cairo_surface_create_similar
  cairo.surface_create_similar_image = libcairo.cairo_surface_create_similar_image
  cairo.surface_create_for_rectangle = libcairo.cairo_surface_create_for_rectangle
  cairo.surface_reference = libcairo.cairo_surface_reference
  cairo.surface_destroy = libcairo.cairo_surface_destroy
  cairo.surface_status = libcairo.cairo_surface_status
  cairo.surface_finish = libcairo.cairo_surface_finish
  cairo.surface_flush = libcairo.cairo_surface_flush
  cairo.surface_get_device = libcairo.cairo_surface_get_device
  cairo.surface_get_font_options = libcairo.cairo_surface_get_font_options
  cairo.surface_get_content = libcairo.cairo_surface_get_content
  cairo.surface_mark_dirty = libcairo.cairo_surface_mark_dirty
  cairo.surface_mark_dirty_rectangle = libcairo.cairo_surface_mark_dirty_rectangle
  cairo.surface_set_device_offset = libcairo.cairo_surface_set_device_offset
  cairo.surface_get_device_offset = libcairo.cairo_surface_get_device_offset
  cairo.surface_get_device_scale = libcairo.cairo_surface_get_device_scale
  cairo.surface_set_device_scale = libcairo.cairo_surface_set_device_scale
  cairo.surface_set_fallback_resolution = libcairo.cairo_surface_set_fallback_resolution
  cairo.surface_get_fallback_resolution = libcairo.cairo_surface_get_fallback_resolution
  cairo.surface_get_type = libcairo.cairo_surface_get_type
  cairo.surface_get_reference_count = libcairo.cairo_surface_get_reference_count
  cairo.surface_set_user_data = libcairo.cairo_surface_set_user_data
  cairo.surface_get_user_data = libcairo.cairo_surface_get_user_data
  cairo.surface_copy_page = libcairo.cairo_surface_copy_page
  cairo.surface_show_page = libcairo.cairo_surface_show_page
  cairo.surface_has_show_text_glyphs = libcairo.cairo_surface_has_show_text_glyphs
  cairo.surface_set_mime_data = libcairo.cairo_surface_set_mime_data
  cairo.surface_get_mime_data = libcairo.cairo_surface_get_mime_data
  cairo.surface_supports_mime_type = libcairo.cairo_surface_supports_mime_type
  cairo.surface_map_to_image = libcairo.cairo_surface_map_to_image
  cairo.surface_unmap_image = libcairo.cairo_surface_unmap_image

  --
  -- Image Surfaces
  --
  cairo.format_stride_for_width = libcairo.cairo_format_stride_for_width
  cairo.image_surface_create = libcairo.cairo_image_surface_create
  cairo.image_surface_create_for_data = libcairo.cairo_image_surface_create_for_data
  cairo.image_surface_get_data = libcairo.cairo_image_surface_get_data
  cairo.image_surface_get_format = libcairo.cairo_image_surface_get_format
  cairo.image_surface_get_width = libcairo.cairo_image_surface_get_width
  cairo.image_surface_get_height = libcairo.cairo_image_surface_get_height
  cairo.image_surface_get_stride = libcairo.cairo_image_surface_get_stride

  --
  -- PDF Surfaces
  --
  cairo.pdf_surface_create = libcairo.cairo_pdf_surface_create
  cairo.pdf_surface_create_for_stream = libcairo.cairo_pdf_surface_create_for_stream
  cairo.pdf_surface_restrict_to_version = libcairo.cairo_pdf_surface_restrict_to_version
  cairo.pdf_get_versions = libcairo.cairo_pdf_get_versions
  cairo.pdf_version_to_string = libcairo.cairo_pdf_version_to_string
  cairo.pdf_surface_set_size = libcairo.cairo_pdf_surface_set_size
  cairo.pdf_surface_add_outline = libcairo.cairo_pdf_surface_add_outline
  cairo.pdf_surface_set_metadata = libcairo.cairo_pdf_surface_set_metadata

  if libcairo.cairo_version() >= 11800 then
    cairo.pdf_surface_set_custom_metadata = libcairo.cairo_pdf_surface_set_custom_metadata
    cairo.pdf_surface_set_page_label = libcairo.cairo_pdf_surface_set_page_label
    cairo.pdf_surface_set_thumbnail_size = libcairo.cairo_pdf_surface_set_thumbnail_size
  end

  --
  -- PNG Support
  --
  cairo.image_surface_create_from_png = libcairo.cairo_image_surface_create_from_png
  cairo.image_surface_create_from_png_stream = libcairo.cairo_image_surface_create_from_png_stream
  cairo.surface_write_to_png = libcairo.cairo_surface_write_to_png
  cairo.surface_write_to_png_stream = function(surface, callbak)
    local function write_func(_, data, length)
      callbak(ffi.string(data, length))
    end

    libcairo.cairo_surface_write_to_png_stream(surface, ffi.cast("cairo_write_func_t", write_func), ffi.new("void*"))
  end

  --
  -- PostScript Surfaces
  --
  cairo.ps_surface_create = libcairo.cairo_ps_surface_create
  cairo.ps_surface_create_for_stream = libcairo.cairo_ps_surface_create_for_stream
  cairo.ps_surface_restrict_to_level = libcairo.cairo_ps_surface_restrict_to_level
  cairo.ps_get_levels = libcairo.cairo_ps_get_levels
  cairo.ps_level_to_string = libcairo.cairo_ps_level_to_string
  cairo.ps_surface_set_eps = libcairo.cairo_ps_surface_set_eps
  cairo.ps_surface_get_eps = libcairo.cairo_ps_surface_get_eps
  cairo.ps_surface_set_size = libcairo.cairo_ps_surface_set_size
  cairo.ps_surface_dsc_begin_setup = libcairo.cairo_ps_surface_dsc_begin_setup
  cairo.ps_surface_dsc_begin_page_setup = libcairo.cairo_ps_surface_dsc_begin_page_setup
  cairo.ps_surface_dsc_comment = libcairo.cairo_ps_surface_dsc_comment

  --
  -- Recording Surfaces
  --
  cairo.recording_surface_create = libcairo. cairo_recording_surface_create
  cairo.recording_surface_ink_extents = libcairo.cairo_recording_surface_ink_extents
  cairo.recording_surface_get_extents = libcairo.cairo_recording_surface_get_extents

  --
  -- Win32 Surfaces
  --
  -- cairo.win32_surface_create = libcairo. cairo_win32_surface_create
  -- cairo.win32_surface_create_with_dib = libcairo.cairo_win32_surface_create_with_dib
  -- cairo.win32_surface_create_with_ddb = libcairo.cairo_win32_surface_create_with_ddb
  -- cairo.win32_surface_create_with_format = libcairo.cairo_win32_surface_create_with_format
  -- cairo.win32_printing_surface_create = libcairo.cairo_win32_printing_surface_create
  -- cairo.win32_surface_get_dc = libcairo.cairo_win32_surface_get_dc
  -- cairo.win32_surface_get_image = libcairo.cairo_win32_surface_get_image

  --
  -- SVG Surfaces
  --
  cairo.svg_surface_create = libcairo.cairo_svg_surface_create
  cairo.svg_surface_create_for_stream = libcairo.cairo_svg_surface_create_for_stream
  cairo.svg_surface_get_document_unit = libcairo.cairo_svg_surface_get_document_unit
  cairo.svg_surface_set_document_unit = libcairo.cairo_svg_surface_set_document_unit
  cairo.svg_surface_restrict_to_version = libcairo.cairo_svg_surface_restrict_to_version
  cairo.svg_get_versions = libcairo.cairo_svg_get_versions
  cairo.svg_version_to_string = libcairo.cairo_svg_version_to_string

  --
  -- Quartz Surfaces
  --
  -- cairo.quartz_surface_create = libcairo.cairo_quartz_surface_create
  -- cairo.quartz_surface_create_for_cg_context = libcairo.cairo_quartz_surface_create_for_cg_context
  -- cairo.quartz_surface_get_cg_context = libcairo.cairo_quartz_surface_get_cg_context
  -- cairo.quartz_image_surface_create = libcairo.cairo_quartz_image_surface_create
  -- cairo.quartz_image_surface_get_image = libcairo.cairo_quartz_image_surface_get_image

  --
  -- XCB Surfaces
  --
  -- cairo.xcb_surface_create = libcairo. cairo_xcb_surface_create
  -- cairo.xcb_surface_create_for_bitmap = libcairo.cairo_xcb_surface_create_for_bitmap
  -- cairo.xcb_surface_create_with_xrender_format = libcairo.cairo_xcb_surface_create_with_xrender_format
  -- cairo.xcb_surface_set_size = libcairo.cairo_xcb_surface_set_size
  -- cairo.xcb_surface_set_drawable = libcairo.cairo_xcb_surface_set_drawable
  -- cairo.xcb_device_get_connection = libcairo.cairo_xcb_device_get_connection
  -- cairo.xcb_device_debug_cap_xrender_version = libcairo.cairo_xcb_device_debug_cap_xrender_version
  -- cairo.xcb_device_debug_cap_xshm_version = libcairo.cairo_xcb_device_debug_cap_xshm_version
  -- cairo.xcb_device_debug_get_precision = libcairo.cairo_xcb_device_debug_get_precision
  -- cairo.xcb_device_debug_set_precision = libcairo.cairo_xcb_device_debug_set_precision

  --
  -- XLib Surfaces
  --
  -- cairo.xlib_surface_create = libcairo.cairo_xlib_surface_create
  -- cairo.xlib_surface_create_for_bitmap = libcairo.cairo_xlib_surface_create_for_bitmap
  -- cairo.xlib_surface_set_size = libcairo.cairo_xlib_surface_set_size
  -- cairo.xlib_surface_get_display = libcairo.cairo_xlib_surface_get_display
  -- cairo.xlib_surface_get_screen = libcairo.cairo_xlib_surface_get_screen
  -- cairo.xlib_surface_set_drawable = libcairo.cairo_xlib_surface_set_drawable
  -- cairo.xlib_surface_get_drawable = libcairo.cairo_xlib_surface_get_drawable
  -- cairo.xlib_surface_get_visual = libcairo.cairo_xlib_surface_get_visual
  -- cairo.xlib_surface_get_width = libcairo.cairo_xlib_surface_get_width
  -- cairo.xlib_surface_get_height = libcairo.cairo_xlib_surface_get_height
  -- cairo.xlib_surface_get_depth = libcairo.cairo_xlib_surface_get_depth
  -- cairo.xlib_device_debug_cap_xrender_version = libcairo.cairo_xlib_device_debug_cap_xrender_version
  -- cairo.xlib_device_debug_get_precision = libcairo.cairo_xlib_device_debug_get_precision
  -- cairo.xlib_device_debug_set_precision = libcairo.cairo_xlib_device_debug_set_precision

  --
  -- XLib-XRender Backend
  --
  -- cairo.xlib_surface_create_with_xrender_format = libcairo.cairo_xlib_surface_create_with_xrender_format
  -- cairo.xlib_surface_get_xrender_format = libcairo.cairo_xlib_surface_get_xrender_format

  --
  -- Script Surfaces
  --
  -- cairo.script_create = libcairo.cairo_script_create
  -- cairo.script_create_for_stream = libcairo.cairo_script_create_for_stream
  -- cairo.script_from_recording_surface = libcairo.cairo_script_from_recording_surface
  -- cairo.script_get_mode = libcairo.cairo_script_get_mode
  -- cairo.script_set_mode = libcairo.cairo_script_set_mode
  -- cairo.script_surface_create = libcairo.cairo_script_surface_create
  -- cairo.script_surface_create_for_target = libcairo.cairo_script_surface_create_for_target
  -- cairo.script_write_comment = libcairo.cairo_script_write_comment

  --
  -- Surface Observer
  --
  cairo.surface_create_observer = libcairo.cairo_surface_create_observer
  cairo.surface_observer_add_fill_callback = libcairo.cairo_surface_observer_add_fill_callback
  cairo.surface_observer_add_finish_callback = libcairo.cairo_surface_observer_add_finish_callback
  cairo.surface_observer_add_flush_callback = libcairo.cairo_surface_observer_add_flush_callback
  cairo.surface_observer_add_glyphs_callback = libcairo.cairo_surface_observer_add_glyphs_callback
  cairo.surface_observer_add_mask_callback = libcairo.cairo_surface_observer_add_mask_callback
  cairo.surface_observer_add_paint_callback = libcairo.cairo_surface_observer_add_paint_callback
  cairo.surface_observer_add_stroke_callback = libcairo.cairo_surface_observer_add_stroke_callback
  cairo.surface_observer_elapsed = libcairo.cairo_surface_observer_elapsed
  cairo.surface_observer_print = libcairo.cairo_surface_observer_print

  --
  -- Tee surface
  --
  cairo.tee_surface_create = libcairo.cairo_tee_surface_create
  cairo.tee_surface_add = libcairo.cairo_tee_surface_add
  cairo.tee_surface_index = libcairo.cairo_tee_surface_index
  cairo.tee_surface_remove = libcairo.cairo_tee_surface_remove
end

do -- Utilities
  --
  -- cairo_matrix_t
  --
  cairo.matrix_init = libcairo.cairo_matrix_init
  cairo.matrix_init_identity = libcairo.cairo_matrix_init_identity
  cairo.matrix_init_translate = libcairo.cairo_matrix_init_translate
  cairo.matrix_init_scale = function(scale_x, scale_y)
    return libcairo.cairo_matrix_init_scale(ffi.new("cairo_matrix_t"), scale_x, scale_y)
  end
  cairo.matrix_init_rotate = libcairo.cairo_matrix_init_rotate
  cairo.matrix_translate = libcairo.cairo_matrix_translate
  cairo.matrix_scale = libcairo.cairo_matrix_scale
  cairo.matrix_rotate = libcairo.cairo_matrix_rotate
  cairo.matrix_invert = libcairo.cairo_matrix_invert
  cairo.matrix_multiply = libcairo.cairo_matrix_multiply
  cairo.matrix_transform_distance = libcairo.cairo_matrix_transform_distance
  cairo.matrix_transform_point = libcairo.cairo_matrix_transform_point

  --
  -- Error handling
  --
  cairo.status_to_string = libcairo.cairo_status_to_string
  cairo.debug_reset_static_data = libcairo.cairo_debug_reset_static_data
end

return cairo
