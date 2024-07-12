local parcel_ids = {3503,3504}
macro(100,"Parcel Target","F6",function()
  local focus = target()
  if not focus then return end
  local find
  for e, entry in pairs(parcel_ids) do
    find = findItem(entry)
    if find then break end
  end
  if not find then return end
  local tPos = focus:getPosition()
  local tiles = getNearTiles(tPos)
  for t, tile in pairs(tiles) do
    local top = tile:getTopUseThing()
    if not table.find(parcel_ids,top:getId()) then
      g_game.move(find,tile:getPosition(),1)
    end
  end
end)