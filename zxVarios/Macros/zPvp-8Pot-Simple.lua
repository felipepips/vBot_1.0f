-- POT NO MOUSE HOTKEY
-- START CONFIG
local potHotkey = "PageUp"
local potId = 3465
-- END CONFIG

function throwPots()
  local focus = g_game.getAttackingCreature()
  if not focus then return true end
  local near = getNearTiles(focus)
  for t, tile in pairs(near) do
    local find = findItem(potId)
    if tile and find then
      g_game.move(find,tile:getPosition(),1)
    end
  end
end

addIcon("8pot",{item=potId,switchable=false, hotkey=potHotkey, text="8Pot"},throwPots)