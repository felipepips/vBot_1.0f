-- Auto SD Target and Self UH
-- only works on 8.6+ (MAYBE some 8.0 or 8.6, not sure)

--START CONFIG:
local UH_ID = 3160
local MIN_HP_TO_UH = 80
local SD_ID = 3155
local MIN_HP_TARGET_TO_SD = 1
local EXHAUSTED_TIME = 2000 --milliseconds
local ONLY_MONSTERS = false -- true or false to attack players too
local macroName = "UH + SD"
setDefaultTab("Main")
-- END CONFIG

UI.Separator()

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.


macro(100, macroName, function()
  if hppercent() <= MIN_HP_TO_UH then 
    g_game.useInventoryItemWith(UH_ID, player)
    delay(EXHAUSTED_TIME)
    return
  end
  if not g_game.isAttacking() then
    return
  else
    local c = g_game.getAttackingCreature()
    if ONLY_MONSTERS and not c:isMonster() then return end
    if c and c:getHealthPercent() > MIN_HP_TARGET_TO_SD then 
      g_game.useInventoryItemWith(SD_ID, c)
      delay(EXHAUSTED_TIME)
      return
    end
  end
end)