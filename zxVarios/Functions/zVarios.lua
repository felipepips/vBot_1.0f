-- Change Profile by Level / CaveBot Function
local config = {
  {0,8,"Primeira Config"},
  {9,100,"Segunda Config"},
  {101,999999,"Terceira Config"},
}
local next = config[1][3]
for e, entry in pairs(config) do
  local min = entry[1]
  local max = entry[2]
  local lv = lvl()
  if min <= lv and lv <= max then
    next = entry[3]
    break
  end
end

if next ~= storage._configs.cavebot_configs.selected then
  storage._configs.cavebot_configs.selected = next
  CaveBot.setOff()
  CaveBot.setOn()
end

return true

-- CHECK LEVEL / CAVEBOT FUNCTION
if lvl() >= 40 then
  gotoLabel("BarcoThais")
else
  gotoLabel("caça2")
end
return true

-- CHANGE TARGET PROFILE
TargetBot.getCurrentProfile = function()
  return storage._configs.targetbot_configs.selected
end

-- CHECK ITEM AMOUNT / CAVEBOT FUNCTION
if itemAmount(1234) < 500 then
  gotoLabel("leave")
else
  gotoLabel("continue")
end
return true

-- CHECK BLESS / CAVEBOT FUNCTION
local bless = player:getBlessings()
if bless == 0 then
  CaveBot.setOff()
end
return true

-- TALK NPC DELAY
-- ORACLE
local npcName = "The Oracle"
local conversation = {"hi","yes","Thais","Knight","yes"}
local talkDelay = 2222 -- ms
local maxDistance = 3 -- sqm

local npc = getCreatureByName(npcName)
if not npc or retries > 20 then 
  return false 
end

local npcPos = npc:getPosition()
local wait = 300

if distanceFromPlayer(npcPos) > maxDistance then
  autoWalk(npcPos, 15, {precision=maxDistance})
  delay(wait)
  return "retry"
end

for i, msg in ipairs(conversation) do
  schedule(talkDelay * i, function()
    NPC.say(msg)
  end)
  wait = talkDelay * (i+1)
end

delay(wait)
return true