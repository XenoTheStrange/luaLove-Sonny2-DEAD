-- This is a template for things that aren't _really_ characters but we want to treat them like characters

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
            sprite = engine.sprites.missing
        }
    }
}

return generic
