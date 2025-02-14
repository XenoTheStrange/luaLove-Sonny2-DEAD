-- Apply Glow Effect to a sprite (with optional parameters for customization)
local function shadowEffect(sprite, parent)
    -- Default glow properties
    local glowColor = {0, 0, 0, 0.5}  -- Black with some transparency (can be adjusted)
    local glowOffsetX = 0            -- Horizontal glow offset
    local glowOffsetY = 0            -- Vertical glow offset
    local glowSpread = 10            -- How much the glow spreads out (larger values for more blur)

    -- Set the glow color (for the glow effect)
    love.graphics.setColor(glowColor)

    -- Apply the glow effect
    love.graphics.push()  -- Start with the main push

    -- Calculate the part's position relative to its parent
    local partX = (sprite.x) * sprite.scale_x * gs
    local partY = (sprite.y) * sprite.scale_y * gs

    -- Apply the glow offset to the transformed position
    local glowX, glowY = partX + glowOffsetX, partY + glowOffsetY

    -- If there's a parent (e.g., a character), apply its position offset as well
    if parent then
        -- Adjust glow position based on the parent's position
        glowX = glowX + parent.x * screen_width
        glowY = glowY + parent.y * screen_height
    end

    -- Draw the glow by offsetting the sprite multiple times around the original position
    for i = 1, glowSpread do
        -- Slightly offset each layer of the glow to create the spread effect
        love.graphics.push()  -- Push for each individual glow layer

        -- Decrease opacity of the glow as we go outward
        love.graphics.setColor(glowColor[1], glowColor[2], glowColor[3], glowColor[4] * (1 - (i / glowSpread)))

        -- Apply a small offset for each glow layer
        love.graphics.translate(glowX + i, glowY + i)

        -- Draw the original sprite (without scaling) for the glow effect
        love.graphics.draw(sprite.sprite, 0, 0, 0, 1*gs, 1*gs, sprite.sprite:getWidth()/2, sprite.sprite:getHeight()/2)

        love.graphics.pop()  -- Pop after drawing each glow layer
    end

    -- Restore the original color and transformation matrix
    love.graphics.setColor(1, 1, 1, 1)

    -- Pop the main transformation matrix
    love.graphics.pop()
end


local function create_texts()
    -- Character to hold all screen scene texts
    local texts = engine.new(engine.characters.generic)
    texts.x, texts.y = 0.5,0.5

    -- Initialize the various texts as parts, then nil the base so it doesn't waste calls
    texts.parts.start = engine.new(texts.parts.base)
    texts.parts.credits = engine.new(texts.parts.base)
    texts.parts.base = nil

    -- Define fonts
    local font1 = love.graphics.newFont(54 * gs)
    local font2 = love.graphics.newFont(34 * gs)

    -- Set the sprites
    local start = love.graphics.newText(font1, "START")
    local credits = love.graphics.newText(font2, "Credits")
    texts.parts.start.sprite = start
    texts.parts.credits.sprite = credits
    engine.utils.add(texts.parts.credits, "y", 0.05)

    -- Position the texts (relative to each other and the center)
    
    -- Add shaders
    texts.parts.start.shaders = {shadowEffect}
    return texts
end

local function create_background()
    -- Parts relative to each other in the model cannot be relative to the size of the screen unless you use a formula containing the aspect_ratio and gs (global size)
    -- I don't want to do that.... hmmmmmm....

    -- Create characters
    local char = engine.characters.generic
    local bg = engine.new(char)
    local armorlogo = engine.new(char)
    local splat = engine.new(char)
    -- local sonnylogo = engine.new(char)

    -- Set the sprites
    bg.parts.base.sprite = sprites.title.background

    bg.scale_y = 1
    bg.scale_x = 1.2
    bg.x = 0.5
    bg.y = 0.5

    return bg
end

local self = {}
function self.init()
    engine.log("d", "Starting scene: pre_title")
    local texts = create_texts()
    local bg = create_background()
    engine.draw_all(bg, texts)
end

return self
