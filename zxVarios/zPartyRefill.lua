-- PARTY REFILL
-- START CONFIG
local party = {
  'Player Name1','Player Name2','Player Name3',
}

local command = 'GOING REFILL'
-- END CONFIG

local ptrMacro = macro(123132,"Party Refill",function()end)

onTalk(function(name, level, mode, text, channelId, pos)
  if ptrMacro:isOff() then return end
  if text ~= command then return end
  if not table.find(party,name,true) then return end
  storage.caveBot.forceRefill = true
  warn(name.." forced party refill")
end)

-- send friends msg
function callFriends()
  local myName = player:getName():lower()
  for _, friendName in pairs(party) do
    if friendName:lower() ~= myName then
      talkPrivate(friendName,command)
    end
  end
end

--[[
THIS PART OF THE CODE YOU HAVE TO INSERT RIGHT BEFORE SUPPLY CHECK ON CAVEBOT WAYPOINTS
CLICK 'FUNCTION' IN CAVEBOT AND PASTE CODE BELOW: 

-- START HERE
if not storage.caveBot.forceRefill and hasSupplies() ~= true then
  callFriends()
end
return true
-- END HERE

]]
