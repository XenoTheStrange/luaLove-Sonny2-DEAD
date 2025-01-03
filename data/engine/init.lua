return {
    restart_game = function()
        print("Resetting game state...")
        data = {}
        scripts = {}
        sprites = {}
        state = {}

        engine.utils = require("engine/scripts/utils") -- Engine is not hot reloaded btw
        engine.load_game_data()
    end,
    
    load_game_data = function()
        engine.load_sprites(config.game_data_directory .. "/sprites", sprites)
        print("Sprites: " .. engine.utils.tp(sprites))
        --engine.load_scripts()
        data_folders_load_order = require(config.game_data_directory .. "/data/load_order")
        engine.populate_data(config.game_data_directory .. "/data", data, true, data_folders_load_order)
        engine.populate_data(config.game_data_directory .. "/scripts", scripts, true)
        print("Scripts: " .. engine.utils.tp(scripts))

    end,

    load_structure = function()
        print("Loading data structure from file at ./" .. config.game_data_directory .. "/data_structure")
        data = require(config.game_data_directory .. "/data_structure")
        
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
                -- Remove the ".svg" extension for the key
                local key = item:gsub("%.svg$", "")
                print("Loading SVG from: " .. full_path)
                output[key] = engine.load_svg_as_image_data(full_path, 100, 100)
            end
        end
    end,

    get_template = function()
        print("Loading scripts...")
        scripts = require(config.game_data_directory .. "/scripts")
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

    load_svg_as_image_data = function()
        -- TODO CAIRO
    end
    
}
