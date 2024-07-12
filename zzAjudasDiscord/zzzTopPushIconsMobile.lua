-- Default Delay
local ex = 1100

-- Base Position
local x,y = 500,450

-- Directions
local offsetDirections = {
  [North]      = {x =  0, y = -1, enabled = false, icon = nil},
  [East]       = {x =  1, y =  0, enabled = false, icon = nil},
  [South]      = {x =  0, y =  1, enabled = false, icon = nil},
  [West]       = {x = -1, y =  0, enabled = false, icon = nil},
  [NorthEast]  = {x =  1, y = -1, enabled = false, icon = nil},
  [SouthEast]  = {x =  1, y =  1, enabled = false, icon = nil},
  [SouthWest]  = {x = -1, y =  1, enabled = false, icon = nil},
  [NorthWest]  = {x = -1, y = -1, enabled = false, icon = nil},
}

-- Positions Icons
for e, entry in pairs(offsetDirections) do
  entry.icon = addIcon("icon"..e,{item=3547, movable=false, text=""}, function(w,on)
    w.item:setItemId(on and 3548 or 3547)
    entry.enabled = on
  end)
  local move = 50
  entry.icon:breakAnchors()
  entry.icon:move(x+(entry.x * move), y+(entry.y * move))
  entry.icon:hide()
end

-- Main Loop
local hidden = true
local pushTarget = macro(50,function(m)
  if hidden then
    hidden = false
    for e, entry in pairs(offsetDirections) do
      entry.icon:show()
    end
  else
    schedule(51,function()
      if m:isOn() then return end
      hidden = true
      for e, entry in pairs(offsetDirections) do
        entry.icon:hide()
      end
    end)
  end
  local target = g_game.getAttackingCreature() or g_game.getFollowingCreature()
  if not target then return end
  for e, entry in pairs(offsetDirections) do
    if entry.enabled then
      local pos = target:getPosition()
      pos.x, pos.y = pos.x + entry.x, pos.y + entry.y
      if g_map.getTile(pos):isWalkable() then
        g_game.move(target,pos)
        return delay(ex)
      end
    end
  end
end)

-- Central Icon
local mainIcon = addIcon("MainIcon",{movable=false, text="Push\nTarget"}, pushTarget)
mainIcon:breakAnchors()
mainIcon:move(x, y-15)
mainIcon.text:setFont('verdana-11px-rounded')