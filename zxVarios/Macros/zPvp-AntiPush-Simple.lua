-- ANTIPUSH
local pushItem = 3031
local pushHotkey = "F12"
local antiPush = macro(250, "AntiPush", pushHotkey, function()
  local find = findItem(pushItem)
  if not find then return end
  local pos = player:getPosition()
  local tile = g_map.getTile(pos)
  if tile then
    local top = tile:getTopUseThing()
    if not top or (top:getId() ~= pushItem) or (top:getCount() < 2) then
      return g_game.move(find,tile:getPosition(),1)
    end
  end
end)