![Screenshot](https://github.com/uriid1/cairo-luajit-ffi/blob/main/screenshot.png)
[Russian](README_RU.md) | English</br>

## Cairo LuaJit FFI
FFI bindings to Cairo graphics

## Installation
## LuaRocks
```bash
sudo luarocks --lua-version 5.1 install cairo-luajit-ffi-0.0-1.rockspec
```

## Dependencies
For Debian or Ubuntu
```bash
sudo apt-get install libcairo2-dev
```

For Fedora
```bash
sudo yum install cairo-devel
```

For openSUSE
```bash
zypper install cairo-devel
```

# Documentation
https://www.cairographics.org/manual/
Methods have undergone minimal changes, but it's better to refer to cairo-ffi.lua, the examples, and test/all_test.lua.

# Minimal Example
```lua
local cairo = require('cairo-luajit-ffi')

local WIDTH = 512
local HEIGHT = 512

local surface = cairo.image_surface_create(cairo.lib.CAIRO_FORMAT_ARGB32, WIDTH, HEIGHT)
local cr = cairo.create(surface)

cairo.set_source_rgb(cr, 1, 1, 1)
cairo.paint(cr)

-- Fill circle
cairo.set_source_rgb(cr, 0, 0.7, 0.7)
cairo.arc(cr, WIDTH/2, HEIGHT/2, 128, 0, 2 * math.pi)
cairo.fill(cr)

cairo.surface_write_to_png(surface, 'circle-test.png')
cairo.destroy(cr)
cairo.surface_destroy(surface)
```
