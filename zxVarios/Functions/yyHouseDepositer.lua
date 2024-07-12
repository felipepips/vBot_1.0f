-- HOUSE DEPOSITER / CAVEBOT FUNCTION
-- BY F.ALMEIDA

-- START CONFIG
local containerId = 2869
local moveDelay = 500
local maxDist = 5 -- max range to look around
-- END CONFIG

local tag = "[House Depositer]\n"
local dest = getContainerByItem(containerId)
if dest then
  if not containerIsFull(dest) then
    local lootItems = getLootItems()
    for c, cont in pairs(g_game.getContainers()) do
      if cont:getContainerItem():getId() ~= containerId then
        for i, item in pairs(cont:getItems()) do
          if table.find(lootItems,item:getId()) then
            g_game.move(item,dest:getSlotPosition(dest:getCapacity()),item:getCount())
            delay(moveDelay)
            return "retry"
          end
        end
      end
    end
    warn(tag.."No More Items")
    return true
  else
    local next = findItem(containerId)
    if next then
      g_game.open(next,dest)
      delay(moveDelay)
      return "retry"
    else
      warn(tag.."No More BPS")
      return true
    end
  end
else
  local pos = player:getPosition()
  for xp = -maxDist,maxDist do
    for yp = -maxDist,maxDist do
      local rTile = g_map.getTile({x = pos.x + xp, y = pos.y + yp, z = pos.z})
      if rTile then
        local topItem = rTile:getTopUseThing()
        if topItem and topItem:getId() == containerId then
          g_game.use(topItem)
          delay(moveDelay * 2)
          return "retry"
        end
      end
    end
  end
  warn(tag.."BP Not Found")
  return true
end