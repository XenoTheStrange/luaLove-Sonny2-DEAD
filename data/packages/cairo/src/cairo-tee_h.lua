local ffi = require('ffi')

ffi.cdef[[
cairo_surface_t *
cairo_tee_surface_create (cairo_surface_t *primary);

void
cairo_tee_surface_add (cairo_surface_t *abstract_surface,
		       cairo_surface_t *target);

void
cairo_tee_surface_remove (cairo_surface_t *abstract_surface,
			  cairo_surface_t *target);

cairo_surface_t *
cairo_tee_surface_index (cairo_surface_t *abstract_surface,
			 unsigned int index);
]]
