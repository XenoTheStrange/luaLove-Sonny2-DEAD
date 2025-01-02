-- Love2d main loop script
package.path = "./data/packages/?/init.lua;" .. "./data/packages/?.lua;" .. "./?.lua;" .. package.path
config = require("config")
package.path = ("./data/" .. config.game_data_directory .. "/data/?.lua;") .. ("./data/" .. config.game_data_directory .. "/?/init.lua;") .. package.path

engine = require("engine/init")
data = {}
scripts = {}
state = {
    sprites_to_draw = {}
}

-- Runs on program start. Load game data.
function love.load()
    engine.restart_game()  
    state.sprites_to_draw = {data.characters.ball} 
    print("START")
    engine.utils.tp(data.characters)
end

function love.draw()
    -- I'm using pairs here so the data structure can be labeled and this will ignore it _. Good for labeling body part pieces.
    if state.sprites_to_draw ~= nil then
        for _, sprite in ipairs(state.sprites_to_draw) do
            for _, piece in pairs(sprite.parts) do
                if piece.visible == true then
                    love.graphics.draw(
                            piece.sprite, 
                            sprite.x + piece.x, 
                            sprite.y + piece.y
                        )
                end
            end
        end
    end
end

-- Runs each frame. Used to update states.
function love.update(dt)
    -- This should pretty much call an update function tied to whatever scene we're in at the moment. TODO

    -- Tmp code to move objects slightly so I can see them reset with the game state
    if state.sprites_to_draw ~= nil then
        for _, sprite in pairs(state.sprites_to_draw) do
            sprite.x = sprite.x + 50 * dt
            sprite.y = sprite.y + 50 * dt
        end
    end

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

