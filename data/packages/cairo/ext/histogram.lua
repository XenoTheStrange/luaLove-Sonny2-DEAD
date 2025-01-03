-- Adaptive histogram
--
local cairo = require('cairo-luajit-ffi')

local unpack = unpack or table.unpack
local MIN_WIDTH = 400
local MIN_HEIGHT = 400
local FONT_SIZE = 16
local GRID_SPACE = 30

local function mk_histogram(opts)
  local min_values = math.min(unpack(opts.values))
  local max_values = math.max(unpack(opts.values))

  local font_size = opts.text and opts.text.font_size or FONT_SIZE
  local rotate_description_text = opts.text and opts.text.rotate_description_text or 0
  local rotate_value_text = opts.text and opts.text.rotate_value_text or -30

  local height = opts.height or MIN_HEIGHT
  if height < MIN_HEIGHT then
    height = MIN_HEIGHT
  end

  local right_line_space = 15
  local left_right_space = opts.space and opts.space.left_right or 50
  local top_space        = opts.space and opts.space.top        or 50
  local bottom_space     = opts.space and opts.space.bottom     or 50

  local bar_count = #opts.values
  local bar_width = opts.bar and opts.bar.width or 25
  local bar_space = opts.bar and opts.bar.space or 2
  local bar_max_height = height - top_space
  local bar_scale_factor = (bar_max_height - top_space) / max_values

  local grid_space = opts.grid and opts.grid.space or GRID_SPACE

  local width = math.max(
    MIN_WIDTH,
    bar_count * (bar_width+bar_space) + left_right_space*2
  )

  local surface = cairo.image_surface_create(cairo.lib.CAIRO_FORMAT_ARGB32, width, height)
  local cr = cairo.create(surface)

  -- Fill bg
  cairo.set_source_rgb(cr, 1, 1, 1)
  cairo.paint(cr)

  --  Draw lines
  --
  cairo.select_font_face(cr, 'Sans', 1, 1)
  cairo.set_font_size(cr, font_size)

  local grid_left_right_space = 5
  local grid_lines = math.min(
    bar_count - 1 == 0 and 1 or bar_count - 1,
    math.floor((height-top_space)/grid_space)
  )
  grid_lines = grid_lines + 1
  local grid_spacing = (bar_max_height-top_space) / grid_lines

  for i = 0, grid_lines do
    local y = (height-bottom_space) - i * grid_spacing

    -- Line
    cairo.set_source_rgb(cr, 0.8, 0.8, 0.8)
    cairo.move_to(cr, left_right_space - grid_left_right_space, y)
    cairo.line_to(cr, width - right_line_space + grid_left_right_space, y)
    cairo.stroke(cr)

    -- Text
    local value
    if i == 0 then
      value = 0
    elseif i == grid_lines then
      value = max_values
    else
      value = min_values + (max_values - min_values) * i / grid_lines
    end

    -- Text params
    local extents = cairo.text_extents(cr, tostring(math.ceil(max_values)))

    cairo.set_source_rgb(cr, 0.5, 0.5, 0.5)
    cairo.save(cr)
    cairo.translate(cr,
      left_right_space - grid_left_right_space - extents.width - 5,
      y + extents.height/2
    )
    cairo.rotate(cr, math.rad(rotate_value_text))
    cairo.move_to(cr, 0, 0)
    cairo.show_text(cr, string.format("%d", value))
    cairo.restore(cr)
  end
  --

  -- Draw bars
  --
  cairo.set_font_size(cr, font_size)
  for i = 1, bar_count do
    local bar_height = opts.values[i] * bar_scale_factor
    local bar_x = left_right_space + ((i-1)*bar_width) + (i-1)*2
    local bar_y = height - bar_height - bottom_space

    cairo.set_source_rgb(cr, 100/bar_height + 0.3, 0.7, 1 - 100/bar_height + 0.3)
    cairo.rectangle(cr,
      -- x
      bar_x,
      -- y
      bar_y,
      -- w
      bar_width,
      -- h
      bar_height
    )
    cairo.fill(cr)

    -- Draw text
    --
    -- Text params
    local extents = cairo.text_extents(cr, tostring(opts.descriptions[i]))
    local text_y = (extents.height + extents.y_bearing)

    cairo.save(cr)
    if opts  and opts.text and opts.text.description_alignment_center then
      local text_ox = (extents.width/2 + extents.x_bearing)
      cairo.translate(cr,
        bar_x + bar_width/2 - text_ox,
        (height - bottom_space) + 20 + text_y
      )
    else
      cairo.translate(cr,
        bar_x + bar_width/2 - extents.height/2,
        (height - bottom_space) + 20 + text_y
      )
    end
    cairo.rotate(cr, math.rad(rotate_description_text))
    cairo.move_to(cr, 0, 0)
    cairo.show_text(cr, opts.descriptions[i])
    cairo.restore(cr)
  end

  cairo.destroy(cr)

  return surface
end

local function surface_destroy(surface)
  cairo.surface_destroy(surface)
end

local function write_to_png(surface, filename)
  filename = filename or 'output.png'
  cairo.surface_write_to_png(surface, filename)
end

return {
  mk_histogram = mk_histogram,
  surface_destroy = surface_destroy,
  write_to_png = write_to_png,
  write_to_png_stream = cairo.surface_write_to_png_stream,
}
