-- This file is a stand-in for another loading screen that looks like the original. It should be renamed to load_game_debug.lua in the future.

local function update_loading_bar(bar, num)
    bar.current = num
    bar.parts.bar.scale_x = num/bar.total
end

-- local loading_bar = engine.new(data.characters.loading_bar)
local function tracked_load(path, table, load_order, loading_bar, files_per_yield)
    -- Get a list of files (use load order if needed)
    local data_files
    if load_order ~= nil then
        data_files = engine.loading.enumerate_files(path, load_order)
    else
        data_files = engine.loading.enumerate_files(path)
    end
    -- initialize loading bar
    loading_bar.total = #data_files

    for i, file_info in ipairs(data_files) do
        -- Load file data
        engine.loading.load_file_data(file_info, table, engine.loading.file_handlers)
        -- Update loading bar
        update_loading_bar(loading_bar, i)

        -- Yield so the screen can be updated
        -- Every 10 files processed so the framerate isn't capping our load speed (as much at least)
        if files_per_yield == nil then
            files_per_yield = 10
        end
        if i % files_per_yield == 1 then
            coroutine.yield()
        end
    end
end

return {
    init = function()
        print("Starting scene: engine/load_game")
        engine.loading.simple_load("engine/scenes", engine.scenes)

        local data_folders_load_order = require(config.game_data_directory .. "/data/load_order")
       
        -- Create a loading bars
        local bar1 = engine.new(engine.characters.loading_bar)
        local bar2 = engine.new(engine.characters.loading_bar)
        local bar3 = engine.new(engine.characters.loading_bar)
        local bar4 = engine.new(engine.characters.loading_bar)
        local barheight = bar1.parts.background1.sprite:getHeight()
        local center = engine.get_screen_center()
        
        -- Loading text in the middle of the screen
        local font = love.graphics.newFont(48)
        local drawable = love.graphics.newText(font, "LOADING")
        local LOADING = engine.new(engine.characters.generic)
        LOADING.parts.base.sprite = drawable
        LOADING.x = center.x - drawable:getWidth()/2
        LOADING.y = center.y - drawable:getHeight()/2
        LOADING.parts.base.tint = {1,1,1,1}
        
        -- Set positions and colors for loading bars
        bar1.x = center.x
        bar2.x = center.x
        bar3.x = center.x
        bar4.x = center.x
        bar1.y = center.y - barheight*2 -- Center then up 2 bar widths
        bar2.y = center.y - barheight*1 -- Center then up 1 bar width
        bar3.y = center.y + barheight*1 -- Center then down 1 bar width
        bar4.y = center.y + barheight*2 -- Center then down 2 bar widths
        bar1.parts.bar.scale_x = 0
        bar2.parts.bar.scale_x = 0
        bar3.parts.bar.scale_x = 0
        bar4.parts.bar.scale_x = 0
        bar1.parts.bar.tint = {0,176/255,1,1} -- Sky blue
        bar2.parts.bar.tint = {1,102/255,0,1} -- Orange
        bar3.parts.bar.tint = {60/255,168/255,84/255,1} -- Green
        bar4.parts.bar.tint = {241/255,196/255,15/255,1} -- yellow
        engine.draw_all(bar1, bar2, bar3, bar4, LOADING)

        -- Define our loading functions so they can be turned into coroutines (can be done inline as anonymous functions but I hate it)
        local load_sprites = function() tracked_load(config.game_data_directory .. "/sprites", sprites, nil, bar1) end
        local load_sounds = function() tracked_load(config.game_data_directory .. "/sounds", sounds, nil, bar2) end
        local load_data = function() tracked_load(config.game_data_directory .. "/data", data, data_folders_load_order, bar3) end
        local load_scripts = function() tracked_load(config.game_data_directory .. "/scripts", scripts, nil, bar4) end
        local continue = function()
            engine.erase_all(bar1, bar2, bar3, bar4, LOADING)
            print("DONE")
            scripts.init()
        end

        -- Queue up our loading routines and contine
        engine.queue_routine(load_sprites) 
        engine.queue_routine(load_sounds)
        engine.queue_routine(load_data)
        engine.queue_routine(load_scripts)
        engine.queue_routine(continue)
    end

}
