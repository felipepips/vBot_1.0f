-- CAST SPELL WITH DELAY / COOLDOWN

-- START CONFIG
local spell = "utevo gran res sac"
local cooldown = 5 -- seconds (900 = 15min)
-- END CONFIG

macro(100,"Auto Empowerment",function()
  if canCast(spell) then
    cast(spell,cooldown*1000)
    delay(cooldown*1000)
  end
end)
