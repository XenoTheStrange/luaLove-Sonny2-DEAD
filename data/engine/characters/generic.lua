local Draw = function(sprite)
    -- Apply any shaders at the sprite level (for the whole character)
    if sprite.shaders then
        for _, shaderFunc in ipairs(sprite.shaders) do
            shaderFunc(sprite)  -- Run shader function
        end
    end

    local partsArray = sprite.sorted_parts or {}
    for _, piece in ipairs(partsArray) do
        if piece.visible == true then
            -- Apply any shaders at the part level (for individual parts)
            if piece.shaders then
                for _, shaderFunc in ipairs(piece.shaders) do
                    shaderFunc(piece, sprite)  -- Run part-specific shader function
                end
            end

            if piece.tint then
                love.graphics.setColor(piece.tint)
            else 
                love.graphics.setColor(1, 1, 1, 1)
            end

            -- Save the current transformation matrix
            love.graphics.push()
            -- Translate to the sprite's position (before rotation)
            love.graphics.translate(sprite.x * screen_width, sprite.y * screen_height)
            -- Apply the global rotation of the sprite (sprite.angle)
            love.graphics.rotate(sprite.angle * 0.017453292519943)

            -- Now draw the piece, accounting for its local position relative to the sprite center
            love.graphics.draw(
                piece.sprite, 
                ((piece.x * screen_width) * sprite.scale_x * gs) * aspect_ratio,
                (piece.y * screen_height) * sprite.scale_y * gs,
                piece.angle * 0.017453292519943,  -- piece rotation still applies
                sprite.scale_x * piece.scale_x * gs,
                sprite.scale_y * piece.scale_y * gs,
                piece.sprite:getWidth() / 2, -- Origin offset x axis
                piece.sprite:getHeight() / 2, -- Origin offset y axis
                piece.shear_x,
                piece.shear_y
            )

            -- Restore the previous transformation matrix
            love.graphics.pop()
        end
    end
end

-- This generic character template can be used for things which aren't traditional character dolls

local generic = {
    name = "generic",
    x = 0,
    y = 0,
    angle = 0,
    scale_x = 1,
    scale_y = 1,
    visible = true,
    shaders = nil, -- Optional
    onHover = nil, -- Optional (not used)
    onClick = nil, -- Optional (not used)
    Draw = Draw,
    parts = {
        base = {
            x = 0,
            y = 0,
            angle = 0,
            scale_x = 1,
            scale_y = 1,
            shear_x = 0,
            shear_y = 0,
            visible = true,
            sprite = engine.sprites.missing,
            shaders = nil, -- Optional
            onHover = nil, -- Optional (not used)
            onClick = nil -- Optional (not used)
        }
    }
}

return generic

-- SHADERS
-- shaders = {func, func2, func3}
-- functions will be run in order on the char as a whole and/or each part as they contain functions
