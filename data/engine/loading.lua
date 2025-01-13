return {
    file_handlers = {
        lua = function(path)
            package.loaded[path:gsub("%.lua$", "")] = nil
            local success, result = pcall(function() return require(path:gsub("%.lua$", "")) end)
            if success then
                return result
            else
                print("Error loading Lua file:", path, result)
                return nil
            end
        end,
    
        png = function(path)
            return love.graphics.newImage(path)
        end,
    
        mp3 = function(path)
            return love.audio.newSource(path, "stream")
        end
    },

    load_file_data = function(file_info, output, handlers)
        local path = file_info.path
        local ext = path:match("([^%.]+)$")
    
        -- Check if it's a directory or file
        if love.filesystem.getInfo(path, "directory") then
            -- If it's a directory, do nothing and return
            return
        end
    
        -- Now process the file for the matching handler
        for ext_key, handler in pairs(handlers) do
            if ext == ext_key then
                -- Calculate the relative path by skipping the base directory (e.g., "sonny2/")
                local relative_path = path:sub(#config.game_data_directory + 1)  -- Remove base directory (e.g., "sonny2/")
    
                -- Ensure there is no leading slash and correctly format the key path
                relative_path = relative_path:sub(2)  -- Remove the leading "/"
                
                -- Convert slashes ("/") to dots (".") to create key path
                -- Remove file extensions such as ".lua", ".mp3", ".png", etc.
                local key_path = relative_path:gsub("/", "."):gsub("%.[^%.]+$", "")  -- Strip the extension from the key

    
                -- Call the appropriate handler to load the data for this file
                local data = handler(path)
    
                -- Split the key_path into separate keys
                local keys = {}
                for key in key_path:gmatch("[^.]+") do
                    table.insert(keys, key)
                end
    
                -- Insert the data into the correct position in the output table
                local current = output
    
                local first_key = keys[1]
                if first_key then
                    -- Remove the first key from the list to skip it (since it's the base folder like "sprites" or "scripts")
                    table.remove(keys, 1)
                end
               
                
                -- After this, check if the current is directly referencing the right place and not adding extra nesting
                
    
                -- Process the remaining subdirectories and files
                for i, key in ipairs(keys) do
                    if i == #keys then
                        -- At the last key, assign the data directly (don't add another nested level)
                        current[key] = data
                    else
                        -- For intermediate keys, ensure an empty table is created
                        if not current[key] then
                            current[key] = {}
                        end
                        current = current[key]
                    end
                end
    
                return
            end
        end
    end,               

    enumerate_files = function(base_path, load_order)
        local total_items = {}
        local processed = {}
    
        -- Helper function to enumerate folders and files
        local function process_folder(item)
            local full_path = base_path .. "/" .. item
            if love.filesystem.getInfo(full_path, "directory") then
                table.insert(total_items, {type = "directory", path = full_path})
                local sub_items = engine.loading.enumerate_files(full_path, nil)
                for _, sub_item in ipairs(sub_items) do
                    table.insert(total_items, sub_item)
                end
            else
                table.insert(total_items, {type = "file", path = full_path, extension = item:match("%.([^.]+)$")})
            end
            processed[item] = true
        end
    
        -- First, enumerate folders in the specified load order
        if load_order then
            for _, folder in ipairs(load_order) do
                if love.filesystem.getInfo(base_path .. "/" .. folder, "directory") then
                    process_folder(folder)
                end
            end
        end
    
        -- Process remaining folders/files not covered by load_order
        local items = love.filesystem.getDirectoryItems(base_path)
        for _, item in ipairs(items) do
            if not processed[item] then
                process_folder(item)
            end
        end
    
        return total_items
    end,

    simple_load = function(path, table, load_order)
        local data_files
        if load_order ~= nil then
            data_files = engine.loading.enumerate_files(path, load_order)
        else
            data_files = engine.loading.enumerate_files(path)
        end

        for i, file_info in ipairs(data_files) do
            engine.loading.load_file_data(file_info, table, engine.loading.file_handlers)
            -- Update loading bar or perform other operations here
        end
    end
    
}
