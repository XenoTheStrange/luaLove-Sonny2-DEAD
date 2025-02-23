-- This runs after all game data is loaded in. Specific to the game running and not part of the engine.
local function finally()
    -- Set the default keys for all the jazz in characters
    part_defaults = {visible = true, x=0, y=0, angle=0, shear_x=0, shear_y=0, scale_x=1, scale_y=1, sprite=sprites.debug.missing} -- Don't wanna type it all, but must avoid crash :P
    character_defaults = {visible = true, x=0, y=0, angle=0, scale_x=1, scale_y=1}

    engine.utils.set_defaults_foreach_in(data.characters, character_defaults)
    for _, character in pairs(data.characters) do
        engine.utils.set_defaults_foreach_in(character.parts, part_defaults)
    end

    -- Launch the intro cutscene
    -- Proceeds to scene pre_title.lua
    if config.debug.skip_intro then 
        data.scenes.pre_title.init()
    else
        data.animations.armorgames_intro()
    end
end

-- data/engine/scenes/load_game.lua
-- This file is a stand-in for another loading screen that looks like the original. It should be renamed to load_game_debug.lua in the future.


-- Create a Canvas-based progress bar sprite
local function newRectangleCanvas(width, height, initial_progress)
    local canvas = love.graphics.newCanvas(width, height)
    local progress = initial_progress or 0
    local storedWidth = width  -- Store width locally
    local storedHeight = height  -- Store height locally

    local function updateCanvas(storedWidth, storedHeight, progress)  -- Add parameters
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)  -- Explicitly white for progress
        love.graphics.rectangle("fill", 0, 0, storedWidth * progress, storedHeight)  -- Use parameters
        love.graphics.setColor(1, 1, 1, 1)  -- Reset (debug)
        love.graphics.setCanvas()
        --print("Canvas updated: progress =", progress, "width =", storedWidth * progress, "height =", storedHeight)  -- Debug
    end

    local rectangleCanvas = {
        canvas = canvas,
        width = storedWidth,  -- Store width explicitly
        height = storedHeight,  -- Store height explicitly
        progress = 0,
        setProgress = function(self, p)
            self.progress = math.min(math.max(p or 0, 0), 1)
            updateCanvas(storedWidth, storedHeight, self.progress)  -- Pass stored values
        end,
        getWidth = function() return storedWidth end,
        getHeight = function() return storedHeight end,
        refresh = function(self)
            updateCanvas(storedWidth, storedHeight, self.progress)  -- Pass stored values
        end
    }

    updateCanvas(storedWidth, storedHeight, progress) -- Initial draw with parameters
    return rectangleCanvas
end

-- ... (rest of load_game.lua unchanged until createLoadingBar)

-- In createLoadingBar, define refreshCanvases as a method
local function createLoadingBar()
    local bar = {
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
                name = "b1",
                x = 0,
                y = 0,
                angle = 0,
                tint = {1, 1, 1, 1},  -- White background
                scale_x = 1.05,
                scale_y = 1.2,
                shear_x = 0,
                shear_y = 0,
                visible = true,
                sprite = love.graphics.newCanvas(600, 100)  -- Fatter bar
            },
            background2 = {
                z_index = 2,
                x = 0,
                y = 0,
                angle = 0,
                tint = {0, 0, 0, 1},  -- Black background
                scale_x = 1,
                scale_y = 1,
                shear_x = 0,
                shear_y = 0,
                visible = true,
                sprite = love.graphics.newCanvas(600, 100)  -- Fatter bar
            },
            bar = {
                z_index = 3,
                x = 0,
                y = 0,
                angle = 0,
                tint = {1, 1, 1, 1},  -- White progress
                scale_x = 1,
                scale_y = 1,
                shear_x = 0,
                shear_y = 0,
                visible = true,
                sprite = nil,  -- Set below
                progressManager = newRectangleCanvas(600, 100, 0)  -- Fatter bar
            }
        },
        Draw = engine.characters.generic.Draw,
        refreshCanvases = function(self)
            self.parts.bar.progressManager:refresh()
        end  -- Explicitly using `self` here
    }

    -- Initialize static canvases
    love.graphics.setCanvas(bar.parts.background1.sprite)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)  -- White
    love.graphics.rectangle("fill", 0, 0, 600, 100)
    love.graphics.setCanvas()

    love.graphics.setCanvas(bar.parts.background2.sprite)
    love.graphics.clear()
    love.graphics.setColor(0, 0, 0, 1)  -- Black
    love.graphics.rectangle("fill", 0, 0, 600, 100)
    love.graphics.setCanvas()

    -- Link progress bar canvas
    bar.parts.bar.sprite = bar.parts.bar.progressManager.canvas

    return bar
end

-- ... (rest of update_loading_bar, tracked_load unchanged)
local function init()
    engine.log("d", "GAME INIT")
    local data_folders_load_order = require(config.game_data_directory .. "/data/load_order")

    -- Create loading bars with unique canvases
    local bar1 = createLoadingBar()
    local bar2 = createLoadingBar()
    local bar3 = createLoadingBar()
    local bar4 = createLoadingBar()
    local barheight = (bar1.parts.background1.sprite:getHeight() * gs) / screen_height  -- Normalized

    -- Loading text in the middle
    local font = love.graphics.newFont("sonny2/data/fonts/2738_Rockwell.ttf", 68 * gs)
    local drawable = love.graphics.newText(font, "LOADING")
    local LOADING = engine.new(engine.characters.generic)
    LOADING.parts.base.sprite = drawable
    LOADING.x = 0.5
    LOADING.y = 0.5
    LOADING.parts.base.tint = {1, 1, 1, 1}

    -- Set positions and colors
    bar1.x = 0.5
    bar2.x = 0.5
    bar3.x = 0.5
    bar4.x = 0.5
    bar1.y = 0.5 - barheight * 2
    bar2.y = 0.5 - barheight
    bar3.y = 0.5 + barheight
    bar4.y = 0.5 + barheight * 2
    bar1.parts.bar.tint = {0, 176/255, 1, 1}         -- Sky blue
    bar2.parts.bar.tint = {1, 102/255, 0, 1}         -- Orange
    bar3.parts.bar.tint = {60/255, 168/255, 84/255, 1} -- Green
    bar4.parts.bar.tint = {241/255, 196/255, 15/255, 1} -- Yellow
    engine.draw_all(bar1, bar2, bar3, bar4, LOADING)

    -- Define loading functions with canvas refresh
    local load_sprites = function()
        engine.loading.tracked_load(config.game_data_directory .. "/sprites", sprites, nil, bar1)
    end
    local load_sounds = function()
        engine.loading.tracked_load(config.game_data_directory .. "/sounds", sounds, nil, bar2)
    end
    local load_data = function()
        engine.loading.tracked_load(config.game_data_directory .. "/data", data, data_folders_load_order, bar3)
    end
    local load_scripts = function()
        engine.loading.tracked_load(config.game_data_directory .. "/scripts", scripts, nil, bar4)
    end
    local continue = function()
        engine.erase_all(bar1, bar2, bar3, bar4, LOADING)
        finally()
    end

    -- Queue routines
    engine.queue_routine(load_sprites)
    engine.queue_routine(load_sounds)
    engine.queue_routine(load_data)
    engine.queue_routine(load_scripts)
    engine.queue_routine(continue)
end

return init