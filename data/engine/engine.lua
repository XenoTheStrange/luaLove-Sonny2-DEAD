return {
    restart_game = function()
        print("Resetting game state...")
        data = {}
        scripts = {}
        sprites = {}
        sounds = {}
        state = {
            sprites_to_draw = {},
            updaters = {}
        }

        engine.utils = require("engine/scripts/utils") -- Engine is not hot reloaded btw
        engine.load_game_data()
    end,
    
    load_game_data = function()
        engine.load_sprites(config.game_data_directory .. "/sprites", sprites)
        engine.load_audio(config.game_data_directory .. "/sounds", sounds)
        --engine.load_scripts()
        data_folders_load_order = require(config.game_data_directory .. "/data/load_order")
        engine.populate_data(config.game_data_directory .. "/data", data, true, data_folders_load_order)
        engine.populate_data(config.game_data_directory .. "/scripts", scripts, true)
    end,

    load_sprites = function(base_path, output)
        -- Recursively load sprites from the base_path into the output table, using folder/filenames as keys and values
        -- TODO Render svg files and load them like the pngs.
        local items = love.filesystem.getDirectoryItems(base_path)
        
        for _, item in ipairs(items) do
            local full_path = base_path .. "/" .. item

            -- Check if the item is a directory or a file
            if love.filesystem.getInfo(full_path, "directory") then
                output[item] = {}
                engine.load_sprites(full_path, output[item])
            elseif item:match("%.png$") then
                -- Remove the ".png" extension for the key
                local key = item:gsub("%.png$", "")
                output[key] = love.graphics.newImage(full_path)
            elseif item:match("%.svg$") then
                -- Placeholder for handling other image formats
                print("Found an svg at \"" .. full_path .."\", Please convert to png manually.")
            end
        end
    end,
    load_audio = function(base_path, output)
        -- Recursively load sprites from the base_path into the output table, using folder/filenames as keys and values
        -- TODO Render svg files and load them like the pngs.
        local items = love.filesystem.getDirectoryItems(base_path)
        
        for _, item in ipairs(items) do
            local full_path = base_path .. "/" .. item

            -- Check if the item is a directory or a file
            if love.filesystem.getInfo(full_path, "directory") then
                output[item] = {}
                engine.load_sprites(full_path, output[item])
            elseif item:match("%.mp3$") then
                -- Remove the ".png" extension for the key
                local key = item:gsub("%.mp3$", "")
                output[key] = love.audio.newSource(full_path, "stream")
            end
        end
    end,


    populate_data = function(base_path, output, load_files, load_order)
        local items = love.filesystem.getDirectoryItems(base_path)
        local processed = {}
    
        -- Helper function to load a specific folder
        local function load_folder(item)
            local full_path = base_path .. "/" .. item
            if love.filesystem.getInfo(full_path, "directory") then
                print("Loading directory:", full_path)
                output[item] = {}
                engine.populate_data(full_path, output[item], load_files, load_order)  -- Recursively load subfolders
            elseif load_files and item:match("%.lua$") then
                local key = item:gsub("%.lua$", "")
                print("Loading Lua file:", full_path)
                package.loaded[full_path:gsub("%.lua$", "")] = nil
                local success, result = pcall(function() return require(full_path:gsub("%.lua$", "")) end)
                if success then
                    output[key] = result
                else
                    print("Error loading Lua file:", full_path, result)
                end
            end
            processed[item] = true
        end
    
        -- First, process folders in the specified load order
        if load_order then
            for _, folder in ipairs(load_order) do
                if love.filesystem.getInfo(base_path .. "/" .. folder, "directory") then
                    load_folder(folder)
                end
            end
        end
    
        -- Process remaining folders/files not covered by load_order
        for _, item in ipairs(items) do
            if not processed[item] then
                load_folder(item)
            end
        end
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
        print("Adding updater function", func)
        if state.updaters == nil then
            state.updaters = {}
        end
        table.insert(state.updaters, func)
    end,
    remove_listener = function(func)
        print("Removing updater function")
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
