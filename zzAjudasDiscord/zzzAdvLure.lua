-- Advanced Lure

setDefaultTab("cave")

local default = {
  positions = {
    [1] = "6213,46,1",
    [2] = "6214,85,1",
    [3] = "6219,130,1",
    [4] = "6221,174,1",
    [5] = "6224,212,1",
  },
}

local qntd = 1
local dist = 6
local maxGoto = 50

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.

local waypoints = #default.positions
stName = "lureMonsters"
if not storage[stName] then storage[stName] = default end
local config = storage[stName]

UI.Label("[[ Advanced Lure ]]"):setColor("green")
for i=1,waypoints do
  UI.TextEdit(config.positions[i] or default.positions[i], function(widget, newText)
    config.positions[i] = newText
  end)
end

local positions = config.positions
local pos = {}
for e, entry in pairs(positions) do
  local regx = regexMatch(entry, [[([^,]+),([^,]+),([^,]+)]])
  pos[e] = {x = tonumber(regx[1][2]), y = tonumber(regx[1][3]), z = tonumber(regx[1][4])}
end
local order = {}
local lastWalk = 0
macro(20,"Lurar",function()
  local count = 0
  local players = 0
  for s, spec in pairs(getSpectators(false)) do
    if spec:isMonster() then 
      if distanceFromPlayer(spec:getPosition()) <= dist then count = count + 1 end
    elseif spec ~= player and spec:isPlayer() then players = players + 1
    end
  end
  if count >= qntd and players > 1 then
    CaveBot.setOn()
    return
  end
  for i=1,waypoints do
    if count >= qntd then order[i] = i else order[i] = waypoints +1-i end
  end
  for _, i in pairs(order) do
    if distanceFromPlayer(pos[i]) < maxGoto then
      if i == lastWalk and player:isWalking() then return end
      lastWalk = i
      autoWalk(pos[i], maxGoto, {ignoreNonPathable = true, precision = 3})
      break
    end
  end
end)