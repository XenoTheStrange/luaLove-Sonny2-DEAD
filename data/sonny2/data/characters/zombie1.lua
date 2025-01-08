local zombie1 = {
    name = "zombie1",
    x = 500,
    y = 500,
    scale_x = 0.4,
    scale_y = 0.4,
    parts = engine.deep_copy(data.models.humanoid.parts)
}

zombie1.parts['arm_left_upper'].sprite = sprites.zombie1.arm
zombie1.parts['arm_left_lower'].sprite = sprites.zombie1.hand
zombie1.parts['leg_left_upper'].sprite = sprites.zombie1.arm
zombie1.parts['foot_left'].sprite = sprites.goofy.croc --sprites.zombie1.foot
zombie1.parts['foot_right'].sprite = sprites.goofy.croc --sprites.zombie1.foot
zombie1.parts['leg_right_lower'].sprite = sprites.zombie1.arm
zombie1.parts['leg_left_lower'].sprite = sprites.zombie1.arm
zombie1.parts['leg_left_lower'].scale_y = 1.3
zombie1.parts['leg_right_lower'].scale_y = 1.2
zombie1.parts['foot_right'].scale_x = 0.1
zombie1.parts['foot_right'].scale_y = 0.1
zombie1.parts['foot_left'].scale_x = 0.1
zombie1.parts['foot_left'].scale_y = 0.1
zombie1.parts['foot_left'].x = zombie1.parts['foot_left'].x+100
zombie1.parts['foot_right'].x = zombie1.parts['foot_right'].x+100
zombie1.parts['leg_right_upper'].sprite = sprites.zombie1.arm
zombie1.parts['torso'].sprite = sprites.zombie1.chest
zombie1.parts['head'].sprite = sprites.zombie1.head
zombie1.parts['arm_right_upper'].sprite = sprites.zombie1.arm
zombie1.parts['arm_right_lower'].sprite = sprites.zombie1.arm
zombie1.parts['weapon_right'].visible = false
zombie1.parts['weapon_left'].visible = false

return zombie1
