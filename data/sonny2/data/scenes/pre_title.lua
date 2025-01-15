local center = engine.get_screen_center()

-- Apply Drop Shadow Effect to a sprite (with optional parameters for customization)
local function shadowEffect2(sprite, parent)
    -- Default drop shadow properties
    local shadowColor = {0, 0, 0, 0.5}  -- Black with some transparency
    local shadowOffsetX = 4  -- Horizontal shadow offset
    local shadowOffsetY = 4  -- Vertical shadow offset
    local shadowBlur = 10     -- How much the shadow is blurred

    -- Set the shadow color
    love.graphics.setColor(shadowColor)

    -- Apply the shadow offset and blur (can customize these values)
    love.graphics.push()

    -- Calculate the part's position relative to its parent
    local partX = sprite.x * sprite.scale_x * gs * aspect_ratio
    local partY = sprite.y * sprite.scale_y * gs

    -- Apply the shadow offset to the transformed position
    local shadowX, shadowY = partX + shadowOffsetX, partY + shadowOffsetY
    
    -- If there's a parent (e.g., a character), apply its position offset as well
    if parent then
        -- Adjust shadow position based on the parent's position
        shadowX = shadowX + parent.x * gs
        shadowY = shadowY + parent.y * gs
    end

    -- Translate to the shadow position (offset the sprite position)
    love.graphics.translate(shadowX, shadowY)

    -- Apply shadow blur (you may want to use a custom shader for more advanced blur effects)
    -- For this example, we're just drawing the shadow slightly offset
    love.graphics.setLineWidth(shadowBlur)

    -- Draw the shadow (simulate a shadow effect by drawing the sprite with an offset)
    love.graphics.draw(sprite.sprite, 0, 0, 0, 1, 1, sprite.sprite:getWidth()/2, sprite.sprite:getHeight()/2)

    -- Restore the transformation matrix
    love.graphics.pop()

    -- Reset the color to white (or the default color)
    love.graphics.setColor(1, 1, 1, 1)
end

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
    local partX = sprite.x * sprite.scale_x * gs * aspect_ratio
    local partY = sprite.y * sprite.scale_y * gs

    -- Apply the glow offset to the transformed position
    local glowX, glowY = partX + glowOffsetX, partY + glowOffsetY

    -- If there's a parent (e.g., a character), apply its position offset as well
    if parent then
        -- Adjust glow position based on the parent's position
        glowX = glowX + parent.x
        glowY = glowY + parent.y
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
        love.graphics.draw(sprite.sprite, 0, 0, 0, 1, 1, sprite.sprite:getWidth()/2, sprite.sprite:getHeight()/2)

        love.graphics.pop()  -- Pop after drawing each glow layer
    end

    -- Restore the original color and transformation matrix
    love.graphics.setColor(1, 1, 1, 1)

    -- Pop the main transformation matrix
    love.graphics.pop()
end


function create_texts()
    -- Character to hold all screen scene texts
    local texts = engine.new(engine.characters.generic)
    texts.x, texts.y = center.x, center.y

    -- Initialize the various texts as parts, then nil the base so it doesn't waste calls
    texts.parts.start = engine.new(texts.parts.base)
    texts.parts.credits = engine.new(texts.parts.base)
    texts.parts.base = nil

    -- Define fonts
    local font1 = love.graphics.newFont(48 * gs)
    local font2 = love.graphics.newFont(24 * gs)

    -- Set the sprites
    local start = love.graphics.newText(font1, "START")
    local credits = love.graphics.newText(font2, "Credits")
    texts.parts.start.sprite = start
    texts.parts.credits.sprite = credits

    -- Position the texts (relative to each other and the center)
    engine.utils.add(texts.parts.credits, "y", engine.getHeight(texts.parts.start.sprite) + (50*gs))
    
    -- Add shaders
    texts.parts.start.shaders = {shadowEffect}--, dropShadowEffect}
    return texts
end

local function create_background()
    -- Create character (centered)
    local bg = engine.new(engine.characters.generic)
    bg.x, bg.y = center.x, center.y

    -- Init parts
    bg.parts.background = engine.new(bg.parts.base)
    bg.parts.armorlogo = engine.new(bg.parts.base)
    --bg.parts.sonnylogo = engine.new(bg.parts.base)
    bg.parts.splat = engine.new(bg.parts.base)
    bg.parts.base = nil

    -- Set the sprites
    bg.parts.background.sprite = sprites.title.background
    bg.parts.armorlogo.sprite = sprites.logos.armor1
    --bg.parts.sonnylogo.sprite = engine.sprites.missing
    bg.parts.splat.sprite = sprites.title.splat

    -- Set positions and sizes of background elements
    bg.parts.background.z_index = 0
    bg.parts.background.scale_y = 1
    bg.parts.background.scale_x = 1.2

    -- Top left corner of the screen
    bg.parts.armorlogo.z_index = 2
    engine.utils.add(bg.parts.armorlogo, "x", 0 - center.x + engine.getWidth(bg.parts.armorlogo.sprite) - (50*gs))
    engine.utils.add(bg.parts.armorlogo, "y", 0 - center.y + engine.getHeight(bg.parts.armorlogo.sprite))

    bg.parts.splat.z_index = 1
    --bg.parts.splat.scale_x,bg.parts.splat.scale_y = 0.9,0.9
    engine.utils.add(bg.parts.splat, "y", -50*gs)
    engine.utils.add(bg.parts.splat, "x", -385*gs)
    return bg
end

local self = {}
function self.init()
    engine.log("d", "Starting scene: pre_title")
    local texts = create_texts()
    local background = create_background()
    engine.draw_all(background, texts)
end

return self
