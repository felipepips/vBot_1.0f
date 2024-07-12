-- START CONFIG
local fishable_water_ids = {4597, 4598, 4599, 4600, 4601, 4602}
local fishing_rod_id = 3483
local maxDistance = 7
local minCapacity = -1 -- -1 = don't stop if low cap
local wormId = 3492 -- leave it = 0 if you dont need worm to fish
local interval = 500 -- milliseconds
local markFishable = true
local markColor = "white"
-- END CONFIG

local useAsHotkey = g_game.getClientVersion() > 800

local fishMacro = macro(250, "The Ultimate Fishing", function(m)
  local rod = useAsHotkey and fishing_rod_id or findItem(fishing_rod_id)
  if not rod then
    warn("[Fishing] No Fishing Rod.")
    return delay(5000)
  end
  if freecap() <= minCapacity then
    warn("[Fishing] No More Capacity.")
    return delay(5000)
  end
  if wormId > 0 and itemAmount(wormId) == 0 then
    warn("[Fishing] No More Worms.")
    return delay(5000)
  end

  local fishable = {}
  local time = 0

  for _, tile in ipairs(g_map.getTiles(posz())) do
    local isFishable = table.contains(fishable_water_ids, tile:getTopUseThing():getId())
    local isReachable = getDistanceBetween(pos(), tile:getPosition()) <= maxDistance
    if isFishable and isReachable and tile:canShoot() then
      table.insert(fishable,tile:getPosition())
      if markFishable then
        tile:getTopUseThing():setMarked(markColor)
      end
    end
  end

  if #fishable == 0 then
    warn("[Fishing] No More Fish Here.")
    return delay(5000)
  end

  for p, pos in pairs(fishable) do
    schedule(time,function()
      if m:isOff() then return end
      local tile = g_map.getTile(pos)
      if tile then
        useWith(rod,tile:getTopUseThing())
      end
    end)
    time = time + interval
  end
  
  delay(time+interval)
end) 

fishMacro.switch:setColor("blue")
fishMacro.switch:setFont('verdana-11px-rounded')