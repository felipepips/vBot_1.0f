-- Icon Constructor
-- Made by F.Almeida#8019

------------------------------------ START CONFIG

-- ICON SETTINGS
local iconsStartPos = {x=200,y=250} -- starting position of icons
local iconsDirection = {x=0,y=1} -- south = {x=0,y=1} // north {x=0,y=-1} // west = {x=-1,y=0} // east = {x=1,y=0} // also, if you want double padding, you can set 2 instead of 1
local iconSizeWithItem = {x=50,y=50}
local iconTextColor = "white"
local fontStyle = "verdana-11px-rounded"
local iconBreakAnchors = true -- true = always reset to original position when restart bot // false = save positions // setting break anchors to false will not respect iconStartPos and direction at the first time, but gonna save positions on player storage

-- ITEMS:
local items = {3191,3155,3160,3180}

-- SWITCH NAME (ON/OFF MACRO)
local switchName = "Runes Icons"

------------------------------------ END CONFIG


-- Don't edit anything below this line, unless you know what you are doing :)

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- function executed onClick
local function notInUse()
end

-- count function
local function countItem(id)
  return itemAmount(id)
end

-- create icons
local lastPos = iconsStartPos
for i = 1,#items do
  local id = items[i]

  local icon = addIcon("Icon"..id, {item=id,switchable=false, movable=false, text=id},function() notInUse() end)
  icon:setId("Icon"..id)
  icon.text:setFont(fontStyle) -- icon font style
  icon.text:setColor(iconTextColor) -- text color
  -- icon positions:
  if iconBreakAnchors then icon:breakAnchors() end 
  local a,b = lastPos.x,lastPos.y 
  icon:move(a,b)
  local size = icon:getSize()
  lastPos = {x=lastPos.x + (size.width*iconsDirection.x),y=lastPos.y + (size.height*iconsDirection.y)}

  -- hide by default
  icon:hide()
end

-- main loop to refresh count and show/hide icons
macro(50,switchName, function(m)
  schedule(50,function()
    for i = 1,#items do
      local id = items[i]
      local panel = modules.game_interface.getMapPanel()
      local icon = panel:getChildById("Icon"..id)
      if icon then 
        if m:isOn() then
          icon:show()
          icon.text:setText(countItem(id).."\n") 
        else
          icon:hide()
        end
      end
    end
  end)
end)