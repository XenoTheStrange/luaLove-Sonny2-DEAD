local klima = {
    name = "Klima Soldier",
    x = 500,
    y = 500,
    -- scale_x = 0.5,
    -- scale_y = 0.5,
    parts = engine.deep_copy(data.models.humanoid.parts)
}
local p = klima.parts

p.shoulder = {
    z_index = 14,
    x = -89,
    y = -539,
    scale_x = 0.9,
    scale_y = 0.9
}


-- Tweak wonky-looking position values

engine.utils.add(p.head, "x", -10)
engine.utils.add(p.head, "y", 80)
engine.utils.add(p.arm_right_lower, "shear_x", -0.15)
-- Legs need moved slightly left
legparts = {"leg_left_upper", "leg_left_lower", "leg_right_upper", "leg_right_lower", "foot_left", "foot_right"}
for _, part in ipairs(legparts) do
  engine.utils.add(p[part], "x", -40)
end

s = sprites.klima_soldier
local tmp = {
  arm_left_upper = s.arm,
  arm_left_lower = s.hand,
  leg_left_upper = s.arm,
  foot_left = s.foot,
  foot_right = s.foot,
  leg_right_lower = s.leg,
  leg_right_upper = s.arm,
  leg_left_lower = s.leg,
  head = s.head,
  torso = s.chest,
  arm_right_upper = s.arm,
  arm_right_lower = s.hand,
  shoulder = s.shoulder
}


engine.utils.map_to_key_in_table(tmp, "sprite", klima.parts)
-- Set sprites
-- klima.parts['arm_left_upper'].sprite = sprites.klima.arm
-- klima.parts['arm_left_lower'].sprite = sprites.klima.hand
-- klima.parts['foot_left'].sprite = sprites.klima.foot
-- klima.parts['leg_left_upper'].sprite = sprites.klima.arm
-- klima.parts['leg_left_lower'].sprite = sprites.klima.leg
-- klima.parts['foot_right'].sprite = sprites.klima.foot
-- klima.parts['leg_right_upper'].sprite = sprites.klima.arm
-- klima.parts['leg_right_lower'].sprite = sprites.klima.leg
-- klima.parts['torso'].sprite = sprites.klima.chest
-- klima.parts['head'].sprite = sprites.klima.head
-- klima.parts['arm_right_upper'].sprite = sprites.klima.arm
-- klima.parts['arm_right_lower'].sprite = sprites.klima.hand
-- klima.parts['shoulder'].sprite = sprites.klima.shoulder
-- klima.parts['foot_right'].sprite = sprites.klima.foot
-- klima.parts['foot_left'].sprite = sprites.klima.foot

return klima
