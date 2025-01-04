local ninja = {
    name = "ninja",
    x = 300,
    y = 200,
    scale_x = 1,
    scale_y = 1,
    parts = data.models.humanoid.parts
}

ninja.parts['arm_left_upper'].sprite = sprites.ninja.arm
ninja.parts['arm_left_lower'].sprite = sprites.ninja.hand
ninja.parts['foot_left'].sprite = sprites.ninja.foot
ninja.parts['leg_left_upper'].sprite = sprites.ninja.arm
ninja.parts['leg_left_lower'].sprite = sprites.ninja.leg
ninja.parts['foot_right'].sprite = sprites.ninja.foot
ninja.parts['leg_right_upper'].sprite = sprites.ninja.arm
ninja.parts['leg_right_lower'].sprite = sprites.ninja.leg
ninja.parts['torso'].sprite = sprites.ninja.chest
ninja.parts['head'].sprite = sprites.ninja.head
ninja.parts['arm_right_upper'].sprite = sprites.ninja.arm
ninja.parts['arm_right_lower'].sprite = sprites.ninja.arm
ninja.parts['shoulder'].sprite = sprites.ninja.shoulder
ninja.parts['weapon_right'].sprite = sprites.weapons.katana
ninja.parts['weapon_left'].sprite = sprites.weapons.katana
love.graphics.setBackgroundColor(177/255,221/255,1,1)
return ninja
