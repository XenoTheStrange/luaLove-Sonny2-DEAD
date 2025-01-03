local ffi = require('ffi')

ffi.cdef[[
typedef enum _cairo_pdf_version {
    CAIRO_PDF_VERSION_1_4,
    CAIRO_PDF_VERSION_1_5,
    CAIRO_PDF_VERSION_1_6,
    CAIRO_PDF_VERSION_1_7
} cairo_pdf_version_t;

cairo_surface_t *
cairo_pdf_surface_create (const char		*filename,
			  double		 width_in_points,
			  double		 height_in_points);

cairo_surface_t *
cairo_pdf_surface_create_for_stream (cairo_write_func_t	write_func,
				     void	       *closure,
				     double		width_in_points,
				     double		height_in_points);

void
cairo_pdf_surface_restrict_to_version (cairo_surface_t 		*surface,
				       cairo_pdf_version_t  	 version);

void
cairo_pdf_get_versions (cairo_pdf_version_t const	**versions,
                        int                      	 *num_versions);

const char *
cairo_pdf_version_to_string (cairo_pdf_version_t version);

void
cairo_pdf_surface_set_size (cairo_surface_t	*surface,
			    double		 width_in_points,
			    double		 height_in_points);

typedef enum _cairo_pdf_outline_flags {
    CAIRO_PDF_OUTLINE_FLAG_OPEN   = 0x1,
    CAIRO_PDF_OUTLINE_FLAG_BOLD   = 0x2,
    CAIRO_PDF_OUTLINE_FLAG_ITALIC = 0x4,
} cairo_pdf_outline_flags_t;

int
cairo_pdf_surface_add_outline (cairo_surface_t	          *surface,
			       int                         parent_id,
			       const char                 *utf8,
			       const char                 *link_attribs,
			       cairo_pdf_outline_flags_t  flags);

typedef enum _cairo_pdf_metadata {
    CAIRO_PDF_METADATA_TITLE,
    CAIRO_PDF_METADATA_AUTHOR,
    CAIRO_PDF_METADATA_SUBJECT,
    CAIRO_PDF_METADATA_KEYWORDS,
    CAIRO_PDF_METADATA_CREATOR,
    CAIRO_PDF_METADATA_CREATE_DATE,
    CAIRO_PDF_METADATA_MOD_DATE,
} cairo_pdf_metadata_t;

void
cairo_pdf_surface_set_metadata (cairo_surface_t	     *surface,
				cairo_pdf_metadata_t  metadata,
                                const char           *utf8);

void
cairo_pdf_surface_set_custom_metadata (cairo_surface_t	    *surface,
                                       const char           *name,
                                       const char           *value);

void
cairo_pdf_surface_set_page_label (cairo_surface_t *surface,
                                  const char      *utf8);

void
cairo_pdf_surface_set_thumbnail_size (cairo_surface_t *surface,
				      int              width,
				      int              height);
]]
