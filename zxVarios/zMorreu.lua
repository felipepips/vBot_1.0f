--[[ server que toma tp, não reloga 
local npcName = "Icarus" -- nome do npc que fica no templo
local cavebotConfig = "Anubis" -- nome do profile que vai usar

local sefudeu = macro(12312313,"Morreu",function() end)

onCreatureAppear(function(creature)
  if sefudeu:isOff() then return end
  if creature:getName() ~= npcName then return end
  if not CaveBot then return end
  CaveBot.setCurrentProfile(cavebotConfig)
  CaveBot:setOff()
  CaveBot:setOn()
end)
]]

-- server que reloga:
local npcName = "Icarus" -- nome do npc que fica no templo
local cavebotConfig = "Anubis" -- nome do profile que vai usar

macro(3000,"Morreu",function()
  if not CaveBot then return end
  if CaveBot.getCurrentProfile() ~= cavebotConfig then
    if getCreatureByName(npcName) then
      CaveBot.setCurrentProfile(cavebotConfig)
      CaveBot:setOff()
      CaveBot:setOn()
    end
  end
end)