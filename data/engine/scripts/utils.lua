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
    set_defaults = function(table, defaults)
        if type(table) ~= "table" then 
            return 
        end
        for key, value in pairs(defaults) do
            if table[key] == nil then
                table[key] = value
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
    shift = function(item, value, amount)
        item[value] = item[value] + amount
    end
    

    
    
}
