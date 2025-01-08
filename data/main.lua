-- Love2d main loop script
package.path = "./data/packages/?/init.lua;" .. "./data/packages/?.lua;" .. "./?.lua;"
config = require("conf")
--package.path = ("./data/" .. config.game_data_directory .. "/data/?.lua;") .. ("./data/" .. config.game_data_directory .. "/?/init.lua;") .. package.path

engine = require("engine/init")
data = {}
scripts = {}
state = {
    sprites_to_draw = {}
}

flux = require("flux")

-- Runs on program start. Load game data.
function love.load()
    engine.restart_game()
    scripts.init()
    state.sprites_to_draw = {data.characters.klima_soldier} -- TODO make a func that pushes things into the to_draw array and sorts it
    love.graphics.setBackgroundColor(177/255,221/255,1,1)
end

function love.draw()
    if state.sprites_to_draw == nil then 
        return -- prevent crash at start :|
    end
    
    -- Sort characters by z_index
    -- TODO move this logic to a func that doesn't run every frame, but only when the array is modified
    table.sort(state.sprites_to_draw, function(a, b)
        return (a.z_index or 0) < (b.z_index or 0)  -- Default to 0 if no z_index is set
    end)

    -- Draw each character and their parts
    for _, sprite in ipairs(state.sprites_to_draw) do
        -- Convert parts from a dictionary to an array
        local partsArray = {}
        for key, piece in pairs(sprite.parts) do
            table.insert(partsArray, piece)
        end
        
        -- Sort parts by z_index
        -- TODO see above todo, sorting shouldn't happen every frame.
        table.sort(partsArray, function(a, b)
            return (a.z_index or 0) < (b.z_index or 0)
        end)

        -- Draw sorted parts
        for _, piece in ipairs(partsArray) do
            if piece.visible == true then
                if piece.tint then
                    love.graphics.setColor(piece.tint)
                else 
                    love.graphics.setColor(1, 1, 1, 1) -- Prevent retaining the previous tint
                end
                love.graphics.draw(
                    piece.sprite, 
                    sprite.x + (piece.x * sprite.scale_x),  -- Adjust position based on character scale
                    sprite.y + (piece.y * sprite.scale_y),  -- Adjust position based on character scale
                    piece.angle * (math.pi / 180), -- turn our degree angle into radians for love2d
                    sprite.scale_x * piece.scale_x,  -- Apply both character and part scales
                    sprite.scale_y * piece.scale_y,  -- Apply both character and part scales
                    piece.sprite:getWidth() / 2, -- Origin centered
                    piece.sprite:getHeight() / 2,
                    piece.shear_x,
                    piece.shear_y
                )               
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

