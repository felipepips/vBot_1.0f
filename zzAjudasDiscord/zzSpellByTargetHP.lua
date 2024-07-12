-- USE SPELL BY TARGET HP %

-- START CONFIG
local config = { -- higher priority first
  [1] = {10,"spell -10% hp"},
  [2] = {50,"spell -50% hp"},
  [3] = {100,"spell any hp%"},
}
local exhausted = 1000
-- END CONFIG

macro(100,"Spell by Target HP",function()
  if not g_game.isAttacking() then return end
  local c = g_game.getAttackingCreature()
  local hp = c:getHealthPercent()
  for e, entry in ipairs(config) do
    if hp <= entry[1] then
      say(entry[2])
      delay(exhausted)
      return
    end
  end
end)