local params = {
    name = "ball",
    x = 0.7,
    y = 0.7,
    parts = {
        base = {
            angle = 0,
            tint = {0.2,0.8,0.8,1},
            sprite=sprites.debug.ball
        },
        left = {
            x=-0.1,
            angle = 0,
            sprite=sprites.debug.ball
    },
        right = {
            x=0.1,
            angle=0,
            tint={0.2, 0, 0.2, 1},
            sprite=sprites.debug.ball
        }
    }
    
}

return engine.entity.new(params)
