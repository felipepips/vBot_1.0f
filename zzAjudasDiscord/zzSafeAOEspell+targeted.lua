-- Auto Attack with Area spell only if no players in range
-- Else use targeted spell or rune on target
-- Tags: safe AOE pvp exori exevo con mort hur gran mas vis flam

--CONFIG HERE:
local AOE_SPELL = "exori"
local TARGETED_TYPE = "spell" -- "spell" or "rune" or "" to don't use any targeted, only AOE
local TARGETED_SPELL = "exori hur"
local TARGETED_RUNE = 3155
local MIN_MONSTERS_TO_USE_AOE = 3
local DISTANCE_TO_COUNT_MONSTERS = 1
local DISTANCE_TO_COUNT_PLAYERS = 3
local EXHAUSTED_TIME = 1000 --milliseconds
--END CONFIG

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD
local old = g_game.getClientVersion() < 860
macro(250, "Safe AOE Spell + Targeted", function()
  local monsters = 0
  local players = 0
  for s, spec in pairs(getSpectators(false)) do
    local dist = getDistanceBetween(pos(),spec:getPosition())
    if spec:isPlayer() and spec ~= player and dist <= DISTANCE_TO_COUNT_PLAYERS then
      players = players + 1
    elseif spec:isMonster() and dist <= DISTANCE_TO_COUNT_MONSTERS then
      monsters = monsters + 1
    end
  end
  if monsters >= MIN_MONSTERS_TO_USE_AOE and players == 0 then
    say(AOE_SPELL)
    delay(EXHAUSTED_TIME)
  elseif g_game.isAttacking() and TARGETED_TYPE ~= "" then
    local target = g_game.getAttackingCreature()
    if TARGETED_TYPE:lower() == "rune" then
      useWith(old and findItem(TARGETED_RUNE) or TARGETED_RUNE,target)
    else
      say(TARGETED_SPELL)
    end
    delay(EXHAUSTED_TIME)
  end
end)