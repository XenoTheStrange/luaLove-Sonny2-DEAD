-- This is an example animations
-- Within this system, animations are functions which take an object and tween its parts.
-- Animations can use frames or whatever so long as they aren't blocking.
-- They can run functions at different points in their execution which can completely alter the control flow of the program.
-- Use that feature with caution.

function anim(ball) -- can be named anything as long as it's returned
    flux.to(ball, 1, {y = 500})
    :ease("linear")
    :after(ball, 1, {y = 100})
    :ease("linear")
    :oncomplete(function() anim(ball) end)
end

return function(ball)
        anim(ball)
    end
