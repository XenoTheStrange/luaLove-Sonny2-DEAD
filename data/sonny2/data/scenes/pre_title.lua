-- Apply Glow Effect to a sprite (with optional parameters for customization)
local function shadowEffect(sprite, parent)
    -- Default glow properties
    local glowColor = {0, 0, 0, 0.5}  -- Black with some transparency (can be adjusted)
    local glowOffsetX = 1            -- Horizontal glow offset
    local glowOffsetY = 1            -- Vertical glow offset
    local glowSpread = 8            -- How much the glow spreads out (larger values for more blur)

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
    -- Characters to hold various texts
    local start = engine.new(engine.characters.generic)
    local credits = engine.new(engine.characters.generic)
    start.x, start.y = 0.5,0.6
    credits.x, credits.y = 0.45,0.7
    start.z_index = 4
    credits.z_index = 4

    -- Define fonts
    local font1 = love.graphics.newFont("sonny2/data/fonts/2738_Rockwell.ttf", 104 * gs)
    local font2 = love.graphics.newFont("sonny2/data/fonts/2738_Rockwell.ttf", 54 * gs)

    -- Set the sprites
    local start_font = love.graphics.newText(font1, "PLAY")
    local credits_font = love.graphics.newText(font2, "Credits")
    start.parts.base.sprite = start_font
    credits.parts.base.sprite = credits_font
    
    -- Add shaders
    start.parts.base.shaders = {shadowEffect}
    credits.parts.base.shaders = {shadowEffect}
    return start, credits
end

local function create_background()
    -- Parts relative to each other in the model cannot be relative to the size of the screen unless you use a formula containing the aspect_ratio and gs (global size)
    -- I don't want to do that.... hmmmmmm....

    -- Create parts
    local bg = engine.entity.new(
        {
            name = "Background Image",
            z_index = 0,
            scale_x = 1.2,
            scale_y = 1,
            parts = {
                base = {
                    sprite = sprites.title.background
                }
            }
        }
    )

    local armorlogo = engine.entity.new(
        {
            name = "Armor Logo 1",
            z_index = 3,
            x = 0.12,
            y = 0.05,
            parts = {
                base = {
                    sprite = sprites.logos.armor1
                }
            }
        }
    )

    local splat = engine.entity.new(
        {
            name = "Title splat",
            z_index = 2,
            x = 0.12,
            y = 0.4,
            scale_x = 0.95,
            scale_y = 0.95,
            parts = {
                base = {
                    sprite = sprites.title.splat
                }
            }
        }
    )

    local decal = engine.entity.new(
        {
            name = "Title decal",
            z_index = 1,
            scale_x = 1.2,
            fuckery = "yeah",
            parts = {
                base = {
                    sprite = sprites.title.decal
                }
            }
        }
    )

    return splat, armorlogo, bg, decal
end

local self = {}
function self.init()
    engine.log("d", "Starting scene: pre_title")
    engine.draw_all(create_texts())
    engine.draw_all(create_background())
end

return self
