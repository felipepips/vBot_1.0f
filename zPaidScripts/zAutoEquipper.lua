-- Auto Equipper by HP / MP %

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL

--[[
items:
se o item for tipo life ring, energy ring, que quando vc equipa ele muda o ID, vc tem q cadastrar os dois IDs, primeiro desequipado segundo equipado..
se for item simples tipo SSA que não muda ID só precisa cadastrar no primeiro slot.

equip/unequip:
equip é pra equipar, se estiver dentro daquelas condições
unequip é pra desequipar o item se estiver fora das condições (se o item vai ser substituido por algum outro, vc n precisa marcar o unequip, pq o outro item já vai tirar ele do lugar.. mas se for tipo um life ring, que quando chegar em, sei lá.. 90% de mana vc quer só tirar e n colocar nd no lugar, vc marca o unequip)

hp e mp%:
só colocar mínimo e máximo de cada um.. 
(nesse ponto é importante se atentar que 1 item nunca pode sobrepor o outro, tanto em HP quanto MP)
no começo as vzs pode gerar um pouco de dúvida ou erros nessa parte, mas depois vc acostuma e vê que é bem de boas..

]]

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

local stName = "AutoEquipV2"
if not storage[stName] or type(storage[stName]) ~= "table" then
  storage[stName] = {
    enabled = false,
    sPanels = 6,
    sHeight = 610,
    sIcon = true,
    sIPX = 200,
    sIPY = 270,
    sTab = "Main",
    sHotkey = "End",
    sPz = true,
    sOldVersion = g_game.getClientVersion() < 800,
    items = {}
  }
end
local config = storage[stName]
setDefaultTab(config.sTab)
UI.Label("Hotkey: "..config.sHotkey):setFont('verdana-11px-rounded')

-- Bot Panel
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: main
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Auto Equipper')
    font: verdana-11px-rounded

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
    font: verdana-11px-rounded

]])

-- Main Window
g_ui.loadUIFromString([[
AE_MainWindow < MainWindow
  !text: tr('Auto Equipper HP/MP %% - By F.Almeida')
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
    font: verdana-11px-rounded
    
  Button
    id: info
    text: Credits
    font: cipsoftFont
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    size: 50 21
    color: yellow
    font: verdana-11px-rounded
    !tooltip: tr('Created by F.Almeida#8019\nClick to contribute.')
    @onClick: g_platform.openUrl("https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD")    

  Button
    id: settings
    !text: tr('Settings')
    anchors.left: info.right
    margin-left: 5 
    size: 65 21
    font: verdana-11px-rounded  
    anchors.verticalCenter: info.verticalCenter

  BotSwitch
    id: sPz
    !text: tr('Stop In PZ')
    anchors.left: settings.right
    margin-left: 5 
    size: 70 20
    font: verdana-11px-rounded  
    anchors.top: settings.top 
    margin-top: 1

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

-- Settings Window
g_ui.loadUIFromString([[
AES_CheckBox < CheckBox
  anchors.left: parent.left
  anchors.right: parent.right
  anchors.top: prev.bottom
  margin-top: 6

AES_Sep < HorizontalSeparator
  anchors.right: parent.right
  anchors.left: parent.left
  anchors.top: prev.bottom
  margin-top: 6

AE_SettingsWindow < MainWindow
  text: Auto Equipper Settings
  size: 230 320
  @onEscape: self:hide()

  Label
    !text: tr('Any changes made here require the bot to be restarted in order to take effect.')
    text-align: center
    text-wrap: true
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 40

  AES_Sep    

  AES_CheckBox
    id: sIcon
    text: Create Icon / Icon Position:

  Label
    anchors.left: prev.left
    anchors.top: prev.bottom
    text-align: center
    margin-top: 5
    width: 40
    height: 20
    !text: ('Pos X: ')

  SpinBox
    id: sIPX
    anchors.left: prev.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    minimum: 0
    maximum: 2000
    width: 50
    step: 10

  Label
    anchors.right: sIPY.left
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    text-align: center
    width: 40
    !text: ('Pos Y: ')

  SpinBox
    id: sIPY
    anchors.right: parent.right
    anchors.top: sIPX.top
    anchors.bottom: sIPX.bottom
    minimum: 0
    maximum: 2000
    width: 50
    step: 10

  AES_Sep

  Label
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 5
    height: 20
    text-align: center
    text: How Many Items Panels:

  SpinBox
    id: sPanels
    anchors.right: parent.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    minimum: 2
    maximum: 20
    width: 50
    step: 2
    text-align: center

  AES_Sep

  Label
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 5
    height: 20
    text-align: center
    text: Window Max Height:

  SpinBox
    id: sHeight
    anchors.right: parent.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    minimum: 300
    maximum: 610
    step: 10
    width: 50
    text-align: center  

  AES_Sep

  Label
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 5
    height: 20
    text-align: center
    text: Set Default Tab:

  BotTextEdit
    id: sTab
    width: 100
    anchors.right: parent.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    editable: true
    focusable: true
    text-align: center

  AES_Sep

  Label
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 5
    height: 20
    text-align: center
    text: Toggle Hotkey:

  BotTextEdit
    id: sHotkey
    width: 100
    anchors.right: parent.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    editable: true
    focusable: true
    text-align: center  

  AES_Sep

  AES_CheckBox
    id: sOldVersion
    text: Old Tibia (No Hotkeys)
    tooltip: Check it if you cannot equip items using hotkey, note: if checked, items must be visible
    
  AES_Sep

  Button
    id: closeButton
    text: Close
    font: verdana-11px-rounded
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 55 21
]])

-- Switch
ui.main:setOn(config.enabled)
ui.main.onClick = function(widget)
  config.enabled = not config.enabled
  broadcastMessage(config.enabled and "Auto-Equipper: ON" or "Auto-Equipper: OFF")
  widget:setOn(config.enabled)
end

-- Icon / Hotkey
if config.sIcon then
  local icon = addIcon("AutoEquipV2", {item = 3088, text="Auto\nEquip", hotkey=config.sHotkey, switchable=false}, 
  function(widget,isOn) ui.main.onClick(ui.main) end)
  -- Sadly we need this..
  macro(50,function()
    icon.text:setColor(config.enabled and "green" or "red")
    icon.item:setItemId(config.enabled and 3089 or 3100)
    ui.main:setOn(config.enabled)
  end)
  icon:setSize({height=60,width=40})
  icon:breakAnchors()
  icon:move(config.sIPX,config.sIPY)
  icon.hotkey:setText('')
  icon.text:setFont('verdana-11px-rounded')
else
  hotkey(config.sHotkey, function() 
    ui.main.onClick(ui.main)
  end)
end

-- UI Functions
rootWidget = g_ui.getRootWidget()
if rootWidget then
  -- Main Window
  AE_MainWindow = UI.createWindow('AE_MainWindow', rootWidget)
  AE_MainWindow:hide()
  AE_MainWindow.closeButton.onClick = function(widget)
    AE_MainWindow:hide()
  end

  -- Settings Window
  AE_SettingsWindow = UI.createWindow('AE_SettingsWindow', rootWidget)
  AE_SettingsWindow:hide()
  AE_SettingsWindow.closeButton.onClick = function(widget)
    AE_SettingsWindow:hide()
  end

  -- Close Buttons
  ui.edit.onClick = function(widget)
    AE_MainWindow:show()
    AE_MainWindow:raise()
    AE_MainWindow:focus()
  end
  AE_MainWindow.settings.onClick = function(widget)
    AE_SettingsWindow:show()
    AE_SettingsWindow:raise()
    AE_SettingsWindow:focus()
  end

  -- Settings
  -- Check Box / Create Icon
  AE_SettingsWindow.sIcon:setChecked(config.sIcon)
  AE_SettingsWindow.sIcon.onClick = function(widget)
    config.sIcon = not config.sIcon
    widget:setChecked(config.sIcon)
  end
  -- Old School Mode, no Hotkeys
  AE_SettingsWindow.sOldVersion:setChecked(config.sOldVersion)
  AE_SettingsWindow.sOldVersion.onClick = function(widget)
    config.sOldVersion = not config.sOldVersion
    widget:setChecked(config.sOldVersion)
  end

  -- Spin Box
  -- Icon Position
  AE_SettingsWindow.sIPX:setValue(config.sIPX)
  AE_SettingsWindow.sIPX:setStep(10)
  AE_SettingsWindow.sIPX.onValueChange = function(widget, value)
    config.sIPX = value
  end
  AE_SettingsWindow.sIPY:setValue(config.sIPY)
  AE_SettingsWindow.sIPY:setStep(10)
  AE_SettingsWindow.sIPY.onValueChange = function(widget, value)
    config.sIPY = value
  end
  -- Panels
  AE_SettingsWindow.sPanels:setValue(config.sPanels)
  AE_SettingsWindow.sPanels:setStep(2)
  AE_SettingsWindow.sPanels.onValueChange = function(widget, value)
    config.sPanels = value
  end
  -- Height
  AE_SettingsWindow.sHeight:setValue(config.sHeight)
  AE_SettingsWindow.sHeight:setStep(10)
  AE_SettingsWindow.sHeight.onValueChange = function(widget, value)
    config.sHeight = value
  end

  -- Text Edit
  -- Default Tab
  AE_SettingsWindow.sTab:setText(config.sTab)
  AE_SettingsWindow.sTab.onTextChange = function(widget, text)
    config.sTab = text
  end
  -- Hotkey
  AE_SettingsWindow.sHotkey:setText(config.sHotkey)
  AE_SettingsWindow.sHotkey.onTextChange = function(widget, text)
    config.sHotkey = text
  end

  -- Switch, stop in PZ
  AE_MainWindow.sPz:setOn(config.sPz)
  AE_MainWindow.sPz.onClick = function(widget)
    config.sPz = not config.sPz
    widget:setOn(config.sPz)
  end

  local maxH = (math.ceil(config.sPanels / 2)*133)+87
  AE_MainWindow:setHeight(maxH > config.sHeight and config.sHeight or maxH)

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

  for i=1,config.sPanels do
    local destUi = i % 2 == 0 and AE_MainWindow.content.right or AE_MainWindow.content.left
    if not config.items[i] then
      config.items[i] = {
        on = i == 1 and true or false, 
        title = "Equip", 
        item1 = i == 1 and 3052 or 0, 
        item2 = i == 1 and 3089 or 0, 
        slot = i == 9,
        unequip = i == 1 and true or false,
        title2 = "Unequip",
        HP = {      
          title="HP%",
          min=0,
          max=100},
        MP = {      
          title="MP%",
          min=0,
          max=i == 1 and 90 or 100},
      }
    end

    UI.Label("Item "..i,destUi)
    UI.TwoItems(config.items[i], function(widget, newParams)
      config.items[i] = newParams
    end,destUi)
    UI.DualScroll(config.items[i].HP, function(widget, newParams) 
      config.items[i].HP = newParams
    end,destUi)
    UI.DualScroll(config.items[i].MP, function(widget, newParams) 
      config.items[i].MP = newParams
    end,destUi)
    UI.Separator(destUi)
  end
end
-- End of UI Functions

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

local function unequipItem(slot)
  local item = getSlot(slot)
  if not item then return end
  if not config.sOldVersion then
    g_game.equipItemId(item:getId())
  else
    local dest
    for i, container in ipairs(g_game.getContainers()) do
      local cname = container:getName():lower()
      if container:getCapacity() > #container:getItems() and not cname:find("dead") and not cname:find("slain") and not cname:find("depot") and not cname:find("quiver") then
        dest = container
      end
      break
    end

    if not dest then
      return warn("[AutoEquipper] Open Backpack.")
    end
    local pos = dest:getSlotPosition(dest:getCapacity())
    g_game.move(item, pos, item:getCount())
  end
end

-- Main Loop
macro(50, function()
  if not config.enabled then return end
  local hp = player:getHealthPercent()
  local mp = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  for e, entry in ipairs(config.items) do
    if entry.on then
      local HPmin = entry.HP.min
      local HPmax = entry.HP.max
      local MPmin = entry.MP.min
      local MPmax = entry.MP.max
      local slotItem = getSlot(entry.slot)
      if config.sPz and isInPz() then
        if slotItem and (slotItem:getId() == entry.item1 or slotItem:getId() == entry.item2) then
          unequipItem(entry.slot)
          return delay(500)
        end
      elseif hp >= HPmin and hp <= HPmax and mp >= MPmin and mp <= MPmax then
        if not slotItem or (slotItem:getId() ~= entry.item1 and slotItem:getId() ~= entry.item2) then
          if config.sOldVersion then
            local item = findItem(entry.item1) or findItem(entry.item2)
            if item then
              g_game.move(item, {x=65535, y=entry.slot, z=0}, item:getCount())
              return delay(500)
            end
          else
            g_game.equipItemId(entry.item1)
            return delay(500)
          end
        end
      elseif entry.unequip and slotItem and (slotItem:getId() == entry.item1 or slotItem:getId() == entry.item2) then
        unequipItem(entry.slot)
        return delay(500)
      end
    end
  end
end)

UI.Separator()

-- Script feito por F.Almeida
-- Se foi útil pra você e quiser fazer uma doação:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=BRL