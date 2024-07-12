-- Use item on ground

-- START CONFIG
local items_ids = {8997} -- always inside {} -- e.g. {1234} or {1234,1235,1236}
local max_distance = 6
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

macro(250,"Use Item On Ground",function()
  for x = -max_distance, max_distance do
    for y = -max_distance, max_distance do
      local pos = player:getPosition()
      local tile = g_map.getTile({x = pos.x + x, y = pos.y + y, z = pos.z})
      if tile and (x ~= 0 or y ~= 0) then
        local topItem = tile:getTopUseThing()
        if topItem then
          if table.find(items_ids,topItem:getId()) then
            return g_game.use(topItem)
          end
        end
      end
    end
  end
end)