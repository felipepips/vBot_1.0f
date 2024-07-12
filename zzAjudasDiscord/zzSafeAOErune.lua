-- Auto Attack with Area Rune on target only if no players on screen
-- Tags: safe pvp AOE gfb avalanche 

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

--CONFIG HERE:
local RUNE_ID = 3191
local MIN_MONSTERS_TO_USE_RUNE = 1
local EXHAUSTED_TIME = 1000 --milliseconds
--END CONFIG

local time = 0
macro(250, "Safe AOE Rune", function()
  if time > now then return end
  local monsters = 0
  local players = 0
  for s, spec in pairs(getSpectators(false)) do
    if spec:getName() ~= player:getName() then
      if spec:isPlayer() then players = players + 1 else monsters = monsters + 1 end
    end
  end
  if not g_game.isAttacking() or players > 0 or monsters < MIN_MONSTERS_TO_USE_RUNE then
    return true
  else
    local c = g_game.getAttackingCreature()
    time = now + EXHAUSTED_TIME
    return g_game.useInventoryItemWith(RUNE_ID, c)
  end
end)