local ffi = require('ffi')

ffi.cdef[[
typedef enum _cairo_svg_version {
    CAIRO_SVG_VERSION_1_1,
    CAIRO_SVG_VERSION_1_2
} cairo_svg_version_t;

typedef enum _cairo_svg_unit {
    CAIRO_SVG_UNIT_USER = 0,
    CAIRO_SVG_UNIT_EM,
    CAIRO_SVG_UNIT_EX,
    CAIRO_SVG_UNIT_PX,
    CAIRO_SVG_UNIT_IN,
    CAIRO_SVG_UNIT_CM,
    CAIRO_SVG_UNIT_MM,
    CAIRO_SVG_UNIT_PT,
    CAIRO_SVG_UNIT_PC,
    CAIRO_SVG_UNIT_PERCENT
} cairo_svg_unit_t;

cairo_surface_t *
cairo_svg_surface_create (const char   *filename,
			  double	width_in_points,
			  double	height_in_points);

cairo_surface_t *
cairo_svg_surface_create_for_stream (cairo_write_func_t	write_func,
				     void	       *closure,
				     double		width_in_points,
				     double		height_in_points);

void
cairo_svg_surface_restrict_to_version (cairo_surface_t 		*surface,
				       cairo_svg_version_t  	 version);

void
cairo_svg_get_versions (cairo_svg_version_t const	**versions,
                        int                      	 *num_versions);

const char *
cairo_svg_version_to_string (cairo_svg_version_t version);

void
cairo_svg_surface_set_document_unit (cairo_surface_t	*surface,
				     cairo_svg_unit_t	 unit);

cairo_svg_unit_t
cairo_svg_surface_get_document_unit (cairo_surface_t	*surface);
]]
