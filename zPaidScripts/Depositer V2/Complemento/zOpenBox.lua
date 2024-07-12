-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

local boxId = 22797
macro(100,"Open BOX",function()
  if not isInPz() then return end
  local open = getContainerByItem(boxId)
  if open then return end
  local find = findItem(boxId)
  if find then
    g_game.open(find,nil)
    delay(1000)
  end
end)