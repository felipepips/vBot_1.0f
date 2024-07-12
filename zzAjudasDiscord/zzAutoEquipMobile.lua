UI.Separator()
setDefaultTab("tools")

-- START CONFIG
local ITEMS_TO_EQUIP = { -- you can set as many items as you want. just use the same pattern.
    [1] = { -- EXAMPLE LIFE RING
        ENABLED = true, -- true or false
        ID1 = 3052,
        ID2 = 3089, -- some items have different ID's when equipped. set it here
        SLOT = 9, -- check slots numbers below
        MIN_HP = 80,
        MAX_HP = 100,
        MIN_MP = 0,
        MAX_MP = 90,
        UNEQUIP = true, -- true = unequip item if out of these conditions
    },
    [2] = { -- EXAMPLE PLATINUM AMULET
        ENABLED = true,
        ID1 = 3055,
        ID2 = 3055,
        SLOT = 2,
        MIN_HP = 21, -- min hp 21 because gonna equip AOL when less then 20
        MAX_HP = 100,
        MIN_MP = 0,
        MAX_MP = 100,
        UNEQUIP = false, -- you don't have to unequip it, since it don't have charges or duration time.
    },
    [3] = { -- EXAMPLE AMULET OF LOSS
        ENABLED = true,
        ID1 = 3057,
        ID2 = 3057,
        SLOT = 2,
        MIN_HP = 0,
        MAX_HP = 20,
        MIN_MP = 0,
        MAX_MP = 100,
        UNEQUIP = true,
    },
    [4] = { -- EXAMPLE ENERGY RING
        ENABLED = true,
        ID1 = 3051,
        ID2 = 3088,
        SLOT = 9,
        MIN_HP = 0,
        MAX_HP = 79,
        MIN_MP = 50, -- only equip if +50% mana
        MAX_MP = 100,
        UNEQUIP = true,
    },
    [5] = { -- EXAMPLE MIGHT RING
        ENABLED = true,
        ID1 = 3048,
        ID2 = 3048,
        SLOT = 9,
        MIN_HP = 0,
        MAX_HP = 79,
        MIN_MP = 0, -- only equip if -50% mana
        MAX_MP = 49,
        UNEQUIP = true,
    },
}

-- END CONFIG

--[[
SLOTS YOU CAN USE:
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


-- don't edit below this line unless you know what you are doing

local oldVersion = g_game.getClientVersion() <= 910

local function unequipItem(slot)
  local item = getSlot(slot)
  if not oldVersion then
    g_game.equipItemId(item)
  else
    local dest
    for i, container in pairs(g_game.getContainers()) do
        local cname = container:getName():lower()
        if container:getCapacity() > #container:getItems() and not cname:find("dead") and not cname:find("depot") and not cname:find("quiver") then
            dest = container
        end
        break
    end

    if not dest then return true end
    local pos = dest:getSlotPosition(dest:getCapacity())
    g_game.move(item, pos, item:getCount())
  end
  return true
end

local equip2 = macro(250, "Equip Item HP/MP %", function()
  local containers = g_game.getContainers()
  local hp = player:getHealthPercent()
  local mp = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  for e, entry in ipairs(ITEMS_TO_EQUIP) do
    if entry.ENABLED then
      local HPmin = entry.MIN_HP
      local HPmax = entry.MAX_HP
      local MPmin = entry.MIN_MP
      local MPmax = entry.MAX_MP
      local slotItem = getSlot(entry.SLOT)
      if hp >= HPmin and hp <= HPmax and mp >= MPmin and mp <= MPmax then
        if not slotItem or (slotItem:getId() ~= entry.ID1 and slotItem:getId() ~= entry.ID2) then
          for _, container in pairs(containers) do
            for __, item in ipairs(container:getItems()) do
              if item:getId() == entry.ID1 or item:getId() == entry.ID2 then
                if oldVersion then
                  g_game.move(item, {x=65535, y=entry.SLOT, z=0}, item:getCount())  
                else
                  g_game.equipItemId(item)
                end
                delay(500) 
                return
              end
            end
          end
        end
      elseif entry.UNEQUIP and slotItem and (slotItem:getId() == entry.ID1 or slotItem:getId() == entry.ID2) then
        unequipItem(entry.SLOT)
        delay(500)
        return
      end
    end
  end
end)