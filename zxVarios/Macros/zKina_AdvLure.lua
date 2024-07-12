--[[
CHANGES TO MAKE IT WORK:

ON cavebot\cavebot.lua
Lines 77 & 78

from:
local nextAction = ui.list:getChildIndex(currentAction) + 1
if nextAction > actions then

to:
local nextAction = ui.list:getChildIndex(currentAction) + 1 + (storage.luring or 0)
if nextAction > actions or nextAction < 1 then
--]]

-- START CONFIG
local distance_to_count = 10
local amount_of_monsters = 1
-- END CONFIG


local steps_back = -2
storage.luring = 0
local lurar = macro(50,"Lurar",function(m)
  if getMonsters(distance_to_count) >= amount_of_monsters then
    if storage.luring ~= steps_back then
      storage.luring = steps_back
      CaveBot.resetWalking()
      local focused = CaveBot.actionList:getFocusedChild()
      local nextAction = focused and CaveBot.actionList:getChildIndex(focused) + 1 + steps_back or 1
      if nextAction > CaveBot.actionList:getChildCount() or nextAction < 1 then
        nextAction = 1
      end
      CaveBot.actionList:focusChild(CaveBot.actionList:getChildByIndex(nextAction))
    end
  else
    if storage.luring == steps_back then
      storage.luring = 0
      CaveBot.resetWalking()
      local focused = CaveBot.actionList:getFocusedChild()
      local nextAction = focused and CaveBot.actionList:getChildIndex(focused) + 1
      if nextAction > CaveBot.actionList:getChildCount() or nextAction < 1 then
        nextAction = 1
      end
      CaveBot.actionList:focusChild(CaveBot.actionList:getChildByIndex(nextAction))
    end
  end
  schedule(50,function()
    if m:isOn() then return end
    storage.luring = 0
  end)
end)