-- CaveBot Action/Function, Use Item With on Ground (Rope/shovel for old versions)
-- START CONFIG
local itemId = 3003
local groundPos = {32335,32174,8}
-- END CONFIG

local pos = {x=groundPos[1],y=groundPos[2],z=groundPos[3]}
local tile = g_map.getTile(pos)
local item = findItem(itemId)
if not item then
  warn("[Use With] Item Not Found: "..itemId)
  return true
end
if not tile then
  warn("[Use With] Position Not Found.")
  return true
end
useWith(item,tile:getTopUseThing())
return true