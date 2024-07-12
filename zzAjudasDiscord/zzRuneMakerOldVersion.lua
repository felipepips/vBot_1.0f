-- rune maker for older versions (move blank rune to hand)
-- weapon always on RIGHT HAND
-- tags: old version tibia 7.4 7.6 7.72 7.92 8.0 8.1 8.4 8.54 8.6

-- START CONFIG
setDefaultTab("Main")
UI.Label("Rune Maker")
local blankRuneID = 3147
local exhausted = 1000
local checkSoul = true
local minSoul = 5
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

panelName = "runeMaker"

local params = {
  spell = "adori gran flam",
  info = {on=false, title="MP%", item=3281, min=50, max=100}
}

if not storage[panelName] then storage[panelName] = params end

local config = storage[panelName]

local runeSpell = UI.TextEdit(config.spell, function(widget, newText)
  config.spell = newText
end)

UI.DualScrollItemPanel(config.info, function(widget, newParams) 
  config.info = newParams
end)

local function moveToBp(item)
  for c, cont in pairs(g_game.getContainers()) do
    local cname = cont:getName()
    if not string.find(cname,"dead") and not string.find(cname,"slain") and not string.find(cname,"depot") and not string.find(cname,"quiver") then
      if cont:getCapacity() > #cont:getItems() then
        return g_game.move(item,cont:getSlotPosition(cont:getCapacity()),item:getCount())
      end
    end
  end
end

local function equipWeapon()
  local weaponId = config.info.item
  if not getRight() or (getRight() and getRight():getId() ~= weaponId) then
    local item = findItem(weaponId)
    if item then 
      moveToSlot(item,SlotRight)
    end
  end
end

macro(100,function() 
  if not config.info.on then return end
  if not findItem(blankRuneID) then
    if not getRight() or getRight():getId() ~= blankRuneID then -- sem mais blanks
      warn("No More Blank Runes")
      equipWeapon()
      delay(5000)
      return
    end
  end
  local mp = manapercent()
  local min = config.info.min
  local max = config.info.max
  if mp >= min and mp <= max and (not checkSoul or soul() >= minSoul) then -- temos mana e soul suficiente
    if getRight() and getRight():getId() == blankRuneID then -- ja temos blank rune na mão
      say(params.spell)
      local tempo = 280000 -- tempo base/minimo
      local var = 10 -- variacao
      local random = math.random(var)
      local tempoVar = math.floor(tempo * random / 100)
      local tempoTotal = tempo + random
      delay(tempoTotal)
    elseif getRight() and getRight():getId() ~= blankRuneID then -- temos outra coisa na mão, vamos remover
      moveToBp(getRight())
      delay(exhausted)
    elseif not getRight() then -- não temos nada na mão, vamos por uma blank
      local item = findItem(blankRuneID)
      if item then 
        moveToSlot(item,SlotRight)
        delay(exhausted)
      end
    end
  else -- não temos mana suficiente
    equipWeapon()
    delay(exhausted)
  end
end)