-- BUY SUPPLIES
-- START CONFIG
local npcName = "Xodet"
local toBuy = {
  -- [id do item] = quantidade,
  [3160] = 150,
}
-- END CONFIG

if retries > 200 then
  warn("BUY SUPPLIES ERROR")
  return true
end
local npc = getCreatureByName(npcName)
if not npc then
  warn("NPC NOT FOUND")
  return true
end
local npcPos = npc:getPosition()
if getDistanceBetween(pos(),npcPos) > 3 then
  CaveBot.walkTo(npcPos,15,{precision=3})
  return "retry"
end
if not NPC.isTrading() then
  NPC.say("hi")
  schedule(1000,function()
    NPC.say('trade')
  end)
  delay(2000)
  return "retry"
end
for id, amount in pairs(toBuy) do
  local count = player:getItemsCount(id)
  if count < amount then
    NPC.buy(id,math.min((amount - count),100))
    delay(250)
    return "retry"
  end
end
return true

-- MANUAL WALK
-- DIRECTIONS = North,   East,   South,   West,   NorthEast,   SouthEast,   SouthWest,   NorthWest
local moves = {East,East,NorthEast,SouthWest}
local delay = 250
-- END CONFIG
local wait = 0
for _, dir in pairs(moves) do
  schedule(wait,function()
    walk(dir)
  end)
  wait = wait + delay
end
CaveBot.delay(wait)
return true

-- CHECK ATTACKING CREATURE
local nameToStop = "Trainer"
-- END CONFIG
if g_game.isAttacking() then
  if g_game.getAttackingCreature():getName():lower() == nameToStop:lower() then
    CaveBot.setOff()
    return true
  end
end
gotoLabel('Trainer')
return true

