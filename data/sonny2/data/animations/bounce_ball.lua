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
