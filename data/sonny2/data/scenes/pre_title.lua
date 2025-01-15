local self = {}

local texts = engine.new(engine.characters.generic)
local t1 = love.graphics.newText(love.graphics.getFont(48*gs), "START")
texts.parts.base.sprite = t1
local center = engine.get_screen_center()
texts.x = center.x
texts.y = center.y

function self.init()
    print("This is where you'd start the scene. TODO")

    engine.draw(texts)
end

return self
