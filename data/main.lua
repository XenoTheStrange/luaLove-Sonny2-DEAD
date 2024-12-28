-- Love2d main loop script
package.path = "./data/packages/?/init.lua;" .. "./data/packages/?.lua;" .. package.path

-- Runs on program start. Load game data.
function love.load()
    flux = require("flux") -- animation helper
    data = require("scripts/data_structure")
end

-- Runs each frame. Used to draw sprites.
function love.draw()
end

-- Runs each frame. Used to update states.
function love.update(dt)
end

-- Runs when any key is pressed.
function love.keypressed(k)

    -- Temporary code to make it easier to test stuff
	if k == 'escape' then
		love.event.push('quit') -- Quit the game.
    elseif k == 'backspace' then
        love.event.quit( "restart" )
	end	

end

-- Runs when any ascii key is pressed. Ignores shift so you can type caps & symbols.
function love.textinput(text)
end

mainLoop = love.run()
