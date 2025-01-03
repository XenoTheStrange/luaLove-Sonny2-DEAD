ball = {
    name = "ball",
    x = 400,
    y = 0,
    parts = {
        base = {
            angle = 15,
            tint = {0.2,0.6,0.8,1},
            sprite=sprites.debug.ball
        },
        left = {
            x=-100,
        },
        right = {
            x=100,
            angle=45,
            tint={0.2, 0, 0.2, 1}
        }
    }
}

return ball
