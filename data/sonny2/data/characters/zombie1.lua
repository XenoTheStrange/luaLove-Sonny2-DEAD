local zombie1 = {
    name = "zombie1",
    x = 500,
    y = 500,
    parts = engine.deep_copy(data.models.humanoid.parts)
}

local s = sprites.zombie1

local tmp = {
    arm_left_upper = s.arm,
    arm_left_lower = s.hand,
    leg_left_upper = s.arm,
    foot_left = s.foot,
    foot_right = s.foot,
    leg_right_lower = s.arm,
    leg_right_upper = s.arm,
    leg_left_lower = s.arm,
    head = s.head,
    torso = s.chest,
    arm_right_upper = s.arm,
    arm_right_lower = s.hand

}

local p = zombie1.parts
engine.utils.map_to_key_in_table(tmp, "sprite", p)


engine.utils.add(p.leg_left_lower.scale_y, 0.3)
engine.utils.add(p.leg_left_lower.scale_x, 0.3)
engine.utils.add(p.foot_left.x, 100)
engine.utils.add(p.foot_right.x, 100)

return zombie1
