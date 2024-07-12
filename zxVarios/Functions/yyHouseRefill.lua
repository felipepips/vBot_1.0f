-- HOUSE REFILL / CaveBot Function, Floor Ground House Refill Supply Supplies
-- BY F.ALMEIDA

-- START CONFIG
local itemId = 3155
local Amount = 400
local maxDist = 5 -- max range to look around
local moveDelay = 500 -- in milliseconds
-- END CONFIG

local tag = "[House Refill]\n"
if retries > 50 then 
  warn(tag.."Error!")
  return true
end

local count = player:getItemsCount(itemId)
local pos = player:getPosition()
if count < Amount then
  for xp = -maxDist,maxDist do
    for yp = -maxDist,maxDist do
      local rTile = g_map.getTile({x = pos.x + xp, y = pos.y + yp, z = pos.z})
      if rTile then
        local topItem = rTile:getTopUseThing()
        if topItem and topItem:getId() == itemId then
          for c, cont in pairs(g_game.getContainers()) do
            if cont:getCapacity() > #cont:getItems() then
              local need = Amount - count
              local toMove = topItem:getCount() < need and topItem:getCount() or need
              g_game.move(topItem,cont:getSlotPosition(cont:getCapacity()),toMove)
              delay(moveDelay)
              return "retry"
            end
          end
        end
      end
    end
  end
  warn(tag.."No More: "..itemId)
  return true
end
warn(tag.."Done!")
return true