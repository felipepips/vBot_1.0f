-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- Use Mana Fluid (item for mana heal) w/ Icon

setDefaultTab("Main")
local rtLabel = UI.Label("[[ Mana Heal ]]")
rtLabel:setColor('#2de0d7')
rtLabel:setFont('verdana-11px-rounded')

local stName = "oldMF"
storage[stName] = storage[stName] or {on=false, title="MP%", item=2874, subType = 2, min=0, max=90}

local config = storage[stName]

local exhausted = 100 -- ms

local function useMf()
  local find = findItem(config.item,config.subType)
  if find then
    useWith(find,player)
  else
    broadcastMessage("No Mana Fluids")
    mfMacro.delay = now + 1000
  end
end

mfMacro = macro(exhausted, function()
  local mp = manapercent()
  if config.min > mp or mp > config.max then return end
  useMf()
end)

config.on = false
local ui = UI.DualScrollItemPanel(config, function(widget, newParams) 
  config = newParams
  widget.title:setOn(false)
end)

local mfIcon = addIcon("mfIcon", {text = "MF", item = config.item, hotkey = "F3"}, mfMacro)
mfIcon.text:setFont("verdana-11px-rounded")
mfIcon.item:setItemSubType(config.subType)

UI.Separator()

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL