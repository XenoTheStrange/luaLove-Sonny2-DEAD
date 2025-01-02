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
    end
}
