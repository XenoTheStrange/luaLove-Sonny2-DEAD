local character = engine.new(data.characters.generic)
local frames = sprites.frame_animations.armorgames_intro

coords = engine.get_screen_center()
-- All the frames in this animation rendered offset so they need tweaked
character.x = coords.x + 106
character.y = coords.y - 50
character.parts.base.sprite = frames["2"]


local function start()
    print("Playing armorgames intro sequence.")

    engine.draw(character)
    sounds["Armor Games Intro"]:play()
end

local function finish(listener)
    engine.remove_listener(listener)
    data.scenes.pre_title.init()
end

local total_playtime = 4.3
local numFrames = 98

local elapsedTime = 0
local currentFrame = 1
local frameDuration = total_playtime/numFrames -- 4.3/109 = 0.039449541284404

local step = 1

local function update_animation(dt)
    elapsedTime = elapsedTime + dt
    if elapsedTime >= frameDuration then
        currentFrame = currentFrame + 1
        character.parts.base.sprite = frames[tostring(currentFrame)]
        if currentFrame == 22 then
            frameDuration = 0.06 -- Sync up the latter half of the animation with the audio
        end
        if currentFrame >= numFrames then -- Finished
            finish(update_animation)
        end
        elapsedTime = 0
    end
end


return function()
    engine.add_listener(update_animation) -- cannot put this inside of start().... it won't get called if you do (????)
    start()
end
