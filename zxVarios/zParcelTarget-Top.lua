-- START CONFIG
local pot_ids = {3465}
local trash_ids = {3492,3031}
local macroName = "Parcel Target"
local macroHotkey = "F6"
-- END CONFIG

local function find(table)
  for e, entry in pairs(table) do
    local find = findItem(entry)
    if find then
      return find
    end
  end
end

local function getNearTiles(pos)
  if type(pos) ~= "table" then pos = pos:getPosition() end
  local tiles = {}
  local dirs = {
      {-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}
  }
  for i = 1, #dirs do
      local tile = g_map.getTile({
          x = pos.x - dirs[i][1],
          y = pos.y - dirs[i][2],
          z = pos.z
      })
      if tile then table.insert(tiles, tile) end
  end
  return tiles
end

macro(100,macroName,macroHotkey,function()
  local focus = g_game.getAttackingCreature()
  if not focus then return end
  local pot = find(pot_ids)
  local gold = find(trash_ids)
  local tPos = focus:getPosition()
  local tiles = getNearTiles(tPos)
  for t, tile in pairs(tiles) do
    -- ver se tem pot ja
    local temPot = false
    for i, item in pairs(tile:getItems()) do
      if table.find(pot_ids,item:getId()) then
        temPot = true
        break
      end
    end
    if temPot and gold then
      local top = tile:getTopUseThing()
      if not top or not table.find(trash_ids,top:getId()) then
        g_game.move(gold,tile:getPosition(),2)
      end
    elseif not temPot and pot then
      g_game.move(pot,tile:getPosition(),1)
    end
  end
end)