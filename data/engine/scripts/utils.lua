return {
    -- Prints a lua table as a string, recursive to get all (for debugging)
    -- Table Print
    tp = function(o)
        if type(o) == 'table' then
           local s = '{ '
           for k,v in pairs(o) do
              if type(k) ~= 'number' then k = '"'..k..'"' end
              s = s .. '['..k..'] = ' .. engine.utils.tp(v) .. ','
           end
           return s .. '} '
        else
           return tostring(o)
        end
     end,
    -- Prints the top-level keys from a lua table
    -- Table Print Pairs
    tpp = function(o)
        for key, value in pairs(o) do
            print(key, value)
        end
    end,
    set_defaults = function(target, source)
        if type(target) ~= "table" then 
            return 
        end
        for key, value in pairs(source) do
            if target[key] == nil then
                target[key] = value
            end
        end
    end,

    set_defaults_foreach_in = function(table, defaults)
        if type(table) ~= "table" then  return end
        for key, value in pairs(table) do
            engine.utils.set_defaults(value, defaults)
        end
    end,
    -- Changes some numerical value in an object by some amount
    add = function(item, key, amount)
        item[key] = item[key] + amount
    end,
    -- Takes a table and maps values 1 layer down.
    -- i.e. if "tmp" is an array containing part_name = sprite, 
    -- engine.utils.map_to_key_in_table(tmp, "sprite", zombie1.parts)
    -- will define the sprite for each part in zombie1.parts using values from tmp
    map_to_key_in_table = function(source, key, target)
    for name, value in pairs(source) do
        target[name][key] = value
    end
end
    

    
    
}
