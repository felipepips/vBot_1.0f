-- OPEN BAG
local bag_id = 2853
local bag = getContainerByItem(bag_id)
if not bag then
  g_game.use(getBack())
  delay(500)
end
return true

-- ABRIR PONTE
local id = 27260
local find = findItemOnGround(id)
if find then
  g_game.use(find)
  delay(500)
end
return true

-- CHECK LEVEL
if lvl() < 8 then
  gotoLabel('startHunt')
end
return true

-- DROP ALL ITEMS
local slots = {getHead(),getBody(),getLeg(),getFeet(),getLeft(),getRight(),getBack()}
local time = 0
for e, entry in pairs(slots) do
  if entry then
    schedule(time,function()
      g_game.move(entry,pos())
    end)
    time = time + 350
  end
end
return true

-- ORACLE
local npcName = "The Oracle"
local conversation = {"hi","yes","Thais",storage["ChooseVoc"].vocation,"yes"}
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

-- CHANGE PROFILE (TABLE)
local config = {
  {0,8,"02-Thais"},
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
  schedule(1000,function()
    CaveBot.setOn()
  end)
end
delay(2000)
return true

-- CHANGE PROFILE (SIMPLE)
local profile = "02-Thais"
storage._configs.cavebot_configs.selected = profile
CaveBot.setOff()
schedule(1000,function()
  CaveBot.setOn()
end)
delay(2000)
return true

-- OPEN BACKPACK
local bag_id = 2854
local bag = getContainerByItem(bag_id)
if not bag then
  g_game.use(getBack())
  delay(500)
end
return true

-- EQUIP ITEMS
local kina_weapon = storage["ChooseVoc"].weaponId
local items_to_equip = {kina_weapon,3572,3552,3372,3354,3359,3425,3066,3074,7992,3059,3362,3374,3277,8095,35562,3571}
local wait = 0
for e, entry in pairs(items_to_equip) do
  if findItem(entry) then
    schedule(wait,function()
      g_game.equipItemId(entry)
    end)
    wait = wait + 350
  end
end
delay(wait)
return true