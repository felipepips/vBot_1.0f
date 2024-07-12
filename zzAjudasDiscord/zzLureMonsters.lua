setDefaultTab("cave")

--START CONFIG
local MONSTERS_NAMES = {"Ravaged Ape","Lava Treeling","Crystal Spectre","berserker"}
local MIN_MONSTERS_TO_LURE = 1
local DIST_TO_PAUSE = 7 -- DISTANCE FROM MONSTER TO PAUSE CAVEBOT TO WAIT/LURE
local MAX_DISTANCE = 8 -- MAX DISTANCE TO COUNT MONSTERS (RECOMMEND 6)
-- local BLOCK_POSITION = {x=6213,y=40,z=5}
local BLOCK_POSITION = {x=32343,y=32212,z=7}
--END CONFIG

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


storage.luring = 0
local p = BLOCK_POSITION
local stopTarget = macro(1000,"Pause Target",function() end)
local stopCave = macro(1000,"Pause Cavebot",function() end)
local lurar = macro(50,"Lurar",function()
    local monsters = 0
    local minDist = 0
    for s, spec in pairs(getSpectators(false)) do
        local dist = getDistanceBetween(pos(),spec:getPosition())
        if not spec:isPlayer() and dist <= MAX_DISTANCE then 
            for e, entry in pairs(MONSTERS_NAMES) do
                if string.find(spec:getName():lower(),entry:lower()) then
                    monsters = monsters + 1
                    if minDist == 0 or dist < minDist then minDist = dist end
                    if monsters >= MIN_MONSTERS_TO_LURE then break end
                end
            end
        end
    end
    if monsters >= MIN_MONSTERS_TO_LURE then storage.luring = -2 else storage.luring = 0 end
    if stopCave:isOn() then
        if minDist >= DIST_TO_PAUSE then CaveBot.setOff() else CaveBot.setOn() end
    end
    if stopTarget:isOn() then
        if pos().x == p.x and pos().y == p.y and pos().z == p.z then
            TargetBot.setOn()
        else
            TargetBot.setOff()
        end
    end
end)