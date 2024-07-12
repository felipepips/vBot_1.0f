local ringTo = 3097
local checkInterval = 2

local lastDrunk 
macro(600, "Drunk Checker", function()
local dwarvenRing = getFinger() and (getFinger():getId() == 3097 or getFinger():getId() == getActiveItemId(3097))
local ring = getFinger() and (getFinger():getId() ~= ringTo or getFinger():getId() ~= getActiveItemId(ringTo))
    if isDrunk() then
        storage.autoEquip[1].on = false
        lastDrunk = now
        g_game.equipItemId(3097)
    elseif not lastDrunk or now - lastDrunk > checkInterval*1000 then 
        if dwarvenRing then
            g_game.equipItemId(ringTo)
            storage.autoEquip[1].on = true
        end
     return
    end
end)