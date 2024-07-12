-- Auto Wave Enemy - Turn to Target and say spell
-- Face Monsters Players

-- START CONFIG
local spell = "exevo gran vis lux"
local max_distance = 5
local exhausted = 1000 -- milliseconds
setDefaultTab("Target")
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

panelName = "autoWave"
if not storage[panelName] then storage[panelName] = { spell = spell, maxDist = max_distance} end

local config = storage[panelName]

local autoWave = macro(100,"Auto Wave Enemy", function()
  local maxDist = tonumber(config.maxDist)
  local spell = config.spell
  local enemy = target()
  if not enemy then return true end
  local pos = player:getPosition()
  local cpos = enemy:getPosition()
  if getDistanceBetween(pos,cpos) > maxDist then return true end
  local diffx = cpos.x - pos.x
  local diffy = cpos.y - pos.y
  if diffx > 0 and diffy == 0 then turn(1) cast(spell) delay(exhausted)
  elseif diffx < 0 and diffy == 0 then turn(3) cast(spell) delay(exhausted)
  elseif diffx == 0 and diffy > 0 then turn(2) cast(spell) delay(exhausted)
  elseif diffx == 0 and diffy < 0 then turn(0) cast(spell) delay(exhausted)
  end
  
end)

autoWaveSpell = UI.TextEdit(config.spell, function(widget, newText)
  config.spell = newText
end)

autoWaveDist = UI.TextEdit(config.maxDist, function(widget, newText)
  config.maxDist = newText
end)