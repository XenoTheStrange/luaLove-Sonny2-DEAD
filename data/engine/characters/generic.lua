-- This generic character template can be used for things which aren't traditional character dolls

local generic = {
    name = "generic",
    x = 0,
    y = 0,
    angle = 0,
    scale_x = 1,
    scale_y = 1,
    visible = true,
    parts = {
        base = {
            x = 0,
            y = 0,
            angle = 0,
            scale_x = 1,
            scale_y = 1,
            shear_x = 0,
            shear_y = 0,
            visible = true,
            sprite = engine.sprites.missing,
            shaders = nil -- Optional
        }
    },
    shaders = nil, -- Optional
    Draw = engine.draws.Character_Generic
}

return generic

-- SHADERS
-- shaders = {func, func2, func3}
-- functions will be run in order on the char as a whole and/or each part as they contain functions
