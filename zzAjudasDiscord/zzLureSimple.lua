setDefaultTab("cave")

--START CONFIG
local MIN_MONSTERS_TO_LURE = 1
local DIST_TO_PAUSE = 4 -- DISTANCE FROM MONSTER TO PAUSE CAVEBOT TO WAIT/LURE
local MAX_DISTANCE = 8 -- MAX DISTANCE TO COUNT MONSTERS (RECOMMEND 6)
--END CONFIG


lurar = macro(50,"Lurar",function()
  local monsters = 0
  local minDist = 0
  for s, spec in pairs(getSpectators(false)) do
    local dist = getDistanceBetween(pos(),spec:getPosition())
    if spec:isMonster() and dist <= MAX_DISTANCE then 
      monsters = monsters + 1
      if dist > minDist then minDist = dist end
      if monsters >= MIN_MONSTERS_TO_LURE then break end
    end
  end

  if minDist >= DIST_TO_PAUSE then CaveBot.setOff() else CaveBot.setOn() end
end)