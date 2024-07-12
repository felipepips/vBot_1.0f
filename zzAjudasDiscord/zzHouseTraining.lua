--START CONFIG
local SAFE_POSITION = {x=32874,y=31973,z=12}
local OUTSIDE_POSITION = {x=32874,y=31972,z=12}
local IGNORAR_EMBLEMAS = {1,4} -- ou vazio
local MAX_RANGE = 6 -- MAX IS 6
local IGNORAR_MONSTROS = true
local MULTI_FLOOR = false
--END CONFIG

local walk = {ignoreNonPathable = true, precision = 0 }
macro(250,"House Training",function()
  for s, spec in pairs(getSpectators(MULTI_FLOOR)) do
    if distanceFromPlayer(spec:getPosition()) <= MAX_RANGE then
      if not spec:isLocalPlayer() and (not IGNORAR_MONSTROS or spec:isPlayer()) then
        if not spec:getEmblem() or not table.find(IGNORAR_EMBLEMAS,spec:getEmblem()) then
          return autoWalk(SAFE_POSITION,10,walk)
        end
      end
    end
  end
  autoWalk(OUTSIDE_POSITION,10,walk)
end)