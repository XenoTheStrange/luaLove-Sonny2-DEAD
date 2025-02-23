-- entity.lua
local Entity = {}
Entity.__index = Entity

function Entity:addPart(partName, partParams)
    -- Ensure self.parts exists, use the existing table or create an empty one
    self.parts = self.parts or {}
    
    -- Define default part properties
    local defaultPart = {
        x = 0,
        y = 0,
        angle = 0,
        scale_x = 1,
        scale_y = 1,
        shear_x = 0,
        shear_y = 0,
        visible = true,
        sprite = engine.assets.missing, -- Assuming engine.assets.missing is available
        shaders = nil
    }
    
    -- Merge default properties with any provided parameters
    local newPart = partParams or {}
    for k, v in pairs(defaultPart) do
        if newPart[k] == nil then
            newPart[k] = v
        end
    end
    
    -- Add the new part to the parts table with the specified name
    self.parts[partName] = newPart
end

function Entity.new(params)
    if params == nil then params = {} end
    local self = setmetatable({}, Entity)
    
    self.name = (params.name or "entity_") .. tostring(math.random(1000, 9999))
    self.x = params.x or 0  -- 0-1 range relative to screen
    self.y = params.y or 0
    self.angle = params.angle or 0
    self.scale_x = params.scale_x or 1
    self.scale_y = params.scale_y or 1
    self.visible = params.visible ~= false
    self.shaders = params.shaders or nil
    
    self.parent = params.parent or nil
    self.children = {}
    
    self.parts = {}
    if params.parts then
        for partName, partData in pairs(params.parts) do
            self:addPart(partName, partData)
        end
    else
        self:addPart("base", {
            x = 0,
            y = 0,
            angle = 0,
            scale_x = 1,
            scale_y = 1,
            shear_x = 0,
            shear_y = 0,
            visible = true,
            sprite = params.sprite or engine.assets.missing,
            shaders = nil
        })
    end
    
    self.events = {
        onMouseDown = nil,
        onMouseUp = nil,
        onMouseIn = nil,
        onMouseOut = nil,
        onClick = nil
    }
    if params.events then
        for eventName, handler in pairs(params.events) do
            self.events[eventName] = handler
        end
    end
    
    self.Draw = params.draw or engine.characters.generic.Draw
    self.wasHovered = false  -- For tracking mouse in/out
    
    -- Automatically add to draw list
    -- if state.sprites_to_draw then
    --     table.insert(state.sprites_to_draw, self)
    -- end
    
    return self
end

function Entity:addChild(child)
    if child.parent then
        child.parent:removeChild(child)
    end
    child.parent = self
    table.insert(self.children, child)
end

function Entity:removeChild(child)
    for i, c in ipairs(self.children) do
        if c == child then
            table.remove(self.children, i)
            child.parent = nil
            return true
        end
    end
    return false
end

function Entity:getGlobalPosition()
    local x, y = self.x, self.y
    local current = self.parent
    while current do
        x = x * current.scale_x + current.x
        y = y * current.scale_y + current.y
        current = current.parent
    end
    return x, y
end

function Entity:triggerEvent(eventName, ...)
    if self.events[eventName] then
        self.events[eventName](self, ...)
    end
    if self.parent then
        self.parent:triggerEvent(eventName, ...)
    end
end

-- Add this to handle removal from draw list if needed
function Entity:destroy()
    if state.sprites_to_draw then
        for i, sprite in ipairs(state.sprites_to_draw) do
            if sprite == self then
                table.remove(state.sprites_to_draw, i)
                break
            end
        end
    end
    for _, child in ipairs(self.children) do
        child:destroy()
    end
end

return Entity