-- This runs after all game data is loaded in. Specific to the game running and not part of the engine.

func = function()
    -- Set the default keys for all the jazz in characters so I can put chars into state.sprites_to_draw
    defaults = {visible = true, x=0, y=0, angle=0, scale_x=1, scale_y=1, sprite=sprites.debug.missing}
    defaults2 = {visible = true, x=100, y=100, angle=0, scale_x=1, scale_y=1}
    engine.utils.set_defaults_foreach_in(data.characters, defaults2)
    for _, character in pairs(data.characters) do
        engine.utils.set_defaults_foreach_in(character.parts, defaults)
    end
end

return func