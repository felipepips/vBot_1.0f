-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- Use Rune on Target w/ 2 Icons
-- 1 icon: toggle on/off = full rune target
-- 1 icon: click to use rune on target

setDefaultTab("Main")
local rtLabel = UI.Label("[[ Rune on Target ]]")
rtLabel:setColor('orange')
rtLabel:setFont('verdana-11px-rounded')

local stName = "RuneTarget"
storage[stName] = storage[stName] or {on=false, title="HP%", item=3155, min=0, max=100}

local config = storage[stName]

local exhausted = 1000 -- ms

local function sdTarget(target)
  local find = findItem(config.item)
  if find then
    useWith(find,target)
  else
    broadcastMessage("No More Runes")
  end
end

local rtMacro = macro(100, function()
  local tg = target()
  if not tg then return end
  local tHp = tg:getHealthPercent()
  if config.min > tHp or tHp > config.max then return end
  sdTarget(tg)
  delay(exhausted)
end)

config.on = false
UI.DualScrollItemPanel(config, function(widget, newParams) 
  config = newParams
  widget.title:setOn(false)
end)

local holdIcon = addIcon("holdIcon", {text = "Hold", item = config.item, hotkey = "F1"}, rtMacro)
holdIcon.text:setFont("verdana-11px-rounded")

local useIcon = addIcon("useIcon", {text = "Use", item = config.item, switchable = false, hotkey = "F2"}, function()
  local tg = target()
  if not tg then
    return broadcastMessage("No Target")
  end
  sdTarget(tg)
end)
useIcon.text:setFont("verdana-11px-rounded")

UI.Separator()

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL