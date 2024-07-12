local range = 5

local offset = {
  ["8"] = { 0, -1 }, --n
  ["6"] = { 1, 0 }, --e
  ["4"] = { -1, 0 }, --w
  ["5"] = { 0, 1 }, --s
  ["2"] = { 0, 1 }, --s
}

local main = macro(10*60*1000,"Dash (Bug Map)",function() end)

onKeyPress(function(key)
  if not main:isOn() then return end
  local w = modules.game_walking.wsadWalking
  if not w then return end
  local off = offset[key]
  if not off then return end

  local newPos = player:getPosition()
  local dir = player:getDirection()
  local dest = {x = newPos.x + (off[1] * range), y = newPos.y + (off[2] * range), z = newPos.z}
  if not dest then return end

  local tile = g_map.getTile(dest)
  if tile then
    if tile:isWalkable() then
      use(tile:getTopUseThing())
      return
    end
  end

  for t, til in pairs(getNearTiles(dest)) do
    if til then
      if til:isWalkable() then
        use(til:getTopUseThing())
        return
      end
    end
  end

end)