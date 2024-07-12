local cake_ids = {12085}

local checkTile
local cmacro = macro(500,"cake",function()
  if not checkTile then return end
  local top = checkTile:getTopUseThing()
  if top and table.find(cake_ids,top:getId()) then
    g_game.use(top)
  else
    checkTile = nil
  end
end)

onAddThing(function(tile, thing)
  if cmacro:isOff() then return end
  if checkTile then return end
  if table.find(cake_ids,thing:getId()) then
    checkTile = tile
  end
end)