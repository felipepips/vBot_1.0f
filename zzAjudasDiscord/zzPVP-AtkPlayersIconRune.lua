-- Macro PVP Auto Target anyone that is not in party + Paralyze (use rune on) Target with Icon.

-- START CONFIG
local paralyzeRuneId = 3165
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

local pz = macro(100,function() 
  local target = g_game.getAttackingCreature()
  if not target then
    for s, spec in pairs(getSpectators(false)) do
      if spec:isPlayer() and spec:getShield() < 3 then
        if spec:getEmblem() ~= 1 then
          g_game.attack(spec)
          return
        end
      end
    end
  end
  useWith(paralyzeRuneId, target)
  delay(500)
end)

pz:setOff()

local pzIcon = addIcon("pzI", {text="PVP", item = {id = paralyzeRuneId, count = 1}, movable=true, switchable=true}, 
function(widget,isOn)
  if isOn then
    pz:setOn()
  else
    pz:setOff()
  end
end)
pzIcon:breakAnchors()
pzIcon:move(200,200)