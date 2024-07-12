--START CONFIG
local hold_pos = {x=2423, y=1608, z=6}
local pos_inicial = {x=2419, y=1612}
local pos_final = {x=2428, y=1613}
local comando = "!concurso \"banderasrandom"
local macroName = "Auto Enter Event"
-- END CONFIG

function getNearTiles(pos)
  if type(pos) ~= "table" then pos = pos:getPosition() end
  local tiles = {}
  local dirs = {{-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}}
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

macro(100,macroName,function()
  if pos_inicial.x <= posx() and posx() <= pos_final.x then
    if pos_inicial.y <= posy() and posy() <= pos_final.y then
      return
    end
  end
  
  if posz() ~= hold_pos.z then return end
  if getDistanceBetween(pos(), hold_pos) > 10 then return end
  
  for s, spec in pairs(getSpectators(false)) do
    if spec:isPlayer() and spec ~= player then
      local specPos = spec:getPosition()
      local x = specPos.x
      local y = specPos.y
      if pos_inicial.x <= x and x <= pos_final.x then
        if pos_inicial.y <= y and y <= pos_final.y then
          say(comando)
          delay(5000)
          return
        end
      end
    end
  end

  if getDistanceBetween(pos(), hold_pos) > 3 then
    for _, tile in pairs(getNearTiles(hold_pos)) do
      local tPos = tile:getPosition()
      if findPath(pos(),tPos) then
        autoWalk(tPos)
        delay(1000)
        break
      end
    end
  end
end)