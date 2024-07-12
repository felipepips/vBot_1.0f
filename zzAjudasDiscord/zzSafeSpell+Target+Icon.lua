-- Auto Attack with Area spell or AOE rune only if no players in range w/ icon
-- Tags: safe pvp exori exevo gran mas vis flam pox party target targeted gfb avalanche

--CONFIG HERE:
local AOE_SPELL_OR_RUNE = "rune" -- "spell" or "rune"
local AOE_SPELL = "aoe spell" -- AOE spell name
local AOE_RUNE = 3191 -- AOE rune id
local TARGETED_SPELL_OR_RUNE = "spell" -- "spell" or "rune"
-- if you don't want to use targeted spells, set TARGETED_SPELL_OR_RUNE = "spell" and TARGETED_SPELL = ""
local TARGETED_SPELL = "exori vis" -- single target spell name
local TARGETED_RUNE = 3155 -- single target rune id
local MIN_MONSTERS_TO_USE_AOE = 3
local RANGE_TO_COUNT_MONSTERS = 5 -- max range
-- if you want to use AOE instead of how many players have on screen, set MAX_PLAYERS_TO_USE_AOE = 1000
local MAX_PLAYERS_TO_USE_AOE = 1 -- if more than this value, use targeted
local RANGE_TO_COUNT_PLAYERS = 7 -- max range
local IGNORE_PARTY_MEMBERS = true -- true or false
local EXHAUSTED_TIME = 500 --milliseconds
local macroName = "PVP SAFE - AOE"
local iconText = "Safe\nAOE"
setDefaultTab("Main")
--END CONFIG

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

local safeAOE = macro(250, macroName, function()
  local players = 0
  local monsters = 0
  for s, spec in pairs(getSpectators(false)) do
    if not g_game.isAttacking() then return end
    local dist = getDistanceBetween(AOE_SPELL_OR_RUNE == "spell" and pos() or g_game.getAttackingCreature():getPosition(),spec:getPosition())
    if spec ~= player then
      if spec:isPlayer() and dist <= RANGE_TO_COUNT_PLAYERS then 
        if not IGNORE_PARTY_MEMBERS or spec:getShield() < 3 then
          players = players + 1
        end
      elseif spec:isMonster() and dist <= RANGE_TO_COUNT_MONSTERS then
        monsters = monsters + 1 
      end
    end
  end

  if not g_game.isAttacking() then return end
  
  if players >= MAX_PLAYERS_TO_USE_AOE then
    if TARGETED_SPELL_OR_RUNE == "spell" then say(TARGETED_SPELL)
    else g_game.useInventoryItemWith(TARGETED_RUNE,g_game.getAttackingCreature()) end
    delay(EXHAUSTED_TIME)
    return
  elseif monsters >= MIN_MONSTERS_TO_USE_AOE then
    if AOE_SPELL_OR_RUNE == "spell" then say(AOE_SPELL)
    else g_game.useInventoryItemWith(AOE_RUNE,g_game.getAttackingCreature()) end
    delay(EXHAUSTED_TIME)
    return
  elseif g_game.isAttacking() then
    if TARGETED_SPELL_OR_RUNE == "spell" then say(TARGETED_SPELL)
    else g_game.useInventoryItemWith(TARGETED_RUNE,g_game.getAttackingCreature()) end
    delay(EXHAUSTED_TIME)
    return
  end

end)

local safeIcon = addIcon("safeAOEicon", {switchable=true, hotkey=nil, movable=true, text=iconText}, function() end)
safeIcon.onClick = function() if safeAOE:isOff() then safeAOE:setOn() else safeAOE:setOff() end end
safeIcon.text:setFont('verdana-11px-rounded')

macro(100,function() safeIcon.text:setColor(safeAOE:isOn() and "green" or "red") end)