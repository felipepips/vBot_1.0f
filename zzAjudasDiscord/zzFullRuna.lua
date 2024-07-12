-- Target All - Rune Attack Full

-- START CONFIG
setDefaultTab("Main")
UI.Label("[[ Full Rune + Target ]]"):setFont("verdana-11px-rounded")
local runeId = 3155
local exhausted = 1000
local minHP = 50 -- self HP percent to stop using runes
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

panelName = "fullRune"

local params = {
  info = {on=false, title="HP%", item=runeId, min=1, max=100}
}

if not storage[panelName] then storage[panelName] = params end

local config = storage[panelName]

UI.DualScrollItemPanel(config.info, function(widget, newParams) 
  config.info = newParams
end)

local fullRuneMacro = macro(100,function() 
  if not config.info.on then return end
  if player:getHealthPercent() < minHP then return end
  local data = config.info
  local target = g_game.getAttackingCreature()
  if target then
    if target:getHealthPercent() <= data.min or target:getHealthPercent() >= data.max then
      g_game.cancelAttack()
      delay(exhausted/3)
      return 
    end
  else 
    for s, spec in pairs(getSpectators(false)) do
      if spec:isMonster() then
        if spec:getHealthPercent() >= data.min and spec:getHealthPercent() <= data.max then
          g_game.attack(spec)
          delay(exhausted/3)
          break 
        end
      end
    end
  end
  target = g_game.getAttackingCreature()
  if not target then return end
  useWith(data.item, target)
  delay(exhausted)
end)

local runeIcon = addIcon("runeIcon", {switchable=true,item={id=runeId,count=1}, movable=true, text="Full\nRune"}, function() end)
runeIcon.onClick = function() config.info.on = not config.info.on end
runeIcon.text:setFont('verdana-11px-rounded')

macro(100,function()
  runeIcon.text:setColor(config.info.on and "green" or "red") 
end)