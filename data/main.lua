-- Love2d main loop script
package.path = "./data/packages/?/init.lua;" .. "./data/packages/?.lua;" .. "./?.lua;"
--package.path = ("./data/" .. config.game_data_directory .. "/data/?.lua;") .. ("./data/" .. config.game_data_directory .. "/?/init.lua;") .. package.path

config = require("conf")
engine = require("engine/engine")
flux = require("flux")

-- Runs on program start. Load game data.
function love.load()
    data = {}
    scripts = {}
    state = {
        sprites_to_draw = {}
    }
    engine.restart_game()
    scripts.init()
end

function love.draw()
    if state.sprites_to_draw == nil then 
        return
    end
    if config.show_fps then 
        engine.show_fps()
    end

    for _, sprite in ipairs(state.sprites_to_draw) do
        local partsArray = sprite.sorted_parts or {}
        for _, piece in ipairs(partsArray) do
            if piece.visible == true then
                if piece.tint then
                    love.graphics.setColor(piece.tint)
                else 
                    love.graphics.setColor(1, 1, 1, 1)
                end

                -- Save the current transformation matrix
                love.graphics.push()

                -- Translate to the sprite's position (before rotation)
                love.graphics.translate(sprite.x, sprite.y)

                -- Apply the global rotation of the sprite (sprite.angle)
                love.graphics.rotate(sprite.angle * 0.017453292519943)

                -- Now draw the piece, accounting for its local position relative to the sprite center
                love.graphics.draw(
                    piece.sprite, 
                    piece.x * sprite.scale_x * config.global_sprite_scale,
                    piece.y * sprite.scale_y * config.global_sprite_scale,
                    piece.angle * 0.017453292519943, -- piece rotation still applies
                    sprite.scale_x * piece.scale_x * config.global_sprite_scale,
                    sprite.scale_y * piece.scale_y * config.global_sprite_scale,
                    piece.sprite:getWidth() / 2,
                    piece.sprite:getHeight() / 2,
                    piece.shear_x,
                    piece.shear_y
                )

                -- Restore the previous transformation matrix
                love.graphics.pop()
            end
        end
    end
end





-- Runs each frame. Used to update states.
function love.update(dt)
    flux.update(dt) -- Needed to use flux
    -- This should pretty much call an update function tied to whatever scene we're in at the moment. TODO
end


-- Runs when any key is pressed.
function love.keypressed(k)

    -- Temporary code to make it easier to test stuff
	if k == 'escape' then
		love.event.push('quit') -- Quit the game.
    elseif k == 'backspace' then
        love.event.quit( "restart" ) -- Restart love
    elseif k == "space" then
        love.load() -- Internally reset the game state (faster than restarting love)
	end

end

-- Runs when any ascii key is pressed. Ignores shift so you can type caps & symbols.
function love.textinput(text)
end

