local character = engine.new(engine.characters.generic)
local frames = sprites.frame_animations.armorgames_intro

-- All the frames in this animation rendered offset so they need tweaked
character.x = 0.5 + (57/vwidth)
character.y = 0.5 - (30/vheight)
character.parts.base.sprite = frames["1"]


local function start()
    engine.draw(character)
    sounds["Armor Games Intro"]:setVolume(0.1) -- Jesus Fucking Christ that was loud
    sounds["Armor Games Intro"]:play()
end

local function finish(listener)
    engine.remove_listener(listener)
    engine.erase(character)
    data.scenes.pre_title.init()
end

local total_playtime = 4.3
local numFrames = 98

local elapsedTime = 0
local currentFrame = 1
local frameDuration = total_playtime/numFrames

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
