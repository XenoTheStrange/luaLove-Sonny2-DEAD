local ffi = require('ffi')

ffi.cdef[[
typedef enum _cairo_ps_level {
    CAIRO_PS_LEVEL_2,
    CAIRO_PS_LEVEL_3
} cairo_ps_level_t;

cairo_surface_t *
cairo_ps_surface_create (const char		*filename,
			 double			 width_in_points,
			 double			 height_in_points);

cairo_surface_t *
cairo_ps_surface_create_for_stream (cairo_write_func_t	write_func,
				    void	       *closure,
				    double		width_in_points,
				    double		height_in_points);

void
cairo_ps_surface_restrict_to_level (cairo_surface_t    *surface,
                                    cairo_ps_level_t    level);

void
cairo_ps_get_levels (cairo_ps_level_t const  **levels,
                     int                      *num_levels);

const char *
cairo_ps_level_to_string (cairo_ps_level_t level);

void
cairo_ps_surface_set_eps (cairo_surface_t	*surface,
			  cairo_bool_t           eps);

cairo_bool_t
cairo_ps_surface_get_eps (cairo_surface_t	*surface);

void
cairo_ps_surface_set_size (cairo_surface_t	*surface,
			   double		 width_in_points,
			   double		 height_in_points);

void
cairo_ps_surface_dsc_comment (cairo_surface_t	*surface,
			      const char	*comment);

void
cairo_ps_surface_dsc_begin_setup (cairo_surface_t *surface);

void
cairo_ps_surface_dsc_begin_page_setup (cairo_surface_t *surface);
]]
