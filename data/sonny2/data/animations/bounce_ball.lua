-- This is an example animations
-- Within this system, animations are functions which take an object and tween its parts.
-- Animations can use frames or whatever so long as they aren't blocking.
-- They can run functions at different points in their execution which can completely alter the control flow of the program.
-- Use that feature with caution.

local function anim(ball) -- can be named anything as long as it's returned
    flux.to(ball, 1, {y = 0.5})
    :ease("linear")
    :after(ball, 1, {y = 0.7})
    :ease("linear")
    :oncomplete(function() anim(ball) end)

    flux.to(ball.parts.left, 1, {x = 0.1})
    :ease("linear")
    :after(ball.parts.left, 1, {x = -0.1})
    :ease("linear")

    flux.to(ball.parts.right, 1, {x = -0.1})
    :ease("linear")
    :after(ball.parts.right, 1, {x = 0.1})
    :ease("linear")
end

return function(ball)
        anim(ball)
    end
