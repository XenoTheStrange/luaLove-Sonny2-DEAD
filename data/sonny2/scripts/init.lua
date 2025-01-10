-- This runs after all game data is loaded in. Specific to the game running and not part of the engine.

return function()
    -- Set the default keys for all the jazz in characters so I can put chars into state.sprites_to_draw
    part_defaults = {visible = true, x=0, y=0, angle=0, scale_x=1, scale_y=1, sprite=sprites.debug.missing} -- Don't wanna type it all, but must avoid crash :P
    character_defaults = {visible = true, x=100, y=100, angle=0, scale_x=1, scale_y=1}

    engine.utils.set_defaults_foreach_in(data.characters, character_defaults)
    for _, character in pairs(data.characters) do
        engine.utils.set_defaults_foreach_in(character.parts, part_defaults)
    end

    -- Launch the intro cutscene (if enabled) otherwise go to the main menu
    -- TODO: Work on main menu and basic structure of scenes.
    
    local myDude = engine.new(data.characters.ninja)
    local myDude2 = engine.new(data.characters.klima_soldier)
    engine.draw_all(myDude, myDude2)

    flux.to(myDude, 5, {x = 1400, y = 500})
    flux.to(myDude, 5, {angle=2160})
    flux.to(myDude2, 10, {x = 1400, y = 500, scale_x = 0.8, scale_y = 1.2})

    love.graphics.setBackgroundColor(177/255,221/255,1,1)
    config.global_sprite_scale = 0.5
end
