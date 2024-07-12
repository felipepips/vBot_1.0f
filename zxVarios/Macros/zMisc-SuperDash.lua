local min,max = 4,6

local offsetDirections = {
  [North]      =  {0,-1},
  [East]       =  {1,0},
  [South]      =  {0,1},
  [West]       =  {-1,0},
  [NorthEast]  =  {-1,-1},
  [SouthEast]  =  {-1,1},
  [SouthWest]  =  {1,1},
  [NorthWest]  =  {1,-1},
}

local alt = "Shift"

local k = {
  ['W'] = North,
  ['D'] = East,
  ['S'] = South,
  ['A'] = West,
  ['Q'] = NorthEast,
  ['W+A'] = NorthEast,
  ['Z'] = SouthEast,
  ['S+A'] = SouthEast,
  ['C'] = SouthEast,
  ['S+D'] = SouthWest,
  ['E'] = NorthWest,
  ['W+D'] = NorthWest,
}

local main = macro(1,"Super Dash",function()
  if not modules.game_walking.wsadWalking then return end
  local p = {}
  for distance = min,max do
    for keys, dir in pairs(k) do
      if alt ~= "" then keys = alt .. "+" .. keys end
      if g_keyboard.areKeysPressed(keys) then
        local off = offsetDirections[dir]
        if off then
          local pos = pos()
          pos.x, pos.y = pos.x + (off[1] * distance), pos.y + (off[2] * distance)
          local nextTile = g_map.getTile(pos)
          if not nextTile then return end
          if nextTile:isWalkable() then
            table.insert(p,nextTile)
          else
            for t, tile in pairs(getNearTiles(nextTile:getPosition())) do
              table.insert(p,tile)
            end
          end
        end
      end
    end
    for _, tile in pairs(p) do
      if tile:isWalkable() then
        local top = tile:getTopUseThing()
        if top then
          return g_game.use(top)
        end
      end
    end
  end
end)