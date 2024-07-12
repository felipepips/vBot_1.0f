-- SMART AUTO TARGET / ATK CLOSEST FIRST
-- tags: attack close closer monster creature player pvp 

-- START CONFIG
local ignoreList = {"deer","rabbit","skunk"} -- always inside {} and lower case letters
local attackPlayers = false -- true = attack players too / false = only attack monsters
local ignoreParty = true -- true = ignore party members / false = attack party too
-- END CONFIG

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

macro(50, "Smart Auto-Target", function()
  if g_game.isAttacking() then return end
  local c = {}
  for s, spec in pairs(getSpectators(false)) do
    if spec ~= player and not table.find(ignoreList,spec:getName():lower()) then
      if (spec:isPlayer() and attackPlayers) or spec:isMonster() then
        if (not ignoreParty or spec:getShield() < 3) or spec:isMonster() then
          table.insert(c,{c=spec,d=distanceFromPlayer(spec:getPosition())})
        end
      end
    end
  end

  table.sort(c, function(a,b) return a.d < b.d end)

  if not g_game.isAttacking() and c[1] then
    g_game.attack(c[1].c)
  end
end)