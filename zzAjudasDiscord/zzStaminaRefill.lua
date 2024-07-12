-- use item by stamina percent
-- low potion refill 

-- START CONFIG
setDefaultTab("Main")
UI.Label("Stamina Refill")
local staminaItemId = 3147
local maxStamina = 42 -- hours
local exhausted = 1000
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

panelName = "staminaRefill"

local params = {
  info = {on=false, title="ST%", item=staminaItemId, min=0, max=50}
}

if not storage[panelName] then storage[panelName] = params end

local config = storage[panelName]

UI.DualScrollItemPanel(config.info, function(widget, newParams) 
  config.info = newParams
end)

macro(2000,function() 
  if not config.info.on then return end
  local potion = findItem(config.info.item)
  if not potion then
    warn("No Stamina Potion")
    return delay(5000)
  end
  local stamina = (stamina() / 60) / maxStamina * 100
  local min, max = config.info.min, config.info.max
  if stamina >= min and stamina <= max then -- low stamina
    useWith(potion,player)
    delay(exhausted)
  end
end)