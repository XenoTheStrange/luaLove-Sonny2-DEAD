-- This file expects to be in the base data directory in place of main.lua.
-- I had to get a little feel for how I need to approach this.

package.path = "./data/packages/?/init.lua;" .. "./data/packages/?.lua;" .. package.path

local flux = require("flux")

print("It didn't crash!")

function love.load() -- load data into the game (runs once on program start)
    ball = {
        x = 0,
        y = 0,
        visible = false,
        sprite = love.graphics.newImage("sprites/ball.png") -- Returns a Drawable Image https://love2d.org/wiki/Image
    }
    -- using love.graphics.getHeight(ball.sprite) returns incorrect values
    ball.height = ball.sprite.getHeight(ball.sprite)
    ball.width = ball.sprite.getWidth(ball.sprite)
end

function love.draw() -- draw sprites under certain conditions (runs each frame)
    if ball.visible then
        love.graphics.draw(ball.sprite, ball.x, ball.y) -- Takes an image and a size and draws it to screen
    end
end

function love.update(dt) -- every frame
    flux.update(dt)
    if love.mouse.isDown(1) then -- if left mouse down
        ball.visible = true
        x,y = love.mouse.getPosition()
        -- x,y = mouse position - half the size of the ball, so it targets the ball's center (images are top left corner oriented)
        x = x - (ball.width/2)
        y = y - (ball.height/2)

        print("Going to x:",x," y:",y)
        flux.to(ball, 0.2, {x=x,y=y}) -- this causes the X and Y values of ball to change to the new x and y values over time (0.2 seconds)
    elseif ball.visible then
        ball.visible = false
    end
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.push('quit') -- Quit the game.
	end	
end

function love.textinput(text)
    -- print(text)
end

mainLoop = love.run()
