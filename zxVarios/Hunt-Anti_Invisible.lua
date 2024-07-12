-- config
local pvpSafe = true
local runeId = 3175
local maxDist = {x = 8, y = 6}
local exhausted = 1000
local creatures = {"warlock"}

-- do not change below
local lastUse
local m = macro(5000, "Anti Invisible", function() end)
onCreatureDisappear(function(creature)
  if m.isOff() then return end
  if creature:getHealthPercent() == 0 then return end
  if not table.find(creatures,creature:getName(),true) then return end
  local pos = creature:getPosition()
  if pos.z ~= posz() then return end

  local tile = g_map.getTile(pos)    
  if not tile then return end

  local tilePos = tile:getPosition()
  local pPos = player:getPosition()
  if math.abs(pPos.x-tilePos.x) >= maxDist.x or math.abs(pPos.y-tilePos.y) >= maxDist.y then return end

  if (not pvpSafe or isSafe(maxDist.x)) and tile:canShoot() and (not lastUse or now - lastUse > exhausted) then
    for i=0,2 do
      schedule(i*200, function()
        useWith(runeId, tile:getTopThing())
        lastUse = now
      end)
    end
  end
end)

onAddThing(function(tile, thing)
  if m.isOff() then return end
  if thing:getId() ~= 13 then return end
  if tile:hasCreature() then return end

  if (not pvpSafe or isSafe(maxDist.x)) and tile:canShoot() and (not lastUse or now - lastUse > exhausted) then
    for i=0,2 do
      schedule(i*200, function()
        useWith(runeId, tile:getTopThing())
        lastUse = now
      end)
    end
  end
end)