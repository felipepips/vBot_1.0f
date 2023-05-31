function getPosByDir()
  local dirs = { { 0, -1 }, { 1, 0 }, { 0, 1 }, { -1, 0 }}
  local dir = player:getDirection() + 1
  local dirPos = pos()
  dirPos.x = dirPos.x + dirs[dir][1]
  dirPos.y = dirPos.y + dirs[dir][2]

  return dirPos.x .. "," .. dirPos.y .. "," .. dirPos.z
end

CaveBot.Extensions.dropItem = {}

CaveBot.Extensions.dropItem.setup = function()
  CaveBot.registerAction("drop item", "orange", function(value, retries)
    local val = string.split(value, ",")
    local itemid = nil
    local count = nil
    local tries = nil
    if #val >= 4 then
      itemid = tonumber(val[4])
    end
    if #val == 5 then
      tries = tonumber(val[5])
    end

    if not val[1] or not val[2] or not val[3] then
      warn("CaveBot[Drop]: invalid value. It should be position (x,y,z), is: " .. value)
      return false
    end

    if retries >= (tries and tries or 20) then
      print("CaveBot[Drop]: too many tries, can't open hole")
      return false -- tried 20 times, can't drop
    end

    local pos = {x=tonumber(val[1]), y=tonumber(val[2]), z=tonumber(val[3])}  

    local dropTile = g_map.getTile(pos)
    if not dropTile then
      return "retry"
    end

    local holeitem = dropTile:getTopThing()
    if holeitem and holeitem:getId() == itemid then
      return true
    end

    local item = findItem(itemid)
    if item then
      g_game.move(item, pos, 1)
      CaveBot.delay(1000)
    end
    return "retry"
  end)
CaveBot.Editor.registerAction("drop item", "drop item", {
    value=function() return getPosByDir() end,
    title="Drop",
    description="Drop item to position (x,y,z), itemid, retries(optional) ",
    multiline=false,
})
end