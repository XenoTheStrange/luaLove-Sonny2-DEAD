ball = {
    name = "ball",
    x = 400,
    y = 0,
    model = "ball",
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


for _, part in pairs(ball.parts) do
    engine.utils.set_defaults(part, {visible = true, x=0, y=0, angle=0, scale_x=1, scale_y=1, sprite=sprites.debug.missing})
end

return ball
