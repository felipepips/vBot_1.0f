--START CONFIG
local PLAYER_NAME = "Masterful"
local ITEM_ID = 1234
local START_MSG = "ManaON"
local STOP_MSG = "ManaOFF"
--END CONFIG

local manarune = macro(250,"Use Item on Player",function()
    if not findItem(ITEM_ID) then return true end
    for s, spec in pairs(getSpectators(false)) do
        if spec:getName() == PLAYER_NAME then
            return g_game.useInventoryItemWith(ITEM_ID, spec)
        end
    end
end)

onTalk(function(name, level, mode, text, channelId, pos)
    if name ~= PLAYER_NAME then return true end
    text = text:lower()
    if string.find(text,START_MSG:lower()) then manarune:setOn() end
    if string.find(text,STOP_MSG:lower()) then manarune:setOff() end
end)

--START CONFIG
local MinMana = 90 -- min mana % to ask for mana runes xD
local manaOnMsg = "ManaON"
local manaOffMsg = "ManaOFF"
--END CONFIG

local asked = ""
macro(200, "Ask for Mana", function()
  if manapercent() <= MinMana and asked ~= manaOnMsg then 
    asked = manaOnMsg
    say(manaOnMsg)
  elseif manapercent() >= MinMana and asked ~= manaOffMsg then 
    asked = manaOffMsg
    say(manaOffMsg)
  end
end)