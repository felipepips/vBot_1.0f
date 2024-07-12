local keyword = "lider"
local leaderShield = {4,6,8,10}

local pl = macro(10000,"Pass Leadership",function() end)

onTalk(function(name, level, mode, text, channelId, pos)
  if pl.isOn() and text:lower():find(keyword:lower()) then
    local whoAsked = getCreatureByName(name)
    if not whoAsked then return end
    if table.find(leaderShield,player:getShield()) and whoAsked:getShield() > 2 then 
      g_game.partyPassLeadership(whoAsked:getId())
    end
  end
end)