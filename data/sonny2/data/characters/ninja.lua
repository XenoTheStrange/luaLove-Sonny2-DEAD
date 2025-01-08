local ninja = {
    name = "ninja",
    x = 500,
    y = 500,
    scale_x = 0.5,
    scale_y = 0.5,
    parts = engine.deep_copy(data.models.humanoid.parts)
}
ninja.parts.shoulder = {
    z_index = 14,
    x = -89,
    y = -539,
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
ninja.parts['weapon_right'].sprite = sprites.weapons.katana_custom
ninja.parts['weapon_left'].sprite = sprites.weapons.katana

ninja.parts['foot_right'].sprite = sprites.goofy.croc
ninja.parts['foot_left'].sprite = sprites.goofy.croc
ninja.parts['foot_right'].scale_x = 0.1
ninja.parts['foot_right'].scale_y = 0.1
ninja.parts['foot_left'].scale_x = 0.1
ninja.parts['foot_left'].scale_y = 0.1

return ninja
