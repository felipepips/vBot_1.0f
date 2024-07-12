--[[
  SLOTS IDs:
  Head = 1
  Neck = 2
  Back = 3
  Body = 4
  Right = 5
  Left = 6
  Leg = 7
  Feet = 8
  Finger = 9
  Ammo = 10
]]--

-- Auto Equip Enchanted Weapon
-- start config
local enchanted = {
  equipped = {26034,26040,26043,26022,3350},
  inventory = {26064,26070,26073,26052,3350},
}
local weaponSlot = 6 -- (5 = right hand, 6 = left hand)
-- end config

macro(1000,"Equip Enchanted",function()
  local equip = getSlot(weaponSlot)
  if not equip or not table.find(enchanted.equipped,equip:getId()) then
    for e, entry in ipairs(enchanted.inventory) do
      local find = findItem(entry)
      if find then
        return moveToSlot(find,weaponSlot)
      end
    end
  end
end)