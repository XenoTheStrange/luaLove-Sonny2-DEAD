local function update_loading_bar(bar, num)
    bar.current = num
    bar.parts.bar.scale_x = num/bar.total
end

-- local loading_bar = engine.new(data.characters.loading_bar)
local function tracked_load(path, table, load_order, loading_bar)
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
        coroutine.yield()
    end
end

local function coroutine_listener()
    -- Resume loading coroutine if it exists
    if loadCoroutine and coroutine.status(loadCoroutine) ~= "dead" then
        coroutine.resume(loadCoroutine)
    end
    if loadCoroutine and coroutine.status(loadCoroutine) == "dead" then
        engine.remove_listener(coroutine_listener)
    end
end

return {
    init = function()
        print("Starting scene: engine/load_game")
        engine.loading.simple_load("engine/scenes", engine.scenes)

        local data_folders_load_order = require(config.game_data_directory .. "/data/load_order")

        -- Create a loading bar
        bar1 = engine.new(engine.characters.loading_bar)
        engine.draw(bar1)

        -- Wrap tracked_load in a coroutine
        loadCoroutine = coroutine.create(function()
            tracked_load(config.game_data_directory .. "/sprites", sprites, nil, bar1)
        end)
        engine.add_listener(coroutine_listener)

        --engine.loading.simple_load(config.game_data_directory .. "/sprites", sprites)
        -- engine.loading.simple_load(config.game_data_directory .. "/sounds", sounds)
        -- engine.loading.simple_load(config.game_data_directory .. "/data", data, data_folders_load_order)
        -- engine.loading.simple_load(config.game_data_directory .. "/scripts", scripts)
        -- scripts.init() -- Pass off control to game/scripts/init.lua
    end

}


-- local loading_bar = engine.new(data.characters.loading_bar)

-- tracked_load = function(path, table, load_order, loading_bar)
--     local data_files
--     if load_order ~= nil then
--         data_files = engine.loading.enumerate_files(path, load_order)
--     else
--         data_files = engine.loading.enumerate_files(path)
--     end
--     local total = #data_files
--     for i, file_info in ipairs(data_files) do
--         engine.loading.load_file_data(file_info, table, engine.loading.file_handlers)
--         update_loading_bar(i)
--     end
-- end