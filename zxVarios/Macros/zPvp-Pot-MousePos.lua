-- POT NO MOUSE HOTKEY
local potHotkey = "F12"
local potId = 3465
singlehotkey(potHotkey,"Pot Mouse",function()
  local find = findItem(potId)
  if not find then return end
  local tile = getTileUnderCursor()
  if not tile then return end
  if tile:isWalkable() and tile:canShoot() then
    g_game.move(find,tile:getPosition())
  end
end)