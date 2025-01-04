ball = {
    name = "ball",
    x = 500,
    y = 500,
    parts = {
        base = {
            angle = 18,
            tint = {0.2,0.8,0.8,1},
            sprite=sprites.debug.ball
        },
        left = {
            x=-100,
            angle = 65
        },
        right = {
            x=100,
            angle=86,
            tint={0.2, 0, 0.2, 1}
        }
    }
}

return ball
