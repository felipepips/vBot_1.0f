-- Auto Conjure & Equip Diamond Arrows
-- start config
local conjure_spell = "exevo gran con hur"
local diamond_id = 25757
local backpack_id = 8860
local arrow_slot = 10
-- end config

macro(1000,"Conjure D-Arrow",function()
  -- cast
  if not getSpellCoolDown(conjure_spell) then
    return say(conjure_spell)
  end
  -- equip
  local ammo = getSlot(arrow_slot)
  if not ammo or ammo:getCount() < 50 then
    local find = findItem(diamond_id)
    if find then
      return moveToSlot(find,arrow_slot)
    end
  end
  -- move to quiver
  local backpack = getContainerByItem(backpack_id,true)
  if backpack then
    for c, cont in pairs(getContainers()) do
      if cont:getContainerItem():getId() ~= backpack_id then
        for i, item in ipairs(cont:getItems()) do
          if item:getId() == diamond_id then
            return g_game.move(item,backpack:getSlotPosition(1),item:getCount())
          end
        end
      end
    end
  end
end)
