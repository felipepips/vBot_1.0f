-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- Throw Trash
local config = storage.CleanDepot
local trash_items = config.trashItems
local trash_bin_id = config.trash_bin_id
local bagloot_id = config.bagloot_id
local default_delay = 350
local tag = "[CleanDepot]\n"
-- END CONFIG


local trashBin = findItemOnGround(trash_bin_id)
if trashBin then
  cleanDepotMacro:setOff()
  local dest = trashBin:getPosition()
  local scTime = 0
  for c, cont in pairs(g_game.getContainers()) do
    for i, item in pairs(cont:getItems()) do
      local itemId = item:getId()
      if itemId ~= bagloot_id then
        if table.find(trash_items,itemId) then
          scTime = scTime + default_delay
          schedule(scTime,function()
            g_game.move(item,dest,item:getCount())
          end)
        end
      end
    end
  end
  local wait = scTime + (default_delay * 2)
  schedule(wait,function()
    cleanDepotMacro:setOn()
    warn(tag.."No More Trash\nContinue...")
  end)
  delay(wait)
  return true
else
  warn(tag.."Trash Bin Not Found")
  delay(10000)
end
return true

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL