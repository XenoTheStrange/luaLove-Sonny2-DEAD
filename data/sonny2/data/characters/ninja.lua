local ninja = {
    name = "ninja",
    x = 500,
    y = 500,
    parts = engine.deep_copy(data.models.humanoid.parts)
}
ninja.parts.shoulder = {
    z_index = 14,
    x = -89,
    y = -539,
}

local s = sprites.ninja
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

engine.utils.map_to_key_in_table(tmp, "sprite", ninja.parts)

return ninja
