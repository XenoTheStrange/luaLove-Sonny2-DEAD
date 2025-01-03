local ninja = {
    name = "ninja",
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
ninja.parts['shoulder'].sprite = sprites.ninja.shoulder
ninja.parts['hand_right'].sprite = sprites.ninja.hand
ninja.parts['weapon_right'].sprite = sprites.ninja.hand
ninja.parts['weapon_left'].sprite = sprites.ninja.hand

return ninja
