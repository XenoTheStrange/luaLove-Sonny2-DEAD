local klima = {
    name = "Klima Soldier",
    x = 500,
    y = 500,
    scale_x = 0.5,
    scale_y = 0.5,
    parts = engine.deep_copy(data.models.humanoid.parts)
}
klima.parts.shoulder = {
    z_index = 14,
    x = -89,
    y = -539,
  }
  
klima.parts['arm_left_upper'].sprite = sprites.klima.arm
klima.parts['arm_left_lower'].sprite = sprites.klima.hand
klima.parts['foot_left'].sprite = sprites.klima.foot
klima.parts['leg_left_upper'].sprite = sprites.klima.arm
klima.parts['leg_left_lower'].sprite = sprites.klima.leg
klima.parts['foot_right'].sprite = sprites.klima.foot
klima.parts['leg_right_upper'].sprite = sprites.klima.arm
klima.parts['leg_right_lower'].sprite = sprites.klima.leg
klima.parts['torso'].sprite = sprites.klima.chest
klima.parts['head'].sprite = sprites.klima.head
klima.parts['arm_right_upper'].sprite = sprites.klima.arm
klima.parts['arm_right_lower'].sprite = sprites.klima.arm
klima.parts['shoulder'].sprite = sprites.klima.shoulder
klima.parts['weapon_right'].sprite = sprites.weapons.katana_custom
klima.parts['weapon_left'].sprite = sprites.weapons.katana

klima.parts['foot_right'].sprite = sprites.goofy.croc
klima.parts['foot_left'].sprite = sprites.goofy.croc
klima.parts['foot_right'].scale_x = 0.1
klima.parts['foot_right'].scale_y = 0.1
klima.parts['foot_left'].scale_x = 0.1
klima.parts['foot_left'].scale_y = 0.1

return klima
