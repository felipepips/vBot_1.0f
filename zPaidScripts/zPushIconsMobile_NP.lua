-- macro para mobile para dar push, nem lembro direito como funciona

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

-- Storage
local stName = "PushIcons"
storage[stName] = storage[stName] or {
  sEx = 1100,
  sIPX = 500,
  sIPY = 450,
  sRune = 3188
}

local config = storage[stName]

-- UI
local main = setupUI([[
Panel
  height: 19

  Button
    id: edit
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    margin-top: 1
    width: 176
    height: 17
    !text: tr('Push Target')
    font: verdana-11px-rounded
    color: red
]])

local edit = setupUI([[
PushIconsBox < CheckBox
  font: verdana-11px-rounded
  margin-top: 5
  margin-left: 5
  anchors.top: prev.bottom
  anchors.left: parent.left
  anchors.right: parent.right
  color: lightGray

PushIconsText < BotTextEdit
  width: 80
  anchors.top: prev.bottom
  anchors.right: parent.right
  font: verdana-11px-rounded
  margin-top: 5

PushIconsLabel < Label
  font: verdana-11px-rounded
  anchors.left: parent.left
  margin-left: 5
  anchors.verticalCenter: prev.verticalCenter
  
Panel
  height: 123

  PushIconsText
    id: sIPX
    anchors.top: parent.top

  PushIconsLabel
    text: Icon Position X:

  PushIconsText
    id: sIPY

  PushIconsLabel
    text: Icon Position Y:

  PushIconsText
    id: sEx

  PushIconsLabel
    text: Push Delay:

  PushIconsText
    id: sRune

  PushIconsLabel
    text: Fire Field ID:
]])
edit:hide()

-- UI Functions
local showEdit = false
main.edit.onClick = function()
  showEdit = not showEdit
  if showEdit then edit:show()
  else edit:hide()
  end
end

edit.sIPX:setText(config.sIPX)
edit.sIPX.onTextChange = function(widget, text)
  config.sIPX = text
end
edit.sIPX:setTooltip("Need Restart to Change.")

edit.sIPY:setText(config.sIPY)
edit.sIPY.onTextChange = function(widget, text)
  config.sIPY = text
end
edit.sIPY:setTooltip("Need Restart to Change.")

edit.sEx:setText(config.sEx)
edit.sEx.onTextChange = function(widget, text)
  config.sEx = text
end

edit.sRune:setText(config.sRune)
edit.sRune.onTextChange = function(widget, text)
  config.sRune = text
end

--- End of UI

-- Base Icon Position
local x,y = config.sIPX, config.sIPY
-- Icon Config
local iConf = {
  step = 43, -- distance from each icon
  itemOn = 3548,
  itemOff = 3547,
}

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
  entry.icon = addIcon("icon"..e,{item=iConf.itemOff, movable=false, text=""}, function(w,on)
    w.item:setItemId(on and iConf.itemOn or iConf.itemOff)
    for o, off in pairs(offsetDirections) do
      if o ~= e then
        if off.enabled then off.icon:onClick() end
      end
    end
    entry.enabled = on
  end)
  
  entry.icon:breakAnchors()
  entry.icon:move(x+(entry.x * iConf.step), y+(entry.y * iConf.step))
  entry.icon:hide()
  entry.icon:setSize({height=iConf.step,width=iConf.step})
end

-- Main Loop
local hidden = true
local pushTarget = macro(50,function(m)
  if hidden then
    hidden = false
    main.edit:setColor("green")
    for e, entry in pairs(offsetDirections) do
      entry.icon:show()
    end
  else
    schedule(49,function()
      if m:isOn() then return end
      hidden = true
      main.edit:setColor("red")
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
      local tile = g_map.getTile(pos)
      if tile then
        local top = tile:getTopUseThing()
        if top and not top:isNotMoveable() then
          useWith(config.sRune,top)
        end
      end
      pos.x, pos.y = pos.x + entry.x, pos.y + entry.y
      if g_map.getTile(pos):isWalkable() then
        g_game.move(target,pos)
        return delay(config.sEx)
      end
    end
  end
end)

-- Central Icon
local mainIcon = addIcon("MainIcon",{movable=false, text="Push\nTarget"}, pushTarget)
mainIcon:breakAnchors()
mainIcon:move(x, y-10)
mainIcon:setSize({height=iConf.step,width=iConf.step})
mainIcon.text:setFont('verdana-11px-rounded')


-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL