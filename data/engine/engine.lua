return {
    restart_game = function()
        data = {}
        scripts = {}
        sprites = {}
        sounds = {}
        state = {
            sprites_to_draw = {},
            updaters = {}
        }

        engine.utils = require("engine/scripts/utils") -- Engine is not hot reloaded btw
        engine.loading = require("engine/loading")
        engine.scenes = {}
        
        -- TODO move all this jazz to engine.scenes.load_game and init that
        -- Once it runs and everything is loaded, that scene can pass control to data.scenes.init() or something, idk.
        local data_folders_load_order = require(config.game_data_directory .. "/data/load_order")
        engine.loading.simple_load("engine/scenes", engine.scenes)
        engine.loading.simple_load(config.game_data_directory .. "/sounds", sounds)
        engine.loading.simple_load(config.game_data_directory .. "/sprites", sprites)
        engine.loading.simple_load(config.game_data_directory .. "/data", data, data_folders_load_order)
        engine.loading.simple_load(config.game_data_directory .. "/scripts", scripts)

        -- engine.load_game_data()
    end,

    deep_copy = function(tbl)
        local copy = {}
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                copy[k] = engine.deep_copy(v)
            else
                copy[k] = v
            end
        end
        return copy
    end,
    show_fps = function()
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    end,
    clear = function()
        state.sprites_to_draw = {}
    end,
    draw = function(sprite)
        if state.sprites_to_draw == nil then
            state.sprites_to_draw = {}
        end
        -- Insert the sprite
        table.insert(state.sprites_to_draw, sprite)
        
        -- Sort sprite's parts by z_index once
        local partsArray = {}
        for key, piece in pairs(sprite.parts) do
            table.insert(partsArray, piece)
        end
        table.sort(partsArray, function(a, b)
            return (a.z_index or 0) < (b.z_index or 0)
        end)
        
        -- Store sorted parts back into the sprite
        sprite.sorted_parts = partsArray
    
        -- Sort characters by z_index (if needed)
        table.sort(state.sprites_to_draw, function(a, b)
            return (a.z_index or 0) < (b.z_index or 0)
        end)
    end,
    erase = function(sprite)
        if state.sprites_to_draw == nil then
            return -- Nothing to remove
        end
    
        -- Find the sprite in the array and remove it
        for i, s in ipairs(state.sprites_to_draw) do
            if s == sprite then
                table.remove(state.sprites_to_draw, i)
                break -- Exit the loop after removing to avoid unnecessary iterations
            end
        end
    end,
    draw_all = function(...)
        args = {...}
        for _, sprite in pairs(args) do
            engine.draw(sprite)
        end
    end,
    new = function(template)
        local tmp = engine.deep_copy(template)
        return tmp
    end,
    add_listener = function(func)
        if state.updaters == nil then
            state.updaters = {}
        end
        table.insert(state.updaters, func)
    end,
    remove_listener = function(func)
        if state.updaters == nil then
            return
        end
        for i, val in ipairs(state.updaters) do
            if val == func then
                table.remove(state.updaters, i)
                break
            end
        end
    end,
    get_screen_center = function()
        local screen_width, screen_height = love.graphics.getDimensions()
        local center_x, center_y = screen_width / 2, screen_height / 2
        return {x = center_x, y = center_y}
    end,
    

    -- load_svg_as_image_data = function(imagePath, imgWidth, imgHeight)
    --     IDEA ABANDONED. Tove didn't render shit right nor work the way I wanted, svglover failed trying to interpret text as RGB data, 
    --     2 days is long enough to be frustrated about this. I'll just pre-render the bitches as png.
    --     Consider retrying svglover and clean up the source svg files so they render properly???
    -- end
    
}
