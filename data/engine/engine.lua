return {
    init_game = function()
        local game_init = require(config.game_data_directory ..  "/init")
        game_init()
    end,
    restart_game = function()
        data = {}
        scripts = {}
        sprites = {}
        sounds = {}
        state = {
            sprites_to_draw = {},
            updaters = {},
            coroutines = {
                queue = {},
                current = nil
            }
        }
        
        -- Engine is not hot reloaded btw
        engine.utils = require("engine/scripts/utils") 
        engine.loading = require("engine/scripts/loading")
        engine.prefabs = require("engine/scripts/prefabs")

        -- Order matters. Scenes depend on characters which depend on sprites.
        engine.assets = {}
        engine.characters = {}
        engine.scenes = {}
        engine.entity = require("engine/entity")
        engine.loading.simple_load("engine/assets", engine.assets)
        engine.loading.simple_load("engine/characters", engine.characters)
        engine.loading.simple_load("engine/scenes", engine.scenes)
        engine.init_game()
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

        -- Insert the sprite
        table.insert(state.sprites_to_draw, sprite)
        
        -- Sort characters by z_index (if needed)
        table.sort(state.sprites_to_draw, function(a, b)
            return (a.z_index or 0) < (b.z_index or 0)
        end)
    end,
    -- TIL unpacking values is kind of quirky.
    -- Try draw_all(var, var, var, var ...) or draw_all(returns_many_sprites())
    draw_all = function(...)
        args = {...}
        for _, sprite in pairs(args) do
            engine.draw(sprite)
        end
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
    erase_all = function(...)
        local sprites_to_erase = {...}
        
        if state.sprites_to_draw == nil then
            return -- No sprites to remove
        end
        
        for _, sprite_to_erase in ipairs(sprites_to_erase) do
            -- Find and remove each sprite from state.sprites_to_draw
            for i, sprite in ipairs(state.sprites_to_draw) do
                if sprite == sprite_to_erase then
                    table.remove(state.sprites_to_draw, i)
                    break -- Break to avoid unnecessary iterations
                end
            end
        end
    end,
    draw_text = function(func)
        if state.love_draw_functions == nil then
            state.love_draw_functions = {}
        end
        table.insert(state.love_draw_functions, func)
    end,
    erase_text = function(func)
        if state.love_draw_functions == nil then
            return -- Nothing to remove
        end
    
        -- Find the sprite in the array and remove it
        for i, s in ipairs(state.love_draw_functions) do
            if s == func then
                table.remove(state.love_draw_functions, i)
                break -- Exit the loop after removing to avoid unnecessary iterations
            end
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
        -- local screen_width, screen_height = love.graphics.getDimensions()
        -- local center_x, center_y = screen_width / 2, screen_height / 2
        -- return {x = center_x, y = center_y}
    end,
    log = function(level, msg)
        local prefix
        if level == "d" then
            prefix = "[DEBUG] "
        elseif level == "i" then
            prefix = "[INFO] "
        elseif level == "w" then
            prefix = "[WARN] "
        elseif level == "e" then
            prefix = "[ERROR] "
        elseif level == "c" then
            prefix = "[CRITICAL] "
        end
        print(prefix .. msg)
    end,
    coroutine_manager = function(dt)
        -- Process the linear queue (state.coroutines.queue)
        if not state.coroutines.current or coroutine.status(state.coroutines.current) == "dead" then
            if #state.coroutines.queue > 0 then
                state.coroutines.current = table.remove(state.coroutines.queue, 1)
            else
                state.coroutines.current = nil -- No more coroutines in queue
            end
        end
    
        if state.coroutines.current and coroutine.status(state.coroutines.current) ~= "dead" then
            local success, err = coroutine.resume(state.coroutines.current)
            if not success then
                engine.log("e","Queue coroutine error: " .. err) -- Debugging output for queue coroutine
            end
        end
        -- Guard clause to prevent crash if list is empty
        if state.coroutines.consecutive == nil then
            return
         end
        -- Process all coroutines in state.coroutines.consecutive simultaneously
        for i = #state.coroutines.consecutive, 1, -1 do
            local consecutive_coro = state.coroutines.consecutive[i]
            
            -- Resume each consecutive coroutine
            if coroutine.status(consecutive_coro) ~= "dead" then
                local success, err = coroutine.resume(consecutive_coro)
                if not success then
                    print("Consecutive coroutine error:", err) -- Debugging output for consecutive coroutine
                end
            end
            
            -- Remove dead coroutines from consecutive
            if coroutine.status(consecutive_coro) == "dead" then
                table.remove(state.coroutines.consecutive, i)
            end
        end
    end,

    queue_routine = function(func)
        -- Automatically wrap the function in a coroutine and enqueue it
        local coro = coroutine.create(func)
        table.insert(state.coroutines.queue, coro)
    end,    
    do_routine = function(func)
        local coro = coroutine.create(func)
        table.insert(state.coroutines.consecutive, coro)
    end,
    getWidth = function(sprite)
        return sprite:getWidth()
    end,
    getHeight = function(sprite)
        return sprite:getHeight()
    end,
    
    
    -- load_svg_as_image_data = function(imagePath, imgWidth, imgHeight)
    --     IDEA ABANDONED. Tove didn't render shit right nor work the way I wanted, svglover failed trying to interpret text as RGB data, 
    --     2 days is long enough to be frustrated about this. I'll just pre-render the bitches as png.
    --     Consider retrying svglover and clean up the source svg files so they render properly???
    -- end
    
}
