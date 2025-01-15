-- Love2d main loop script
-- What if I just leave this path alone...?
-- package.path = "./data/packages/?/init.lua;" .. "./data/packages/?.lua;" .. "./?.lua;" .. package.path
-- package.path = ("./data/" .. config.game_data_directory .. "/data/?.lua;") .. ("./data/" .. config.game_data_directory .. "/?/init.lua;") .. package.path



config = require("conf")
engine = require("engine.engine")
flux = require("packages.flux") -- This works and doesn't crash if packaged as a .love file

-- Set the global scale variable to a percentage to handle when the actual screen is smaller.... not perfect.
local target_width = 1920
local target_height = 1080
local screen_width, screen_height = love.graphics.getDimensions()
local aspect_ratio = screen_width / screen_height
local scale_x = screen_width / target_width
local scale_y = screen_height / target_height

config.global_sprite_scale = math.min(scale_x, scale_y)
gs = config.global_sprite_scale

-- Runs on program start. Load game data.
function love.load()
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

local function draw_characters()
    if state.sprites_to_draw == nil then 
        return
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

                -- if type(piece.sprite) == "userdata" and piece.sprite:typeOf("Text") then
                --     love.graphics.draw(
                --         piece.sprite, 
                --         (piece.x * sprite.scale_x * gs) * aspect_ratio, 
                --         piece.y * sprite.scale_y * gs,
                --         piece.angle * 0.017453292519943,
                --         sprite.scale_x * piece.scale_x * gs,
                --         sprite.scale_y * piece.scale_y * gs,
                --         piece.sprite:getWidth() / 2,

                --     )
                -- else
                -- Now draw the piece, accounting for its local position relative to the sprite center
                love.graphics.draw(
                    piece.sprite, 
                    (piece.x * sprite.scale_x * gs) * aspect_ratio,  -- Adjust for aspect ratio on x
                    piece.y * sprite.scale_y * gs,  -- y remains unchanged
                    piece.angle * 0.017453292519943,  -- piece rotation still applies
                    sprite.scale_x * piece.scale_x * gs,
                    sprite.scale_y * piece.scale_y * gs,
                    piece.sprite:getWidth() / 2, -- Origin offset x axis
                    piece.sprite:getHeight() / 2, -- Origin offset y axis
                    piece.shear_x,
                    piece.shear_y
                )
            -- end
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

-- Runs when any ascii key is pressed. Ignores shift so you can type caps & symbols.
function love.textinput(text)
end

