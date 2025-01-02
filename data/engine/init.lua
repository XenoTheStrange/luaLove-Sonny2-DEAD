return {
    restart_game = function()
        print("Resetting game state...")
        data = {}
        scripts = {}
        sprites = {}
        state = {}

        engine.utils = require("engine/scripts/utils")
        engine.load_game_data()
    end,
    
    load_game_data = function()
        engine.load_structure()
        print("Initial Data Structure: " .. engine.utils.tp(data))
        engine.load_sprites(config.game_data_directory .. "/sprites", sprites)
        print("Sprites: " .. engine.utils.tp(sprites))
        engine.load_scripts()
        print("Scripts: " .. engine.utils.tp(scripts))
        engine.populate_data(config.game_data_directory .. "/data", data)
        print("Loaded Game Data: " .. engine.utils.tp(data))
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
                print("Creating directory in output for:", full_path)
                output[item] = {}
                engine.load_sprites(full_path, output[item])
            elseif item:match("%.png$") then
                -- Remove the ".png" extension for the key
                local key = item:gsub("%.png$", "")
                print("Loading sprite:", full_path)
                output[key] = love.graphics.newImage(full_path)
            end
        end
    end,

    load_scripts = function()
        print("Loading scripts...")
        scripts = require(config.game_data_directory .. "/scripts")
    end,

    populate_data = function(base_path, output)
        -- Print the base_path to see if it's correct
        print("Attempting to read directory:", base_path)
    
        -- Get the list of items in the current folder
        local items = love.filesystem.getDirectoryItems(base_path)
    
        -- Check if any items were found
        if not items or #items == 0 then
            print("No items found in:", base_path)
        else
            print("Items found in", base_path, ":", #items)
        end
    
        for _, item in ipairs(items) do
            local full_path = base_path .. "/" .. item
    
            -- Check if the item is a directory or a file
            if love.filesystem.getInfo(full_path, "directory") then
                print("Creating directory in output for:", full_path)
                output[item] = {}
                engine.populate_data(full_path, output[item])  -- Recursively load subfolders
            elseif item:match("%.lua$") then
                -- Remove the ".lua" extension for the key
                local key = item:gsub("%.lua$", "")
                print("Loading Lua file:", full_path)
    
                -- Use pcall to safely attempt loading the Lua file
                package.loaded[full_path:gsub("%.lua$", "")] = nil
                local success, result = pcall(function() return require(full_path:gsub("%.lua$", "")) end)
    
                if success then
                    output[key] = result
                    print("Successfully loaded:", full_path)
                else
                    print("Error loading Lua file:", result)
                end
            else
                print("Skipping non-Lua file:", full_path)
            end
        end
    end
    
    
}