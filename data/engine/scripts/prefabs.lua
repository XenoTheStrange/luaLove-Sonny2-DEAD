return {
    rectangle = function(width, height, color)
        if color == nil then color = {0,0,0,1} end
        local canvas = love.graphics.newCanvas(width, height)
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setCanvas()
        return canvas
    end
}