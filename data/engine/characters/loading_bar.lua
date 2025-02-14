-- This is a template for things that aren't _really_ characters but we want to treat them like characters
local loading_bar = {
    name = "loading_bar",
    x = 400,
    y = 400,
    angle = 0,
    scale_x = 1,
    scale_y = 0.75,
    visible = true,
    parts = {
        background1 = {
            z_index = 1,
            name="b1",
            x = 0,
            y = 0,
            angle = 0,
            tint = {1,1,1,1},
            scale_x = 1.05,
            scale_y = 1.2,
            shear_x = 0,
            shear_y = 0,
            visible = true,
            sprite = engine.sprites.bar
        },
        background2 = {
            z_index = 2,
            x = 0,
            y = 0,
            angle = 0,
            tint = {0,0,0,1},
            scale_x = 1,
            scale_y = 1,
            shear_x = 0,
            shear_y = 0,
            visible = true,
            sprite = engine.sprites.bar
        },
        bar = {
            z_index = 3,
            x = 0,
            y = 0,
            angle = 0,
            tint = {1,1,1,1},
            scale_x = 0.1,
            scale_y = 1,
            shear_x = 0,
            shear_y = 0,
            visible = true,
            sprite = engine.sprites.bar
        }
    },
    Draw = engine.draws.Character_Generic
}

return loading_bar
