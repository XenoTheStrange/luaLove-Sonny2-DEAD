-- This runs after all game data is loaded in. Specific to the game running and not part of the engine.

return function()
    -- Set the default keys for all the jazz in characters
    part_defaults = {visible = true, x=0, y=0, angle=0, shear_x=0, shear_y=0, scale_x=1, scale_y=1, sprite=sprites.debug.missing} -- Don't wanna type it all, but must avoid crash :P
    character_defaults = {visible = true, x=0, y=0, angle=0, scale_x=1, scale_y=1}

    engine.utils.set_defaults_foreach_in(data.characters, character_defaults)
    for _, character in pairs(data.characters) do
        engine.utils.set_defaults_foreach_in(character.parts, part_defaults)
    end

    -- Launch the intro cutscene
    -- Proceeds to scene pre_title.lua
    data.animations.armorgames_intro()
end
