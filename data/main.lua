-- Love2d main loop script
-- What if I just leave this path alone...?
-- package.path = "./data/packages/?/init.lua;" .. "./data/packages/?.lua;" .. "./?.lua;" .. package.path
-- package.path = ("./data/" .. config.game_data_directory .. "/data/?.lua;") .. ("./data/" .. config.game_data_directory .. "/?/init.lua;") .. package.path



config = require("conf")
engine = require("engine.engine")
flux = require("packages.flux") -- This works and doesn't crash if packaged as a .love file

-- Set the global scale variable to a percentage to handle when the actual screen is smaller.... not perfect.
screen_width = 0
screen_height = 0
aspect_ratio = 0
gs = 0

-- Runs on program start. Load game data.
function love.load()
    love.resize()
    engine.restart_game()
end

local function draw_love_graphics()
    if state.love_draw_functions ~= nil then
        for _, func in ipairs(state.love_draw_functions) do
            love.graphics.push()  -- Save the current transformation matrix before calling the function
            func()                -- Run the custom drawing function (e.g., text)
            love.graphics.pop()   -- Restore the previous transformation matrix after the function
        end
    end
end

-- Note: expects normalized positions because Fuck all that math bullshit me and the homies hate coordinates
local function draw_characters()
    if state.sprites_to_draw == nil then 
        return
    end

    for _, sprite in ipairs(state.sprites_to_draw) do
        -- Apply any shaders at the sprite level (for the whole character)
        if sprite.shaders then
            for _, shaderFunc in ipairs(sprite.shaders) do
                shaderFunc(sprite)  -- Run shader function
            end
        end

        local partsArray = sprite.sorted_parts or {}
        for _, piece in ipairs(partsArray) do
            if piece.visible == true then
                -- Apply any shaders at the part level (for individual parts)
                if piece.shaders then
                    for _, shaderFunc in ipairs(piece.shaders) do
                        shaderFunc(piece, sprite)  -- Run part-specific shader function
                    end
                end

                if piece.tint then
                    love.graphics.setColor(piece.tint)
                else 
                    love.graphics.setColor(1, 1, 1, 1)
                end

                -- Save the current transformation matrix
                love.graphics.push()
                -- Translate to the sprite's position (before rotation)
                love.graphics.translate(sprite.x * screen_width, sprite.y * screen_height)
                -- Apply the global rotation of the sprite (sprite.angle)
                love.graphics.rotate(sprite.angle * 0.017453292519943)

                -- Now draw the piece, accounting for its local position relative to the sprite center
                love.graphics.draw(
                    piece.sprite, 
                    ((piece.x * screen_width) * sprite.scale_x * gs) * aspect_ratio,
                    (piece.y * screen_height) * sprite.scale_y * gs,
                    piece.angle * 0.017453292519943,  -- piece rotation still applies
                    sprite.scale_x * piece.scale_x * gs,
                    sprite.scale_y * piece.scale_y * gs,
                    piece.sprite:getWidth() / 2, -- Origin offset x axis
                    piece.sprite:getHeight() / 2, -- Origin offset y axis
                    piece.shear_x,
                    piece.shear_y
                )

                -- Restore the previous transformation matrix
                love.graphics.pop()
            end
        end
    end
end

function love.draw()
    if config.show_fps then 
        engine.show_fps()
    end
    draw_love_graphics()
    draw_characters()
end

-- Call each function in state.updaters (used for all sorts of detections)
local function call_updaters(dt)
    if state.updaters ~= nil then
        for _, func in ipairs(state.updaters) do
            func(dt)
        end
    end
end

-- Runs each frame. Used to update states.
function love.update(dt)
    flux.update(dt) -- Needed to use flux
    call_updaters(dt)
    engine.coroutine_manager(dt) -- Update all routines in state
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

function love.resize()
    -- Set the global scale variable to a percentage to handle when the actual screen is smaller.... not perfect.
    screen_width, screen_height = love.graphics.getDimensions()
    aspect_ratio = screen_width / screen_height
    local scale_x = screen_width / 1920
    local scale_y = screen_height / 1080

    config.global_sprite_scale = math.min(scale_x, scale_y)
    gs = config.global_sprite_scale
end

-- Runs when any ascii key is pressed. Ignores shift so you can type caps & symbols.
function love.textinput(text)
end


