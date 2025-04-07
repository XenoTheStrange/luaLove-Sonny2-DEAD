local function shadowEffect(sprite)
    -- Debug: Check sprite position

    -- Default glow properties
    local glowColor = {0, 0, 0, 0.5}
    local glowOffsetX = 1
    local glowOffsetY = 1
    local glowSpread = 8

    local VIRTUAL_WIDTH = 1920
    local VIRTUAL_HEIGHT = 1080

    love.graphics.setColor(glowColor)
    love.graphics.push()

    -- Ensure that sprite.x and sprite.y are valid
    local partX = sprite.x * VIRTUAL_WIDTH
    local partY = sprite.y * VIRTUAL_HEIGHT

    local glowX, glowY = partX + glowOffsetX, partY + glowOffsetY

    for i = 1, glowSpread do
        love.graphics.push()
        love.graphics.setColor(glowColor[1], glowColor[2], glowColor[3], glowColor[4] * (1 - (i / glowSpread)))
        love.graphics.translate(glowX + i, glowY + i)
        love.graphics.draw(sprite.parts.base.sprite, 0, 0, 0, 1, 1, sprite.parts.base.sprite:getWidth()/2, sprite.parts.base.sprite:getHeight()/2)
        love.graphics.pop()
    end

    love.graphics.setColor(1, 1, 1, 1)
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
    local font1 = love.graphics.newFont("sonny2/fonts/2738_Rockwell.ttf", 104)
    local font2 = love.graphics.newFont("sonny2/fonts/2738_Rockwell.ttf", 54)

    -- Set the sprites
    local start_font = love.graphics.newText(font1, "PLAY")
    local credits_font = love.graphics.newText(font2, "Credits")
    start.parts.base.sprite = start_font
    credits.parts.base.sprite = credits_font
    
    -- Add shaders
    start.shaders = {shadowEffect}
    credits.shaders = {shadowEffect}
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
