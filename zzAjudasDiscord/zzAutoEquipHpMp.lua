[[Since many people look for this, and idk if there's something real good, i've made one :)
Tags: might energy ring ssa stone skin amulet equipper

You must configure it with attention, you must not have items transposing other items conditions (if they use the same slot)... **see the picture**
If you set:
might ring from 0-20 HP%
any other ring shouldn't use this same range..
if you also set Energy Ring, it must starts from 21% HP
and so on...

Unequip:
Basically you don't have to set "unequip" for items that gonna be swapped for any other else.. in the example, life ring should be unequipped since there is no other ring to replace it if you are over 50% HP and 80% MP...

You can have as many items as you want, just change it on the "config" section in the beginning of the script.
```local scripts = 6 -- if you want more auto equip panels you can change this value```]]


-- Auto Equip Item HP and MP percent
-- Tags: might energy ring ssa stone skin amulet equipper

-- START CONFIG
local scripts = 6 -- if you want more auto equip panels you can change this value
local maxHeight = 610 -- adjust if the window is larger then your screen
local toggleHotkey = "End" -- e.g.: "Space" "Ctrl+Space" "Shift+Pause" "Alt+F2"
local createIcon = true -- true or false
local Icon, Pos = 200,270
local defaultTab = "tools"
-- END CONFIG


-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

UI.Separator()
setDefaultTab(defaultTab)
UI.Label("Auto Equipper Hotkey: "..toggleHotkey)

local panelName = "AutoEquipV2"

if not storage[panelName] or type(storage[panelName]) ~= "table" then
  storage[panelName] = {}
end

local config = storage[panelName]
local oldVersion = g_game.getClientVersion() <= 910

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: main
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Auto Equip HP/MP %%')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])

g_ui.loadUIFromString([[
AutoEquipWindow < MainWindow
  !text: tr('Auto Equipper HP/MP%% by F.Almeida')
  size: 400 350
  @onEscape: self:hide()

  VerticalScrollBar
    id: contentScroll
    anchors.top: parent.top
    margin-top: 3
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 5
    margin-bottom: 5

  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 10
    
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

    Panel
      id: right
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.left: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

    VerticalSeparator
      anchors.top: parent.top
      anchors.bottom: prev.bottom
      anchors.left: parent.horizontalCenter

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8    

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 5    

  Label
    !text: tr('')
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 5
    margin-left: 15   

DualScroll < Panel
  height: 29
  margin-top: 3
    
  Label
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  HorizontalScrollBar
    id: scroll1
    anchors.left: title.left
    anchors.right: title.horizontalCenter
    anchors.top: title.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 100
    step: 1
    &disableScroll: true
    
  HorizontalScrollBar
    id: scroll2
    anchors.left: title.horizontalCenter
    anchors.right: title.right
    anchors.top: prev.top
    margin-left: 2
    minimum: 0
    maximum: 100
    step: 1
    &disableScroll: true

TwoItems < Panel
  height: 35
  margin-top: 4
      
  BotItem
    id: item1
    anchors.left: parent.left
    anchors.top: parent.top
    margin-top: 1

  BotItem
    id: item2
    anchors.left: prev.right
    anchors.top: prev.top
    margin-left: 1
    
  SmallBotSwitch
    id: title
    anchors.left: prev.right
    anchors.top: prev.top
    text-align: center
    width: 45
    margin-left: 2
    margin-top: 0
    tooltip: equip this item if under these conditions

  SmallBotSwitch
    id: title2
    anchors.left: prev.right
    anchors.right: parent.right
    anchors.top: prev.top
    text-align: center
    width: 55
    margin-left: 2
    margin-top: 0
    tooltip: unequip this item if out of these conditions

  SlotComboBox
    id: slot
    anchors.left: item2.right
    anchors.right: prev.right
    anchors.top: prev.bottom
    anchors.bottom: item2.bottom
    margin-top: 2
    margin-bottom: 1
    margin-left: 2
    &disableScroll: true
]])

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

if not storage.AutoEquipON then
  storage.AutoEquipON = {enabled = false}
end

ui.main:setOn(storage.AutoEquipON.enabled)
ui.main.onClick = function(widget)
storage.AutoEquipON.enabled = not storage.AutoEquipON.enabled
widget:setOn(storage.AutoEquipON.enabled)
end

rootWidget = g_ui.getRootWidget()
if rootWidget then
  AutoEquipWindow = UI.createWindow('AutoEquipWindow', rootWidget)
  AutoEquipWindow:hide()

  AutoEquipWindow.closeButton.onClick = function(widget)
    AutoEquipWindow:hide()
  end
end

ui.edit.onClick = function(widget)
  AutoEquipWindow:show()
  AutoEquipWindow:raise()
  AutoEquipWindow:focus()
end

local maxH = (math.ceil(scripts / 2)*133)+87
AutoEquipWindow:setHeight(maxH > maxHeight and maxHeight or maxH)

UI.DualScroll = function(params, callback, parent)
  params.title = params.title or "title"
  params.min = params.min or 20
  params.max = params.max or 80
  
  local widget = UI.createWidget('DualScroll', parent)
  
  local update  = function(dontSignal)
    widget.title:setText("" .. params.min .. "% <= " .. params.title .. " <= " .. params.max .. "%")  
    if callback and not dontSignal then
      callback(widget, params)
    end
  end
  
  widget.scroll1:setValue(params.min)
  widget.scroll2:setValue(params.max)

  widget.scroll1.onValueChange = function(scroll, value)
    params.min = value
    update()
  end
  widget.scroll2.onValueChange = function(scroll, value)
    params.max = value
    update()
  end
  update(true)
end

UI.TwoItems = function(params, callback, parent)
  params.title = params.title or "title"
  params.title = params.title or "title2"
  params.item1 = params.item1 or 0
  params.item2 = params.item2 or 0
  params.slot = params.slot or 1
  
  local widget = UI.createWidget("TwoItems", parent)
    
  widget.title:setText(params.title)
  widget.title:setOn(params.on)
  widget.title.onClick = function()
    params.on = not params.on
    widget.title:setOn(params.on)
    if callback then
      callback(widget, params)
    end
  end

  widget.title2:setText(params.title2)
  widget.title2:setOn(params.unequip)
  widget.title2.onClick = function()
    params.unequip = not params.unequip
    widget.title2:setOn(params.unequip)
    if callback then
      callback(widget, params)
    end
  end
  
  widget.slot:setCurrentIndex(params.slot)
  widget.slot.onOptionChange = function()
    params.slot = widget.slot.currentIndex
    if callback then
      callback(widget, params)
    end
  end
  
  widget.item1:setItemId(params.item1)
  widget.item1.onItemChange = function()
    params.item1 = widget.item1:getItemId()
    if callback then
      callback(widget, params)
    end
  end
 
  widget.item2:setItemId(params.item2)
  widget.item2.onItemChange = function()
    params.item2 = widget.item2:getItemId()
    if callback then
      callback(widget, params)
    end
  end 
  
  return widget
end

for i=1,scripts do
  local destUi = i % 2 == 0 and AutoEquipWindow.content.right or AutoEquipWindow.content.left
  if not config[i] then
    config[i] = {
      on = i == 1 and true or false, 
      title="Equip", 
      item1 = i == 1 and 3052 or 0, 
      item2 = i == 1 and 3089 or 0, 
      slot = i == 1 and 9 or 0,
      unequip = i == 1 and true or false,
      title2 = "Unequip",
      ["HP"]={      
        title="HP%",
        min=0,
        max=100},
      ["MP"]={      
        title="MP%",
        min=0,
        max=i == 1 and 90 or 100},
    }
  end

  UI.Label("Item "..i,destUi)
  UI.TwoItems(config[i], function(widget, newParams)
    config[i] = newParams
  end,destUi)
  UI.DualScroll(config[i].HP, function(widget, newParams) 
    config[i].HP = newParams
  end,destUi)
  UI.DualScroll(config[i].MP, function(widget, newParams) 
    config[i].MP = newParams
  end,destUi)
  UI.Separator(destUi)
end

local function unequipItem(slot)
  local item = getSlot(slot)
  if not oldVersion then
    g_game.equipItemId(item)
  else
    local dest
    for i, container in pairs(g_game.getContainers()) do
        local cname = container:getName():lower()
        if container:getCapacity() > #container:getItems() and not cname:find("dead") and not cname:find("slain") and not cname:find("depot") and not cname:find("quiver") then
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

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

macro(250, function()
  if not storage.AutoEquipON.enabled then return true end
  local containers = g_game.getContainers()
  local hp = player:getHealthPercent()
  local mp = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  for e, entry in ipairs(config) do
    if entry.on then
      local HPmin = entry.HP.min
      local HPmax = entry.HP.max
      local MPmin = entry.MP.min
      local MPmax = entry.MP.max
      local slotItem = getSlot(entry.slot)
      if hp >= HPmin and hp <= HPmax and mp >= MPmin and mp <= MPmax then
        if not slotItem or (slotItem:getId() ~= entry.item1 and slotItem:getId() ~= entry.item2) then
          for _, container in pairs(containers) do
            for __, item in ipairs(container:getItems()) do
              if item:getId() == entry.item1 or item:getId() == entry.item2 then
                if oldVersion then
                  g_game.move(item, {x=65535, y=entry.slot, z=0}, item:getCount())  
                else
                  g_game.equipItemId(item)
                end
                delay(500) 
                return
              end
            end
          end
        end
      elseif entry.unequip and slotItem and (slotItem:getId() == entry.item1 or slotItem:getId() == entry.item2) then
        unequipItem(entry.slot)
        delay(500)
        return
      end
    end
  end
end)

if createIcon then
  local icon = addIcon("AutoEquipV2", {text="Auto\nEquip", hotkey=toggleHotkey, switchable=false}, 
  function(widget,isOn)
    storage.AutoEquipON.enabled = not storage.AutoEquipON.enabled
    broadcastMessage(storage.AutoEquipON.enabled and "Auto-Equipper ON" or "Auto-Equipper OFF")
    widget.text:setColor(storage.AutoEquipON.enabled and "green" or "red")
    return ui.main:setOn(storage.AutoEquipON.enabled)
  end)
  icon:breakAnchors()
  icon:move(Icon,Pos)
  icon.hotkey:setText('')
  icon.text:setFont('verdana-11px-rounded')
  icon.text:setColor(storage.AutoEquipON.enabled and "green" or "red")
else
  hotkey(toggleHotkey, function() 
    storage.AutoEquipON.enabled = not storage.AutoEquipON.enabled
    broadcastMessage(storage.AutoEquipON.enabled and "Auto-Equipper ON" or "Auto-Equipper OFF")
  end)
end

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD