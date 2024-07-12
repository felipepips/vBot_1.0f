-- HOUSE RUNE MAKER

-- START CONFIG
-- posições:
local mf_pos = {x=33344, y=32058, z=7} -- posicao da mf no chao
local blank_pos = {x=33344, y=32059, z=7} -- posicao da blank rune no chao
local rune_pos = {x=33343, y=32057, z=7} -- posicao da runa feita no chao
-- configurações:
local min_mp_percent = 95 -- vai usar mf com mana abaixo de x%
local rune_spell = "adori vita vis" -- magia pra runar
local mp_rune = 220 -- mana pra fazer a runa
-- IDs:
local rune_id = 3155 -- id da runa feita
local blank_id = 3147 -- id da blank rune
local mf_id = 23373 -- id da MF
-- END CONFIG

setDefaultTab("Main")
UI.Separator()
UI.Label("House Rune Maker")

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

floorMf = macro(100,"Usar MF Chao",function() 
  local mp = manapercent()
  if mp > min_mp_percent then return end
  local tile = g_map.getTile(mf_pos)
  if not tile then return end
  local topItem = tile:getTopUseThing()
  if not topItem then return end
  if topItem:getId() == mf_id then
    useWith(topItem,player)
  else
    g_game.move(topItem,player:getPosition(),topItem:getCount())
    delay(250)
  end
end)

pegarBlank = macro(100,"Blank Refill",function() 
  local blankCount = itemAmount(blank_id)
  if blankCount > 10 then return end
  local tile = g_map.getTile(blank_pos)
  if not tile then return end
  local topItem = tile:getTopUseThing()
  if not topItem then return end
  if topItem:getId() == blank_id then
    for c, cont in pairs(g_game.getContainers()) do
      if cont:getCapacity() > #cont:getItems() then
        g_game.move(topItem,cont:getSlotPosition(cont:getCapacity()),topItem:getCount())
        delay(1000)
        break
      end
    end
  else
    g_game.move(topItem,player:getPosition(),topItem:getCount())
    delay(250)
  end
end)

droparRuna = macro(100,"Dropar Runa",function() 
  local rune = findItem(rune_id)
  if not rune then return end
  g_game.move(rune,rune_pos,rune:getCount())
  delay(500)
end)

runar = macro(100,"Runar",function() 
  if mana() >= mp_rune then
    say(rune_spell)
    delay(500)
  end
end)